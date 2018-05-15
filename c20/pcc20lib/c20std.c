# include <c.defs>
# include <stdio.h>

/**********************************************************************

	STDIO.C	- 'Standard I/O' Simulator

	Note: Must # include <stdio.h>.
	To link with STINKR, say X <C>STDIO instead of X <C>CLIB.
	** Not complete. **

	Routines implemented, either here, by redefinition (in STDIO.H),
	or in the default TOPS-20 library:

	fileptr	= fopen	(name, mode)
	fileptr	= freopen (name, mode, fileptr)
	c = getc (fileptr)
	c = fgetc (fileptr)
	i = getw (fileptr)
	c = putc (c, fileptr)
	c = fputc (f, fileptr)
	fclose (fileptr)
	fflush (fileptr)
	exit (errcode)
	b = feof (fileptr)
	c = getchar ()
	putchar	(c)
	s = gets (s)
	s = fgets (s, n, fileptr)
	puts (s)
	fputs (s, fileptr)
	putw (i, fileptr)
	ungetc (c, fileptr)
	printf (format,	a1, ...)
	fprintf	(fileptr, format, a1, ...)
	sprintf	(buf, format, a1, ...)
	scanf (format, a1, ...)
	fscanf (fileptr, format, a1, ...)
	sscanf (s, format, a1, ...)
	fread (ptr, itemsize, nitems, fileptr)	 these use cgeti, cputi 
	fwrite (ptr, itemsize, nitems, fileptr)
**	fcread (ptr, itemsize, nitems, fileptr)	 these use cgetc, cputc 
**	fcwrite (ptr, itemsize, nitems, fileptr)
	rewind (fileptr)
	fileno (fileptr)
	fseek (fileptr, offset, mode)
	i = ftell (fileptr)
	atof (s)		(in ATOI.C)
	ftoa (d, s, p, f)	(in ATOI.C)
	unlink (s)
	i = strcmp (s1,	s2)
	strcpy (dest, source)
	strcat (dest, source)
	i = strlen (s)
	b = isalpha (c)
	b = isupper (c)
	b = islower (c)
	b = isdigit (c)
	b = isspace (c)
	c = toupper (c)
	c = tolower (c)
	uid = getuid ()
	buf = getpw (uid, buf)
		- writes user name into	buf
	time (int[2])
		- write	current	time into array
	s = ctime (int[2])
		- convert time to string format
	p = calloc (num, size)
	cfree (ptr)	(in ALLOC.C)

	Routines not implemented:

	ferror, system, tmpnam, abort, intss, wdleng, nargs, setbuf, gcvt

	See <C.LIB>CPRINT.C for information about PRINTF formats.

** = hack routines to provide functionality not otherwise available

**********************************************************************/

extern int cin, cout, cerr;

stdio () {;}	/* for historical reasons */

FILE *fopen (name, mode) /* this is renamed */
	char *name, *mode;

	{register int f;
	f = copen (name, *mode, mode + 1);
	if (f == OPENLOSS) return (NULL);
	return (f);
	}

char fgetc (f)

	{register char c;
	if ((c = cgetc (f)) == 0 && ceof (f)) return (EOF);
	return (c);
	}

char getchar () /* this is renamed */

	{return	(fgetc (cin));}

char peekc (f)

	{int c;
	if ((c = cgetc (f)) == 0 && ceof (f)) return (EOF);
	ungetc (c, f);
	return (c);
	}

char pkchar ()

	{return	(peekc (cin));}

char *gets (s)
	char *s;

	{register char c, *sp;
	sp = s;
	while ((c = fgetc (stdin)) != EOF)
		if (c == '\n') break;
		else *sp++ = c;
	*sp = 0;
	if (c == EOF && sp == s) return (NULL);
	return (s);
	}

char *fgets (s,	n, f)
	char *s;
	FILE *f;

	{register char *sp;
	register int c;
	sp = s;
	while (--n > 0 && (c = fgetc (f)) != EOF)
		if ((*sp++ = c)	== '\n') break;
	*sp = 0;
	if (c == EOF &&	sp == s) return	(NULL);
	return (s);
	}

fputs (s, f)
	char *s;
	FILE *f;

	{register int c;
	while (c = *s++) fputc (c, f);
	}

printf (a, b, c, d, e, f, g, h, i, j, k, l, m, n)
	{cprint	(cout, a, b, c,	d, e, f, g, h, i, j, k, l, m, n);}

fprintf	(a, b, c, d, e,	f, g, h, i, j, k, l, m, n, o) /* this is renamed */
	{cprint	(a, b, c, d, e,	f, g, h, i, j, k, l, m, n, o);}

sprintf	(s, a, b, c, d,	e, f, g, h, i, j, k, l, m, n)
	char *s;
	{register int fp;
	fp = copen (s, 'w', "s");
	cprint (fp, a, b, c, d,	e, f, g, h, i, j, k, l, m, n);
	cclose (fp);
	}

