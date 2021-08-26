#define GENBOOK 1
#include "ob.h"

/**********************************************************************

	bk_read (fd)		read book from file
	bk_write (fd)		write book to file
	bk_parse (fd)		read book in readable form
	bk_print (fd)		print book in readable form
	bk_clear (c)		reset to beginning of game
	bk_move (p)		make move at p
	bk_lookup (t, tp) -> k	return current book move(s)

	bk_grow (n)		grow n nodes
	bn_grow (b)		grow successors to node b

**********************************************************************/

bnode *bnlist[MAXNODE];
int nnodes 0;
extern bnode *curbn;
extern rotation currot;
int book[];

bnode *bnfind(), *extrace();
position rotate();

position movlst[] {
	pos(3,3), pos(3,4), pos(4,3), pos(4,4),
	pos(2,3), pos(2,4), pos(3,2), pos(3,5),
	pos(4,2), pos(4,5), pos(5,3), pos(5,4),
	pos(7,3), pos(7,4), pos(7,5), pos(7,6),
	pos(2,2), pos(2,5), pos(5,2), pos(5,5),
	pos(0,0), pos(0,7), pos(7,0), pos(7,7),
	pos(0,1), pos(0,2), pos(0,3), pos(0,4),
	pos(0,5), pos(0,6), pos(1,0), pos(1,7),
	pos(2,0), pos(2,7), pos(3,0), pos(3,7),
	pos(4,0), pos(4,7), pos(5,0), pos(5,7),
	pos(6,0), pos(6,7), pos(7,1), pos(7,2),
	pos(1,2), pos(1,3), pos(1,4), pos(1,5),
	pos(2,1), pos(2,6), pos(3,1), pos(3,6),
	pos(4,1), pos(4,6), pos(5,1), pos(5,6),
	pos(6,2), pos(6,3), pos(6,4), pos(6,5),
	pos(1,1), pos(1,6), pos(6,1), pos(6,6),
	-1
	};

bnode *bnalloc ()

	{return (calloc (sizeof (*curbn)/sizeof (0)));}

bnode *bntrim (bn)
	bnode *bn;

	{bnode *nn;
	int save, sz, *d, *s;
	if (bn->nmoves == MAXEXIT) return (bn);
	sz = sizeof (bn->moves[0]);
	save = sz * (MAXEXIT - bn->nmoves);
	sz = ((sizeof (*curbn) - save)/sizeof(0));
	nn = calloc (sz);
	s = bn;
	d = nn;
	while (--sz >= 0) *d++ = *s++;
	bnlist[nn->nodenum] = nn;
	cfree (bn);
	return (nn);
	}

bnode *bnexpand (bn)
	bnode *bn;

	{bnode *nn;
	int save, sz, *d, *s;
	if (bn->nmoves == MAXEXIT) return (bn);
	sz = sizeof (bn->moves[0]);
	save = sz * (MAXEXIT - bn->nmoves);
	sz = ((sizeof (*curbn) - save)/sizeof(0));
	nn = calloc (sizeof (*curbn)/sizeof(0));
	s = bn;
	d = nn;
	while (--sz >= 0) *d++ = *s++;
	bnlist[nn->nodenum] = nn;
	cfree (bn);
	return (nn);
	}

bnode *bnuniq (b, pr)
	bnode *b;
	rotation *pr;

	{int i;
	*pr = R0;
	for (i=1;i<=nnodes;++i)
		{bnode *ob;
		ob = bnlist[i];
		if (ob == b) return (ob);
		if (ob)
			{rotation r;
			if ((r = bncompare (b, ob)) >= 0)
				{*pr = r;
				cfree (b);
				return (ob);
				}
			}
		}
	b->nodenum = ++nnodes;
	bnlist[nnodes] = b;
	return (bntrim (b));
	}

