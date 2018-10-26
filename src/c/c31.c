# include "cc.h"
# include "c3.h"

/*

	C COMPILER
	Phase C: Code Generator
	Section 1: Control, Storage Allocation, and Statements

	Copyright (c) 1977 by Alan Snyder

*/

type	ftype;		/* type of current function */

enode	acore[acoresz],	/* core for enode tree and switch table*/
	*acorp {acore};

int	lc_node 1,	/* node file location counter */
	flc_node,	/* lc_node at beginning of current function,
			   used to relocate tree to start of core */
	*core,		/* points to array which holds the tree
			   for each function */
	*corep,		/* pointer to next free location in core */
	cbn 0,		/* current block number */
	nfunc 0,	/* current number of functions */
	lineno 1,	/* line number of current statement */
	exprlev 0,	/* expression interpretation level */
	ttxlev 0,	/* expression code generation level */
	cur_op,		/* current node op, for error messages */
	temploc 0,	/* temporary location counter */
	autoloc 0,	/* automatic variables location counter */
	framesize 0,	/* current maximum stack frame size */
	int_size,	/* size of integer */
	argops,		/* 1 => .arg ops are defined */
	objmode -1,	/* object mode (pure, impure, data, pdata) */
	f_error -1,
	f_mac -1,
	f_node -1,
	fidn -1,
	ntw[]		/* indicates which words of a node
			   are pointers, according to type_node */
		{000,002,006,016,003,001,007,004},
	eof_node 0,	/* indicates end-of-file of node file */
	aflag 0,	/* flag indicates tracing */
	aquote 0,	/* exprlev at which don't cvt array to ptr */
	ciln 5000;	/* current input label number */

char	*fn_error,
	*fn_mac,
	*fn_node,
	*fn_typtab,
	*options,
	type_node[]	/* used to index ntw according to node-op */

		{0,0,0,0,0,0,4,4,5,5,
		5,5,5,5,5,5,5,4,4,4,
		4,4,4,4,4,4,4,4,4,4,
		4,4,4,4,4,4,4,4,4,4,
		4,4,4,4,4,4,5,4,4,5,
		0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,
		0,0,0,0,0,0,0,0,0,0,
		3,1,0,1,4,3,5,5,1,7,
		1,4,0,0},
	nodelen[]	/* length in words of node given op */

		{
# include "cnlen.h"
		},
	opbop[] {
	0,		0,		e_idn,		e_int,		e_float,
	e_string,	e_call,		e_qmark,	0,		0,
	0,		0,		0,		0,		0,
	e_bnot,		e_not,		e_band,		e_bor,		e_xor,
	e_mod,		e_divi,		e_muli,		e_subi,		e_addi,
	0,		0,		0,		0,		0,
	0,		0,		e_ls,		e_rs,		e_rs,
	e_ls,		e_addi,		e_subi,		e_muli,		e_divi,
	e_mod,		e_band,		e_xor,		e_bor,		e_and,
	e_or,		0,		e_colon,	e_comma,	0
		};

int allreg[2] {l_reg,-1};	/* dummy loc indicating all registers ok */
int allmem[2] {l_mem,-1};	/* dummy loc indicating all memory ok */
int anywhere[2] {l_any,0};	/* dummy loc indicating anywhere ok */
int swloc[2] {l_reg,0};		/* dummy loc for switch arg */

/**********************************************************************

	MAIN ROUTINE

**********************************************************************/

# define MAXN 6

