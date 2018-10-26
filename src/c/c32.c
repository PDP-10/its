# include "cc.h"
# include "c3.h"

/*

	C COMPILER
	Phase C: Code Generator
	Section 2: Semantic Interpretation and Optimization

	Copyright (c) 1977 by Alan Snyder

*/

/**********************************************************************

	CODE GENERATOR:  SEMANTIC INTERPRETATION ROUTINES

	chktype
	fudge
	esize
	pointer
	ectype
	pctype
	conv
	conv4
	convert
	convx
	convd
	texpr
	txpr2
	txpr3
	tptrop
	tpsub
	tpadd
	tpcomp
	txinc
	taddr
	telist
	tfarg

*/

/**********************************************************************

	CHKTYPE - Check type of enode.  If the enode is not of a valid
		type, then issue an error message and return TRUE.

	    M - integer indicating the valid types:
		If M is negative, the enode must be an lvalue.
		If M is zero, the enode is checked only to see if it
		is an lvalue.  The valid types are indicated by the
		low-order bits of the absolute value of M:

		bit 0 - integer
		bit 1 - character
		bit 2 - float
		bit 3 - double
		bit 4 - pointer

**********************************************************************/

int chktype (ep, m) enode *ep; int m;

	{type t;

	if (!ep) return (FALSE);
	t = ep->etype;
	if (m <= 0)
		{m = -m;
		if (!ep->lvalue)
			{errx (2023, cur_op);
			return (TRUE);
			}
		if (m==0) return (FALSE);
		}

	if (t == TUNDEF) return (TRUE);
	if ((t==TINT) && (m&001) ||
	(t==TCHAR) && (m&002) ||
	(t==TFLOAT) && (m&004) ||
	(t==TDOUBLE) && (m&010) ||
	(m&020) && (pointer(ep))) return (FALSE);

	errx (2022, cur_op);
	return (TRUE);
	}

/**********************************************************************

	FUDGE - determine constant used in pointer arithmetic

**********************************************************************/

int fudge (ep) enode *ep;

	{type t;

	t = ep->etype;
	if (t->tag != TTPTR) errx (6026);
	return (t->val->size);
	}

/**********************************************************************

	ESIZE - return the size of an expression

**********************************************************************/

int esize (ep) enode *ep;

	{return (ep->etype->size);}

/**********************************************************************

	POINTER - is the given expression subtree a pointer

**********************************************************************/

int pointer (p1) enode *p1;

	{return (p1 && p1->etype->tag == TTPTR);}

/**********************************************************************

	ECTYPE - return CTYPE of an expression

**********************************************************************/

int ectype (ep) enode *ep;

	{return (ctype (ep->etype));}

/**********************************************************************

	PCTYPE - return POINTER TYPE of expression

**********************************************************************/

int pctype (ep) enode *ep;

	{return (ectype (ep) - ct_p0);}

/**********************************************************************

	CONV - check for certain types

		convert CHAR -> INT
		convert FLOAT -> DOUBLE
		convert POINTER -> INT

		return pointer to enode

**********************************************************************/

enode *conv (p1, m) enode *p1; int m;

	{type t;

	if (!p1) return (NULL);
	if (chktype (p1, m)) return (NULL);
	t = p1->etype;
	if (t==TCHAR || pointer (p1)) p1=convert (p1, TINT);
	else if (t==TFLOAT) p1=convert (p1, TDOUBLE);
	return (p1);
	}

/**********************************************************************

	CONV4 - Convert Two Expressions As Appropriate For Arithmetic
		Operators:  Check for CHAR, INT, FLOAT, or DOUBLE.
		Convert to INT or DOUBLE as appropriate (expressions
		passed by reference).  Return 0 if result is INT,
		1 if result is DOUBLE, -1 if error.

**********************************************************************/

