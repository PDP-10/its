# include "gt.h"

/*

	GT Compiler
	Section 3: Action Routines

*/

/* The maximum number of registers is really limited by the number
   of bits in a word on the machine running this program and
   on the machine running the C compiler since the set of all
   registers is represented by the bits in a single word.
   Also, the maximum number of indirect classes is even further
   limited because the set of all memory reference classes, which
   includes indirection via registers, is also represented by the
   bits in a single word. */

# define maxregs 16		/* maximum number of registers */
# define maxtypes 8		/* maximum number of data types */
# define maxmem 16		/* maximum number of memory refs */
# define maxnmacs 100		/* maximum number of named macros */
# define retregsz 18		/* 2 + maxtypes*2 */
# define namop 0300		/* number of abstract machine operators */
# define mdfsz 2000		/* size of macro definition list table */

# define find_reg fndrg
# define find_pc fndpc
# define find_type fndty

extern char cstore[], *cscsp;
extern int lineno, f_out, *get_top();

int	ntype 0,		/* number of data types */
	typname[maxtypes],	/* names of data types */
	nmem 0,			/* current number of memory refs */
	memname[maxmem],	/* names of memory refs */
	nreg 0,			/* current number of registers */
	regname[maxregs],	/* index to name of register */
	rcname[maxregs],	/* index to name of register classes */
	rcp[maxregs],		/* descriptions of register classes */
	nrc 0,			/* number of register classes */
	pcname[maxtypes],	/* index to name of pointer classes */
	npc 0,			/* current number of pointer classes */
	pcor[maxtypes],		/* pointer class offset range function no. */
	norr 0,			/* number of offset range functions emitted */
	trdt[maxtypes],		/* registers holding a given type */
	prdt[maxtypes],		/* registers holding a given pointer */
	cfp[maxregs],		/* descriptions of conflicts */
	nac 0,			/* number of alignment classes */
	calign[maxtypes],	/* align. factors of align. classes */
	tsize[maxtypes],	/* sizes of each type */
	talign[maxtypes],	/* align. classes of each type */
	tpoint[maxtypes],	/* pointer classes of each type */
	pc_align[maxtypes],	/* resolution of pointer class in characters */
	retreg[retregsz],	/* the registers in which values
				   of a given type are returned
				   in a function call - this array is
				   indexed by the value returned by a
				   routine CTYPE in the code generator */
	cfactor 0,		/* current alignment factor */
	save_area_size -1,
	opreg[namop],		/* registers for result of op */
	opmem[namop],		/* memory refs for result of op */
	oplist[namop],		/* used to construct opreg, opmem */
	coplist 0,		/* index into oplist */
	amopp[namop],		/* indices to lists in amopl */
	c_oploc 0,		/* current index in oploc table */
	amopl[500],		/* lists of indices to oplocs */
	c_amopl 0,		/* current entry in amopl */
	copflag l_unknown,	/* current flag */
	allmem -1,		/* this name represents all mem_refs */
	mactab[namop],		/* names of macro calls */
	macdef[namop],		/* index in mdeflist to beginning of macro */
	nnmacs 0,		/* current number of named macros */
	nmacname[maxnmacs],	/* names of named macros */
	nmacdef[maxnmacs],	/* index in mdeflist to beginning of macro */
	mdeflist[mdfsz],	/* list of macro definitons, each a list of
				   integers:

					flag(operand 1)
					word(operand 1)
					flag(operand 2)
					word(operand 2)
					flag(result)
					word(result)

					...

					-1

				*/
	cmacro 1,		/* current macro number */
	cmdf 0;			/* current entry in mdeflist */

struct oploc {
	int	flag[3],	/* flag for opnd 1, opnd 2, result:
					1 - memory ref type
					2 - registers
					3 - result left in opnd 1
					4 - result left in opnd 2
				*/
		word[3],	/* word for opnd1, opnd2, result:
					bits represent memory ref
					types or register numbers
					according to the flag
				*/
		clobber;}	/* bits indicate registers which
				   are clobbered as a result of this
				   operation
				*/
	doploc;

/**********************************************************************

	PRCOM - Print Comment

**********************************************************************/

prcom (name, narray, varray, count)
	int name, narray[], varray[], count;

	{int i;

	for (i=0; i<count; ++i)
		{gprint ("/* %s %m\t", name, narray[i]);
		rd_print (varray[i]);
		gprint (" */\n");
		}
	}