pscanf (fmt, a, b, c, d, e, f, g, h, i, j, k, l, m)
	char *fmt;
	{return (cscanf (cin, fmt, a, b, c, d, e, f, g, h, i, j, k, l, m));
	}

fscanf (fp, fmt, a, b, c, d, e, f, g, h, i, j, k, l, m)
	FILE *fp; char *fmt;
	{return (cscanf (fp, fmt, a, b, c, d, e, f, g, h, i, j, k, l, m));
	}

sscanf (s, fmt, a, b, c, d, e, f, g, h, i, j, k, l, m)
	char *s, *fmt;
	{int fp, result;
	fp = copen (s, 'r', "s");
	result = cscanf (fp, fmt, a, b, c, d, e, f, g, h, i, j, k, l, m);
	cclose (fp);
	return (result);
	}

fclose (f) {cclose (f);}

getw (f)
	FILE *f;

	{int i;
	i = cgeti (f);
	if (ceof (f)) return (EOF);
	return (i);
	}

fread (buf, size, number, f)
	int *buf;
	FILE *f;

	{register int i, j, k;
	for (i = 0; i < number; ++i)
		{j = size;
		while (--j >= 0)
			{k = cgeti (f);
			if (ceof (f)) return (i);
			*buf++ = k;
			}
		}
	return (i);
	}

fwrite (buf, size, number, f)
	register int *buf, size;
	FILE *f;

	{size *= number;
	while (--size >= 0) cputi (*buf++, f);
	return (number);
	}

fcread (buf, size, number, f)
	char *buf;
	FILE *f;

	{register int i, j, k;
	for (i = 0; i < number; ++i)
		{j = size;
		while (--j >= 0)
			{k = cgetc (f);
			if (ceof (f)) return (i);
			*buf++ = k;
			}
		}
	return (i);
	}

fcwrite (buf, size, number, f)
	register char *buf;
	register int size;
	FILE *f;

	{size *= number;
	while (--size >= 0) cputc (*buf++, f);
	return (number);
	}

FILE *freopen (name, mode, f)
	char *name, *mode;

	{int i;
	cclose (f);
	i = copen (name, *mode, mode + 1);
	if (i == OPENLOSS) return (NULL);
	return (i);
	}

fileno (f)
	FILE *f;
	{return (cjfn (f));
	}

/**********************************************************************

	STRING ROUTINES

**********************************************************************/

strcmp (s1, s2)
	register char *s1, *s2;

	{register int c1, c2;
	while ((c1 = *s1++) == (c2 = *s2++) && c1);
	if (c1 < c2) return (-1);
	else if (c1 == 0) return (0);
	else return (1);
	}

strcpy (dest, source)
	char *dest, *source;

	{stcpy (source,	dest);}

strcat (dest, source)
	register char *dest;
	char *source;

	{while (*dest) ++dest;
	stcpy (source, dest);
	}

int strlen (s)
	char *s;

	{register char *e;
	e = s;
	while (*e) ++e;
	return (e - s);
	}

/**********************************************************************

	CHARACTER ROUTINES

**********************************************************************/

int isalpha (c)
	char c;

	{return	((c >= 'a' && c	<= 'z')	|| (c >= 'A' &&	c <= 'Z'));}

int isupper (c)
	char c;

	{return	(c >= 'A' && c <= 'Z');}

int islower (c)
	char c;

	{return	(c >= 'a' && c <= 'z');}

int isdigit (c)
	char c;

	{return	(c >= '0' && c <= '9');}

int isspace (c)
	char c;

	{return	(c == '	' || c == '\t' || c == '\n' || c == '\p');}

int tolower (c)
	char c;

	{if (c >= 'A' && c <= 'Z') c += ('a' - 'A');
	return (c);
	}

int toupper (c)
	char c;

	{if (c >= 'a' && c <= 'z') c -= ('a' - 'A');
	return (c);
	}

/**********************************************************************

	OBSCURE	ROUTINES

**********************************************************************/

int getuid ()

	{int un, x;
	SYSGJI (-1, halves (0777777, x = &un), 2);
		/* GETJI - read	user number */
	return (un);
	}

char *getpw (un, buf)
	char *buf;

	{SYSDIRST (mkbptr (buf), un);
	return (buf);
	}

nowtime	(tv)
	int tv[];

	{cal foo;
	now (&foo);
	tv[0] =	tv[1] =	cal2f (&foo);
	}

char *ctime (tv) int tv[];

	{static	char buf[100];
	cal foo;
	int f;
	f2cal (tv[0], &foo);
	f = copen (buf,	'w', "s");
	prcal (&foo, f);
	cputc ('\n', f);
	cclose (f);
	return (buf);
	}

unlink (s) {delete (s);}
exit (cc) {cexit (cc);}
fflush (f) {cflush (f);}
rewind (f) {rew(f);}
char *calloc (num, size) {return (salloc (num*size));}
