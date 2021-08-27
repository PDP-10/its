# include "r.h"

/*

	R Text Formatter
	Control Structures and Variables

	Copyright (c) 1976, 1977 by Alan Snyder


	ROUTINES:

	cntrl_init ()		initialization
	push_group (...)	push group entry
	pop_group ()		pop top group entry
	push_var (type, name)	push variable
	pop_var ()		pop top variable entry
	leave_group (lev)	end-of-macro handler
	unterminated_group (p)	emit error message
	nv_define (n, v)	define number variable
	sv_define (s, v)	define string variable
	be_com ()		begin BEGIN block
	push_begin (name)	push begin group on stack
	wh_com ()		begin WHILE statement
	push_while ()		push while group on stack
	if_com ()		begin IF statement
	push_if ()		push if group on stack
	fr_com ()		begin FOR statement
	push_for (...)		push for group on stack
	cond_test ()		perform a conditional test
	skip_until_end (p, b)	skip until matching EN request is found
	bk_com ()		process BREAK statement
	ef_com ()		process ELSE statement
	en_com ()		process END statement

*/

/*	variables	*/

# define v_nr 0			/* previously-defined NR */
# define v_unr 1		/* previously-undefined NR */
# define v_sr 2			/* previously-defined SR */
# define v_usr 3		/* previously-undefined SR */

struct _var_entry {
	idn	name;		/* register name */
	int	vtype;		/* variable type */
	int	val;		/* variable value */
	};
# define var_entry struct _var_entry

var_entry
	var_stack[max_var],
	*cvar {var_stack},
	*evar,
	*mvar {var_stack};

/*	group types	*/

# define g_while 0
# define g_for 1
# define g_if 2
# define g_begin 3
# define g_dummy 4	/* surrounds entire file */

struct _group_entry
	{idn	name;		/* FOR variable or BEGIN block name */
	int	gtype;		/* type of group */
	int	icblev;		/* input level of macro */
	var_entry *pvar;	/* variable stack level */
	char	*ip;		/* input pointer */
	int	icount;		/* input count */
	int	hi;		/* hi bound of FOR */
	int	step;		/* step of FOR */
	};
# define group_entry struct _group_entry

group_entry
	group_stack[max_group],
	*cgrp {group_stack},
	*egrp,
	*mgrp {group_stack};

extern	int	icblev, no_interpretation, in_mode, i_val, exiting;
extern	char	*i_p;

/**********************************************************************

	CNTRL_INIT - initialization

**********************************************************************/

int cntrl_init ()

	{cgrp->gtype = g_dummy;
	cgrp->icblev = -1;
	egrp = cgrp + max_group;
	evar = cvar + max_var;
	cgrp->pvar = cvar;
	}

/**********************************************************************

	PUSH_GROUP - push group entry

**********************************************************************/

push_group (type, need_pos, name, hi, step)
	idn name;

	{if (++cgrp >= egrp) fatal ("too many nested statements");
	if (cgrp > mgrp) mgrp = cgrp;
	cgrp->gtype = type;
	cgrp->icblev = icblev;
	cgrp->pvar = cvar;
	if (need_pos)
		{cgrp->ip = i_p;
		cgrp->icount = i_val;
		}
	else cgrp->ip = cgrp->icount = 0;
	cgrp->name = name;
	cgrp->hi = hi;
	cgrp->step = step;
	}

/**********************************************************************

	POP_GROUP - pop top group entry

**********************************************************************/

pop_group ()

	{var_entry *p;

	if (cgrp <= group_stack) barf ("POP_GROUP: stack underflow");
	else
		{p = cgrp->pvar;
		while (cvar > p) pop_var ();
		--cgrp;
		}
	}

/**********************************************************************

	PUSH_VAR - push variable entry

**********************************************************************/

push_var (type, name)

	{int val;
	if (++cvar >= evar) fatal ("too many variables");
	if (cvar > mvar) mvar = cvar;
	cvar->name = name;
	val = 0;
	if (type == v_nr)
		{if (nr_find (name) >= 0) val = nr_value (name);
		else type = v_unr;
		}
	else if (type == v_sr)
		{if (sr_find (name) >= 0) val = sr_value (name);
		else type = v_usr;
		}
	cvar->vtype = type;
	cvar->val = val;
	}

/**********************************************************************

	POP_VAR - pop top variable entry

**********************************************************************/

pop_var ()

	{idn name;

	name = cvar->name;
	if (cvar <= var_stack) barf ("POP_VAR: stack underflow");
	else
		{switch (cvar->vtype) {
		case v_nr:	nr_enter (name, cvar->val); break;
		case v_unr:	nr_undef (name); break;
		case v_sr:	sr_enter (name, cvar->val); /* move ref */
				break;
		case v_usr:	sr_undef (name); break;
		default:	barf ("POP_VAR: bad variable type");
				}
		--cvar;
		}
	}

