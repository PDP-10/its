# include "o.h"

extern int mvnhack;
extern fastchar quadrant[100];
int danger;

/**********************************************************************

	RELSCORE maps two values representing what I get and
	what my opponent gets into a letter score.  The input
	values are:

	0 - unsafe edge (can be taken back)
	1 - move that may give away corner
	2 - no move
	3 - adjacent to edge
	4 - interior
	5 - hole-making edge
	6 - safe edge
	7 - corner

	note:	A = move that wipes out opponent
		B = move that saves corner
		H = defensive taking of edge

**********************************************************************/

# define GOODSCORE 'H'	/* scores worse than this => movnum hack */
# define BADSCORE 'U'	/* scores better than this => movnum hack */

fastchar relscore[8][8] {
	'X', 'X', 'X', 'X', 'X', '?', 'X', 'Z',
	'Y', 'Y', 'Y', 'Y', 'Y', '?', 'Y', 'Z',
	'?', '?', '?', '?', '?', '?', '?', '?',
	'E', 'E', 'E', 'Q', 'R', '?', 'T', 'Z',
	'E', 'E', 'E', 'P', 'P', '?', 'S', 'Z',
	'?', '?', '?', '?', '?', '?', 'V', 'Z',
	'D', 'D', 'D', 'J', 'K', '?', 'N', 'Z',
	'C', 'C', 'C', 'C', 'C', '?', 'F', 'U',
	};

/**********************************************************************

	MY_MOV - Select a move from the set of best moves.

**********************************************************************/

position my_mov (b,c,o)
	board b;
	color c, o;

	{struct mt t[64], *tp[64];
	register int k;

	k = bk_lookup (t, tp);
	if (k > 0)
		{position p;
		p = tp[0]->p;
		if (k > 1) p = tp[(rand() & 017777) % k]->p;
		if (ismove (b,c,p)) return (p);
		cprint ("Book returns illegal move.\n");
		}
	k = getcandidates (b,c,o,tp,t);
	if (k==0) return (0);
	if (k==1) return (tp[0]->p);
	k = (rand() & 017777) % k;
	return (tp[k]->p);
	}

/**********************************************************************

	GETCANDIDATES - Get all best moves.

**********************************************************************/

int getcandidates (b,c,o,tp,t)
	board b;
	color c, o;
	struct mt *tp[], t[];

	{extern int movnum;
	int k, omvnhack;

	omvnhack = mvnhack;
	sethack (b, c);
	k = igetcandidates (b,c,o,tp,t,movnum>=MIDDLEMOVE);
	if (movnum<MIDDLEMOVE && danger && k>0 && tp[0]->c <= -80)
		{mvnhack = 0;
		k = igetcandidates (b,c,o,tp,t,'V');
		if (tp[0]->c <= -80)
			{k = igetcandidates (b,c,o,tp,t,'X');
			if (tp[0]->c <= -85)
				k = igetcandidates (b,c,o,tp,t,1);
			}
		}
	mvnhack = omvnhack;
	return (k);
	}

/**********************************************************************

	SETHACK - Determine if we are in danger of being
	    wiped out.

**********************************************************************/

int sethack (b, c)
	board b;
	color c;

	{int ccount, ocount;
	extern int handicap;
	ccount = cntbrd (b, c);
	ocount = cntbrd (b, oppcolor(c));
	if (handicap < 0) ccount =+ handicap;
	danger = ccount<6;
	if (movnum >= MIDDLEMOVE) mvnhack=0;
	}

/**********************************************************************

	IGETBEST - Get best (letterwise) moves

**********************************************************************/

int igetbest (b,c,o,tp,t,tryall)
	board b;
	color c, o;
	struct mt *tp[], t[];
	int tryall;

	{extern int mmdepth;
	int k, best;

	mmdepth = 2;
	k = pmvgen (b,c,o,tp,t,tryall==1,tryall!=1);
	if (k==0) return (0);
	best = tp[0]->s;
	if (tryall > 1 && best < tryall) k = exprange (tp, t, tryall);
	else if (tryall == 0)
		{if (best == 'P' && !mvnhack)
			{int oldk;
			oldk = k;
			k = exprange (tp, t, 'S');
			if (k > oldk) ++mmdepth;
			}
		}
	return (k);
	}

/**********************************************************************

	IGETCANDIDATES - Get possible moves.

	   tryall == 0: use normal selection
	   tryall == 1: try all moves
	   other value: try all moves <= value

**********************************************************************/

