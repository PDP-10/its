# include "r.h"

/*

	R Text Formatter
	Miscellaneous Routines

	Copyright (c) 1976, 1977 by Alan Snyder


	ERROR ROUTINES:

	error (fmt, args...)	announce user error
	fatal (fmt, args...)	announce fatal user error
	barf (fmt, args...)	announce internal error
	bletch (fmt, args...)	announce fatal internal error
	eprint (fmt, args...)	print error message string
	eprint_lineno ()	print error line number

	OTHER ROUTINES:

	hp = next_tab (hp)	return next tab stop
	chkvoff ()		check for legitimate voff
	x = min (i, j)
	x = max (i, j)
	bool = alpha (c)	is character alphanumeric?
	ic = iclower (ic)	convert ichar to lower case
	c = chlower (c)		convert text to lower case
	append_char (s, c)	append "extended" char to string
	append_string (ac, s)	append C string to AC
	tprint (fmt, args...)	print tracing info
	scan_macro_def (s, name, term)
				scan macro definition
	phex (h, f, w)		print hexadecimal
	i = atoi (s)		convert string to integer
	i = current_adjust_mode ()	return current adjust mode
	i2al (n, c, s)		convert integer to alpha mode
	i2r (n, s)		convert integer to roman numerals
	i2sr (n, s)		convert integer to small romans
	i2a (n, s)		convert integer to ascii
	a2a (s, s)		move string

	unit conversion routines:

	i = mil2hu (i)		convert mils to HU
	i = mil2vu (i)		convert mils to VU
	i = hu2mil (i)		convert HU to mils
	i = vu2mil (i)		convert VU to mils

	trace support routines:

	tr_character (ic)
	tr_int (i)
	tr_hu (i)
	tr_vu (i)
	tr_fixed (i)

*/

extern	env	*e;
extern	int	in_mode, etrace, e2trace, ftrace, f2trace, cout;
extern	char	ctab[];
static	char	*bufp;

error (fmt, a1, a2, a3, a4, a5)

	{eprint_lineno ();
	eprint ("%s", ": ");
	eprint (fmt, a1, a2, a3, a4, a5);
	eprint ("\n");
	}

fatal (fmt, a1, a2, a3, a4, a5)

	{error (fmt, a1, a2, a3, a4, a5);
	cprint ("execution aborted");
	cexit (1);
	}

barf (fmt, a1, a2, a3, a4, a5)

	{eprint_lineno ();
	eprint ("%s", ": internal error in ");
	eprint (fmt, a1, a2, a3, a4, a5);
	eprint ("\n");
	if (etrace>=0) stkdmp (etrace);
	if (e2trace>=0) stkdmp (e2trace);
	stkdmp (cout);
	}

bletch (fmt, a1, a2, a3, a4, a5)

	{barf (fmt, a1, a2, a3, a4, a5);
	cprint ("execution aborted");
	cexit (2);
	}

eprint (fmt, a1, a2, a3, a4, a5)

	{cprint (fmt, a1, a2, a3, a4, a5);
	if (etrace>=0)
		cprint (etrace, fmt, a1, a2, a3, a4, a5);
	if (e2trace>=0)
		cprint (e2trace, fmt, a1, a2, a3, a4, a5);
	}

eprint_lineno ()

	{ac s;

	s = get_lineno ();
	ac_puts (s, cout);
	if (etrace>=0)
		{cprint (etrace, "\n *** ");
		ac_puts (s, etrace);
		}
	if (e2trace>=0)
		{cprint (e2trace, "\n *** ");
		ac_puts (s, e2trace);
		}
	ac_unlink (s);
	}

/**********************************************************************

	NEXT_TAB - Return horizontal position of next tab stop
		given current horizontal position.  Returns
		first tab stop >= HP + SPACE_WIDTH; if none,
		returns HP + SPACE_WIDTH.

**********************************************************************/

int next_tab (hp)

	{int i, l;

	hp =+ e->space_width;
	for (i=0;i<max_tabs;++i)
		{l = e->tab_stops[i];
		if (l == -1) return (hp);
		if (l >= hp) return (l);
		}
	return (hp);
	}

/**********************************************************************

	CHKVOFF

**********************************************************************/

chkvoff ()

	{register int v;

	v = e->ivoff;
	if (v > max_voff-min_voff)
		{error ("too much superscripting");
		e->ivoff = max_voff-min_voff;
		}
	else if (v < 0)
		{error ("too much subscripting");
		e->ivoff = 0;
		}
	}

/**********************************************************************

	MAX and MIN

**********************************************************************/

# ifndef USE_MACROS

int max (i, j)

	{return (i>=j ? i : j);
	}

