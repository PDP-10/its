# include "r.h"

/*

	R Text Formatter
	Expression Parsing

	Copyright (c) 1976, 1977 by Alan Snyder


	ROUTINES:

	gete () => double	read numeric expression
	getp () => double	read numeric primary
	getop () => op		read expression operator
	pushop (op)		push-back expression operator
	i = fcomp (f1, f2)	floating point comparison

*/


/*	expression operators	*/

# define o_end 0
# define o_add 1
# define o_sub 2
# define o_mul 3
# define o_div 4
# define o_and 5
# define o_or 6
# define o_eq 7
# define o_ne 8
# define o_lt 9
# define o_le 10
# define o_gt 11
# define o_ge 12
# define o_mod 13
# define o_idiv 14

extern	int	ftrace;
extern	ac	rd_ac;
extern	double	getp(), gete1();

/**********************************************************************

	GETE - Get Numeric Expression

	The expression is assumed to begin with the next input
	character.  The expression terminates with the first invalid
	expression character.  The operators are the usual arithmetic,
	comparison, and logical operators.  The precedence of the
	operators is given in the array PREC.  All operators are
	left-associative.  Left-corner parsing is used.

**********************************************************************/

int	prec[] {
		0,	/* o_end */
		5,	/* o_add */
		5,	/* o_sub */
		6,	/* o_mul */
		6,	/* o_div */
		2,	/* o_and */
		1,	/* o_or */
		3,	/* o_eq */
		3,	/* o_ne */
		4,	/* o_lt */
		4,	/* o_le */
		4,	/* o_gt */
		4,	/* o_ge */
		6,	/* o_mod */
		6	/* o_idiv */
		};

double	gete1 (lprec) int lprec;	/* left binding power */

	{double	val, rval;
	int	rprec, op, i;

	val = getp ();
	while ((op = getop()) != o_end)
		{if ((rprec = prec[op]) <= lprec)
			{pushop (op);
			return (val);
			}
		rval = gete1 (rprec);
		switch (op) {

case o_or:	val = fcomp (val, 0.0) || fcomp (rval, 0.0); break;
case o_and:	val = fcomp (val, 0.0) && fcomp (rval, 0.0); break;
case o_eq:	val = !fcomp (val, rval); break;
case o_ne:	val = fcomp (val, rval); break;
case o_lt:	val = fcomp (val, rval) < 0; break;
case o_le:	val = fcomp (val, rval) <= 0; break;
case o_gt:	val = fcomp (val, rval) > 0; break;
case o_ge:	val = fcomp (val, rval) >= 0; break;
case o_add:	val =+ rval; break;
case o_sub:	val =- rval; break;
case o_mul:	val =* rval; break;
case o_div:	val =/ rval; break;
case o_mod:	val = (i=val) % (i=rval); break;
case o_idiv:	val = (i=val) / (i=rval); break;
default:	barf ("GETE: bad operator %d", op); break;
			}
		}
	return (val);
	}

/**********************************************************************

	GETP - Read Numeric Primary

	The primary expression is assumed to begin with the
	next input character.  The primary expression terminates
	with the first invalid expression character.  Prefix '+',
	'-', and '~' are recognized, as are parenthesized expressions.

**********************************************************************/

double	getp ()

	{double	val, factor;
	int	c, ival;
	idn	name;

	switch (c = getc2 ()) {

case '+':	return (getp ());
case '-':	return (-getp ());
case '~':	return (val = !fcomp (getp (), 0.0));
case '(':	val = gete ();
		if ((c = getc2 ()) != ')')
			{error ("missing ')' in expression");
			push_char (c);
			}
		return (val);
		}

	if (c>='0' && c<='9' || c=='.')
		{val = 0.0;
		while (c>='0' && c<='9')
			{val = val*10.0 + (c-'0'); c=getc2();}
		if (c=='.')
			{c = getc2 ();
			factor = .1;
			while (c>='0' && c<='9')
				{val =+ factor*(c-'0');
				factor =/ 10.0;
				c=getc2();
				}
			}
		push_char (c);
		return (val);
		}

	if (alpha (c))
		{ac_flush (rd_ac);
		while (alpha (c))
			{ac_xh (rd_ac, c);
			c = getc2 ();
			}
		if (c != '!') push_char (c);
		name = make_ac_idn (rd_ac);
		val = ival = nr_value (name);
		if (ftrace >= 0) cprint (ftrace, "(%d)", ival);
		return (val);
		}

	push_char (c);
	return (0.0);
	}

/**********************************************************************

	GETOP - Get Expression Operator

	The operator is assumed to begin with the next character.
	If a valid operator is not found, the end-of-expression
	operator is returned and the input reset so that that same
	character will be next read.  If a valid operator is found,
	the next input character will be the character following
	the operator.

	The recognizer is driven by the table OPCTAB, which lists the
	valid first characters of operators.  The corresponding table
	OPVTAB gives either the value of the single-character operator
	(if that is the only operator beginning with that character)
	or negative the index into OPCTAB of another list giving the
	possible second characters of two-character operators
	beginning with that symbol.  These lists terminate with 0 if
	the single character is not a valid operator or -1 if it is.

**********************************************************************/

int	opctab[] {
	'*',
	'/',
	'+',
	'-',
	'&',
	'|',
	'%',
	'~',
	'=',
	'<',
	'>',
	'^',
	0,	/* end of first character list */
	'=',	/* (13) ~= */
	0,	/* (14) ~ (invalid) */
	'=',	/* (15) == */
	0,	/* (16) = (invalid) */
	'=',	/* (17) <= */
	-1,	/* (18) < */
	'=',	/* (19) >= */
	-1,	/* (20) > */
	};

int	opvtab[] {
	o_mul,
	o_div,
	o_add,
	o_sub,
	o_and,
	o_or,
	o_mod,
	-13,	/* ~ */
	-15,	/* = */
	-17,	/* < */
	-19,	/* > */
	o_idiv,
	0,
	o_ne,
	0,
	o_eq,
	0,
	o_le,
	o_lt,
	o_ge,
	o_gt
	};

int	getop ()

	{int	c1, c2, *p, m, v;

	c1 = getc2 ();
	p = opctab;
	while (m = *p++) if (c1 == m)
		{v = opvtab[p-opctab-1];
		if (v>=0) return (v);
		c2 = getc2 ();
		p = opctab-v;
		while ((m = *p++) > 0) if (c2==m) break;
		v = opvtab[p-opctab-1];
		if (c2 == m) return (v);
		push_char (c2);
		if (m == -1) return (v);
		break;
		}
	push_char (c1);
	return (o_end);
	}

/**********************************************************************

	PUSHOP - Push-back expression operator

**********************************************************************/

char	*opstab[] {

	"", "+", "-", "*", "/", "&", "|", "==", "~=", "<", "<=",
	">", ">=", "%"};

pushop (op) {push_string (opstab[op]);}

/**********************************************************************

	FCOMP - Floating Point Comparison

	Compare two floating point numbers F1 and F2; return
		-1 if F1<F2
		0 if F1==F2 (within .01%)
		1 if F1>F2

**********************************************************************/

int fcomp (f1, f2)	double f1, f2;

	{int	w;
	double	m1, m2, m;

	w = f1 < f2;
	if (f1<0) m1 = -f1; else m1 = f1;
	if (f2<0) m2 = -f2; else m2 = f2;
	if (m1<m2) m = m1 * .0001; else m = m2 * .0001;
	if (m<1e-10) m = 1e-10;
	if (w ? f2-f1<m : f1-f2<m) return (0);
	return (w ? -1 : 1);
	}

