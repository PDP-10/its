# include "c/c.defs"
# include "c/its.bits"
# define MAXUSER 300
# define FNSIZE 40

/**********************************************************************

	Incremental Statistics Generator -- CLUCMP

**********************************************************************/

/**********************************************************************

	The following code is per-program:

**********************************************************************/

# define BUFSIZ 20
# define statfilename "/clu/clucmp.stat"
# define sumfilename "/clu/clucmp.stats"
# define accfilename "/dm/clu/clucmp.stats"
# define oldfilename "/dm/clu/clucmp.ostat"

char *mlist[] {
	"dm",
	};

int pflag {TRUE};	/* default is to print accumulated stats */

struct _stat {
	int name;	/* user name - in SIXBIT */
	int time;	/* CPU time (in 60th sec) */
	};

struct _user {
	int name;	/* user name - in SIXBIT */
	int count;	/* number of runs */
	int time;	/* total time (in 60th secs) */
	};

/**********************************************************************

	The following code is common.

**********************************************************************/

typedef struct _stat stat;
typedef struct _user user;

user usertab[MAXUSER], *cuser, *euser;
extern int cout;
cal thetime;
int usersize;
int changed;

main (argc, argv)
	char *argv[];

	{int addstat(), wsummary();
	if (!wizard())
		{cprint ("Please do not run this program;\n");
		cprint ("you may screw up a permanent data base.\n");
		cprint ("Thank you for your cooperation.\n");
		return;
		}
	now (&thetime);
	usersize = sizeof (*cuser) / sizeof (pflag);
	changed = FALSE;
	cuser = usertab;
	euser = usertab+MAXUSER;
	if (argc>1 && stcmp (argv[1], "-p")) pflag = !pflag;
	foreach (addstat);
	if (!changed)
		{cprint ("No recent statistics.\n");
		rdacc ();
		sortuser ();
		}
	foreach (wsummary);
	if (pflag) wfacc (cout, FALSE);
	}

foreach (f)
	int (*f)();

	{int n;
	char **p;
	n = sizeof(mlist)/sizeof(mlist[0]);
	p = mlist;
	while (--n >= 0)
		(*f)(*p++);
	}

wsummary (s) char *s;

	{char *t, buf[FNSIZE];
	t = stcpy ("/", buf);
	t = stcpy (s, t);
	stcpy (sumfilename, t);
	wfnacc (buf, FALSE);
	}

char stfname[FNSIZE];

int wizard ()

	{int xuname, option;
	xuname = rsuset (UXUNAME);
	option = rsuset (UOPTION);
	return (!(option & (010000<<18)) & (xuname == csto6 ("AS")));
	}

addstat (s) char *s;

	{char *t;
	t = stcpy ("/", stfname);
	t = stcpy (s, t);
	stcpy (statfilename, t);
	if (yexists ())			/* if YSTAT file exists */
		{apy2o (s);		/* append YSTAT file to OSTAT file */
		dely ();		/* delete YSTAT file */
		changed = TRUE;
		}
	if (!xexists ())		/* if XSTAT file doesn't exist */
		{rns2x ();		/* rename STAT file to XSTAT */
		if (!xexists ())	/* if XSTAT file doesn't exist */
			return;
		}
	changed = TRUE;
	rdacc ();			/* read accumulated stats */
	rdxstat ();			/* read XSTAT file - add to acc stats */
	sortuser ();			/* sort accumulated stats */
	wfnacc (accfilename, TRUE);	/* update accumulated stats */
	rnx2y ();			/* rename XSTAT file to YSTAT file */
	apy2o (s);			/* print YSTAT and append to OSTAT file */
	dely ();			/* delete YSTAT file */
	}

int xexists ()

	{char buf[FNSIZE];
	int fd;
	apfname (buf, stfname, "xstat");
	fd = copen (buf, 'r');
	if (fd != OPENLOSS)
		{cclose (fd);
		return (TRUE);
		}
	return (FALSE);
	}

int yexists ()

	{char buf[FNSIZE];
	int fd;
	apfname (buf, stfname, "ystat");
	fd = copen (buf, 'r');
	if (fd != OPENLOSS)
		{cclose (fd);
		return (TRUE);
		}
	return (FALSE);
	}