/**********************************************************************

	RD_PRINT - gprint register description as bit string

**********************************************************************/

rd_print (w) int w;

	{int i;

	for (i=0;i<nreg;i++) gprint ("%c", ((w>>i) & 1) + '0');
	}

/**********************************************************************

	GENERIC TABLE ROUTINES

	TFIND - find name in table, return -1 if not there
	TENTER - find name in table, enter if not there
	TEFIND - find name in table, emit error message if not there

**********************************************************************/

int tfind (name, table, size)
	int name, *table, size;

	{int i;

	for (i=0;i<size;++i) if (table[i]==name) return (i);
	return (-1);
	}

int tenter (name, table, psize, maxsize, errno)
	int name, *table, *psize, maxsize, errno;

	{int i, size;

	size = *psize;
	if ((i = tfind (name, table, size)) >= 0) return (i);
	if (size >= maxsize) error (errno, lineno);
	table[size] = name;
	return ((*psize)++);
	}

int tefind (name, table, size, errno)
	int name, *table, size, errno;

	{int i;

	i = tfind (name, table, size);
	if (i<0) error (errno, lineno, TIDN, name);
	return (i);
	}

/**********************************************************************

	SPECIFIC TABLE ROUTINES

**********************************************************************/

int typ_find (n) {return (tfind (n, typname, ntype));}
int typ_enter (n) {return (tenter (n, typname, &ntype, maxtypes, 4019));}
int find_type (n) {return (tefind (n, typname, ntype, 2028));}

int mem_find (n) {return (tfind (n, memname, nmem));}
int mem_enter (n) {return (tenter (n, memname, &nmem, maxmem, 4020));}
int find_mem (n) {return (tefind (n, memname, nmem, 2029));}

int reg_find (n) {return (tfind (n, regname, nreg));}
int reg_enter (n) {return (tenter (n, regname, &nreg, maxregs, 4017));}
int find_reg (n) {return (tefind (n, regname, nreg, 2027));}

int rc_find (n) {return (tfind (n, rcname, nrc));}
int rc_enter (n) {return (tenter (n, rcname, &nrc, maxregs, 4018));}

int pc_find (n) {return (tfind (n, pcname, npc));}
int pc_enter (n) {return (tenter (n, pcname, &npc, maxtypes, 4016));}
int find_pc (n) {return (tefind (n, pcname, npc, 2026));}

/**********************************************************************

	GETREG - return bit set for register named N
		if undefined, emit message and return empty set

**********************************************************************/

int getreg (n)

	{int r;

	if ((r = find_reg (n)) < 0) return (0);
	return (1 << r);
	}

/**********************************************************************

	GETRC - same as GETREG but N can name register class

**********************************************************************/

int getrc (n)

	{int c;

	if ((c = rc_find (n)) >= 0) return (rcp[c]);
	return (getreg (n));
	}

/**********************************************************************

	ATNAMES - define names of data types

**********************************************************************/

atnames (sp) int *sp;

	{int *ot;

	ot = get_top (sp);
	if (ntype != 0) error (2002, lineno);
	else while (sp<=ot) typ_enter (*sp++);
	}

/**********************************************************************

	ARNAMES - define names of registers

**********************************************************************/

arnames (sp) int *sp;

	{int *ot;

	ot = get_top (sp);
	if (nreg != 0) error (2003, lineno);
	else while (sp <= ot) reg_enter (*sp++);
	}

/**********************************************************************

	AMNAMES - define names of memory references

**********************************************************************/

amnames (sp) int *sp;

	{int *ot;

	ot = get_top (sp);
	if (nmem != 0) error (2004, lineno);
	else while (sp <= ot) mem_enter (*sp++);
	}

/**********************************************************************

	FS1 - finished with TYPENAMES,REGNAMES, and MEMNAMES statements

**********************************************************************/

fs1()

	{int t;

	if (ntype == 0) error (4013,lineno);
	if (nreg == 0) error (4014,lineno);
	if (nmem == 0) error (4015,lineno);

	for (t=0; t<ntype; ++t)
		pcname[t]=calign[t]=tsize[t]=talign[t]=tpoint[t]= -1;
	for (t=0; t<namop; ++t) amopp[t] = mactab[t] = -1;
	for (t=0; t<retregsz; ++t) retreg[t] = -1;
	}

