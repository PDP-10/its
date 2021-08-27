# include "c.defs"

/*
 * Editor
 */

# define MAXCHAR 50000
# define MAXLINE 5000

#define	SIGHUP	1
#define	SIGINTR	2
#define	SIGQUIT	3
#define	FNSIZE	64
#define	LBSIZE	512
#define	ESIZE	128
#define	GBSIZE	256
#define	MAXBRA	5
#define	_EOF	-1

#define	CBRA	1
#define	CCHR	2
#define	CDOT	4
#define	CCL	6
#define	NCCL	8
#define	CDOL	10
#define	EOF	11
#define	CKET	12

#define	STAR	01

#define	error	errfunc ()
#define	_READ	0
#define	_WRITE	1

int	peekc;
int	lastc;
int	tty;
char	savedfile[FNSIZE];
char	file[FNSIZE];
char	linebuf[LBSIZE];
char	rhsbuf[LBSIZE/2];
char	expbuf[ESIZE+4];
int	circfl;
int	*zero;
int	*dot;
int	*dol;
int	*addr1;
int	*addr2;
char	genbuf[LBSIZE];
long	count;

#define linebp linbp	/* to avoid conflict */

char	*linebp;
int	ninbuf;
int	io;
int	pflag;
int	vflag	1;
int	listf;
int	col;
char	*globp;
int	tfile	-1;
int	tline;
char	tfname[40];
char	*loc1;
char	*loc2;
char	*locs;
int	ichanged;
int	nleft;
int	errfunc();

char	buffer[MAXCHAR];
char	*ebuffer;

int	*lines[MAXLINE];
int	**elines;

tag	restart;

int	names[26];
char	*braslist[MAXBRA];
char	*braelist[MAXBRA];

extern int cin, cout;

main (argc, argv)
	char **argv;

	{register char *p1, *p2;
	extern int onintr();

	ebuffer = buffer + MAXCHAR;
	elines = lines + MAXLINE;

	on (ctrls_interrupt, 1);
	argv++; --argc;
	if (argc>0) {
		p1 = *argv;
		p2 = savedfile;
		while (*p2++ = *p1++);
		globp = "r";
	}
	tty = istty (cin) && istty (cout);
	init ();
	maktag (&restart);
	on (ctrlg_interrupt, onintr);
	commands();
	term ();
	}

commands()

	{int getfile(), gettty();
	register int *a1, c;

	for (;;)
		{if (pflag)
			{pflag = 0;
			addr1 = addr2 = dot;
			goto print;
			}
		addr1 = 0;
		addr2 = 0;
		if (tty && !peekc && !globp) cputc ('=', cout);
		do
			{addr1 = addr2;
			if ((a1 = address())==0)
				{c = getchar();
				break;
				}
			addr2 = a1;
			if ((c=getchar()) == ';')
				{c = ',';
				dot = a1;
				}
			} while (c==',');
		if (addr1==0) addr1 = addr2;
		switch(c) {

	case 'a':	setdot();
			newline();
			append(gettty, addr2);
			continue;

	case 'c':	delete();
			append(gettty, addr1-1);
			continue;

	case 'd':	delete();
			continue;

	case 'e':	setnoaddr();
			if ((peekc = getchar()) != ' ') error;
			savedfile[0] = 0;
			init();
			addr2 = zero;
			goto caseread;

	case 'f':	setnoaddr();
			if ((c = getchar()) != '\n')
				{peekc = c;
				savedfile[0] = 0;
				filename();
				}
			puts(savedfile);
			continue;

	case 'g':	global(1);
			continue;

	case 'i':	setdot();
			nonzero();
			newline();
			append(gettty, addr2-1);
			continue;

	case 'k':	if ((c = getchar()) < 'a' || c > 'z') error;
			newline();
			setdot();
			nonzero();
			names[c-'a'] = *addr2;
			continue;

	case 'm':	move(0);
			continue;

	case '\n':	if (addr2==0) addr2 = dot+1;
			addr1 = addr2;
			goto print;

	case 'l':	listf++;
	case 'p':	newline();
	print:		setdot();
			nonzero();
			a1 = addr1;
			do puts(getline(*a1++));
				while (a1 <= addr2);
			dot = addr2;
			listf = 0;
			continue;

	case 'q':	setnoaddr();
			newline();
			term ();

	case 'r':
	caseread:	filename();
			if ((io = copen (file, 'r')) == OPENLOSS)
				{lastc = '\n';
				error;
				}
			setall();
			ninbuf = 0;
			append(getfile, addr2);
			exfile();
			continue;

	case 's':	setdot();
			nonzero();
			substitute(globp);
			continue;

	case 't':	move(1);
			continue;

	case 'v':	global(0);
			continue;

	case 'w':	setall();
			nonzero();
			filename();
			if ((io = copen (file, 'w')) == OPENLOSS) error;
			putfile();
			exfile();
			continue;

	case '=':	setall();
			newline();
			count = (addr2-zero)&077777;
			putd();
			putchar('\n');
			continue;

/*	case '!':	unix();
			continue;
*/
	case _EOF:	return;
			}
		error;
		}
	}

