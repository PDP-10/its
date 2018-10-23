# include "c.defs"

/**********************************************************************

	STKDMP - C Stack Dumping Routine

	This file is PDP-10 dependent, but essentially system
	independent.

**********************************************************************/

# rename findproc "FINDPR"
# rename findframe "FINDFR"
# rename print_name "PRNAME"
# rename callok "CALLOK"

# rename hack "STKDMP"
# rename seg2lo "SEG2LO"
# rename seg2hi "SEG2HI"
# rename seg3lo "SEG3LO"
# rename seg3hi "SEG3HI"
# rename pdlbot "PDLBOT"
# rename pdltop "PDLTOP"
# rename purbot "PURBOT"
# rename purtop "PURTOP"
# rename intptr "INTPTR"
# rename mpvh   "MPVH"
# rename etsint "ETSINT"
# rename uuoh	"UUOH"
# rename uuohan "UUO$HA"
# rename euuoh	"EUUOH"
# rename caller	"CALLER"

# define ADDI_P 0271740
# define SUBI_P 0275740
# define GO_P	0254037
# define JSP_D	0265200
# define GO	0254000

# define left(x) (((x) >> 18) & 0777777)
# define right(x) ((x) & 0777777)

extern int	*seg2lo, *seg2hi, *seg3lo, *seg3hi,
		*pdlbot, *pdltop, *purbot, *purtop, *caller,
		mpvh[], etsint[], intptr, uuoh[], uuohan[], euuoh[],
		cout, *findframe(), *findproc(), hack[];

/**********************************************************************

	STKDMP - Dump stack.

**********************************************************************/

static int tuuoh;

stkdmp (fd)

	{int	*pc;		/* procedure pointer */
	int	*opc;		/* previously printed-out pc */
	int	*sp;		/* stack pointer */

	if (!cisfd(fd)) fd = cout;
	cputc ('\n', fd);
	tuuoh = uuoh[0];
	sp = &fd;		/* arg is on the stack */
	pc = right(sp[1]);	/* my caller's pc is on the stack */
	opc = -1;
	--sp;			/* top of stack when he was running */
	if (pc >= hack && pc <= hack+12)   /* PUSHJ P,STKDMP$X */
		{pc = right(sp[0]);	/* 'real' caller */
		sp =- 7;		/* 'real' stack top */
		}
	while (TRUE)
		{int *proc, nargs, *npc, *namep, *ap;
		proc = findproc (pc);
		if (proc == 0) break;
		nargs = left(proc[-1]);
		namep = right(proc[-1]);
		sp = findframe (sp, proc, pc);
		if (sp == 0)
			{if (opc != caller)
				{cprint (fd, "        ");
				print_name (namep, fd);
				cprint (fd, "\n");
				}
			break;
			}
		npc = right(sp[0]);
		sp =- nargs;
		ap = sp;
		--sp;
		cprint (fd, "%7o ", sp);
		print_name (namep, fd);
		cprint (fd, " (");
		if (nargs>10) nargs = 10;
		while (--nargs >= 0)
			{cprint (fd, "%o", *ap++);
			if (nargs) cprint (fd, ", ");
			}
		cprint (fd, ")\n");
		opc = proc;
		pc = npc;
		}
	}

/**********************************************************************

	FINDPROC - Find beginning of active procedure, given a PC.

**********************************************************************/

int *findproc (pc) int *pc;

	{int *low, *high, n;

	n = 3;
	while (--n>=0)
		{if (pc >= mpvh && pc < etsint)
			{int *p;
			p = right(intptr);
			pc = right(p[-4]);
			continue;
			}
		if (pc == uuoh+1 || (pc >= uuohan && pc < euuoh))
			{pc = right(tuuoh);
			if ((pc[0]>>29)==0) ++pc;	/* hack */
			continue;
			}
		}
	if (pc > seg2lo && pc <= seg2hi)
		{low = seg2lo;
		high = seg2hi;
		}
	else if (pc > purbot && pc <= purtop)
		{low = purbot;
		high = purtop;
		}
	else return (0);

	++pc;
	while (--pc > low)
		{int data, c, nargs, *namep;
		if ((*pc >> 27) == 0) continue;
		data = pc[-1];
		nargs = left(data);
		namep = right(data);
		if (nargs >= 16) continue;
		if (namep < seg3lo || namep > seg3hi) continue;
		c = (*namep >> 29);	/* left byte */
		if (c < ' ' || c > 'z') continue;
		return (pc);
		}
	return (0);
	}

/**********************************************************************

	FINDFRAME - Find stack frame, given stack top and procedure
		pointer, and PC within procedure.  Returns pointer
		to return address on stack.

**********************************************************************/

int *findframe (sp, proc, pc) int *sp, *proc, *pc;

	{int instr, signal();

	instr = proc[0];
	if (left(instr) == ADDI_P)	/* procedure allocates a frame */
		{int bump;
		bump = right(instr);		/* local frame size */
		if (pc == proc);		/* hasn't allocated it yet */
		else if (left(pc[0]) == GO_P);	/* has popped it */
		else sp =- bump;
		}
	if (pc >= mpvh && pc < etsint)		/* was in interrupt handler */
		sp =- 17;		/* ignore stuff pushed by handler */
		/* !!! the above is wrong !!! */

	++sp;
	while (--sp >= pdlbot)
		{int data, *opc;
		data = *sp;

		/* look for return address word on stack */
		/* check for reasonable status bits */
		if (!(data & 0010000000000)) continue;
			/* must be in user mode */
		if (data & 0027637000000) continue; /* bad for status bits */

		/* check for reasonable old PC (within code segment) */
		opc = right(data) - 1;
		if (opc < seg2lo) continue;
		if (opc > seg2hi) continue;

		/* check to see if old PC was call to current proc */
		if (callok (opc, proc))
			{if (proc == signal && opc>=mpvh && opc<etsint)
				tuuoh = sp[-1];
			return (sp);
			}
		}
	return (0);
	}

/**********************************************************************

	CALLOK

**********************************************************************/

int callok (opc, proc)
	int *opc, *proc;

	{int call, *tpc, op;
	call = *opc;
	if (call & 037000000)	/* index or indirect */
		return (TRUE);	/* can't test it, assume it's the right one */
	op = left(call);	/* op code */
	tpc = right(call);	/* address */
	if (op == JSP_D)	/* call with nargs mismatch */
		{int n, i;	/* look for jump */
		n = 20;		/* up to 20 instructions before jump */
		for (i=0;i<n;++i)
			{call = tpc[i];
			op = left(call);
			if (op == GO)
				{tpc = right(call);
				break;
				}
			}
		}
	return (tpc == proc);
	}

/**********************************************************************

	PRINTNAME

**********************************************************************/

print_name (namep, fd)

	{int c;
	namep = right(namep) | 0440700000000;
	while (c = ildb (&namep))
		cputc (c>='A' && c<='Z' ? c+('a'-'A') : c, fd);
	}
