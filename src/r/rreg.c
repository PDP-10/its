# include "r.h"

/*

	R Text Formatter
	Register Hacking Routines

	Copyright (c) 1976, 1977 by Alan Snyder


	ROUTINES:

	nr_find (name) => b		is named number register defined?
	nr_enter (name, val)		define or redefine nr
	nr_undef (name)			make nr undefined
	nr_value (name) => value	get value of nr
	nr_incr (name) => value		increment nr, return new value
	nr_decr (name) => value		decrement nr, return new value
	und_nr (name)			print undefined nr error message
	bad_nr (name, val)		print bad value error message

	sr_find (name) => b		is named string register defined?
	sr_enter (name, val)		define or redefine sr
	sr_undef (name)			make sr undefined
	sr_value (name) => value	get value of sr
	und_sr (name)			print undefined sr error message
	reg_init ()			initialization routine

*/

/**********************************************************************

	Built-in Register Information

**********************************************************************/

/*	the following give UIDs for built-in registers		*/

# define r_page 0
# define r_even 1
# define r_lpt 2
# define r_xgp 3
# define r_pfont 4
# define r_font 5
# define r_vpos 6
# define r_hpos 7
# define r_vtrap 8
# define r_ll 9
# define r_pl 10
# define r_indent 11
# define r_rindent 12
# define r_month 13
# define r_day 14
# define r_year 15
# define r_ls 16
# define r_debug 17
# define r_next_page 18
# define r_spacing 19
# define r_printing 20
# define r_vplost 21
# define r_nargs 22
# define r_version 23
# define r_trace 24
# define r_fill 25
# define r_adjust 26
# define r_enabled 27
# define r_date 28
# define r_time 29
# define r_env 30
# define r_sdate 31
# define r_lineno 32
# define r_device 33
# define r_user 34
# define r_filename 35
# define r_fdate 36
# define r_ftime 37
# define r_stats 38
# define r_voff 39
# define r_habove 40
# define r_hbelow 41
# define r_fheight 42
# define r_varian 43
# define r_lvpu 44
# define r_interactive 45
# define r_cfilename 46
# define r_page_empty 47
# define r_fwidth 48
# define r_end_of_sentence 49

/*	The following must appear in the same order as the
	above UIDs.  They give the string names of the
	registers, plus the related register info.
*/

struct _rginfo {
	char	*name;
	int	info;
	};

# define rginfo struct _rginfo

rginfo rgtab[] {
	"page",		NRDEFINED+NRBUILTIN,
	"even",		NRDEFINED+NRBUILTIN,
	"lpt",		NRDEFINED+NRBUILTIN+NRFREEZE,
	"xgp",		NRDEFINED+NRBUILTIN+NRFREEZE,
	"pfont",	NRDEFINED+NRBUILTIN+NRFREEZE,
	"font",		NRDEFINED+NRBUILTIN+NRFREEZE,
	"vpos",		NRDEFINED+NRBUILTIN+NRFREEZE,
	"hpos",		NRDEFINED+NRBUILTIN+NRFREEZE,
	"vtrap",	NRDEFINED+NRBUILTIN+NRFREEZE,
	"ll",		NRDEFINED+NRBUILTIN+NRFREEZE,
	"pl",		NRDEFINED+NRBUILTIN+NRFREEZE,
	"indent",	NRDEFINED+NRBUILTIN+NRFREEZE,
	"rindent",	NRDEFINED+NRBUILTIN+NRFREEZE,
	"month",	NRDEFINED+NRBUILTIN,
	"day",		NRDEFINED+NRBUILTIN,
	"year",		NRDEFINED+NRBUILTIN,
	"ls",		NRDEFINED+NRBUILTIN+NRFREEZE,
	"debug",	NRDEFINED+NRBUILTIN,
	"next_page",	NRDEFINED+NRBUILTIN,
	"spacing",	NRDEFINED+NRBUILTIN,
	"printing",	NRDEFINED+NRBUILTIN,
	"vplost",	NRDEFINED+NRBUILTIN+NRFREEZE,
	"nargs",	NRDEFINED+NRBUILTIN,
	"version",	NRDEFINED+NRBUILTIN,
	"trace",	NRDEFINED+NRBUILTIN,
	"fill",		NRDEFINED+NRBUILTIN+NRFREEZE,
	"adjust",	NRDEFINED+NRBUILTIN+NRFREEZE,
	"enabled",	NRDEFINED+NRBUILTIN,
	"date",		SRDEFINED+SRBUILTIN,
	"time",		SRDEFINED+SRBUILTIN,
	"env",		SRDEFINED+SRBUILTIN+SRFREEZE,
	"sdate",	SRDEFINED+SRBUILTIN,
	"lineno",	SRDEFINED+SRBUILTIN,
	"device",	SRDEFINED+SRBUILTIN+SRFREEZE,
	"user",		SRDEFINED+SRBUILTIN,
	"filename",	SRDEFINED+SRBUILTIN,
	"fdate",	SRDEFINED+SRBUILTIN,
	"ftime",	SRDEFINED+SRBUILTIN,
	"stats",	NRDEFINED+NRBUILTIN,
	"voff",		NRDEFINED+NRBUILTIN+NRFREEZE,
	"habove",	NRDEFINED+NRBUILTIN+NRFREEZE,
	"hbelow",	NRDEFINED+NRBUILTIN+NRFREEZE,
	"fheight",	NRDEFINED+NRBUILTIN+NRFREEZE,
	"varian",	NRDEFINED+NRBUILTIN+NRFREEZE,
	"lvpu",		NRDEFINED+NRBUILTIN+NRFREEZE,
	"interactive",	NRDEFINED+NRBUILTIN,
	"cfilename",	SRDEFINED+SRBUILTIN,
	"page_empty",	NRDEFINED+NRBUILTIN,
	"fwidth",	NRDEFINED+NRBUILTIN+NRFREEZE,
	"end_of_sentence",	NRDEFINED+NRBUILTIN+NRFREEZE,
	0
	};

