# include "r.h"

/*

	R Text Formatter
	Lowest Level Input Routines

	Copyright (c) 1976, 1977 by Alan Snyder


	These routines handle multiple input sources.

	ROUTINES:

	set_map (c, d)		set mapping of input character
	unset_map (c)		remove mapping of input character
	d = get_map (c)		return mapping of input character
	getc1 ()		get next character
	getc_notrace ()		get next character, don't trace it
	getc_trace ()		get next character, trace it
	getc_file ()		get next character from file
	getc_char ()		get next character from character
	getc_string ()		get next character from string
	getc_ac ()		get next character from AC
	getc_macro ()		get next character from macro
	getc_peekc ()		get next character from PEEKC
	getc_eof ()		get next character after EOF
	push_file (f, s)	push file input source
	push_char (c)		push character input source
	push_string (s)		push string input source
	push_ac (s)		push array of chars input source
	push_macro (name, s, argv, n, dotflag)	push macro input source
	pop_icb ()		pop top input source
	pop_all ()		pop all input sources
	pop_file ()		pop innermost file input
	in_nargs ()		return number of macro args
	i = get_input_type ()	return current input type
	decrement_input_pos ()	decrement input position in macro
	set_exit (f)		set exit routine
	getfilename () => ac	return innermost file name
	get_lineno () => ac	get line number description
	trace_on ()		turn tracing on
	trace_off ()		turn tracing off
	in1_init ()		initialization routine

*/

# define _ignore -1	/* char should be ignored on input */
# define _newline -2	/* char indicates end of input line */

struct	_icb {
	int	type;		/* type of input source */
	char	*p;		/* current char ptr */
	ac	s;		/* for AC and MACRO input, also filename */
	int	val;		/* miscellaneous use */
	int	state;		/* old READER state or lineno */
	int	nlflag;		/* next char will be first of input line */
	idn	name;		/* name of macro */
	int	(*exit)();	/* routine to call on exit */
	};
# define icb struct _icb

ichar	(*pgetc)();		/* current getc routine */
ichar	getc_file(),getc_char(),getc_string(),getc_ac(),getc_macro(),
	getc_peekc(),getc_eof();
ichar	(*agetc[])()
	{getc_file,
	getc_char,
	getc_string,
	getc_ac,
	getc_macro,
	getc_peekc,
	getc_eof};

icb	istack[max_icb];
int	icblev {-1};
int	trlev {-1};		/* level last mentioned in trace */
int	exit_called {FALSE};	/* exit macro has been invoked */
int	exiting {FALSE};	/* indicates forced popping of inputs */
icb	*cicb;

/*
 *	The current ICB is kept in special variables for faster
 *	referencing.  They are kept in sync by PUSH_ICB and
 *	POP_ICB.  Variables I_P and I_VAL are read and modified
 *	by RCNTRL, which saves and restores position in macros.
 */

int	i_type, i_val, i_state, i_nlflag;
char	*i_p;
ac	i_s;
int	(*i_exit)();

int	peekc {-1};			/* lookahead character */
int	no_interpretation {FALSE};
		/* If TRUE, then ^Q, ^A, ^N, ^S, and ^K are not
		   interpreted.  This flag is used for
		   skipping statement bodies and for parsing \ */

ac	margs[max_icb][max_args];		/* macro arguments */
int	mdotflag[max_icb];			/* ^A. flag */
int	maclev {0};

int	ftrace {-1}, f2trace {-1}, etrace {-1}, e2trace {-1};

extern	int	state, in_mode, cin;
extern	long	Znchar;

/**********************************************************************

	The mapping from physical input characters to logical
	input characters which takes place upon input from files
	is represented in the following tables.  A physical input
	character C may be mapped to either a control character CC
	or the text character corresponding to C.  If the latter,
	then CC_MODE[C]==1000.  If the former, then CC_TAB[C]==CC
	and CC_MODE[C]== "that input mode needed to recognize CC."
	The mapping tables are maintained by the routines
	SET_MAP and UNSET_MAP.

**********************************************************************/