rotation bncompare (b1, b2)
	bnode *b1, *b2;

	{rotation r;
	int *bd1, *bd2;
	if (b1->c != b2->c) return (-1);
	bd1 = b1->b;
	bd2 = b2->b;
	if (bscore (bd1, WHITE) != bscore (bd2, WHITE)) return (-1);
	if (bscore (bd1, BLACK) != bscore (bd2, BLACK)) return (-1);
	for (r=0;r<12;++r) if (brcomp (bd1, bd2, r)) return (r);
	return (-1);
	}

int brcomp (b1, b2, r)
	board b1, b2;
	rotation r;

	{position p, *pp;
	forallpos (p, pp)
		if (b1[p] != b2[rotate(p,r)]) return (FALSE);
	return (TRUE);
	}

# ifdef GENBOOK

/**********************************************************************

	bk_grow

**********************************************************************/

bk_grow (n)

	{int depth, count;
	if (nnodes == 0)
		{int i;
		bnode *b;
		b = bnalloc ();
		clrbrd (b->b);
		b->c = BLACK;
		b->nmoves = 0;
		b->depth = 1;
		b->eval = NOT_EVAL;
		bnuniq (b, &i);
		}
	depth = 1;
	count = 0;
	show (count);
	while (TRUE)
		{int i;
		bnode *b;
		for (i=1;i<=nnodes;++i)
			{b = bnlist[i];
			if (b && b->depth == depth && b->nmoves == 0)
				{bn_grow (b);
				++count;
				show (count);
				if (count >= n) return;
				if ((count%10)==0) savbook ();
				}
			}
		if (count == 0 && depth == 12) return;
		++depth;
		}
	}

bk_eval (n)

	{int i, count;

	count = 0;
	show (count);
	for (i=1;i<=nnodes;++i)
		{bnode *b;
		b = bnfind (i);
		if (b && b->eval == NOT_EVAL && b->nmoves==0)
			{b->eval = geval (b->b, b->c);
			++count;
			show (count);
			if (count >= n) return;
			if ((count%10)==0) savbook ();
			}
		}
	}

bk_clean ()

	{int i;

	for (i=1;i<=nnodes;++i)
		{bnode *b;
		b = bnfind (i);
		if (b) b->eval = NOT_EVAL;
		}
	}

# endif

static int wrcount;

bk_write (fd)
	int fd;

	{int i, maxn, o[MAXNODE];
	maxn = 0;
	wrcount = 1;
	cprint (fd, "int book[] {0, ");
	for (i=1;i<=nnodes;++i)
		{bnode *bn;
		o[i] = wrcount;
		bn = bnfind (i);
		if (bn && bn->nmoves>0)
			{bn_write (bn, fd);
			maxn = i;
			}
		}
	cprint (fd, "};\nint *bnlist[] {0, ");
	for (i=1;i<=maxn;++i)
		{bnode *bn;
		bn = bnfind (i);
		if (bn && bn->nmoves>0)
			cprint (fd, "%d", o[i]);
		else cprint (fd, "0");
		if (i < maxn)
			{if ((i%10) == 0) cprint (fd, ",\n");
			else cprint (fd, ", ");
			}
		}
	cprint (fd, "};\n");
	cprint (fd, "int nnodes {%d};\n", maxn);
	}

bn_write (bn, fd)
	bnode *bn;

	{int i;
	
	cprint (fd, "%d, %d", bn->nodenum, bn->nmoves);
	wrcount =+ 2;
	for (i=0;i<bn->nmoves;++i)
		{exit *e, temp;
		bnode *b;
		int next, sz, *p;
		e = &bn->moves[i];
		next = getnext(e);
		b = bnfind (next);
		if (!b || b->nmoves == 0) next = 0;
		 {position ep;
		 rotation er;
		 int eg;
		 ep = getpos (e);
		 er = getrot (e);
		 eg = getgood (e);
		 consexit (&temp, ep, eg, er, next);
		 }
		p = &temp;
		sz = sizeof(temp)/sizeof(0);
		while (--sz >= 0)
			{cprint (fd, ", %d", *p++);
			++wrcount;
			}
		}
	cprint (fd, ",\n");
	}

