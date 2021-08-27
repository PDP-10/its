# include "c/c.defs"
# define MAXUSER 100

struct _stat {
	int name;	/* user name - in SIXBIT */
	int time;	/* CPU time (in 60th sec) */
	};
typedef struct _stat stat;

struct _user {
	int name;	/* user name - in SIXBIT */
	int count;	/* number of runs */
	int tcount;	/* number of timed runs */
	int time;	/* total time (in 60th secs) */
	};

typedef struct _user user;

user usertab[MAXUSER], *cuser, *euser;
extern int cout;
cal thetime;
int usersize;

main ()

	{int fd;
	usersize = sizeof (*cuser) / sizeof (fd);
	now (&thetime);
	cuser = usertab;
	euser = usertab+MAXUSER;
	addstat ("clu/clu.stat");
	sortuser ();
	fd = copen ("clu/clu.stats", 'w');
	pruser (fd);
	cclose (fd);
	pruser (cout);
	}

addstat (s) char *s;

	{int fd;
	stat cstat;

	fd = copen (s, 'r');
	if (fd == OPENLOSS) return;
	while (!ceof (fd))
		{if (rdstat (fd, &cstat)) continue;
		enterstat (&cstat);
		}
	cclose (fd);
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

pruser (fd)

	{user *up;
	int total_count, total_tcount, total_time;

	cprint (fd, "CLU Statistics as of ");
	prcal (&thetime, fd);
	cprint (fd, "\n\n(times not recorded before 7/10/76)");
	cprint (fd, "\n\nuser\t   count          time     average\n\n");
	total_count = total_tcount = total_time = 0;
	for (up=usertab;up<cuser;++up)
		{char buf[10];
		int rate;
		c6tos (up->name, buf);
		cprint (fd, "%s\t%8d  ", buf, up->count);
		pr60th (up->time, fd);
		if (up->tcount == 0) cprint (fd, "         ---");
		else pr60th (up->time/up->tcount, fd);
		cprint (fd, "\n", rate);
		total_count =+ up->count;
		total_tcount =+ up->tcount;
		total_time =+ up->time;
		}
	cprint (fd, "\ntotals\t%8d  ", total_count);
	pr60th (total_time, fd);
	pr60th (total_time/total_tcount, fd);
	cprint (fd, "\n");
	}

enterstat (p) stat *p;

	{user *up;

	up = ulookup (p->name);
	++up->count;
	if (p->time) ++up->tcount;
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

# define BUFSIZ 20

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

scan (fd, s, n, tc) char *s;

	{char *ebuf;
	int c;

	ebuf = s + (n-1);
	while (c = cgetc (fd))
		{if (c == tc)
			{*s = 0;
			return (0);
			}
		if (c == '\n' || c <= 0) return (1);
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