ichar	cc_tab[0200];
int	cc_mode[0200];
ichar	ec_tab[26];	/* EC_TAB maps escape sequences into ICHARs */

	/* CC_TYPE gives the type of each control character */

int	cc_type[0200] {
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	cc_universal /* SPACE */, 0, 0, 0, 0, 0, 0, cc_universal /* ^' */,
	0, 0, 0, 0, 0, 0, cc_universal /* ^. */, 0,
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	0, 0, 0, 0, 0, 0, 0, cc_separator /* ^G */, 0, 0, 0, 0, 0, 0, 0, 0,
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, cc_input /* ^\ */, 0, 0, 0,
	0,
	cc_input, 	/* ^a */
	cc_text,	/* ^b */
	cc_separator,	/* ^c */
	cc_text,	/* ^d */
	cc_text,	/* ^e */
	cc_text,	/* ^f */
	cc_separator,	/* ^g */
	cc_text,	/* ^h */
	cc_universal,	/* ^i */
	cc_universal,	/* ^j */
	cc_input,	/* ^k */
	0,		/* ^l */
	0, 		/* ^m */
	cc_input,	/* ^n */
	0,		/* ^o */
	cc_separator,	/* ^p */
	cc_input,	/* ^q */
	cc_separator,	/* ^r */
	cc_input,	/* ^s */
	cc_separator,	/* ^t */
	cc_text,	/* ^u */
	0,		/* ^v */
	cc_separator,	/* ^w */
	cc_separator,	/* ^x */
	0,		/* ^y */
	cc_text,	/* ^z */
	0, 0, 0, 0, 0};

/**********************************************************************

	IN1_INIT - Initialization Routine

**********************************************************************/

in1_init ()

	{register int i;

	/* initialization of CC_TAB and CC_MODE */

	for (i=1;i<=032;++i)	/* ^A thru ^Z */
		set_map (i, i+('a'-1));
	for (i=033;i<0200;++i)	/* ESC thru DEL */
		unset_map (i);
	unset_map (0);			/* NUL is text */
	set_map (' ', ' ');		/* SPACE char */
	set_map ('\\', '\\');		/* protect char */
	set_map ('.', '.');		/* request char */
	set_map ('\'', '\'');		/* no-break request char */

	/* special system-dependent hacks */

	cc_tab['\r'] = _ignore;
	cc_tab['\n'] = _newline;
	cc_tab['\014'] = _ignore;
	cc_mode['\r'] = cc_mode['\n'] = cc_mode['\014'] = 0;

	/* initialization of EC_TAB */

	for (i=0;i<26;++i) ec_tab[i] = _ignore;
	ec_tab ['n'-'a'] = ichar_cons (i_text, '\n');
	ec_tab ['r'-'a'] = ichar_cons (i_text, '\r');
	ec_tab ['p'-'a'] = ichar_cons (i_text, '\014');
	}

/**********************************************************************

	SET_MAP (C, D)

	Adjust the input mapping so that physical input character
	C maps to the control character designated by D.

**********************************************************************/

set_map (c, d)

	{int mode;

	if (c == '\r' || c == '\n' || c == '\014') return;
	switch (d) {
		case 'k':
		case 'i':
		case ' ':
		case '\\':
		case 'q':
		case 'a':
		case 'n':
		case 's':	mode = m_args; break;
		default:	mode = m_text; break;
		}

	cc_mode[c] = mode;
	cc_tab[c] = ichar_cons (i_control, d);
	}

/**********************************************************************

	UNSET_MAP (C)

	Adjust the input mapping so that the physical input
	character C maps to the corresponding text character.

**********************************************************************/

unset_map (c)

	{if (c == '\r' || c == '\n' || c == '\014') return;
	cc_mode[c] = 1000;
	cc_tab[c] = ichar_cons (i_text, c);
	}

/**********************************************************************

	D = GET_MAP (C)

	Returns the mapping of the physical input character C.
	If C is mapped to a control character, then the corresponding
	designator character is returned.  If C is mapped to the
	corresponding text input character, then -1 is returned.

**********************************************************************/

int get_map (c)

	{if (cc_mode[c] == 1000) return (-1);
	else return (ichar_val (cc_tab[c]));
	}

