# include "cc.h"
# include "c2.h"

/*

	C COMPILER
	Phase P: Parser
	Section 3: Declaration and Function Processing

	Copyright (c) 1977 by Alan Snyder

*/

/**********************************************************************

	ROUTINE DECLARATIONS

**********************************************************************/

dentry	*astridn(), *alidn(), *aeidn(), *afidn(), *afdcl();
dentry	*dmerge();
int	*adeclr();
type	maktyp();
type	astruct();
type	aostruct();
type	afield();
type	atidn();
type	mkstruct();
type	mkdummy();

/**********************************************************************

	EXTERNAL VARIABLES

**********************************************************************/

extern int	*pv, f_node, f_mac, f_symtab, lc_node, nodeno,
		ciln, sflag;

/**********************************************************************

	DECLARATION PROCESSING VARIABLES

**********************************************************************/

int	cblock 0,	/* current block, 0 = external */
	nblock 0,	/* number of blocks */
	class UNDEF,	/* current storage class */
	tclass,		/* storage class after defaults */
	mtype,		/* current type modifier */
	cidn,		/* current identifier */
	cdim,		/* current number of dimensions */
	dims[MAXDIMS],	/* current dimensions */
	*dimp,		/* pointer to current entry in dims */
	strlev 0,	/* structure definition level */
	in_type_def 0,	/* flag indicates processing of type-
			   declarations (parameter declarations and
			   structure member definitions) */
	*parml,		/* pointer to list of parameter names */
	nstatic 0,	/* static variable counter */
	autoloc,	/* location counter for auto variables */
	framesize,	/* maximum allocated size of stack frame */
	flineno,	/* line number for function definition */
	fnarg,		/* number of arguments to current function */
	objmode UNDEF;	/* object mode (pure, impure, data, pdata) */

type	btype;		/* basic type of declaration statement */
type	TUNSPEC UNDEF;	/* unspecified type */

dentry	**fparms;	/* list of parm definitions on stack */

	/* Initialization Processing */

int	initc,		/* counter of initializers */
	allow[6],	/* allowable initialization classes */
	ipc,		/* pointer class for variable being initialized */
	initflag;	/* initialization flag */
type	ivtype;		/* type of variable being initialized */
type	ietype;		/* element type of variable being initialized */
dentry	*idp;		/* dictionary pointer of variable */

/*	DICTIONARY	*/

dentry	dict [stsize],

	*dbegin {dict},	/* first entry */
	*dgdp {dict},	/* entry following global defs */
	*dldp,		/* first entry in local defs */
	*dend;		/* following last entry */

/**********************************************************************

	DINIT - Initialize Declaration Processing Variables

**********************************************************************/

dinit ()

	{dldp = dend = dict+stsize;
	typinit ();
	}

/**********************************************************************

	AFDCL - process function declaration

	Begin processing of function defintion.  This routine is
	called immediately after the function declaration (the type
	specification for the function and the list of parameter
	names) has been recognized.

	Define the function name in the global definition dictionary.
	Enter preliminary definitions for the parameters in the
	local definition dictionary.

	Parameters:
		FLAG - 1 ==> type explicitly specified

	External variables used:
		BTYPE - the basic type of the function
		MTYPE - the type modifier of the function
		CIDN - the function name
		PARML - points to a list of identifiers (the formal
			parameters) on the stack.  PARML is 0 if
			there are no formal parameters

	Replace the list of identifiers on the stack with a list of
	pointers to the dictionary definitions of the formal
	parameters.  Set FPARMS to point to that list.  Return the
	dictionary pointer of the function.

**********************************************************************/

dentry *afdcl (flag)

	{int *sp, idn, *ot;
	type t;
	dentry *fdp;

	flineno = lineno;
	if (!flag)
		{class = c_extdef;
		btype = TINT;
		}
	t = maktyp ();
	if (class != c_extdef) errcidn (1019);
	if (!parml) parml = top ()+1;	/* null parameter list */

	/* define function name in global dictionary */

	fdp = define (0, cidn, c_extdef, t, cidn);
	cblock = ++nblock;
	framesize = autoloc = sv_area_sz;
	if (sflag) puti (cidn, f_symtab);

	/* define parameters in local dictionary */

	fparms = sp = parml;
	fnarg = 0;
	ot = top ();
	while (sp <= ot)
		{idn = *sp;
		*sp++ = define (cblock, idn, c_param, TUNSPEC, UNDEF);
		++fnarg;
		}

	return (fdp);
	}