int conv4 (epp1, epp2) enode **epp1,**epp2;

	{type t1;
	type t2;

	if (chktype (*epp1, 017) | chktype (*epp2, 017))
		return (-1);	/* note: NOT || */
	t1 = (*epp1)->etype;
	t2 = (*epp2)->etype;
	if (t1==TFLOAT || t1==TDOUBLE || t2==TFLOAT || t2==TDOUBLE)
		{*epp1 = convert (*epp1, TDOUBLE);
		*epp2 = convert (*epp2, TDOUBLE);
		return (1);
		}
	else
		{*epp1 = convert (*epp1, TINT);
		*epp2 = convert (*epp2, TINT);
		return (0);
		}
	}

/**********************************************************************

	CONVERT - convert expression (EP) to given type (T)

**********************************************************************/

enode *convert (ep, t) enode *ep; type t;
	{return (convd (ep, ctype (t), t));}

/**********************************************************************

	CONVX - Convert expression to a given CTYPE.
		(Type field will be set to TUNDEF.)

**********************************************************************/

enode *convx (ep, ct) enode *ep;
	{return (convd (ep, ct, TUNDEF));}

/**********************************************************************

	CONVD - Real Conversion Routine

**********************************************************************/

# define _BAD 0177	/* illegal conversion */
# define _SAME 0176	/* identity conversion */
# define _STR 0175	/* structure : structure */

char cvt[10][10] {
	_BAD,_BAD,_BAD,_BAD,_BAD,_BAD,_BAD,_BAD,_BAD,_BAD,
	_BAD,_STR,_BAD,_BAD,_BAD,_BAD,_BAD,_BAD,_BAD,_BAD,
	_BAD,_BAD,_SAME,0040,0041,0042,_BAD,_BAD,_BAD,_BAD,
	_BAD,_BAD,0043,_SAME,0044,0045,0046,0047,0050,0051,
	_BAD,_BAD,0052,0053,_SAME,0054,_BAD,_BAD,_BAD,_BAD,
	_BAD,_BAD,0055,0056,0057,_SAME,_BAD,_BAD,_BAD,_BAD,
	_BAD,_BAD,_BAD,0060,_BAD,_BAD,_SAME,0061,0062,0063,
	_BAD,_BAD,_BAD,0064,_BAD,_BAD,0065,_SAME,0066,0067,
	_BAD,_BAD,_BAD,0070,_BAD,_BAD,0071,0072,_SAME,0073,
	_BAD,_BAD,_BAD,0074,_BAD,_BAD,0075,0076,0077,_SAME};

enode *convd (ep, ct, t) enode *ep; type t;

	{int op;
	switch (op = cvt[ectype (ep)][ct]) {
	case _BAD:	errx (2026, cur_op);
			return (NULL);
	case _SAME:
	case _STR:	return (ep);
			}
	return (mkenode (op, t, 0, ep, NULL));
	}

/**********************************************************************

	TEXPR - Translate expression from syntax tree form
	to expanded form with AMOPs.

**********************************************************************/

	/*	definition of OPDOPE fields	*/

# define NSUBTREE 0003	/* number of subtrees */
#   define UNARY 1
#   define BINARY 2
# define LVFLAG 0004	/* indicates to check for left lvalue */
# define CVMODE 0030	/* indicates some default conversions */
#   define BITSTRING 010	/* check for int or char */
#   define INTEGER 010		/* check for int or char */
#   define ARITH 020		/* do arithmetic conversions */
#   define LOGICAL 030		/* check for fundamental or ptr */
# define PTFLAG	0040	/* indicates special action on pointer */
# define OPFLAG 0100	/* indicates to set OP */
# define EQOP 0200	/* indicates op is an =OP */
# define SWFLAG 0400	/* indicates to execute main switch */

