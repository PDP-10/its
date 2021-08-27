# include "r.h"

/*

	R Text Formatter
	Request Handlers

	Copyright (c) 1976, 1977 by Alan Snyder

*/

struct _ienv {
	int	old_line_spacing;
	int	old_indent;
	int	old_right_indent;
	int	old_adjust_mode;
	int	old_pfont;
	int	old_ifont;
	};

# define ienv struct _ienv

extern	int	comtab[];		/* request and macro table */
extern	int	name_info[];

int	old_even_page_offset;
int	old_odd_page_offset;
int	old_line_length;

extern	ienv	*ie, *oie;

env	*old_env;

int	trt[0200];			/* translation table */

/*	device dependent	*/

int	nvui;				/* VU per inch */
int	nhui;				/* HU per inch */
int	dvpw;				/* device page width in HU */
int	dvpl;				/* device page length in VU */
int	vsp;				/* char height fudge factor in VU */

static	idn	em_idn;

extern	env	*e;
extern	int	page_number, next_page_number, line_length,
		vp, nsmode, in_mode,
		allow_neg, com, ulpos, uldpos, ulthick, uldthick,
		und_com ();
extern	ichar	ec_tab[];

/**********************************************************************

	BUILT-IN REQUEST INFO

**********************************************************************/

struct _rqinfo {
	char *name;
	int (*f)();
	int info;
	};
# define rqinfo struct _rqinfo
extern rqinfo rqtab[];

/**********************************************************************

	REQ2_INIT - Initialization Routine

**********************************************************************/

int	req2_init ()

	{register int i;
	rqinfo	*p;
	char	*name;

	for (i=0;i<0200;++i) trt[i] = i;
	em_idn = make_idn ("em");
	p = rqtab;
	while (name = p->name) {def_com (name, p->f, p->info); ++p;}
	}

/**********************************************************************

	REQUEST ROUTINES

**********************************************************************/

pl_com ()

	{extern	int	page_length;

	page_length = get_vu (11*nvui, page_length);
	}

bp_com ()

	{int n;
	n = get_int (07777, page_number);
	if (n != 07777) next_page_number = n;
	if (nsmode != 'p' || n != 07777) new_page ();
	}

pn_com ()

	{extern	int	next_page_number;
	int	i;

	i = get_int (-1000, page_number);
	if (i>=0) next_page_number = i;
	}

eo_com ()

	{extern	int	even_page_offset, current_page_offset;
	int	i;

	i = get_hu (old_even_page_offset, even_page_offset);
	old_even_page_offset = even_page_offset;
	even_page_offset = i;
	if ((page_number&1)==0) current_page_offset = even_page_offset;
	}

oo_com ()

	{extern	int	odd_page_offset, current_page_offset;
	int	i;

	i = get_hu (old_odd_page_offset, odd_page_offset);
	old_odd_page_offset = odd_page_offset;
	odd_page_offset = i;
	if (page_number&1) current_page_offset = odd_page_offset;
	}

ne_com ()

	{int d;

	d = get_vu (e->default_height, 0);
	if (next_trap()-vp < d) new_vp (vp+d);
	}

br_com ()

	{;}

bj_com ()

	{LineBrkjust ();}

fi_com ()

	{int mode;
	e->filling = TRUE;
	if ((mode = get_adjust (-1)) >= 0) e->adjust_mode = mode;
	}

nf_com ()

	{int mode;
	e->filling = FALSE;
	if ((mode = get_adjust (-1)) >= 0) e->nofill_adjust_mode = mode;
	}

ls_com ()

	{int	n;

	n = get_fixed (ie->old_line_spacing, e->line_spacing);
	if (n<0) error ("negative line spacing");
	else
		{ie->old_line_spacing = e->line_spacing;
		e->line_spacing = n;
		}
	}

sp_com ()

	{int d;
	d = get_vu (e->default_height, 0);
	if (nsmode == 'n') new_vp (vp+d);
	}

hp_com ()

	{LineHPos (get_hu (0, e->hp));
	}

hs_com ()

	{allow_neg = TRUE;
	LineOffset (get_hu (0, 0));
	allow_neg = FALSE;
	}

vp_com ()

	{new_vp (get_vu (0, 0));
	}

ns_com ()

	{extern	int	nsmode;
	int c;

	c = get_c ();
	switch (c) {

	case 's':
	case 'S':
	case -2:
	case ' ':	if (nsmode != 'p') nsmode = 's'; break;

	case 'p':
	case 'P':	nsmode = 'p'; break;

	default:	error ("unrecognized no-space mode '%c'", c);
		}
	}

rs_com ()

	{extern	int	nsmode;

	nsmode = 'n';
	}

ll_com ()

	{int	d;

	d = get_hu (old_line_length, line_length);
	old_line_length = line_length;
	line_length = d;
	}

in_com ()

	{int	d;

	d = get_hu (ie->old_indent, e->indent);
	ie->old_indent = e->indent;
	e->indent = d;
	}

ti_com ()

	{int	d;

	d = get_hu (e->char_width, e->indent);
	e->temp_indent = d;
	}

