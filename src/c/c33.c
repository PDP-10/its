# include "cc.h"
# include "c3.h"

/*

	C COMPILER
	Phase C: Code Generator
	Section 3: Expression Code Generation

	Copyright (c) 1977 by Alan Snyder

*/

/**********************************************************************

	CODE GENERATOR:  LOWER-LEVEL CODE GENERATION ROUTINES

	ttexpr
	cgexpr
	jumpval
	cgidn
	cgint
	cgfloat
	cgstring
	cgindirect
	cgassign
	cgcall
	cgqmark
	cglseq
	cgop
	cgmove
	cg_elist
	cg_farg
	choose
	score
	scorop
	eresult
	jumpz
	jumpn
	creturn
	jumpe
	expr2

*/

/**********************************************************************

	TTEXPR - Generate code to evaluate expression EP into an
		acceptable location as specified by LP.

**********************************************************************/

enode *ttexpr (ep, lp)	enode *ep; loc *lp;

	{loc	l;

	if (!ep) return (NULL);
	if (ttxlev++ == 0) {rflush (); temploc = autoloc;}

# ifndef SCRIMP

	if (aflag)
		{if (ttxlev==1) prtree (ep);
		cprint ("%2d TTEXPR %o TO ", ttxlev, ep);
		prloc (lp);
		cprint ("\n");
		}

# endif

	l.flag = lp->flag;	/* copy loc for modification */
	l.word = lp->word;
	fixloc (ep, &l);	/* remove impossible cases */
	if (l.flag==l_reg && l.word==0) errx (6001);
	ep = cgexpr (ep, &l);	/* any location possible */
	if (ep) ep = cgmove (ep, &l);	/* move to desired location */

# ifndef SCRIMP

	if (aflag)
		{cprint ("%2d TTEXPR RETURNS ", ttxlev);
		if (ep)
			{cprint ("(%d,%d)\n", ep->edref.drbase, ep->edref.droffset);
			cprint ("   ep=%o,p1=%o,p2=%o\n", ep, ep->ep1, ep->ep2);
			}
		else cprint ("0\n");
		}

# endif

	--ttxlev;
	return (ep);
	}

/**********************************************************************

	CGEXPR - Generate code to evaluate expression EP.
		Result is placed wherever convenient; preferred
		locations are specified by LP.  This routine
		checks for special cases.

**********************************************************************/

enode *cgexpr (ep, lp)	enode *ep; loc *lp;

	{if (!ep) return (NULL);
	if (ep->lvalue > 0 && ep->edref.drbase<0)
		{restore (ep);
		return (ep);
		}
	if (jumpop (ep->op))
		if (lp->flag == l_label) return (cgop (ep, lp));
		else return (jumpval (ep,lp));

	switch (ep->op) {
case e_idn:	return (cgidn (ep));
case e_int:	return (cgint (ep));
case e_float:	return (cgfloat (ep));
case e_string:	return (cgstring (ep));
case e_call:	return (cgcall (ep));
case e_qmark:	return (cgqmark (ep, lp));
case e_assign:	return (cgassign (ep, lp));
case e_ind:	return (cgindirect (ep, lp));
case e_lseq:	return (cglseq (ep, lp));
case e_comma:	return (cgcomma (ep, lp));
		}

	return (cgop (ep,lp));
	}

/**********************************************************************

	JUMPVAL - Generate code to obtain a value from a jump
		operation.

**********************************************************************/

enode *jumpval (ep, lp)		enode *ep; loc *lp;

	{int	r, i, j;
	loc	l;

	jumpz (ep, i=ciln++);
	r = trdt[TTINT];
	r = (lp->flag == l_reg ? getreg (lp->word, r) : freereg (r));
	l.flag = l_reg;
	l.word = 1<<r;
	eclear (ttexpr (intcon (1), &l));
	jump (j=ciln++);
	ilabel (i);
	eclear (ttexpr (intcon (0), &l));
	ilabel (j);
	reserve (r, ep);
	return (ep);
	}

/**********************************************************************

	CGIDN - Generate Code for Identifier

**********************************************************************/

