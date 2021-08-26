#include	"o.h"

extern int eflag;

/**********************************************************************

	EDGEVAL - Evaluate C's taking the edge square at P?

	 *
	 * Scores:
	 *
	 *	+4 = win 2 corners
	 *	+2 = win 1 corner
	 *	+1 = no corners taken, moved last
	 *	0 = each won 1 corner
	 *
	 *

**********************************************************************/

int edepth, ddepth;
color ecolor;

int edgeval (b,c,o,p)
	board b;
	color c, o;
	position p;

	{direction d;
	board a;

	ecolor = c;
	if (eflag)
		{printf ("\n *** edgeval (");
		putcolor (c, stdout);
		printf (", ");
		putpos (p, stdout);
		printf ("):\n");
		}
	if (horizedge(p)) d=WEST; else d=NORTH;
	cpybrd (a,b);
	putmov (a,c,p);
	return (-eeval (b,a,o,c,p,d,TRUE));
	}

int eeval (oldb,b,c,o,p,d,pass_ok)	/* return score from C's point of view */
	board oldb, b;
	color c, o;
	position p;
	direction d;
	int pass_ok;

	/*
	 * Pass_ok is set to false when we are evaluating
	 * the result of O not moving on this edge on the
	 * previous turn.  In this case, C can always not
	 * move and get 1 point for moving last.
	 *
	 */

	{int s;		/* best score for C */
	int t;		/* temporary score for C */

	if (edepth > 4 && c==ecolor) return (1);
	++edepth;
	if (eflag)
		{putn (edepth);
		printf ("eeval (");
		putcolor (c, stdout);
		printf (", ");
		putdir (d, stdout);
		printf ("):\n");
		}
	if (pass_ok) s = -100; else s = 1;
	t = e1move (oldb, b, c, o, p, d);
	if (t>s) s = t;
	t = e1move (oldb, b, c, o, p, oppdir(d));
	if (t>s) s = t;
	if (pass_ok && edepth < 4)
		{t = -eeval (oldb, b, o, c, p, d, FALSE);
		if (t>s) s = t;
		}
	if (s == -100) s = -1;
	if (eflag)
		{putn (edepth);
		printf ("eeval (");
		putcolor (c, stdout);
		printf (", ");
		putdir (d, stdout);
		printf (") = %d\n", s);
		}
	--edepth;
	return (s);
	}

int e1move (oldb,b,c,o,p,d)	/* return score from C's point of view */
	board oldb, b;
	color c, o;
	position p;
	direction d;

	{position findempty ();
	int rc;

	rc = -100;
	++edepth;	
	if (eflag)
		{putn (edepth);
		printf ("e1move (");
		putcolor (c, stdout);
		printf (", ");
		putdir (d, stdout);
		printf (") ");
		}
	p = findempty (b, p, d);
	if (valid (p) && ismove (b, c, p))
		{int s, t;
		board a;
		cpybrd (a, b);
		putmov (a, c, p);
		if (eflag)
			{printf ("move at ");
			putpos (p, stdout);
			printf ("\n");
			}
		t = 0;
		if (corner(p) && !ismove (oldb, c, p)) t = 2;
		s = -eeval (oldb,a,o,c,p,d,TRUE);
		if (t==0 || s<-1 || s>1)
			t =+ s;
		/* only count 1 pt. if no corners */
		rc = t;
		}
	else if (eflag) printf ("no move\n");
	--edepth;
	return (rc);
	}

position findempty (b, p, d)
	board b;
	position p;
	direction d;

	{while (valid (nextpos (p, d)) && b[p] != EMPTY);
	return (p);
	}

putn (n)
	{printf ("%2d", n);
	while (--n>=0) {putchar (' '); putchar (' ');}
	}

/**********************************************************************

	DEFEDGE - Does the move at edge P have defensive value?

	(Move has not yet been made.)

	An edge move has defensive value if it prevents the opponent
	from capturing along an edge.

	look for:	~o X o+ c+ _
			where the _ is not a bad move (W,X,Y,Z) for O
	look for:	o c* X c* o
			where there is a hole

**********************************************************************/

int defedge (b,c,o,p)
	board b;
	color c, o;
	position p;

	{direction d;
	position p1;
	int rc;
	p1 = p;
	if (ddepth>0) return (FALSE);	/* avoid useless recursion */
	++ddepth;
	if (horizedge(p)) d=WEST; else d=NORTH;
	rc = def1edge (b,c,o,p,d) ||
	     def1edge (b,c,o,p,oppdir(d)) ||
	     def2edge (b,c,o,p,d);
	--ddepth;
	return (rc);
	}