address()

	{register int *a1, minus, c;
	int n, relerr;

	minus = 0;
	a1 = 0;
	for (;;)
		{c = getchar();
		if ('0'<=c && c<='9')
			{n = 0;
			do {
				n =* 10;
				n =+ c - '0';
			} while ((c = getchar())>='0' && c<='9');
			peekc = c;
			if (a1==0) a1 = zero;
			if (minus<0) n = -n;
			a1 =+ n;
			minus = 0;
			continue;
			}
		relerr = 0;
		if (a1 || minus) relerr++;
		switch(c) {
		case ' ':
		case '\t':	continue;
	
		case '+':	minus++;
				if (a1==0) a1 = dot;
				continue;

		case '-':
		case '^':	minus--;
				if (a1==0) a1 = dot;
				continue;
	
		case '?':
		case '/':	compile(c);
				a1 = dot;
				for (;;)
					{if (c=='/')
						{a1++;
						if (a1 > dol) a1 = zero;
						}
					else
						{a1--;
						if (a1 < zero) a1 = dol;
						}
					if (execute(0, a1)) break;
					if (a1==dot) error;
					}
				break;
	
		case '$':	a1 = dol;
				break;
	
		case '.':	a1 = dot;
				break;

		case '\'':	if ((c = getchar()) < 'a' || c > 'z')
					error;
				for (a1=zero; a1<=dol; a1++)
					if (names[c-'a'] == *a1) break;
				break;
	
		default:	peekc = c;
				if (a1==0) return(0);
				a1 =+ minus;
				if (a1<zero || a1>dol) error;
				return(a1);
			}
		if (relerr) error;
		}
	}

setdot()

	{if (addr2 == 0) addr1 = addr2 = dot;
	if (addr1 > addr2) error;
	}

setall()

	{if (addr2==0)
		{addr1 = zero+1;
		addr2 = dol;
		if (dol==zero) addr1 = zero;
		}
	setdot();
	}

setnoaddr()

	{if (addr2) error;
	}

nonzero()

	{if (addr1<=zero || addr2>dol) error;
	}

newline()

	{register int c;

	if ((c = getchar()) == '\n') return;
	if (c=='p' || c=='l')
		{pflag++;
		if (c=='l') listf++;
		if (getchar() == '\n') return;
		}
	error;
	}

filename()

	{register char *p1, *p2;
	register int c;

	count = 0;
	c = getchar();
	if (c=='\n' || c==_EOF)
		{p1 = savedfile;
		if (*p1==0) error;
		p2 = file;
		while (*p2++ = *p1++);
		return;
		}
	if (c!=' ') error;
	while ((c = getchar()) == ' ');
	if (c=='\n') error;
	p1 = file;
	do {*p1++ = c;} while ((c = getchar()) != '\n');
	*p1++ = 0;
	if (savedfile[0]==0)
		{p1 = savedfile;
		p2 = file;
		while (*p1++ = *p2++);
		}
	}

exfile()

	{cclose (io);
	io = -1;
	if (vflag)
		{putd();
		putchar('\n');
		}
	}

onintr()

	{putchar ('\n');
	lastc = '\n';
	error;
	}

errfunc()

	{register int c;

	listf = 0;
	puts ("?");
	count = 0;
	pflag = 0;
	if (globp) lastc = '\n';
	globp = 0;
	peekc = lastc;
	while ((c = getchar()) != '\n' && c != _EOF);
	if (io >= 0)
		{cclose(io);
		io = -1;
		}
	gotag (&restart);
	}

getchar()

	{if (lastc=peekc)
		{peekc = 0;
		return(lastc);
		}
	if (globp)
		{if ((lastc = *globp++) != 0) return(lastc);
		globp = 0;
		return(_EOF);
		}
	if ((lastc = cgetc (cin)) <= 0) return (lastc = _EOF);
	lastc =& 0177;
	return(lastc);
	}