/**********************************************************************

	FS2 - finished with SIZE, ALIGN, CLASS, CONFLICT, POINTER,
		and SAVEAREASIZE statements

**********************************************************************/

fs2()

	{int t, i, a, c;

	if (npc==0) error(4021,lineno);
	for (i=0; i<ntype; ++i)
		if (tsize[i]<0)
			{error(2016,lineno,TIDN,typname[i]);
			tsize[i]=1;
			}
	for (i=0; i<ntype; ++i)
		if (talign[i]<0)
			{error(2023,lineno,TIDN,typname[i]);
			talign[i]=0;}
	prcom ("\t  class", rcname, rcp, nrc);
	prcom ("\tconflict", regname, cfp, nreg);
	for (t=0;t<ntype;++t)
		{a=calign[talign[t]];
		for(c=npc-1;c>=0;--c) if ((a%pc_align[c])==0) break;
		if (c<0) error(2022,lineno,TIDN,typname[t]);
		else tpoint[t]=c;
		}
	}

/**********************************************************************

	ASIZE - define size of basic types

	SIZE - the size in characters
	SP - a pointer to a list of the types with the given size

**********************************************************************/

asize (size, sp) int size, *sp;

	{int *ot, t;

	ot = get_top (sp);
	while (sp<=ot)
		{if ((t = find_type (*sp++)) >= 0)
			if (tsize[t] >= 0)
				error(2015,lineno,TIDN,typname[t]);
			else tsize[t]=size;
		}
	}

/**********************************************************************

	AALIGN - define alignment class

	factor - alignment factor
	sp - pointer to list of types in this alignment class

**********************************************************************/

aalign (factor, sp)	int factor, *sp;

	{int *ot, t;

	ot = get_top (sp);
	if (factor <= cfactor)
		{error (2009, lineno);
		return;
		}
	cfactor = calign[nac] = factor;
	while (sp <= ot)
		{if ((t = find_type (*sp++)) >= 0)
			if (talign[t]>=0)
				error (2020,lineno,TIDN,typname[t]);
			else talign[t] = nac;
		}
	nac++;
	}

/**********************************************************************

	APOINT - define pointer class

	name - the name of the pointer class
	resolution - the resolution in characters of a pointer
		in the pointer class

**********************************************************************/

apoint (name, resolution) int name,resolution;

	{static int current_resolution;

	if (npc==0) current_resolution=0;
	if (resolution<0 || resolution<=current_resolution)
		{error(2009,lineno);
		return;
		}
	current_resolution=pc_align[pc_enter(name)]=resolution;
	}

/**********************************************************************

	ACLASS - define register class

	idn - name of register class
	sp - pointer to list of names of members of the class

**********************************************************************/

aclass (idn ,sp) int idn, *sp;

	{int *ot, rc;

	ot = get_top (sp);
	rc = rc_enter (idn);
	while (sp <= ot) rcp[rc] =| getreg (*sp++);
	}

/**********************************************************************

	ASAVE - define save area size (in characters)

**********************************************************************/

asave (i)

	{save_area_size = i;
	}

/**********************************************************************

	AOR1 - Handle Offset_Range of Form (lo,hi)

**********************************************************************/

aor1 (idn, lo, hi)

	{int pc;

	if ((pc = find_pc (idn)) >= 0)
		{gprint ("int ofok%d (i) {return (i>=%d && i<=%d);}\n",
			++norr, lo, hi);
		pcor[pc] = norr;
		}
	}

/**********************************************************************

	AOR2 - Handle Offset_Range of Form (lo,)

**********************************************************************/

aor2 (idn, lo)

	{int pc;

	if ((pc = find_pc (idn)) >= 0)
		{gprint ("int ofok%d(i) {return (i>=%d);}\n",
			++norr, lo);
		pcor[pc] = norr;
		}
	}

/**********************************************************************

	AOR3 - Handle Offset_Range of Form (,hi)

**********************************************************************/

aor3 (idn, hi)

	{int pc;

	if ((pc = find_pc (idn)) >= 0)
		{gprint ("int ofok%d(i) {return (i<=%d);}\n",
			++norr, hi);
		pcor[pc] = norr;
		}
	}

/**********************************************************************

	AOR4 - Handle Offset_Range of Form (,)

**********************************************************************/