int opdope [] {	/* info on some node ops */

			0,
			0,
	/* idn */	SWFLAG + OPFLAG,
	/* int */	SWFLAG + OPFLAG,
	/* float */	SWFLAG + OPFLAG,
	/* string */	SWFLAG + OPFLAG,
	/* call */	SWFLAG + OPFLAG,
	/* ? */		SWFLAG + OPFLAG + BINARY,
	/* ++x */	SWFLAG + UNARY,
	/* x++ */	SWFLAG + UNARY,
	/* --x */	SWFLAG + UNARY,
	/* x-- */	SWFLAG + UNARY,
	/* *p */	SWFLAG + UNARY,
	/* &x */	SWFLAG + LVFLAG + UNARY,
	/* -x */	SWFLAG + UNARY,
	/* ~x */	SWFLAG + OPFLAG + UNARY,
	/* !x */	OPFLAG + LOGICAL + UNARY,
	/* x & y */	OPFLAG + BITSTRING + BINARY,
	/* x | y */	OPFLAG + BITSTRING + BINARY,
	/* x ^ y */	OPFLAG + BITSTRING + BINARY,
	/* x % y */	OPFLAG + INTEGER + BINARY,
	/* x / y */	OPFLAG + ARITH + BINARY,
	/* x * y */	OPFLAG + ARITH + BINARY,
	/* x - y */	OPFLAG + PTFLAG + ARITH + BINARY,
	/* x + y */	OPFLAG + PTFLAG + ARITH + BINARY,
	/* x = y */	SWFLAG + LVFLAG + BINARY,
	/* x == y */	SWFLAG + PTFLAG + ARITH + BINARY,
	/* x != y */	SWFLAG + PTFLAG + ARITH + BINARY,
	/* x < y */	SWFLAG + PTFLAG + ARITH + BINARY,
	/* x > y */	SWFLAG + PTFLAG + ARITH + BINARY,
	/* x <= y */	SWFLAG + PTFLAG + ARITH + BINARY,
	/* x >= y */	SWFLAG + PTFLAG + ARITH + BINARY,
	/* x << y */	OPFLAG + BITSTRING + BINARY,
	/* x >> y */	OPFLAG + BITSTRING + BINARY,
	/* x =>> y */	EQOP + OPFLAG + LVFLAG + BITSTRING + BINARY,
	/* x =<< y */	EQOP + OPFLAG + LVFLAG + BITSTRING + BINARY,
	/* x =+ y */	EQOP + OPFLAG + PTFLAG + LVFLAG + ARITH + BINARY,
	/* x =- y */	EQOP + OPFLAG + PTFLAG + LVFLAG + ARITH + BINARY,
	/* x =* y */	EQOP + OPFLAG + LVFLAG + ARITH + BINARY,
	/* x =/ y */	EQOP + OPFLAG + LVFLAG + ARITH + BINARY,
	/* x =% y */	EQOP + OPFLAG + LVFLAG + INTEGER + BINARY,
	/* x =& y */	EQOP + OPFLAG + LVFLAG + BITSTRING + BINARY,
	/* x =^ y */	EQOP + OPFLAG + LVFLAG + BITSTRING + BINARY,
	/* x =| y */	EQOP + OPFLAG + LVFLAG + BITSTRING + BINARY,
	/* x && y */	OPFLAG + LOGICAL + BINARY,
	/* x || y */	OPFLAG + LOGICAL + BINARY,
	/* x . y */	SWFLAG + UNARY,
	/* x : y */	SWFLAG + OPFLAG + BINARY,
	/* x , y */	SWFLAG + OPFLAG + BINARY,
	/* sizeof x */	SWFLAG
	};

enode *texpr (np) int *np;

	{enode *p1, *p2;
	int errflag;

	if (!exprlev) e_free();
	++exprlev;

	p1 = p2 = NULL;
	errflag = FALSE;
	switch (opdope[np[0]] & NSUBTREE) {
	case BINARY:	if (!(p2 = texpr (np[2]))) errflag = TRUE;
	case UNARY:	if (!(p1 = texpr (np[1]))) errflag = TRUE;
		}
	if (!errflag) p1 = txpr2 (np, p1, p2);
	else p1 = NULL;
	--exprlev;
	return (p1);
	}