/**********************************************************************

	AFPDCL - Process Function Parameter Declarations

	This routine is called after the declarations of formal
	parameters have been processed.  The list of formal
	parameter definitions (accessed via FPARMS) is removed
	from the stack.  Offsets are computed for the parameters.

**********************************************************************/

afpdcl ()

	{dentry *dp, **pp, **ot;
	int ploc;
	type t;

	pp = fparms;
	ot = get_top (pp);
	ploc = 0;
	while (pp <= ot)
		{dp = *pp++;
		if (dp->dtype == TUNSPEC) dp->dtype = TINT;
		t = dp->dtype;
		ploc = align (ploc, t->align);
		dp->offset = ploc;
		ploc =+ t->size;
		}
	}

/**********************************************************************

	AFDEF - Terminate Processing of Function Definition

	This routine is called after the end of the function
	definition has been reached.  FDP is a pointer to the
	dictionary definition of the function.  N is the node
	offset of the function body.

**********************************************************************/

afdef (fdp, n)	dentry *fdp; int n;

	{node (n_prog, fdp->name, tp2o (fdp->dtype), n, framesize, fnarg);
	chkdict (dldp, dend);
	if (sflag)
		{wdict (dldp, dend);	/* write parameter defs */
		puti (UNDEF, f_symtab);
		}
	dldp = dend;			/* delete parameter defs */
	cblock = 0;
	}

/**********************************************************************

	ATTRIB - process decl-specifiers

	Check for valid CLASS and determine default CLASS or TYPE if
	possible.

**********************************************************************/

attrib (pclass, pbtype)	int pclass, pbtype;

	/*	check CLASS	*/

	{if (strlev>0) class = c_mos;
	else if (in_type_def) class = c_param;
	else if (cblock==0) switch (pclass) {	/* global declaration */
		case UNDEF:	class = c_extdef;	/* default */
				break;
		case c_typedef:
		case c_extern:
		case c_static:	class = pclass;
				break;
		case c_auto:	errx (1018);
				class = c_extdef;
				break;
		default:	errx (6009);
			}
	else class = pclass;

	/*	check TYPE	*/

	if (pbtype == UNDEF) btype = TINT;	/* default */
	else btype = pbtype;
	}

/**********************************************************************

	ASTRUCT - Define a Structure Type

	DP is the dictionary pointer of the type name, or NULL if
		the structure type is unnamed.
	FP is a pointer to a list of field definitions.
	Return the appropriate structure type.

**********************************************************************/

type astruct (dp, fp)	dentry *dp; field *fp;

	{int nfields;
	field *efp;

	--strlev;
	efp = (get_top (fp) + 1);	/* get definition list */
	nfields = efp - fp;		/* number of members */
	if (dp != NULL)			/* named structure type */
		{fixdummy (dp->dtype, nfields, fp);
		return (dp->dtype);
		}
	return (mkstruct (nfields, fp));
	}

/**********************************************************************

	AOSTRUCT - Return type given structure type name.

**********************************************************************/

type aostruct (name)

	{dentry *dp;
	type t;

	--strlev;
	dp = find (name + cssiz);
	if (dp) return (dp->dtype);
	t = mkdummy (name);
	define (cblock, name + cssiz, c_ustruct, t, 0);
	return (t);
	}

/**********************************************************************

	ASTRIDN - Define Structure Type Name

	Create a dictionary definition for a named structure type
	about to be defined.

**********************************************************************/

dentry *astridn (name)

	{dentry *dp;

	dp = find (name+cssiz);
	if (dp)
		{if (dp->class == c_ustruct)
			{dp->class = c_struct;
			return (dp);
			}
		errx (2018, TIDN, name);
		return (NULL);
		}
	return (define (cblock, name+cssiz, c_struct, mkdummy (name), 0));
	}

