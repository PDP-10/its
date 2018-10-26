# include "cc.h"
# include "c2.h"

/*

	C COMPILER
	Phase P: Parser
	Section 2: Statement Processing and Action Routine Support

	Copyright (c) 1977 by Alan Snyder

*/

/**********************************************************************

	VARIABLES

**********************************************************************/

int ciln 0;	/* current internal label number */
extern int	line, cblock;

/**********************************************************************

	GROUP STACK

**********************************************************************/

# define gentry struct _gentry
struct _gentry {int gtype, gchain, giln;};

# define GNULL 0
# define GSWITCH 1
# define GFOR 2
# define GDO 3
# define GWHILE 4

gentry gstack[GSSIZE];
gentry *cgsp, *egsp;

gpush (gtype, niln)

	{if (++cgsp >= egsp) errx (4002);
	cgsp->gtype = gtype;
	cgsp->giln  = ciln;
	cgsp->gchain = 0;
	ciln =+ niln;
	}

gentry *findswitch ()

	{gentry *gp;

	for (gp=cgsp; gp->gtype>GSWITCH; --gp);
	if (gp>gstack) return (gp);
	return (NULL);
	}

/**********************************************************************

	STACK ROUTINES FOR ACTIONS

**********************************************************************/

int stack[pssize];
int *stakp stack;
int *estkp;

int *push (i)

	{if (++stakp >= estkp) errx (4007);
	*stakp = i;
	return (stakp);
	}

pop ()

	{int i;
	i = *stakp--;
	if (stakp < stack) errx (6002);
	return (i);
	}

int *setsp (nsp) int *nsp;	/* set stack pointer */

	{if (nsp < stack || nsp >= estkp) errx (6010);
	return (stakp = nsp);
	}

int *top ()			/* get stack pointer */

	{return (stakp);}

int *get_top (nsp) int *nsp;	/* get list from top of stack */

	{int *ot;

	ot = top ();
	setsp (nsp-1);
	return (ot);
	}

/**********************************************************************

	ACTION ROUTINES

**********************************************************************/

ainit ()

	{ciln = 0;
	cgsp = gstack;
	egsp = cgsp + GSSIZE;
	cgsp->gtype = GNULL;
	estkp = stack + pssize;
	dinit ();
	}

astmtl (stmtl, stmt)

	{return (node (n_stmtl, stmtl, stmt));}

aexprstmt (expr)

	{return (node (n_exprs, line, expr));}

aif (test, if_part, else_part)

	{return (node (n_if, line, test, if_part, else_part));}

awhile (expr, stmt)

	{int l;

	l = (cgsp--)->giln;
	return (astmtl (
		ailabel (l+1,
			aif (expr, astmtl (stmt, abranch (l+1)), 0)),
		ailabel (l, 0)));
	}

apshw () {gpush (GWHILE, 2);}

ado (stmt, expr)

	{int l;

	l = (cgsp--)->giln;
	return (astmtl (
		ailabel (l+2, stmt),
		astmtl (
			ailabel (l+1, aif (expr, abranch (l+2), 0)),
			ailabel (l, 0))));
	}

apshd () {gpush (GDO, 3);}


afor (e1, e2, e3, stmt)

	{int l, tnode;

	l = (cgsp--)->giln;
	tnode = astmtl (
		stmt,
		astmtl (
			ailabel (l+1, (e3 ? aexprstmt (e3) : NULL)),
			abranch (l+2)));
	if (e2) tnode = aif (e2, tnode, 0);
	tnode = astmtl (
		ailabel (l+2, tnode),
		ailabel (l, 0));
	if (e1) tnode = astmtl (aexprstmt (e1), tnode);
	return (tnode);
	}

apshf () {gpush (GFOR, 3);}

aswitch (expr, stmt)

	{int l, c;

	c = cgsp->gchain;
	l = (cgsp--)->giln;

	return (astmtl (
		node (n_switch, line, expr, stmt, c),
		ailabel (l, 0)));
	}

apshs () {gpush (GSWITCH, 1);}

abreak ()

	{if (cgsp==gstack)
		{error (2002, line);
		return (NULL);
		}
	return (abranch (cgsp->giln));
	}

acontinue ()

	{gentry *gp;

	for (gp = cgsp; gp>gstack; --gp)
		if (gp->gtype > GSWITCH)	/* not a switch */
			return (abranch (gp->giln+1));
	error (2003, line);
	return (NULL);
	}

areturn (expr)

	{return (node (n_return, line, expr));}

agoto (expr)

	{return (node (n_goto, line, astar (expr)));}

alabel (idn, stmt)

	{dentry *dp;

	dp = define (cblock, idn, c_label, TINT, UNDEF);
	if (dp->offset == UNDEF) dp->offset = ciln++;
	return (ailabel (dp->offset, stmt));
	}

ailabel (iln, stmt)

	{return (node (n_label, iln, stmt));}

abranch (iln)

	{return (node (n_branch, iln));}

acase (c, stmt)

	{gentry *gp;

	if (gp = findswitch ())
		{gp->gchain = node (n_case, gp->gchain, c, ciln);
		return (ailabel (ciln++, stmt));
		}
	error (2004, line);
	return (stmt);
	}

adefault (stmt)

	{gentry *gp;

	if (gp = findswitch ())
		{gp->gchain = node (n_def, gp->gchain, ciln);
		return (ailabel (ciln++, stmt));
		}
	error (2005, line);
	return (stmt);
	}

anull ()

	{return (NULL);}

aelist (elist, expr)

	{return (node (n_elist, elist, expr));}

asubscript (e1, e2)

	{return (astar (node (n_plus, e1, e2)));}

acall (func, args)

	{return (node (n_call, func, args));}

adot (expr, idn)

	{return (node (n_dot, expr, idn));}

aptr (expr, idn)

	{return (adot (astar (expr), idn));}

astar (expr)

	{return (node (n_star, expr));}

aidn (dp)
	dentry *dp;

	{int class;

	switch (class = dp->class) {
	case c_ulabel:	class=c_label; break;
	case c_extern:	class=c_extdef; break;
	case c_uauto:	class=c_auto; break;
	case c_typedef:	errx (2042, TIDN, dp->name); class=c_auto; break;
		}
	return (node (n_idn, tp2o (dp->dtype), class, dp->offset));
	}

aentry (idn, stmt)

	{return (stmt);}	/* not implemented */

