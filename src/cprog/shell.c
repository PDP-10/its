# include "c/c.defs"
# include "c/its.bits"

/* sizes */

# define max_args 20	/* maximum number of args to built-in command */
# define arg_size 200	/* maximum number of chars in command args */
# define max_files 30	/* maximum number of input files */
# define max_dirs 10	/* maximum number of search directories */
# define max_jobs 8	/* maximum number of inferior jobs */

/* directory list modes */

# define ls_long 01	/* long form */
# define ls_new 02	/* new entries only */
# define ls_dirdev 04	/* dirdev form (real long) */

/* some useful SIXBIT quantities */

# define _FILE_    0164651544516	/* .FILE. */
# define _PDIRP_   0104451621100	/* (DIR) */
# define _TS_      0646300000000
# define _ZZ_      0727200000000
# define _GREATER_ 0360000000000	/* > */
# define _LESS_    0340000000000
# define _ERR_     0456262000000
# define _TTY_     0646471000000
# define _TPL_     0646054000000
# define _XGP_     0704760000000
# define _DSK_     0446353000000
# define _SYS_     0637163000000
# define _SYS1_    0637163210000
# define _SYS2_    0637163220000
# define _DIR_     0445162000000
# define _NAME1_   0564155452100
# define _UP_      0656000000000
# define _SHELL_   0635045545400
# define _SHELL0_  0635045545420

/*	special input types		*/

# define VALINPUT -2
# define TTYINPUT -1

/*	some control characters		*/

# define BELL 007
# define CTLG 007
# define CTLQ 021
# define CTLS 023
# define CTLV 026
# define CTLW 027
# define CTLZ 032
# define ESC 033

# define _TBINT 0100000000000
# define _TBWAT 0040000000000
# define _TBOUT 0004000000000
# define _TBINF 0002000000000

# rename jnames "JOBNAM"
# rename jxnames "JOBXNM"

extern int jnames [], jxnames [], cin, cout, cerr, cerrno;
int cur_job -1, sflag, ttyflg;

/* ring buffer of jobs */

# define ring struct _ring
ring {int jobno; ring *next;};

ring cjring[max_jobs+1];
ring *cjrhead {cjring};	/* points to first job in ring */
ring *cjrtail {cjring};	/* points to first free slot in ring */

int nfdir [max_dirs] {
	_SYS_, _SYS1_, _SYS2_};
int nfcnt 3;
int instk [max_files], incnt 1, infile;
char *inval [max_files];
char *inpts [max_files], *inptr;

char jcl_buf[arg_size];	/* command buffer */
char *jcl;		/* command argument string */
int argc;		/* # of arguments to built-in commands */
char *argv[max_args];	/* parsed args to built-in commands */
tag restart;		/* restart loc for ^G interrupt */

static int default_device _DSK_;

struct _command {
	char *name;		/* command name */
	int (*f)();		/* command routine */
	char *desc;		/* command description */
	};
# define command struct _command

command comtab[] {
	"con",		_con,		"continue job",
	"jobs",		_jobs,		"list jobs",
	"job",		_job,		"change current job",
	"kill",		_kill,		"kill job",
	"pro",		_pro,		"proceed job",
	"protty",	_protty,	"proceed job, allow typeout",
	"stop",		_stop,		"stop job",
	"own",		_own,		"reown job",
	"disown",	_disown,	"disown job",
	"forget",	_forget,	"forget job",
	"ls",		_ls,		"list directory",
	"cat",		_cat,		"print files",
	"lpr",		_lpr,		"print files on line printer",
	"rm",		_rm,		"remove (delete) files",
	"mv",		_mv,		"move (rename) file",
	"ln",		_ln,		"add link to file",
	"df",		_df,		"print disk free space",
	"nfdir",	_nfdir,		"specify new search directories",
	"ofdir",	_ofdir,		"remove search directories",
	"chdir",	_chdir,		"change working directory",
	"tranad",	_tranad,	"add filename translations",
	"sfauth",	_sfauth,	"set file author",
	"pwd",		_pwd,		"print working directory",
	"xfile",	_xfile,		"execute command file",
	"echo",		_echo,		"echo arguments",
	"ttyoff",	_toff,		"suppress typeout",
	"ttyon",	_ton,		"unsuppress typeout",
	"newtty",	_newtty,	"recompute tty type",
	"clear",	_clear,		"clear screen",
	"login",	_login,		"change user name",
	"detach",	_detach,	"detach job tree",
	"attach",	_attach,	"replace SHELL with job",
	"snarf",	_snarf,		"snarf inferior from dead job",
	"vk",		_vk,		0,
	"?",		_help,		0,
	"contin",	_con,		0,
	"continue",	_con,		0,
	"procee",	_pro,		0,
	"proceed",	_pro,		0,
	"proced",	_pro,		0,
	0};

int g2s;
shandler ()
	{sflag = TRUE;
	reset (tyoopn ());
	}
ghandler ()
	{if (g2s>0)
		{--g2s;
		return (shandler ());
		}
	pos0 ();
	gotag (&restart);
	}