enode *cgidn (ep)	eidn *ep;

	{ep->edref.drbase = -(ep->eclass);
	ep->edref.droffset = ep->eoffset;
	return (ep);
	}

/**********************************************************************

	CGINT - Generate Code for Integer Constant

**********************************************************************/

enode *cgint (ep)	econst *ep;

	{ep->edref.drbase = -c_integer;
	ep->edref.droffset = ep->eval;
	return (ep);
	}

/**********************************************************************

	CGFLOAT - Generate Code for Float Constant

**********************************************************************/

enode *cgfloat (ep)	econst *ep;

	{ep->edref.drbase = -c_float;
	ep->edref.droffset = ep->eval;
	return (ep);
	}

/**********************************************************************

	CGSTRING - Generate Code for String Constant

**********************************************************************/

enode *cgstring (ep)	econst *ep;

	{ep->edref.drbase = -c_string;
	ep->edref.droffset = ep->eval;
	return (ep);
	}

/**********************************************************************

	CGINDIRECT - Generate Code for Indirection Operator

**********************************************************************/

enode *cgindirect (ep, lp)	enode *ep; loc *lp;

	{loc	l;
	enode	*p1;
	econst	*ecp;
	int	op, off;

	l.flag = l_reg;
	l.word = (lp->flag == l_mem ? lp->word >> c_indirect : -1);

	if (p1 = ep->ep1)
		{op = p1->op;
		if (op >= e_add0 && op <= e_add3)
			{if ((ecp=p1->ep2)->op==e_int &&
				(*off_ok[op-e_add0])(off=ecp->eval))
					p1 = p1->ep1;
			else off=0;
			}
		else off=0;
		if (p1)
			{p1 = ttexpr (p1, &l);
			ep->edref.drbase = -(c_indirect + p1->edref.drbase);
			ep->edref.droffset = off;
			ep->ep1 = p1;
			return (ep);
			}
		}
	return (NULL);
	}

/**********************************************************************

	CGASSIGN - Generate Code For Assignment

**********************************************************************/

enode *cgassign (ep, lp)	enode *ep; loc *lp;

	{enode	*p1, *p2;
	int	r;

	if (lp->flag != l_reg) lp = allreg;
	if (expr2 (ep, allmem, lp))
		{p1 = ep->ep1;
		p2 = ep->ep2;
		r = p2->edref.drbase;
		p2 = mmove (p2, p1->edref.drbase, p1->edref.droffset, TRUE);
		if (p2)
			{eclear (p1);
			reserve (r, ep);
			return (ep);
			}
		}
	return (NULL);
	}

/**********************************************************************

	CGCALL - Generate Code for Function Call Operation

**********************************************************************/

enode *cgcall (ep)	enode *ep;

	{int	narg, o, r;
	enode	*p1;

	narg = cg_elist (ep->ep2, &o);
	rsave ();
	if (p1 = ttexpr (ep->ep1, allmem))
		{eclear (p1);
		fcall (narg,o,p1->edref.drbase,p1->edref.droffset);
		r = retreg[ectype(ep)];
		if (r<0) errx (6029);
		reserve (r, ep);
		return (ep);
		}
	return (NULL);
	}

/**********************************************************************

	CGQMARK - Generate Code for Conditional Expression

**********************************************************************/

enode *cgqmark (ep, lp)	enode *ep; loc *lp;

	{int	l1, l2, r;
	enode	*p2, *p;
	loc	l;

	l1 = ciln++;
	l2 = ciln++;
	p2 = ep->ep2;
	jumpz (ep->ep1, l1);
	l.flag = l_reg;
	l.word = (lp->flag == l_reg ? lp->word : -1);
	p = ttexpr (p2->ep1, &l);
	if (p)
		{eclear (p);
		jump (l2);
		ilabel (l1);
		r = p->edref.drbase;
		l.word = 1<<r;
		p = ttexpr (p2->ep2, &l);
		if (p)
			{eclear (p);
			ilabel (l2);
			reserve (r, ep);
			return (ep);
			}
		}
	return (NULL);
	}