aor4 (idn)

	{int pc;

	if ((pc = find_pc (idn)) >= 0)
		{gprint ("int ofok%d(i) {return (1);}\n", ++norr);
		pcor[pc] = norr;
		}
	}

/**********************************************************************

	ARETREG - define the types which are returned in a given register

	REG_NAME - the name of the register
	SP	- a pointer to a list of type or pointer_class names

**********************************************************************/

aretreg (reg_name, sp) int *sp;

	{int *ot, type_name, type, pc, reg, i;

	ot = get_top (sp);

	if ((reg = find_reg (reg_name)) >= 0)
		while (sp<=ot)
			{i = 0;
			type_name = *sp++;
			if ((type=typ_find(type_name)) >= 0) i=type+2;
			else if ((pc=pc_find(type_name)) >= 0) i=pc+ntype+2;
			if (i==0) error(2028,lineno,TIDN,type_name);
			else if (retreg[i]>=0) error(2005,lineno,TIDN,type_name);
			else retreg[i]=reg;
			}
	}

/**********************************************************************

	ATYPE - define register types

	type - C type
	sp - pointer to list of register names of that type

**********************************************************************/

atype (type_name, sp) int type_name, *sp;

	{int *ot, type;

	if ((type = typ_find (type_name)) < 0)
		{aptype (type_name, sp);
		return;
		}
	ot = get_top (sp);
	while (sp<=ot) trdt[type] =| getrc (*sp++);
	}

/**********************************************************************

	FTYPE - finished with TYPE statement

**********************************************************************/

ftype()

	{int i, r, flt_hack;

	prcom ("\ttype", typname, trdt, ntype);
	prcom ("pointer class", pcname, prdt, npc);

	if (save_area_size <0)
		{error (2014, lineno);
		save_area_size=0;
		}

	flt_hack = 1;
	if (tsize[tdouble]==tsize[tint] && tsize[tfloat]==tsize[tint]
		&& talign[tdouble]<=talign[tint] && talign[tfloat]<=talign[tint])
			flt_hack = 0;

	/* output OFF_OK array */

	gprint ("\nint (*off_ok[])() {");
	i = 0;
	for (r=0;r<npc;++r)
		{if (pcor[r]==0)
			{if (i==0) i = ++norr;
			gprint ("ofok%d", i);
			}
		else gprint ("ofok%d", pcor[r]);
		if (r<npc-1) gprint (",");
		}
	gprint ("};\n");
	if (i) gprint ("int ofok%d(i) {return (0);}\n", i);
	gprint ("\n");

	outarray ("tsize", tsize, ntype);
	outarray ("talign", talign, ntype);
	outarray ("calign", calign, nac);
	outarray ("retreg", retreg, 2+ntype+npc);
	outarray ("tpoint", tpoint, ntype);
	outarray ("spoint", pc_align, npc);
	outarray ("trdt", trdt, ntype);
	outarray ("prdt", prdt, npc);
	outarray ("conf", cfp, nreg);
	outint ("flt_hack", flt_hack);
	gprint ("int xoploc[] {\n");
	}

/**********************************************************************

	APTYPE - define pointer-types of registers

	idn - name of pointer class
	sp - pointer to list of names of registers of this type

**********************************************************************/

aptype (idn, sp) int idn, *sp;

	{int pc, *ot;

	ot = get_top (sp);
	if ((pc = find_pc (idn)) >= 0)
		while (sp <= ot) prdt[pc] =| getrc (*sp++);
	}

/**********************************************************************

	ACONF - define a conflicting pair of registers

	n1 - name of one register
	n2 - name of the other register

**********************************************************************/

aconf (n1, n2) int n1, n2;

	{int r1, r2;

	r1 = find_reg (n1);
	r2 = find_reg (n2);
	if (r1>=0 && r2>=0 && r1!=r2)
		{cfp[r1] =| 1<<r2;
		cfp[r2] =| 1<<r1;
		}
	}

/**********************************************************************

	AOPL - set a location field in DOPLOC

**********************************************************************/

aopl (o, f, w)

	{doploc.flag[o] = f;
	doploc.word[o] = w;
	copflag = l_unknown;
	}

/**********************************************************************

	ARTOP - set index of a abstract_machine_operator

**********************************************************************/

aamop (o)

	{oplist[coplist++] = o;
	amopp[o]=c_amopl;
	}

/**********************************************************************

	AOPLOC - gprint out an OPLOC

**********************************************************************/