dhandler ()
	{int st[7], minutes, seconds;
	sstatus (st);
	seconds = st[0];
	if (seconds == -1) shout ("system revived!");
	else if (seconds == -2) shout ("system down!");
	else
		{int ch;
		char buf[1000];
		buf[0] = 0;
		seconds =/ 30;
		minutes = seconds/60;
		seconds =% 60;
		ch = fopen ("sys:down mail", 0);
		if (ch >= 0)
			{char *s;
			int n, c;
			n = 990;
			s = buf;
			while (--n >= 0 && ((c = uiiot (ch)) >= 0))
				if (c > 3) *s++ = c;
			*s = 0;
			close (ch);
			}
		shout ("system going down in %d:%d\r%s",
			minutes, seconds, buf);
		}
	}

shout (fmt, a1, a2, a3)

	{if (j_grab_tty ()==0)
		{char buf[200];
		int f;
		ttybclear (-1, _TBINF);
		f = copen (buf, 'w', "s");
		cputc (07, f);
		cputc (' ', f);
		cputc (' ', f);
		cprint (f, fmt, a1, a2, a3);
		cclose (f);
		spctty ('S');
		spctty ('T');
		spctty ('L');
		tyos (buf);
		spctty ('R');
		ttybset (-1, _TBINF);
		j_retn_tty ();
		}
	}

/* handler for obscure interrupts */

int loss;
int loser ()

	{loss = TRUE;
	setpc (getpc()+1);
	}

/* handler for job status changes */

int jchandler (j, s)

	{char *job_name();
	if (s== -2) shout ("job %s finished", job_name (j));
	else if (s & PJTTY) shout ("job %s wants the TTY", job_name (j));
	else if (s > 0) shout ("job %s needs help", job_name (j));
	}

main (ac, av)	int ac; char *av[];

	{char *pname, *p;
	int c, n, tty, prfs(), pr6();

	setnam ();
	deffmt ('f', prfs, 1);
	deffmt ('x', pr6, 1);

	on (ioc_interrupt, 1);
	on (ctrlg_interrupt, 1);
	on (ctrls_interrupt, shandler);
	on (sys_down_interrupt, dhandler);
	j_onchange (jchandler);

	for (n=0;n<=max_jobs;++n)
		{cjring[n].jobno = -1;
		cjring[n].next = cjring+n+1;
		}
	cjring[max_jobs].next = cjring;

	if (tty = istty (cin)) infile = TTYINPUT;
	else infile = cin;
	inptr = 0;

	if (infile == TTYINPUT) doinit ();
	maktag (&restart);
	on (ctrlg_interrupt, ghandler);

more:	while (incnt>0)
		{int wait, allowtyo;
		n = rdcom (jcl_buf);
		if (n < 0)
			{pop ();
			continue;
			}
		if (n<=1) continue;
		pname = jcl_buf;
		while (*pname == ' ') ++pname;
		if (*pname == ':')
			{if (*++pname == ESC)
				{++pname;
				while (c = *pname++) if (c == ESC) break;
				if (c==0) continue;
				}
			while (*pname == ' ') ++pname;
			}
		if (*pname == 0) continue;
		p = pname;
		wait = TRUE;
		allowtyo = FALSE;
		while ((c = *p) && c != ' ') ++p;
		if (c == ' ')
			{*p = 0;
			jcl = p+1;
			if (n>=2 && jcl_buf[n-2] == '&')
				{wait = FALSE;
				jcl_buf[n-2] = 0;
				if (n>=3 && jcl_buf[n-3] == '&')
					{allowtyo = TRUE;
					jcl_buf[n-3] = 0;
					}
				}
			}
		else jcl = p;
		ttybset (-1, _TBINF);
		if (!built_in (pname))
			{n = run_job (pname, jcl, wait, allowtyo);
			if (n >= 0)
				{setjob (n);
				if (wait)
					if (!wait_job (cur_job))
						next_job ();
				}
			else switch (n) {
			case -2:	eprint ("can't create job\n"); break;
			case -3:	eprint ("can't load program file\n"); break;
				}
			}
		}
	if (tty)
		{int fd;
		tty = 0;
		fd = copen ("_SHELL (EXIT)", 'r');
		if (fd == OPENLOSS)
			{int uname;
			filespec fs;
			char buf[100];
			uname = rsuset (UXUNAME);
			fs.dev = _DSK_;
			fs.dir = csto6 ("(INIT)");
			fs.fn1 = uname;
			fs.fn2 = csto6 ("SHELL_");
			prfile (&fs, buf);
			fd = copen (buf, 'r');
			}
		if (fd != OPENLOSS)
			{push (fd, 0);
			goto more;
			}
		}
	}

/**********************************************************************

	RDCOM - Read Command

**********************************************************************/

int rdcom (buf)
	char buf[];

	{int n;
	if (infile == TTYINPUT)
		{int c;
		n = get_buf (buf, arg_size, '\r', "> ");
		if (n <= 0) return (-1);
		buf[n-1] = 0;
		while (c = *buf)
			{if (c == CTLZ || c == CTLG || c == CTLS)
				*buf = ' ';
			++buf;
			}
		}
	else if (infile == VALINPUT)
		{char *p;
		int c;
		p = buf;
		while (c = *inptr++)
			{if (c==CTLV) {_ton (); continue;}
			if (c==CTLW) {_toff (); continue;}
			if (c=='\n' || c=='\r') break;
			nputc (*p++ = c);
			if (p>buf+arg_size) break;
			}
		if (c==0)
			{if (p>buf) --inptr;
			else return (-1);
			}
		*p++ = 0;
		n = p-jcl_buf;
		nputc ('\n');
		}
	else
		{char *p;
		int c;
		p = buf;
		n = 1;
		while ((c = cgetc (infile)) != '\n' && c > 0)
			{*p++ = c; ++n;}
		if (n == 1 && ceof (infile)) return (-1);
		*p++ = 0;
		}
	return (n);
	}

