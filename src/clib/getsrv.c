# include "c.defs"

/**********************************************************************

	GETSRV - Lookup name in table of Arpanet Servers
	Currently runs only on ITS machines (needs a particular file).
	Requires upper case string.

**********************************************************************/

# define TABLESIZE 10000

int getsrv (s) char *s; /* return -1 if bad */

	{static int *p;
	int n, *nmtab;
	/* first check for decimal host number */
	n = atoi (s);
	if (n > 0) return (n);
	/* if not a number, must search the table of host names */
	if (!p) /* host file not read in yet */
		{int f, *q, *e;
		char *ss;
		p = calloc (TABLESIZE);
		ss = "sysbin;hosts1 >";
		f = copen (ss, 'r', "b");
		if (f == OPENLOSS)
			{cprint ("Unable to find host table: %s\n", ss);
			return (-1);
			}
		e = p + TABLESIZE;
		q = p;
		while (!ceof (f) && q<e) *q++ = cgeti (f);
		cclose (f);
		}
	nmtab = p+p[6];	/* name table */
	n = *nmtab++;
	while (--n >= 0)
		{int nte, nm, bp;
		nte = *nmtab++;
		nm = nte & 0777777; /* index of name in table */
		nm = p + nm; /* pointer to name in table */
		bp = 0440700000000 | nm; /* byte pointer to name */
		if (_gmatch (bp, s)) /* found entry */
			{int num;
			num = nte >> 18; /* index of numtab entry in table */
			if (p[num+2]<0) /* it's a server */
				return (p[num]);
			return (-1);	
			}
		}
	return (-1);
	}

_gmatch (bp, s) char *s;

	{int c;
	while (c = ildb (&bp))
		if (c != *s++) return (FALSE);
	return (*s == 0);
	}			


#ifdef testing
main ()

	{char buf[100];
	int n;

	while (TRUE)
		{cprint ("Enter name:");
		gets (buf);
		n = getsrv (buf);
		cprint ("Name=%s,Number=%d\n", buf, n);
		}
	}

#endif