ir_com ()

	{int	d;

	d = get_hu (ie->old_right_indent, e->right_indent);
	ie->old_right_indent = e->right_indent;
	e->right_indent = d;
	}

eq_com ()

	{idn source, dest;
	int info;

	dest = get_name ();
	source = get_name ();
	if (source >= 0 && dest >= 0 && source != dest)
		{info = name_info[source] & RQBITS;
		name_info[dest] =& ~RQBITS;
		name_info[dest] =| info;
		if (info & RQMACRO) comtab[dest] = ac_link (comtab[source]);
		else comtab[dest] = comtab[source];
		}
	}

de_com ()

	{idn	name;	/* macro name */
	idn	term;	/* macro terminator */
	ac	s;	/* will hold macro definition */

	term = em_idn;
	name = get_name ();

	if (name>=0)
		{idn temp;
		temp = get_optional_name ();
		if (temp >= 0) term = temp;
		if (name_info[name] & RQMACRO) ac_unlink (comtab[name]);
		}
	s = ac_alloc (200);
	scan_macro_def (s, name, term);
	if (name>=0)
		{comtab[name] = ac_trim (s);
		name_info[name] =& ~RQBITS;
		name_info[name] =| RQMACRO;
		}
	else ac_unlink (s);
	}

am_com ()

	{idn	name;	/* macro name */
	idn	term;	/* macro terminator */
	ac	s;	/* will hold macro definition */

	term = em_idn;
	name = get_name ();
	if (name<0 || (name_info[name] & RQMACRO) == 0)
		s = ac_new ();
	else s = comtab[name];
	if (name >= 0)
		{idn temp;
		temp = get_optional_name ();
		if (temp >= 0) term = temp;
		}
	scan_macro_def (s, name, term);
	if (name>=0)
		{comtab[name] = s;
		name_info[name] =& ~RQBITS;
		name_info[name] =| RQMACRO;
		}
	else ac_unlink (s);
	}

rm_com ()

	{idn	name;	/* macro name */

	name = get_name ();
	if (name>=0 && (name_info[name] & RQMACRO))
		{ac_unlink (comtab[name]);
		comtab[name] = und_com;
		name_info[name] =& ~RQBITS;
		}
	}

st_com ()

	{idn	name;	/* macro name */
	int	v;	/* trap position */

	name = get_name ();
	v = get_vu (0, 0);
	if (name >= 0) add_trap (name, v);
	}

rt_com ()

	{idn	name;	/* macro name */
	int	v;	/* trap position (if specified) */

	name = get_name ();
	v = get_vu (-1, 0);
	if (name >= 0) rem_trap (name, v);
	}

ct_com ()

	{idn	name;	/* macro name */
	int	v;	/* new trap position */
	int	v1;	/* old trap position */

	name = get_name ();
	if (name >= 0)
		{if ((v1 = find_trap (name)) >= 0)
			{v = get_vu (0, v1);
			rem_trap (name, v1);
			add_trap (name, v);
			}
		else error ("no trap to macro '%s'", idn_string (name));
		}
	}

cc_com ()

	{int	d, c;

	d = get_c ();
	c = get_c ();
	if (c>=0 && d>=0) set_map (c, chlower (d));
	}

nc_com ()

	{int	c;

	c = get_c ();
	if (c>=0) unset_map (c);
	}

ec_com ()

	{int	c;
	ichar	ic;

	c = get_c ();
	if (c >= 0)
		{c = chlower (c);
		if (c >= 'a' && c <= 'z')
			{ic = get_l ();
			if (ic != -1) ec_tab [c - 'a'] = ic;
			else error ("second argument to EC request missing");
			}
		else error ("non-alphabetic escape character designator");
		}
	else error ("arguments to EC request missing");
	}

tr_com ()

	{register int c1, c2;

	c1 = get_c ();
	if (c1 >= 0)
		{c2 = get_c ();
		if (c2 < 0) c2 = ' ';
		trt[c1] = c2;
		}
	}

ev_com ()

	{idn	name;

	name = get_optional_name ();
	if (name >= 0)
		{old_env = e;
		oie = ie;
		get_env (name);
		}
	else if (name == -2)
		{if (old_env)
			{e = old_env;
			ie = oie;
			}
		}
	}

xe_com ()

	{idn	name;

	name = get_optional_name ();
	if (name == -1) return;
	if (name == -2) name = e->ename;
	expunge_env (name);
	}

es_com ()

	{idn name;

	name = get_name ();
	if (name >= 0) copy_env (name);
	}

ex_com ()

	{pop_all ();
	push_char (i_newline);
	}

ta_com ()

	{int i, h;

	for (i=0;i<max_tabs;++i)
		{h = get_hu (-1000, 0);
		if (h == -1000) break;
		e->tab_stops[i] = h;
		}
	while (i<max_tabs) e->tab_stops[i++] = -1;
	}

xc_com ()

	{ac s;
	ichar ic;

	s = ac_new ();
	append_char (s, i_dot);
	in_mode = m_text;
	ic = skip_blanks ();
	while (ic != i_newline && ic != i_eof)
		{append_char (s, ic);
		ic = getc2 ();
		}
	append_char (s, i_newline);
	push_ac (s);
	ac_unlink (s);
	push_char (ic);
	}

