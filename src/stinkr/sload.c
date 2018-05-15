# include "s.h"

extern int debug, pflag;	/* option flags */
extern int ovflag;		/* assignment being processed */
extern int nlfile;		/* number of loaded files */

int loc;			/* current location */
int creloc[MAXSEGS];		/* current relocation */
int cloc[MAXSEGS];		/* current location */
int segvsiz[MAXSEGS];		/* declared size of segments for
				   current load file */
int segvorg[MAXSEGS];		/* segment virtual origins */
int segaorg[MAXSEGS]		/* segment actual origins */
	{ORIGIN_0, ORIGIN_1};	/* default values */
int cseg 0;			/* current segment */
int nvsegs 2;			/* number of virtual segments for
				   current load file */
int nsegs 2;			/* number of segments */

linit ()
	{int n;
	for (n=0;n<nsegs;++n) cloc[n] = segaorg[n];
	}

lexit ()

	{int n;
	/* print info on segments */
	cprint ("\n --- Segments --- \n\n");
	for (n=0;n<nsegs;++n)
		{int lo, hi, len;
		lo = segaorg[n];
		hi = cloc[n] - 1;
		len = hi-lo+1;
		cprint ("\t%d\t%7o - %7o (%o=%d)\n", n, lo, hi, len, len);
		}
	/* check for overlapping segments */
	for (n=0;n<nsegs-1;++n)
		{int n1;
		for (n1=n+1;n1<nsegs;++n1)
			{int lo,hi,lo1,hi1;
			lo = segaorg[n];
			hi = cloc[n] - 1;
			lo1 = segaorg[n1];
			hi1 = cloc[n1] - 1;
			if (lo<lo1 && hi<lo1) continue;
			if (lo1<lo && hi1<lo) continue;
			cprint ("\nSegments %d and %d overlap.\n", n, n1);
			return;
			}
		}
	}

/* start program */

lsprog ()

	{int n;

	nvsegs = 2;
	segvorg[0] = 0;
	segvorg[1] = 0400000;
	cseg = -1;
	if (nlfile==0) for (n=0;n<nsegs;++n) cloc[n] = segaorg[n];
	for (n=0;n<nsegs;++n)
		{creloc[n] = cloc[n];
		segvsiz[n] = 0;
		}
	++nlfile;
	if (debug)
		{cprint ("\n initial relocation factors");
		for (n=0;n<nsegs;++n)
			cprint ("\n\tsegment %d: %o", n, creloc[n]);
		}
	}

/* end program */

leprog ()

	{int n;

	if (cseg>=0) cloc[cseg] = loc;
	for (n=0;n<nvsegs;++n)
		{int nloc;
		nloc = creloc[n]+segvsiz[n];
		if (nloc>cloc[n]) cloc[n] = nloc;
		}
	}

getval (n, sub) name n; int sub;

	{symbol s;
	int swap, action, flags, global;

	flags = n >> 32;
	swap = (flags >> 3) & 1;
	action = (flags >> 1) & 03;
	global = flags & 01;

	if (!global)
		{error ("reference to local symbol %x not implemented", n);
		return (0);
		}
	s = symfind (n);
	if (symdefined (s))
		{int val;
		val = symvalue (s);
		if (swap) val = wswap (val);
		if (sub) val = -val;
		switch (action) {
		case fa_word:	break;
		case fa_right:	val =& 0777777; break;
		case fa_left:	val =& ~0777777; break;
		case fa_ac:	val =& 0740000000; break;
			}
		return (val);
		}
	if (ovflag)
		{error ("%x undefined in assignment", n);
		return (0);
		}
	symaddfix (s, fixcons (sub, swap, action, loc));
	return (0);
	}

linkreq (n, chain) name n; int chain;

	{int flags, relocate, global, count;
	flags = n >> 32;
	global = flags & 01;
	relocate = chain & 0100000000000;
	chain =& 0777777;
	if (relocate) chain = reloc (chain);
	if (global)
		{symbol s;
		if (pflag) cprint ("\n\tlink for global %x at %o",
				n, chain);
		s = symfind (n);
		count = 1000;
		while (chain)
			{int w;
			if (--count < 0)
				{error ("link chain too long");
				break;
				}
			w = jread (chain);
			if (symdefined (s))
				{if (debug) cprint ("\n\tsmashing");
				jwrite (chain, wcons(wleft(w),
					wright(symvalue(s))));
				}
			else
				{if (debug) cprint ("\n\tfollowing");
				jwrite (chain, w & 0777777000000);
				symaddfix (s, fixcons(0,0,fa_right,chain));
				}
			if (debug) cprint (" link at %o", chain);
			chain = wright(w);
			}
		}
	else
		{if (pflag) cprint ("\n\tlink for local %x at %o",
			n, chain);
		unimplemented ();
		}
	}

dodef (n, val, allowredef) name n;

	{int flags, rleft, rright, global, halfkill;
	flags = n >> 32;
	halfkill = flags & 010;
	rleft = flags & 04;
	rright = flags & 02;
	global = flags & 01;

	if (pflag)
		{if (allowredef) cprint ("\n\tredefine symbol");
		else cprint ("\n\t  define symbol");
		if (halfkill) cprint (" half-killed");
		if (global) cprint (" global");
			else cprint ("  local");
		cprint (" %x = ", n, val);
		}
	if (rright) val = wcons(wleft(val),reloc(wright(val)));
	if (rleft) val = wcons(reloc(wleft(val)),wright(val));
	if (pflag) cprint ("%o", val);
	if (global)
		{symbol s;
		s = symfind (n);
		if (symdefined (s) && symvalue (s) != val && !allowredef)
			error ("%x multiply defined", n);
		else symdef (s, val);
		if (halfkill) symhkill (s);
		}
	}

setloc (l)
	{loc = l;
	if (cseg >= 0) cloc[cseg] = loc;
	}

setaloc (l)
	{if (cseg >= 0) cloc[cseg] = loc;
	loc = l;
	cseg = -1;
	if (debug) cprint ("\n\tswitching to absolute mode");
	}

setrloc (l)

	{int n, o;

	n = nvsegs;
	while (--n > 0) if (l >= segvorg[n]) break;
	o = l - segvorg[n];
	if (n != cseg) if (cseg >= 0) cloc[cseg] = loc;
	cseg = n;
	loc = creloc[n] + o;
	}

reloc (l)

	{int n, o;

	n = nvsegs;
	while (--n >= 0) if ((o = l - segvorg[n]) >= 0) break;
	if (o<0)
		{error ("virtual address %o not in any segment", l);
		return (0);
		}
	n = creloc[n] + o;
	if (n<0 || n>=01000000)
		{error ("address wraparound");
		n =& 0777777;
		}
	return (n);
	}

char *actnam[] {"word", "right half of", "left half of", "AC of"};

dofixup (f, val) fixup f;

	{int lc, action, sub, swap;
	sub = fixsub (f);
	swap = fixswap (f);
	action = fixact (f);
	lc = fixloc (f);
	if (debug) cprint ("\n\tfixup %s %o to %o",
		actnam[action], lc, val);
	if (swap) {val = wswap (val); if (debug) cprint (" (swap)");}
	if (sub) {val = -val; if (debug) cprint (" (subtract)");}
	switch (action) {
	case fa_word:	break;
	case fa_right:	val =& 0777777; break;
	case fa_left:	val =& ~0777777; break;
	case fa_ac:	val =& 0740000000; break;
		}
	jwrite (lc, jread (lc) + val);
	}