/*	The value tables hold a UID for built-in registers.	*/

int	n_vals [max_idn];		/* NR value table */
ac	s_vals [max_idn];		/* SR value table */

extern	int	page_number, device, vp, nvui, nhui, page_length,
		next_page_number, debug, nsmode, printing, vplost,
		verno, ftrace, line_length, frozen, traps_enabled,
		sflag, name_info[], rmonth, rday, ryear, lvpu,
		page_empty;
extern	env	*e;
extern	ac	date_ac, time_ac, sdate_ac, user_ac, filename_ac,
		fdate_ac, ftime_ac;
extern	idn	dev_tab[];

/**********************************************************************

	REG_INIT - Initialization Routine

**********************************************************************/

int	reg_init ()

	{register int i, info;
	char *name;
	idn x;

	for (i=0;i<max_idn;++i) name_info[i] = 0;
	i = 0;
	while (name = rgtab[i].name)
		{info = rgtab[i].info;
		x = make_idn (name);
		name_info[x] =| info;
		if (info & NRBUILTIN) n_vals[x] = i;
		if (info & SRBUILTIN) s_vals[x] = i;
		++i;
		}
	}

/**********************************************************************

	NR_FIND - Return 1 if number register defined;
		return -1 if number register is undefined.

**********************************************************************/

int	nr_find (name)	idn name;

	{return (name_info[name] & NRDEFINED ? 1 : -1);}

/**********************************************************************

	NR_ENTER - Define or redefine number register; set its value.

**********************************************************************/

nr_enter (name, val)	idn name;

	{int info;

	info = name_info[name];
	if (info & NRBUILTIN)
		{if (info & NRFREEZE) freeze;
		setbnr (name, val);
		}
	else
		{name_info[name] =| NRDEFINED;
		n_vals[name] = val;
		}
	}

/**********************************************************************

	SETBNR - Set value of built-in number register.

**********************************************************************/

