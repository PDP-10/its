#include "o.h"

extern int display, explain;
extern fastchar pcolor[];

# define LEFT 0
# define RIGHT 1
# define TYOSIZ 1000

static board leftb, rightb;
static int cboard;
static int left_exists, right_exists;
static char tyobuf[TYOSIZ], *ctyop {tyobuf};

# define tyo(c) *ctyop++ = (c)

# ifndef unix
# rename tyochn "TYOCHN"
extern int tyochn;
# define tyocrlf() (tyo('\r'))
# define down() (tyo(16),tyo('D'))
# define top() (tyo(16),tyo('T'))
# define horiz(n) (tyo(16),tyo('H'),tyo(8+(n)))
# define vertical(n) (tyo(16),tyo('V'),tyo(8+(n)))
# define erasechar() (tyo(16),tyo('K'))
# define eraseline() (tyo(16),tyo('L'))
# define erasescreen() (tyo(16),tyo('E'))
clrscreen () {spctty ('C');}
# define savepos() (tyo(16),tyo('S'))
# define rstrpos() (tyo(16),tyo('R'))
# endif

# ifdef unix
static int hpos, vpos, svhpos, svvpos;
static char cmm[] {0, 10, 0, 11, 0377, 0377};
getpos ()
	{ttymod (1, cmm);
	vpos = cmm[0];
	hpos = cmm[2];
	vpos=11;
	hpos=0;
	}
# define tyocrlf() (++vpos,hpos=0,tyo('\n'),eraseline())
# define down() (++vpos, tyo(033), tyo('B'))
# define tyoreset() (tyo(033),tyo('Y'),tyo(vpos+040),tyo(hpos+040))
# define top() (vpos=0,hpos=0,tyoreset())
# define horiz(n) (hpos=(n),tyoreset())
# define vertical(n) (vpos=(n),tyoreset())
# define erasechar() 
# define eraseline() (tyo(033),tyo('K'))
# define erasescreen() (tyo(033),tyo('J'))
clrscreen () {top();erasescreen();}
# define savepos() (getpos(),svhpos=hpos,svvpos=vpos)
# define rstrpos() (hpos=svhpos,vpos=svvpos,tyoreset(),erasescreen())
# endif

# ifndef unix
tyoflush ()
	{int ptr;
	if (ctyop > tyobuf)
		{ptr = tyobuf;
		ptr =| 0444400000000;
		siot (tyochn, ptr, ctyop-tyobuf);
		ctyop = tyobuf;
		}
	}
# endif
# ifdef unix
tyoflush ()
	{if (ctyop > tyobuf)
		{write (1, tyobuf, ctyop-tyobuf);
		ctyop = tyobuf;
		}
	}
# endif

styo (s)
	char *s;
	{int c;
	while (c = *s++) tyo(c);
	}

dpyempty ()

	{
	right_exists = 0;
	left_exists = 0;
	vertical (11);
	erasescreen ();
	tyoflush ();
	}

prtbrd (b)
	board b;

	{
	if (display)
		{if (cboard == LEFT || !explain) right_exists = 0;
		cpybrd (leftb,b);
		cboard = LEFT;
		erasescreen();
		newleft ();
		left_exists = TRUE;
		eraseline();
		tyoflush();
		}
	else
		 outbrd (b);
	}

auxbrd(b)
	board b;

	{
	if (display)
		{cboard = RIGHT;
		cpybrd (rightb,b);
		savepos();
		newright ();
		right_exists = TRUE;
		rstrpos ();
		tyoflush();
		}
	else
		 outbrd (b);
	}

shwbrd(b)
	board b;

	{
	if (display)
		{if (cboard == LEFT || !explain) right_exists = 0;
		cpybrd (leftb,b);
		cboard = LEFT;
		savepos ();
		newleft ();
		rstrpos ();
		left_exists = TRUE;
		tyoflush();
		}
	else
		 outbrd (b);
	}

newleft ()

	{
	register int x, y;
	if (!right_exists || !left_exists) {redisplay (); return;}
	top();
	eraseline();
	horiz (0);
	down();
	down();
	for (x=0; x<8; ++x)
		{horiz (1);
		for (y=0; y<8; ++y) dpysq (leftb,x,y);
		horiz (0);
		down();
		}
	}