aoploc (c)

	{int f, w, i;

	gprint ("\t%d,%d,%d,", doploc.flag[0], doploc.word[0], doploc.flag[1]);
	gprint ("%d,%d,%d,", doploc.word[1], doploc.flag[2], doploc.word[2]);
	gprint ("%d,\n", c);

	amopl[c_amopl++] = c_oploc;
	c_oploc =+ 1;
	f = doploc.flag[2];
	if (f==3)
		{f = doploc.flag[0];
		w = doploc.word[0];
		}
	else if (f==4)
		{f = doploc.flag[1];
		w = doploc.word[1];
		}
	else w = doploc.word[2];

	for (i=0;i<coplist;++i) switch (f) {
	case 1:		opreg[oplist[i]] =| w; break;
	case 2:		opmem[oplist[i]] =| w; break;
		}
	}

/**********************************************************************

	AOPE  - determine an OP location expression

**********************************************************************/

aope (n)	int n;	/* name, either register or mem_ref */

	{int j, c;

	if (n == -1)	/* INDIRECT */
		{if (copflag==l_register) error (2018, lineno);
		copflag = l_memory;
		return (~0777);
		}
	if (n == -2)	/* M */
		{if (copflag==l_register) error (2018, lineno);
		copflag = l_memory;
		return (-1);
		}
	if (copflag==l_unknown || copflag==l_register)
		{if ((j = reg_find (n)) >= 0)
			{copflag = l_register;
			return (1 << j);
			}
		else if ((c = rc_find(n)) >= 0)
			{copflag = l_register;
			return (rcp[c]);
			}
		else if (copflag == l_register)
			{error (2027, lineno, TIDN, n);
			return (0);
			}
		}
	if ((j = find_mem (n)) >= 0)
		{copflag = l_memory;
		return (1 << j);
		}
	return (0);
	}

/**********************************************************************

	ACLOBBER - determine the clobber field

**********************************************************************/

aclobber (sp) int *sp;

	{int *ot, i;

	ot = get_top (sp);
	i = 0;
	while (sp<=ot) i =| getrc (*sp++);
	return (i);
	}

/**********************************************************************

	FOPLOC - finished with OPLOCs

**********************************************************************/

foploc()

	{int i;

	gprint ("\t0};\n");

	/* set predefined values of OPREG and OPMEM */

	i = trdt[1];
	opreg[e_not] = opreg[e_and] = opreg[e_or] = opreg[e_qmark] = i;
	opmem[e_not] = opmem[e_and] = opmem[e_or] = opmem[e_qmark] = 0;
	opreg[e_int] = opreg[e_float] = opreg[e_string] = 0;
	opmem[e_int] = 1 << c_integer;
	opmem[e_float] = 1 << c_float;
	opmem[e_string] = 1 << c_string;
	outarray ("rtopp",amopp,namop);
	outarray ("rtopl",amopl,c_amopl);
	outarray ("opreg",opreg,namop);
	outarray ("opmem",opmem,namop);
	}

/**********************************************************************

	MPUSH - push an integer onto DEFLIST

**********************************************************************/

int mpush (a1)

	{int j;

	mdeflist[j = cmdf++] = a1;
	if (cmdf>=mdfsz) error(4002,lineno);
	return (j);
	}

/**********************************************************************

	MPSH2 - push two integers onto DEFLIST

**********************************************************************/

int mpsh2 (a1, a2)

	{int j;

	j = mpush (a1);
	mpush (a2);
	return (j);
	}

/**********************************************************************

	FMACRO - finished with MACRO specifications

**********************************************************************/

int col;