int igetcandidates (b,c,o,tp,t,tryall)
	board b;
	color c, o;
	struct mt *tp[], t[];
	int tryall;

	{register int k;

	k = igetbest (b,c,o,tp,t,tryall);
	if (k==0) return (0);
	if (k==1 && !danger)
		{tp[0]->c = -1000;
		return (1);
		}
	return (dosearch (b,c,o,tp,t,k,tryall));
	}

/**********************************************************************

	DOSEARCH

**********************************************************************/

int dosearch (b,c,o,tp,t,k,tryall)
	board b;
	color c, o;
	struct mt *tp[], t[];
	int tryall;

	{extern int debug, mmdepth, movnum;
	register struct mt **bp, **mp, **ep;
	int best;

	ep = tp + k;
	bp = tp;
	mp = tp;

	best = tp[0]->s;
	if (mvnhack && !danger && best < 'V' && best != 'B')
		{while (mp < ep)
			{struct mt *p;
			p = *mp++;
			p->c = -1000;
			}
		return (k);
		}

	if (best >= 'X')
		{mmdepth = 4;
		mvnhack = 0;
		}
	else if (best >= 'V') mmdepth = 3;
	if (movnum>=ENDGAMEMOVE) mmdepth = 6;
	else if (movnum>=MIDDLEMOVE)
		{if (k<=3) mmdepth = 6;
		else mmdepth = 4;
		}
	else if (movnum>=16)
		{if (k<=3) mmdepth = 4;}
	else if (movnum>=4)
		{if (k==2) mmdepth = 4;}

	if (danger && mmdepth<4) mmdepth=4;

	if (debug>0) printf ("\nsearch depth %d\n", mmdepth);
	tp[0]->c = -1000;
	while (mp < ep)
		{struct mt *p;
		p = *mp++;
		p->c = meval (b,c,o,p->p,tp[0]->c);
		if (debug>0) printf (" %d-%d %c %d\n", posx(p->p)+1,
				posy(p->p)+1, p->s, p->c);
		if (p->c > tp[0]->c) {bp = tp; *bp++ = p;}
		else if (p->c == tp[0]->c) *bp++ = p;
		}
	return (bp-tp);
	}

/**********************************************************************

	EXPRANGE - Return all moves in an already-computed set that
		   are not worse than a given LETTER score

**********************************************************************/

int exprange (tp,t,letter)
	struct mt *tp[], t[];

	{register struct mt **bp, *mp;
	mp = t;
	bp = tp;
	while (mp->p >= 0)
		{if (mp->s <= letter) *bp++ = mp;
		++mp;
		}
	return (bp-tp);
	}

/**********************************************************************

	PMVGEN - Probable Move Generator

**********************************************************************/

int pmvgen (b,c,o,tp,t,allmoves,wantscores)
	board b;
	color c,o;
	struct mt *tp[],t[];

	{struct mt *ep;
	register struct mt **bp, *mp;
	int k;

	k = fillmt(b,c,o,t,wantscores);
	if (k==0) return (0);
	if (k==1) {tp[0] = t; return (1);}
	ep = t+k;
	mp = t;
	bp = tp;
	*bp++ = mp;
	while (++mp < ep)
		if (allmoves) *bp++ = mp;
		else
			{if (mp->s < tp[0]->s) {bp = tp; *bp++ = mp;}
			else if (mp->s == tp[0]->s) *bp++ = mp;
			}
	return (bp-tp);
	}

/**********************************************************************

	FILLMT - Legal Move Generator

**********************************************************************/

fillmt(b,c,o,t,wantscores)
	board b;
	color c, o;
	struct mt t[64];

	{register position p;
	register struct mt *tp;
	board omb;

	filmvs(b,o,omb);
	tp = t;
	forallpos (p) if (ismove (b,c,p))
		{tp->p = p;
		tp->s = (wantscores ? s_move(b,c,o,p,omb) : 'O');
		++tp;
		}
	tp->p = -1;
	return (tp-t);
	}

/**********************************************************************

	S_MOVE - Simple Move Evaluator

	OMB is a board where all of O's moves are marked with
	a printing character.

**********************************************************************/