enode *txpr2 (np, p1, p2)	int *np; enode *p1, *p2;

	{enode *ep;
	type t;

# ifndef SCRIMP

	if (aflag) cprint ("%2d TXPR2 %o[%d,%o,%o]\n",
		exprlev, np, np[0], p1, p2);

# endif

	ep = txpr3 (np, p1, p2);
	if (ep && exprlev != aquote && (t=ep->etype)->tag==TTARRAY)
		{ep->etype = t = t->val;
		ep = taddr (ep);
		ep->etype = mkptr (t);
		}

# ifndef SCRIMP

	if (aflag)
		{if (ep) cprint ("%2d TXPR2 RETURNS %o [%o,%o,%o]\n",
			exprlev, ep, ep->op, ep->ep1, ep->ep2);
		else cprint ("%2d TXPR2 RETURNS 0\n", exprlev);
		}

# endif

	return (ep);
	}

enode *txpr3 (np, p1, p2)	int *np; enode *p1, *p2;

	{field *fp;
	type t;
	int i, j, lvalue, op, eval, dope, cop, *ip;

	dope = opdope[cop=np[0]];
	eval = lvalue = 0;
	t = TINT;
	cur_op = cop;

	if (dope & LVFLAG)
		{if (chktype (p1, 0)) return (NULL);
		op = 1;
		}
	else op = 0;

	if ((dope & PTFLAG) && (pointer(p1) || pointer(p2)))
		return (tptrop (cop, p1, p2));

	switch (dope & CVMODE) {
	case BITSTRING:	p1 = conv (p1, 003);
			p2 = conv (p2, 003);
			if (!p1 || !p2) return (NULL);
			break;
	case ARITH:	switch (conv4 (&p1, &p2)) {
			case 1:		t = TDOUBLE; op =+ 2; break;
			case -1:	return (NULL);
				}
			break;
	case LOGICAL:	if (chktype (p1, 037) | chktype (p2, 037))
				return (NULL);	/* note: NOT || */
			}
	if (dope & OPFLAG) op =+ opbop[cop];
	if (dope & EQOP)
		{if (!p1->lvalue || undfop (op))

/*	lvalue==0 indicates an =op to a character or a float -
	p1 is a conversion operator

	convert to an assignment a = a op b with the
	subtree "a" pointed to by both operators

*/

			{p2 = mkenode (op-1, t, lvalue, p1, p2);
			if (!p1->lvalue) p1 = p1->ep1; /* the lvalue */
			p1->lvalue = 2;	/* special marker indicating this node
					  is a direct descendant of two nodes */
			goto case_assign;	/* make assignment */
			}
		}

	if (dope & SWFLAG) switch (cop) {

case n_incb:
case n_inca:
case n_decb:
case n_deca:	return (txinc (cop, p1, 1));

case n_star:
case_star:	if (chktype (p1, 020)) return (NULL);
		if (p1->op >= e_a0 && p1->op <= e_a3) return (p1->ep1);
		t = p1->etype->val;
		op = e_ind;
		lvalue = 1;
		break;

case n_addr:	return (taddr (p1));

case n_uminus:	if (!(p1 = conv (p1, 017))) return (NULL);
		if ((t=p1->etype) == TINT) op = e_iminus;
		else op = e_dminus;
		break;

case n_bnot:	if (!(p1 = conv (p1, 003))) return (NULL);
		op = e_bnot;
		break;

case n_assign:
case_assign:	if (!(p2 = convert (p2, t = p1->etype))) return (NULL);
		op = e_assign;
		break;

case n_idn:	return (txidn (np+1));

case n_int:	t = TINT;
		eval = np[1];
		p1 = eval;
		break;

case n_float:	t = TDOUBLE;
		eval = np[1];
		p1 = eval;
		break;

case n_string:	t = TACHAR;
		eval = np[1];
		p1 = eval;
		break;

case n_eq:
case n_ne:
case n_lt:
case n_gt:
case n_le:
case n_ge:	op = (t==TDOUBLE ? e_eqd : e_eqi) + cop - n_eq;
		t = TINT;
		break;

case n_call:	ip = np[1];	/* the function being called */
		if (!(p1 = texpr (ip))) return (NULL);
		if (ip[0] == n_idn && p1->op != e_idn)	/* undo coercion */
			{p1 = p1->ep1;
			if (!p1) return (NULL);
			}
		if (p1->etype->tag != TTFUNC)
			{errx (2028);
			return (NULL);
			}
		p2 = telist (np[2]);	/* the arguments */
		t = p1->etype->val;	/* the return type */
		break;

case n_dot:	/*
		 * Structure Reference
		 *
		 * Get structure type and search for the named
		 * field.
		 *
		 */

		if (p1->etype->tag != TTSTRUCT)
			{errx (2030);
			return (NULL);
			}
		j = np[2];		/* field name */
		fp = p1->etype->val;
		while (fp->name != UNDEF)
			if (fp->name == j) break;
			else ++fp;
		if (fp->name != j)	/* field not found */
			{errx (2029, TIDN, j);
			return (NULL);
			}
		t = fp->dtype;
		i = fp->offset;
		p1 = taddr (p1);
		t = mkptr (t);
		j = ctype (t);
		p1 = convx (p1, j);
		p1->etype = t;
		j =- ct_p0;
		p1 = mkenode (e_add0+j, t, 0, p1, intcon(i/spoint[j]));
		goto case_star;

case n_qmark:	if (chktype (p1, 037)) return (NULL);

case n_comma:	t = p2->etype;	/* fall through */
		break;

case n_colon:	if (p1->etype != p2->etype)
			{if (p1->etype->tag <= TTDOUBLE &&
			     p2->etype->tag <= TTDOUBLE)
				{switch (conv4 (&p1, &p2)) {
				case 1:		t = TDOUBLE; break;
				case -1:	return (NULL);
				default:	t = TINT;
					}
				}
			else
				{errx (2031);
				return (NULL);
				}
			}
		else t = p1->etype;
		break;

case n_sizeof:	i = aquote;
		aquote = exprlev + 1;
		p1 = texpr (np[1]);
		aquote = i;
		if (!p1) return (NULL);
		return (intcon (esize (p1)));

default:	errx (2035, cop);
		return (NULL);
		}

	return (mkenode (op, t, lvalue, p1, p2));
	}