newright ()

	{register int x, y;
	if (!left_exists) {redisplay (); return;}
	top();
	eraseline();
	horiz (0);
	down();
	if (!right_exists)
		{horiz (32);
		styo ("  1 2 3 4 5 6 7 8");
		horiz (0);
		}
	down();
	for (x=0; x<8; ++x)
		{horiz (32);
		eraseline();
		tyo (x+'1');
		for (y=0; y<8; ++y) tyosq (rightb,x,y);
		horiz (0);
		down ();
		}
	}

redisplay ()

	{
	register int x, y;
	top();
	eraseline();
	tyocrlf ();
	styo("  1 2 3 4 5 6 7 8");
	if (right_exists) styo ("\t\t  1 2 3 4 5 6 7 8");
	tyocrlf ();
	for (x=0; x<8; ++x)
		{tyo (x+'1');
		for (y=0; y<8; ++y) tyosq (leftb,x,y);
		if (right_exists)
			{styo ("\t\t");
			tyo (x+'1');
			for (y=0; y<8; ++y) tyosq (rightb,x,y);
			}
		tyocrlf();
		}
	}

tyosq (b, x, y)
	board b;
	position x, y;

	{register int z;
	tyo(' ');
	z = b[pos(x,y)];
	if (z<=2) tyo(pcolor[z]);
	else tyoletter(z);
	}

dpysq (b, x, y)
	board b;
	position x, y;

	{register int z;
	tyo (' ');
	z = b[pos(x,y)];
	erasechar ();
	if (z<=2) tyo(pcolor[z]);
	else tyoletter(z);
	}

tyoletter (c)
	{tyo(c);
	}

outbrd (b)
	board b;

	{register int x, y;
	printf("\n  1 2 3 4 5 6 7 8\n");
	for (x=0; x<8; ++x)
		{printf("%1d",x+1);
		for (y=0; y<8; ++y) outsq (b,x,y);
		putchar('\n');
		}
	}

outsq (b, x, y)
	board b;
	position x, y;

	{register int z;
	putchar(' ');
	z = b[pos(x,y)];
	if (z<=2) putchar(pcolor[z]);
	else putletter(z);
	}

putletter (c)
	{putchar(c);
	}

extern char gambuf[];
extern FILE *gamefile;

writbd(b, s)
	board b;
	char *s;

	{register int x, y;
	register FILE *f;
	char *e;

	if (s[0] == 0) s = "o.save";
	if ((f = fopen (s, "w")) == NULL) return (0);
	for (x=0; x<8; ++x)
		{for (y=0; y<8; ++y) putc(pcolor[b[pos(x,y)]], f);
		putc('\n', f);
		}
# ifndef unix
	putc ('\n', f);
	s = gambuf;
	e = cclose (gamefile);
	while (s < e) putc (*s++, f);
	gamefile = copen (e, 'w', "s");
# endif
	fclose (f);
	return (1);
	}

readbd(b, s)
	board b;
	char *s;

	{register int x, y;
	register FILE *f;
	extern int fcnt[], handicap;
	if (s[0] == 0) s = "o.save";
	if ((f = fopen (s, "r")) == NULL) return (0);
	for (x=0; x<8; ++x)
		{for (y=0; y<8; ++y) switch (getc (f)) {
			case '*':	b[pos(x,y)] = BLACK; continue;
			case '@':	b[pos(x,y)] = WHITE; continue;
			default:	b[pos(x,y)] = EMPTY; continue;
			}
		getc(f);
		}
# ifndef unix
	getc (f);
	cclose (gamefile);
	gamefile = copen (gambuf, 'w', "s");
	while ((x = getc (f)) > 0) putc (x, gamefile);
# endif
	fclose (f);
	endgame = -1000;
	setmov (b, (cntbrd (b,WHITE) + cntbrd (b,BLACK) - 1)/2);
	fcnt[WHITE] = fcnt[BLACK] = handicap = 0;
	right_exists = FALSE;
	return (1);
	}

fixbrd (b)
	board b;

	{register position p;
	b[0] = b[1] = b[2] = 0;
	forallpos (p)
		{register color c;
		if ((c = b[p]) != EMPTY) b[c] =+ sqscore (p);
		}
	}
