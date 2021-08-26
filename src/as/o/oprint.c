# include "o.h"

int movnum;

# define FORFEIT 1000
# define NOMOVE 1001
# define ILLEGAL 1002

main (argc, argv)
	char *argv[];

	{char *infn, *outfn;
	int in, out;
	++argv;
	--argc;
	if (argc != 2)
		{puts ("Usage: oprint in.file out.file");
		return;
		}
	infn = argv[0];
	outfn = argv[1];
	in = copen (infn, 'r');
	if (in == -1)
		{cprint ("Can't open input: %s\n", infn);
		return;
		}
	out = copen (outfn, 'w');
	if (out == -1)
		{cprint ("Can't open output: %s\n", outfn);
		return;
		}
	oprint (in, out);
	cclose (in);
	cclose (out);
	}

oprint (in, out)

	{board b;

	clrbrd (b);
	movnum = 1;
	while (domove (b, in, out));
	op_score (b, out);
	}

domove (b, in, out)
	board b;

	{position p1, p2;
	board b1;

	rmovnum (in);
	p1 = doply (b, in, BLACK);
	if (p1 == ILLEGAL) return (0);
	cpybrd (b1, b);
	if (p1 < FORFEIT) putmov (b1, BLACK, p1);
	p2 = doply (b1, in, WHITE);
	if (p2 == ILLEGAL) return (0);
	prbrds (b, b1, out);
	prmvs (p1, p2, out);
	cpybrd (b,b1);
	if (p2 < FORFEIT) putmov (b, WHITE, p2);
	++movnum;
	return (p2 != NOMOVE);
	}

position doply (b, in, cc)
	board b;
	color cc;

	{int c;
	position p;

	p = ILLEGAL;
	c = cgetc (in);
	if (c <= 0) return (NOMOVE);
	while (c == ' ' || c == '\t') c = cgetc (in);
	if (c == 'F' && !anymvs (b, cc)) p = FORFEIT;
	else if (c == '.' && movnum == 1 && cc == BLACK) p = NOMOVE;
	else if (c >= '1' && c <= '8')
		{int x, y;
		x = c - '1';
		c = cgetc (in);
		if (c == '-')
			{c = cgetc (in);
			if (c >= '1' && c <= '8')
				{position p1;
				y = c - '1';
				p1 = pos (x, y);
				if (ismove (b, cc, p1)) p = p1;
				}
			}
		}
	while (c != ' ' && c != '\n' && c)
		{if (c == '.')
			{cgetc (in);
			cgetc (in);
			break;
			}
		c = cgetc (in);
		}
	if (c == '\n' && cc == BLACK) ungetc (0, in);
	if (p == ILLEGAL) cprint ("Move %d is illegal.\n", movnum);
	return (p);
	}

prbrds (b, b1, out)
	board b, b1;

	{int x, y;
	cprint (out, "  1 2 3 4 5 6 7 8\t  1 2 3 4 5 6 7 8\n");
	for (x=0;x<8;++x)
		{cprint (out, "%d", x+1);
		for (y=0;y<8;++y) opsq (b,x,y,out);
		cprint (out, "\t%d", x+1);
		for (y=0;y<8;++y) opsq (b1,x,y,out);
		cputc ('\n', out);
		}
	cputc ('\n', out);
	}

prmvs (p1, p2, out)
	position p1, p2;

	{cprint (out, "%d.  ", movnum);
	prmv (p1, out);
	cprint (out, " ... ");
	prmv (p2, out);
	cputc ('\n', out);
	if ((movnum % 5) == 0) cputc ('\p', out);
	else cputc ('\n', out);
	}

prmv (p, out)
	position p;

	{switch (p) {
	case NOMOVE: cprint (out, "   "); return;
	case FORFEIT: cprint (out, "Forfeit"); return;
	case ILLEGAL: return;
		}
	cprint (out, "%d-%d", posx(p)+1, posy(p)+1);
	}

opsq (b, x, y, out)
	board b;
	position x, y;

	{register int z;
	extern char pcolor[];
	cputc (' ', out);
	z = b[pos(x,y)];
	if (z<=2) z = pcolor[z];
	cputc(z,out);
	}

rmovnum (in)

	{int c;
	c = cgetc (in);
	while (c != ' ' && c != '\t' && c) c = cgetc (in);
	}

op_score (b, out)
	{;}