int min (i, j)

	{return (i<=j ? i : j);
	}

# endif

/**********************************************************************

	ALPHA - Is character alphanumeric?

**********************************************************************/

# ifndef USE_MACROS

int alpha (ic)
	ichar ic;

	{return (!(ic&~0177) && ctab[ic]);}

# endif

/**********************************************************************

	ICLOWER - Convert arbitrary character to lower case

**********************************************************************/

ichar iclower (ic)
	ichar ic;

	{if (ichar_type (ic) == i_text)
		return (ichar_cons (i_text, chlower (ichar_val (ic))));
	return (ic);
	}

/**********************************************************************

	CHLOWER - Convert text character to lower case

**********************************************************************/

int chlower (c)

	{int x;
	if (x = ctab[c]) return (x);
	return (c);
	}

/**********************************************************************

	APPEND_CHAR - Append ICHAR onto string

	Protected characters are decremented here.

**********************************************************************/

append_char (s, ic)	ac s; ichar ic;

	{register int t, v;

	v = ichar_val (ic);
	switch (t = ichar_type (ic)) {

case i_text:	if (v == ' ') ac_xh (s, '#');
		ac_xh (s, v);
		if (v == '#') ac_xh (s, '0');
		return;

default:	/* protected control character */
		t =- i_protect;		/* number of quoting backslashes */
		--t;			/* remove 1 backslash */
		if (t > 0)		/* still protected?  */
			{ac_xh (s, '#');
			ac_xh (s, '0' + t);
			ac_xh (s, v);
			return;
			}
		/* otherwise, it's a normal control character */

case i_control:	if (v != ' ') ac_xh (s, '#');
		ac_xh (s, v);
		return;
		}
	}

/**********************************************************************

	APPEND_STRING

**********************************************************************/

append_string (s, r)
	ac s; char *r;

	{int c;

	while (c = *r++) append_char (s, c);
	}

/**********************************************************************

	TPRINT - print info on trace files

**********************************************************************/

tprint (fmt, a1, a2, a3, a4, a5)

	{if (ftrace>=0) cprint (ftrace, fmt, a1, a2, a3, a4, a5);
	if (f2trace>=0) cprint (f2trace, fmt, a1, a2, a3, a4, a5);
	}

/**********************************************************************

	SCAN_MACRO_DEF - Read in and return macro definition

 	This routine is assumed to be called by a request handler.
	Thus, the first thing it does is skip past the next newline
	character.  Then it continues reading until a line containing
	an invocation of the terminating macro is found.  When it
	returns normally, the next input character will be a newline.
	The NAME parameter is used only in the "unterminated macro
	definition" error message.  It may be -1.

**********************************************************************/

scan_macro_def (s, name, term)	ac s; idn name, term;

	{ichar	ic;		/* current char */
	char	*sterm;		/* terminating string */
	char	*p;		/* pointer into string for comparison */
	int	win;		/* boolean indicating success of comparison */
	int	nlflag;		/* boolean indicating last char was newline */
	int	first;		/* boolean to prevent extra newline trace */
	ichar	leader;		/* either ^. or ^' */

	sterm = idn_string (term);
	in_mode = m_quote;
	while ((ic = getc2 ()) != i_newline && ic != i_eof);
		/* skip end of request */
	trace_character (i_newline);

	nlflag = TRUE;
	first = TRUE;
	win = TRUE;

	in_mode = m_text;
	while (TRUE)
		{ic = getc2 ();
		if (nlflag)
			{if (ic == i_dot || ic == i_quote)
				{win = TRUE;
				leader = ic;
				p = sterm;
				}
			else
				{if (f2trace >= 0 && !first)
					trace_character (i_newline);
				win = FALSE;
				}
			}
		else if (win && !((p == sterm) && is_separator (ic)))
			{char next, *q;
			next = *p++;
			if (iclower (ic) != next || ic == i_eof)
				{if (next==0 && is_terminator (ic))
					{push_char (ic);
					push_string (sterm);
					push_char (leader);
					push_char (i_newline);
					return;
					}
				if (!first) trace_character (i_newline);
				append_char (s, leader);
				trace_character (leader);
				q = sterm;
				--p;
				while (q < p)
					{trace_character (*q);
					append_char (s, *q++);
					}
				win = FALSE;
				}
			}
		if (ic == i_eof) break;
		if (ic == i_newline)
			{nlflag = TRUE;
			first = FALSE;
			}
		else nlflag = FALSE;
		if (!win)
			{append_char (s, ic);
			if (ic != i_newline) trace_character (ic);
			}
		}
	push_char (i_newline);
	if (name >= 0)
	    error ("missing '.%s' to terminate definition of macro '%s'",
		sterm, idn_string (name));
	else error ("missing '.%s'", sterm);
	}

