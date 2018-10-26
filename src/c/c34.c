# include "cc.h"
# include "c3.h"

/*

	C COMPILER
	Phase C: Code Generator
	Section 4: Macro Emitting Routines and Auxiliary Routines

	Copyright (c) 1977 by Alan Snyder

*/

/**********************************************************************

	ABSTRACT MACHINE INSTRUCTION EMITTING ROUTINES

**********************************************************************/

ilabel(i)		{mprint ("%l(*)\n", i);}
jump(i)			{mgoto  (-c_label, i);}
string()		{mprint ("%sr()\n");}
mprolog(n, i, na)	{mprint ("%p(*,*,*)\n", n, i, na);}
mepilog()		{mprint ("%ep(*,*)\n", nfunc, framesize);}
mgoto(b, o)		{mprint ("%go(0,*,*)\n", b, o);}
fcall(n, p, b, o)	{mprint ("%ca(*,*,0,*,*)\n", n, p, b, o);}
mreturn()		{mprint ("%rt(*)\n", nfunc);}
mtswitch(b, o, l, h, d)	{mprint ("%ts(*,*,*,*,*,*)\n", l, -c_label, d, b, o, h);}
mlswitch(b, o, n, d)	{mprint ("%ls(*,*,*,*,*)\n", n, -c_label, d, b, o);}
metswitch(b,o,l,h,d)	{mprint ("%ets(*,*,*,*,*,*)\n", l, -c_label, d, b, o, h);}
melswitch(b,o,n,d)	{mprint ("%els(*,*,*,*,*)\n", n, -c_label, d, b, o);}
endcard()		{mprint ("%end()\n");}
mint(i)			{mprint ("%in(*)\n", i);}
mlabcon(i)		{mprint ("%lc(*)\n", i);}
mpure()			{mprint ("%pu()\n");objmode=o_pure;}
mpdata()		{mprint ("%pd()\n");objmode=o_pdata;}

ln (p)	int *p;

	{if (p[1] != lineno)
		{lineno = p[1];
		mprint ("%ln(*)\n", lineno);
		}
	}

/**********************************************************************

	EMITOP  - emit operation given

	OP - run-time operator
	RB - result base
	RO - result offset
	B1 - base of operand 1 (optional)
	O1 - offset of operand 1 (optional)
	B2 - base of operand 2 (optional)
	O2 - offset of operand 2 (optional)

**********************************************************************/

emitop (nopr, op, rb, ro, b1, o1, b2, o2)
	int op, rb, ro, b1, o1, b2, o2;

	{int i;

	if ((i = mactab[op]) < 0) errx (1028, op);
	else
		{cputc ('%', f_mac);
		mprd (i);
		cputc ('(', f_mac);
		mprd (op);
		cputc (',', f_mac);
		mprd (rb);
		cputc (',', f_mac);
		mprd (ro);
		cputc (',', f_mac);
		mprd (b1);
		cputc (',', f_mac);
		mprd (o1);
		if (nopr>1)
			{cputc (',', f_mac);
			mprd (b2);
			cputc (',', f_mac);
			mprd (o2);
			}
		cputc (')', f_mac);
		cputc ('\n', f_mac);
		}
	}

/**********************************************************************

	MMOVE - emit macro to accomplish a MOVE

**********************************************************************/

enode *mmove (ep,db,dof,clear_old)	enode *ep;

	{int ct,op;

	ct = ectype (ep);
	if (ct == ct_bad) return (NULL);
	if (ct == ct_struct)
		{errx (2033);
		return (NULL);
		}
	if (ct < ct_char || ct > ct_p3) errx (6024, ct);

	op = e_movec + ct - ct_char;
	emitop (1, op, db, dof, ep->edref.drbase, ep->edref.droffset);
	if (clear_old) eclear (ep);
	if (ep->lvalue > 0) ep = mkenode (op, ep->etype, 0, ep, NULL);
	ep->edref.drbase = db;
	ep->edref.droffset = dof;
	ep->saved = 0177;
	return (ep);
	}

/**********************************************************************

	CODE GENERATOR:  AUXILIARY ROUTINES

	e_alloc
	bget1
	e_free
	intcon
	condop
	jumpop
	invcond
	mkenode
	tregs
	read_node
	onebit
	fixloc
	undfop

	max
	min
	rtyptab
	to2p
	ro2p
	prloc
	prtree

*/

/**********************************************************************

	E_ALLOC - allocate an ENODE

**********************************************************************/