bk_print (fd)
	int fd;

	{int i;
	for (i=1;i<=nnodes;++i)
		{bnode *bn;
		bn = bnfind (i);
		if (bn) bn_print (bn, fd);
		}
	}

bn_print (b, fd)
	bnode *b;

	{int j, nmoves;
#ifdef GENBOOK
	if (b->depth==0) return;
#endif
	cprint (fd, "%3d:  ", b->nodenum);
	j = b->eval;
	if (j != NOT_EVAL)
		cprint (fd, "[%d]  ", j);
	nmoves = b->nmoves;
	for (j=0;j<nmoves;++j)
		{exit *e;
		e = &b->moves[j];
		cprint (fd, "  ");
		prpos (getpos(e), fd);
		if (getrot(e) != R0)
			{cprint (fd, " ");
			prrot (getrot(e), fd);
			}
		cprint (fd, " %d", getnext(e));
		if (getgood(e)) cprint (fd, "g");
		if (j<nmoves-1) cprint (fd, ",");
		}
	cprint (fd, ";\n");
	}

bk_parse (fd)
	int fd;

	{while (bn_parse (fd));
# ifdef GENBOOK
	bkfixup ();
# endif
	}

/**********************************************************************

	parse bnode

**********************************************************************/

int bn_parse (fd)
	int fd;

	{int bnum, i;
	bnode *b;

	bnum = scani (fd);
	if (bnum<0) return (FALSE);
	b = bnalloc ();
	b->nodenum = bnum;
	if (bnum > nnodes) nnodes = bnum;
	bnlist[bnum] = b;
	b->nmoves = 0;
	b->eval = NOT_EVAL;
# ifdef GENBOOK
	b->depth = 0;
	b->c = EMPTY;
# endif
	if (scanc (fd, ':') == FALSE) return (FALSE);
	if (scanc (fd, '['))
		{b->eval = scani (fd);
		scanc (fd, ']');
		}
	i = 0;
	while (bkpex (fd, b, i)) ++i;
	bntrim (b);
	return (TRUE);
	}

/**********************************************************************

	parse exit

**********************************************************************/

int bkpex (fd, b, i)
	int fd;
	bnode *b;
	int i;

	{position p;
	rotation r;
	int bnnum;

	p = scanpos (fd);
	if (p>=0)
		{r = scanrot (fd);
		bnnum = scani (fd);
		if (bnnum>=0)
			{int good;
			good = scanc (fd, 'g');
			consexit (&b->moves[i],p,good,r,bnnum);
			++b->nmoves;
			if (scanc (fd, ',')) return (TRUE);
			}
		}
	skipc (fd, ';');
	return (FALSE);
	}

/**********************************************************************

	skipc - skip to a character

**********************************************************************/

skipc (fd, match)
	int fd;
	char match;

	{int c;
	while (TRUE)
		{c = cgetc (fd);
		if (c <= 0 && ceof (fd)) return;
		if (c == match) return;
		}
	}

/**********************************************************************

	scanc - scan for a character

**********************************************************************/

int scanc (fd, match)
	int fd;
	char match;

	{int c;
	c = skipb (fd);
	if (c==match) return (TRUE);
	ungetc (c, fd);
	return (FALSE);
	}

/**********************************************************************

	skipb - skip blanks

**********************************************************************/

int skipb (fd)

	{int c;
	while (TRUE)
		{c = cgetc (fd);
		if (c<=0 && ceof(fd)) return (0);
		if (c==' ' || c=='\t' || c=='\n') continue;
		return (c);
		}
	}

/**********************************************************************

	skipw - skip a word and its terminator

**********************************************************************/

