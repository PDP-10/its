# include "cc.h"

/*

	C Compiler
	Phase S: Symbol Table Dumper

	Copyright (c) 1977 by Alan Snyder

	uses c93.c c95.c

*/

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

/*	dictionary	*/

struct _dentry		/* dictionary entry */
	{int	name;	/* the identifier, struct types stored +cssiz */
	type	dtype;	/* data type */
	int	offset;	/* addressing info */
	int	class;	/* storage class */
	};

# define dentry struct _dentry

type	typscan();
type	to2p();
int	*ro2p();

int	debug;

char	cstore[cssiz];
char	*fn_cstore;	/* cstore file name */
char	*fn_symtab;
char	*fn_typtab;

/*	DICTIONARY	*/

dentry	dict [stsize],
	*dbegin {dict},	/* first entry */
	*dgdp {dict},	/* entry following defs */
	*dend;		/* following last entry */

/*	special type values	*/

type	TCHAR;
type	TINT;
type	TFLOAT;
type	TDOUBLE;
type	TLONG;
type	TUNSIGNED;
type	TUNDEF;
type	TPCHAR;
type	TACHAR;
type	TFINT;

/*	type table	*/

int	typtab[TTSIZE];
int	*ctypp, *crecp, *etypp;

main (argc, argv)
	char *argv[];

	{extern int cout;
	int fout;

	--argc;
	++argv;

	if (argc > 0) fn_cstore = argv[0];
		else fn_cstore = "0.cs";
	if (argc > 1) fn_typtab = argv[1];
		else fn_typtab = "0.ty";
	if (argc > 2) fn_symtab = argv[2];
		else fn_symtab = "0.sy";
	if (argc > 3) fout = copen (argv[3], 'w');
		else fout = -1;
	if (fout == -1) fout = cout;
	if (argc < 4) debug = TRUE;
	rcstore ();
	rtyptab ();
	typcinit ();
	psymtab (fout);
	if (debug) ptypes (fout);
	cclose (fout);
	}

psymtab (fout)

	{int name, f;

	dend = dbegin + stsize;
	f = xopen (fn_symtab, MREAD, BINARY);
	do
		{name = geti (f);
		rdict (f);
		pdict (name, fout);
		}
	while (name != UNDEF);
	cclose (f);
	}

pdict (name, fout)

	{dentry *dp, *p1, *p2;
	int incr;

	if (name == UNDEF)
		{cprint (fout, "\n --- GLOBAL SYMBOL TABLE --- \n");
		p1 = dbegin;
		p2 = dgdp;
		incr = 1;
		}
	else
		{cprint (fout, "\n --- LOCAL SYMBOL TABLE FOR FUNCTION ");
		pridn (name, fout);
		cprint (fout, " --- \n");
		p1 = dgdp-1;
		p2 = dbegin-1;
		incr = -1;
		}

	dp = p1;
	while (dp != p2)
		{if (debug || dp->name < cssiz)
			{cprint (fout, "\t");
			pridn (dp->name, fout);
			cprint (fout, ": ");
			prclass (dp->class, fout);
			cprint (fout, " ");
			typrint (dp->dtype, fout);
			if (debug) cprint (fout, "  %d", dp->offset);
			cprint (fout, "\n");
			}
		dp =+ incr;
		}
	}

ptypes (fout)

	{int *p;
	extern int typtab[], *ctypp;

	cprint (fout, "\n --- TYPE TABLE --- \n");
	p = typtab;
	while (p < ctypp)
		{cprint (fout, "%5d: tag=%2d sz=%4d al=%2d  ",
			p, p[0], p[1], p[2]);
		typrint (p, fout);
		cprint (fout, "\n");
		p = typscan (p);
		}
	}

pridn (name, f)

	{if (name>=cssiz) {name =- cssiz; cprint (f, ".");}
	if (name < cssiz) prs (&cstore[name], f);
	}

prclass (class, f)

	{char *s;

	switch (class) {
case c_register:	s = "register"; break;
case c_auto:		s = "auto"; break;
case c_extdef:		s = "extdef"; break;
case c_static:		s = "static"; break;
case c_param:		s = "parameter"; break;
case c_label:		s = "label"; break;
case c_extern:		s = "extern"; break;
case c_struct:		s = "struct type ="; break;
case c_typedef:		s = "type ="; break;
case c_ustruct:		s = "undefined struct type"; break;
case c_ulabel:		s = "undefined label"; break;
default:		s = "class[%d]";
			}
	cprint (f, s, class);
	}

int typnval[] {0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 2, 1, 1};
int typform[] {0, 0, 0, 0, 0, 0, 0, 1, 1, 2, 2, 3, 4, 1};

typcinit () {;}

typedesc *typscan (p)
	typedesc *p;

	{return (&(p->val) + typnval[p->tag]);}

typrint (t, f)
	type t;

	{switch (t->tag) {
	case TTCHAR:		cprint (f, "char"); return;
	case TTINT:		cprint (f, "int"); return;
	case TTFLOAT:		cprint (f, "float"); return;
	case TTDOUBLE:		cprint (f, "double"); return;
	case TTLONG:		cprint (f, "long"); return;
	case TTUNSIGNED:	cprint (f, "unsigned"); return;
	case TTCFIELD:		cprint (f, "char[%d]", t->val); return;
	case TTIFIELD:		cprint (f, "int[%d]", t->val); return;
	case TTUNDEF:		cprint (f, "undefined"); return;
	case TTPTR:		cprint (f, "*"); typrint (t->val, f);
				return;
	case TTFUNC:		cprint (f, "()"); typrint (t->val, f);
				return;
	case TTARRAY:		cprint (f, "[%d]", t->nelem);
				typrint (t->val, f); return;
	case TTSTRUCT:		prstruct (t, f); break;
	default:		cprint (f, "?");
			}
	}

prstruct (t, f)
	type t;

	{register field *fp;
	static int level;

	++level;
	if (level > 1) cprint (f, "struct#%d", t);
	else
		{fp = t->val;
		cprint (f, "{");
		while (fp->name != UNDEF)
			{pridn (fp->name, f);
			cprint (f, ":");
			typrint (fp->dtype, f);
			if ((++fp)->name != UNDEF) cprint (f, ",");
			}
		cprint (f, "}");
		}
	--level;
	}

/**********************************************************************

	RDICT - Read Dictionary

	Read Dictionary from file F.

**********************************************************************/

rdict (f)

	{int name;

	dgdp = dbegin;
	while (TRUE)
		{name = geti (f);
		if (name == UNDEF || ceof (f)) return;
		if (dgdp >= dend) errx (4005);
		dgdp->name = name;
		dgdp->dtype = to2p (geti (f));
		dgdp->offset = geti (f);
		dgdp->class = geti (f);
		++dgdp;
		}
	}

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

	{extern int typtab[], *ctypp;

	if (i < 0 || i >= TTSIZE) errx (6006);
	return (typtab + i);
	}

int *ro2p (i) int i;

	{extern int *etypp;

	if (i < 0 || i >= TTSIZE) errx (6047);
	return (etypp - i);
	}

errx (n)
	{cprint ("Table format error %d\n", n);
	if (n>=4000) cexit(-1);
	}

char *fn_error;
int f_error;
cleanup () {cexit (0);}