/**********************************************************************

	BUILT_IN

**********************************************************************/

int built_in (pname)
	char *pname;

	{char *s;
	int c; command *p;

	s = pname;
	while (c = *s) *s++ = lower (c);
	p = comtab;
	while (s = p->name)
		{if (stcmp (s, pname))
			{argc = parse (jcl, argv);
			(*p->f)();
			return (TRUE);
			}
		++p;
		}
	return (FALSE);
	}

/**********************************************************************

	BUILT-IN COMMAND ROUTINES

**********************************************************************/

int _jobs ()

	{int n, i;
	char *job_name();

	sflag = FALSE;
	n = 0;
	for (i=0; i<max_jobs && !sflag; ++i)
		{if (j_sts (i) != -1)
			{++n;
			print ("%c %d %s ",
				i==cur_job?'+':' ', i, job_name (i));
			pr_sts (i);
			nputc ('\n');
			}
		}
	if (n==0 && !sflag) print ("no jobs\n");
	}

int _job ()

	{int j;

	j = get_job (-2);
	if (j>=0)
		{setjob (j);
		go_job (FALSE);
		}
	else if (j == -2) {if (!next_job()) print ("no jobs\n");}
	}

int _con ()

	{if (set_job () >= 0)
		if (!wait_job (cur_job)) next_job ();
	}

int _kill ()

	{if (set_job () >= 0)
		{j_kill (cur_job);
		next_job ();
		}
	}

int _pro ()

	{if (set_job () >= 0)
		{if (j_sts (cur_job) == -2) go_job (FALSE);
		else j_start (cur_job);
		}
	}

int _protty ()

	{if (set_job () >= 0)
		{if (j_sts (cur_job) == -2) go_job (FALSE);
		else
			{j_start (cur_job);
			ttybset (j_ch (cur_job), _TBOUT+_TBWAT);
			}
		}
	}

int _stop ()

	{if (set_job () >= 0)
		{j_stop (cur_job);
		ttybclear (j_ch (cur_job), _TBOUT+_TBWAT);
		}
	}

int _own ()

	{int uname, jname, j;

	if (argc < 1 || argc > 2) eprint ("usage: own {uname} jname\n");
	else
		{if (argc==1)
			{uname = runame ();
			jname = csto6 (argv[0]);
			}
		else
			{uname = csto6 (argv[0]);
			jname = csto6 (argv[1]);
			}
		j = ownjob (uname, jname);
		if (j<0)
			{switch (j) {
			case -5:	eprint ("no such job\n"); break;
			case -6:	eprint ("job not yours\n"); break;
			default:	eprint ("fatal error\n"); break;
				}
			return;
			}
		setjob (j);
		if (jnames[j] != jxnames[j]) pr_job (j);
		}
	}

int ownjob (uname, jname)

	{int j;

	j = j_own (uname, jname);
	if (j >= 0) ttybset (j_ch(j), _TBINT);
	return (j);
	}

int _disown ()

	{if (set_job () >= 0)
		{ttybclear (j_ch (cur_job), _TBINT);
		j_disown (cur_job);
		next_job ();
		}
	}

int _forget ()

	{if (set_job () >= 0)
		{ttybclear (j_ch (cur_job), _TBINT);
		j_forget (cur_job);
		next_job ();
		}
	}

int _detach () {sysdtach (0777777); _newtty ();}

int _attach ()

	{if (set_job () >= 0)
		{int sts, option, tty, ch;
		sts = j_sts (cur_job);
		if (sts == 0 || sts == PJTTY)
			{ch = j_ch (cur_job);
			option = ruset (ch, UOPTION);
			tty = ruset (ch, UTTY);
			wuset (ch, UOPTION, option & ~(OPTCMD|OPTBRK));
			wuset (ch, UTTY, 0);
			j_start (cur_job);
			sysatach (j_ch (cur_job), -1);
			wuset (ch, UTTY, tty);
			wuset (ch, UOPTION, option);
			eprint ("unable to attach\n");
			}
		else eprint ("job must be running\n");
		}
	}

int _snarf ()

	{int jname, j;

	if (argc < 1 || argc > 2)
		eprint ("usage: snarf {dead-job-name} inferior-name\n");
	else
		{if (argc==1)
			{jname = csto6 (argv[0]);
			if ((j = cur_job) < 0) eprint ("no jobs\n");
			}
		else
			{j = fndjob (argv[0]);
			jname = csto6 (argv[1]);
			}
		if (j >= 0)
			{if (j_snarf (j, jname)) eprint ("no such inferior\n");
			else
				{j = ownjob (runame (), jname);
				if (j<0) eprint ("unable to reown job\n");
				}
			}
		}
	}