int def1edge (b,c,o,p,d)
	board b;
	color c, o;
	position p;
	direction d;

	{position p1;
	direction d1;
	d1 = oppdir (d);
	p1 = p;
	if (valid (nextpos (p1, d1)) && b[p1]==o) return (FALSE);
	if (!valid (nextpos (p, d))) return (FALSE);
	if (b[p] != o) return (FALSE);
	while (b[p] == o) if (!valid (nextpos (p, d))) return (FALSE);
	if (b[p] != c) return (FALSE);
	while (b[p] == c) if (!valid (nextpos (p, d))) return (FALSE);
	if (b[p] != EMPTY) return (FALSE);
	return (s_move (b,o,c,p,b) < 'W');
	}

int def2edge (b,c,o,p,d)
	board b;
	color c, o;
	position p;
	direction d;

	{if (!def3edge (b,c,o,p,d)) return (FALSE);
	if (!def3edge (b,c,o,p,oppdir(d))) return (FALSE);
	while (b[p] != o) if (!valid (nextpos (p, d))) return (FALSE);
	return (hole (b,o,c,p));
	}

int def3edge (b,c,o,p,d)
	board b;
	color c, o;
	position p;
	direction d;

	{if (!valid (nextpos (p, d))) return (FALSE);
	while (b[p] == c) if (!valid (nextpos (p, d))) return (FALSE);
	return (b[p] == o);
	}

/**********************************************************************

	SAFEDGE - Is the move at edge P safe?

	(Move must have been made.)

	An edge move is considered safe if neither of the nearest
	empty edge squares can be taken by the opponent and
	(if not a corner) have defensive value for the opponent.

	Return TRUE if the move is safe.

**********************************************************************/

int safedge (b,c,o,p)
	board b;
	color c, o;
	position p;

	{direction d;
	if (horizedge(p)) d=WEST; else d=NORTH;
	return (saf1edge (b,c,o,p,d) && saf1edge (b,c,o,p,oppdir(d)));
	}

int saf1edge (b,c,o,p,d)
	board b;
	color c, o;
	position p;
	direction d;

	{p = findempty (b, p, d);
	if (valid (p) && ismove (b, o, p))
		return (!(corner(p) || defedge (b, o, c, p)));
	else return (TRUE);
	}

#define FHOLE 1
#define FCORNER 2

/*
 * hole - does the position resulting from a move at P by C contain a
 * hole for O? If so, what value square is given up?
 *
 * (The move has already been made.)
 *
 */

hole(b,c,o,p)
	board b;
	color c, o;
	position p;

	{register int h;
	if (horizedge (p))
		h = hole1 (b,c,o,p,EAST) | hole1 (b,c,o,p,WEST);
	else
		h = hole1 (b,c,o,p,NORTH) | hole1 (b,c,o,p,SOUTH);
	if (h > FHOLE) return (CORNERVALUE);
	if (h == FHOLE) return (EDGEVALUE);
	return (0);
	}

/*
 * case 1:		_ c* X c* _ c+ _
 *
 * case 2:		_ c* X c* o+ _ c+ _
 *			o c* X c* o+ _ c+ _
 *
 * case 3:		_ c* X c* _ o+ c+ _
 *			_ c* X c* _ o+ c+ o
 *
 * case 4:		... c+ o+ c+
 *			can be ignored since it will
 *			be picked up by edgeval
 *
 * In all cases, inner _ may be any odd number of _s.
 * In all cases, outer _ may be [ or ].
 * In all cases, outer _ are the squares given up,
 *	plus the inner edge square.
 *
 */

hole1(b,c,o,p,d)
	board b;
	color c, o;
	register position p;
	direction d;

	{int n_o_left, n_o_right, n_spaces;
	position p1;
	direction d1;

	p1 = p;
	d1 = oppdir (d);
	nextpos (p1, d1);
	while (valid (p1) && b[p1] == c) nextpos (p1, d1);

	if (!valid (nextpos (p, d))) return (0);
	while (b[p] == c) if (!valid (nextpos (p, d))) return (0);
	n_o_left = 0;
	while (b[p] == o)
		{if (!valid (nextpos (p, d))) return (0);
		++n_o_left;
		}
	if (b[p] != EMPTY) return (0);
	n_spaces = 0;
	while (b[p] == EMPTY)
		{if (!valid (nextpos (p, d))) return (0);
		++n_spaces;
		}
	if ((n_spaces & 1) == 0) return (0);
	n_o_right = 0;
	while (b[p] == o)
		{if (!valid (nextpos (p, d))) return (0);
		++n_o_right;
		}
	if (b[p] != c) return (0);
	while (b[p] == c)
		if (!valid (nextpos (p, d))) break;
	if (valid (p1) && b[p1] == o && n_o_left == 0) return (0);
	if (valid (p) && b[p] == o && n_o_right == 0) return (0);
	if (valid (p) && corner (p)) return (FCORNER);
	if (valid (p1) && corner (p1)) return (FCORNER);
	return (FHOLE);
	}