gettty()

	{register int c, gf;
	register char *p;

	p = linebuf;
	gf = globp;
	while ((c = getchar()) != '\n')
		{if (c==_EOF)
			{if (gf) peekc = c;
			return(c);
			}
		if ((c =& 0177) == 0) continue;
		*p++ = c;
		if (p >= &linebuf[LBSIZE-2]) error;
		}
	*p++ = 0;
	if (linebuf[0]=='.' && linebuf[1]==0) return(_EOF);
	return(0);
	}

getfile()

	{register int c;
	register char *lp;

	lp = linebuf;
	do
		{c = cgetc (io) & 0177;
		if (c <= 0 && ceof (io)) return (_EOF);
		if (c == 0) continue;
		if (lp >= &linebuf[LBSIZE]) error;
		*lp++ = c;
		++count;
		} while (c != '\n');
	*--lp = 0;
	return(0);
	}

putfile()

	{register char *lp;
	register int c, *a1;

	a1 = addr1;
	do
		{lp = getline (*a1++);
		for (;;)
			{++count;
			c = *lp++;
			if (c) cputc (c, io);
			else
				{cputc ('\n', io);
				break;
				}
			}
		} while (a1 <= addr2);
	}

append (f, a)
	int (*f)();

	{register int *a1, *a2, *rdot;
	int nline, tl;

	nline = 0;
	dot = a;
	while ((*f)() == 0) {
		if (dol >= elines) error;
		tl = putline();
		nline++;
		a1 = ++dol;
		a2 = a1+1;
		rdot = ++dot;
		while (a1 > rdot) *--a2 = *--a1;
		*rdot = tl;
		}
	return (nline);
	}

delete()

	{register int *a1, *a2, *a3;

	setdot();
	newline();
	nonzero();
	a1 = addr1;
	a2 = addr2+1;
	a3 = dol;
	dol =- a2 - a1;
	do *a1++ = *a2++; while (a2 <= a3);
	a1 = addr1;
	if (a1 > dol) a1 = dol;
	dot = a1;
	}

getline (tl)

	{register char *bp, *lp;
	register int nl;

	lp = linebuf;
	bp = getblock (tl, _READ);
	nl = nleft;
	while (*lp++ = *bp++)
		if (--nl == 0)
			{bp = getblock (tl =+ nleft, _READ);
			nl = nleft;
			}
	return (linebuf);
	}

putline()

	{register char *bp, *lp;
	register int nl;
	int tl;

	lp = linebuf;
	tl = tline;
	bp = getblock (tl, _WRITE);
	nl = nleft;
	while (*bp = *lp++)
		{if (*bp++ == '\n')
			{*--bp = 0;
			linebp = lp;
			break;
			}
		if (--nl == 0)
			{bp = getblock(tl =+ nleft, _WRITE);
			nl = nleft;
			}
		}
	nl = tline;
	tline =+ (lp-linebuf);
	tline = adjline (tline);
	return (nl);
	}

getblock (atl, iof)

	{nleft = MAXCHAR - atl;
	return (buffer + atl);
	}

init()

	{tline = 0;
	dot = zero = dol = lines;
	}

global(k)

	{register char *gp;
	register int c;
	register int *a1;
	char globuf[GBSIZE];

	if (globp) error;
	setall();
	nonzero();
	if ((c=getchar())=='\n') error;
	compile(c);
	gp = globuf;
	while ((c = getchar()) != '\n') {
		if (c==_EOF) error;
		if (c=='\\')
			{c = getchar();
			if (c!='\n') *gp++ = '\\';
			}
		*gp++ = c;
		if (gp >= &globuf[GBSIZE-2]) error;
		}
	*gp++ = '\n';
	*gp++ = 0;
	for (a1=zero; a1<=dol; a1++)
		{unmark (a1);
		if (a1>=addr1 && a1<=addr2 && execute(0, a1)==k)
			mark (a1);
	}
	for (a1=zero; a1<=dol; a1++) {
		if (marked (a1))
			{unmark (a1);
			dot = a1;
			globp = globuf;
			commands();
			a1 = zero;
		}
	}
}

substitute(inglob)

	{register int gsubf, *a1, nl;
	int getsub();

	gsubf = compsub();
	for (a1 = addr1; a1 <= addr2; a1++)
		{if (execute (0, a1)==0) continue;
		inglob =| 01;
		dosub();
		if (gsubf)
			{while (*loc2)
				{if (execute(1)==0) break;
				dosub();
				}
			}
		*a1 = putline();
		nl = append (getsub, a1);
		a1 =+ nl;
		addr2 =+ nl;
		}
	if (inglob==0) error;
	}

