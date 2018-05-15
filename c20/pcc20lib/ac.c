#
/*

	AC - Array of Characters Cluster

	operations:

	ac_new () => ac			create empty array
	ac_alloc (size) => ac		create empty array, preferred size
	ac_create (string) => ac	create with initial value
	ac_xh (ac, c) => c		extend array with character
	ac_trim (ac) => ac		trim excess storage
	ac_fetch (ac, i) => c		fetch character from array
	ac_link (ac) => ac		make new link to array
	ac_unlink (ac)			remove link to array
	ac_puts (ac, f)			print array
	ac_cat (ac, ac) => ac		concatenate arrays
	ac_copy (ac) => ac		copy array
	ac_unlink_string (ac) => ac	remove link to string version
	ac_string (ac) => *char		return string version
	ac_size (ac) => size		return current size of array
	ac_flush (ac)			make array empty
	ac_n () => int			return # of active arrays

*/

struct rep {
	int count;		/* reference count */
	char *s;		/* pointer to actual array */
	int csize;		/* logical size of array */
	int msize;		/* physical size of array (at least csize+1) */
	};

# define ac struct rep*		/* watch usage! */
# define ASIZE 4		/* number of words in rep */
# define initial_size 8		/* default initial allocation */

# define ac_unlink_string acunlstr

# ifdef TOPS20
# rename crealloc "ZREALL"	/* really same as realloc on 20's */
# endif

char *calloc ();
int *salloc ();
char *crealloc ();
ac ac_new();
ac ac_alloc();
ac ac_create();
ac ac_link();
ac ac_cat();
ac ac_copy();

static int count;

/**********************************************************************

	AC_NEW - Create empty array.
	AC_ALLOC - Create empty array, preferred size given.

**********************************************************************/

ac ac_new ()

	{return (ac_alloc (initial_size));}

ac ac_alloc (sz)
	register int sz;

	{register ac a;

	if (sz < 0) sz = 0;
	a = salloc (ASIZE);
	a->count = 1;
	a->csize = 0;
	a->s = calloc (a->msize = ++sz);
	++count;
	return (a);
	}

/**********************************************************************

	AC_CREATE - Create array with initial value.

**********************************************************************/

ac ac_create (s)
	register char *s;

	{register int sz;
	register ac a;

	sz = slen (s);
	a = ac_alloc (sz);
	a->csize = sz;
	cmove (s, a->s, sz);
	return (a);
	}

/**********************************************************************

	AC_XH - Extend Array with Character.

**********************************************************************/

char ac_xh (a, c)
	register ac a;

	{if (a->csize >= a->msize - 1)
		{if (a->s)
			{if (a->msize >= 1000) a->msize += 500;
			else a->msize *= 2;
			a->s = crealloc (a->s, a->msize);
			}
		else	a->s = calloc (a->msize *= 2);
		}
	a->s[a->csize++] = c;
	return (c);
	}

/**********************************************************************

	AC_TRIM - Discard excess storage.

**********************************************************************/

ac ac_trim (a)
	register ac a;

	{if (a->csize < a->msize - 1)
		a->s = crealloc (a->s, a->msize = a->csize + 1);
	return (a);
	}

/**********************************************************************

	AC_FETCH - Fetch Character from Array.

**********************************************************************/

char ac_fetch (a, n)
	register ac a;
	register int n;

	{extern int cerr;
	if (n < 0 || n >= a->csize)
		{cprint (cerr, "Character array bounds error.");
		return (0);
		}
	return (a->s[n]);
	}

/**********************************************************************

	AC_LINK - Create link to array.

**********************************************************************/

ac ac_link (a) ac a;

	{++a->count;
	return (a);
	}

/**********************************************************************

	AC_UNLINK - Remove link to array.

**********************************************************************/

ac_unlink (a)
	register ac a;

	{if (--a->count == 0)
		{if (a->s) cfree (a->s);
		--count;
		sfree (a);
		}
	}

/**********************************************************************

	AC_PUTS - Print array.

**********************************************************************/

ac_puts (a, f, wid)
	register ac a;
	/* 3 args for cprint usage */

	{register char *p;
	register int i;

	p = a->s;
	i = a->csize;
	while (--i >= 0) cputc (*p++, f);
	}

/**********************************************************************

	AC_CAT - Concatenate arrays.

**********************************************************************/

ac ac_cat (a1, a2)
	register ac a1;
	register ac a2;

	{register ac a;
	register int i;

	a = ac_alloc (i = a1->csize + a2->csize);
	a->csize = i;
	cmove (a1->s, a->s, a1->csize);
	cmove (a2->s, a->s + a1->csize, a2->csize);
	return (a);
	}

/**********************************************************************

	AC_STRING - Return string version of array.  The returned
		string is valid only while the array remains linked
		to and unchanged.

**********************************************************************/

char *ac_string (a)
	register ac a;

	{a->s[a->csize] = 0;
	return (a->s);
	}

/**********************************************************************

	AC_UNLINK_STRING - Remove link to string version of array.

**********************************************************************/

ac ac_unlink_string (a) ac a;

	{return (a);
	}

/**********************************************************************

	AC_SIZE - Return current size of array.

**********************************************************************/

int ac_size (a)
	ac a;

	{return (a->csize);}

/**********************************************************************

	AC_FLUSH - Make array empty

**********************************************************************/

ac_flush (a)
	ac a;

	{a->csize = 0;}

/**********************************************************************

	AC_N - Return number of active arrays.

**********************************************************************/

int ac_n ()

	{return (count);}
