# include "r.h"

/*

	R Text Formatter
	Request Control

	Copyright (c) 1976, 1977 by Alan Snyder


	ROUTINES:

	find_env (name)		find an environment
	make_env (name)		make an uninitialized environment
	get_env (name)		set current environment
	copy_env (name)		make a copy of the current environment
	new_pfont ()		propagate new principle font
	set_current_font (i)	set current input font
	set_pfont (i)		set principal font
	perform_request (brk)
	def_com (name, routine)	define request
	getmd (name)		get macro definition (or 0)
	req1_init ()
*/

int	name_info [max_idn];

struct _ienv {
	int	old_line_spacing;
	int	old_indent;
	int	old_right_indent;
	int	old_adjust_mode;
	int	font_ring[FRSIZE];
	int	cfont;
	};

# define ienv struct _ienv

int	comtab[max_idn];		/* request and macro table */
int	frozen {FALSE};
idn	com {-1};			/* current request name */
					/* -1 if not in request routine */

ienv	*ie;
ienv	*oie;
ienv	*ienv_tab[max_env];

env	*env_tab[max_env];		/* table of environments */

extern	env	*e;
extern	int	page_number, page_started, vp, line_length,
		ec_tab[], in_mode, traps_enabled, f2trace, cout, vsp;

/**********************************************************************

	REQ1_INIT - Initialization Routine

**********************************************************************/

int	req1_init ()

	{register int i;
	extern	int und_com ();

	for (i=0;i<max_idn;++i) comtab[i] = und_com;
	for (i=0;i<max_env;++i) env_tab[i] = ienv_tab[i] = 0;
	}

/**********************************************************************

	FIND_ENV - Return index of named environment.
	Return -1 if no such environment.

**********************************************************************/

int find_env (name) idn name;

	{int i;
	env *ep;

	for (i=0;i<max_env;++i)
		if (ep = env_tab[i])
			if (ep->ename==name) return (i);
	return (-1);
	}

/**********************************************************************

	MAKE_ENV - Create a new uninitialized environment.
		Return its index.

**********************************************************************/

int make_env (name) idn name;

	{int i;

	if ((i = find_env (name)) >= 0)
		{barf ("MAKE_ENV: environment already exists");
		return (i);
		}

	for (i=0;i<max_env;++i)
		if (env_tab[i] == 0)
			{env_tab[i] = salloc (sizeof(*e)/sizeof(i));
			ienv_tab[i] = salloc (sizeof(*ie)/sizeof(i));
			env_tab[i]->ename = name;
			return (i);
			}

	fatal ("too many environments");
	}

/**********************************************************************

	EXPUNGE_ENV - Expunge environment

**********************************************************************/

expunge_env (name) idn name;

	{int i;

	if ((i = find_env (name)) < 0)
		{error ("no environment %s", idn_string (name));
		return;
		}

	if (e == env_tab[i])	/* environment is current */
		e->delflag = TRUE;
	else
		{extern env *old_env;
		if (old_env == env_tab[i]) old_env = 0;
		sfree (env_tab[i]);
		sfree (ienv_tab[i]);
		env_tab[i] = ienv_tab[i] = 0;
		}
	}

/**********************************************************************

	GET_ENV - Select Environment, Create If Necessary.

**********************************************************************/

env	*get_env (name)	idn name;

	{int i, j, flag;
	env *old_e;

	flag = FALSE;
	i = find_env (name);
	if (i == -1)		/* must create one */
		{i = make_env (name);
		flag = TRUE;
		}
	old_e = e;
	e = env_tab[i];
	ie = ienv_tab[i];
	if (old_e && old_e != e && old_e->delflag) expunge_env (old_e->ename);
	if (!flag) return (e);

	/* initialize the new environment */

	e->line_spacing = 100;
	e->indent = e->right_indent = e->partial_word = 0;
	e->adjust_mode = a_both;
	e->nofill_adjust_mode = a_left;
	e->filling = TRUE;
	e->temp_indent = -1;
	e->ivoff = -min_voff;
	e->rm = line_length;
	e->iul = e->text_seen = e->delflag = FALSE;
	e->tn = e->ha = e->hb = e->hp = e->pfont = e->ifont = 0;
	new_pfont ();
	for (j=0;j<max_tabs;++j) e->tab_stops[j] = j*8*e->char_width;

	ie->old_line_spacing = e->line_spacing;
	ie->old_indent = e->indent;
	ie->old_right_indent = e->right_indent;
	ie->old_adjust_mode = e->adjust_mode;
	for (j=0;j<FRSIZE;++j) ie->font_ring[j] = 0;
	ie->cfont = 0;
	return (e);
	}

/**********************************************************************

	COPY_ENV - Make a copy of the current environment

**********************************************************************/

copy_env (name)

	{int i, *p, *q, n;

	if (e->ename == name) return;
	i = find_env (name);
	if (i == -1) i = make_env (name);

	p = e;
	q = env_tab[i];
	n = sizeof(*e)/sizeof(i);
	while (--n >= 0) *q++ = *p++;

	p = ie;
	q = ienv_tab[i];
	n = sizeof(*ie)/sizeof(i);
	while (--n >= 0) *q++ = *p++;

	env_tab[i]->ename = name;	/* don't change name! */
	}