/**********************************************************************

	CGLSEQ - Generate code for left-sequence operator.  This
	operator computes and saves the value of its left operand,
	then computes the value of its right operand, then returns
	the value which it computed for its left operand.  It is
	used in the implementation of postfix increment and decrement
	operators, when not defined in the machine description.

**********************************************************************/

enode *cglseq (ep, lp)	enode *ep; loc *lp;

	{enode *p1, *p2;

	if (lp->flag!=l_reg) lp = allreg;
	p1 = ep->ep1;
	p2 = ep->ep2;
	p1 = ttexpr (p1, lp);
	p2 = ttexpr (p2, anywhere);
	if (p2) eclear (p2);
	return (p1);
	}

/**********************************************************************

	CGCOMMA - Generate code for comma operator.  This operator
	evaluates its left operand, then evaluates and returns its
	right operand.

**********************************************************************/

enode *cgcomma (ep, lp)	enode *ep; loc *lp;

	{enode *p1;
	p1 = ttexpr (ep->ep1, anywhere);
	if (p1) eclear (p1);
	return (ttexpr (ep->ep2, lp));
	}

/**********************************************************************

	CGOP - Code Generator for Operations not special-cased
		by CGEXPR.

**********************************************************************/

enode *cgop (ep, lp)	enode *ep; loc *lp;

	{loc	l, *lp1, *lp2;
	enode	*p1, *p2;
	oploc	*po;
	int	rflag, w, r, base, offset;

	/* choose an OPLOC */

	if (!(po=choose (ep, lp, &l))) return (NULL);
	rflag = po->xloc[2].flag;

	/* determine locations for operands */

	lp1 = (rflag==3 ? &l : &po->xloc[0]);
	lp2 = (rflag==4 ? &l : &po->xloc[1]);

	/* generate code to evaluate operands */

	if (!expr2 (ep, lp1, lp2)) return (NULL);
	p1 = ep->ep1;
	p2 = ep->ep2;

	/* mark operand registers unused */

	eclear (p1);
	eclear (p2);

	/* save clobbered registers */

	if (w = po->clobber) for (r=0;r<nreg;++r) if (bget1 (w, r)) save (r);

	/* determine result location */

	if (lp->flag == l_label)
		{base = -c_label;
		offset = lp->word;
		}
	else if (rflag==3)
		{base = p1->edref.drbase;
		offset = p1->edref.droffset;
		}
	else if (rflag==4)
		{base = p2->edref.drbase;
		offset = p2->edref.droffset;
		}
	else if (l.flag == l_reg)	/* choose a register */
		{mark (p1);
		mark (p2);
		base = getreg (l.word, po->xloc[2].word);
		offset = 0;
		unmark (p1);
		unmark (p2);
		}
	else if (l.flag == l_mem)	/* choose a memory location ? */
		errx (6007);

	/* emit operation */

	if (p2) emitop (2,ep->op,base,offset,p1->edref.drbase,p1->edref.droffset,
		p2->edref.drbase,p2->edref.droffset);
	else	emitop (1,ep->op,base,offset,p1->edref.drbase,p1->edref.droffset);

	/* record location of result */

	if (base>=0) reserve (base, ep);
	else
		{ep->edref.drbase = base;
		ep->edref.droffset = offset;
		ep->saved = 0177;
		}

	return (ep);
	}

/**********************************************************************

	CGMOVE - Generate code to move value to a desired
		location.

	This routine will load a register, move between registers,
	and/or store in a temporary.

**********************************************************************/

enode *cgmove (ep, lp)	enode *ep; loc *lp;

	{int	base, w;
	loc	tl;

	base = ep->edref.drbase;
	w = lp->word;

	switch (lp->flag) {

case l_label:	if (base != -c_label) errx (6038);
		break;

case l_any:	break;

case l_reg:	if (base<0 || !bget1 (w, base))
			{eclear (ep);
			base = freereg (w);
			ep = mmove (ep, base, 0, FALSE);
			reserve (base, ep);
			}
		break;

case l_mem:	if (base>=0)	/* in a register */
			{if (bget1 (w, c_temp))
				ep = mmove (ep, -c_temp, gettemp (ep), TRUE);
			else errx (6012);
			}
		else if (!bget1 (w, -base))
			{if (bget1 (w, -c_temp))
				{tl.flag = l_reg;
				tl.word = tregs (ep);
				ep = cgmove (ep, &tl);
				ep = cgmove (ep, lp);
				}
			else errx (6038);
			}
		break;

default:	errx (6039, lp->flag, w);
		}

	return (ep);
	}

