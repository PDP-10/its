# include <stdio.h>

/**********************************************************************

	FILES.C - This file contains useful stuff related to files

	fdmap (p, f)	- p is a file spec string possibly containing
			  wildcard characters. Call the function f(s)
			  for each existing file matching the pattern p.
			  The argument s is the actual name of the file
			  currently being processed.

	exparg 		- given an argument vector possibly containing
			  wildcarded filenames, convert it to an argument
			  vector with all wildcarded filenames expanded.
			  Function return value is the new argc.


The next two are just specific uses of the routines in C20FNM.C

	outfnm		- make an output file name, given an input file 
			  name and a suffix.

	apfname		_ generate a file name with a specific suffix.


**********************************************************************/


# define QUOTE 22	/* control-V */
# define TRUE  1
# define FALSE 0

/**********************************************************************

	FDMAP (P, F)

	Call F(S) for all filenames S that match the pattern P.

**********************************************************************/

fdmap (p, f)
char *p;
int (*f)();
{
	register int jfn, rc;
	char buf[100];

	fnstd (p, buf);
	rc = jfn = _GTJFN (halves (0100121, 0),
					/* GJ%OLD+GJ%IFG+GJ%FLG+GJ%SHT */
			     mkbptr (buf));
	while ((rc & 0600000) == 0) {
		_JFNS (mkbptr (buf), jfn & 0777777, 0);
		(*f)(buf);
		_CLOSF (jfn);
		rc = _GNJFN (jfn);
	}
}

/**********************************************************************

	EXPAND ARGUMENT VECTOR CONTAINING FILE NAME PATTERNS
	TOPS-20 Version

**********************************************************************/

static char **next;
static char *bufp;

int exparg (argc, argv, outv, buffer)
char *argv[], *outv[], buffer[];
{
	register int i;
	int expfile();
	register char *s;

	bufp = buffer;
	next = outv;
	i = 0;
	while (i < argc) {
		s = argv[i++];
		if (expmagic (s)) fdmap (s, expfile);
		else *next++ = s;
	}
	return (next - outv);
}

static int expmagic (s)		/* does it contain magic pattern chars? */
register char *s;
{
	register int c;
	while (c = *s++) switch (c) {
		case '%':
		case '*':	return (TRUE);
		case QUOTE:	if (*s) ++s; continue;
	}
	return (FALSE);
}

static expfile (s)
register char *s;
{
	*next++ = bufp;
	while (*bufp++ = *s++);
}

/**********************************************************************

	APFNAME - Append suffix to file name

**********************************************************************/

char *apfname (dest, source, suffix)
char *dest, *source, *suffix;
{
	fnsfd (dest, source, 0, 0, 0, suffix, "", "");
	return (dest);
}

/**********************************************************************

	OUTFNM - Make output file name

**********************************************************************/

char *outfnm (dest, source, suffix)
char *dest, *source, *suffix;
{
	fnsfd (dest, source, "", 0, 0, suffix, "", "");
	return (dest);
}
