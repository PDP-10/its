#include "o.h"
#include "c/c.defs"
int eflag 0, debug 0, endgame 0, stdout, printf, fprintf;
int movnum 15;
int mvnhack 1;
int handicap 0;

#define USNAME 016
static int oldsname;
extern int cin, cout;

main ()

	{oldsname = rsuset (USNAME);
	rdbook ("book");
	while (TRUE) docommand ();
	}

rdbook (s)
	char *s;

	{int fd;
	fd = xopen (s, 'r');
	if (fd <= 0) return;
	bk_parse (fd);
	cclose (fd);
	}

int xopen (fname, mode)
	char *fname;

	{int fd, temp;
	temp = rsuset (USNAME);
	wsuset (USNAME, oldsname);
	fd = copen (fname, mode);
	wsuset (USNAME, temp);
	return (fd);
	}

int xdelete (fname)
	char *fname;

	{int temp;
	temp = rsuset (USNAME);
	wsuset (USNAME, oldsname);
	delete (fname);
	wsuset (USNAME, temp);
	}

savbook ()

	{int fd, n;
	filespec fs;
	char *itoa ();
	static char fnbuf[20] {'b', 'o', 'o', 'k', '.'};

	fd = xopen ("book", 'w');
	if (fd <= 0) {cprint ("Can't save book.\n"); cexit ();}
	filnam (itschan (fd), &fs);
	c6tos (fs.fn2, fnbuf+5);
	n = atoi (fnbuf+5);
	bk_print (fd);
	cclose (fd);
	n = n - 4;
	itoa (n, fnbuf+5);
	xdelete (fnbuf);
	}

docommand ()

	{int c;
	putchar ('%');
	c = utyi ();
	switch (c) {
	case 'g': cprint ("Grow tree\n"); dogrow (); break;
	case 'e': cprint ("Evaluate\n"); doeval (); break;
	case 'f': cprint ("Flush evaluations\n"); doflush (); break;
	case 'm': cprint ("Minimax\n"); bkminimax(); break;
	case 't': cprint ("Test moves\n"); testmoves(); return;
	case 'w': cprint ("Write tree\n"); dowrite(); return;
	default: putchar ('?'); return;
		}
	savbook ();
	}

dowrite ()

	{int fd;
	fd = xopen ("cbook", 'w');
	if (fd != OPENLOSS)
		{bk_write (fd);
		cclose (fd);
		}
	else cprint ("Cant write file\n");
	}

dogrow ()

	{int n;
	cprint ("Enter number of leaf nodes to grow: ");
	n = scani (cin);
	if (n<=0) return;
	bk_grow (n);
	}

doeval ()

	{int n;
	cprint ("Enter number of leaf nodes to evaluate: ");
	n = scani (cin);
	if (n<=0) return;
	bk_eval (n);
	}

doflush ()

	{bk_clean ();
	}

show (n)

	{char buf[20];
	int fd, w;

	fd = copen (buf, 'w', "s");
	cprint (fd, "%d", n);
	cclose (fd);
	w = csto6 (buf);
	wsuset (USNAME, w);
	}

testmoves ()

	{cprint ("Black moving first:\n");
	bk_clear (BLACK);
	tmoves (BLACK);
	cprint ("White moving first:\n");
	bk_clear (WHITE);
	tmoves (WHITE);
	}

tmoves (c)
	color c;

	{while (TRUE)
		{position p;
		struct mt t[64], *tp[64];
		int k, i;

		k = bk_lookup (t, tp);
		if (k == 0)
			{cprint ("Book has no moves.\n");
			return;
			}
		if (c==BLACK) cprint ("Moves for * are: ");
		else cprint ("Moves for @ are: ");
		for (i=0;i<k;++i)
			{p = tp[i]->p;
			cprint (" ");
			prpos (p, cout);
			cprint (",");
			}
		cprint ("\n");
		cprint ("Move: ");
		p = scanpos (cin);
		if (p < 0 || p > 100) return;
		bk_move (p);
		c = oppcolor (c);
		}
	}

atoi (s)
char *s;

	{int n, c;
	n = 0;
	while (c = *s++) n = (n * 10) + (c - '0');
	return (n);
	}

char *itoa (n, s)
char *s;

	{int a;
	if (n<0) n=0;
	if (a = (n / 10)) s = itoa (a, s);
	*s++ = '0' + n%10;
	*s = 0;
	return (s);
	}
