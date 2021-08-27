# include "r.h"

/*

	R Text Formatter
	Main Program Section

	Copyright (c) 1976, 1977 by Alan Snyder

*/

env	*e {0};				/* current environment */

ac	date_ac,
	sdate_ac,
	time_ac,
	user_ac,
	filename_ac,
	fdate_ac,
	ftime_ac;

int	rmonth, rday, ryear;

# ifndef unix
char	version[5] {'X'};		/* R version name: patched later */
# endif
# ifdef unix
char	version[5] {'2', '9'};		/* for unix where patching is difficult */
# endif

int	verno;				/* R version number */
char	ofname[FNSIZE];			/* output file name buffer */
char	ifname[FNSIZE];			/* input file name buffer */

int	page_length {infinity};		/* in VU */
int	line_length {infinity};		/* in HU */
int	page_number {1};
int	next_page_number {2};
int	even_page_offset {0};		/* in HU */
int	odd_page_offset {0};		/* in HU */
int	current_page_offset;		/* according to page_number */
int	nsmode {'n'};			/* no-space mode */
int	in_mode {m_text};		/* input mode */

int	lvpu {0};			/* internal last vertical position used:
					   used to avoid overlap of subscripts and
					   superscripts */
int	vp {0};				/* VP is the vertical position to
					   be used for the baseline of the
					   next line to be output. */

int	page_empty {TRUE};	/* TRUE if no line yet output on page. */
int	page_started {FALSE};	/* TRUE if NEW_VP has been called on page.
				   TRUE => input text or break will
				   cause header macro to be invoked,
				   if traps are enabled */

int	traps_enabled {TRUE};	/* TRUE if traps are enabled */
int	temp;			/* used by MACRO definitions */
bits	btemp;			/* used by MACRO definitions */
int	gflag {FALSE};		/* indicates user ^G interrupt */

char	*fname {0};		/* input file name */
int	xargc;			/* program arg count */
char	**xargv;		/* program args */

char	*months[] {
	"January", "February", "March", "April", "May", "June",
	"July", "August", "September", "October", "November", "December"};

extern	int	etrace, frozen, cout, fout;

/*	options		*/

int	opt_dev {-1};			/* desired output device */
int	debug {FALSE};			/* (user) debug mode */
int	sflag {FALSE};			/* print statistics */
int	tflag {FALSE};			/* start up in trace mode */

/*	statistics	*/

long	Znchar {0};			/* number of input chars read */
int	Znpage {0};			/* number of pages written */
int	Zngc {0};			/* number of GCs */
int	Zngcw {0};			/* number of GC-moved words */
int	gc_time {0};
int	rstart {FALSE};			/* TRUE => program restared */

/**********************************************************************

	MAIN - Main Routine

**********************************************************************/

main (argc, argv)	int argc; char *argv[];

	{int	f, time;

	time = cputm ();
	xargc = --argc;
	xargv = ++argv;

	if (fname)	/* We have been restarted! */
		{rstart = TRUE;
		reinit ();
		}

# ifndef unix
	if (argc < 1)
		{cprint ("Usage: R input.file\n");
		return;
		}
# endif

	process_args (argc, argv);
	if (fname == 0)

# ifndef unix
		{cprint ("No file name given.\n");
		return;
		}
# endif
# ifdef unix
		{f = 0;
		filename_ac = ac_create ("tty");
		}
# endif

	else
		{f = openinput ();
		if (f==OPENLOSS)
			{cprint ("Unable to open %s.\n", fname);
			return;
			}
		filename_ac = ac_create (ifname);
		}
	if (!interactive ()) cprint ("%s:\n", ifname);
	init (f);			/* initialize the world */
	push_file (f, ac_link (filename_ac));	/* push input file */
	sethandler ();			/* set interrupt handler */
	reader ();			/* do it ! */
	freeze;				/* create output file if not yet done */
	leave_group (0);		/* check for unterminated blocks */
	fil_close ();			/* close any auxiliary output file */
	output_eof ();			/* do any needed output processing */
	ocls ();			/* close output file */
	dostat (time);			/* output statistics */
	}