/**********************************************************************

	CG_ELIST - compute function arguments given by an expression_list
	subtree (see ELIST).  Return the number of arguments.  Set
	*LCP to the offset of the first argument in the stack frame,
	or to 0 if .ARG ops are being used.

**********************************************************************/

int cg_elist (ep, lcp)
	enode *ep;
	int *lcp;

	{int n, *ip, o;
	enode *argv[maxfarg], **argp, **eargp;

	eargp = argp = &argv[maxfarg];
	ip = ep;
	while (ip && ip[0] < 0)
		{*--argp = ip[2];
		ip = ip[1];
		}
	if (ip) *--argp = ip;

	n = eargp - argp;
	if (!argops) *lcp = o = ttemp (TINT, n); /* stack space for args */
	else *lcp = o = 0;
	while (argp < eargp)
		{cg_farg (*argp++, o);
		o =+ int_size;
		}
	return (n);
	}

/**********************************************************************

	CG_FARG  - generate code for a single function argument
		(into stack frame offset LC, if not using .ARG ops)

**********************************************************************/

cg_farg (ep, lc)
	enode *ep;
	int lc;

	{if (!ep) return;
	ep = opt (ep);
	if (flt_hack && ep->etype == TDOUBLE)
		{if (!(ep = ttexpr (ep, allreg))) return;
		ep = mmove (ep, -c_temp, gettemp (ep), TRUE);
		if (!ep) return;
		if (ep->lvalue > 1) errx (6046);
		ep->op = e_idn;		/* make fake idn */
		ep->lvalue = 2;		/* so won't be recomputed */
		ep = taddr (ep);
		if (argops)
			ep = mkenode (e_arg0 + tpoint[TTDOUBLE],
				ep->etype, 0, ep, NULL);
		}
	if (!(ep = ttexpr (ep, argops ? anywhere : allreg))) return;
	if (!argops) ep = mmove (ep, -c_temp, lc, TRUE);
	else eclear (ep);
	}

/**********************************************************************

	CHOOSE - Return an OPLOC for expression EP with preferred
		result locations specified by LP.  Set the LOC
		pointed to by RP to a LOC describing the possible
		locations of the result, which will be derived
		from LP and the OPLOC LOC for the result, first
		operand, or second operand.

**********************************************************************/

oploc *choose (ep, lp, rp)	enode *ep; loc *lp, *rp;

	{oploc	*po, *maxp;
	loc	*p;
	int	i, j, s, maxs, op, *l;

	op = ep->op;
	i = rtopp[op];
	if (i>=0)
		{l = &rtopl[i];
		maxs = -500;	/* filter out incompatible OPLOCs */
		maxp = NULL;
		while ((j = *l++) >= 0)
			{po = &xoploc[j];
			s = score (po, ep, lp);
			if (s>maxs) {maxs = s; maxp = po;}
			}
		if (maxp)	/* found one */
			{s = maxp->xloc[2].flag;
			p = &maxp->xloc[s==3 ? 0 : s==4 ? 1 : 2];
			rp->flag = p->flag;
			rp->word = p->word;
			if (lp->flag == rp->flag && (s = rp->word & lp->word))
				rp->word = s;
			return (maxp);
			}
		errx (6031, op);
		}
	errx (1029, op);
	return (NULL);
	}

/**********************************************************************

	SCORE - Determine the suitability of an OPLOC for a given
		expression EP and preferred result locations, specified
		by LP.

**********************************************************************/