/**********************************************************************

	GETC1 - Lowest-Level Input Routine

	GETC1 returns the next logical input character, according to
	the current mode.  It handles multiple input sources and the
	recognition of R control characters.  The QUOTE control
	character is implemented by this routine, as is the backslash
	input conventions.

	GETC1 returns an ICHAR; ICHARs are described in a separate
	file.

	Peculiarities:  The mapping from the physical input alphabet to
	the logical input alphabet is performed only on FILE input.  In
	addition, the recognition of the . and ' control characters
	only occurs when the the physical input character begins an
	input line.  Also, ^K works only in file input.

	In strings, ACs, and MACROs, non-text characters are encoded.
	The encoding is as follows:

		control X	=> #x
		text #		=> #0
		n-protected ^X	=> #nx (n a digit char)

	Except that:

		control-space	=> SP
		text-space	=> # SP

	These encodings, and the particular decoding techniques
	used, imply that none of the following can be logical
	input characters:

		control-digit

	The input routines must guarantee that no such characters
	can be created.

	Knowledge of the encodings is also present in RFILE,
	RMISC, and RREQ3.

**********************************************************************/

# define getc_notrace() ((*agetc[i_type])())

ichar getc_trace ()
	{ichar ic;
	ic = (*agetc[i_type])();
	trace_input_type ();
	ichar_print (ic, ftrace);
	return (ic);
	}

ichar getc_peekc ()

	{i_type = cicb->type;
	if (ftrace<0) pgetc = agetc[i_type];
	else pgetc = getc_trace;
	return (peekc);
	}

ichar getc_eof ()
	{if (exit_called) return (ichar_cons (i_control, 0));
	exit_called = TRUE;
	push_char (i_newline);
	push_string ("exit_macro");
	push_char (i_quote);
	return (getc_notrace ());
	}

/**********************************************************************

	GETC_FILE - read from current file

**********************************************************************/

ichar getc_file ()

	{ichar	ic;
	int	c, onlflag, oin_mode, t;

	if ((c = cgetc (i_val)) <= 0 && ceof (i_val))
		{if (!i_nlflag) {i_nlflag = TRUE; return (i_newline);}
		pop_icb ();
		return (getc_notrace ());
		}

	++Znchar;
	if (i_nlflag)	/* at beginning of an input line */
		{onlflag = TRUE;
		i_nlflag = FALSE;
		++i_state;
		}
	else onlflag = FALSE;

	/* now recognize control characters */

	if (cc_mode[c] > in_mode) return (ichar_cons (i_text, c));

	/* must be a control character */

	ic = cc_tab[c];
	for (;;)		/* loop for backslash */
		{if (ic == _newline)
			{if (i_val==cin && onlflag)
				{pop_icb ();
				return (getc_notrace ());
				}
			i_nlflag = TRUE;
			return (i_newline);
			}
		if (ic == _ignore) return (getc_file ());
		if (ichar_type (ic) != i_control) return (ic);
		if ((t = cc_type[ichar_val (ic)]) < cc_universal)
			return (ic);

		/* the character is either universal or input */

		if (t == cc_universal) switch (ic) {

case i_space:	return (i_space);	/* here for efficiency */

case i_dot:
case i_quote:	if (!onlflag) return (ichar_cons (i_text, c));

default:	return (ic);
			}

		switch (ic) {

case i_comment:	if (no_interpretation) return (ic);
		while ((c = cgetc (i_val)) > 0 || !ceof (i_val))
			if (c == '\n')
				{i_nlflag = TRUE;
				if (!onlflag) return (i_newline);
				return (getc_file ());
				}
		pop_icb ();
		return (getc_notrace ());

case i_ctrl_q:	if (no_interpretation) return (ic);
		oin_mode = in_mode;
		in_mode = m_quote;
		ic = ichar_cons (i_text, getc_file ());
		in_mode = oin_mode;
		return (ic);

case i_ctrl_a:	if (no_interpretation) return (ic);
		insert_argument ();
		return (getc_notrace ());

case i_ctrl_s:	if (no_interpretation) return (ic);
		insert_string ();
		return (getc_notrace ());

case i_ctrl_n:	if (no_interpretation) return (ic);
		insert_number ();
		return (getc_notrace ());

case i_back:	ic = process_backslash (onlflag);
		continue;

default:	return (ic);
			}
		}
	}