/**********************************************************************

	TPTROP - Translate pointer operation

**********************************************************************/

enode *tptrop (cop, p1, p2)
	enode *p1, *p2;

	{switch (cop) {
	case n_minus:	return (tpsub (p1, p2));
	case n_aminus:	return (tpadd (e_sub0, TRUE, p1, p2));
	case n_plus:	if (pointer(p2))
				return (tpadd (e_add0, FALSE, p2, p1));
			return (tpadd (e_add0, FALSE, p1, p2));
	case n_aplus:	return (tpadd (e_add0, TRUE, p1, p2));
	case n_eq:
	case n_ne:
	case n_lt:
	case n_gt:
	case n_le:
	case n_ge:	return (tpcomp (p1, p2, cop-n_eq));
		}
	}

/**********************************************************************

	TPSUB - Translate pointer subtraction

**********************************************************************/

enode *tpsub (p1, p2)
	enode *p1, *p2;

	{int i;

	if (pointer (p1) && pointer (p2))
		{if (p1->etype != p2->etype) errx (2025);
		i = fudge (p1);
		p1 = convert (p1, TPCHAR);
		p2 = convert (p2, TPCHAR);
		p1 = mkenode (e_p0sub, TINT, 0, p1, p2);
		p2 = intcon (i);
		return (mkenode (e_divi, TINT, 0, p1, p2));
		}
	if (pointer(p2))
		{errx (2034);
		return (NULL);
		}
	return (tpadd (e_sub0, FALSE, p1, p2));
	}