int _ls ()

	{int form, n, c;
	char **ss, *s;

	form = 0;
	n = 0;
	ss = argv;
	if (argc>0 && argv[0][0] == '-')
		{s = argv[0]+1;
		++ss;
		--argc;
		while (c = *s++) switch (lower (c)) {
			case 'l': form =| ls_long; continue;
			case 'n': form =| ls_new; continue;
			case 'd': form =| ls_dirdev; continue;
			default: print ("unrecognized option: '%c'\n", c);
			}
		}
	while (--argc >= 0) {ls_dir (*ss++, form); ++n;}
	if (n==0) ls_dir ("", form);
	}

ls_dir (name, form)
	char *name;

	{int fd;
	filespec f;

	fparse (name, &f);
	if (f.fn1 && !f.dir) f.dir = f.fn1;
	if (f.dev == _TTY_ || f.dev == _TPL_ ||
		f.dev == _XGP_) form =| ls_long;
	if (form & ls_dirdev)
		{form =| ls_long;
		f.dev = _DIR_;
		f.fn1 = _NAME1_;
		f.fn2 = _UP_;
		}
	else
		{f.fn1 = _FILE_;
		f.fn2 = _PDIRP_;
		}

	g2s = 1;
	fd = xopen (&f, 'r');
	if (fd == OPENLOSS) pr_err (&f, cerrno);
	else typdir (fd, form);
	g2s = 0;
	}

int _cat ()

	{int fd, i;

	for (i=0;i<argc;++i)
		{g2s = 1;
		fd = eopen (argv[i], 'r');
		if (fd != OPENLOSS) typfil (fd);
		g2s = 0;
		}
	}

int _lpr ()

	{int i, j;
	char buf[200], *p, *s;

	for (i=0;i<argc;++i)
		{s = argv[i];
		p = buf;
		*p++ = '"';
		while (*p++ = *s++);
		p[-1] = '"';
		s = " /tpl/output.>";
		while (*p++ = *s++);
		j = run_job ("sys2/cp", buf, TRUE, FALSE);
		if (j >= 0) wait_job (j);
		}
	pos0 ();
	}

int _rm ()

	{filespec f;
	int ec;
	char **ss;

	if (argc < 1)
		{eprint ("usage: rm file.name ...\n");
		return;
		}
	if (infile == TTYINPUT && argc > 1)
		{cprint ("delete %d files", argc);
		if (ask ("") == FALSE) return;
		}
	ss = argv;
	while (--argc >= 0)
		{xparse (*ss++, &f);
		ec = sysdel (&f);
		if (ec && ttyflg==0) pr_err (&f, -ec);
		}
	}

int _nfdir ()

	{char **ss;

	ss = argv;
	while (--argc >= 0) nfdir[nfcnt++] = csto6 (*ss++);
	}

int _ofdir ()

	{char **ss;
	int w, i;

	ss = argv;
	while (--argc >= 0)
		{w = csto6 (*ss++);
		for (i=0;i<nfcnt;++i)
			if (nfdir[i]==w)
				{while (++i<nfcnt) nfdir[i-1]=nfdir[i];
				--nfcnt;
				break;
				}
		}
	}

int _chdir ()

	{if (argc != 1) eprint ("usage: chdir new_dir\n");
	else ssname (csto6 (argv[0]));
	}

int _tranad ()

	{char *s;
	int flags, j, c, e;
	filespec fromfs, tofs;

	if (argc < 4)
		{eprint ("usage: tranad job aio* from.file to.file\n");
		return;
		}
	if (stcmp (argv[0], ".")) j = -1;
	else
		{j = fndjob (argv[0]);
		if (j == -1) return;
		j = j_ch (j);
		}
	flags = 0;
	s = argv[1];
	while (c = lower (*s++)) switch (c) {
		case 'a':	flags =| 0400000; continue;
		case 'i':	flags =| 0000001; continue;
		case 'o':	flags =| 0000002; continue;
		case '*':	flags =| 0200000; continue;
		default:	eprint ("unrecognized mode: %c\n", c);
		}
	fparse (argv[2], &fromfs);
	fparse (argv[3], &tofs);
	e = tranad (j, &fromfs, &tofs, flags);
	if (e) pr_err (&fromfs, -e);
	}

int _sfauth ()

	{int fd;
	if (argc < 2)
		{eprint ("usage: sfauth author file\n");
		return;
		}
	fd = eopen (argv[1], 'r');
	if (fd != OPENLOSS)
		{int name;
		name = csto6 (argv[0]);
		sauth (itschan (fd), name);
		cclose (fd);
		}
	}

int _pwd ()

	{print ("/dsk/%x\n", rsname());}

int _xfile ()

	{int fd;
	g2s = 1;
	fd = eopen (jcl, 'r');
	if (fd != OPENLOSS) push (fd, 0);
	g2s = 0;
	}

int _mv ()

	{int ec;
	filespec f1, f2;

	if (argc != 2) eprint ("usage: mv old_file new_file\n");
	else
		{xparse (argv[0], &f1);
		fparse (argv[1], &f2);
		if (!f2.fn2) {f2.fn2 = f2.fn1; f2.fn1 = f1.fn1;}
		ec = sysrnm (&f1, &f2);
		if (ec < 0 && ttyflg==0) pr_err (&f1, -ec);
		}
	}