/*
 * trap1 - look to see if moving on the edge adjacent to a corner
 *    is safe
 *
 * bad if: it turns over an opponent's piece on the adjacent diagonal
 * bad if: [_ X c* _ o* _ _
 *		(unless the last _ is a corner or adjacent to a corner)
 * bad if: [_ X c* _ o* _ c* o
 *
 */

trap1 (b, c, o, p)
	board b;
	color c, o;
	position p;

	{direction d, d1;
	position p1;
	extern fastchar quadrant[];

	switch (quadrant[p]) {
		case 1: d = EAST; d1 = SOUTH; break;
		case 2: d = WEST; d1 = SOUTH; break;
		case 3:	d = EAST; d1 = NORTH; break;
		case 4:	d = WEST; d1 = NORTH; break;
		}
	if (!horizedge (p))
		{direction temp;
		temp = d;
		d = d1;
		d1 = temp;
		}
	p1 = p;
	nextpos (p1, d1);
	if (b[p1] == o)
		{while (b[p1] == o) if (!valid (nextpos (p1, d1))) break;
		if (valid (p1) && b[p1] == c) return (TRUE);
		}
	nextpos (p, d);
	while (b[p] == c) if (!valid (nextpos (p, d))) return (FALSE);
	if (b[p] != EMPTY) return (FALSE);
	if (!valid (nextpos (p, d))) return (FALSE);
	while (b[p] == o) if (!valid (nextpos (p, d))) return (TRUE);
	if (b[p] != EMPTY) return (TRUE);
	if (!valid (nextpos (p, d))) return (FALSE);
	if (b[p] == EMPTY) return (sqval[p] == EDGEVALUE);
	while (b[p] == c) if (!valid (nextpos (p, d))) return (FALSE);
	return (b[p] == o);
	}

/*
 * trap2 - look to see if move on edge, which can be taken back,
 * is actually safe.  Return CORNERVALUE if it results in taking
 * a corner, EDGEVALUE if it is otherwise safe, 0 if it is unsafe.
 *
 * CORNERVALUE if: [_ o+ X c* _ c+ ~o
 * CORNERVALUE if: [_ o+ X c* _ o+ c+
 * EDGEVALUE if:  _ o+ X c* _ c+ ~o
 * EDGEVALUE if:  _ o+ X c* _ o+ c+
 * EDGEVALUE if:  c+ o+ c+ X _ _
 * EDGEVALUE if:  _ o+ _ o+ X _ _
 *
 */

trap2 (b, c, o, p)
	board b;
	color c, o;
	position p;

	{direction d;
	int v;
	if (horizedge (p)) d = EAST;
	else d = NORTH;
	if ((v = trp2a (b, c, o, p, d)) > 0) return (v);
	if ((v = trp2a (b, c, o, p, oppdir(d))) > 0) return (v);
	if (trp2b (b, c, o, p, d) || trp2b (b, c, o, p, oppdir(d)))
		return (EDGEVALUE);
	return (0);
	}

trp2a (b, c, o, p, d)
	board b;
	color c, o;
	position p;
	direction d;

	{direction od;
	position ip;
	int v, n;

	ip = p;
	od = oppdir(d);
	if (!valid (nextpos (p, od))) return (0);
	if (b[p] != o) return (0);
	while (b[p] == o) if (!valid (nextpos (p, od))) return (0);
	if (b[p] != EMPTY) return (0);
	if (corner (p)) v = CORNERVALUE; else v = EDGEVALUE;
	p = ip;
	if (!valid (nextpos (p, d))) return (0);
	while (b[p] == c) if (!valid (nextpos (p, d))) return (0);
	if (b[p] != EMPTY) return (0);
	if (!valid (nextpos (p, d))) return (0);
	n = 0;
	while (b[p] == o)
		if (!valid (nextpos (p, d))) return (0);
		else ++n;
	if (b[p] != c) return (0);
	if (n > 0) return (v);
	while (b[p] == c) if (!valid (nextpos (p, d))) return (v);
	if (b[p] == EMPTY) return (v);
	return (0);
	}

