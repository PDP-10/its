#define GENBOOK 1
#include "ob.h"

int gmdepth 0;
int gmmdepth 4;

int geval (b,c)
	board b;
	color c;

	{color o;
	o = oppcolor (c);
	return (gmeval (b,c,o));
	}

int gmeval (b,c,o)
	board b;
	color c, o;

	{int myscore;
	if (++gmdepth == gmmdepth) myscore = gseval (b,c);
	else
		{register position *pp, p;
		myscore = -1000;
		forallpos (p, pp) if (ismove (b,c,p))
			{register int temp;
			board a;
			cpybrd (a,b);
			putmov (a,c,p);
			temp = -gmeval(a,o,c);
			if (temp>myscore) myscore=temp;
			}
		}
	--gmdepth;
	return (myscore);
	}

gseval (b, c)
	board b;
	color c;

	{color o;
	position p, *pp;
	int nmymoves, nopmoves, s, myscore;

	o = oppcolor (c);
	s = -1;
	nopmoves = nmymoves = 0;
	forallpos (p, pp)
		{if (ismove (b,c,p))
			{register int temp;
			temp = sqeval (b,c,o,p);
			if (temp > 2 && temp != 5)	/* count only good moves */
				{++nmymoves;
				if (edge (p)) nmymoves=+2; /* count edges higher */
				}
			}
		if (ismove (b,o,p))
			{register int temp;
			temp = sqeval (b,o,c,p);
			if (temp > 2 && temp != 5)	/* count only good moves */
				{++nopmoves;
				if (edge (p)) nopmoves=+2; /* count edges higher */
				}
			if (temp>s) {s=temp;}
			}
		}
	myscore = nmymoves-nopmoves;
	if (nmymoves<6) myscore =- (6-nmymoves)*2;
	if (nopmoves<6) myscore =+ (6-nopmoves)*2;
	if (s == CORNERVALUE) myscore =- 100;
	return (myscore);
	}

bkminimax ()

	{bkmxnode (bnfind (1));
	}

bkmxnode (bn)
	bnode *bn;

	{int i, myscore;
	if (bn == 0) return;
	i = bn->nmoves;
	if (i == 0) return;
	myscore = NOT_EVAL;
	while (--i >= 0)
		{bnode *next;
		int temp;
		next = extrace (bn, i);
		bkmxnode (next);
		temp = -(next->eval);
		if (temp > myscore) myscore = temp;
		}
	bn->eval = myscore;
	i = bn->nmoves;
	while (--i >= 0)
		{bnode *next;
		int temp;
		next = extrace (bn, i);
		temp = -(next->eval);
		if (temp == myscore) setgood (&bn->moves[i]);
		}
	}

