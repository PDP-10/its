# include "cc.h"

/*

	C Compiler
	Routines common to phases P and C

	Copyright (c) 1977 by Alan Snyder

	ctype
	remarr
	mprint
	mprd
	align

*/

/**********************************************************************

	CTYPE - convert type to CTYPE

**********************************************************************/

int ctype (t) type t;

	{extern int tpoint[], talign[], ntype;
	extern type TINT;
	extern type remarr();
	int ac, tag;

	if (t->tag == TTFUNC) t = t->val;
	switch (t->tag) {

case TTCHAR:	return (ct_char);
case TTINT:	return (ct_int);
case TTFLOAT:	return (ct_float);
case TTDOUBLE:	return (ct_double);
case TTSTRUCT:	return (ct_struct);
case TTPTR:	t = remarr (t->val);
		switch (t->tag) {
	case TTCHAR:
	case TTFLOAT:
	case TTDOUBLE:	break;
	case TTSTRUCT:	ac = t->align;
			for (tag=0;tag<ntype;++tag)
				if (talign[tag]==ac)
					return (ct_p0 + tpoint[tag]);
	default:	t = TINT;
			}
		return (ct_p0 + tpoint[t->tag]);
		}
	return (ct_bad);
	}

/**********************************************************************

	REMARR - remove "array of ..." modifiers from type

**********************************************************************/

type remarr (t) type t;

	{while (t->tag == TTARRAY) t = t->val;
	return (t);
	}

/**********************************************************************

	MPRINT - Macro Printing Routine

**********************************************************************/

mprint (s,x1,x2,x3,x4,x5,x6,x7)	char *s;

	{int	*p;	/* argument pointer */
	int	c;	/* current character */
	extern int f_mac;

	p = &x1;
	while (c = *s++)
		{if (c == '*') mprd (*p++);
		else cputc (c, f_mac);
		}
	}

/**********************************************************************

	MPRD - Print Decimal Integer

**********************************************************************/

mprd (i)

	{extern int f_mac;
	int b[30], *p, a;

	if (i < 0)
		{i = -i;
		if (i < 0)
			{mprint (SMALLEST);
			return;
			}
		cputc ('-', f_mac);
		}

	p = b;
	while (a = i/10)
		{*p++ = i%10 + '0';
		i = a;
		}

	cputc (i + '0', f_mac);
	while (p > b) cputc (*--p, f_mac);
	}

/**********************************************************************

	ALIGN - align integer according to alignment class

**********************************************************************/

int align (i, ac)

	{int r, a;
	extern int calign[];

	a = calign[ac];
	if (r = (i % a)) return (i + (a - r));
	return (i);
	}

/**********************************************************************

	TYPES

	Representation:

	A type is represented by a pointer to a descriptor,
	stored in TYPTAB.  There are a fixed number
	of classes of types, distinguished by a tag value.
	The descriptor also contains the size and the alignment
	class of objects of the type.  The format of the remainder
	of the descriptor is dependent upon the tag:

		fields: the size in bits
		pointers: the pointed-to type
		functions: the returned type
		arrays: the element type, the number of elements
		structs: a pointer to a sequence of field definitions,
		   terminated by an UNDEF name
		dummy structs: the name of the structure type
		others: nothing

	Types not involving structures are uniquely represented.
	The notion of equality of types is complex where recursive
	structure definitions are involved; luckily, the concept
	is unnecessary in C.  The structure field lists are
	allocated from the end of TYPTAB.

	Operations:

	typinit ()			initialize type data base
	typcinit ()			initialize type constants
	mkptr (T) => T			make pointer type
	mkfunc (T) => T			make function type
	mkarray (T, N) => T		make array type
	mkcfield (N) => T		make char field type
	mkifield (N) => T		make int field type
	typrint (T, f)			print description of type

	In c22:

	mkstruct (n, F[n]) => T		make structure type
	mkdummy (name) => T		make dummy structure type
	fixdummy (T, n, F[n])		complete structure definition
	wtyptab (f)			write type table
	tp2o (T) => I			cvt type to integer offset

	In c34:

	rtyptab (f)			read type table
	to2p (I) => T			cvt offset to type pointer

	Internal Operations:

	mktype (tag, V[]) => T		make type from tag and
					extra values
	typequal (tag, V[], T) => B	compare type descriptors
	typscan (T) => T		return "next" type descriptor
	typadd (tag, V[]) => T		add non-struct type to table
	typxh (w) => T			append word to type table
	recxl (w) => *I			append word to field list
	fixtype (T) => T		compute size and alignment
	fixbtype (T, tag)		compute for basic type
	fixstr (T)			compute for structure type
	prstruct (T, f)			print structure type

**********************************************************************/

extern int tsize[], talign[];

