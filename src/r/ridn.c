# include "r.h"

/*

	R Text Formatter
	Identifier Cluster

	Copyright (c) 1976, 1977 by Alan Snyder


	ROUTINES:

	i = make_idn (s)	convert CONSTANT string to idn
	i = make_ac_idn (ac)	convert ac to idn
	s = idn_string (i)	convert idn to string
	idn_init ()		initialization routine

	REPRESENTATION OF AN IDN:

	An IDN is represented as an integer index into
	the array NAMETAB.  The NAMETAB entry corresponding
	to the integer contains the string form of the
	identifier.  The string form is related to the
	NAMETAB entry using a hash table.

*/

int	hash_tab [max_idn];	/* entries initialized to -1 */
int	nidn {0};		/* number of idns */
int	*ehp;			/* points to end of hash_tab */

char	*nametab [max_idn];	/* holds string form of idns */

# define BLKSIZE 1024		/* allocation size for cstore */

char	*ccs {0};		/* points to next unused element of cstore */
char	*ecs {0};		/* points to last element of cstore */

int	Zncsused {0};		/* size of cstore used */
int	Zncsalloc {0};		/* size of cstore allocated */
int	Zncspure {0};		/* size of pure strings */

char	ctab[128] {		/* for alpha check and case mapping */

	0,	0,	0,	0,	0,	0,	0,	0,
	0,	0,	0,	0,	0,	0,	0,	0,
	0,	0,	0,	0,	0,	0,	0,	0,
	0,	0,	0,	0,	0,	0,	0,	0,
	0,	0,	0,	0,	0,	0,	0,	0,
	0,	0,	0,	0,	0,	0,	0,	0,
	'0',	'1',	'2',	'3',	'4',	'5',	'6',	'7',
	'8',	'9',	0,	0,	0,	0,	0,	0,
	0,	'a',	'b',	'c',	'd',	'e',	'f',	'g',
	'h',	'i',	'j',	'k',	'l',	'm',	'n',	'o',
	'p',	'q',	'r',	's',	't',	'u',	'v',	'w',
	'x',	'y',	'z',	0,	0,	0,	0,	'_',
	0,	'a',	'b',	'c',	'd',	'e',	'f',	'g',
	'h',	'i',	'j',	'k',	'l',	'm',	'n',	'o',
	'p',	'q',	'r',	's',	't',	'u',	'v',	'w',
	'x',	'y',	'z',	0,	0,	0,	0,	0
	};

/**********************************************************************

	IDN_INIT - Initialization Routine

**********************************************************************/

int	idn_init ()

	{register int i;

	for (i=0;i<max_idn;++i) hash_tab[i] = -1;
	ehp = hash_tab+max_idn;
	}

/**********************************************************************

	MAKE_IDN - Convert CONSTANT lower-case string to identifier.

**********************************************************************/

idn	make_idn (s)	char s[];

	{int i, v, *h, sz;

	i = ihash (s, &sz);

	/* look for identifier in hash table */

	h = &hash_tab[i % max_idn];
	while ((v = *h) >= 0)
		if (stcmp (nametab[v], s)) return (v);
		else if (++h >= ehp) h = hash_tab;

	/* not there, so enter it */

	nametab[v = *h = nidn++] = s;
	if (nidn >= max_idn) fatal ("hash table overflow");
	Zncspure =+ sz;
	return (v);
	}

/**********************************************************************

	MAKE_AC_IDN - Convert AC to identifier.

**********************************************************************/

idn	make_ac_idn (a)
	ac a;

	{char *s;
	int i, *h, v, sz;

	s = ac_string (a);
	i = ihshcopy (s, &sz);

	/* look for identifier in hash table */

	h = &hash_tab[i % max_idn];
	while ((v = *h) >= 0)
		if (stcmp (nametab[v], ccs)) return (v);
		else if (++h >= ehp) h = hash_tab;

	/* not there, so enter it */

	nametab[v = *h = nidn++] = ccs;
	ccs =+ sz;
	if (nidn >= max_idn) fatal ("hash table overflow");
	Zncsused =+ sz;
	return (v);
	}

/**********************************************************************

	IHSHCOPY

**********************************************************************/

int ihshcopy (s, psz)
	char *s;
	int *psz;

	/* Compute hash code for string.  Also copy string to
	   cstore, converting upper case to lower case. */

	{char *p, *q;
	int i, c, shift;

	q = s;
	p = ccs;
	shift = i = 0;
	while (c = *q++)
		{if ((c = ctab[c]) == 0)
			{error ("invalid character in name '%s'", s);
			c = 'x';
			}
		i =+ (c << shift);
		if (++shift == 8) shift = 0;
		if (p >= ecs)	/* leave room for trailing NUL */
			{char *b, *np;
			int sz;
			sz = max (BLKSIZE, (p-ccs)*2);
			np = b = calloc (sz);
			Zncsalloc =+ sz;
			while (ccs < p) *np++ = *ccs++;
			ccs = b;
			ecs = ccs + (sz-1);
			p = np;
			}
		*p++ = c;
		}
	if (i < 0) i = -i;
	*p++ = 0;
	*psz = p-ccs;
	return (i);
	}

/**********************************************************************

	IHASH

**********************************************************************/

int ihash (s, psz)
	char *s;
	int *psz;

	/* Compute hash code for lower-case string. */

	{register char *q;
	int i, c, shift, sz;

	q = s;
	sz = shift = i = 0;
	while (c = *q++)
		{i =+ (c << shift);
		if (++shift == 8) shift = 0;
		++sz;
		}
	if (i < 0) i = -i;
	*psz = sz+1;
	return (i);
	}

/**********************************************************************

	IDN_STRING - Get string form of identifier.

**********************************************************************/

# ifndef USE_MACROS

char *idn_string (i)

	{if (i<0 || i>=nidn)
		{barf ("IDN_STRING: bad identifier %d", i);
		return ("bad");
		}
	return (nametab[i]);
	}

# endif