/**********************************************************************

	ADECLR - process declarator

	Process the declarator using the following external variables:

		CLASS - the storage class (may be UNDEF)
		CIDN  - the identifier number
		STRLEV - indicates whether member of structure

	Check for illegally specified CLASS, and determine the default
	CLASS if necessary.  If we are defining a structure field,
	then push a field definition on the stack and return a pointer
	to it.  Otherwise, enter the definition of the declarator in
	the dictionary.
	Assign a static variable number to static variables.
	Set IDP to point to the dictionary entry of the variable, for
	use by the initialization routines.  Set INITC to UNDEF so that
	variables without initialization can be recognized by AIDECLR.

**********************************************************************/

int *adeclr (t)
	type t;

	{int *ip, o;
	dentry *dp;

	if (strlev)
		{ip = push (cidn);
		push (t);
		push (UNDEF);
		return (ip);
		}
	dp = NULL;
	if (class == UNDEF)
		tclass = ((t->tag==TTFUNC) ? c_extern : c_auto);
		else tclass = class;
	if (t->tag==TTFUNC && tclass!=c_param && tclass!=c_typedef)
		{if (tclass != c_extern && tclass != c_extdef)
			errcidn (1021);
		tclass = c_extern;
		}
	if (tclass==c_param)
		{if (!(dp = find (cidn)))	/* not a parameter */
			{errcidn (1027);
			tclass = c_auto;
			}
		else if (dp->class==c_param)	/* parameter entry located */
			{if (t == TCHAR) t = TINT;
			else if (t == TFLOAT) t = TDOUBLE;
			else if (t->tag==TTARRAY)
				t = mkptr (t->val);
			else if (t->tag==TTFUNC || t->tag==TTSTRUCT)
				{errcidn (2036);
				t = mkptr (t);
				}
			if (dp->dtype != TUNSPEC) errcidn (2016);
			else dp->dtype = t;
			}
		}
	switch (tclass) {
	case c_static:	o = ++nstatic; break;
	case c_extdef:
	case c_extern:	o = cidn; break;
	case c_auto:	tclass = c_uauto;
			o = autoloc = align (autoloc, t->align);
			autoloc =+ t->size;
			break;
	default:	o = UNDEF;
		}
	if (!dp) dp = define (cblock, cidn, tclass, t, o);
	idp = dp;		/* for processing initializers */
	ivtype = idp->dtype;
	initc = UNDEF;
	return (0);
	}

/**********************************************************************

	ADCLR - construct declarator

	MTYP is the current type modifier, NEWTYP is the new type
	modifier, DIM is the array dimension, ARRAYFLAG indicates that
	all type modifiers so far have been "array of".  The current
	type modifier is stored in external variable MTYPE.

**********************************************************************/

int adclr (mtyp, newtyp, dim) int mtyp, newtyp, dim;

	{if (mtyp==0 && newtyp==0)		/* new declarator */
		{cidn = pv[1];
		cdim = 0;
		dimp = dims;
		return (mtype = newtyp);
		}
	if (mtyp == UNDEF) return (UNDEF);	/* previous error */
	mtyp = mtyp << 2 | newtyp;
	if (newtyp==MARRAY)
		{if (cdim>=MAXDIMS)
			{errcidn (2015);
			return (mtype = UNDEF);
			}
		if (dim<=0)
			{errcidn (1031);
			dim=1;
			}
		*dimp++ = dim;
		++cdim;
		}

	return (mtype = mtyp);
	}

/**********************************************************************

	MAKTYP - check for invalid types and correct

	Combine type modifier MTYPE and basic type BTYPE.

**********************************************************************/

type maktyp ()

	{register int i;
	type t;

	if (mtype == UNDEF) return (TUNDEF);	/* previous error */
	if (mtype<<1<0 || mtype<<2<0)
		{errcidn (2014);
		return (TUNDEF);
		}
	t = btype;
	while (i = (mtype&03))
		{switch (i) {
		case MPTR:	t = mkptr (t); break;
		case MFUNC:	t = mkfunc (t); break;
		case MARRAY:	t = mkarray (t, *--dimp); break;
			}
		mtype =>> 2;
		}
	return (t);
	}

/**********************************************************************

	AFIELD - Construct declarator for bit field definition.
	(Currently implemented as INT.)  This routine performs
	the functions of ADCLR and MAKTYP.

**********************************************************************/