main (argc,argv) int argc; char *argv[];

	{int c, i, core_size;
	char *cp;

	if (argc < MAXN)
		{cprint ("Phase C called with too few arguments.\n");
		cexit (100);
		}

	int_size = tsize[TTINT];
	argops = !undfop (e_argi);

	/* initialize swloc */

	i = rtopp[e_sw];
	if (i >= 0)
		{i = rtopl[i];
		if (i >= 0)
			{swloc[0]=xoploc[i].xloc[0].flag;
			swloc[1]=xoploc[i].xloc[0].word;
			}
		}

	cp = argv[1];
	while (c = *cp++) switch (c) {
		case 'a':	aflag=TRUE; break;
		}

	options=argv[1];
	fn_error=argv[2];
	fn_node=argv[3];
	fn_typtab=argv[4];
	fn_mac=argv[5];

	core_size = coresz;
	if (argc>MAXN) if ((i=atoi(argv[MAXN]))>1000) core_size=i;

	core = getvec (core_size);
	reg_init ();

	rtyptab ();
	typcinit ();

	f_mac = xopen (fn_mac, MAPPEND, TEXT);
	pure;
	s_alloc ();

	f_node = xopen (fn_node, MREAD, BINARY);
	while (!eof_node)
		{flc_node = lc_node;
		corep = core;
		cbn++;

		while (read_node() != n_prog)
			{if (eof_node) break;
			if (corep >= core + (core_size - 6))
				errx (4013);
			}

		if (!eof_node)
			{fhead (corep[-5], corep[-4], corep[-1]);
			framesize = autoloc = corep[-2];
			stmt (corep[-3]);
			framesize = align (framesize, nac-1);
			mepilog ();
			ftail ();
			}
		}
	endcard ();
	cclose (f_mac);
	cleanup (0);
	}

/**********************************************************************

	CLEANUP - Code Generator Cleanup Routine

**********************************************************************/

cleanup (rcode)

	{extern int maxerr;
	cexit (rcode?rcode:maxerr>=2000);
	}

/**********************************************************************

	ERRX - Report error (lineno accessed via external variable)

**********************************************************************/

errx (errno, a1, a2, a3, a4)
	{error (errno, lineno, a1, a2, a3, a4);}

/**********************************************************************

	CODE GENERATOR: STORAGE ALLOCATION ROUTINES

	fhead
	ftail
	gettemp
	ttemp
	s_alloc
	sdef

*/

/**********************************************************************

	FHEAD - function head

	Define function name (FIDN) and type (FTYPE) and emit prolog.

**********************************************************************/

fhead (name, o, narg) int name, o, narg;

	{++nfunc;
	ftype = to2p (o);
	fidn = name;
	pure;
	mprolog (nfunc, fidn, narg);
	}

/**********************************************************************

	FTAIL - Termination Processing for Function.

**********************************************************************/

ftail()

	{;}

/**********************************************************************

	GETTEMP - Allocate a temporary location on the stack
		for an expression.  Return its offset from the
		beginning of the stack frame.

**********************************************************************/

int gettemp (ep) enode *ep;

	{return (ttemp (ep->etype, 1));}

/**********************************************************************

	TTEMP - allocate a temporary for N objects of type T

**********************************************************************/

int ttemp (t, n)
	type t;

	{int lc;

	lc = temploc = align (temploc, t->align);
	temploc =+ n*t->size;
	if (temploc > framesize) framesize = temploc;
	return (lc);
	}

/**********************************************************************

	S_ALLOC - Allocate storage for string constants

**********************************************************************/

s_alloc ()

	{pdata;
	string ();
	}

/**********************************************************************

	CODE GENERATOR: HIGHER LEVEL CODE GENERATION ROUTINES

	stmt
	astmt
	cgswitch
	expr

*/

/**********************************************************************

	STMT - PROCESS A STATEMENT

	This routine looks for statement lists and calls ASTMT when it
	finds a "real" statement.  This method saves stack space while
	descending the syntax tree.

**********************************************************************/

stmt (p) int *p;

	{if (p[0]==n_stmtl) {stmt(p[1]); stmt(p[2]);}
	else astmt(p);
	}

/**********************************************************************

	ASTMT - Process statement

**********************************************************************/

