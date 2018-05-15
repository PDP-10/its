# include "s.h"
# include "c/its.bits"

/**********************************************************************

	STINKR
	System-dependent code for manipulating inferior process.
	This version for running on ITS.

**********************************************************************/

int jbhandle (j)

	{return (j_ch (j));
	}

pgwzero (jch, p)
	int jch;
	int p;

	/* write a zero page into page P of inferior */
	{corblk (0300000,jch,p,-5,0);
	}

pgwindow (jch, p, mypage)
	int jch;
	int p;
	int mypage;

	/* map inferior page P into my page MYPAGE */
	{corblk (0110000,-1,mypage,jch,p);
	}

jsetup (jch)

	{extern int nsegs, segaorg[], cloc[];
	int n;
	for (n=0;n<nsegs;++n)
		{int lo, hi, l;
		lo = segaorg[n];
		hi = cloc[n] - 1;
		/* initialize segments tables for program's benefit */
		jwrite (020+n, wcons (lo, hi));
		/* touch each page to make sure it is created */
		for (l=lo; l<hi; l=+PAGE_SIZE) jread (l);
		jread (hi);
		}
	}

jbrun (job, jch, loc, n) /* run init routine */
	name n;

	{int sts;
	wuset (jch, UPC, loc);
	if (j_start (job))
		{error ("can't run init routine %x", n);
		return;
		}
	sts = j_wait (job);
	if (sts == -2) return;
	cprint ("Initialization routine %x failed", n);
	if (sts == -3)
		{char *s;
		s = j_val (job);
		cprint (", %s\n", s);
		}
	else cprint (".\n");
	}

jbdump (jch, ofd, startadr)

	{int och, temp;
	och = itschan (ofd);
	pdump (jch, och);
	temp = 0324000000000 | wright (startadr);
	cputi (temp, ofd);
	symwrite (jch, ofd);
	cputi (temp, ofd);
	}

static int checksum;
static int oofd;

souti (w)

	{int hi;
	cputi (w, oofd);
	hi = checksum >> 35;
	checksum = (checksum << 1) + hi + w;
	}

sostart (count, jch, ofd)

	{count = (count + 1) * 2;
	checksum = 0;
	oofd = ofd;
	souti ((-count)<<18);
	souti (015315513316);
	souti ((-count)<<18);
	}

soentry (p, jch, ofd)
	symbol p;

	{name n;
	n = (symname (p) & SYMMASK) | DDTGBIT;
	if (symhkilled (p)) n =| DDTHBIT;
	souti (n);
	souti (symvalue (p));
	}

soend (count, jch, ofd)
	{souti (checksum);
	}

