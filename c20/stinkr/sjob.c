# include "s.h"

/**********************************************************************

	STINKR
	Code for manipulating inferior process.
	Relatively system-independent code.

**********************************************************************/

int job;			/* some identification of inferior process */
int jch;			/* the inferior process handle (for calls) */
int jpages[NPAGES];		/* "page map" of inferior process */
int *jwindow[NWINDOW];		/* pointer to windows */
int jwpage[NWINDOW];		/* page number of first window */
int jcpage[NWINDOW];		/* current inferior pages in windows */
int jnwindow;			/* next window to be used */
extern int startadr;
extern char oname[];

jinit ()

	{job = j_create (0202027);
	if (job<0) fatal ("unable to create inferior");
	jch = jbhandle (job);
	jpages[0] = 1;
	jnwindow = NWINDOW;

	while (--jnwindow >= 0)
		{jcpage[jnwindow] = -1;
		jwpage[jnwindow] = pg_get (1);
		jwindow[jnwindow] = jwpage[jnwindow] << PAGE_SHIFT;
		}
	jnwindow = 0;
	}

int jread (l)
	{int p, w;
	p = l >> PAGE_SHIFT;
	w = NWINDOW;
	while (--w >= 0)
		if (p == jcpage[w])
			return (jwindow[w][l & PAGE_MASK]);
	if (p >= NPAGES) bletch ("bad page number");
	if (jpages[p] == 0)
		{pgwzero (jch, p);
		jpages[p] = 1;
		}
	pgwindow (jch, p, jwpage[jnwindow]);
	jcpage[jnwindow] = p;
	p = jnwindow;
	if (++jnwindow >= NWINDOW) jnwindow = 0;
	return (jwindow[p][l & PAGE_MASK]);
	}

int jwrite (l, v)
	{int p, w;
	p = l >> PAGE_SHIFT;
	w = NWINDOW;
	while (--w >= 0)
		if (p == jcpage[w])
			{jwindow[w][l & PAGE_MASK] = v;
			return;
			}
	if (p >= NPAGES) bletch ("bad page number");
	if (jpages[p] == 0)
		{pgwzero (jch, p);
		jpages[p] = 1;
		}
	pgwindow (jch, p, jwpage[jnwindow]);
	jcpage[jnwindow] = p;
	p = jnwindow;
	if (++jnwindow >= NWINDOW) jnwindow = 0;
	jwindow[p][l & PAGE_MASK] = v;
	}

jexit ()

	{extern int ninit, iloc[];
	extern name iname[];
	int i;

	for (i=0;i<ninit;++i)	/* run init routines */
		{int loc;
		loc = iloc[i];
		if (loc >= 0) jbrun (job, jch, loc, iname[i]);
		}

	if (oname[0])	/* write output file */
		{int ofd;
		ofd = sopen (oname, 'w', "b");
		if (ofd==OPENLOSS) return;
		jbdump (jch, ofd, startadr);
		cclose (ofd);
		}
	j_kill (job);
	}

