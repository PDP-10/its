# include "o.h"

/*
 * o5 - static evaluator and minimax
 *
 */

extern int debug, movnum, mvnhack;

/**********************************************************************

	SEVAL - Static Evaluator

**********************************************************************/

int mmquantile 100;

int seval (b, c, o)
	board b;
	color c, o;

	{register int ccount, ocount;

	ccount = bscore (b, c);
	ocount = bscore (b, o);
	return (((ccount - ocount) * mmquantile) / (ccount + ocount));
	}

/**********************************************************************

	MEVAL - minimax move evaluator

**********************************************************************/

int mdepth 0;
int mmdepth;

int meval (b,c,o,p,alpha)

	{board a;
	int minmove;

	cpybrd (a,b);
	putmov (a,c,p);
	if (++mdepth == mmdepth) minmove = seval (a,c,o);
	else
		{minmove = 1000;
			{register position *qq, q;
			extern position trymov[];
			qq = trymov;
			while ((q = *qq++) >= 0) if (ismove (a,o,q))
				{register int temp;
				temp = -meval(a,o,c,q,-minmove);
				if (temp<minmove)
					{minmove=temp;
					if (minmove<alpha) break;
					}
				}
			}
		if (minmove==1000)	/* o forfeits */
			{minmove = -1000;
				{register position *qq, q;
				extern position trymov[];
				qq = trymov;
				while ((q = *qq++) >= 0) if (ismove (a,c,q))
					{register int temp;
					temp = meval(a,c,o,q,minmove);
					if (temp>minmove) minmove=temp;
					}
				}
			if (minmove == -1000)	/* c forfeits */
				minmove = seval(a,c,o);
			}
		}
	--mdepth;
	if (debug>1)
		{printf ("%2d ", mdepth);
		putn (mdepth);
		putpos (p, stdout);
		printf (" %d\n", minmove);
		}
	return (minmove);
	}

# define C CORNERSCORE
# define E EDGESCORE
# define P POINTSCORE
# define I INTERIORSCORE
# define D DANGERSCORE

fastchar ssqval[100] {
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	0, C, E, E, E, E, E, E, C, 0,
	0, E, D, D, D, D, D, D, E, 0,
	0, E, D, P, I, I, P, D, E, 0,
	0, E, D, I, I, I, I, D, E, 0,
	0, E, D, I, I, I, I, D, E, 0,
	0, E, D, P, I, I, P, D, E, 0,
	0, E, D, D, D, D, D, D, E, 0,
	0, C, E, E, E, E, E, E, C, 0,
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	};