setbnr (name, val)	idn name;

	{switch (n_vals[name]) {
	case r_page:	page_number = val;
			next_page_number = val+1; return;
	case r_pfont:	set_pfont (val); return;
	case r_font:	set_cfont (val); return;
	case r_hpos:	if (val < 0) goto bad;
			LineHPos (mil2hu (val));
			return;
	case r_vpos:	if (val < 0) goto bad;
			new_vp (mil2vu (val));
			return;
	case r_ll:	if (val <= 0) goto bad;
			line_length = mil2hu (val);
			return;
	case r_pl:	if (val <= 0) goto bad;
			page_length = mil2vu (val);
			return;
	case r_indent:	if (val < 0) goto bad;
			e->indent = mil2hu (val);
			return;
	case r_rindent:	if (val < 0) goto bad;
			e->right_indent = mil2hu (val);
			return;
	case r_ls:	if (val < 0) goto bad;
			e->line_spacing = val;
			return;
	case r_next_page:	next_page_number = val; return;
	case r_spacing:	if (val == 0) nsmode = 'n';
			else if (val == 1) nsmode = 's';
			else if (val == 2) nsmode = 'p';
			else goto bad;
			return;
	case r_printing:	printing = val; return;
	case r_trace:	if (val==1) trace_on ();
			else if (val==0) trace_off ();
			else goto bad;
			return;
	case r_fill:	if (val==0 || val==1) e->filling=val;
			else goto bad;
			return;
	case r_adjust:	if (val<0 || val>a_both) goto bad;
			if (e->filling) e->adjust_mode = val;
			else e->nofill_adjust_mode = val;
			return;
	case r_enabled:	traps_enabled = (val != 0); return;
	case r_stats:	sflag = (val != 0); return;
	case r_voff:	e->ivoff = mil2vu (val) - min_voff;
			chkvoff ();
			return;
	case r_lvpu:	lvpu = mil2vu (val); return;
	case r_page_empty:
			page_empty = (val != 0); return;
	case r_end_of_sentence:
			e->end_of_sentence = (val != 0);
			return;
	default:
	error ("attempt to redefine built-in number register '%s'",
			idn_string (name));
		}
	return;
bad:	bad_nr (name, val);
	}

/**********************************************************************

	NR_UNDEF - Make NR undefined.

**********************************************************************/

nr_undef (name)

	{name_info[name] =& ~(NRDEFINED+NRBUILTIN+NRFREEZE);
	}

/**********************************************************************

	NR_VALUE - Return value of number register.

**********************************************************************/

int	nr_value (name)	idn name;

	{int info;

	info = name_info[name];
	if (info & NRBUILTIN)
		{if (info & NRFREEZE) freeze;
		return (getbnr (name));
		}
	if (info & NRDEFINED) return (n_vals[name]);
	und_nr (name);
	nr_enter (name, 0);
	return (0);
	}

/**********************************************************************

	GETBNR - Get value of built-in number register.

**********************************************************************/

int	getbnr (name)	idn name;

	{switch (n_vals[name]) {

	case r_page:	return (page_number);
	case r_even:	return (!(page_number & 1));
	case r_lpt:	return (device == d_lpt);
	case r_xgp:	return (device == d_xgp);
	case r_pfont:	return (e->pfont);
	case r_font:	return (e->ifont);
	case r_vpos:	return (vu2mil (vp));
	case r_hpos:	return (hu2mil (e->hp));
	case r_vtrap:	return (vu2mil ((next_trap() - vp)));
	case r_ll:	return (hu2mil (line_length));
	case r_pl:	return (vu2mil (page_length));
	case r_indent:	return (hu2mil (e->indent));
	case r_rindent:	return (hu2mil (e->right_indent));
	case r_month:	return (rmonth);
	case r_day:	return (rday);
	case r_year:	return (ryear);
	case r_ls:	return (e->line_spacing);
	case r_debug:	return (debug);
	case r_next_page:	return (next_page_number);
	case r_spacing:	return (nsmode=='p' ? 2 : (nsmode=='s' ? 1 : 0));
	case r_printing:	return (printing);
	case r_vplost:	return (vu2mil (vplost));
	case r_nargs:	return (in_nargs ());
	case r_version:	return (verno);
	case r_trace:	return (ftrace >= 0);
	case r_fill:	return (e->filling);
	case r_adjust:	return (e->filling ? e->adjust_mode :
				e->nofill_adjust_mode);
	case r_enabled:	return (traps_enabled);
	case r_stats:	return (sflag);
	case r_voff:	return (vu2mil (e->ivoff + min_voff));
	case r_habove:	return (vu2mil (e->ha));
	case r_hbelow:	return (vu2mil (e->hb));
	case r_fheight:	return (vu2mil (e->default_height));
	case r_fwidth:	return (hu2mil (e->char_width));
	case r_varian:	return (device == d_varian);
	case r_lvpu:	return (vu2mil (lvpu));
	case r_interactive:
			return (interactive () != 0);
	case r_page_empty:
			return (page_empty);
	case r_end_of_sentence:
			return (e->end_of_sentence);
	default:	barf ("GETBNR: bad register name");
		}
	return (0);
	}