/**********************************************************************

	Format tables:

	NVAL - number of extra descriptor values for each tag
	FORM - format number describing format of extra values:
		0 - no extra values
		1 - integer
		2 - type
		3 - type, integer
		4 - fieldlist

**********************************************************************/

int typnval[] {0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 2, 1, 1};
int typform[] {0, 0, 0, 0, 0, 0, 0, 1, 1, 2, 2, 3, 4, 1};

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

/**********************************************************************

	OPERATIONS

**********************************************************************/

type mkptr();
type mkfunc();
type mkarray();
type mktype();
type typscan();
type typadd();
type typxh();
type fixtype();

typinit ()

	{ctypp = typtab;
	crecp = etypp = typtab+TTSIZE;
	typcinit ();
	}

typcinit ()

	{TCHAR = mktype (TTCHAR);
	TINT = mktype (TTINT);
	TFLOAT = mktype (TTFLOAT);
	TDOUBLE = mktype (TTDOUBLE);
	TLONG = mktype (TTLONG);
	TUNSIGNED = mktype (TTUNSIGNED);
	TUNDEF = mktype (TTUNDEF);
	TPCHAR = mkptr (TCHAR);
	TACHAR = mkarray (TCHAR, 1);
	TFINT = mkfunc (TINT);
	}

type mkptr (t) type t;
	{return (mktype (TTPTR, &t));}

type mkfunc (t) type t;

	{switch (t->tag) {
	case TTCHAR:	t = TINT; break;
	case TTFLOAT:	t = TDOUBLE; break;
	case TTFUNC:
	case TTARRAY:
	case TTSTRUCT:
	case TTDUMMY:	errcidn (1004);
			t = mkptr (t);
			break;
		}
	return (mktype (TTFUNC, &t));
	}

type mkarray (t, n) type t;
	{return (mktype (TTARRAY, &t));}

type mkcfield (n)
	{return (mktype (TTCFIELD, &n));}

type mkifield (n)
	{return (mktype (TTIFIELD, &n));}

type mktype (tag, v)
	int v[];

	{register typedesc *p;	/* pointer to current type in table */

	p = typtab;
	while (p < ctypp)
		{if (typequal (tag, v, p)) return (p);
		p = typscan (p);
		}
	return (typadd (tag, v));
	}

int typequal (tag, v, p)
	int tag, v[];
	typedesc *p;

	{register int *pv;

	if (tag != p->tag) return (FALSE);
	pv = &(p->val);
	switch (typnval[tag]) {
		case 2:		if (v[1] != pv[1]) return (FALSE);
		case 1:		if (v[0] != pv[0]) return (FALSE);
		default:	return (TRUE);
		}
	}

typedesc *typscan (p)
	typedesc *p;

	{return (&(p->val) + typnval[p->tag]);}

type typadd (tag, v)
	int v[];

	{register type t;	/* the new type created */
	register int n;		/* number of extra values */

	t = typxh (tag);
	typxh (-1);		/* size not known yet */
	typxh (0);		/* "default" alignment class */
	n = typnval[tag];
	while (--n>=0) typxh (*v++);
	if (tag == TTFUNC) t->size = 0;	/* avoid spurious errmsg */
	t = fixtype (t);
	if (tag == TTFUNC) t->size = -1;
	return (t);
	}

typedesc *typxh (w)
	int w;

	{if (ctypp < crecp)
		{*ctypp = w;
		return (ctypp++);
		}
	errx (4006);
	}

int *recxl (w)
	int w;

	{if (crecp > ctypp)
		{*--crecp = w;
		return (crecp);
		}
	errx (4006);
	}

type fixtype (t) type t;

	{register int tag;
	register type et;
	
	if (t->size < 0) switch (tag = t->tag) {

case TTCFIELD:	fixbtype (t, TTCHAR);
		break;

case TTLONG:
case TTUNSIGNED:
case TTIFIELD:
case TTPTR:	fixbtype (t, TTINT);
		break;

case TTCHAR:
case TTINT:
case TTFLOAT:
case TTDOUBLE:	fixbtype (t, tag);
		break;

case TTUNDEF:	t->size = 0;
		t->align = 0;
		break;

case TTFUNC:	errcidn (1005);
		return (mkptr (t));

case TTARRAY:	t->val = et = fixtype (t->val);
		t->size = t->nelem*et->size;
		t->align = et->align;
		break;

case TTDUMMY:	errx (2040, TIDN, t->val);
		return (mkptr (t));

case TTSTRUCT:	if (t->size == -2)
			{errcidn (2019);
			return (mkptr (t));
			}
		fixstr (t);	
		break;

default:	errx (6014);
		}
	return (t);
	}

fixbtype (t, tag)
	type t;

	{t->size = tsize[tag];
	t->align = talign[tag];
	}

# ifndef SCRIMP

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

pridn (i, f) {;}

# endif

