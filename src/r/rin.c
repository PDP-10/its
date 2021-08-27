# include "r.h"

/*

	R Text Formatter
	Top-Level Input Routines

	Copyright (c) 1976, 1977 by Alan Snyder


	ROUTINES:

	get_name () => idn	read a name
	get_optional_name () => idn	read an optional name
	get_untraced_name () => idn	read an optional name (no trace2)
	get_hu (d, b) => int	read value in HU
	get_vu (d, b) => int	read value in VU
	get_int (d, b) => int	read integer
	get_fixed (d, b) => int	read value in 1/100ths
	get_c () => int		read text character
	get_l () => ic		read logical input char
	get_string () => ac	read string argument
	get_text () => ac	read text string argument
	get_adjust (def) => int	read adjustment mode
	get_font (def) => n	read font designator
	check_prefix ()		check for prefix
	check_next (s) => c	check validity of next char
	ic = skip_blanks ()	skip input spaces and tabs, return next char
	ic = skip_arg ()	skip until arg terminator
	in_init ()		initialization routine

*/

/**********************************************************************

	WARNING:  These routines use floating-point!  They expect
	the ROUND macro (or routine) to convert floating-point
	to integer by rounding.

**********************************************************************/

int	allow_neg {FALSE};	/* allow negative VX and HX */
int	inparens;		/* expression is in parens */
ac	rd_ac;			/* read temp ac */

extern	env	*e;
extern	int	frozen, nhui, nvui, in_mode, f2trace, ftrace,
		no_interpretation;

/**********************************************************************

	IN_INIT - Initialization Routine

**********************************************************************/

int	in_init ()

	{rd_ac = ac_alloc (40);
	}

/**********************************************************************

	GET_NAME - Read Name

	Name is assumed to begin with next non-SPACE input character and
	be immediately followed by a SPACE or a ^J.  Returns -1 if bad
	character in name or no name found.  An error message is
	produced if no name is found.

**********************************************************************/

idn	get_name ()

	{idn	name;		/* holds result */

	name = get_optional_name ();
	if (name == -2)
		{error ("name not found where expected");
		name = -1;
		}
	return (name);
	}

/**********************************************************************

	GET_OPTIONAL_NAME - Read Name (Optional)

	Name is assumed to begin with next non-SPACE input character and
	be immediately followed by a SPACE or a ^J.  Returns -1 if bad
	character in name, -2 if no name found.

**********************************************************************/

idn	get_optional_name ()

	{idn	name;

	name = get_untraced_name ();
	if (name >= 0 && f2trace >= 0)
		cprint (f2trace, " %s", idn_string (name));
	return (name);
	}

/**********************************************************************

	GET_UNTRACED_NAME - Read Name (Optional)

	Like GET_OPTIONAL_NAME except that there is no trace2 output.

**********************************************************************/

idn	get_untraced_name ()

	{ichar	ic;		/* current character */
	ichar	badc;		/* first bad character encountered */
	idn	name;		/* holds result */
	int	oin_mode;	/* to restore input mode */

	ac_flush (rd_ac);
	oin_mode = in_mode;
	in_mode = m_args;
	ic = skip_blanks ();
	if (ic == i_newline)	/* no name? */
		name = -2;
	else
		{while ((ic != i_eof) && alpha (ic))
			{ac_xh (rd_ac, ic);
			ic = getc2 ();
			}
		if (!is_terminator (ic))
			{badc = ic;
			ic = skip_arg ();
			if (!no_interpretation)	/* not skipping stmt body */
				error ("invalid character '%i' in name", badc);
			name = -1;
			}
		else name = make_ac_idn (rd_ac);
		}
	
	if (!is_separator (ic)) push_char (ic); /* efficiency hack */
	in_mode = oin_mode;
	return (name);
	}

/**********************************************************************

	GET_HU - Read value in Horizontal Units

**********************************************************************/

int	get_hu (def, base)

	{double	val;
	int	c, f, ival;

	f = check_prefix ();
	if (f==2) return (def);
	val = gete ();
	c = check_next ("IMC");
	switch (c) {
		case 'i':	val =* nhui; break;
		case 'm':	val =* nhui / 1000.; break;
		case 'c':	val =* nhui / 2.54; break;
		default:	val =* e->char_width;
		}
	if (f>0) val=base+val;
	 else if (f<0) val=base-val;
	ival = round (val);
	if (ival<0 && !allow_neg)
		{error ("negative horizontal distance specification");
		ival = 0;
		}
	trace_hu (ival);
	return (ival);
	}

