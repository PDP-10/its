# include "r.h"

/*

	R Text Formatter
	Top-Level Input Reader

	Copyright (c) 1976, 1977 by Alan Snyder


	ROUTINES:

	reader ()		top-level reader
	inline_macro ()		process inline macro invocation
	readpos ()		process ^P
	readvoff ()		process ^V
	readr_init ()		initialization routine

*/

int	state {0};		/* reader state:
				   0 - at beginning of line
				   1 - not at beginning of line
				 */
int	old_state;		/* state when current character read */

extern	env	*e;
extern	ac	rd_ac;
extern	int	frozen, page_started, vp, nhui, allow_neg, inparens,
		in_mode, f2trace, ftrace, gflag, cin, cc_type[],
		traps_enabled, icblev, wwval, nsmode, page_empty;

/**********************************************************************

	READR_INIT - Initialization Routine

**********************************************************************/

int	readr_init ()

	{;}

/**********************************************************************

	READER - Top Level Input Reader

**********************************************************************/

reader ()

	{LineReset ();
	while (TRUE)
		{int	v, it, i;
		ichar	ic;

		if (gflag)
			{push_file (cin, 0);
			gflag = FALSE;
			}

		v = ichar_val (ic = getc2 ());
		it = ichar_type (ic);

		if (it == i_control) switch (v) {

		case '.':
		case '\'':	perform_request (v == '.');
				continue;

		case 0:		DoEof ();
				if (icblev<0) return;
				continue;
				}
		freeze;
		if (!page_started && traps_enabled)
			{push_char (ic);
			new_vp (vp);	/* header macros not called too soon */
			continue;
			}

		old_state = state;
		state = 1;

		if (it == i_control && cc_type[v] >= cc_separator) switch (v) {

	case 'j':	/* newline */

     /*	A newline causes a line-break in nofill or centering mode.  In
	fill mode, it turns into a space, whose width is determined
	by whether the last token on the line is a text word
	and on the last character of that text word.  The effects
	of newline are inhibited if immediately following a ^G.	*/

			if ((e->partial_word & PWEATNL) == 0)
			    {state = 0;
			    if (e->ivoff > -min_voff)
				error ("input line contains unterminated superscripts");
			    else if (e->ivoff < -min_voff)
				error ("input line contains unterminated subscripts");
			    e->ivoff = -min_voff;
			    if (old_state == 0)
				{LineBreak ();
				if (nsmode == 'n') new_vp (vp+e->default_height);
				}
			    else if (!e->filling) LineBreak ();
			    else
				{i = 1;
				if (e->tn>0 &&
				    token_type(e->line_buf[e->tn-1])==t_text &&
				    e->end_of_sentence) i = 2;
				LineNLSpace (i*e->space_width);
				}
			    }
			else e->partial_word =& (~PWEATNL);
			trace_character (ic);
			continue;

	case ' ':	/* SPACE */

			trace_character (ic);
			if (old_state==0) LineBreak ();
			LineSpace (e->space_width);
			continue;

	case 'i':	/* TAB */

			trace_character (ic);
			if (old_state==0) LineBreak ();
			LineTab ();
			continue;

	case 'G':	/* internal GLUE -- don't trace */

			LineIGlue ();
			continue;

	case 'g':	/* GLUE */

			trace_character (ic);
			LineGlue ();
			continue;

	case 'w':	/* WORD BREAK */

			trace_character (ic);
			LineNull ();
			continue;

	case 'p':	/* POS */

			trace_character (ic);
			readpos ();
			continue;	

	case 'c':	/* CENTER */

			trace_character (ic);
			if (old_state == 0) LineBreak();
			LineCenter ();
			continue;

	case 'r':	/* RIGHT FLUSH */

			trace_character (ic);
			if (old_state == 0) LineBreak();
			LineRight ();
			continue;

	case 't':	/* SET TAB REPLACEMENT WORD */

			trace_character (ic);
			push_char (build_text_word (getc1 (), -1));
			LineTabc (wwval);
			continue;

	case 'x':	/* INLINE MACRO INVOCATION */

			trace_character (ic);
			inline_macro ();
			continue;
			}

		/* processing text */

		{word w;

			w = -1;
			if (e->partial_word)
				{token t;
				t = e->line_buf[e->tn-1];
				if (token_type (t) == t_text)
					{--e->tn;
					w = token_val (t);
					e->hp =- text_width (w);
					}
				e->partial_word = 0;
				}
			ic = build_text_word (ic, w);
			if (ic != i_space) push_char (ic);
				else trace_character (ic);
			LineText (wwval);
				/* may cause trap (sets state=0) */
			if (ic == i_space) LineSpace (e->space_width);
				/* efficiency hack */
			}
		}
	}