int score (po, ep, lp)	oploc *po; enode *ep; loc *lp;

	{int w, s, f, rf, rw, lw;

	s = ((w = po->clobber) ? -10*nbusy (w) : 0);
	f = po->xloc[2].flag;
	if (f==3)
		{rf = po->xloc[0].flag;
		rw = po->xloc[0].word;
		}
	else if (f==4)
		{rf = po->xloc[1].flag;
		rw = po->xloc[1].word;
		}
	else
		{rf = f;
		rw = po->xloc[2].word;
		}
	lw = lp->word;

	switch (lp->flag) {

case l_label:	if (rf!=l_mem || !bget1 (rw, c_label)) s = -1000;
		break;

case l_reg:	if (rf==l_reg)
			{if (w = lw & rw)
				if (nfree (w)==0 && nfree (lw)>0) s =- 10;
				else;
			else s =- (nfree (rw)>0 ? 4 : 14);
			}
		else s =- 5;
		break;

case l_mem:	if (rf==l_reg)
			{if (!bget1 (lw, c_temp)) s = -1000;
			else s =- (nfree (rw)>0 ? 5 : 15);
			}
		else if ((rw & lw) != rw) s = -1000;
		break;
		}

	if (s > -1000)
		{if (ep->ep1) s =+ scorop (ep->ep1, f, &po->xloc[0]);
		if (ep->ep2) s =+ scorop (ep->ep2, f, &po->xloc[1]);
		}

# ifndef SCRIMP

	if (aflag) cprint ("SCORE IS %d\n", s);

# endif

	return (s);
	}

/**********************************************************************

	SCOROP - Determine suitability of operands.

**********************************************************************/

int scorop (ep, f, lp)	enode *ep; loc *lp;

	{int	lf, lw, wreg, wmem, s;

	lf = lp->flag;
	lw = lp->word;
	eresult (ep, &wreg, &wmem);
	s = 0;
	if (lf == l_reg)
		{if (f<3 && nfree (lw)==0) s =- 10;
		if (wreg)
			if ((wreg & lw) == 0) s =- 4;
			else;
		else s =- 5;
		}
	else if (lf == l_mem)
		{if ((lw & (1<<c_indirect)-1) == (1<<c_indirect)-1)
			if (wmem==0) s =- 5;
			else;
		else	/* restrictive class of memory refs */
			if ((wmem & lw) != wmem || (wreg && !bget1 (lw, c_temp)))
				return (-1000);
		}
	return (s);
	}

/**********************************************************************

	ERESULT - Indicate possible locations for expression EP:
		*P1 - registers
		*P2 - memory reference classes

**********************************************************************/

eresult (ep, p1, p2)	enode *ep; int *p1, *p2;

	{int	op, c;
	eidn	*eip;

	op = ep->op;
	switch (op) {

case e_ind:	*p1 = 0;
		*p2 = tregs (ep->ep1) << c_indirect;
		return;

case e_assign:
case e_qmark:	*p1 = tregs (ep);
		*p2 = 0;
		return;

case e_call:	*p1 = 1 << retreg[ectype(ep)];
		*p2 = 0;
		return;

case e_idn:	eip = ep;
		*p1 = 0;
		*p2 = 1 << ((c = eip->eclass) == c_extern ? c_extdef : c);
		return;
		}

	*p1 = opreg[op];
	*p2 = opmem[op];
	}

/**********************************************************************

	JUMPZ - Emit Jump on Zero

**********************************************************************/

jumpz (ep, iln)	enode *ep; int iln;

	{int	op, l, n[1], i;
	econst	*ecp;

	if (!ep) return;
	op = ep->op;

	if (condop (op))
		{i = invcond (op);
		if (rtopp[i]<0)		/* inverse op not implemented */
			{jumpn (ep, l=ciln++);
			jump (iln);
			ilabel (l);
			}
		else
			{ep->op = i;
			jumpn (ep, iln);
			ep->op = op;
			}
		return;
		}

	switch (op) {

case e_not:	jumpn (ep->ep1, iln);
		return;

case e_and:	jumpz (ep->ep1, iln);
		jumpz (ep->ep2, iln);
		return;

case e_or:	jumpn (ep->ep1, l=ciln++);
		jumpz (ep->ep2, iln);
		ilabel (l);
		return;

case e_int:	if ((ecp=ep)->eval==0) jump (iln);
		return;
		}

	n[0] = n_eq;
	jumpn (txpr2 (n, ep, intcon (0)), iln);
	}