/**********************************************************************

	LEAVE_GROUP - this routine is called when a macro
		containing an active group is finished; it is
		also called explicitly when processing is finished

**********************************************************************/

leave_group (lev)

	{while (cgrp->icblev >= lev)
		{if (cgrp->gtype == g_begin && lev > 0)
			{group_entry *p;
			int olev;
			p = cgrp;
			olev = lev;
			while (olev >= lev)
				olev = --p->icblev;
			olev = max (0, olev);
			while (++p <= cgrp)
				p->icblev = olev;
			break;
			}
		if (!exiting) unterminated_group (cgrp);
		pop_group ();
		}
	}

/**********************************************************************

	UNTERMINATED_GROUP - emit error message for unterminated group

**********************************************************************/

unterminated_group (p)
	group_entry *p;

	{switch (p->gtype) {
case g_while:	error ("unterminated while statement"); return;
case g_if:	error ("unterminated if statement"); return;
case g_for:	error ("unterminated for statement"); return;
case g_begin:	if (p->name == -1)
			error ("unterminated unnamed begin block");
		else error ("unterminated begin block named %s",
			idn_string (p->name));
		return;
default:	barf ("UNTERMINATED_GROUP: bad group type");
		}
	}

/**********************************************************************

	OUT_OF_SCOPE - return TRUE if not properly in the
		scope of some statement

**********************************************************************/

int out_of_scope ()

	{return (cgrp->icblev < icblev && cgrp->gtype != g_begin);}

/**********************************************************************

	NV_DEFINE - define number variable

**********************************************************************/

nv_define (name, val)
	idn name;

	{if (out_of_scope ())
		error ("variables must be defined within statements");
	else
		{push_var (v_nr, name);
		nr_enter (name, val);
		}
	}

/**********************************************************************

	SV_DEFINE - define string variable

**********************************************************************/

sv_define (name, val)
	idn name;

	{if (out_of_scope ())
		error ("variables must be defined within statements");
	else
		{push_var (v_sr, name);
		sr_enter (name, val);
		}
	}

/**********************************************************************

	BE_COM - Begin BEGIN block.  The input must be positioned
	in front of the block name.

**********************************************************************/

be_com ()

	{idn name;

	name = get_name ();
	push_begin (name);
	set_exit (leave_group);
	}

/**********************************************************************

	PUSH_BEGIN - push begin group on stack

**********************************************************************/

push_begin (name) {push_group (g_begin, FALSE, name, 0, 0);}

/**********************************************************************

	WH_COM - Begin WHILE statement.  Input must be coming
	from a macro definition, and the input must be positioned
	in front of the while expression.

**********************************************************************/

wh_com ()

	{int t;
	ichar ic;

	ic = -1;
	t = get_input_type ();
	if (t==i_char)	/* character following WH may have
			   been read */
		{ic = getc1 ();
		t = get_input_type ();
		}
	if (t != i_macro)
		{error ("while statement must be in macro definition");
		return;
		}
	if (ic != 1) decrement_input_pos ();
	push_while ();
	set_exit (leave_group);
	cond_test ();
	}

/**********************************************************************

	PUSH_WHILE - push while group on stack

**********************************************************************/

push_while () {push_group (g_while, TRUE, 0, 0, 0);}

/**********************************************************************

	FR_COM - Begin FOR statement.  Input must be coming
	from a macro definition, and the input must be positioned
	in front of the first argument.

**********************************************************************/

fr_com ()

	{int t, lo, hi, step;
	ichar ic;
	idn name;

	name = get_name ();
	lo = get_int (1, 0);
	hi = get_int (infinity, 0);
	step = get_int (1, 0);

	if (name<0) return;
	ic = -1;
	t = get_input_type ();
	if (t==i_char)	/* character following FR may have been read */
		{ic = getc1 ();
		t = get_input_type ();
		}
	if (t != i_macro)
		{error ("for statement must be in macro definition");
		return;
		}
	if (ic != 1) decrement_input_pos ();
	push_for (name, hi, step);
	set_exit (leave_group);
	push_var (v_nr, name);
	nr_enter (name, lo);
	cond_test ();
	}

/**********************************************************************

	PUSH_FOR - push for group on stack

**********************************************************************/

push_for (name, hi, step)
	idn name;
	int hi, step;

	{push_group (g_for, TRUE, name, hi, step);
	}

/**********************************************************************

	IF_COM - Begin IF statement.  Input must be coming
	from a macro definition, and the input must be positioned
	in front of the conditional expression.

**********************************************************************/

if_com ()

	{int t;
	ichar ic;
	group_entry *p;

	ic = -1;
	t = get_input_type ();
	if (t==i_char)	/* character following IF may have been read */
		{ic = getc1 ();
		t = get_input_type ();
		}
	if (t != i_macro && t != i_file)
		{error ("if statement must be in file or macro definition");
		return;
		}
	push_if ();
	set_exit (leave_group);
	if (ic != -1) push_char (ic);
	p = cgrp;
	for (;;)	/* loop to process else-if clauses */
		{if (cond_test ()) break;	/* test succeeds */
		if (cgrp != p) break;		/* no else-if */
		}
	}