type afield (idn, width)

	{cidn = idn;
	cdim = 0;
	if (!strlev) errcidn (1032);
	if (width<0) errcidn (1033);
	switch (btype->tag) {
		case TTCHAR:	/* return (mkcfield (width)); */
				break;
		case TTINT:	/* return (mkifield (width)); */
				break;
		default:	errcidn (1034);
		}
	return (TINT);
	}

/**********************************************************************

	AIINZ - Initialize for the processing of initializers.

	Determine what types of initializers are valid for this
	variable and set the array ALLOW accordingly.  Also determine
	whether or not initialization of this variable is allowed at
	all.  Output symbol defining macros.

	This routine is called after ADECLR is called for the
	variable and immediately before the first initializer is
	processed.

**********************************************************************/

aiinz ()

	{int i;

	initflag = FALSE;
	for (i=0;i<6;i++) allow[i]=FALSE;
	ietype = remarr (ivtype);		/* remove arrays */

	/* determine valid initializer types */

	switch (ietype->tag) {
	case TTCHAR:
	case TTINT:	allow[i_int] = TRUE; break;
	case TTFLOAT:
	case TTDOUBLE:	allow[i_float] = TRUE;
			allow[i_negfloat] = TRUE;
			break;
	case TTSTRUCT:	allow[i_string] = TRUE;
			allow[i_int] = TRUE;
			allow[i_idn] = TRUE;
			ipc = tpoint[TTINT];
			break;
	case TTPTR:	allow[i_int] = TRUE;
			allow[i_idn] = TRUE;
			ipc = ctype (ietype) - ct_p0;
			if (ietype==TPCHAR) allow[i_string] = TRUE;
			}

	/* check CLASS */

	switch (tclass) {
		case c_extdef:	data;
				malign (ivtype->align);
				mequ (cidn);
				break;
		case c_static:	data;
				malign (ivtype->align);
				mstatic (idp->offset);
				break;
		case c_uauto:
		case c_auto:	errcidn (1024);
				initflag = TRUE;
				break;
		default:	errcidn (1026);
				initflag = TRUE;
				}
	initc = 0;
	}

/**********************************************************************

	INZ - process initializer

	Process initializer and increment INITC.  Determine whether
	the initializer is of a valid type.
	Output the initializer onto the MAC file.  INITFLAG is used
	to prohibit certain multiple error messages.

**********************************************************************/

inz (i_type, index) int i_type, index;

	{dentry *dp;
	int cls;

	if (initflag) return;	/* previous error */
	if (!allow[i_type])
		{errcidn (1022);
		return;
		}
	++initc;
	switch (i_type) {

case i_int:	if (ietype==TCHAR) mchar (index);
		else mint (index);
		return;

case i_idn:	dp = afidn (index);
		switch (cls = dp->class) {
		case c_extern:	cls = c_extdef;
		case c_extdef:
		case c_static:	madcon (ipc, -cls, dp->offset);
				break;
		default:	mint (0);
				errx (2038, TIDN, index);
			}
		return;

case i_string:	mstrcon (index);
		return;

case i_float:	if (ietype==TFLOAT) mfloat (index);
		else mdouble (index);
		return;

case i_negfloat:
		if (ietype==TFLOAT) mnfloat (index);
		else mndouble (index);
		return;
		}
	errx (6041);
	}

/**********************************************************************

	AIDECL - Finish processing for a variable which may
	have been initialized.  If it was initialized, determine
	the actual size of the variable and output any zero space
	needed.  If it was not initialized and was an external
	definition or a static variable, allocate storage for it.
	Check for multiple initializers to a non-structured variable.

**********************************************************************/