/**********************************************************************

	JUMPN - Emit jump on non-zero

**********************************************************************/

jumpn (ep, iln)	enode *ep; int iln;

	{int	op, l, n[1];
	loc	x;
	econst	*ecp;

	if (!ep) return;
	op = ep->op;

	if (condop (op))
		{x.flag = l_label;
		x.word = iln;
		ttexpr (ep, &x);
		return;
		}

	switch (op) {

case e_not:	jumpz (ep->ep1, iln);
		return;

case e_and:	jumpz (ep->ep1, l=ciln++);
		jumpn (ep->ep2, iln);
		ilabel (l);
		return;

case e_or:	jumpn (ep->ep1, iln);
		jumpn (ep->ep2, iln);
		return;

case e_int:	if ((ecp=ep)->eval) jump (iln);
		return;
		}

	n[0] = n_ne;
	jumpn (txpr2 (n, ep, intcon (0)), iln);
	}

/**********************************************************************

	CRETURN - return statment

**********************************************************************/

creturn (ep) enode *ep;

	{loc	l;
	int	r;

	if (ep)
		{r=retreg[ectype(ep)];
		if (r<0) errx (6030);
		l.flag = 1;
		l.word = 1<<r;
		expr (ep, &l);
		}
	mreturn ();
	}

/**********************************************************************

	JUMPE - Emit Jump to Expression

**********************************************************************/

jumpe (ep) enode *ep;

	{if (expr (ep, allmem))
		mgoto (ep->edref.drbase, ep->edref.droffset);
	}

/**********************************************************************

	EXPR2 - evaluate two subexpressions given sets of
		desired locations for the results

	Evaluate the more complicated expression first; make sure
	that the results do not require the same register.

**********************************************************************/

expr2 (ep, lp1, lp2) enode *ep; loc *lp1, *lp2;

	{enode **epp1, **epp2;
	loc *dlp, loc1, loc2, *l1, *l2;
	int f1, f2, w1, w2, s1, s2, f, b;

	if (!ep->ep2)
		if (ep->ep1)
			return (ep->ep1 = ttexpr (ep->ep1, lp1));
			else return (0);
	if (ep->ep2->degree > ep->ep1->degree && ep->ep1->lvalue<2)
		{epp1= &(ep->ep2);
		epp2= &(ep->ep1);
		dlp=lp1; lp1=lp2; lp2=dlp;
		}
	else
		{epp1 = &(ep->ep1);
		epp2 = &(ep->ep2);
		}

	loc1.flag = lp1->flag;
	loc1.word = lp1->word;
	loc2.flag = lp2->flag;
	loc2.word = lp2->word;
	l1 = &loc1;
	l2 = &loc2;
	fixloc (*epp1, l1);
	fixloc (*epp2, l2);
	f1=l1->flag;
	f2=l2->flag;
	w1=l1->word;
	w2=l2->word;

	if (f1 == l_mem)
		{s1=w1 & ((1<<c_indirect)-1);
		w1 =>> c_indirect;
		}
	if (f2 == l_mem)
		{s2 = w2 & ((1<<c_indirect)-1);
		w2=>>c_indirect;
		}
	if (onebit (w2)) w1 =& ~w2;

	if (f1 == l_mem) w1 = (w1<<c_indirect) | s1;
	l1->word = w1;
	f = (*epp1) = ttexpr (*epp1, l1);

	if ((b = (*epp1)->edref.drbase) >= 0) w2 =& ~(1<<b);
	else if (b <= -c_indirect)
		w2 =& ~(1 << -b-c_indirect);
	if (f2 == l_mem) w2 = (w2<<c_indirect)|s2;
	l2->word = w2;
	if (f) f = (*epp2 = ttexpr (*epp2, l2));
	restore (*epp1);
	return (f);
	}

