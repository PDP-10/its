/*

	PARSING ROUTINE

	Requires the following:

	the tables produced by YACC
	GETTOK - a lexical routine
	PTOKEN - a token printing routine
	a set of error message routines (one such set is
		contained in the file YERROR >)
	Returns TRUE if a fatal syntax error occured.

*/

struct _token { int type, index, line; };
# define token struct _token
token *dmperr(),*lex(),*tok(),*ctok(),*yreset();

# define pssize 200
# define tbsize 30
# define FALSE 0
# define TRUE 1

extern int cout;

/*	GLOBAL VARIABLES USED TO RECEIVE INFO FROM GETTOK	*/

int	lextype;	/* indicates which terminal symbol read */
int	lexindex;	/* used as translation element */
int	lexline;	/* line-number of line which token appears on */

/*	GLOBAL VARIABLES WHICH MAY BE SET TO INDICATE OPTIONS	*/

int	debug	FALSE;	/* nonzero => print debugging info */
int	edebug	FALSE;	/* nonzero => print error recovery info */
int	xflag	FALSE;	/* nonzero => do not call action routines */
int	tflag	FALSE;	/* nonzero => print tokens as read */

/*	GLOBAL VARIABLES REFERENCED BY ACTION ROUTINES	*/

int	val;		/* set to indicate translation element of LHS */
int	line;		/* set to indicate line number of LHS */
int	*pv;		/* used to reference translations of RHS */
int	*pl;		/* used to reference line numbers of RHS */
int	lineno;		/* used to reference lineno of current token */

/*	INTERNAL STATIC VARIABLES	*/

static int	*ps;		/* parser stack pointer - states */
static int	s[pssize];	/* parser stack - states */
static int	v[pssize];	/* parser stack - translation elements */
static int	l[pssize];	/* parser stack - line numbers */
static int	*sps;		/* save stack pointer - states*/
static int	*spv;		/* save stack pointer - translation elements */
static int	*spl;		/* save stack pointer - line numbers */
static int	ss[pssize];	/* save stack - states */
static int	sv[pssize];	/* save stack - translation elements */
static int	sl[pssize];	/* save stack - line numbers */
static int	must 7;		/* number of tokens which must shift
				   correctly before error recovery is
				   considered successful */
static int	errcount 0;	/* number of tokens left until successful */
static int	tskip;		/* number of tokens skipped */
static int	spop;		/* number of states popped */
static int	errmode 0;	/* error recovery mode */
static int	tabmod FALSE;	/* indicates index tables have been optimized */

/**********************************************************************

	PARSE - THE PARSER ITSELF

**********************************************************************/

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

	{	/* precompute index tables into action
		   and goto arrays */

	ip = pa;
	while ((o = *++ip) != -1) *ip = &a[o];
	ip = pg;
	while ((o = *++ip) != -1) *ip = &g[o];
	tabmod = TRUE;
	}

while (TRUE)
	{ap = pa[state];

	if (debug)
		cprint("executing state %d, token=%d\n",state, ct->type);

	while (TRUE)

		{ac = *ap++;
		op = ac>>12;
		n = ac&07777;

		switch (op) {

	case 1:		/* SKIP ON TEST */

		if (ct->type!=n) ++ap;
		continue;

	case 2:		/* SHIFT INPUT SYMBOL */

		state = n;

shift:		val = ct->index;
		line = ct->line;
 		ct = lex();

		if (errcount)
			{--errcount;
			if (errcount==0)	/* successful recovery */
				{ct = dmperr();	/* list recovery actions */
				control = 0;
				break;
				}
			}

		control=1;	/* stack new state */
		break;

	case 3:		/* MAKE A REDUCTION */

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
		control = 1;	/* stack new state */
		break;

	case 5:		/* SHIFT ON MASK */

		t = ct->type;
		if (ap[t>>4] & (1<<(t&017)))	/* bit on */
			{state = *(a+n+t-1);
			goto shift;
			}

		ap =+ nwpbt;	/* skip over bit array */
		continue;

	case 4:		/* ACCEPT INPUT */

		if (errmode)
			{ct = dmperr();
			control = 0;
			break;
			}
		return (FALSE);

	case 0:		/* SYNTAX ERROR */

/*	The error recovery method used is to try skipping input symbols
	and popping states off the stack in all possible combinations,
	subject to a limitation on the number of symbols which may be
	skipped.  If a combination can be found which allows parsing
	to continue for at least 7 more symbols, then the recovery is
	considered a success.  If no such combination can be found, the
	parser gives up.

	In running through the possible recovery actions, skipping
	input symbols is given priority over popping states, since
	popping states tends to confuse the action routines, while
	skipping symbols can not have any harmful effects on the
	action routines.

	While searching for a successful combination of states and
	symbols, the action routines are not called.  When a successful
	combination is found, the appropriate error messages are
	written, the action routines are turned back on, and the parser
	is reset at the point where the corrections have just been made.

	*/

		switch (errmode) {

		case 0:		/* NEW ERROR */

	if (edebug) cprint("errmode=0:st=%d,nst=%d,tok=%d\n",
		state,ps-s,ct->type);

			synerr (ct->line);	/* report syntax error */

			p=s;
			while (p<=ps) qprint (*p++);
			pcursor ();

			tkeem();	/* enter error mode to save tokens */
			for (i=0;i<5;++i)
				{tp = tok(i);
				if (tp->type==1) break;
				tprint (tp);
				}

			save();		/* save parser stack */
			errcount = must;
			errmode = 1;
			xflag =| 2;	/* turn off action routnes */

			/* set up limits for recovery search */

			tlimit = tbsize - must - 2;
			slimit = ps-s;

			tskip = 0;
			spop = 0;
			errn = 1;

		case 1:		/* try next recovery attempt */

			restore();
			yreset();

			if ((++tskip & 1) == 0) --spop;
			if (spop<0 || ct->type==1 || tskip>tlimit)
				{spop = errn++;
				tskip = 0;
				}
			if (spop <= slimit)
				{ct = ctok(tskip);
				control = -spop;
				break;
				}
			giveup (ct->line);	/* give up */
			return (TRUE);
			}

		if (edebug) cprint ("spop=%d,tskip=%d,token=%d\n",
			spop,tskip,ct->type);
		break;
		}

	if (control>0)
		{if (debug) cprint ("stack st=%d val=%d\n",state,val);
		*++ps = state;
		*++pv = val;
		*++pl = line;
		if (ps-s>=pssize)	/* stack overflow */
			{stkovf (ct->line);
			return (TRUE);
			}
		}

	else if (control<0)
		{pv =+ control;
		ps =+ control;
		pl =+ control;
		if (ps<s)	/* stack underflow */
			{stkunf (ct->line);
			return (TRUE);
			}
		}
	state = *ps;
	break;
	}
	}
}