rns2x ()

	{char buf[FNSIZE];
	apfname (buf, stfname, "xstat");
	rename (stfname, buf);
	}

rnx2y ()

	{char buf1[FNSIZE], buf2[FNSIZE];
	apfname (buf1, stfname, "xstat");
	apfname (buf2, stfname, "ystat");
	rename (buf1, buf2);
	}

rdacc ()

	{int fd, rc;

	fd = copen (accfilename, 'r');
	if (fd == OPENLOSS)
		{cprint ("Can't read stats file: %s\n", accfilename);
		cexit (1);
		}
	rc = rdfacc (fd);
	cclose (fd);
	if (rc)
		{cprint ("Error in reading stats file: %s\n", accfilename);
		cexit (1);
		}
	}

rdxstat ()

	{int fd, n, unk;
	char buf[FNSIZE];
	stat cstat;

	apfname (buf, stfname, "xstat");
	fd = copen (buf, 'r');
	if (fd == OPENLOSS)
		{cprint ("Cant open %s\n", buf);
		cexit (1);
		}
	n = 0;
	unk = csto6 ("?");
	while (!ceof (fd))
		{++n;
		if (rdstat (fd, &cstat)) continue;
		if (cstat.name == unk)
			cprint ("File %s stat %d unknown user\n", buf, n);
		enterstat (&cstat);
		}
	cclose (fd);
	}

wfnacc (s, full)

	{int fd;
	fd = copen (s, 'w');
	if (fd == OPENLOSS)
		{if (!full) cprint ("Warning: ");
		cprint ("Cant write stats file: %s\n", s);
		if (full) cexit (1);
		return;
		}
	wfacc (fd, full);
	cclose (fd);
	}

apy2o (s)
	char *s;

	{char buf[FNSIZE];
	int fin, fout, c;

	apfname (buf, stfname, "ystat");
	fin = copen (buf, 'r');
	if (fin == OPENLOSS)
		{cprint ("Cant read YSTAT file: %s\n", buf);
		cexit (1);
		}
	fout = copen (oldfilename, 'a');
	if (fout == OPENLOSS)
		{cprint ("Cant append to OSTAT file: %s\n", buf);
		cexit (1);
		}
	cprint ("\n %s:\n\n", s);
	while (c = cgetc (fin))
		{cputc (c, fout);
		putchar (c);
		}
	putchar ('\n');
	cclose (fin);
	cclose (fout);
	}

dely ()

	{char buf[FNSIZE];

	apfname (buf, stfname, "ystat");
	delete (buf);
	}

getfield (fd, s, n)
	char s[];

	{char *ebuf;
	int c;

	ebuf = s + (n-1);
	c = cgetc (fd);
	while (c == ' ' || c == '\t') c = cgetc (fd);
	while (TRUE)
		{if (c == ' ' || c == '\t')
			{*s = 0;
			return (0);
			}
		if (c == '\n' || c <= 0) return (1);
		if (s < ebuf) *s++ = c;
		c = cgetc (fd);
		}
	return (1);
	}

/**********************************************************************

	GETLINE - Read a line into a buffer.
		Return 1 if EOF detected.

**********************************************************************/

getline (fd, s, n)
	char *s;

	{return (scan (fd, s, n, '\n'));}

scan (fd, s, n, tc) char *s;

	{char *ebuf;
	int c;

	ebuf = s + (n-1);
	while (c = cgetc (fd))
		{if (c == tc)
			{*s = 0;
			return (0);
			}
		if (c == '\n') return (1);
		if (s < ebuf) *s++ = c;
		}
	return (1);
	}

int atoi (s) char s[];

	{int i, sign, c;
	
	if (!s) return (0);
	i = 0;
	sign = 1;
	while (*s == '-') {++s; sign = -sign;}
	while ((c = *s++)>='0' && c<='9') i = i*10 + c-'0';
	if (i<0)
		{i = -i;
		if (i<0)
			if (sign>0) return (-(i+1));
			else return (i);
		}
	return (sign*i);
	}

rename (s1, s2) char *s1, *s2;

	{filespec f1, f2;
	fparse (s1, &f1);
	fparse (s2, &f2);
	sysrnm (&f1, &f2);
	}