/**********************************************************************

	CODE GENERATOR:  REGISTER MANAGEMENT ROUTINES

	clear
	eclear
	freereg
	getreg
	mark
	nbusy
	nfree
	reserve
	restore
	rflush
	rsave
	save
	save1
	unmark

*/

struct _ureg
	{int ucode;	/* status code:
			   0    free
			   -1   directly contains an expression
			   n>0  n conflicting regs are busy
			*/
	int marked;	/* marked flag: non-zero => marked */
	enode *rep;	/* points to expression contained in reg */
	};
# define ureg struct _ureg

ureg	regtab[maxreg];		/* table of register status */
ureg	*eregtab;		/* points past end of table */

/**********************************************************************

	REG_INIT - initialize register status variables

**********************************************************************/

reg_init ()
	{eregtab = &regtab[nreg];
	}

/**********************************************************************

	CLEAR - clear register R, directly containing an expression
		decrement UCODE of conflicting registers

**********************************************************************/

clear (r) int r;

	{int i, w;
	ureg *p;

# ifndef SCRIMP

	if (aflag) cprint ("CLEAR(%d)\n", r);

# endif

	p = &regtab[r];
	if (p->ucode >= 0) errx (6019, r);
	p->ucode = 0;
	p->rep = NULL;
	if (w = conf[r]) for (i=0;i<nreg;i++) if (bget1 (w, i))
		if (--regtab[i].ucode < 0) errx (6021, i);
	}

/**********************************************************************

	ECLEAR - clear register containing expression

**********************************************************************/

eclear (ep) enode *ep;

	{int i;

# ifndef SCRIMPT

	if (aflag) cprint ("ECLEAR(%o)\n", ep);

# endif

	if (!ep) return;
	i = ep->edref.drbase;
	if (ep->saved == 0177)
		{if (i>=0) clear (i);
		else if (i <= -c_indirect)
			if (ep->lvalue>0 && --ep->lvalue==0)
				eclear (ep->ep1);
		}
	}

/**********************************************************************

	FREEREG - Find an unused register specified by the word W; if
		none, select any specified register and save it.

**********************************************************************/

int freereg (w) int w;

	{int i, j, k;

	if (!w) errx (6013);
	j = k = -1;

	for (i=0; i<nreg; i++)
		{if (w & 01)
			if (regtab[i].marked) k = i;
			else if (regtab[i].ucode) j = i;
			else return (i);
		w =>> 1;
		}
	if (j == -1) j = k;
	save (j);
	return (j);
	}

/**********************************************************************

	GETREG - Get a register, make it available for use.

	Priority:

		1. free register from W1
		2. busy register from W1
		3. free register from W2
		4. busy register from W2
		5. marked register from W1

**********************************************************************/

int getreg (w1, w2)

	{int r, m, bw1, fw2, bw2, mkd, c, marked;

	if (!w1) errx (6040);
	bw1 = fw2 = bw2 = mkd = -1;
	m = 1;
	for (r=0; r<nreg; ++r)
		{c = regtab[r].ucode;
		marked = regtab[r].marked;
		if (w1 & m)
			{if (marked) mkd = r;
			else if (c == 0) return (r);
			else bw1 = r;
			}
		else if (w2 & m)
			{if (marked) ;
			else if (c==0) fw2 = r;
			else bw2 = r;
			}
		m =<< 1;
		}
	if (bw1 >= 0) {save (bw1); return (bw1);}
	if (fw2 >= 0) return (fw2);
	if (bw2 >= 0) {save (bw2); return (bw2);}
	return (mkd);
	}

/**********************************************************************

	MARK - If the expression EP is referenced indirect through
	a register, mark that register as not to be used.

**********************************************************************/

int mark (ep) enode *ep;

	{int r;

	if (ep && (r = ep->edref.drbase) <= -c_indirect)
		{r = -r - c_indirect;

# ifndef SCRIMP

		if (aflag) cprint ("MARK(%d)\n", r);

# endif

		if (regtab[r].marked) errx (6044, r);
		++regtab[r].marked;
		return (1);
		}
	return (0);
	}