/**********************************************************************

	PROCESS_BACKSLASH - Process an escape sequence from
		the current input file.

	ONLFLAG => the escape sequence begins an input line.

**********************************************************************/

ichar process_backslash (onlflag)

	{register int count, c, x;
	ichar ic;

	i_nlflag = onlflag;
	count = 1;
	while ((c = cgetc (i_val)) > 0 || !ceof (i_val))
		if (cc_tab[c] == i_back) ++count;
		else break;
	if (ceof (i_val))
		{error ("invalid use of \\: incomplete escape sequence");
		return (getc_file ());
		}
	x = chlower (c);
	if (x >= 'a' && x <= 'z')	/* make escape character */
		{ic = ec_tab[x-'a'];
		if (ic == _ignore)
			error ("escape sequence \\%c undefined", x);
		--count;
		}
	else
		{ungetc (c, i_val);
		++no_interpretation;
		ic = getc_file ();
		--no_interpretation;
		}
	return (protect (ic, count));
	}

/**********************************************************************

	PROTECT - protect a given ICHAR with N levels of protection

**********************************************************************/

ichar protect (ic, n)
	ichar ic;

	{if (n <= 0) return (ic);
	if (ichar_type (ic) != i_control)
	    {error ("invalid use of \\: not followed by letter or control character");
	    return (_ignore);
	    }
	return (ichar_cons (i_protect+n, ichar_val (ic)));
	}

/**********************************************************************

	UNPROTECT - remove 1 level of protection from a character

**********************************************************************/

ichar unprotect (ic)
	ichar ic;

	{register int t;
	t = ichar_type (ic);
	if (t > i_protect)
		{if (--t>i_protect) ic = ichar_cons (t, ichar_val (ic));
		else ic = ichar_cons (i_control, ichar_val (ic));
		}
	return (ic);
	}

/**********************************************************************

	GETC_CHAR - read current character

**********************************************************************/

ichar getc_char ()

	{ichar ic;

	ic = i_val;
	pop_icb ();
	return (ic);
	}

/**********************************************************************

	String, Arrays-of-Characters, and Macros require decoding.
	The DECODE_CHAR macro does the inline stuff; the DECODE_SHARP
	and DECODE_BACKSLASH functions do the special-case stuff
	out-of-line.

**********************************************************************/

# define decode_char(c) (c==' '?ichar_cons(i_control,' '):c=='#'?decode_sharp():ichar_cons(i_text,c))

ichar decode_sharp ()

	{register ichar ic;

	ic = getc_notrace ();
	if (ic == i_space) return (ichar_cons (i_text, ' '));
	if (ic>'0' && ic<='9')
		return (ichar_cons (i_protect + (ic - '0'), getc_notrace()));
	switch (ic) {
case '0':	return (ichar_cons (i_text, '#'));
case 'a':	if (no_interpretation) break;
		insert_argument ();
		return (getc_notrace ());
case 's':	if (no_interpretation) break;
		insert_string ();
		return (getc_notrace ());
case 'n':	if (no_interpretation) break;
		insert_number ();
		return (getc_notrace ());
		}
	return (ichar_cons (i_control, ic));
	}

/**********************************************************************

	GETC_STRING - read from current string

**********************************************************************/

ichar getc_string ()

	{int c;

	if (c = *i_p++)
		{++Znchar;
		return (decode_char (c));
		}
	pop_icb ();
	return (getc_notrace ());
	}

/**********************************************************************

	GETC_AC - read from current array-of-characters

**********************************************************************/

ichar getc_ac ()

	{int c;

	if (--i_val < 0)
		{pop_icb ();
		return (getc_notrace ());
		}
	++Znchar;
	c = *i_p++;
	return (decode_char (c));
	}

/**********************************************************************

	GETC_MACRO - read from current macro definition

**********************************************************************/