int _ln ()

	{int ec;
	filespec f1, f2;

	if (argc != 2) eprint ("usage: ln new_file old_file\n");
	else
		{xparse (argv[0], &f1);
		fparse (argv[1], &f2);
		if (!f2.dir) f2.dir = f1.dir;
		if (!f2.fn1) f2.fn1 = f1.fn1;
		if (!f2.fn2) f2.fn2 = f1.fn2;
		ec = syslnk (&f1, &f2);
		if (ec < 0) pr_err (&f2, -ec);
		}
	}

int _df ()

	{int fd;
	char buf[100];
	fd = eopen ("/dsk/sys/.file..(dir)", 'r');
	if (fd != OPENLOSS)
		{readstring (buf, fd);
		readstring (buf, fd);
		print ("%s\n", buf+12);
		cclose (fd);
		}
	}

int _echo ()

	{int i;

	for (i=0;i<argc;++i)
		{nputs (argv[i]); nputc (' ');}
	nputc ('\n');
	}

int _toff () {++ttyflg;}
int _ton () {if (--ttyflg<0) ttyflg=0;}

int _clear () {spctty ('C');}
int _newtty () {tyiopn ();}

int _login ()

	{int j, name, oldname;

	if (argc != 1)
		{eprint ("usage: login user-name\n");
		return;
		}
	name = csto6 (argv[0]);
	if (!top_level())
		{eprint ("must be top-level job\n");
		return;
		}
	oldname = rsuset (UXUNAME);
	if (oldname == csto6 ("GUEST")) oldname = 0;
	else
		{int ch;
		filespec ff;
		ff.dev = _DSK_;
		ff.dir = oldname;
		ff.fn1 = _FILE_;
		ff.fn2 = _PDIRP_;
		ch = open (&ff, BII);
		if (ch < 0) oldname = 0;
		else close (ch);
		}
	if (oldname == 0)
		{eprint ("I'm sorry, but you are a loser.\n");
		return;
		}
	for (j=0;j<max_jobs;++j) j_kill (j);
	on (ilopr_interrupt, loser);
	loss = FALSE;
	wsuset (UUNAME, name);
	on (ilopr_interrupt, 0);
	if (loss)
		{eprint ("unable to login as '%s'\n", argv[0]);
		return;
		}
	wsuset (UXUNAME, name);
	wsuset (USNAME, name);
	doinit ();
	}

int _vk () {_ton ();}

int _help ()

	{char *r, *s;
	int c, n;
	command *p;

	sflag = FALSE;
	print ("commands:\n");
	p = comtab;
	while ((s = p->name) && !sflag)
		{if (r = p->desc)
			{nputs ("   ");
			n = 0;
			while (c = *s++) {nputc (c); ++n;}
			n = 15-n;
			while (--n >= 0) nputc (' ');
			while (c = *r++) nputc (c);
			nputc ('\n');
			}
		++p;
		}
	}

/**********************************************************************

	TTYBSET, TTYBCLEAR

**********************************************************************/

ttybset (j, bits)

	{int w;
	if (j>=0)
		{w = ruset (j, UTTY);
		wuset (j, UTTY, w | bits);
		}
	else
		{w = rsuset (UTTY);
		wsuset (UTTY, w | bits);
		}
	}

ttybclear (j, bits)

	{int w;
	if (j>=0)
		{w = ruset (j, UTTY);
		wuset (j, UTTY, w & ~bits);
		}
	else
		{w = rsuset (UTTY);
		wsuset (UTTY, w & ~bits);
		}
	}

/**********************************************************************

	PARSE

**********************************************************************/

int parse (string, v)
	char *string, *v[];

	{int n, c, qflag;

	n = 0;
	while (TRUE)
		{while ((c = *string++) == ' ');
		if (!c) break;
		if (n>=max_args)
			{eprint ("too many args\n");
			break;
			}
		qflag = FALSE;
		if (c == '"')
			{v[n++] = string;
			qflag = TRUE;
			}
		else v[n++] = --string;
		while (TRUE)
			{if ((c = *string) == 0) break;
			if (c == CTLQ && string[1])
				{string =+ 2;
				continue;
				}
			if (qflag && c == '"') break;
			if (!qflag && c == ' ') break;
			++string;
			}
		*string++ = 0;
		if (!c) break;
		}
	return (n);
	}

/**********************************************************************

	PUSH and POP

**********************************************************************/

push (fd, s)
	char *s;

	{char *p;

	if (incnt >= (max_files-1))
		{eprint ("too many input sources\n");
		if (fd != VALINPUT) cclose (fd);
		}
	else
		{instk[incnt] = infile;
		inpts[incnt] = inptr;
		++incnt;
		instk[incnt] = infile = fd;
		if (fd == VALINPUT)
			{p = calloc (slen (s) + 1);
			stcpy (s, p);
			}
		else p = 0;
		inval[incnt] = inpts[incnt] = inptr = p;
		}
	}

pop ()

	{if (cisfd (infile)) cclose (infile);
	else if (infile == VALINPUT) cfree (inval[incnt]);
	if (--incnt > 0)
		{infile = instk[incnt];
		inptr = inpts[incnt];
		}
	else infile = -3;
	}

/**********************************************************************

	TYPFIL

**********************************************************************/

