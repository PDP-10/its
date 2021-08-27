# include "r.h"

/*

	R Text Formatter
	Trap Routines

	Copyright (c) 1976, 1977 by Alan Snyder


	ROUTINES:

	add_trap (name, pos)
	rem_trap (name, pos)		pos == -1 => first one
	pos = find_trap (name)		-1 if none
	pos = next_trap ()		page_length if none
	new_vp (pos)
	trap (name)			do trap
	reset_traps ()
	new_page ()

*/


struct _trapdes {
	int	pos;			/* in VU */
	idn	name;			/* macro to be invoked */
	};

# define trapdes struct _trapdes


trapdes	trap_table [max_traps];
trapdes	*etrap {trap_table};			/* end of trap list */
trapdes	*ctrap {trap_table};			/* next pending trap */
int	vplost {0};				/* vp space lost by trap */

extern	int	vp, lvpu, page_length, page_empty, page_started,
		traps_enabled, page_number, next_page_number,
		current_page_offset, even_page_offset, odd_page_offset;

extern	env	*e;

/**********************************************************************

	ADD_TRAP - Add trap to given macro at given vertical
		position.  The new trap will go after all
		traps of lesser or equal vertical position.
		If the new trap is before the current vertical
		position, it will not become enabled until the
		next page, unless there is another pending trap
		on the current page at a lesser or equal vertical
		position as the new trap.

**********************************************************************/

add_trap (name, pos)	idn name; int pos;

	{trapdes *p, *q;

	if (etrap >= trap_table+max_traps)
		fatal ("too many traps");
	for (p=trap_table;p<etrap;++p)
		if (p->pos > pos)	/* then insert before this one */
			{for (q=etrap;q>p;--q)
				{q->name = q[-1].name;
				q->pos = q[-1].pos;
				}
			break;
			}
	p->name = name;
	p->pos = pos;
	++etrap;
	if (p==ctrap && pos<vp) ++ctrap;
	}

/**********************************************************************

	REM_TRAP - Remove trap of given macro at given vertical
		position.  If POS == -1, remove the first trap
		with the given macro name, if any.

**********************************************************************/

rem_trap (name, pos)	idn name; int pos;

	{trapdes *p;

	for (p=trap_table;p<etrap;++p)
		if (p->name == name && (pos == -1 || p->pos == pos))
			{if (ctrap > p) --ctrap;
			--etrap;
			while (p < etrap)
				{p->name = p[1].name;
				p->pos = p[1].pos;
				++p;
				}
			return;
			}
	}

/**********************************************************************

	FIND_TRAP - Find the vertical position of the first trap
		to the given macro.  Return -1 if there are no
		traps to the given macro.

**********************************************************************/

int find_trap (name)	idn name;

	{trapdes *p;

	for (p=trap_table;p<etrap;++p)
		if (p->name==name) return (p->pos);
	return (-1);
	}

/**********************************************************************

	NEXT_TRAP - Return the vertical position of the next
		pending trap.  Return the page_length if there
		are no pending traps before the end of the
		page.

**********************************************************************/

int next_trap ()

	{if (!traps_enabled) return (infinity);
	if (ctrap<etrap && ctrap->pos < page_length)
		return (ctrap->pos);
	return (page_length);
	}

/**********************************************************************

	NEW_VP - Update the current vertical position to the given
		value.  If there is a pending trap at or before
		this position and within the page_length, enable
		that trap and set the current vertical position
		to that trap position (unless that action would
		decrease the current vertical position).
		Otherwise, if the desired vertical position is
		greater than the page_length, call NEW_PAGE.

**********************************************************************/

new_vp (pos)

	{if (pos < vp) lvpu = 0;
	if (traps_enabled)
		{page_started = TRUE;
		if (ctrap<etrap && pos>=ctrap->pos && ctrap->pos<page_length)
			{idn name;
			if (ctrap->pos>vp) vp = ctrap->pos;
			vplost = max (0, pos-vp);
			name = ctrap->name;
			++ctrap;
			trap (name);
			}
		else if (pos >= page_length)
			{vp = pos;	/* avoid infinite recursion */
			new_page ();
			}
		else vp=pos;
		}
	else vp=pos;
	}

/**********************************************************************

	TRAP

**********************************************************************/

trap (name)
	idn name;

	{int t;
	ac s;
	extern int state;
	t = vu2mil (vp);
	tprint (" *** trap to %s at %dm\n", idn_string (name), t);
	s = getmd (name);
	if (s)
		{extern idn com;
		if (com != -1)	/* we are interrupting a request routine */
			{while (TRUE)	/* so skip remainder of request line */
				{ichar ic;
				ic = getc1 ();
				if (ic == i_newline || ic == i_eof) break;
				}
			}
		push_macro (name, s, 0, 0, 0);
		if (com != -1) push_char (i_newline);	/* request terminator */
		else state = 0;	/* process as new line */
		}
	else error ("trap macro %s undefined", idn_string (name));
	}

/**********************************************************************

	RESET TRAPS

**********************************************************************/

reset_traps ()

	{ctrap = trap_table;}

/**********************************************************************

	NEW_PAGE - Go to the next page

	If the current page has not been finished, then call
	NEW_VP to finish off the page: if there is any pending
	trap, it will be enabled; otherwise, the vertical
	position will be set past the page length and NEW_PAGE
	called (recursively).

**********************************************************************/

new_page ()

	{if (vp < page_length) new_vp (page_length); /* recursion! */
	else
		{output_eop ();
		lvpu = 0;
		vp = 0;
		page_number = next_page_number++;
		current_page_offset = (page_number&1 ? odd_page_offset :
					even_page_offset);
		page_empty = TRUE;
		page_started = FALSE;
		reset_traps ();
		}
	}