/**********************************************************************

	PUSH_IF - push if group on stack

**********************************************************************/

push_if () {push_group (g_if, FALSE, 0, 0, 0);}

/**********************************************************************

	COND_TEST - perform a IF, FOR, or WHILE statement test
	If current input is from a macro, the input will be
	positioned to read the conditional expression.
	Returns TRUE if the test succeeded.

**********************************************************************/

int cond_test ()

	{int val, lev, i, flag;

	val = -1;
	flag = FALSE;
	switch (cgrp->gtype) {
	case g_if:	flag = TRUE; break;
	case g_for:	i_p = cgrp->ip;
			i_val = cgrp->icount;
			i = nr_value (cgrp->name);
			if (cgrp->step>=0 && i>cgrp->hi ||
				cgrp->step<=0 && i<cgrp->hi)
					{val = 0;
					break;
					}
			break;
	case g_while:	i_p = cgrp->ip;
			i_val = cgrp->icount;
			break;
	default:	barf ("COND_TEST: bad group");
			return;
			}
	lev = cgrp->icblev;
	if (val == -1) val = get_int (1, 0);
	if (val==0)	/* expression is FALSE */
		skip_until_end (cgrp, flag);
	return (val != 0);
	}

/**********************************************************************

	SKIP_UNTIL_END - Skip until specified matching EN request is
		or corresponding macro definition is terminated.
	If FLAG is TRUE, stop if an ELSE statement at the current
	level is seen.

**********************************************************************/

skip_until_end (p, flag)
	group_entry *p;

	{ichar ic;
	idn name;
	int (*f)();
	extern int (*comtab[])(), name_info[], en_com(), wh_com(),
		if_com(), fr_com(), be_com(), ef_com();

	no_interpretation = TRUE;
	in_mode = m_text;
	while (TRUE)
		{ic = getc1 ();
		if (cgrp < p || icblev<0) break;
		if (ic == i_dot || ic == i_quote)
			{name = get_untraced_name ();
			if (name >= 0 && (name_info[name] & RQMACRO) == 0)
				{f = comtab[name];
				if (f == en_com) pop_group ();
				else if (f == wh_com) push_while ();
				else if (f == if_com) push_if ();
				else if (f == be_com) push_begin (get_name ());
				else if (f == fr_com) push_for (-1, 0, 0);
				else if (f == ef_com)
					{if (flag && p == cgrp)
						{ic = -1;
						break;
						}
					}
				}
			}
		}
	if (ic != -1) push_char (ic);
	no_interpretation = FALSE;
	}

/**********************************************************************

	BK_COM - process BREAK statement

**********************************************************************/

bk_com ()

	{ichar ic;
	group_entry *p;

	ic = -1;
	if (get_input_type () == i_char) ic = getc1 ();
		/* character following BK may have been read */
	p = cgrp;
	while (p->gtype != g_while && p->gtype != g_for)
		if (icblev > p->icblev)
			{error ("extraneous break statement");
			return;
			}
		else --p;
	skip_until_end (p, FALSE);
	}

/**********************************************************************

	EF_COM - process ELSE statement

**********************************************************************/

ef_com ()

	{ichar ic;
	group_entry *p;

	ic = -1;
	if (get_input_type () == i_char) ic = getc1 ();
		/* character following EF may have been read */
	p = cgrp;
	if (p->gtype != g_if || icblev > p->icblev)
		{error ("extraneous else-if statement");
		return;
		}
	skip_until_end (p, FALSE);
	}

/**********************************************************************

	EN_COM - process END statement

**********************************************************************/

en_com ()

	{int t;
	ichar ic;
	var_entry *p;

	ic = -1;
	t = get_input_type ();
	if (t==i_char)	/* character following EN may have been read */
		{ic = getc1 ();
		t = get_input_type ();
		}
	p = cgrp->pvar;
	if (out_of_scope ()) error ("extraneous end statement");
	else switch (cgrp->gtype) {
		case g_begin:
		case g_if:	pop_group ();
				break;
		case g_for:	++p;
				while (cvar > p) pop_var ();
				nr_enter (cgrp->name,
					nr_value (cgrp->name) + cgrp->step);
				return (cond_test ());
		case g_while:	while (cvar > p) pop_var ();
				return (cond_test ());
		}
	if (ic != -1) push_char (ic);
	}

/**********************************************************************

	CNTRL_STAT - Compute Statistics

**********************************************************************/

cntrl_stat (nvar, ngroup) int *nvar, *ngroup;

	{*nvar = (mvar-var_stack);
	*ngroup = (mgrp-group_stack);
	}