typfil (fd)

	{int c;

	sflag = FALSE;
	while ((c = cgetc (fd)) > 0 || !ceof (fd))
		{if (sflag)
			{nputc ('\n'); break;}
		if (c == BELL) {nputc ('^'); nputc ('G');}
		else if (c != '\p') nputc (c);
		}
	pos0 ();
	cclose (fd);
	}

/**********************************************************************

	TYPDIR

**********************************************************************/

typdir (fd, form)

	{int c, n, _long, _new, _dirdev;
	char buf[100], *s;

	sflag = FALSE;
	_long = form & ls_long;
	_new = form & ls_new;
	_dirdev = form & ls_dirdev;
	n = 0;
	while (TRUE)
		{readstring (buf, fd);
		if (sflag || buf[0]==3 || buf[0] == '\p' || ceof (fd))
			break;
		++n;
		s = buf;
		if (!_long && n==2) continue;
		if (_new && n>1)
			{if (_dirdev)
				{if (buf[28] != '!') continue;}
			else if (buf[22] != '!' &&
			    buf[23] != '!' &&
			    buf[24] != '!') continue;
			}
		if (!_long && n>1)
			{buf[19] = 0;
			buf[4] = buf[0];
			s = buf+4;
			}
		while (c = *s++) nputc (lower (c));
		nputc ('\n');
		}
	pos0 ();
	cclose (fd);
	}

/**********************************************************************

	PR_ERR

**********************************************************************/

pr_err (fp, x)
	filespec *fp;

	{filespec f;
	int fd, c;
	char *buf[40];

	prfile (fp, buf);
	cprint (cerr, "  %s  ", buf);

	f.dev = _ERR_;
	f.fn1 = 4;
	f.fn2 = x;
	fd = mopen (&f, 0);
	if (fd >= 0)
		{int cap;
		cap = TRUE;
		while ((c = uiiot (fd)) > 0)
			if (c != '\r' && c != '\p')
				{if (c>='A' && c<='Z')
					{if (!cap) c = lower(c);
					cap = FALSE;
					}
				else cap=TRUE;
				cputc (c, cerr);
				}
		close (fd);
		}
	}

/**********************************************************************

	EOPEN

**********************************************************************/

int eopen (name, mode)
	char *name;

	{int fd;
	filespec f;

	fparse (name, &f);
	fd = xopen (&f, mode);
	if (fd == OPENLOSS) pr_err (&f, cerrno);
	return (fd);
	}

/**********************************************************************

	XOPEN

**********************************************************************/

int xopen (fp, mode)
	filespec *fp;

	{char buf[40];
	if (!fp->dev) fp->dev = default_device;
	if (!fp->dir) fp->dir = rsname ();
	prfile (fp, buf);
	return (copen (buf, mode));
	}

/**********************************************************************

	XPARSE

**********************************************************************/

int xparse (name, fp)
	char *name;
	filespec *fp;

	{int rc;

	rc = fparse (name, fp);
	if (!fp->dev) fp->dev = default_device;
	if (!fp->dir) fp->dir = rsname ();
	if (!fp->fn2) fp->fn2 = _GREATER_;
	return (rc);
	}

/**********************************************************************

	NEXT_JOB

**********************************************************************/

int next_job ()

	{if (cjrhead == cjrtail)	/* no jobs */
		{pos0 ();
		cur_job = -1;
		return (FALSE);
		}
	if (cjrhead->next != cjrtail) /* more than 1 job */
		{cjrtail->jobno = cjrhead->jobno;
		cjrhead = cjrhead->next;
		cjrtail = cjrtail->next;
		}
	cur_job = cjrhead->jobno;
	if (cur_job < 0 || j_sts (cur_job) == -1)
		{cjrhead = cjrhead->next;
		return (next_job ());
		}
	go_job (TRUE);
	return (TRUE);
	}

/**********************************************************************

	SET_JOB - Set the current job to the named job, if any.
		Return -1 if no such job.

**********************************************************************/

int set_job ()

	{int j;
	if (argc < 1 && cur_job == -1)
		{eprint ("no jobs\n");
		return (-1);
		}
	j = get_job (cur_job);
	if (j>=0) setjob (j);
	return (j);
	}

/**********************************************************************

	SETJOB - Set the current job.  This manipulates the ring
	buffer.

**********************************************************************/

setjob (j)

	{ring *p, *q;

	if (j<0 || j>=max_jobs) return;
	cur_job = j;
	if (cjrhead->jobno == cur_job) return;

	/* find the job in the ring.  if there, remove it. */

	if (cjrhead != cjrtail)
		{p = cjrhead;
		while ((p = p->next) != cjrtail)
			if (p->jobno == cur_job)
				{for (;;)
					{q = p->next;
					if (q == cjrtail)
						{cjrtail = p;
						break;
						}
					p->jobno = q->jobno;
					p = q;
					}
				break;
				}
		}

	/* now put the job at the head of the ring */

	p = cjrtail;
	while ((q = p->next) != cjrhead) p = q;
	p->jobno = cur_job;
	cjrhead = p;
	}

/**********************************************************************

	GET_JOB - Return the job number of the named job.  If no
		name is given, return the DEFLT value.  If there
		is no such named job, return -1.

**********************************************************************/

int get_job (deflt)

	{if (argc > 1)
		{eprint ("too many arguments\n");
		return (-1);
		}
	if (argc == 1) return (fndjob (argv[0]));
	return (deflt);
	}