/**********************************************************************

	PROCESS_ARGS - Process Command Arguments

**********************************************************************/

process_args (argc, argv) char **argv;

	{char *s, *is_eq();

	while (--argc >= 0)
		{s = *argv++;
		if (s[0] == '-') process_options (s+1);
		else if (!is_eq (s))
			{if (fname) cprint ("Extra file name given: %s\n", s);
			else fname = s;
			}
		}
	}

/**********************************************************************

	PROCESS_OPTIONS - Process an options string

**********************************************************************/

process_options (s) char *s;

	{if (s[1] == 0)
		{int c;
		c = chlower (s[0]);
		switch (c) {
	case 'd':	debug = TRUE; return;
	case 's':	sflag = TRUE; return;
	case 't':	tflag = TRUE; return;
			}
		if (devoption (c)) return;
		cprint ("Unrecognized command option: %s\n", s);
		}
	}

/**********************************************************************

	IS_EQ - Is the given string an equate?
		If it is, return a pointer to the character
		following the equal sign.  Otherwise, return 0.

**********************************************************************/

char *is_eq (s)
	char *s;

	{int c;

	while (c = *s++) if (c == '=') return (s);
	return (0);
	}

/**********************************************************************

	REINIT - Initialize on restart

**********************************************************************/

reinit ()

	{extern int icblev, trlev, peekc, ftrace, f2trace,
		etrace, e2trace, maclev;
	fname = 0;
	Znchar = 0;
	Znpage = Zngc = Zngcw = gc_time = 0;
	icblev = trlev = peekc = ftrace = f2trace = etrace = e2trace = -1;
	maclev = 0;
	}

/**********************************************************************

	INIT - Main Initialization

**********************************************************************/

init (f)

	{int ichar_print(), ac_puts(), phex();
	char *username();

	if (!rstart)
		{deffmt ('i', ichar_print, 1);	/* extend cprint formats */
		deffmt ('a', ac_puts, 1);
		deffmt ('x', phex, 1);
		setprompt ("r ");		/* set default TTY input prompt */
		verno = atoi (version);
		}
	user_ac = ac_create (username ());
	getfdates (f);
	getdates ();

	if (!rstart)
		{cntrl_init ();
		fil_init ();
		fonts_init ();
		idn_init ();
		in_init ();
		in1_init ();
		readr_init ();
		reg_init ();
		req1_init ();
		req2_init ();
		text_init ();
		dev_init ();	/* after idn init */
		}

	do_reginit (FALSE);
	if (tflag) trace_on ();
	}

/**********************************************************************

	HEADER - Perform Beginning of File Processing
		Now that things are frozen.

**********************************************************************/

header ()

	{extern	int device, nvui, nhui;
	int i;

	frozen = TRUE;
	if (opt_dev >= 0) device = opt_dev;
	if (device != d_lpt)
		{for (i=0;i<max_fonts;++i) read_font (i);
		if (!font_exists (0)) fatal ("font 0 undefined");
		}

	devsetup ();
	fout = openoutput ();
	devheader ();
	page_length = 11*nvui;
	even_page_offset = odd_page_offset = current_page_offset = 1*nhui;
	line_length = 6.5 * nhui;
	e = get_env (make_idn ("text"));
	do_reginit (TRUE);
	}

/**********************************************************************

	DO_REGINIT - Do Register Initializations

	If not FREEZERS, then do all but built-in freezing registers.
	If FREEZERS, do only built-in freezing registers.

**********************************************************************/

do_reginit (freezers)

	{int i;
	for (i=0;i<xargc;++i)
		{char *s, *r;
		s = xargv[i];
		if (r = is_eq (s))
			{idn name;
			ac a;
			r[-1] = 0;
			a = ac_create (s);
			name = make_ac_idn (a);
			ac_unlink (a);
			r[-1] = '=';
			if (name>=0)
				{extern int name_info[];
				int info;
				info = name_info[name];
				if (((info & NRFREEZE) != 0) == freezers)
					nr_enter (name, atoi (r));
				}
			}
		}
	}

