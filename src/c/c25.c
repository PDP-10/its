#
/*

	C COMPILER
	Phase P: Parser
	Section 5: Parsing Routine

	Copyright (c) 1977 by Alan Snyder

*/

struct _token { int tag, index, line; };
# define token struct _token
token *dmperr(),*lex(),*tok(),*ctok(),*yreset();

# define pssize 200
# define tbsize 30
# define FALSE 0
# define TRUE 1
extern	int cout;
int	lextag;
int	lexindex;
int	lexline;
int	debug	FALSE;
int	edebug	FALSE;
int	xflag	FALSE;
int	tflag	FALSE;
int	val;
int	line;
int	*pv;
int	*pl;
int	lineno;

static int	*ps;
static int	s[pssize];
static int	v[pssize];
static int	l[pssize];
static int	*sps;
static int	*spv;
static int	*spl;
static int	ss[pssize];
static int	sv[pssize];
static int	sl[pssize];
static int	must 7;
static int	errcount 0;
static int	tskip;
static int	spop;
static int	errmode 0;
static int	tabmod FALSE;
parse()
{extern int	(*act[])(), g[], pg[], r1[], r2[], a[], pa[], nwpbt;
int		ac, op, n, state, *ap, *gp, control, i, r,
		tlimit, slimit, *p, *ip, o, (*fp)(), t, errn;
token		*ct, *tp;
ps = &s[0];
pv = &v[0];
pl = &l[0];
state = 1;
*ps = 1;
*pv = 0;
*pl = 0;
ct = lex();
if (!tabmod)
	{
	ip = pa;
	while ((o = *++ip) != -1) *ip = &a[o];
	ip = pg;
	while ((o = *++ip) != -1) *ip = &g[o];
	tabmod = TRUE;
	}
while (TRUE)
	{ap = pa[state];
	if (debug)
		cprint("executing state %d, token=%d\n",state, ct->tag);
	while (TRUE)
		{ac = *ap++;
		op = ac>>12;
		n = ac&07777;
		switch (op) {
	case 1:
		if (ct->tag!=n) ++ap;
		continue;
	case 2:
		state = n;
shift:		val = ct->index;
		line = ct->line;
 		ct = lex();
		if (errcount)
			{--errcount;
			if (errcount==0)
				{ct = dmperr(ct);
				control = 0;
				break;
				}
			}
		control=1;
		break;
	case 3:
		if (debug) cprint ("reduce %d\n",n);
		r = r2[n];
		ps =- r;
		pv =- r;
		pl =- r;
		if (r>0)
			{val = pv[1];
			line = pl[1];
			}
		else
			{val = ct->index;
			line = ct->line;
			}
		if (!xflag && (fp = act[n])) (*fp)();
		state = *ps;
		gp= pg[r1[n]];
		while (*gp)
			{if (*gp==state) break;
			gp=+2;
			}
		state = *++gp;
		control = 1;
		break;
	case 5:
		t = ct->tag;
		if (ap[t>>4] & (1<<(t&017)))
			{state = *(a+n+t-1);
			goto shift;
			}
		ap =+ nwpbt;
		continue;
	case 4:
		if (errmode)
			{ct = dmperr(ct);
			control = 0;
			break;
			}
		return (FALSE);
	case 0:
		switch (errmode) {
		case 0:
	if (edebug) cprint("errmode=0:st=%d,nst=%d,tok=%d\n",
		state,ps-s,ct->tag);
			synerr (ct->line);
			p=s;
			while (p<=ps) qprint (*p++);
			pcursor ();
			tkeem();
			for (i=0;i<5;++i)
				{tp = tok(i);
				if (tp->tag==1) break;
				tprint (tp);
				}
			save();
			errcount = must;
			errmode = 1;
			xflag =| 2;
			tlimit = tbsize - must - 2;
			slimit = ps-s;
			tskip = 0;
			spop = 0;
			errn = 1;
		case 1:
			restore();
			yreset();
			if ((++tskip & 1) == 0) --spop;
			if (spop<0 || ct->tag==1 || tskip>tlimit)
				{spop = errn++;
				tskip = 0;
				}
			if (spop <= slimit)
				{ct = ctok(tskip);
				control = -spop;
				break;
				}
			giveup (ct->line);
			return (TRUE);
			}
		if (edebug) cprint ("spop=%d,tskip=%d,token=%d\n",
			spop,tskip,ct->tag);
		break;
		}
	if (control>0)
		{if (debug) cprint ("stack st=%d val=%d\n",state,val);
		*++ps = state;
		*++pv = val;
		*++pl = line;
		if (ps-s>=pssize)
			{stkovf (ct->line);
			return (TRUE);
			}
		}
	else if (control<0)
		{pv =+ control;
		ps =+ control;
		pl =+ control;
		if (ps<s)
			{stkunf (ct->line);
			return (TRUE);
			}
		}
	state = *ps;
	break;
	}
	}
}
token *dmperr(ct)
	token *ct;
	{int i;
	token *tp;
	yreset();
	restore();
	if (spop>0) delmsg (ct->line);
	for (i=1;i<=spop;++i)
		qprint (ps[-spop+i]);
	if (tskip>0) skpmsg (ct->line);
	for(i=0;i<tskip;++i)
		tprint ( tok(i));
	xflag =& ~02;
	errmode = 0;
	errcount = 0;
	ps =- spop;
	pv =- spop;
	pl =- spop;
	tp = ctok (tskip);
	tklem();
	return (tp);
	}