/**********************************************************************

	NEW_PFONT - Update ENV to reflect new PFONT

**********************************************************************/

new_pfont ()

	{register int f, i, j;

	f = e->pfont;
	e->default_height = font_ha (f) + font_hb (f) + vsp;
	i = e->space_width = font_width (f, ' ');
	j = font_width (f, '0');
	if (j > i) i = min (j, 2*i);
	e->char_width = i;
	}

/**********************************************************************

	SET_CURRENT_FONT - Set Current Input Font

	Set the current input font to the specified font number.
	If the given number is -1000, reset the current input font
	to the previous input font.  Emit an error message if the
	specified font does not exist.

**********************************************************************/

popfont ()

	{register int f;
	f = ie->font_ring[ie->cfont];
	if (--ie->cfont < 0) ie->cfont = FRSIZE-1;
	return (f);
	}

pushfont (n)

	{if (++ie->cfont >= FRSIZE) ie->cfont=0;
	ie->font_ring[ie->cfont] = n;
	}

set_cfont (n)

	{if (font_exists (n)) e->ifont = n;
	else error ("undefined font %x selected", n);
	}

set_pfont (n)

	{if (font_exists (n))
		{e->pfont = n;
		new_pfont ();
		}
	}

/**********************************************************************

	PERFORM_REQUEST

	Read request name and execute corresponding request routine.
	If at the beginning of an output page and the request will
	cause a line-break and traps are enabled, reset the world and
	do a NEW_VP to enable any header macros.

**********************************************************************/

perform_request (brk)

	{int	(*f)(), info;
	idn	lcom;
	ichar	ic;

	in_mode = m_args;
	if ((lcom = get_untraced_name ()) >= 0)
		{info = name_info[lcom];
		f = comtab[lcom];
		if ((info & RQBREAK) && brk)
			{freeze;
			if (!page_started && traps_enabled) /* headers */
				{push_char (i_space);
				push_string (idn_string (lcom));
				push_char (i_dot);
				new_vp (vp);	/* can invoke trap macro */
				return;
				}
			else if (e->text_seen)
				{push_char (i_space);
				push_string (idn_string (lcom));
				push_char (i_quote);
				LineBreak ();	/* can invoke trap macro */
				return;
				}
			}
		if (f2trace>=0)
			cprint (f2trace, "%i%s", brk ? i_dot : i_quote,
				idn_string (lcom));
		com = lcom;
		if (info & RQMACRO) mac_com (brk);
		else
			{if (info & RQFREEZE) freeze;
			if (info & RQTHAW) not_frozen;
			(*f)();		/* execute request routine */
			}
		com = -1;
		}
	in_mode = m_quote;
	while ((ic = getc2 ()) != i_newline && ic != i_eof);
	in_mode = m_text;
	if (lcom>=0) trace_character (i_newline);
	}

/**********************************************************************

	DEF_COM	- Define Command (Performed at Initialization Only)

**********************************************************************/

def_com (s, f, info)	char s[]; int (*f)();

	{idn	name;

	name = make_idn (s);
	comtab[name] = f;
	name_info[name] =| info;
	}

/**********************************************************************

	MAC_COM - Macro Command (Invoke macro COM)

**********************************************************************/

mac_com (brk)

	{ac	argv[max_args], s;
	int	argc;
	ichar	ic;

	argc = 0;
	in_mode = m_text;

	while ((ic = getc2 ()) != i_newline && ic!=i_eof)
		{if (is_separator (ic)) continue;
		trace_character (i_space);
		s = ac_new (); 
		if (ic == '"') 	while (TRUE)
			{trace_character ('"');
			while ((ic = getc2 ()) != '"' &&
				ic != i_eof && ic != i_newline)
					{trace_character (ic);
					append_char (s, ic);
					}
			trace_character (ic);
			if (ic != '"')
				error ("unterminated quoted macro argument");
			else
				{ic = getc2 ();
				if (ic == '"')
					{append_char (s, ic);
					continue;
					}
				}
			break;
			}
		else while (!is_terminator (ic))
			{trace_character (ic);
			append_char (s, ic);
			ic = getc2 ();
			}
		if (!is_separator (ic)) push_char (ic);	/* efficiency hack */
		if (argc<max_args) argv[argc++] = s;
			else ac_unlink (s);
		}

	push_macro (com, comtab[com], argv, argc, brk);
	push_char (ic);
	}

/**********************************************************************

	UND_COM - Undefined Command Routine

**********************************************************************/

und_com ()

	{error ("undefined request '%s'", idn_string (com));}

/**********************************************************************

	GETMD - Get macro definition.  Return 0 if none.

**********************************************************************/

ac getmd (name)	idn name;

	{if ((name_info[name] & RQMACRO) == 0) return (0);
	return (comtab[name]);
	}

/**********************************************************************

	TOOLATE - Emit error message

**********************************************************************/

toolate () {fatal ("too late for '%s' command", idn_string (com));}