/**********************************************************************

	PHEX - Print hexadecimal digit

**********************************************************************/

phex (h, f, w)

	{if (h>=0 && h<=9) cputc ('0'+h, f);
	else if (h>=10 && h<=15) cputc (('A'-10)+h, f);
	else cputc ('?', f);
	}

/**********************************************************************

	ATOI - convert string to integer

**********************************************************************/

int atoi (s) char s[];

	{int i, f, c;
	
	if (!s) return (0);
	i = f = 0;
	if (*s == '-') {++s; ++f;}
	while ((c = *s++)>='0' && c<='9') i = i*10 + c-'0';
	return (f?-i:i);
	}

/**********************************************************************

	CURRENT_ADJUST_MODE - return current adjustment mode

**********************************************************************/

int current_adjust_mode ()

	{if (e->filling) return (e->adjust_mode);
	return (e->nofill_adjust_mode);
	}

/**********************************************************************

	I2AL - Convert number to alphabetics.

**********************************************************************/

char *i2al (n, c, buffer) char buffer[];

	{bufp = buffer;
	if (n==0) *bufp++ = '0';
	else
		{if (n<0) {*bufp++ = '-';  n = -n;}
		i2al1 (n-1, c);
		}
	*bufp = 0;
	return (bufp);
	}

i2al1 (n, c)

	{int i;

	i = n/26;
	if (i>0) i2al1 (i-1, c);
	*bufp++ = c + n%26;
	}

/**********************************************************************

	I2R - Convert Integer to Roman Numerals
	I2SR - Convert Integer to Small Roman Numerals

**********************************************************************/

char *i2r (val, buffer) char buffer[];

	{bufp = buffer;
	if (val==0) *bufp++ = '0';
	else
		{if (val<0) {val = -val; *bufp++ = '-';}
		i2r1 (val, "IXCM", "VLD");
		}
	*bufp = 0;
	return (bufp);
	}

char *i2sr (val, buffer) char buffer[];

	{bufp = buffer;
	if (val==0) *bufp++ = '0';
	else
		{if (val<0) {val = -val; *bufp++ = '-';}
		i2r1 (val, "ixcm", "vld");
		}
	*bufp = 0;
	return (bufp);
	}

i2r1 (val, p1, p5) char *p1, *p5;

	{int q, r;

	q = val/10;
	r = val%10;
	if (q > 0) i2r1 (q, p1+1, p5+1);
	if (r > 0)
		{q = r/5;
		r = r%5;
		if (r==4)
			{*bufp++ = *p1;
			if (q==0) *bufp++ = *p5;
			else *bufp++ = p1[1];
			}
		else
			{if (q>0) *bufp++ = *p5;
			while (--r >= 0) *bufp++ = *p1;
			}
		}
	}

/**********************************************************************

	I2A - Convert integer to ASCII

**********************************************************************/

char *i2a (n, buffer) char buffer[];

	{bufp = buffer;
	if (n==0) *bufp++ = '0';
	else
		{if (n<0) {*bufp++ = '-';  n = -n;}
		i2a1 (n);
		}
	*bufp = 0;
	return (bufp);
	}

i2a1 (n)

	{int i;

	i = n/10;
	if (i>0) i2a1 (i);
	*bufp++ = '0' + n%10;
	}

/**********************************************************************

	MOVE STRING

**********************************************************************/

char *a2a (s, d) register char *s, *d;

	{while (*d++ = *s++);
	return (--d);
	}

/**********************************************************************

	CONVERSION BETWEEN HU, VU AND MILS.

**********************************************************************/

extern int nhui, nvui;
int mil2hu (val) {return (round ((val / 1000.) * nhui));}
int mil2vu (val) {return (round ((val / 1000.) * nvui));}
int hu2mil (val) {return (round ((val * 1000.) / nhui));}
int vu2mil (val) {return (round ((val * 1000.) / nvui));}

/**********************************************************************

	TRACE SUPPORT ROUTINES

**********************************************************************/

tr_character (ic) {ichar_print (ic, f2trace);}
tr_int (i) {cputc (' ', f2trace); tr_iint (i);}
tr_iint (i) {cprint (f2trace, "%d", i);}
tr_hu (i) {tr_int (hu2mil (i)); cputc ('m', f2trace);}
tr_vu (i) {tr_int (vu2mil (i)); cputc ('m', f2trace);}
tr_fixed (i)
	{tr_int (i/100);
	cputc ('.', f2trace);
	tr_iint ((i%100)/10);
	tr_iint (i%10);
	}
