# include "gt.h"

/*

	GT Compiler
	Section 2: Parser Interface

*/

extern	int	lineno;
extern	char	cstore[], *fn_out;

int	f_out -1;

/**********************************************************************

	Parser Error Message Routines

**********************************************************************/

synerr (line)		{error (2007, line);}
giveup (line)		{error (4012, line);}
stkovf (line)		{error (4003, line);}
delmsg (line)		{error (2012, line);}
skpmsg (line)		{error (2013, line);}

qprint (q)		{error (2008, -1, q);}
tprint (tp) token *tp;	{error (2011, -1, tp->type, tp->index);}
pcursor ()		{error (2010, -1);}

stkunf (line)		{error (6006, line);}
tkbovf (line)		{error (6002, line);}
badtwp (line)		{error (6005, line);}
badtok (line, i)	{error (6000, line, i);}

/**********************************************************************

	PTOKEN - Print Token Routine

**********************************************************************/

ptoken (tp, f)	token *tp;

	{int type, index;
	extern char *sterm[], *eopch[];

	type = tp->type;
	index = tp->index;
	switch (type) {
		case TIDN:	cprint (f, "%s", &cstore[index]);
				return;
		case TINTCON:	cprint (f, "%d", index);
				return;
		case TSTRING:	cprint (f, "\"\"");
				return;
		case T_AMOP:	cprint (f, "%s", eopch[index]);
				return;
		default:	cprint (f, "%s", sterm[type]);
		}
	}

/**********************************************************************

	PINIT - Parser Initialization Routine

**********************************************************************/

pinit ()

	{extern int prm();
	lxinit ();
	f_out = xopen (fn_out, MWRITE, TEXT);
	deffmt ('m', prm, 1);
	}

/**********************************************************************

	CLEANUP - Parser CleanUp Routine

**********************************************************************/

cleanup (rcode)

	{cclose (f_out);
	cexit (rcode);
	}

/**********************************************************************

	STACK FOR ACTION ROUTINES

**********************************************************************/

int stack[pssize];
int *sp {stack};

int *push (i)

	{if (++sp >= &stack[pssize]) error (4007, lineno);
	*sp = i;
	return (sp);
	}

int pop ()

	{int i;

	i = *sp--;
	if (sp < stack) error (6001, lineno);
	return (i);
	}

int *setsp (nsp) int *nsp;	/* set stack pointer */

	{if (nsp < stack) error (6003, lineno);
	if (nsp >= &stack[pssize]) error (6004, lineno);
	return (sp = nsp);
	}

int *top ()			/* get stack pointer */

	{return (sp);
	}

int *get_top (nsp) int *nsp;	/* get list from top of stack */

	{int *ot;

	ot = top();
	setsp (nsp-1);
	return (ot);
	}

/**********************************************************************

	GPRINT - Formatted Print Routine

**********************************************************************/

gprint (fmt,x1,x2,x3)	char fmt[];

	{cprint (f_out, fmt, x1, x2, x3);}

/**********************************************************************

	PRM - Print String in Cstore

**********************************************************************/

prm (i, f)

	{cprint (f, "%s", &cstore[i]);}
