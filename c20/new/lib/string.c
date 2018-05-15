# include <stdio.h>

/* 	Useful functions for character strings	*/


/**********************************************************************

	SCONCAT - String Concatenate

	concatenate strings S1 ... Sn into buffer B
	return B

**********************************************************************/


char *sconcat (b, n, s1)	/* any number of string args possible */
char *b, *s1;
{
	char **s;
	register char *p, *q;
	register int c;

	q = b;
	s = &s1;

	while (--n >= 0) {
		p = *s--;
		while (c = *p++) *q++ = c;
	}

	*q = 0;
	return (b);
}

/**********************************************************************

	SLOWER - Convert String To Lower Case

**********************************************************************/

slower (s)
register char *s;
{
	register int c;
	while (c = *s) *s++ = lower (c);
}

/****************************************************************

	CMOVE, SMOVE - copy non-overlapping regions

****************************************************************/

smove (from, to, n)
int *from, *to, n;
{
	if (n > 0) blt (from, to, n);
}

cmove (from, to, n)
char *from, *to;
int n;
{
	if (n > 0) blt (from, to, n);
}

/****************************************************************

	CFILL, SFILL - fill a region with a given value

****************************************************************/

sfill (start, count, val)
int *start, count, val;
{
	if (count > 0) {
		*start = val;
		if (--count > 0) blt (start, start + 1, count);
	}
}

cfill (start, count, val)
char *start, val;
int count;
{
	if (count > 0) {
		*start = val;
		if (--count > 0) blt (start, start + 1, count);
	}
}