/**********************************************************************

	INLINE_MACRO - interpret inline macro invocation

**********************************************************************/

inline_macro ()

	{ac	argv[max_args];
	int	argc, level;
	idn	name;
	ichar	ic;

	in_mode = m_text;
	ac_flush (rd_ac);
	ic = getc2 ();
	while (alpha (ic))
		{ac_xh (rd_ac, ic);
		trace_character (ic);
		ic = getc2 ();
		}
	if (ac_size (rd_ac) == 0)
		{error ("name missing in inline macro invocation (^X)");
		return;
		}
	name = make_ac_idn (rd_ac);

	argc = 0;
	if (ic == '(')
		{trace_character (ic);
		while ((ic = getc2 ()) != i_eof)
			{ac s;
			if (ic == i_newline || ic == ')') break;
			if (is_separator (ic)) continue;
			s = ac_new ();
			level = 0;
			if (ic == '"') while (TRUE)
				{trace_character ('"');
				while ((ic = getc2 ()) != '"' &&
					ic != i_eof && ic != i_newline)
						{trace_character (ic);
						append_char (s, ic);
						}
				if (ic != '"')
					error ("unterminated quoted macro argument");
				else
					{ic = getc2 ();
					if (ic == '"')
						{trace_character (ic);
						append_char (s, ic);
						continue;
						}
					}
				break;
				}
			else while (ic != i_newline && ic != i_eof)
				{if (is_separator (ic) && level<=0) break;
				else if (ic == ')') {if (--level<0) break;}
				else if (ic == '(') ++level;
				trace_character (ic);
				append_char (s, ic);
				ic = getc2 ();
				}
			if (is_separator (ic)) trace_character (ic);
			else if (ic != ')') push_char (ic);
			if (argc<max_args) argv[argc++] = s;
				else ac_unlink (s);
			if (ic == ')') break;
			}
		if (ic == ')') trace_character (ic);
		else
			{error ("unterminated inline macro invocation (^X)");
			push_char (ic);
			}
		}
	else if (ic != '!') push_char (ic);
	if (name >= 0)
		{ac s;
		s = getmd (name);
		if (s==0)
			error ("macro %s undefined in inline macro invocation (^X)",
				idn_string (name));
		else
			{e->partial_word =| PWCONCAT;
			push_char (i_ictr_g);
			push_macro (name, s, argv, argc, 0);
			}
		}
	}

/**********************************************************************

	READPOS - process ^P

**********************************************************************/

readpos ()

	{if (getc2() == '(')
		{int i, oin_mode;
		oin_mode = in_mode;
		trace_character ('(');
		++inparens;
		i = get_hu (e->hp, 0);
		--inparens;
		trace_character (')');
		if (old_state==0) LineBreak ();
		LinePos (i);
		in_mode = oin_mode;
		}
	else error ("bad POS (^P) specification");
	}

/**********************************************************************

	READVOFF - Process ^V

**********************************************************************/

readvoff ()

	{if (getc2() == '(')
		{int oin_mode;
		oin_mode = in_mode;
		trace_character ('(');
		++allow_neg;
		++inparens;
		e->ivoff = (get_vu (0, e->ivoff+min_voff) - min_voff);
		--inparens;
		--allow_neg;
		trace_character (')');
		in_mode = oin_mode;
		}
	else error ("bad VOFF (^V) specification");
	}

/**********************************************************************

	DoEof

**********************************************************************/

DoEof ()

	{freeze;
	LineBreak ();
	if (!page_empty) new_page ();
	}