save()
	{int *p1,*p2;
	p1=s;
	p2=ss;
	do *p2++ = *p1++; while (p1 <= ps);
	p1=v;
	p2=sv;
	do *p2++ = *p1++; while (p1 <= pv);
	p1=l;
	p2=sl;
	do *p2++ = *p1++; while (p1 <= pl);
	sps=ps;
	spv=pv;
	spl=pl;
	}
restore()
	{int *p1,*p2;
	ps=sps;
	pv=spv;
	pl=spl;
	p1=s;
	p2=ss;
	do *p1++ = *p2++; while (p1 <= ps);
	p1=v;
	p2=sv;
	do *p1++ = *p2++; while (p1 <= pv);
	p1=l;
	p2=sl;
	do *p1++ = *p2++; while (p1 <= pl);
	errcount=must;
	}
token	tokbuf [tbsize];
token	*tct tokbuf;
token	*twp tokbuf;
int	tokmode 0;
token	*lex()
	{if (++tct >= twp) 
		{if (tokmode==0) tct=twp=tokbuf;
		else
			{if (twp>=tokbuf+tbsize) tkbovf (tct->line);
			if (tct>twp) badtwp (tct->line);
			}
		rtoken (twp++);
		}
	if (tflag && !tokmode)
		{ptoken (tct, cout);
		cputc ('\n', cout);
		}
	lineno = tct->line;
	return (tct);
	}
token	*tok(i)
	{token *p;
	p = tct + i;
	if (p<tokbuf || p>=tokbuf+tbsize)
		badtok (tct->line, i);
	while (p>=twp) rtoken (twp++);
	return (p);
	}
token	*ctok(i)
	{return (tct = tok(i));}
token	*yreset()
	{return (tct = tokbuf);}
tkeem()
	{int i,j;
	token *tp1, *tp2;
	tokmode = 1;
	j = i = twp - tct;
	if (i>0)
		{tp1 = tokbuf-1;
		tp2 = tct-1;
		while (i--)
			{(++tp1)->tag = (++tp2)->tag;
			tp1->index = tp2->index;
			tp1->line = tp2->line;
			}
		}
	tct = tokbuf;
	twp = tct + j;
	}
tklem()
	{tokmode = 0;}
rtoken(p) token *p;
	{
	gettok();
	p->tag = lextag;
	p->index = lexindex;
	p->line = lexline;
	}