/**********************************************************************

	TPADD - Translate pointer addition/subtraction with integer

**********************************************************************/

enode *tpadd (op, assign, p1, p2)
	enode *p1, *p2;

	{type t;
	int j;
	enode *ep;

	t = p1->etype;
	j = pctype (p1);
	if (!(p2 = conv (p2, 003))) return (NULL);
	ep = mkenode (e_muli, TINT, 0, p2, intcon (fudge(p1)/spoint[j]));
	ep = mkenode (op+j, t, 0, p1, ep);
	if (assign)
		{p1 = ep->ep1;
		p1->lvalue = 2;
		ep = mkenode (e_assign, t, 0, p1, ep);
		}
	return (ep);
	}

/**********************************************************************

	TPCOMP - Construct Pointer Comparison

**********************************************************************/

enode *tpcomp (p1, p2, cc)	enode *p1, *p2;

	{int op, j;
	enode *ep;
	econst *ecp;

	if (pointer (p1) && pointer (p2))
		{j = min (pctype (p1), pctype (p2));
		op = e_eqp0 + cc + 6*j;
		while (undfop(op) && j>0) {--j; op =- 6;}
		j =+ ct_p0;
		p1 = convx (p1, j);
		p2 = convx (p2, j);
		return (mkenode (op, TINT, 0, p1, p2));
		}

	if (pointer (p2)) {ep=p1;p1=p2;p2=ep;}

	p2 = opt(p2);
	if (cc<cc_lt0 && p2->op==e_int && (ecp=p2)->eval==0)
		{op = e_jz0 + 4*cc + pctype (p1);
		if (!undfop (op)) return (mkenode (op, TINT, 0, p1, NULL));
		return (mkenode (e_eqi+cc, TINT, 0,
			convx (p1, ct_int), intcon (0)));
		}

	errx (2032);
	return (intcon (0));
	}

/**********************************************************************

	TXIDN - Translate IDN node

**********************************************************************/

enode *txidn (p)
	struct {int itype, iclass, ioffset;} *p;

	{type t;
	enode *ep;

	t = to2p (p->itype);
	ep = mkenode (e_idn, t, 1, p->iclass, p->ioffset);
	if (t->tag==TTFUNC || p->iclass==c_label)
		ep = mkenode (e_a0+tpoint[TTINT], mkptr (t), 0, ep, NULL);
	else if (flt_hack && t==TDOUBLE && p->iclass==c_param)
		{ep->etype = mkptr (t);
		ep->lvalue = 0;
		ep = mkenode (e_ind, t, 1, ep, NULL);
		}
	return (ep);
	}

/**********************************************************************

	TXINC - Translate increment/decrement

**********************************************************************/

enode *txinc (cop, p1, n)
	enode *p1;

	{int op, bop, j;
	type t;
	enode *p2;

	p2 = NULL;
	bop = op = cop - n_incb;
	if (chktype (p1, -037)) return (NULL);
	t = p1->etype;
	switch (t->tag) {
	case TTCHAR:	op =+ e_incbc; break;
	case TTINT:	op =+ e_incbi; break;
	case TTFLOAT:	op =+ e_incbf; break;
	case TTDOUBLE:	op =+ e_incbd; break;
	default:	j = pctype (p1);
			op =+ e_incb0 + (j<<2);
			p2 = intcon (fudge(p1)/spoint[j]);
			}
	if (undfop (op))
		{switch (bop) {
		case 0:	/* prefix */
		case 2:	op = (bop==0 ? n_aplus : n_aminus);
			return (txpr3 (&op, p1, intcon (1)));
		case 1:	/* postfix */
		case 3:	op = (bop==1 ? n_aplus : n_aminus);
			p2 = txpr2 (&op, p1, intcon (1));
			++p1->lvalue;
			op = e_lseq;
			break;
			}
		}
	return (mkenode (op, t, 0, p1, p2));
	}