s_move(b,c,o,p,omb)
	board b, omb;
	color c, o;
	position p;

	{board a;	/* board after move */
	register int myscore, hisscore;
	int nmoves, nsaves;
	extern int machine[], ddepth;

	cpybrd (a, b);
	putmov (a, c, p);
	if (bscore (a, o) == 0 && cntbrd (a, o) == 0) return ('A');
	if (debug>0 && ddepth==0)
		{printf ("\n");
		putpos (p, stdout);
		}
	hisscore = aeval (a, p, o, c, omb, &nmoves, &nsaves);
 	myscore = sqeval (b,c,o,p);
	if (ddepth == 0)
		{if (debug>0)
			{printf (" ");
			putcolor (c, stdout);
			printf ("=%d ", myscore);
			putcolor (o, stdout);
			printf ("=%d (", hisscore);
			putletter (relscore[myscore][hisscore]);
			printf (")");
			}
		if (edge (p) && !corner (p))
			{int escore;
			escore = edgeval (b, c, o, p);
			if (escore > 1) myscore = CORNERVALUE;
			else if (escore < -1) hisscore = CORNERVALUE;
			else if (escore == 0) myscore = hisscore = CORNERVALUE;
			else if (myscore < CORNERVALUE)
				{register int temp;
				if (escore < 0 && myscore == EDGEVALUE) myscore = 0;
				temp = hole (a,c,o,p);
				if (temp>0 && trap4 (b, c, o, p))
					myscore = CORNERVALUE;
				else
					{if (temp>hisscore) hisscore=temp;
					if (temp>0 &&
					   (myscore>=HEDGEVALUE || myscore==0))
						myscore = HEDGEVALUE;
					}
				}
			}
		}
	myscore = relscore[myscore][hisscore];
	if (ddepth == 0)
		{if (!corner (p) && edge (p) &&
			myscore>GOODSCORE && (myscore<BADSCORE || myscore=='X')
			   && defedge (b,c,o,p))
				myscore = 'H';
		else if (mvnhack && myscore>GOODSCORE &&
		      (myscore<BADSCORE || myscore=='X'))
			myscore = mvneval (myscore, a, c, o, nmoves);
		}
	if (nsaves>0 && myscore<'Z') myscore='B';
	return (myscore);
	}

/**********************************************************************

	MVNEVAL

**********************************************************************/

int mvneval (myscore, a, c, o, nmoves)
	board a;
	color c, o;

	{int nmymoves, bias;
	if (myscore=='X') bias = 3; else bias = 0;
	nmymoves = cntokmoves (a, c);
	myscore=(GOODSCORE+10)+nmoves-nmymoves+bias;
	if (nmymoves<6) myscore =+ (6-nmymoves)*2;
	if (debug>0)
		{printf ("; ");
		putcolor (c, stdout);
		printf ("=%d ", nmymoves);
		putcolor (o, stdout);
		printf ("=%d sum=%d score=%d", nmoves,
		nmoves-nmymoves, myscore - (GOODSCORE+1));
		}
	if (myscore>(GOODSCORE+3))
		myscore = (GOODSCORE+3) + (myscore-(GOODSCORE+3))/4;
	if (myscore>=BADSCORE) myscore = BADSCORE-1;
	else if (myscore<=GOODSCORE) myscore = GOODSCORE+1;
	return (myscore);
	}

/**********************************************************************

	AEVAL - Evaluate replies

**********************************************************************/

aeval (b, oldp, c, o, omb, pnmoves, pnsaves)
	board b, omb;
	position oldp;
	color c, o;
	int *pnmoves, *pnsaves;

	{register int s;
	register position p;
	position bestp;
	int nmoves, nsaves;

	s = -1;
	nmoves = nsaves = 0;
	if (debug>0 && ddepth == 0) printf (" [");
	forallpos (p)
		{if (ismove (b,c,p))
			{register int temp;
			++nmoves;
			if (danger && ddepth==0)
				{board a;
				cpybrd (a, b);
				putmov (a, c, p);
				if (bscore (a, o) == 0 && cntbrd (a, o) == 0)
					return (CORNERVALUE);
				}
			temp = sqeval (b,c,o,p);
			if (temp > 2 && temp != 5)	/* count only good moves */
				{++nmoves;
				if (edge (p)) nmoves=+2; /* count edges higher */
				}
			if (omb[p] >= ' ')	/* can already move there */
				{if (temp>INTERIORVALUE && corner (p)
				     && !adjedge(oldp))
					temp = INTERIORVALUE;
				}
			if (debug>1 && ddepth == 0)
				{putpos (p, stdout);
				printf (":%d ", temp);
				}
			if (temp>s) {s=temp; bestp = p;}
			}
		else
			{if ((omb[p] >= ' ') && corner(p)) ++nsaves;}
		}
	*pnmoves = nmoves;
	*pnsaves = nsaves;
	if (debug>0 && ddepth == 0)
		{if (s<0) printf ("no reply");
		else
			{printf ("best reply is ");
			putpos (bestp, stdout);
			}
		printf ("]");
		}
	if (s<0) return (2);
	return (s);
	}