/**********************************************************************

	GET_VU - Read Value in Vertical Units

**********************************************************************/

int	get_vu (def, base)

	{double	val;
	int	c, f, ival;

	f = check_prefix ();
	if (f==2) return (def);
	val = gete ();
	c = check_next ("IMCL");
	switch (c) {
		case 'i':	val =* nvui; break;
		case 'm':	val =* nvui / 1000.; break;
		case 'c':	val =* nvui / 2.54; break;
		case 'l':	val =* e->default_height * (e->line_spacing / 100.);
				break;
		default:	val =* e->default_height;
		}
	if (f>0) val = base+val;
	 else if (f<0) val = base-val;
	ival = round (val);
	if (ival<0 && !allow_neg)
		{error ("negative vertical distance specification");
		ival = 0;
		}
	trace_vu (ival);
	return (ival);
	}

/**********************************************************************

	GET_INT - Read Integer Expression Value

**********************************************************************/

int	get_int (def, base)

	{double	val;
	int f, ival;

	f = check_prefix ();
	if (f==2) return (def);
	val = gete ();
	check_next (0);
	if (f>0) val=base+val;
	 else if (f<0) val=base-val;
	ival = round (val);
	trace_int (ival);
	return (ival);
	}

/**********************************************************************

	GET_FIXED - Read Value in Hundredths

**********************************************************************/

int	get_fixed (def, base)

	{double	val;
	int f, ival;

	f = check_prefix ();
	if (f==2) return (def);
	val = gete () * 100.;
	check_next (0);
	if (f>0) val=base+val;
	 else if (f<0) val=base-val;
	ival = round (val);
	trace_fixed (ival);
	return (ival);
	}

/**********************************************************************

	GET_C - Read one text logical input character, return
		the character value.  Returns -1 if lossage, -2
		if ^J encountered.

**********************************************************************/

int	get_c ()

	{int	c, oin_mode;
	ichar	ic;

	oin_mode = in_mode;
	if (in_mode > m_args) in_mode = m_args;
	if ((ic = skip_blanks ()) == i_newline)
		{push_char (ic);
		c = -2;
		}
	else
		{trace_character (i_space);
		trace_character (ic);
		if (ichar_type (ic) != i_text)
			{error ("non-text character '%i' where text expected", ic);
			c = -1;
			}
		else c = ichar_val (ic);
		}
	in_mode = oin_mode;
	return (c);
	}

/**********************************************************************

	GET_L - Read one non-space non-^J logical input character,
		removing 1 level of protection.  Returns -1 if ^J found.

**********************************************************************/

ichar	get_l ()

	{int oin_mode;
	ichar	ic;

	oin_mode = in_mode;
	in_mode = m_text;
	if ((ic = skip_blanks ()) == i_newline)
		{push_char (ic);
		ic = -1;
		}
	else
		{trace_character (i_space);
		trace_character (ic);
		ic = unprotect (ic);
		}
	in_mode = oin_mode;
	return (ic);
	}

/**********************************************************************

	GET_STRING - Read String Argument

	The string is assumed to begin with the next non-SPACE input
	character and terminate with the next ^J, which is pushed back.

**********************************************************************/

ac	get_string ()

	{ac s;		/* holds the string */
	ichar	ic;	/* the current char */

	in_mode = m_text;
	s = ac_alloc (20);
	ic = skip_blanks ();
	trace_character (i_space);
	while (ic != i_newline && ic != i_eof)
		{trace_character (ic);
		append_char (s, ic);
		ic = getc2 ();
		}
	push_char (ic);
	return (s);
	}

/**********************************************************************

	GET_TEXT - Read Text String Argument

	The string is assumed to begin with the next non-SPACE input
	character and terminate with the next ^J, which is pushed
	back.  Non-text characters within the string are converted to
	text.  Return an ASCII string -- NOT ENCODED.

**********************************************************************/