aidecl ()

	{int esize, isize, dsize, dcount, i, nelem, aesize;
	type etype;

	dsize = ivtype->size;
	if (initc == UNDEF)	/* not initialized */
		{if (tclass == c_extdef)
			{impure;
			malign (ivtype->align);
			mequ (cidn);
			mzero (dsize);
			}
		if (tclass==c_static)
			{impure;
			malign (ivtype->align);
			mstatic (idp->offset);
			mzero (dsize);
			}
		}
	else
		{if (ietype->tag==TTSTRUCT)		/* finish structure hack */
			{esize = ietype->size;		/* structure size */
			isize = initc * tsize[TTINT];	/* initialzed size */
			if (i = isize % esize)
				{i = esize - i;
				mzero (i);		/* fill out structure */
				isize =+ i;
				}
			initc = isize / esize;	/* number of structure values */
			}
		if (ivtype->tag == TTARRAY)
			/* initializers may increase size of array */
			{esize = ietype->size;
			dcount = nelem = dsize/esize;
			if (initc > nelem)
				{nelem = initc;
				etype = ivtype->val;
				aesize = etype->size;
				ivtype = idp->dtype = mkarray (etype,
					(nelem*esize+(aesize-1))/aesize);
				dcount = ivtype->size/esize;
				}
			}
		else 
			{if (initc>1) errcidn (1023);
			esize = dsize;
			dcount = 1;
			}
		if (initc < dcount) mzero (esize*(dcount-initc));
		}
	}

/**********************************************************************

	BLOCK STRUCTURE ROUTINES

**********************************************************************/

abegin ()

	{push (dldp);
	push (autoloc);
	}

aend ()

	{int n;
	dentry *dp, *odp;

	if (autoloc > framesize) framesize = autoloc;
	n = pop ();
	if (n >= sv_area_sz && n <= autoloc) autoloc = n;
	dp = pop ();
	if (dp >= dldp && dp <= dend)
		{odp = dldp;
		dldp = dp;
		chkdict (odp, dldp);	/* obscure ILHACK interaction */
		if (sflag) wdict (odp, dldp);
		}
	}

/**********************************************************************

	IDENTIFIER LOOKUP ROUTINES

**********************************************************************/

dentry *aeidn (name)

	{dentry *dp;

	dp = define (cblock, name, UNDEF, TUNDEF, UNDEF);
	if (dp->class == UNDEF)
		{errx (2027, TIDN, name);
		dp->class = c_auto;
		}
	else if (dp->class == c_uauto) dp->class = c_auto;
	return (dp);
	}

dentry *afidn (name)

	{dentry *dp;

	dp = define (0, name, UNDEF, TUNSPEC, name);
	if (dp->class == UNDEF)
		{dp->class = c_extern;
		dp->dtype = TFINT;
		}
	else if (dp->class == c_uauto) dp->class = c_auto;
	return (dp);
	}

dentry *alidn (name)

	{dentry *dp;

	dp = define (cblock, name, c_ulabel, TINT, UNDEF);
	if (dp->offset == UNDEF) dp->offset = ciln++;
	return (dp);
	}

type atidn (name)

	{dentry *dp;

	dp = find (name);
	if (!dp || dp->class != c_typedef)
		{errx (2041, TIDN, name);
		return (TUNDEF);
		}
	return (dp->dtype);
	}

/**********************************************************************

	MACRO OUTPUT ROUTINES

**********************************************************************/

mhead()		{mprint ("%hd()\n");}
mentry(n)	{mprint ("%en(%i(*))\n", n);}
extrn(n)	{mprint ("%ex(%i(*))\n", n);}
mstatic (n)	{mprint ("%st(*)\n", n);}
mequ (n)	{mprint ("%eq(%i(*))\n", n);}
mzero (i)	{mprint ("%z(*)\n", i);}
malign (ac)	{if (ac>0) mprint ("%al*()\n", ac);}
mint (i)	{mprint ("%in(*)\n", i);}
mstrcon (i)	{mprint ("%sc(*)\n", i);}
madcon (n,b,o)	{mprint ("%ad*(0,*,*)\n", n, b, o);}
mchar (i)	{mprint ("%c(*)\n", i);}
mfloat (i)	{mprint ("%f(*)\n", i);}
mnfloat (i)	{mprint ("%nf(*)\n", i);}
mdouble (i)	{mprint ("%d(*)\n", i);}
mndouble (i)	{mprint ("%nd(*)\n", i);}
mimpure ()	{mprint ("%im()\n"); objmode=o_impure;}
mpure ()	{mprint ("%pu()\n"); objmode=o_pure;}
mdata ()	{mprint ("%da()\n"); objmode=o_data;}

/**********************************************************************

	SDEF - Define external references and global names

**********************************************************************/