int fndjob (s)
	char *s;

	{int i, name;

	name = csto6 (s);
	for (i=0;i<max_jobs;++i)
		if (jnames[i]==name && j_sts(i) != -1) return (i);
	eprint ("no job %s\n", s);
	return (-1);
	}

pr_job (j)

	{print ("job %s\n", job_name (j));
	}

go_job (print_flag)

	{if (print_flag) pr_job (cur_job);
	if (j_sts (cur_job) ==  -2)
		{if (!wait_job (cur_job)) next_job ();}
	}

/**********************************************************************

	RUN_JOB

	Returns:

		-3	Unable to load program file.
		-2	Unable to create job.
		-1	Unable to open program file.
		other	Job number.

**********************************************************************/

int run_job (pname, args, givetty, allowtyo)	char *pname, *args;

	{int j;
	filespec f;

	fparse (pname, &f);
	g2s = 1;
	j = findprog (&f);
	if (j<0)
		{g2s = 0;
		if (j == -1000)
			{eprint ("can't find %s\n", pname);
			j = -1;
			}
		return (j);
		}
	g2s = 0;

	if (jnames[j] != jxnames[j]) pr_job (j);
	j_sjcl (j, args);
	if (givetty) j_give_tty (j);
	ttybset (j_ch(j), (givetty ? _TBINT+_TBWAT : _TBINT));
	if (!givetty && allowtyo) ttybset (j_ch(j), _TBOUT+_TBWAT);
	j_start (j);
	return (j);
	}

/**********************************************************************

	FINDPROG - Find a program.

**********************************************************************/

int findprog (fp)
	filespec *fp;

	{int n, *p, j;

	if (fp->fn1 == _GREATER_ || fp->fn1 == _LESS_) return (-1000);
	fp->fn2 = fp->fn1;
	fp->fn1 = _TS_;

	if (!fp->dev) fp->dev = default_device;
	if (fp->dir) return (tryprog (fp));
	else
		{fp->dir = rsname ();
		if ((j = tryprog (fp)) != -1000) return (j);
		}

	n = nfcnt;
	p = nfdir;
	while (--n>=0)
		{fp->dir = *p++;
		if ((j = tryprog (fp)) != -1000) return (j);
		}
	return (-1000);
	}

int tryprog (fp)
	filespec *fp;

	{int oldn2, fd;

	fp->fn1 = _TS_;
	if ((fd = open (fp, BII)) >= 0)
		return (j_cload (fd, fp->fn2));
	fp->fn1 = _ZZ_;
	oldn2 = fp->fn2;
	fp->fn2 = rj6 (fp->fn2);
	if ((fd = open (fp, BII)) >= 0)
		return (j_cload (fd, oldn2));
	fp->fn1 = _TS_;
	fp->fn2 = oldn2;
	return (-1000);
	}

int rj6 (w)

	{if (w == 0) return (0);
	while ((w & 077) == 0) w =>> 6;
	return (w);
	}

/**********************************************************************

	WAIT_JOB

	Returns:

		-6	Job ^Zed.
		-5	Job .VALUEed something.
		-4	Internal fatal error.
		-3	Unhandled interrupt.
		0	Job terminated normally.

**********************************************************************/

int wait_job (j)

	{int i;
	char *s;

	if (j<0) return (0);
	if (j_sts (j) == -1) return (0);
	if (j_sts (j) != -2)
		{j_give_tty (j);
		j_start (j);
		}

	i = j_wait (j);
	j_take_tty (j);
	ttybclear (j_ch (j), _TBOUT+_TBWAT);
	pos0 ();
	if (i<0) switch (i) {

	case -1:	return (0);
	case -2:	break;
	case -3:	s = j_val (j);
			if (s) push (VALINPUT, s);
			else print ("Job .VALUE 0\n");
			return (-5);
			break;
	case -5:	return (-6);
	default:	return (-3);
			}
	else if (i>0)
		{eprint ("unhandled interrupts: ");
		pr_int (i);
		nputc ('\n');
		return (-3);
		}

	i = ruset (j_ch(j), URUNT) / (16666000./4069.);
	if (i >= 60)	/* print times only greater than 1 second */
		print ("%d.%d", i/60, (i%60)/10);
	j_kill (j);
	return (0);
	}

/**********************************************************************

	JOB_NAME

**********************************************************************/

char *job_name (j)

	{filespec f;
	static char buf[10];

	if (j_sts (j) == -1) return ("");
	j_name (j, &f);
	c6tos (f.fn2, buf);
	return (buf);
	}

/**********************************************************************

	PR_STS

**********************************************************************/

pr_sts (j)

	{int s;

	s = j_sts (j);
	switch (s) {
		case -5:	nputs ("stopped by ^Z"); return;
		case -4:	nputs ("stopped"); return;
		case -3:	nputs (".VALUE"); return;
		case -2:	nputs ("finished"); return;
		case -1:	nputs ("?"); return;
		case 0:		nputs ("running"); return;
		default:	nputs ("interrupted: ");
				pr_int (s); return;
		}
	}

/**********************************************************************

	PR_INT - Print Interrupt Bits

**********************************************************************/