skipw (fd)

	{int c;
	while (TRUE)
		{c = cgetc (fd);
		if (c<=0 && ceof(fd)) return;
		if (c==' ' || c=='\t' || c=='\n') return;
		}
	}

/**********************************************************************

	scani - read an integer

**********************************************************************/

int scani (fd)
	int fd;

	{int c, sum, negflag;
	sum = -1;

	negflag = FALSE;
	c = skipb (fd);
	if (c == '-')
		{negflag = TRUE;
		c = cgetc (fd);
		}
	if (c >= '0' && c <= '9')
		{sum = 0;
		while (c >= '0' && c <= '9')
			{sum = (sum * 10) + c-'0';
			c = cgetc (fd);
			}
		if (negflag) sum = -sum;
		}
	if (c > 0) ungetc (c, fd);
	return (sum);
	}

position scanpos (fd)
	int fd;

	{int x, y;
	if (scanc (fd, 'f'))
		{skipw (fd);
		return (0);
		}
	x = scani (fd);
	if (x<0) return (-1);
	if (scanc (fd, '-') == FALSE) return (-1);
	y = scani (fd);
	if (y<0) return (-1);
	return (pos (x-1, y-1));
	}

prpos (p, fd)
	position p;

	{if (p==0) cprint (fd, "forfeit");
	else cprint (fd, "%d-%d",posx(p)+1,posy(p)+1);
	}

rotation scanrot (fd)
	int fd;

	{if (scanc (fd, 'r'))
		return (scani (fd)/90);
	if (scanc (fd, 'h'))
		return (4 + scani (fd)/90);
	if (scanc (fd, 'v'))
		return (8 + scani (fd)/90);
	return (0);
	}

prrot (r, fd)
	rotation r;

	{switch (r/4) {
		case 0: cprint (fd, "r"); break;
		case 1: cprint (fd, "h"); break;
		case 2: cprint (fd, "v"); break;
		}
	cprint (fd, "%d", 90*(r%4));
	}

# ifdef GENBOOK

/**********************************************************************

	bn_grow (b)

**********************************************************************/

bn_grow (b)
	bnode *b;

	{position p, *pp;
	if (b->nmoves > 0) return;
	b = bnexpand (b);
	forallpos (p, pp) if (!adjcorner(p) && ismove (b->b, b->c, p))
		{bnode *nb;
		rotation r;
		if (b->nmoves == MAXEXIT)
			{cprint ("Node %d too many exits.\n", b->nodenum);
			return;
			}
		nb = bnalloc ();
		nb->depth = b->depth + 1;
		nb->c = oppcolor (b->c);
		nb->nmoves = 0;
		nb->eval = NOT_EVAL;
		cpybrd (nb->b, b->b);
		putmov (nb->b, b->c, p);
		nb = bnuniq (nb, &r);
		consexit (&b->moves[b->nmoves],p,FALSE,r,nb->nodenum);
		++b->nmoves;
		}
	bntrim (b);
	}

bkfixup ()

	{board b;
	clrbrd (b);
	bkfxnode (bnfind (1), 1, b, BLACK);
	}

bkfxnode (bn, depth, b, c)
	bnode *bn;
	board b;
	color c;

	{int i;
	color o;
	if (bn == 0) return;
	if (bn->c != EMPTY) return;
	if (bn->depth != 0) return;
	bn->c = c;
	bn->depth = depth;
	cpybrd (bn->b, b);
	++depth;
	o = oppcolor (c);
	i = bn->nmoves;
	while (--i >= 0) if (getrot(&bn->moves[i]) == R0)
		{board a;
		position p;
		bnode *next;
		p = getpos (&bn->moves[i]);
		if (!ismove (b, c, p))
			{cprint ("Node %d move at ");
			prpos (p);
			cprint (" is not legal.\n");
			return;
			}
		cpybrd (a, b);
		putmov (a, c, p);
		next = extrace (bn, i);
		bkfxnode (next, depth, a, o);
		}
	}

# endif