sdef ()

	{dentry *dp;
	extern char *fn_hmac;

	cclose (f_mac);
	f_mac = xopen (fn_hmac, MWRITE, TEXT);
	mhead ();

/*	DEFINE ENTRY POINTS	*/

	pure;
	for (dp=dbegin; dp<dgdp; ++dp)
		if (dp->class==c_extdef) mentry (dp->name);

/*	DEFINE EXTERNAL REFERENCES	*/

	for (dp=dbegin; dp<dgdp; ++dp)
		if (dp->class==c_extern) extrn (dp->name);

	cclose (f_mac);
	}

/**********************************************************************

		SYMBOL TABLE FORMAT

	The symbol table consists of two parts: a dictionary (DICT)
	and a type table (TYPTAB).

	The dictionary is an array of dictionary entries (DENTRY).
	The fields of a DENTRY are:

		name - index of identifier
		class - storge class
		dtype - data type
		offset - basis for addressing the item:
			parameters: offset in parameter list
			automatic: offset in stack frame
			static: static variable number
			external: 0
			labels: corresponding internal label number

**********************************************************************/

/**********************************************************************

	DEFINE - Create or modify a dictionary entry.

**********************************************************************/

dentry *define (block, name, xclass, dtype, offset)
	type dtype;

	{dentry *dp;

	if (dp = find (name))	/* if old entry exists */
		return (dmerge (dp, xclass, dtype, offset));
	if (block==0 || xclass==c_extern)
		dp = dgdp++;
	else dp = --dldp;
	if (dldp < dgdp) errx (4005);
	dp->name = name;		/* copy entry */
	dp->class = xclass;
	dp->dtype = dtype;
	dp->offset = offset;
	return (dp);
	}

/**********************************************************************

	DMERGE - Merge new definition with old one.

**********************************************************************/

dentry *dmerge (dp, xclass, dtype, offset)
	dentry *dp;
	type dtype;

	{type t;
	int c;

	if (xclass == UNDEF) return (dp);
	c = dp->class;
	t = dp->dtype;
	if (xclass==c_extdef && c==c_extern ||
	    xclass==c_label  && c==c_ulabel)
		{c = xclass;
		xclass = dp->class;
		dp->class = c;
		t = dtype;
		dtype = dp->dtype;
		dp->dtype = t;
		}
	if (xclass==c_extern && (c==c_extdef || c==c_extern) ||
	    xclass==c_ulabel && (c==c_label || c==c_ulabel))
		{if (dtype == TUNSPEC) return (dp);
		if (t == dtype) return (dp);
		if (t->tag == TTARRAY && dtype->tag == TTARRAY &&
		    t->val == dtype->val) return (dp);
		}
	errx (2016, TIDN, dp->name);
	return (dp);
	}

/**********************************************************************

	FIND - Find the dictionary entry for a identifier

**********************************************************************/

dentry *find (name)

	{dentry *p;

	p = dldp;
	while (p<dend) if (p->name == name) return (p); else ++p;
	p = dgdp;
	while (--p >= dbegin) if (p->name == name) return (p);
	return (NULL);
	}

/**********************************************************************

	CHKDICT - Check dictionary bounded by P1 and P2 for undefined
		things.

**********************************************************************/

chkdict (p1, p2) dentry *p1, *p2;

	{type t;
	int ilhack;

	ilhack = (p2 == dldp && p1 != dbegin);
	while (--p2 >= p1)
		{t = p2->dtype;
		if (t->tag == TTDUMMY)
			{errx (2024, TIDN, t->val);
			t = p2->dtype = TUNDEF;
			}
		if (p2->class == c_ulabel)
			{if (ilhack) dswap (p2, --dldp);
			else
				{errx (2017, TIDN, p2->name);
				p2->class = c_label;
				}
			}
		else if (p2->class == c_uauto)
			{error (1006, flineno, TIDN, p2->name);
			p2->class = c_auto;
			}
		}
	}

dswap (p1, p2) dentry *p1, *p2;

	{if (p1 != p2)
		{swap (&p1->name, &p2->name);
		swap (&p1->class, &p2->class);
		swap (&p1->dtype, &p2->dtype);
		swap (&p1->offset, &p2->offset);
		}
	}

swap (p1, p2) int *p1, *p2;

	{int t;
	t = *p1;
	*p1 = *p2;
	*p2 = t;
	}