/**********************************************************************

	CNTOKMOVES - Count non-possibly-corner-losing-moves by C

**********************************************************************/

cntokmoves (b, c)
	board b;
	color c;

	{register position p;
	register int nmoves;

	nmoves = 0;
	forallpos (p)
		if (ismove (b,c,p) && !adjcorner(p)) ++nmoves;
	return (nmoves);
	}

/**********************************************************************

	SQEVAL - Simple Square Evaluator

**********************************************************************/

sqeval (b, c, o, p)
	board b;
	color c, o;
	position p;

	{register int val;
	extern fastchar selfplay;
	extern int movnum, machine[];

	val = sqval[p];
	if (adjcorner (p))	 /* adjacent to corner on edge or diagonal */
		{register position cp;
		cp = nrcorner (p);	/* the corner */
		if (adjdiag (p)) val = INTERIORVALUE;
		else val = EDGEVALUE;
		if (b[cp] == EMPTY)
			{if (adjdiag(p)) val = 1;
			else if (machine[c] && trap1 (b, c, o, p)) val = 1;
				/* this move bad only for the machine
				   since the machine is not particularly
				   good at taking advantage of it */
			}
		}
	if (val == EDGEVALUE)
		{board a;
		cpybrd (a,b);
		putmov (a,c,p);	/* try move */
		if (safedge (a,c,o,p))
			{if (trap3 (b,c,o,p)) val = CORNERVALUE;
			}
		else
			{int v;
			if ((v = trap2 (a,c,o,p)) > 0) val = v;
			else val = 0;
			}
		}
	return (val);
	}

/**********************************************************************

	NRCORNER - Return position of nearest corner

**********************************************************************/

position nrcorner(p)
	position p;

	{switch (quadrant [p]) {
	case 1:		return (pos(0,0));
	case 2:		return (pos(0,7));
	case 3:		return (pos(7,0));
	case 4:		return (pos(7,7));
			}
	return (0);
	}

/**********************************************************************

	DOTREE - Print tree of possible future machine play.

**********************************************************************/

static int treedepth 0;

dotree (b, c, o, depth, fd)
	board b;
	color c, o;

	{
#ifdef unix
	struct mt t[32], *tp[32];
	board a;
#endif
#ifndef unix
	struct mt *t, **tp;
	board *a;
#endif
	register int k, n;

#ifndef unix
	{int *ip;
	ip = salloc (100+64+64);
	t = ip;
	tp = ip + 64;
	a = ip + (64 + 64);
	}
# endif

	++treedepth;
	k = getcandidates (b,c,o,tp,t);
	if (k>10) k=10;
	if (k == 0)
		{treindent (fd);
		if (anymvs (b,o))
			{fprintf (fd, "Forfeit\n");
			dotree (b,o,c,depth,fd);
			}
		else fprintf (fd, "(%d-%d)\n", cntbrd(b,c),cntbrd(b,o));
		}
	else for (n=0;n<k;++n)
		{position p;
		treindent (fd);
		p = tp[n]->p;
		fprintf (fd, "%d-%d %c", posx(p)+1, posy(p)+1, tp[n]->s);
		if (tp[n]->c != -1000) fprintf (fd, " %d", tp[n]->c);
		putc ('\n', fd);
		if (treedepth < depth)
			{cpybrd (a,b);
			putmov (a,c,p);
			dotree (a,o,c,depth,fd);
			}
		}
	--treedepth;

# ifndef unix
	sfree (t);
# endif
	}

treindent (fd)

	{register int n;
	n = treedepth;
	fprintf (fd, "%2d", treedepth);
	putc ('\t', fd);
	while (n >= 8) {putc ('\t', fd); n =- 8;}
	while (--n >= 0) putc (' ', fd);
	}