ichar getc_macro ()

	{int c;

	if (--i_val < 0)
		{pop_icb ();
		return (getc_notrace ());
		}
	++Znchar;
	c = *i_p++;
	return (decode_char (c));
	}

/**********************************************************************

	INPUT PUSH ROUTINES

**********************************************************************/

push_file (f, s)	/* S is not linked to */
	ac s;

	{push_icb (i_file, 0, s, f, 0);
	}

push_string (s) char s[];

	{push_icb (i_string, s, 0, 0, -1);
	}

push_ac (s) ac s;

	{int size;

	if (size = ac_size (s))
		push_icb (i_ac, ac_string (s), ac_link (s), size, -1);
	}

push_char (c)

	{int oc;

	if (i_type==i_peekc)
		{oc = peekc;
		i_type = cicb->type;
		push_icb (i_char, 0, 0, oc, -1);
		}
	cicb->type = i_type;
	i_type = i_peekc;
	pgetc = getc_peekc;
	peekc = c;
	}

push_macro (name, s, argv, n, dotflag)
	idn name;
	ac s;
	ac argv[];

	{int i, size;

	if (s && (size = ac_size (s)))
		{push_icb (i_macro, ac_string (s), ac_link (s), size, state);
		for (i=0;i<n;++i) margs[maclev][i] = argv[i];
		for (i=n;i<max_args;++i) margs[maclev][i] = 0;
		mdotflag[maclev] = dotflag;
		cicb->name = name;
		}
	}

/**********************************************************************

	PUSH_ICB - Internal Input Push Routine

**********************************************************************/

push_icb (type, p, s, val, st)	char *p; ac s;

	{int	c;

	if (val == 0 && (type==i_ac || type==i_macro)) return;
		/* don't want any null strings */

	if (type==i_macro) ++maclev;

	if (i_type==i_peekc)
		{c = peekc;
		i_type = cicb->type;
		push_icb (i_char, 0, 0, c, -1);
		if (ftrace>=0) pgetc = getc_trace;
		}

	if (icblev>=0)
		{cicb->type = i_type;
		cicb->p = i_p;
		cicb->s = i_s;
		cicb->val = i_val;
		cicb->state = i_state;
		cicb->nlflag = i_nlflag;
		cicb->exit = i_exit;
		}

	if (++icblev >= max_icb) fatal ("input stack overflow");
	cicb = &istack[icblev];
	i_type = type;
	i_p = p;
	i_s = s;
	i_val = val;
	i_state = st;
	i_nlflag = TRUE;
	i_exit = 0;
	if (ftrace<0) pgetc = agetc[i_type];
	}

/**********************************************************************

	POP_ICB - Pop Top Input Source

**********************************************************************/

pop_icb ()

	{int i;
	int (*exit)();
	ac s;

	if (i_type==i_peekc) i_type=cicb->type;
	else if (icblev>=0)
		{exit = i_exit;
		if (exit) (*exit)(icblev);
		if (i_type==i_ac || i_type==i_macro || i_type==i_file)
			{if (i_s) ac_unlink (i_s);}
		if (i_type==i_macro)
			{for (i=0;i<max_args;++i) if (s=margs[maclev][i])
				ac_unlink (s);
			--maclev;
			if (i_state >= 0) state = i_state;
			}
		if (i_type==i_file && i_val != cin) cclose (i_val);
		if (--icblev>=0)
			{cicb = &istack[icblev];
			trlev = -1;
			i_type = cicb->type;
			i_p = cicb->p;
			i_s = cicb->s;
			i_val = cicb->val;
			i_state = cicb->state;
			i_nlflag = cicb->nlflag;
			i_exit = cicb->exit;
			}
		else i_type = i_nomore;
		}
	if (ftrace<0) pgetc = agetc[i_type];
	else pgetc = getc_trace;
	}

/**********************************************************************

	POP_ALL - Pop all input sources.

**********************************************************************/

pop_all ()

	{++exiting;
	while (icblev>=0) pop_icb ();
	--exiting;
	}

/**********************************************************************

	POP_FILE - Pop the innermost file source.

**********************************************************************/

pop_file ()

	{int t;

	++exiting;
	while (icblev>=0)
		{t = i_type;
		pop_icb ();
		if (t == i_file) break;
		}
	--exiting;
	}

