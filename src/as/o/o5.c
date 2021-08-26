#include "o.h"

fastchar pcolor[] {'-', '@', '*'};

fastchar quadrant[100] {
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	0, 1, 1, 1, 1, 2, 2, 2, 2, 0,
	0, 1, 1, 1, 1, 2, 2, 2, 2, 0,
	0, 1, 1, 1, 1, 2, 2, 2, 2, 0,
	0, 1, 1, 1, 1, 2, 2, 2, 2, 0,
	0, 3, 3, 3, 3, 4, 4, 4, 4, 0,
	0, 3, 3, 3, 3, 4, 4, 4, 4, 0,
	0, 3, 3, 3, 3, 4, 4, 4, 4, 0,
	0, 3, 3, 3, 3, 4, 4, 4, 4, 0,
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	};

position trymov[] {
	pos(0,0), pos(0,7), pos(7,0), pos(7,7),
	pos(0,1), pos(0,2), pos(0,3), pos(0,4),
	pos(0,5), pos(0,6), pos(1,0), pos(1,7),
	pos(2,0), pos(2,7), pos(3,0), pos(3,7),
	pos(4,0), pos(4,7), pos(5,0), pos(5,7),
	pos(6,0), pos(6,7), pos(7,1), pos(7,2),
	pos(7,3), pos(7,4), pos(7,5), pos(7,6),
	pos(2,2), pos(2,5), pos(5,2), pos(5,5),
	pos(2,3), pos(2,4), pos(3,2), pos(3,5),
	pos(4,2), pos(4,5), pos(5,3), pos(5,4),
	pos(1,2), pos(1,3), pos(1,4), pos(1,5),
	pos(2,1), pos(2,6), pos(3,1), pos(3,6),
	pos(4,1), pos(4,6), pos(5,1), pos(5,6),
	pos(6,2), pos(6,3), pos(6,4), pos(6,5),
	pos(1,1), pos(1,6), pos(6,1), pos(6,6),
	pos(3,3), pos(3,4), pos(4,3), pos(4,4),
	-1
	};

clrbrd(b)
	board b;

	{register int i;
	i = 100;
	while (--i>=0) b[i] = EMPTY;
	b[pos(3,3)] = b[pos(4,4)] = WHITE;
	b[pos(4,3)] = b[pos(3,4)] = BLACK;
	b[WHITE] = b[BLACK] = 2;
	}

#ifdef unix
cpybrd (a,b)
	register fastchar *a, *b;

	{register int i;
	i = 100;
	while (--i>=0) *a++ = *b++;
	}
#endif

cntbrd (b,c)
	board b;
	color c;

	{register position p;
	int count;
	count = 0;
	forallpos (p) {if (b[p] == c) ++count;}
	return (count);
	}

anymvs(b,c)
	board b;
	color c;

	{register position p;
	forallpos (p) {if (ismove (b,c,p)) return (TRUE);}
	return (FALSE);
	}

direction dirlist[]
	{NORTH, EAST, SOUTH, WEST,
	NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST,
	0};

# ifdef unix
ismov1(b,c,p1)
	board b;
	color c;
	position p1;

	{register direction d;
	direction *dd;
	dd = dirlist;
	while (d = *dd++)
		{register position p;
		int k;
		p = p1;
		k = 0;
		while (valid (nextpos (p, d)))
			{register color x;
			if ((x = b[p]) == EMPTY) break;
			if (x == c)
				{if (k) return (TRUE);
				break;
				}
			++k;
			}
		}
	return (FALSE);
	}
# endif

putmov(b,c,p1)
	board b;
	color c;
	position p1;

	{register direction d;
	direction *dd;
	color o;

	b[p1] = c;
	b[c] =+ sqscore (p1);
	o = oppcolor (c);
	dd = dirlist;
	while (d = *dd++)
		{register position p;
		int k;
		p = p1;
		k = 0;
		while (valid (nextpos (p, d)))
			{{register color x;
			if ((x = b[p]) == EMPTY) break;
			if (x != c) {++k; continue;}
			}
			if (k==0) break;
			p = p1;
			while (valid (nextpos (p, d)))
				{register int sscore;
				if (b[p] != o) break;
				b[p] = c;
				b[c] =+ (sscore = sqscore (p));
				b[o] =- sscore;
				}
			break;
			}
		}
	}

putpos (p, fd)
	position p;
	FILE *fd;

	{fprintf(fd, "%d-%d",posx(p)+1,posy(p)+1);
	}

putcolor (c, fd)
	color c;
	FILE *fd;

	{if (c>=0 && c<=2) putc (pcolor[c], fd);
	else putc ('?', fd);
	}

putdir (d, fd)
	direction d;
	FILE *fd;

	{char *s;
	if (d==NORTH) s="NORTH";
	else if (d==SOUTH) s="SOUTH";
	else if (d==EAST) s="EAST";
	else if (d==WEST) s="WEST";
	else if (d==NORTHEAST) s="NORTHEAST";
	else if (d==NORTHWEST) s="NORTHWEST";
	else if (d==SOUTHEAST) s="SOUTHEAST";
	else if (d==SOUTHWEST) s="SOUTHWEST";
	else s="?";
	fprintf (fd, "%s", s);
	}

# define C CORNERVALUE
# define E EDGEVALUE
# define I INTERIORVALUE

fastchar sqval[100] {
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	0, C, 2, E, E, E, E, 2, C, 0,
	0, 2, 1, 3, 3, 3, 3, 1, 2, 0,
	0, E, 3, I, I, I, I, 3, E, 0,
	0, E, 3, I, I, I, I, 3, E, 0,
	0, E, 3, I, I, I, I, 3, E, 0,
	0, E, 3, I, I, I, I, 3, E, 0,
	0, 2, 1, 3, 3, 3, 3, 1, 2, 0,
	0, C, 2, E, E, E, E, 2, C, 0,
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	};
