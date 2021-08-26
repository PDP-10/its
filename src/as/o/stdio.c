# include "c/c.defs"
int stdin, stdout;
extern int cin, cout;

stdio ()

	{stdin = cin; stdout = cout;
	on (ctrlg_interrupt, INT_IGNORE);
	}

flopen (name, mode) char *name, *mode;

	{int f;
	f = copen (name, mode[0]);
	if (f == OPENLOSS) return (0);
	return (f);
	}

printf (a, b, c, d, e, f, g)
	{cprint (cout, a, b, c, d, e, f, g);}

fprintf (a, b, c, d, e, f, g)
	{cprint (a, b, c, d, e, f, g);}

strcmp (s1, s2) {return (stcmp (s2, s2));}

fclose (f) {cclose (f);}

fread (f, buf, size, number) char buf[];

	{int n;
	n = size * number;
	while (--n >= 0) *buf++ = cgetc (f);
	}

freopen (name, mode, f) char *name, *mode;

	{int i;
	cclose (f);
	i = copen (name, *mode);
	return (i);
	}

getuid () {return (rsuset (074));}

getpw (w, buf) char *buf;
	{c6tos (w, buf);}

nowtime (tv) int tv[];
	{cal foo;
	now (&foo);
	tv[0] = tv[1] = cal2f (&foo);
	}

char *ctime (tv) int tv[];
	{static char buf[100];
	cal foo;
	int f;
	f2cal (tv[0], &foo);
	f = copen (buf, 'w', "s");
	prcal (&foo, f);
	cputc ('\n', f);
	cclose (f);
	return (buf);
	}

unlink (s) {delete (s);}
exit (cc) {cexit (cc);}