trp2b (b, c, o, p, d)
	board b;
	color c, o;
	position p;
	direction d;

	{direction od;
	position ip;

	ip = p;
	od = oppdir (d);
	if (!valid (nextpos (p, od))) return (FALSE);
	if (b[p] != EMPTY) return (FALSE);
	if (!valid (nextpos (p, od))) return (FALSE);
	if (b[p] != EMPTY) return (FALSE);
	p = ip;
	if (!valid (nextpos (p, d))) return (FALSE);
	if (b[p] != c)
		{if (b[p] != o) return (FALSE);
		while (b[p] == o) if (!valid (nextpos (p, d))) return (FALSE);
		if (b[p] != EMPTY) return (FALSE);
		if (!valid (nextpos (p, d))) return (FALSE);
		if (b[p] != o) return (FALSE);
		while (b[p] == o) if (!valid (nextpos (p, d))) return (TRUE);
		return (b[p] == EMPTY);
		}
	while (b[p] == c) if (!valid (nextpos (p, d))) return (FALSE);
	if (b[p] != o) return (FALSE);
	while (b[p] == o) if (!valid (nextpos (p, d))) return (FALSE);
	return (b[p] == c);
	}

/*
 * trap3 - look to see if move on edge, which cannot be taken back,
 * actually wins the corner
 *
 * look for: [_ o+ X c* o
 *
 */

trap3 (b, c, o, p)
	board b;
	color c, o;
	position p;

	{direction d;
	if (horizedge (p)) d = EAST;
	else d = NORTH;
	return (trp3a (b, c, o, p, d) || trp3a (b, c, o, p, oppdir(d)));
	}

trp3a (b, c, o, p, d)
	board b;
	color c, o;
	position p;
	direction d;

	{direction od;
	position ip;

	ip = p;
	od = oppdir(d);
	if (!valid (nextpos (p, od))) return (FALSE);
	if (b[p] != o) return (FALSE);
	while (b[p] == o) if (!valid (nextpos (p, od))) return (FALSE);
	if (b[p] != EMPTY) return (FALSE);
	if (!corner (p)) return (FALSE);
	p = ip;
	if (!valid (nextpos (p, d))) return (FALSE);
	while (b[p] == c) if (!valid (nextpos (p, d))) return (TRUE);
	return (b[p] == o);
	}

/*
 * trap4 - look to see if move on edge, which creates a hole,
 * actually wins the corner
 *
 * look for: [_ o _ c _ X _ _
 *	     [_ o _ X _ c _ _
 *
 */

trap4 (b, c, o, p)
	board b;
	color c, o;
	position p;

	{int x, y;
	x = posx (p);
	y = posy (p);
	if (x == 2) return (trp4a (b, c, o, p, SOUTH));
	if (x == 5) return (trp4a (b, c, o, p, NORTH));
	if (y == 2) return (trp4a (b, c, o, p, EAST));
	if (y == 5) return (trp4a (b, c, o, p, WEST));
	if (x == 3) return (trp4b (b, c, o, p, NORTH));
	if (x == 4) return (trp4b (b, c, o, p, SOUTH));
	if (y == 3) return (trp4b (b, c, o, p, WEST));
	if (y == 4) return (trp4b (b, c, o, p, EAST));
	return (FALSE);
	}

trp4a (b, c, o, p, d)
	board b;
	color c, o;
	position p;
	direction d;

	/* look for: [_ o _ c _ X _ _ */

	{position p1;

	p1 = p;
	nextpos (p, d);
	if (b[p] != EMPTY) return (FALSE);
	nextpos (p, d);
	if (b[p] != c) return (FALSE);
	nextpos (p, d);
	if (b[p] != EMPTY) return (FALSE);
	nextpos (p, d);
	if (b[p] != o) return (FALSE);
	nextpos (p, d);
	if (b[p] != EMPTY) return (FALSE);
	p = p1;
	d = oppdir (d);
	nextpos (p, d);
	if (b[p] != EMPTY) return (FALSE);
	nextpos (p, d);
	if (b[p] != EMPTY) return (FALSE);
	return (TRUE);
	}

trp4b (b, c, o, p, d)
	board b;
	color c, o;
	position p;
	direction d;

	/* look for: [_ o _ X _ c _ _ */

	{position p1;

	p1 = p;
	nextpos (p, d);
	if (b[p] != EMPTY) return (FALSE);
	nextpos (p, d);
	if (b[p] != o) return (FALSE);
	nextpos (p, d);
	if (b[p] != EMPTY) return (FALSE);
	p = p1;
	d = oppdir (d);
	nextpos (p, d);
	if (b[p] != EMPTY) return (FALSE);
	nextpos (p, d);
	if (b[p] != c) return (FALSE);
	nextpos (p, d);
	if (b[p] != EMPTY) return (FALSE);
	nextpos (p, d);
	if (b[p] != EMPTY) return (FALSE);
	return (TRUE);
	}