compsub()

	{register int seof, c;
	register char *p;

	if ((seof = getchar()) == '\n') error;
	compile(seof);
	p = rhsbuf;
	for (;;)
		{c = getchar();
		if (c=='\\') c = getchar() | 0200;
		if (c=='\n') error;
		if (c==seof) break;
		*p++ = c;
		if (p >= &rhsbuf[LBSIZE/2]) error;
		}
	*p++ = 0;
	if ((peekc = getchar()) == 'g')
		{peekc = 0;
		newline();
		return(1);
		}
	newline();
	return(0);
	}

getsub()

	{register char *p1, *p2;

	p1 = linebuf;
	if ((p2 = linebp) == 0) return (_EOF);
	while (*p1++ = *p2++);
	linebp = 0;
	return (0);
	}

dosub()

	{register char *lp, *sp, *rp;
	int c;

	lp = linebuf;
	sp = genbuf;
	rp = rhsbuf;
	while (lp < loc1) *sp++ = *lp++;
	while (c = *rp++)
		{if (c=='&')
			{sp = place(sp, loc1, loc2);
			continue;
			}
		else if (c<0 && (c =& 0177) >='1' && c < MAXBRA+'1')
			{sp = place(sp, braslist[c-'1'], braelist[c-'1']);
			continue;
			}
		*sp++ = c&0177;
		if (sp >= &genbuf[LBSIZE]) error;
		}
	lp = loc2;
	loc2 = linebuf + (sp - genbuf);
	while (*sp++ = *lp++) if (sp >= &genbuf[LBSIZE]) error;
	lp = linebuf;
	sp = genbuf;
	while (*lp++ = *sp++);
	}

place(asp, al1, al2)

	{register char *sp, *l1, *l2;

	sp = asp;
	l1 = al1;
	l2 = al2;
	while (l1 < l2)
		{*sp++ = *l1++;
		if (sp >= &genbuf[LBSIZE]) error;
		}
	return(sp);
	}

move(cflag)

	{register int *adt, *ad1, *ad2;
	int getcopy();

	setdot();
	nonzero();
	if ((adt = address())==0)
		error;
	newline();
	ad1 = addr1;
	ad2 = addr2;
	if (cflag) {
		ad1 = dol;
		append(getcopy, ad1++);
		ad2 = dol;
	}
	ad2++;
	if (adt<ad1) {
		dot = adt + (ad2-ad1);
		if ((++adt)==ad1)
			return;
		reverse(adt, ad1);
		reverse(ad1, ad2);
		reverse(adt, ad2);
	} else if (adt >= ad2) {
		dot = adt++;
		reverse(ad1, ad2);
		reverse(ad2, adt);
		reverse(ad1, adt);
	} else
		error;
}

reverse(aa1, aa2)
{
	register int *a1, *a2, t;

	a1 = aa1;
	a2 = aa2;
	for (;;) {
		t = *--a2;
		if (a2 <= a1)
			return;
		*a2 = *a1;
		*a1++ = t;
	}
}

getcopy()
{
	if (addr1 > addr2)
		return(_EOF);
	getline(*addr1++);
	return(0);
}

compile (aeof)

	{register int eofchar, c;
	register char *ep;
	char *lastep;
	char bracket[MAXBRA], *bracketp;
	int nbra;
	int cclcnt;

	ep = expbuf;
	eofchar = aeof;
	bracketp = bracket;
	nbra = 0;
	if ((c = getchar()) == eofchar)
		{if (*ep==0) error;
		return;
		}
	circfl = 0;
	if (c=='^')
		{c = getchar();
		circfl++;
		}
	if (c=='*') goto cerror;
	peekc = c;
	for (;;)
		{if (ep >= &expbuf[ESIZE]) goto cerror;
		c = getchar();
		if (c == eofchar)
			{*ep++ = EOF;
			return;
			}
		if (c!='*') lastep = ep;
		switch (c) {

		case '\\':
			if ((c = getchar())=='(') {
				if (nbra >= MAXBRA)
					goto cerror;
				*bracketp++ = nbra;
				*ep++ = CBRA;
				*ep++ = nbra++;
				continue;
			}
			if (c == ')') {
				if (bracketp <= bracket)
					goto cerror;
				*ep++ = CKET;
				*ep++ = *--bracketp;
				continue;
			}
			*ep++ = CCHR;
			if (c=='\n')
				goto cerror;
			*ep++ = c;
			continue;

		case '.':
			*ep++ = CDOT;
			continue;

		case '\n':
			goto cerror;

		case '*':
			if (*lastep==CBRA || *lastep==CKET)
				error;
			*lastep =| STAR;
			continue;

		case '$':
			if ((peekc=getchar()) != eofchar)
				goto defchar;
			*ep++ = CDOL;
			continue;

		case '[':
			*ep++ = CCL;
			*ep++ = 0;
			cclcnt = 1;
			if ((c=getchar()) == '^') {
				c = getchar();
				ep[-2] = NCCL;
			}
			do {
				if (c=='\n')
					goto cerror;
				*ep++ = c;
				cclcnt++;
				if (ep >= &expbuf[ESIZE])
					goto cerror;
			} while ((c = getchar()) != ']');
			lastep[1] = cclcnt;
			continue;

		defchar:
		default:
			*ep++ = CCHR;
			*ep++ = c;
		}
	}
   cerror:
	expbuf[0] = 0;
	error;
}