/**********************************************************************

	TADDR - Construct Address of Expression

**********************************************************************/

enode *taddr (ep)	enode *ep;

	{int op;
	type t;

	if (!ep) return (NULL);
	op = ep->op;

	if (op==e_ind) ep = ep->ep1;
	else
		{if (ep->lvalue==0) ep->lvalue=1;
		t = mkptr (ep->etype);
		op = e_a0 + ctype (t) - ct_p0;
		ep = mkenode (op, t, 0, ep, NULL);
		}
	return (ep);
	}

/**********************************************************************

	TELIST - translate an expression_list subtree

	Translate the expressions in an expression list.  Use the
	ELIST node structure to hold the translated expressions.
	Mark such nodes with -1 to distinguish from ENODEs.

**********************************************************************/

enode *telist (np)
	int *np;

	{enode *ep;
	int count, *onp;

	if (!np) return (NULL);
	if (np[0] != n_elist) return (tfarg (np));
	ep = np;
	count = 1;
	do
		{np[0] = -1;	/* mark */
		np[2] = tfarg (np[2]);
		onp = np;
		np = np[1];
		++count;
		} while (np && np[0] == n_elist);
	onp[1] = tfarg (np);

	if (count > maxfarg) {errx (2039); return (NULL);}
	return (ep);
	}

/**********************************************************************

	TFARG - translate a function argument

**********************************************************************/

enode *tfarg (np)
	int *np;

	{enode *ep;
	int op;

	if (!(ep = texpr (np))) return (NULL);
	cur_op = n_call;	/* for error messages */
	if (ep->etype == TCHAR) ep = convert (ep, TINT);
	else if (ep->etype == TFLOAT) ep = convert (ep, TDOUBLE);
	if (chktype (ep, 031)) return (NULL);
	if (!argops) return (ep);
	switch (ep->etype->tag) {
		case TTINT:	op = e_argi; break;
		case TTDOUBLE:	if (flt_hack) return (ep);
				op = e_argd; break;
		case TTPTR:	op = e_arg0 + pctype (ep); break;
		}
	return (mkenode (op, ep->etype, 0, ep, NULL));
	}

/**********************************************************************

	CODE GENERATOR:  OPTIMIZATION ROUTINES

	opt

*/

/**********************************************************************

	OPT - Optimize Expression

	Evaluate Integer Constant Expressions
	Commute Where Desirable
	Simplify Operations by 0 or 1
	Rearrange Multiple Additions to a Pointer

**********************************************************************/

# define COMMUTATIVE 1
# define ZEROIDENTITY 2
# define ZEROFLUSH 4
# define ONEIDENTITY 010

