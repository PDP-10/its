/*

	C COMPILER
	Phase C: Code Generator
	Insert File

	Copyright (c) 1977 by Alan Snyder

*/

/*	types	*/

struct _dref {int drbase, droffset;};
struct _loc {int flag, word;};
struct _oploc {struct _loc xloc [3]; int clobber;};

struct _enode {
	int op;
	type etype;
	struct _dref edref;
	char lvalue, degree, saved;
	struct _enode *ep1, *ep2;
	};

struct _econst {
	int op;
	type etype;
	struct _dref edref;
	char lvalue, degree, saved;
	int eval;
	};

struct _eidn {
	int op;
	type etype;
	struct _dref edref;
	char lvalue, degree, saved;
	int eclass, eoffset;
	};

# define dref struct _dref
# define loc struct _loc
# define oploc struct _oploc
# define enode struct _enode
# define econst struct _econst
# define eidn struct _eidn

/*      machine description tables      */

extern  oploc   xoploc[];
extern  int     tsize[], talign[], calign[], retreg[], tpoint[],
		spoint[], trdt[], prdt[], conf[], rtopp[], rtopl[],
		mactab[], opreg[], opmem[], (*off_ok[])(), ntype,
		nmem, nac, npc, nreg, flt_hack;

/*      code generator variables defined in C31 */

extern  enode   acore[], *acorp;

extern  int     lc_node, flc_node, *core, *corep, cbn, nfunc, lineno,
		exprlev, ttxlev, cur_op, temploc, autoloc, aquote,
		framesize, objmode, f_error, argops,
		f_mac, f_node, fidn, ntw[], eof_node, aflag, ciln,
		int_size, opdope[], adope[], allreg[], allmem[],
		anywhere[];

extern  char    *fn_error, *fn_node, *fn_typtab, *options,
		*fn_mac, type_node[], nodelen[], opbop[];

extern	type	ftype;

/*	functions	*/

enode	*cgassign(), *cgcall(), *cgcomma(), *cgexpr(), *cgfloat(),
	*cgidn(), *cgindirect(), *cgint(), *cglseq(), *cgmove(),
	*cgop(), *cgqmark(), *cgstring(), *conv(), *convd(),
	*convert(), *convx(), *e_alloc(), *intcon(), *jumpval(),
	*mkenode(), *mmove(), *opt(), *taddr(), *telist(), *tfarg(),
	*texpr(), *tpadd(), *tpcomp(), *tpsub(), *tptrop(), *ttexpr(),
	*txidn(), *txinc(), *txpr2(), *txpr3();

int	*elist(), *ro2p();

oploc	*choose();

type	mkarray();
type	mkptr();
type	to2p();

/*	special type values	*/

extern type	TCHAR;
extern type	TINT;
extern type	TFLOAT;
extern type	TDOUBLE;
extern type	TLONG;
extern type	TUNSIGNED;
extern type	TUNDEF;
extern type	TPCHAR;
extern type	TACHAR;
extern type	TFINT;