execute(gf, addr)
int *addr;

	{register char *p1, *p2, c;

	if (gf)
		{if (circfl) return(0);
		p1 = linebuf;
		p2 = genbuf;
		while (*p1++ = *p2++);
		locs = p1 = loc2;
		}
	else
		{if (addr==zero) return(0);
		p1 = getline(*addr);
		locs = 0;
		}
	p2 = expbuf;
	if (circfl)
		{loc1 = p1;
		return(advance(p1, p2));
		}
	/* fast check for first character */
	if (*p2==CCHR)
		{c = p2[1];
		do
			{if (*p1!=c) continue;
			if (advance(p1, p2))
				{loc1 = p1;
				return(1);
				}
			} while (*p1++);
		return(0);
		}
	/* regular algorithm */
	do
		{if (advance(p1, p2))
			{loc1 = p1;
			return(1);
			}
		} while (*p1++);
	return(0);
	}

advance (alp, aep)

	{register char *lp, *ep, *curlp;

	lp = alp;
	ep = aep;
	for (;;) switch (*ep++) {
	case CCHR:	if (*ep++ == *lp++) continue;
			return(0);
	case CDOT:	if (*lp++) continue;
			return(0);
	case CDOL:	if (*lp==0) continue;
			return(0);
	case EOF:	loc2 = lp;
			return(1);
	case CCL:	if (cclass(ep, *lp++, 1))
				{ep =+ *ep;
				continue;
				}
			return(0);
	case NCCL:	if (cclass(ep, *lp++, 0))
				{ep =+ *ep;
				continue;
				}
			return(0);
	case CDOT|STAR:	curlp = lp;
			while (*lp++);
			goto do_star;
	case CCHR|STAR:	curlp = lp;
			while (*lp++ == *ep);
			ep++;
			goto do_star;
	case CCL|STAR:
	case NCCL|STAR:	curlp = lp;
			while (cclass(ep, *lp++, ep[-1]==(CCL|STAR)));
			ep =+ *ep;
			goto do_star;
	do_star:	do {
				lp--;
				if (advance(lp, ep)) return (1);
				} while (lp > curlp);
			return(0);
	default:	error;
		}
	}

cclass (aset, ac, af)

	{register char *set, c;
	register int n;

	set = aset;
	if ((c = ac) == 0) return(0);
	n = *set++;
	while (--n) if (*set++ == c) return(af);
	return(!af);
	}

putd ()

	{cprint ("%d", count);}

puts (as)

	{register char *sp;

	sp = as;
	col = 0;
	while (*sp) putchar(*sp++);
	putchar('\n');
	}

putchar (ac)

	{register int c;

	c = ac;
	if (listf)
		{++col;
		if (col >= 72)
			{col = 0;
			cputc ('\\', cout);
			cputc ('\n', cout);
			}
		if ((c<' ' && c!= '\n') || (c == 0177))
			{cputc ('^', cout);
			cputc (c ^ 0100, cout);
			++col;
			}
		else cputc (c, cout);
		}
	else cputc (c, cout);
	}

term ()

	{ /* unlink (tfname); */
	cexit ();
	}

/* mark line */
mark (a)
	int *a;
	{*a =| 0400000000000;}

unmark (a)
	int *a;
	{*a =& ~0400000000000;}

marked (a)
	int *a;
	{return (*a & 0400000000000);}
adjline (tl)
	{return (tl);}