int adope [] {	/* info on some AMOPs */

	/* +i */	COMMUTATIVE + ZEROIDENTITY,
	/* =+i */	ZEROIDENTITY,
	/* +d */	COMMUTATIVE,
	/* =+d */	0,
	/* -i */	ZEROIDENTITY,
	/* =-i */	ZEROIDENTITY,
	/* -d */	0,
	/* =-d */	0,
	/* *i */	COMMUTATIVE + ZEROFLUSH + ONEIDENTITY,
	/* =*i */	ZEROFLUSH + ONEIDENTITY,
	/* *d */	COMMUTATIVE,
	/* =*d */	0,
	/* /i */	ONEIDENTITY,
	/* =/i */	ONEIDENTITY,
	/* /d */	0,
	/* =/d */	0,
	/* % */		0,
	/* =% */	0,
	/* << */	ZEROIDENTITY,
	/* =<< */	ZEROIDENTITY,
	/* >> */	ZEROIDENTITY,
	/* =>> */	ZEROIDENTITY,
	/* & */		COMMUTATIVE + ZEROFLUSH,
	/* =& */	0,
	/* ^ */		COMMUTATIVE + ZEROIDENTITY,
	/* =^ */	ZEROIDENTITY,
	/* | */		COMMUTATIVE + ZEROIDENTITY,
	/* =| */	ZEROIDENTITY,
	/* && */	0,
	/* || */	0,
	/* -p0p0 */	0,
	/* = */		0,
	/* .argi */	0,
	/* .argd */	0,
	/* .arg0 */	0,
	/* .arg1 */	0,
	/* .arg2 */	0,
	/* .arg3 */	0,
	/* +p0 */	ZEROIDENTITY,
	/* +p1 */	ZEROIDENTITY,
	/* +p2 */	ZEROIDENTITY,
	/* +p3 */	ZEROIDENTITY,
	/* -p0 */	ZEROIDENTITY,
	/* -p1 */	ZEROIDENTITY,
	/* -p2 */	ZEROIDENTITY,
	/* -p3 */	ZEROIDENTITY
			};

enode *opt (ep)	enode *ep;

	{int	op, dope, c1, c2, v1, v2, v;
	enode	*p1, *p2, *p;
	econst	*ecp;

	if (!ep) return (ep);
	switch (op = ep->op) {
		case e_call:
		case e_idn:
		case e_int:
		case e_float:
		case e_string:	return (ep);
		}
	if (!(p1 = ep->ep1)) return (ep);
	p1 = ep->ep1 = opt (p1);
	p2 = ep->ep2 = opt (ep->ep2);
	if (c1 = (p1->op == e_int)) v1 = (ecp=p1)->eval;
	if (c2 = (p2 && p2->op == e_int)) v2 = (ecp=p2)->eval;

# define y goto yes;

	/* evaluate unary operations on integer constants */

	if (op<=e_not && c1) switch (op) {
	case e_iminus:	v = -v1; y
	case e_bnot:	v = ~v1; y
	case e_not:	v = !v1; y
		}

	else if (op>=e_addi && op<=e_sub3 && p2)
		{dope = adope[op-e_addi];

	/* evaluate binary operations on integer constants */

		if (c1 && c2) switch (op) {
		case e_addi:	v = v1+v2; y
		case e_subi:	v = v1-v2; y
		case e_muli:	v = v1*v2; y
		case e_divi:	v = v1/v2; y
		case e_mod:	v = v1%v2; y
		case e_ls:	v = v1<<v2; y
		case e_rs:	v = v1>>v2; y
		case e_band:	v = v1&v2; y
		case e_xor:	v = v1^v2; y
		case e_bor:	v = v1|v2; y
		case e_and:	v = v1&&v2; y
		case e_or:	v = v1||v2; y
			}

	/* commute where suitable */

		else
			{if ((dope & COMMUTATIVE)
			    && (c1 || p2->degree > p1->degree))
				{p = p1; ep->ep1 = p1 = p2; ep->ep2 = p2 = p;
				v = c1; c1 = c2; c2 = v;
				v = v1; v1 = v2; v2 = v;
				}

	/* hack operations by 0 */

			if (c2)
				if (v2==0)
					{if (dope & ZEROIDENTITY)
						return (p1);
					if (dope & ZEROFLUSH)
						return (p2);
					}

	/* hack operations by 1 */

				else if (v2==1)
					if (dope & ONEIDENTITY)
						return (p1);

	/* rearrange pointer additions */

			if (op>=e_add0 && op<=e_sub3 && p1->op==op)
				{p = p1->ep1;
				p1->op = e_addi;
				p1->etype = TINT;
				p1->ep1 = p2;
				ep->ep2 = opt (p1);
				ep->ep1 = p;
				}
			}
		}
	return (ep);
yes:	return (intcon (v));
	}