pr_int (w)

	{if (w & PJRLT) nputs ("timer ");
	if (w & PJRUN) nputs ("run_timer ");
	if (w & PJTTY) nputs ("wants_TTY ");
	if (w & PJPAR) nputs ("parity_error ");
	if (w & PJFOV) nputs ("floating_overflow ");
	if (w & PJWRO) nputs ("pure_page_write ");
	if (w & PJFET) nputs ("executing_from_impure ");
	if (w & PJTRP) nputs ("system_uuo_trap ");
	if (w & PJDBG) nputs ("system_being_debugged ");
	if (w & PILOS) nputs (".LOSE ");
	if (w & PICLI) nputs ("CLI ");
	if (w & PIPDL) nputs ("stack_overflow ");
	if (w & PILTP) nputs ("light_pen_hit ");
	if (w & PIMAR) nputs ("MAR ");
	if (w & PIMPV) nputs ("memory_protection_violation ");
	if (w & PICLK) nputs ("slow_clock ");
	if (w & PI1PR) nputs ("single_instruction ");
	if (w & PIBRK) nputs (".BREAK ");
	if (w & PIOOB) nputs ("address_out_of_bounds ");
	if (w & PIIOC) nputs ("io_channel_error ");
	if (w & PIVAL) nputs (".VALUE ");
	if (w & PIDWN) nputs ("system_going_down ");
	if (w & PIILO) nputs ("illegal_operation ");
	if (w & PIDIS) nputs ("display_memory_protect ");
	if (w & PIARO) nputs ("arithmetic_overflow ");
	if (w & PIB42) nputs ("bad_location_42 ");
	if (w & PICZ ) nputs ("^Z ");
	if (w & PITYI) nputs ("TTY_input ");
	}

/**********************************************************************

	SETNAM

**********************************************************************/

setnam ()

	{int i;

	if (top_level ())
		{ssname (rsuset (UXUNAME));
		on (ilopr_interrupt, loser);
		loss = FALSE;
		wsuset (UJNAME, _SHELL_);
		if (loss)
			{for (i=0;i<9;++i)
				{loss = FALSE;
				wsuset (UJNAME, _SHELL0_+i);
				if (!loss) break;
				}
			}
		on (ilopr_interrupt, 0);
		}
	}

/**********************************************************************

	DOINIT - Do User Initialization

**********************************************************************/

doinit ()

	{int fd;
	fd = copen ("_SHELL (INIT)", 'r');
	if (fd == OPENLOSS)
		{int uname;
		filespec fs;
		char buf[100];
		uname = rsuset (UXUNAME);
		fs.dev = _DSK_;
		fs.dir = csto6 ("(INIT)");
		fs.fn1 = uname;
		fs.fn2 = csto6 ("_SHELL");
		prfile (&fs, buf);
		fd = copen (buf, 'r');
		}
	if (fd != OPENLOSS) push (fd, 0);
	}

/**********************************************************************

	PRINT - normal print routine

**********************************************************************/

print (fmt, a1, a2, a3, a4, a5)
	{if (!ttyflg)
		{cputc (' ', cout);
		cputc (' ', cout);
		cprint (fmt, a1, a2, a3, a4, a5);
		}
	}

nputs (s) {if (!ttyflg) prs (s, cout, 0);}
nputc (c) {if (!ttyflg) cputc (c, cout);}

/**********************************************************************

	EPRINT - Error Print Routine

**********************************************************************/

eprint (fmt, a1, a2, a3, a4, a5)

	{ttyflg = 0;
	cprint (cerr, "  ");
	cprint (cerr, fmt, a1, a2, a3, a4, a5);
	if (infile == VALINPUT)
		{pop ();
		cprint (cerr, "--flushed--\n");
		}
	}

prfs (fp, f, width)
	filespec *fp;

	{char buf[40];
	prfile (fp, buf);
	prs (buf, f, 0);
	}

pr6 (w, f, width)
	{char buf[10], *p, c;

	c6tos (w, buf);
	p = buf;
	while (c = *p) *p++ = lower (c);
	prs (buf, f, 0);
	}

/**********************************************************************

	READSTRING

**********************************************************************/

readstring (s, fd)
	char *s;

	{int c;

	while ((c = cgetc (fd)) != '\n' && c>0) *s++ = c;
	*s = 0;
	}

/**********************************************************************

	POS0 - ensure that cursor is at left margin
	(could be conservative and always output NL)

**********************************************************************/

pos0 ()

	{if (ttyflg) return;
	tyo_flush ();
	if ((rcpos (itschan (cout)) & 0777777) != 0) cputc ('\n', cout); 
	else spctty ('L');	/* erase line */
	}

/**********************************************************************

	TOP_LEVEL - return non-zero if this job is a top-level job

**********************************************************************/

int top_level ()

	{return (rsuset (USUPPR) == -1);
	}

/**********************************************************************

	ASK - ask a yes/no question

**********************************************************************/

ask(s)

	{while (TRUE)
		{tyos (s);
		tyos (" (Y or N)? ");
		while (TRUE)
			{switch (lower (utyi ())) {
			case 'y':	tyos ("yes\r"); return (TRUE);
			case 0:
			case 'n':	tyos ("no\r"); return (FALSE);
			case '\014':	tyo ('\r'); break;
			default:	tyo (007); continue;
				}
			break;
			}
		}
	}