/**********************************************************************

	WSYMTAB - Write Global Symbol Table

**********************************************************************/

wsymtab ()

	{puti (UNDEF, f_symtab);
	wdict (dbegin, dgdp);
	puti (UNDEF, f_symtab);
	}

/**********************************************************************

	WDICT - Write dictionary bounded by P1 and P2.

**********************************************************************/

wdict (p1, p2)	dentry *p1, *p2;

	{while (p1 < p2)
		{puti (p1->name, f_symtab);
		puti (tp2o (p1->dtype), f_symtab);
		puti (p1->offset, f_symtab);
		puti (p1->class, f_symtab);
		++p1;
		}
	}

dp2o (p) dentry *p;

	{if (p==NULL) return (UNDEF);
	if (p<dbegin || p>=dend) errx (6035);
	if (p >= dgdp) return (010000 + (dend - p));
	return (p-dbegin);
	}

/**********************************************************************

	WTYPTAB - Write Type Table

**********************************************************************/

wtyptab ()

	{extern int typtab[], *ctypp, *crecp, *etypp, typform[];
	extern char *fn_typtab;
	register int *p, fmt;
	register field *fp;
	int f;

	f = xopen (fn_typtab, MWRITE, BINARY);
	puti (ctypp-typtab, f);
	p = typtab;
	while (p < ctypp)
		{fmt = typform[p[0]];
		puti (*p++, f);
		puti (*p++, f);
		puti (*p++, f);
		switch (fmt) {
			case 1:	puti (*p++, f); break;
			case 2:	puti (tp2o (*p++), f); break;
			case 3:	puti (tp2o (*p++), f);
				puti (*p++, f);
				break;
			case 4:	puti (rp2o (*p++), f); break;
			}
		}
	puti (etypp-crecp, f);
	p = crecp;
	while (p < etypp)
		{fp = p;
		puti (fp->name, f);
		if (fp->name == UNDEF) ++p;
		else
			{puti (tp2o (fp->dtype), f);
			puti (fp->offset, f);
			p = fp+1;
			}
		}
	cclose (f);
	}		

int tp2o (t) type t;

	{extern int typtab[], *ctypp;
	int *tt;

	tt = t;
	if (tt < typtab || tt >= ctypp) errx (6005);
	return (tt - typtab);
	}

int rp2o (p) int *p;

	{extern int *crecp, *etypp;

	if (p < crecp || p >= etypp) errx (6037);
	return (etypp - p);
	}

/**********************************************************************

	Type Operations Used Only In Phase P

**********************************************************************/

type mkstruct (n, v)
	int n;
	field v[];

	{type t;
	t = mkdummy (0);
	fixdummy (t, n, v);
	return (t);
	}

type mkdummy (name)

	{type t;
	t = typxh (TTDUMMY);
	typxh (UNDEF);
	typxh (1);
	typxh (name);
	return (t);
	}

fixdummy (t, n, fp)
	type t;
	int n;
	field *fp;

	{field *p;

	recxl (UNDEF);		/* UNDEF name marks end of list */
	fp =+ n;
	while (--n >= 0)
		{--fp;
		recxl (fp->offset);
		recxl (fp->dtype);
		p = recxl (fp->name);
		}
	t->tag = TTSTRUCT;
	t->val = p;
	fixstr (t);
	}

fixstr (t)	type t;

	{int salign, offset;
	register field *fp;
	register type ft;
	
	t->size = -2;			/* to catch recursive definition */
	fp = t->val;			/* field list */
	salign = 0;
	while (fp->name != UNDEF)	/* determine alignment */
		{fp->dtype = ft = fixtype (fp->dtype);
		if (ft->align > salign) salign = ft->align;
		++fp;
		}
	t->align = salign;
	fp = t->val;
	offset = 0;
	while (fp->name != UNDEF)	/* determine offsets */
		{ft = fp->dtype;
		offset = align (offset, ft->align);
		fp->offset = offset;
		offset =+ ft->size;
		++fp;
		}
	t->size = align (offset, t->align);
	}

/**********************************************************************

	ERRCIDN - announce error for current identifier

**********************************************************************/

errcidn (errno) {errx (errno, TIDN, cidn);}