astmt (p) int *p;

	{int el, fl, op, l1, *p1;
	enode *ep;
	econst *ecp;

	while (TRUE)

	    {if (!p) return;
	    cur_op = op = p[0];
	    switch (op) {

case n_switch:	ln (p);
		l1 = ciln++;
		cgswitch (p[2], p[4], l1);
		stmt (p[3]);
		ilabel (l1);
		return;

case n_if:	ln (p);
		if (!(ep = opt (texpr (p[2])))) return;
		if (ep->op == e_int)
			if ((ecp=ep)->eval) stmt (p[3]);
			else stmt (p[4]);
		else
			{p1 = p[3];	/* then stmt */
			if (p1[0]==n_branch)
				{jumpn (ep, p1[1]);
				if (p[4]) stmt (p[4]);
				}
			else
				{jumpz (ep, fl=el=ciln++);
				stmt (p[3]);
				if (p[4])
					{jump (fl=ciln++);
					ilabel (el);
					stmt (p[4]);
					}
				ilabel (fl);
				}
			}
		return;

case n_goto:	ln (p);
		if (!(ep = texpr (p[2]))) return;
		if (ep->etype==TINT) jumpe (ep);
		else errx (2009);
		return;

case n_branch:	jump (p[1]);
		return;

case n_label:	ilabel (p[1]);
		p = p[2];
		continue;

case n_stmtl:	stmt (p[1]);
		stmt (p[2]);
		return;

case n_return:	ln (p);
		if (p[2]) ep = convert (texpr(p[2]), ftype->val);
		else ep = NULL;
		creturn (ep);
		return;

case n_exprs:	ln (p);
		expr (texpr (p[2]), anywhere);
		return;
		}
	    }
	}

/**********************************************************************

	CGSWITCH - Generate SWITCH operation for expression
		NP, case list LP, and label L1 following body
		of SWITCH statement.

**********************************************************************/

cgswitch (np, lp, l1)	int *np, *lp, l1;

	{enode *ep;
	int l, n, lo, hi, range, *p, *swtab, *et, *q, i, *csp, b, o;

	ep = texpr (np);
	cur_op = n_switch;
	ep = expr (conv (ep, 03), swloc);
	if (!ep) return;
	b = ep->edref.drbase;
	o = ep->edref.droffset;
	l = -1;		/* default internal label */
	n = 0;
	csp = swtab = acore;
	et = acore + acoresz;
	p = lp;
	while (p)
		{switch (p[0]) {

	case n_case:	i = p[2];
			for (q=swtab;q<csp;q=+2)
				if (q[0]==i) {errx (2020); break;}
			if (q==csp)
				{if (csp>=et) errx (4010);
				*csp++ = i;
				*csp++ = p[3];
				if (n++ == 0) {lo = i; hi = i;}
				else if (i < lo) lo = i;
				else if (i > hi) hi = i;
				}
			break;

	case n_def:	if (l>=0) errx (2021);
			else l = p[2];
			break;

	default:	errx (6003, p[0]);
			}

		p = p[1];
		}

	if (l<0) l = l1;
	if (n==0) {jump (l); return;}
	range = hi - lo + 1;

	if (range <= 3*n && swtab+range < et)
		{csp = swtab+range;
		for (q=swtab;q<csp;++q) *q=l;
		p = lp;
		while (p)
			{if (p[0]==n_case) swtab[p[2]-lo] = p[3];
			p = p[1];
			}
		mtswitch (b, o, lo, hi, l);
		for (q=swtab;q<csp;++q) mlabcon (*q);
		metswitch (b, o, lo, hi, l);
		}

	else
		{mlswitch (b, o, n, l);
		for (q=csp-2;q>=swtab;q =- 2) mint (q[0]);
		for (q=csp-2;q>=swtab;q =- 2) mlabcon (q[1]);
		melswitch (b, o, n, l);
		}
	}

/**********************************************************************

	EXPR - Optimize and Generate Code For Expression

**********************************************************************/

expr (ep, xp) enode *ep;

	{return (ttexpr (opt (ep), xp));}
