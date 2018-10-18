# include "clib/c.defs"
# include "clib/its.bits"

/**********************************************************************

	C10TPR - Printing Routine for C Timer Package
	*ITS*

**********************************************************************/

# rename null "$NULL$"
# rename timing "TIMING"
# rename timtab "TIMTAB"
# rename timep "TIMEP"
# rename tprt "TPRT"

struct _tentry {int *proc, pname, count, time;};
# define tentry struct _tentry

extern int timing;
extern tentry timtab[], *timep;
extern int cout;

/*	All times are kept in machine-dependent Units
	and converted upon output to the appropriate
	units.
*/

tprt ()

	{int	fout,		/* output file */
		total_time,	/* total CPU time used */
		smallest,	/* smallest average time */
		time,		/* time used by current routine */
		average,	/* average time of current routine */
		percent,	/* percentage CPU time, current routine */
		cpercent,	/* cumulative percentage CPU time */
		ctime,		/* cumulative CPU time */
		count,		/* number of calls, current routine */
		ncalls,		/* total number of calls */
		namep,		/* pointer to current routine name */
		nulltime,	/* time to call null routine */
		t,
		c;

	tentry *ip, *ip1;

	t = rsuset (URUNT);
	c = 50;
	timing = -1;
	while (--c >= 0)
		{null ();
		null ();
		null ();
		null ();
		null ();
		null ();
		null ();
		null ();
		null ();
		null ();
		null ();
		null ();
		null ();
		null ();
		null ();
		null ();
		null ();
		null ();
		null ();
		null ();
		}
	timing = 0;

	fout = copen ("timer.output", 'a');
	if (fout<0) fout = copen ("timout", 'w');
	if (fout<0) fout = cout;

	cprint (fout, "\n\n\n	*** TIMING INFORMATION ***\n\n");
	cprint (fout, "TIME(usec)   PERCENT    CUM. %%  NO. CALLS   AVG. TIME  ROUTINE NAME\n\n");

	/* null entry should be last */

	--timep;
	nulltime = timep->time / timep->count;

	/* sort entries in order of decreasing CPU time used */

	for (ip=timtab;ip<timep;++ip)
	  for (ip1 = ip+1;ip1<timep;++ip1)
	    if (ip1->time > ip->time)
		bswap (ip, ip1, 4);

	total_time = 0;
	for (ip=timtab;ip<timep;++ip)
	  total_time =+ ip->time;

	ncalls = 0;
	smallest = 10000;	/* big number */
	ctime = 0;
	for (ip=timtab;ip<timep;++ip)
	  {time = ip->time;
	  ctime =+ time;
	  percent = (time * 1000) / total_time;
	  cpercent = (ctime * 1000) / total_time;
	  count = ip->count;
	  ncalls =+ count;
	  namep = (ip->pname) | 0440700000000;
	  average = time/count;
	  if (average<smallest && average>0) smallest=average;
	  cprint (fout, "%10d%8d.%1d%8d.%1d",
		u2mic (time), percent/10, percent%10,
		      cpercent/10, cpercent%10);
	  cprint (fout, "%11d%12d  ", count, u2mic (average));
	  while (c = ildb (&namep)) cputc (c, fout);
	  cputc ('\n', fout);
	  }

	if (smallest<nulltime) nulltime=smallest;
	time = ncalls * nulltime;
	percent = (time * 1000) / total_time;	/* percent * 10 */

	cprint (fout, "\nTOTAL TIME = %d MSEC.\n", u2mil (total_time));
	cprint (fout, "PROC. CALL TIME = %d USEC.\n", u2mic (nulltime));
	cprint (fout, "NO. CALLS = %d\n", ncalls);
	cprint (fout, "EST. CALL OVERHEAD = %d.%d %%\n",
		percent/10, percent%10);

	cclose (fout);
	}

u2mil (t)	/* convert Units to Milliseconds */

	{return ((t * 407) / 100000);}

u2mic (t)	/* convert Units to Microseconds */

	{return ((t * 407) / 100);}

bswap (p, q, n)	int *p, *q;

	{int t;

	while (--n >= 0)
		{t = *p;
		*p++ = *q;
		*q++ = t;
		}
	}

null () {;}