/**********************************************************************

	NBUSY - Return number of busy registers in set W

**********************************************************************/

int nbusy (w)

	{int s;
	ureg *p;

	s = 0;
	p = regtab;
	while (p<eregtab && w)
		{if ((w&1) && p->ucode) ++s;
		++p;
		w =>> 1;
		}
	return (s);
	}

/**********************************************************************

	NFREE - Return number of free registers in set W

**********************************************************************/

int nfree (w)

	{int s;
	ureg *p;

	s = 0;
	p = regtab;
	while (p<eregtab && w)
		{if ((w&1) && p->ucode==0) ++s;
		++p;
		w =>> 1;
		}
	return (s);
	}

/**********************************************************************

	RESERVE - reserve a register for a given expression

**********************************************************************/

reserve (r, ep)	int r; enode *ep;

	{int i, w;
	ureg *p;

# ifndef SCRIMP

	if (aflag) cprint ("RESERVE(%d,%o)\n", r, ep);

# endif

	p = &regtab[r];
	if (p->ucode) errx (6017, r);
	if (w = conf[r]) for (i=0;i<nreg;i++) if (bget1 (w, i))
		if (++regtab[i].ucode <= 0) errx (6018, i);
	p->ucode = -1;	/* directly contains an expression */
	p->rep = ep;
	ep->edref.drbase = r;
	ep->edref.droffset = 0;
	ep->saved = 0177;
	}

/**********************************************************************

	RESTORE - restore saved expression to original location

	Return TRUE if a restoration takes place.

**********************************************************************/

int restore (ep) enode *ep;

	{int r;

# ifndef SCRIMP

	if (aflag) cprint ("RESTORE(%o)\n", ep);

# endif

	if (!ep) return (FALSE);
	if ((r = ep->saved) == 0177)
		{if (ep->edref.drbase <= -c_indirect)
			return (restore (ep->ep1));
		return (FALSE);
		}
	save (r);
	ep = mmove (ep, r, 0, TRUE);
	if (!ep) return (FALSE);
	reserve (r, ep);
	return (TRUE);
	}

/**********************************************************************

	RFLUSH - Flush All Registers

**********************************************************************/

rflush ()

	{ureg *p;
	for (p=regtab; p<eregtab; ++p) p->ucode = 0;
	}

/**********************************************************************

	RSAVE - Save All Registers

**********************************************************************/

rsave ()

	{int r;
	for (r=0; r<nreg; ++r) save (r);
	}

/**********************************************************************

	SAVE - make register R available by saving whatever registers
		are necessary

**********************************************************************/

save (r) int r;

	{int n, i, w;

# ifndef SCRIMP

	if (aflag) cprint ("SAVE(%d)\n", r);

# endif

	n = regtab[r].ucode;
	if (n<0) save1 (r);
	else if (n>0)
		if (w = conf[r])
			for (i=0; i<nreg; i++)
				if (bget1 (w, i) &&
					regtab[i].ucode < 0) save1 (i);
	if (regtab[r].ucode != 0) errx (6023, r);
	}

/**********************************************************************

	SAVE1 - save a register directly containing an expression

**********************************************************************/

save1 (r) int r;

	{int o;
	enode *ep;

	if (regtab[r].ucode >= 0) errx (6022, r);
	ep = regtab[r].rep;
	if (ep)
		{o = gettemp (ep);
		ep = mmove (ep, -c_temp, o, TRUE);
		if (ep) ep->saved = r;
		}
	else regtab[r].ucode = 0;
	}

/**********************************************************************

	UNMARK - unMARK a register previously MARKed

**********************************************************************/

int unmark (ep) enode *ep;

	{int r;

	if (ep && (r = ep->edref.drbase) <= -c_indirect)
		{r = -r - c_indirect;

# ifndef SCRIMP

		if (aflag) cprint ("UNMARK(%d)\n", r);

# endif

		if (regtab[r].marked == 0) errx (6045, r);
		--regtab[r].marked;
		return (1);
		}
	return (0);
	}