/**********************************************************************

	IN_NARGS - Return the number of arguments provided to
	the most recent macro invocation.

**********************************************************************/

int in_nargs ()

	{ac *mp;
	int i;

	mp = margs[maclev];
	for (i=0;i<max_args;++i) if (mp[i]==0) return (i);
	return (max_args);
	}

/**********************************************************************

	GET_INPUT_TYPE - return current input type

**********************************************************************/

int get_input_type () {return (i_type==i_peekc ? i_char : i_type);}

/**********************************************************************

	DECREMENT_INPUT_POS - decrement input position in macro
		Watch out for escape sequences.

**********************************************************************/

decrement_input_pos ()

	{int c;
	
	--i_p; ++i_val;
	c = i_p[-1];
	if (c=='#') {--i_p; ++i_val;}
	else if (c > '0' && c <= '9' && i_p[-1]=='#')
		{i_p =- 2; i_val =+ 2;}
	}

/**********************************************************************

	SET_EXIT - set exit routine

**********************************************************************/

set_exit (f)
	int (*f)();

	{i_exit = f;}

/**********************************************************************

	GETFILENAME - Return the innermost filename as AC

**********************************************************************/

ac getfilename ()

	{if (icblev >= 0)
		{register int i;
		if (i_type!=i_peekc) cicb->type = i_type;
		cicb->val = i_val;
		cicb->state = i_state;
		cicb->s = i_s;
		for (i=icblev;i>=0;--i)
			{register icb *p;
			p = &istack[i];
			if (p->type == i_file)
				{if (p->val != cin)
					return (ac_link (p->s));
				else return (ac_create ("TTY"));
				}
			}
		}
	return (ac_create ("EOF"));
	}

/**********************************************************************

	GET_LINENO - Return line number as AC

**********************************************************************/

ac get_lineno ()

	{char buf[500], *r, *s;
	int i, first;
	icb *p;

	if (icblev<0) s = "EOF";
	else
		{s = r = buf;
		first = TRUE;
		if (i_type!=i_peekc) cicb->type = i_type;
		cicb->val = i_val;
		cicb->state = i_state;
		cicb->s = i_s;
		for (i=0;i<=icblev;++i)
			{p = &istack[i];
			if (p->type == i_file)
				{if (!first) *r++ = ',';
				first = FALSE;
				if (p->val != cin)
					{r = a2a (ac_string(p->s), r);
					r = a2a (" (", r);
					r = i2a (p->state, r);
					*r++ = ')';
					}
				else r = a2a ("TTY", r);
				}
			else if (p->type == i_macro)
				{if (!first) *r++ = ',';
				first = FALSE;
				r = a2a (idn_string (p->name), r);
				}
			}
		*r = 0;
		}
	return (ac_create (s));
	}

/**********************************************************************

	TRACE_INPUT_TYPE - trace type of current input

**********************************************************************/

trace_input_type ()

	{int t;
	if (icblev != trlev)
		{switch (i_type) {
	case i_file:	t = 'F'; break;
	case i_char:	t = 'C'; break;
	case i_string:	t = 'S'; break;
	case i_ac:	t = 'A'; break;
	case i_macro:	t = 'M'; break;
	case i_peekc:	return;
	case i_nomore:	return;
	default:	t = '?'; break;
			}
		cprint (ftrace, "[%c]", t);
		trlev = icblev;
		}
	}

/**********************************************************************

	TRACE_ON - turn on tracing

**********************************************************************/

trace_on ()

	{pgetc = getc_trace;
	if (ftrace < 0)
		{if (etrace < 0) opentrace ();
		if (etrace < 0 || e2trace < 0)
			fatal ("unable to open trace files");
		ftrace = etrace;
		f2trace = e2trace;
		tprint ("TRACE ON\n");
		}
	}

/**********************************************************************

	TRACE_OFF - turn tracing off

**********************************************************************/

trace_off ()

	{pgetc = agetc[i_type];
	if (ftrace >= 0)
		{tprint ("\nTRACE OFF\n");
		ftrace = f2trace = -1;
		}
	}