fmacro()

	{int c, f, lc, *ip, *ep, flag;
	char *p;

	outarray ("mactab",mactab,namop);
	outint ("ntype",ntype);
	outint ("nmem",nmem);
	outint ("nac",nac);
	outint ("npc",npc);
	outint ("sv_area_sz",save_area_size);
	outint ("nreg",nreg);

	/* gprint out MCSTORE */

	lc=col=0;
	flag=TRUE;
	ip=mdeflist;
	ep= &mdeflist[cmdf];

	p = cstore;
	gprint ("char mcstuff[] {\n");

	while (TRUE)
		{c = *p++;
		if (p >= cscsp) break;
		if (flag) while (ip < ep) if (*++ip == -3)
			{*ip = lc;
			flag = FALSE;
			break;
			}

again:		switch(c) {

case '\\':	switch (c = *p++) {
	
	case 't':	mputc ('\t'); ++lc; continue;
	case 'n':	mputc ('\n'); ++lc; continue;
	case '#':	mputs ("\\#"); lc=+2; continue;
	case '\\':	mputs ("\\\\"); lc=+2; continue;
	case '\n':	continue;
			}

		mputc ('\\');
		++lc;
		goto again;

case 0:		flag=TRUE;
		mputc (0);
		++lc;
		continue;

case '\"':	mputc ('\"');
		++lc;
		continue;

case '\t':	mputc ('\t');
		++lc;
		continue;

case '\n':	mputc ('\n');
		++lc;
		continue;

case '#':	c = *p++;
		if (c == '\'')
			{switch (c = *p++) {
			case 'F':
				mputs("#3,#4");
				lc =+ 5;
				break;
			case 'S':
				mputs("#5,#6");
				lc =+ 5;
				break;
			case 'R':
				mputs("#1,#2");
				lc =+ 5;
				break;
			case 'O':
				mputs("#0");
				lc =+ 2;
				}
			continue;
			}
		mputc ('#');
		mputc (c);
		lc =+ 2;
		continue;

default:	mputc (c & 0177);
		++lc;
			}
		}

	gprint ("};\n");
	gprint ("char *mcstore {mcstuff};\n");
	outarray ("macdef",macdef,cmacro);
	gprint ("char *nmacname[] {\n");
	for (f=0;f<nnmacs-1;f++)
		gprint ("\t\"%s\",\n",&cstore[nmacname[f]]);
	gprint ("\t\"%s\"};\n",&cstore[nmacname[nnmacs-1]]);
	outarray ("nmacdef",nmacdef,nnmacs);
	outarray ("mdeflist",mdeflist,cmdf);
	outint ("nnmacs",nnmacs);
	outint ("mdflsz",cmdf);
	outint ("nmacros",cmacro);
	}

mputs (s)	char *s;

	{int c;

	while (c = *s++) mputc (c);
	}

mputc (c)

	{if (c == 0) cputc ('0', f_out);
	else
		{cputc ('\'', f_out);
		switch (c) {
		case '\\':	cputc ('\\', f_out);
				cputc ('\\', f_out);
				break;
		case '\t':	cputc ('\\', f_out);
				cputc ('t', f_out);
				break;
		case '\n':	cputc ('\\', f_out);
				cputc ('n', f_out);
				break;
		case '\'':	cputc ('\\', f_out);
				cputc ('\'', f_out);
				break;
		default:	cputc (c, f_out);
				}
		cputc ('\'', f_out);
		}
	cputc (',', f_out);
	if (++col >= 12)
		{cputc ('\n', f_out);
		col=0;
		}
	else cputc (' ', f_out);
	}

/**********************************************************************

	OUTINT - write out an integer in C definition format

**********************************************************************/

outint (n,i) char n[]; int i;

	{gprint ("int %s { %d };\n", n, i);
	}

/**********************************************************************

	OUTARRAY - write out integer array in C definition format

**********************************************************************/

outarray (n,v,s) char n[]; int v[],s;

	{int i;

	gprint ("int %s[%d] {\n",n,s);
	for(i=0;i<s-1;i++)
		gprint ("%d,%s",*v++,
		(i%10==9)?"\n":"");
	gprint ("%d};\n",*v);
	}

/**********************************************************************

	NMAC - define a named macro

**********************************************************************/

nmac(idn,def) int idn,def;

	{int n;

	for (n=0; n<nnmacs; n++)
		if (nmacname[n]==idn)
			{error(2017,lineno,TIDN,idn);
			return;
			}
	if (nnmacs >= maxnmacs) error(4006,lineno);
	nmacname[nnmacs] = idn;
	nmacdef[nnmacs] = def;
	++nnmacs;
	}

/**********************************************************************

	XOPEN - Open File with Error Detection

	open file given 

		file - name of file
		mode - mode of file
		opt - string of system-dependent options

	If unable to open print a message and exit.
	Otherwise, return the file number.

**********************************************************************/

xopen (file, mode, opt) char *file, *opt; int mode;

	{int i;

	i = copen (file, mode, opt);
	if (i == OPENLOSS)
		{cprint ("Unable to open '%s'.\n", file);
		cexit (100);
		}
	return (i);
	}

