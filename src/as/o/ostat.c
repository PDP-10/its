# include "c/c.defs"
# include "c/its.bits"
# define MAXUSER 300
# define FNSIZE 40

/**********************************************************************

	Incremental Statistics Generator -- Othello

**********************************************************************/

/**********************************************************************

	The following code is per-program:

**********************************************************************/

# define BUFSIZ 20
# define statfilename "/c/_    o.stat"
# define sumfilename "/common/o.stats"
# define accfilename "/dm/c/_    o. state"
# define oldfilename "/dm/c/_    o.ostat"

char *mlist[] {
	"dm",
	"ml",
	"ai",
	"mc"
	};

int pflag {TRUE};	/* default is to print accumulated stats */

struct _stat {
	int name;	/* user name - in SIXBIT */
	int user;	/* user score */
	int machine;	/* machine score */
	int hcap;	/* handicap */
	int aflag;	/* too much help? */
	int color;	/* either 0, 1=*, or 2=@ */
	};

struct _user {
	int name;	/* must be first */
	int total;
	int totalpercent;
	int won[3];
	int cheat[3];
	int lost[3];
	int drawn[3];
	int percent[3];	/* must be last */
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

sortuser ()

	{user *up, *up1;

	for (up=usertab;up<cuser;++up)
		{int i, totaltotal, totalwin;
		totaltotal = totalwin = 0;
		for (i=0;i<=2;++i)
			{int total;
			total = up->won[i] + up->lost[i];
			totaltotal =+ total;
			totalwin =+ up->won[i];
			up->percent[i] = up->won[i]*1000/total;
			}
		up->totalpercent = totalwin*1000/totaltotal;
		}
	for (up=usertab;up<cuser;++up)
		for (up1=up+1;up1<cuser;++up1)
			{int sz, n, *s, *d;
			user temp;
			if (up1->totalpercent < up->totalpercent) continue;
			if (up1->totalpercent == up->totalpercent)
				if (up1->total <= up->total) continue;
			sz = sizeof(temp)/sizeof(0);
			s = up; d = &temp; n = sz;
			while (--n >= 0) *d++ = *s++;
			s = up1; d = up; n = sz;
			while (--n >= 0) *d++ = *s++;
			s = &temp; d = up1; n = sz;
			while (--n >= 0) *d++ = *s++;
			}
	}

wfacc (fd, full)

	{if (full) wrall (fd);
	else wrsum (fd);
	}

wrall (fd)

	{user *up;

	for (up=usertab;up<cuser;++up)
		{char buf[10];
		int sz, *p;
		c6tos (up->name, buf);
		cprint (fd, "%s", buf);
		sz = sizeof(*up)/sizeof(0);
		p = up;
		++p; --sz;
		while (--sz >= 0) cprint (fd, " %d", *p++);
		cputc ('\n', fd);
		}
	}

wrsum (fd)

	{user *up;
	int cutoff, twon, tcheat, tlost, tdrawn, tpercent;
	int nuser, spercent;

	cutoff = 4;
	twon = tcheat = tlost = tdrawn = nuser = spercent = 0;
	cprint (fd, "Othello Statistics as of ");
	prcal (&thetime, fd);
	cprint (fd, "\n\n note: cheat = win, but used analysis more than 10 times\n");
	cprint (fd, " users playing %d games or fewer not included\n", cutoff);
	cprint (fd,
	   "\n\nuser\t  won   cheat    lost   drawn   win %%   win %%   win %%\n");
	cprint (fd, "\t                                black   white   total\n\n");
	for (up=usertab;up<cuser;++up)
		{char buf[10];
		if (up->total > cutoff)
			{
			int swon, scheat, slost, sdrawn;
			++nuser;
			twon =+ (swon = up->won[0]+up->won[1]+up->won[2]);
			tcheat =+ (scheat = up->cheat[0]+up->cheat[1]+up->cheat[2]);
			tlost =+ (slost = up->lost[0]+up->lost[1]+up->lost[2]);
			tdrawn =+ (sdrawn = up->drawn[0]+up->drawn[1]+up->drawn[2]);
			spercent =+ up->totalpercent;
			c6tos (up->name, buf);
			cprint (fd, "%s\t%5d%8d%8d%8d", buf, swon,
				scheat, slost, sdrawn);
			prpercent (fd, up->percent[1]);
			prpercent (fd, up->percent[2]);
			prpercent (fd, up->totalpercent);
			cputc ('\n', fd);
			}
		}
	cprint (fd, "\ntotals\t%5d%8d%8d%8d", twon, tcheat, tlost, tdrawn);
	tpercent = twon*1000/(twon+tlost);
	cprint (fd, "%22d.%d\n", tpercent/10, tpercent%10);
	spercent = spercent/nuser;
	cprint (fd, "average\t%51d.%d\n", spercent/10, tpercent%10);
	}

prpercent (fd, n)
	{cprint (fd, "%6d.%d", n/10, n%10);
	}

enterstat (p) stat *p;

	{user *up;

	up = ulookup (p->name);
	if (up && p->hcap == 0)
		{if (p->user > p->machine)
			if (!p->aflag) ++up->won[p->color];
			else ++up->cheat[p->color];
		else if (p->user < p->machine) ++up->lost[p->color];
		else ++up->drawn[p->color];
		++up->total;
		}
	}

ulookup (n)

	{user *up;

	for (up=usertab;up<cuser;++up)
		if (up->name == n) return (up);
	if (cuser < euser)
		{int i;
		cuser->name = n;
		cuser->total = 0;
		for (i=0;i<=2;++i)
			{cuser->won[i] = 0;
			cuser->lost[i] = 0;
			cuser->cheat[i] = 0;
			cuser->drawn[i] = 0;
			}
		return (cuser++);
		}
	return (0);
	}

rdstat (fd, p) stat *p;

	{char buf[BUFSIZ], *s;

	if (scan (fd, buf, BUFSIZ, '\t')) return (1);
	p->name = csto6 (buf);
	if (scan (fd, buf, BUFSIZ, '-')) return (1);
	p->user = atoi (buf);
	if (scan (fd, buf, BUFSIZ, '\t')) return (1);
	p->machine = atoi (buf);
	if (scan (fd, buf, BUFSIZ, '\t')) return (1);

	s = buf;
	p->color = 0;
	if (*s == '*') {p->color = 1; ++s;}
	else if (*s == '@') {p->color = 2; ++s;}
	p->aflag = FALSE;
	if (*s == 'a') {p->aflag = TRUE; ++s;}
	else if (*s == 'r') {p->user = 0; p->machine = 100; ++s;}
	p->hcap = atoi (s);

	if (scan (fd, buf, BUFSIZ, '\n')) return (1);
	return (0);
	}

rdfacc (fd)

	{cuser = usertab;
	while (rduser (fd));
	return (0);
	}

int rduser (fd)

	{char buf[BUFSIZ];
	int name, sz, *p;
	user *up;

	if (getfield (fd, buf, BUFSIZ)) return (0);
	if (buf[0] == 0) return (0);
	name = csto6 (buf);
	up = ulookup (name);
	if (up->total)
		{c6tos (name, buf);
		cprint ("Duplicate stats entry for %s\n", buf);
		}
	sz = sizeof(*up)/sizeof(0);
	p = up;
	++p; --sz; sz =- 3; /* ignore percent fields */
	while (--sz >= 0)
		{if (getfield (fd, buf, BUFSIZ)) return (0);
		*p++ = atoi (buf);
		}
	if (getline (fd, buf, BUFSIZ)) return (0);
	return (1);
	}