uo_com ()

	{allow_neg = TRUE;
	ulpos = get_vu (uldpos, 0);
	allow_neg = FALSE;
	}

ut_com ()

	{ulthick = get_vu (uldthick, 0);
	}

wf_com ()

	{fil_open (FALSE);
	}

wa_com ()

	{fil_open (TRUE);
	}

we_com ()

	{fil_close ();
	}

ws_com ()

	{ac s;

	s = get_string ();
	fil_write (s);
	ac_unlink (s);
	}

wl_com ()

	{ac s;

	s = get_string ();
	append_char (s, i_newline);
	fil_write (s);
	ac_unlink (s);
	}

wm_com ()

	{idn name;

	name = get_name ();
	if (name >= 0)
		{if (name_info[name] & RQMACRO)
			fil_write (comtab[name]);
		else error ("macro %s undefined", idn_string (name));
		}
	}

___com ()
 
	{;}

int	be_com(), bk_com(), ef_com(), en_com(), fr_com(), if_com(), wh_com();
int	sb_com(), sc_com(), si_com(), sl_com(), nr_com(), xn_com(), sr_com();
int	xs_com(), nd_com(), sd_com(), nv_com(), sv_com(), hx_com(), vx_com();
int	hv_com(), vv_com(), dv_com(), fo_com(), fs_com();
int	so_com(), nx_com(), tm_com(), rl_com(), rd_com();

rqinfo rqtab[] {
	"am",	am_com,		0,
	"be",	be_com,		0,
	"bj",	bj_com,		0,
	"bk",	bk_com,		0,
	"bp",	bp_com,		RQBREAK+RQFREEZE,
	"br",	br_com,		RQBREAK,
	"cc",	cc_com,		0,
	"ct",	ct_com,		RQFREEZE,
	"de",	de_com,		0,
	"dv",	dv_com,		RQTHAW,
	"ec",	ec_com,		0,
	"ef",	ef_com,		0,
	"em",	___com,		0,
	"en",	en_com,		0,
	"eo",	eo_com,		RQFREEZE,
	"eq",	eq_com,		0,
	"es",	es_com,		RQFREEZE,
	"ev",	ev_com,		RQFREEZE,
	"ex",	ex_com,		0,
	"fi",	fi_com,		RQBREAK+RQFREEZE,
	"fo",	fo_com,		RQTHAW,
	"fr",	fr_com,		0,
	"fs",	fs_com,		RQFREEZE,
	"hp",	hp_com,		RQFREEZE,
	"hs",	hs_com,		RQFREEZE,
	"hv",	hv_com,		RQFREEZE,
	"hx",	hx_com,		RQFREEZE,
	"if",	if_com,		0,
	"in",	in_com,		RQBREAK+RQFREEZE,
	"ir",	ir_com,		RQBREAK+RQFREEZE,
	"ll",	ll_com,		RQFREEZE,
	"ls",	ls_com,		RQFREEZE,
	"nc",	nc_com,		0,
	"nd",	nd_com,		0,
	"ne",	ne_com,		RQBREAK+RQFREEZE,
	"nf",	nf_com,		RQBREAK+RQFREEZE,
	"nr",	nr_com,		0,
	"ns",	ns_com,		0,
	"nv",	nv_com,		0,
	"nx",	nx_com,		0,
	"oo",	oo_com,		RQFREEZE,
	"pl",	pl_com,		RQFREEZE,
	"pn",	pn_com,		0,
	"rd",	rd_com,		0,
	"rl",	rl_com,		0,
	"rm",	rm_com,		0,
	"rs",	rs_com,		RQBREAK,
	"rt",	rt_com,		RQFREEZE,
	"sb",	sb_com,		0,
	"sc",	sc_com,		0,
	"sd",	sd_com,		0,
	"si",	si_com,		0,
	"sl",	sl_com,		0,
	"so",	so_com,		0,
	"sp",	sp_com,		RQBREAK+RQFREEZE,
	"sr",	sr_com,		0,
	"st",	st_com,		RQFREEZE,
	"sv",	sv_com,		0,
	"ta",	ta_com,		RQFREEZE,
	"ti",	ti_com,		RQBREAK+RQFREEZE,
	"tm",	tm_com,		0,
	"tr",	tr_com,		0,
	"uo",	uo_com,		RQFREEZE,
	"ut",	ut_com,		RQFREEZE,
	"vp",	vp_com,		RQBREAK+RQFREEZE,
	"vv",	vv_com,		RQFREEZE,
	"vx",	vx_com,		RQFREEZE,
	"wa",	wa_com,		0,
	"we",	we_com,		0,
	"wf",	wf_com,		0,
	"wh",	wh_com,		0,
	"wl",	wl_com,		0,
	"wm",	wm_com,		0,
	"ws",	ws_com,		0,
	"xc",	xc_com,		0,
	"xe",	xe_com,		RQFREEZE,
	"xn",	xn_com,		0,
	"xs",	xs_com,		0,
	"exit_macro",	___com,		0,
	0};