/**********************************************************************

	NR_INCR - Increment value of number register; return
		incremented value.

**********************************************************************/

int	nr_incr (name)	idn name;

	{int val;

	val = nr_value (name) + 1;
	nr_enter (name, val);
	return (val);
	}

/**********************************************************************

	NR_DECR - Decrement value of number register; return
		decremented value.

**********************************************************************/

int	nr_decr (name)	idn name;

	{int val;

	val = nr_value (name) - 1;
	nr_enter (name, val);
	return (val);
	}

/**********************************************************************

	UND_NR - Print undefined number register error message.

**********************************************************************/

und_nr (name)	idn name;

	{error ("undefined number register: '%s'", idn_string (name));
	}

/**********************************************************************

	BAD_NR - Print bad number register value error message.

**********************************************************************/

bad_nr (name, val)	idn name;

	{error ("bad value %d specified for built-in number register: '%s'",
		val, idn_string (name));
	}

/**********************************************************************

	SR_FIND - Return 1 if string register is defined;
		return -1 if string register is undefined.

**********************************************************************/

int	sr_find (name)	idn name;

	{return (name_info[name] & SRDEFINED ? 1 : -1);}

/**********************************************************************

	SR_ENTER - Define or redefine string register; set its value.
		(The value reference is moved, not copied.)

**********************************************************************/

sr_enter (name, val)	idn name; ac val;

	{int info;

	info = name_info[name];
	if (info & SRBUILTIN)
		{if (info & SRFREEZE) freeze;
		setbsr (name, val);
		}
	else
		{sr_undef (name);	/* throw away any old value */
		name_info[name] =| SRDEFINED;
		s_vals[name] = val;
		}
	}

/**********************************************************************

	SETBSR - Set value of built-in string register.

**********************************************************************/

setbsr (name, val)	idn name; ac val;

	{int uid;

	uid = s_vals[name];
	switch (uid) {

	case r_env:	get_env (make_ac_idn (val));
			ac_unlink (val);
			return;

	default:
		error ("attempt to redefine built-in string register '%s'",
			idn_string (name));
		ac_unlink (val);
		}
	}

/**********************************************************************

	SR_UNDEF - Make string register undefined.

**********************************************************************/

sr_undef (name) idn name;

	{register int info;

	info = name_info[name];
	if ((info & SRDEFINED) && !(info & SRBUILTIN))
		ac_unlink (s_vals[name]);
	name_info[name] =& ~(SRDEFINED+SRBUILTIN+SRFREEZE);
	s_vals[name] = 0;
	}

/**********************************************************************

	SR_VALUE - Return value of string register.

**********************************************************************/

ac	sr_value (name)	idn name;

	{ac s;
	int info;

	info = name_info[name];
	if (info & SRBUILTIN)
		{if (info & SRFREEZE) freeze;
		return (getbsr (name));
		}
	if (info & SRDEFINED) return (ac_link (s_vals[name]));
	und_sr (name);
	sr_enter (name, s = ac_new ());
	return (ac_link (s));
	}

/**********************************************************************

	GETBSR - Get value of built-in string register.

**********************************************************************/

ac	getbsr (name)	idn name;

	{int uid;

	uid = s_vals[name];
	switch (uid) {
		case r_date:	return (ac_link (date_ac));
		case r_time:	return (ac_link (time_ac));
		case r_env:	return (ac_create (idn_string (e->ename)));
		case r_sdate:	return (ac_link (sdate_ac));
		case r_lineno:	return (get_lineno ());
		case r_device:	return (ac_create (idn_string (dev_tab[device])));
		case r_user:	return (ac_link (user_ac));
		case r_filename:	return (ac_link (filename_ac));
		case r_fdate:	return (ac_link (fdate_ac));
		case r_ftime:	return (ac_link (ftime_ac));
		case r_cfilename:	return (getfilename ());

		default:	barf ("GETBSR: bad register name");
				return (ac_new ());
		}
	}

/**********************************************************************

	UND_SR - Print undefined string register error message.

**********************************************************************/

und_sr (name)	idn name;

	{error ("undefined string register: '%s'",
		idn_string (name));
	}