ac	get_text ()

	{ac	s;	/* the string */
	ichar	ic;	/* the current char */
	int	val;	/* current character value */

	in_mode = m_args;
	s = ac_alloc (20);
	ic = skip_blanks ();
	trace_character (i_space);
	while (ic != i_newline && ic != i_eof)
		{trace_character (ic);
		if (ic==i_space) ic = ichar_cons (i_text, ' ');
		else if (ic==i_tab) ic = ichar_cons (i_text, '\t');
		val = ichar_val (ic);
		switch (ichar_type (ic)) {
	case i_text:	ac_xh (s, val); break;
	default:	{int t;
			t = ichar_type (ic) - i_protect;
			while (--t >= 0) ac_xh (s, '\\');
			}	/* fall through */
	case i_control:	ac_xh (s, '^');
			ac_xh (s, val);
			break;
			}
		ic = getc2 ();
		}
	push_char (ic);
	return (s);
	}

/**********************************************************************

	GET_ADJUST - read adjustment mode

**********************************************************************/

int get_adjust (def)

	{int c;

	if ((c = get_c ()) >= 0) switch (chlower (c)) {
	case 'l':	return (a_left);
	case 'r':	return (a_right);
	case 'n':	/* obsolete */
	case 'b':	return (a_both);
	case 'c':	return (a_center);
	default:	error ("unrecognized adjust mode '%c'", c);
			return (-1);
			}
	if (c == -2) return (def);
	return (-1);
	}

/**********************************************************************

	GET_FONT - read font designator

	Returns -1 in case of loss.

**********************************************************************/

int get_font (def)

	{int	oin_mode, f;
	ichar	ic;

	oin_mode = in_mode;
	in_mode = m_args;
	if ((ic = skip_blanks ()) == i_newline)
		{push_char (ic);
		return (def);
		}
	trace_character (i_space);
	trace_character (ic);
	in_mode = oin_mode;
	f = fontid (ic);
	if (f == -1) error ("invalid font specification: %i", ic);
	return (f);
	}

/**********************************************************************

	CHECK_PREFIX - Check next input characters for (1) the presence
	or absence of a +/- prefix, (2) the presence or absence of an
	argument.  Leading SPACEs are skipped if not INPARENS.  Return:

	-1	- prefix found (and eaten)
	0	no prefix (input reset)
	1	+ prefix found (and eaten)
	2	arg found to be missing (spaces eaten)

**********************************************************************/

int check_prefix ()

	{int	ic;

	in_mode = m_args;
	if (inparens) ic = getc2 ();
	else ic = skip_blanks ();
	if (ic=='+') return (1);
	if (ic=='-') return (-1);
	push_char (ic);
	if (ic==i_newline || ic==i_eof) return (2);
	return (0);
	}

/**********************************************************************

	CHECK_NEXT - The next input characters are processed and the
	input is advanced until the next character is either a newline,
	a NULL, or a SPACE or TAB.  If a SPACE or TAB, then the SPACE
	or TAB is eaten (unless tracing is on).

	If INPARENS, the input must match a ')', which is eaten.

	If no match set is given or a match set is given but the next
	input character does not match, an error message will be
	printed if the next character is not a space, a tab, a newline,
	or a NULL; the value returned will be 0.  If a match set is
	given and the next character is in that set, then it will be
	skipped and the following input treated as described above;
	the returned value will be the character that matched, in
	lower case.

**********************************************************************/

int	check_next (s)	char s[];

	{int	m, val;
	ichar	ic;

	ic = getc2 ();
	val = 0;
	if (s) while (m = *s++) if (ic == m || ic == chlower (m))
			{val = chlower (ic);
			ic = getc2 ();
			break;
			}
	if (inparens ? ic != ')' : !is_terminator(ic))
		{error ("invalid expression (bad character is '%i')", ic);
		if (inparens) return (val);
		ic = skip_arg ();
		}
	if (!inparens && (!is_separator(ic) || ftrace>=0)) push_char (ic);
		/* efficiency hack */
	return (val);
	}

/**********************************************************************

	SKIP_BLANKS - Skip Input Spaces and Tabs, Return Next Character

**********************************************************************/

ichar skip_blanks ()

	{ichar	ic;
	while (TRUE)
		{ic = getc2 ();
		if (!is_separator (ic)) return (ic);
		}
	}

/**********************************************************************

	SKIP_ARG - Skip until SPACE, TAB, NEWLINE, or EOF

**********************************************************************/

ichar skip_arg ()

	{ichar ic;

	in_mode = m_args;
	while (TRUE)
		{ic = getc1 ();
		if (is_terminator (ic)) return (ic);
		}
	}