/**********************************************************************

	DMPERR - PRINT ERROR RECOVERY ACTION TAKEN
		RESET PARSER TO RESTART WITH ACTION ROUTINES
		RETURN PTR TO NEW CURRENT TOKEN

**********************************************************************/

token *dmperr()

	{int i;
	token *tp;
	extern token *ct;

	yreset();
	restore();
	if (spop>0) delmsg (ct->line);	/* print DELETED: */
	for (i=1;i<=spop;++i)
		qprint (ps[-spop+i]);	/* print symbol associated with state */
	if (tskip>0) skpmsg (ct->line);
	for(i=0;i<tskip;++i)
		tprint ( tok(i));	/* print token skipped */
	xflag =& ~02;
	errmode = 0;
	errcount = 0;
	ps =- spop;
	pv =- spop;
	pl =- spop;
	tp = ctok (tskip);
	tklem();	/* leave error mode */
	return (tp);
	}

/**********************************************************************

	SAVE - SAVE PARSER STACK

**********************************************************************/

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


/**********************************************************************

	RESTORE - RESTORE PARSER STACK

**********************************************************************/

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

/**********************************************************************

	PARSER TOKEN CLUSTER

	There are two modes of operation:

	1.  Normal mode, in which only the current token
		is remembered.
	2.  Error mode, in which all tokens seen are remembered
		(up to a limit).


	OPERATIONS:

	lex()	Return a pointer to the next token in the input
		stream and make it the current token.

	tok(i)	In error mode, return a pointer to the i-th token
		relative to the current token in the input stream.

	ctok(i)	Same as tok(i), except the selected token becomes
		the current token.

	yreset() In error mode, adjust the input stream so that
		the current token is that which was current when
		error mode was entered, and return a pointer
		to it.

	tkeem()	Enter error mode.

	tklem()	Leave error mode.

**********************************************************************/

token	tokbuf [tbsize];	/* token buffer, for error mode */
token	*ct tokbuf;		/* current token pointer */
token	*twp tokbuf;		/* pointer to next available position
				   in token buffer */
int	tokmode 0;		/* Normal or Error mode */



token	*lex()

	{if (++ct >= twp) 

		/* If true, it is neccessary to read in another token.
		   If in normal mode, place the token in the first
		   element of the buffer.
		*/

		{if (tokmode==0) ct=twp=tokbuf;
		else
			{if (twp>=tokbuf+tbsize) tkbovf (ct->line);
			if (ct>twp) badtwp (ct->line);
			}
		rtoken (twp++);		/* read token into next slot */
		}

	if (tflag && !tokmode)
		{ptoken (ct, cout);
		cputc (' ', cout);
		}
	lineno = ct->line;
	return (ct);		/* return ptr to token read */
	}

token	*tok(i)

	{token *p;

	p = ct + i;
	if (p<tokbuf || p>=tokbuf+tbsize) badtok (ct->line, i);
	while (p>=twp) rtoken (twp++);
	return (p);
	}

token	*ctok(i)

	{return (ct = tok(i));}

token	*yreset()

	{return (ct = tokbuf);}

tkeem()

	{int i,j;
	token *tp1, *tp2;

	tokmode = 1;
	j = i = twp - ct;	/* number of valid tokens in buf */
	if (i>0)
		{tp1 = tokbuf-1;
		tp2 = ct-1;
		while (i--)
			{(++tp1)->type = (++tp2)->type;
			tp1->index = tp2->index;
			tp1->line = tp2->line;
			}
		}
	ct = tokbuf;
	twp = ct + j;
	}

tklem()

	{tokmode = 0;}


/**********************************************************************

	RTOKEN - PARSER READ TOKEN ROUTINE

**********************************************************************/

rtoken(p) token *p;

	{
	gettok();
	p->type = lextype;
	p->index = lexindex;
	p->line = lexline;
	}

/**********************************************************************

	PARSER ERROR MESSAGE ROUTINES

	synerr - announce syntax error
	delmsg - print "DELETED:" message
	skpmsg - print "SKIPPED:" message

	qprint - print symbol corresponding to parser state
	tprint - print token
	pcursor - print cursor symbol
	
	*** fatal errors ***

	giveup - announce failure of recovery attempt
	stkovf - parser stack overflow

	*** internal fatal errors ***

	stkunf - parser stack underflow
	tkbovf - token buffer overflow
	badtwp - inconsistent token pointers
	badtok - bad token reference

	*****

	The routines are contained in the file YERROR.C so that
	one may easily substitute other routines for them.

*/