/**********************************************************************

	GHANDLER - handler user ^G interrupt
	(will cause input to be taken from TTY at next
	command reading)

**********************************************************************/

ghandler ()

	{gflag = TRUE;}

/**********************************************************************

	DOSTAT - Do Statistics Hacking

**********************************************************************/

dostat (time)

	{int nsec, n100, rate, gc_1000, f;

	time = cputm () - time;
	nsec = time / 60;
	n100 = ((time % 60) * 100) / 60;
	rate = (Znchar * 60.0) / time;
	gc_1000 = (gc_time * 1000.) / time;
	f = openstat ();
	if (f != OPENLOSS)
		{cprint (f, "%2s  %s  %6s  %c%c",
			version, ac_string (sdate_ac), ac_string (user_ac),
			(etrace>=0 ? 'T' : ' '), (debug ? 'D' : ' '));
# ifdef unix
		printf (f, "%10ld", Znchar);
# endif
# ifndef unix
		cprint (f, "%10d", Znchar);
# endif
		cprint (f, "c%6dc/s %d.%d%%\t%s\n", rate,
			gc_1000/10, gc_1000%10, ofname);
		cclose (f);
		}
# ifdef unix
	printf ("%ld", Znchar);
# endif
# ifndef unix
	cprint ("%d", Znchar);
# endif

	cprint (" chars in %d.%d%d sec: %d char/s (%d.%d%% GC)\n",
		nsec, n100/10, n100%10, rate, gc_1000/10,
		gc_1000%10);
	if (sflag) pstat (cout);
	}

/**********************************************************************

	PSTAT - Print extra statistics

**********************************************************************/

pstat (f)

	{extern int name_info[], nidn;
	extern ac s_vals[], comtab[];
	extern env *env_tab[];
	extern int Zncspure, Zncsused, Zncsalloc;

	int nmacro, ncmacro, nnr, nsr, ncsr, nenv;
	int i, info, nvar, ngroup, nwfree, nwalloc, nblock;

	nmacro = ncmacro = nnr = nsr = ncsr = nenv = 0;
	for (i=0;i<nidn;++i)
		{info = name_info[i];
		if (info & RQMACRO)
			{++nmacro;
			ncmacro =+ ac_size(comtab[i]);
			}
		if ((info & NRDEFINED) && !(info & NRBUILTIN))
			++nnr;
		if ((info & SRDEFINED) && !(info & SRBUILTIN))
			{++nsr;
			ncsr =+ ac_size (s_vals[i]);
			}
		}
	for (i=0;i<max_env;++i)
		if (env_tab[i]) ++nenv;
	cntrl_stat (&nvar, &ngroup);

	cprint (f, "\nNames: %d/%d\n", nidn, max_idn);
	cprint (f, "Name storage: %d pure, %d used, %d allocated\n",
			Zncspure, Zncsused, Zncsalloc);
	cprint (f, "Macros: %d (%d characters)\n", nmacro, ncmacro);
	cprint (f, "User number registers: %d\n", nnr);
	cprint (f, "User string registers: %d (%d characters)\n",
			nsr, ncsr);
	cprint (f, "Environments: %d/%d\n", nenv, max_env);
	cprint (f, "Groups: %d/%d\n", ngroup, max_group);
	cprint (f, "Variables: %d/%d\n", nvar, max_var);
	cprint (f, "GC: %d times, %d avg. words moved\n",
			Zngc, Zngcw/Zngc);
	nwfree = alocstat (&nwalloc, &nblock);
	if (nwfree >= 0)
		{cprint (f, "Dynamic Storage: %d words used/%d words allocated\n",
			nwalloc-nwfree, nwalloc);
		cprint (f, "\t%d strings, %d free blocks\n", ac_n(), nblock);
		}
	cprint (f, "Pages Output: %d\n", Znpage);
	}
