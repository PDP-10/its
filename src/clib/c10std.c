# include "c.defs"
# include "stdio.h"

/**********************************************************************

	STDIO.C - 'Standard I/O' Simulator for ITS

	Must call STDIO to initialize.

**********************************************************************/

int *stdin, *stdout, *stderr;
extern int cin, cout, cerr;

stdio ()

	{stdin = cin; stdout = cout; stderr = cerr;
	on (ctrlg_interrupt, INT_IGNORE);
	}

flopen (name, mode)
	char *name, *mode;

	{int f;
	f = copen (name, mode[0]);
	if (f == OPENLOSS) return (0);
	return (f);
	}

int fgetc (f)

	{int c;
	c = cgetc (f);
	if (c < 0) return (EOF);
	if (c == 0 && ceof (f)) return (EOF);
	return (c);
	}

int fgeth ()

	{return (fgetc (cin));}

int peekc (f)

	{int c;
	c = cgetc (f);
	if (c < 0) return (EOF);
	if (c == 0 && ceof (f)) return (EOF);
	ungetc (c, f);
	return (c);
	}

int pkchar ()

	{return (peekc (cin));}

printf (a, b, c, d, e, f, g)
	{cprint (cout, a, b, c, d, e, f, g);}

fprintf (a, b, c, d, e, f, g)
	{cprint (a, b, c, d, e, f, g);}

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

/**********************************************************************

	STRING ROUTINES

**********************************************************************/

strcmp (s1, s2)
	char *s1, *s2;

	{int c1, c2;
	while (TRUE)
		{c1 = *s1++;
		c2 = *s2++;
		if (c1 < c2) return (-1);
		if (c1 > c2) return (1);
		if (c1 == 0) return (0);
		}
	}

strcpy (dest, source)
	char *dest, *source;

	{stcpy (source, dest);}

strcat (dest, source)
	char *dest, *source;

	{while (*dest) ++dest;
	stcpy (source, dest);
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