enode *e_alloc ()

	{if (acorp >= acore+(acoresz-1)) errx (4011);
	return (acorp++);
	}

/**********************************************************************

	BGET1 - bit get

**********************************************************************/

int bget1 (w, n) int w, n;

	{return ((w>>n) & 1);}

/**********************************************************************

	E_FREE - free all ENODEs

**********************************************************************/

e_free ()

	{extern enode acore[], *acorp;

	acorp = acore;
	}

/**********************************************************************

	INTCON - create an integer constant expression node

**********************************************************************/

enode *intcon (i)

	{return (mkenode (e_int, TINT, 0, i, NULL));}

/**********************************************************************

	CONDOP - Is AMOP a conditional?

**********************************************************************/

int condop (op)

	{return (op>=e_eqi && op<=e_gep3 || op>=e_jz0 && op<=e_jn3);}

/**********************************************************************

	JUMPOP - Is AMOP a jump operation?

**********************************************************************/

int jumpop (op)

	{return (condop(op) || op==e_not || op==e_and || op==e_or);}

/**********************************************************************

	INVCOND - Return inverse of conditional AMOP

**********************************************************************/

int invtab [] {
	1,	0,	5,	4,	3,	2,
	7,	6,	11,	10,	9,	8,
	13,	12,	17,	16,	15,	14,
	19,	18,	23,	22,	21,	20,
	25,	24,	29,	28,	27,	26,
	31,	30,	35,	34,	33,	32};

int invcond (op)

	{if (op>=e_eqi) return (e_eqi + invtab[op-e_eqi]);
	if (op>=e_jn0) return (op-4);
	return (op+4);
	}

/**********************************************************************

	MKENODE - create a new expression node, determine its degree

**********************************************************************/

enode *mkenode (op, etype, lvalue, ep1, ep2)

	int op, lvalue;
	type etype;
	enode *ep1, *ep2;

	{enode *ep;
	ep = e_alloc ();
	ep->op = op;
	ep->etype = etype;
	ep->lvalue = lvalue;
	ep->ep1 = ep1;
	ep->ep2 = ep2;
	ep->degree = 1;
	switch (op) {
	case e_int:
	case e_float:
	case e_string:
	case e_idn:	break;

	default:	if (!ep1) break;
			if (!ep2) ep->degree = ep1->degree;
			else if (ep1->degree==ep2->degree)
				ep->degree = ep1->degree+1;
			else ep->degree = max (ep1->degree, ep2->degree);
		}
	ep->edref.drbase = ep->edref.droffset = 0;
	ep->saved = 0177;
	return (ep);
	}

/**********************************************************************

	TREGS - find registers which can hold a given type
		of expression (indicated by 1 bits in the returned word)

**********************************************************************/

int tregs (ep) enode *ep;

	{int ct;
	ct = ectype (ep);
	if (ct >= ct_p0) return (prdt[ct-ct_p0]);
	if (ct >= ct_char) return (trdt[ct-ct_char]);
	return (0);
	}

/**********************************************************************

	READ_NODE - Read Node From Node File

**********************************************************************/

read_node ()

	{int op, i, j, n;

	op = geti (f_node);
	if (op<1 || op>n_elist) error (6027, -2, op, lc_node);
	*corep++ = op;
	i = nodelen[op];
	lc_node =+ i;
	j = ntw[type_node[op]];

	/*	read in remaining words of node,
		converting offsets to pointers according
		to the low-order bits of ntw[]			*/

	while (--i > 0)
		{n = geti (f_node);
		if (j&1 && n) n = core+(n-flc_node);
		*corep++ = n;
		j =>> 1;
		}

	if (op <= 1) eof_node = 1;
	return (op);
	}

/**********************************************************************

	ONEBIT - Return TRUE if word has only 1 bit on.

	(Notice the efficiency of this routine.  Handling of
	high order bit assumes two's complement representation.)

**********************************************************************/

int onebit (w)

	{int f;

	if (w==0) return (FALSE);
	if (w<0) return (-w < 0);

	f = FALSE;

	do
		if (w & 1) if (f) return (FALSE); else f=TRUE;
		while (w =>> 1);

	return (TRUE);
	}

/**********************************************************************

	FIXLOC - modify a LOC for an expression
		by removing those possibilities
		which can never occur, due to the
		type of the expression, unless that
		would remove all possibilities

**********************************************************************/

