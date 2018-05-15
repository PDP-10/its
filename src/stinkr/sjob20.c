# include "s.h"

# define _CLOSF SYSCLOSF

/**********************************************************************

	STINKR
	System-dependent code for manipulating inferior process.
	This version for running on TOPS-20.

**********************************************************************/

int j_create (jname)

	{int j;
	j = _CFORK (0200000000000, 0);
		/* create process, with my capabilities */
	if (j >= 0600000) return (-2);
	return (j);
	}

int jbhandle (j)

	{return (j);
	}

int j_kill (j)

	{_KFORK (j);
	}

int pg_get (n)

	{static int space[(NWINDOW+1)*PAGE_SIZE];
		/* space used for windows */
	static int *sp {space};
		/* pointer to next available page */

	int i, pn;
	i = sp;
	if (i & PAGE_MASK)	/* sp hasn't been aligned yet */
		{i =+ PAGE_MASK;
		i =& ~PAGE_MASK;
		}
	pn = i >> PAGE_SHIFT;	/* page number of allocated page */
	i =+ PAGE_SIZE;		/* advance to next page */
	sp = i;
	return (pn);
	}

pgwzero (jch, p)
	int jch;
	int p;

	/* write a zero page into page P of inferior */
	{; /* not needed on TOPS-20 */
	}

pgwindow (jch, p, mypage)
	int jch;
	int p;
	int mypage;

	/* map inferior page P into my page MYPAGE */
	{_PMAP (wcons(jch,p), wcons(0400000,mypage), wcons(0140000,0));
	}

jsetup (jch)

	{extern int nsegs, segaorg[], cloc[];
	int n;

	/* append symbol table to highest segment */
	symwrite (jch, 0);
	/* initialize segment tables for program's benefit */
	for (n=0;n<nsegs;++n)
		{int lo, hi;
		lo = segaorg[n];
		hi = cloc[n] - 1;
		jwrite (020+n, wcons (lo, hi));
		}
	}

jbrun (j, jch, loc, n) /* run init routine */
	name n;

	{int sts, code;
	_SFORK (j, loc);
	_WFORK (j);
	sts = _RFSTS (j);
	code = (sts >> 18) & 07777;
	if (code == 2) return;
	cprint ("Initialization routine %x failed, ", n);
	if (code == 3)
		{int number;
		number = sts & 0777777;
		cprint ("error number %d.\n", number);
		}
	else cprint ("status %d.\n", code);
	}

jbdump (jch, ofd, startadr)

	{int jfn;
	jfn = cjfn (ofd);
	_CLOSF (wcons (0400000, jfn)); /* do not release */
	jwrite (0120, wcons (jread (0121), startadr));
	_SEVEC (jch, wcons (0254000, startadr));
	_SSAVE (wcons (jch, jfn), wcons (-NPAGES, 0360000));
	}

static int where;

souti (w)

	{jwrite (where, w);
	where = where + 1;
	}

sostart (count, jch, ofd)

	{extern int cloc[], nsegs;
	int pat;
	where = cloc[nsegs-1];
	count =* 2;
	count =+ 2*2; /* pat.. and program entries */
	pat = where + count;
	if (pat%2 == 1) /* make sure patch area on even address */
		++pat;
	jwrite (0116, wcons (-count, where));
	jwrite (0121, where+count);
	jwrite (0133, where+count-1);
	cloc[nsegs-1] = pat+32; /* leave room for DDT patch area */
	souti (rj40 (rdname ("pat..")) | DDTGBIT);
	souti (pat);
	}

soentry (p, jch, ofd)
	symbol p;

	{name n;
	n = symname (p) & SYMMASK;
	n = rj40 (n);
	n =| DDTGBIT;
	if (symhkilled (p)) n =| DDTHBIT;
	souti (n);
	souti (symvalue (p));
	}

soend (count, jch, ofd)

	{;
	souti (017573520526);
	souti (wcons (-0100, 0100));
	}

rj40 (n) /* right justify a SQUOZE coded symbol (remove trailing blanks) */

	{for (;;)
		{int c;
		c = n % 40;	/* trailing character */
		if (c) break;	/* not a blank */
		n =/ 40;	/* remove trailing character */
		}
	return (n);
	}