int rd60th (s)
	char *s;

	{int sum, done, n;
	char *e;

	sum = 0;
	e = s;
	done = FALSE;
	while (!done)
		{while (*e != ':' && *e != '.' && *e) ++e;
		done = !*e;
		*e = 0;
		n = atoi (s);
		sum = sum * 60 + n;
		s = e+1;
		e = s;
		}
	return (sum);
	}

/**********************************************************************

	particular code

**********************************************************************/

rdfacc (fd)

	{char buf[10];
	cuser = usertab;
	if (getline (fd, buf, 10)) return (1);
	if (getline (fd, buf, 10)) return (1);
	if (getline (fd, buf, 10)) return (1);
	if (getline (fd, buf, 10)) return (1);
	while (rduser (fd));
	return (0);
	}

int rduser (fd)

	{char buf[BUFSIZ];
	int name, count, time;
	user *up;

	if (getfield (fd, buf, BUFSIZ)) return (0);
	if (buf[0] == 0) return (0);
	name = csto6 (buf);
	if (getfield (fd, buf, BUFSIZ)) return (0);
	count = atoi (buf);
	if (getfield (fd, buf, BUFSIZ)) return (0);
	time = rd60th (buf);
	if (getline (fd, buf, BUFSIZ)) return (0);
	up = ulookup (name);
	if (up->count)
		{c6tos (name, buf);
		cprint ("Duplicate stats entry for %s\n", buf);
		}
	else
		{up->count = count;
		up->time = time;
		}
	return (1);
	}

sortuser ()

	{user *up, *up1;

	for (up=usertab;up<cuser;++up)
		for (up1=up+1;up1<cuser;++up1)
			if (up1->time > up->time)
				swap (up, up1, usersize);
	}

swap (p, q, n)
	int *p, *q;

	{int temp[20], i, *d, *s;
	d = temp; s = p; i = n;
	while (--i >= 0) *d++ = *s++;
	d = p; s = q; i = n;
	while (--i >= 0) *d++ = *s++;
	d = q; s = temp; i = n;
	while (--i >= 0) *d++ = *s++;
	}

wfacc (fd)

	{user *up;
	int total_count, total_time;

	cprint (fd, "CLUCMP Statistics as of ");
	prcal (&thetime, fd);
	cprint (fd, "\n\nuser\t   count          time     average\n\n");
	total_count = total_time = 0;
	for (up=usertab;up<cuser;++up)
		{char buf[10];
		int rate;
		c6tos (up->name, buf);
		cprint (fd, "%s\t%8d  ", buf, up->count);
		pr60th (up->time, fd);
		pr60th (up->time/up->count, fd);
		cprint (fd, "\n", rate);
		total_count =+ up->count;
		total_time =+ up->time;
		}
	cprint (fd, "\ntotals\t%8d  ", total_count);
	pr60th (total_time, fd);
	pr60th (total_time/total_count, fd);
	cprint (fd, "\n");
	}

enterstat (p) stat *p;

	{user *up;

	up = ulookup (p->name);
	++up->count;
	up->time =+ p->time;
	}

ulookup (n)

	{user *up;

	for (up=usertab;up<cuser;++up)
		if (up->name == n) return (up);
	if (cuser < euser)
		{cuser->name = n;
		cuser->count = cuser->time = 0;
		return (cuser++);
		}
	return (0);
	}

rdstat (fd, p) stat *p;

	{char buf[BUFSIZ];
	int newform;

	newform = 0;
	if (getfield (fd, buf, BUFSIZ)) return (1);
	if (buf[0] >= '0' && buf[0] <= '9')
		{if (getfield (fd, buf, BUFSIZ)) return (1);
		newform = 1;
		}
	p->name = csto6 (buf);
	p->time = 0;
	if (newform)
		{int secs, millisecs;
		if (getfield (fd, buf, BUFSIZ)) return (1);
		if (getfield (fd, buf, BUFSIZ)) return (1);
		if (scan (fd, buf, BUFSIZ, '.')) return (1);
		secs = atoi (buf);
		if (getfield (fd, buf, BUFSIZ)) return (1);
		buf[3] = 0;
		millisecs = atoi (buf) + (secs * 1000);
		p->time = (millisecs * 60) / 1000;
		}
	if (scan (fd, buf, BUFSIZ, '\n')) return (1);
	return (0);
	}