fixloc (ep, lp) enode *ep; loc *lp;

	{int i;

	if (lp->flag == l_mem && ep->op==e_ind)
		lp->word =& (tregs(ep->ep1)<<c_indirect)
			| ((1<<c_indirect)-1);
	else if (lp->flag==l_reg)
		{i = lp->word & tregs(ep);
		if (i) lp->word = i;
		}
	}

/**********************************************************************

	UNDFOP - is abstract machine operator undefined?

**********************************************************************/

int undfop (op) {return (rtopp[op]<0);}

int max (a, b)

	{return (a>b ? a : b);}

int min (a, b)

	{return (a<b ? a : b);}

/**********************************************************************

	RTYPTAB - Read Type Table

**********************************************************************/

rtyptab ()

	{extern int typtab[], *ctypp, *crecp, *etypp, typform[];
	register int *p, fmt;
	register field *fp;
	int f;

	f = xopen (fn_typtab, MREAD, BINARY);
	etypp = typtab + TTSIZE;
	ctypp = typtab + geti (f);
	p = typtab;
	while (p < ctypp)
		{fmt = typform[*p++ = geti (f)];
		*p++ = geti (f);
		*p++ = geti (f);
		switch (fmt) {
			case 1:	*p++ = geti (f); break;
			case 2:	*p++ = to2p (geti (f)); break;
			case 3:	*p++ = to2p (geti (f));
				*p++ = geti (f);
				break;
			case 4:	*p++ = ro2p (geti (f)); break;
			}
		}
	crecp = etypp - geti (f);
	p = crecp;
	while (p < etypp)
		{fp = p;
		fp->name = geti (f);
		if (fp->name == UNDEF) ++p;
		else
			{fp->dtype = to2p (geti (f));
			fp->offset = geti (f);
			p = fp+1;
			}
		}
	cclose (f);
	}

type to2p (i) int i;

	{extern int typtab[], *etypp;

	if (i < 0 || i >= TTSIZE) errx (6006);
	return (typtab + i);
	}

int *ro2p (i) int i;

	{extern int *etypp;

	if (i < 0 || i >= TTSIZE) errx (6047);
	return (etypp - i);
	}

fixstr () {errx (6015);}
errcidn () {errx (6020);}

# ifndef SCRIMP

/**********************************************************************

	PRLOC - Print a LOC (for debugging)

**********************************************************************/

prloc (lp)	loc *lp;

	{int w;

	w = lp->word;
	switch (lp->flag) {

case l_label:	cprint ("LABEL %d", w);
		break;

case l_reg:	if (w == -1) cprint ("ANY REGISTER");
		else cprint ("REGISTERS %o", w);
		break;

case l_mem:	if (w == -1) cprint ("ANY MEMORY");
		else cprint ("MEMORY %o", w);
		break;

case l_any:	cprint ("ANYWHERE");
		break;

default:	cprint ("BAD LOC [%d,%d]", lp->flag, w);
		}
	}

/**********************************************************************

	PRTREE - print an enode tree (for debugging)

**********************************************************************/

prtree (ep) enode *ep;

	{static int prlev;
	int i, op;
	econst *ecp;
	eidn *eip;
	extern int cout;

	if (!ep) return;
	if ((i = ++prlev) == 1) cputc ('\n', cout);
	while (--i >= 0) cputc (' ', cout);
	cprint ("%o ", ep);
	ecp = eip = ep;
	switch (op = ep->op) {
		case e_int:	cprint ("int %d\n", ecp->eval);
				break;
		case e_float:	cprint ("float %d\n", ecp->eval);
				break;
		case e_string:	cprint ("string %d\n", ecp->eval);
				break;
		case e_idn:	cprint ("idn class=%d, offset=%d, type=",
					eip->eclass, eip->eoffset);
				typrint (eip->etype, cout);
				cprint ("\n");
				break;
		case e_call:	cprint ("[call %o %o] type=",
					ep->ep1, ep->ep2);
				typrint (ep->etype, cout);
				cprint ("\n");
				prtree (ep->ep1);
				prelist (ep->ep2);
				break;
		default:	cprint ("[%o %o %o] type=",
					op, ep->ep1, ep->ep2);
				typrint (ep->etype, cout);
				cprint ("\n");
				prtree (ep->ep1);
				prtree (ep->ep2);
		}
	if (--prlev == 0) cputc ('\n', cout);
	}

prelist (np)
	int *np;

	{if (np[0] != -1) prtree (np);
	else
		{prelist (np[1]);
		prelist (np[2]);
		}
	}

# endif
