/*
 * Copyright (c) 1978 Charles H. Forsyth
 */

#include <stdio.h>
#include "lexlex.h"

/*
 * Construct the
 * epsilon closure of
 * a given set; this is
 * the set of states that may
 * be reached by some number of
 * epsilon transitions from
 * that state.
 */
struct set *
eclosure(t)
struct set *t;
{
	register struct nfa *np, *xp;
	register i;
	struct nfa **sp, **tp, **ip, *stack[MAXNFA], *temp[MAXNFA];

	tp = temp;
	for (sp = stack, i = 0; i < t->s_len; i++)
		if (sp <= stack+MAXNFA)
			*tp++ = *sp++ = t->s_els[i];
		else {
			error("Stack overflow in `eclosure'");
			exit(1);
		}
	while (sp > stack) {
		np = *--sp;
		if (np->n_char==EPSILON)
		for (i = 0; i < 2; i++)
			if (xp = np->n_succ[i]) {
				for (ip = temp; ip < tp;)
					if (*ip++ == xp)
						goto cont;
				if (tp >= temp+MAXNFA) {
					error("eclosure: list overflow");
					exit(1);
				}
				*sp++ = *tp++ = xp;
			cont:;
			}
	}
	t = newset(temp, tp-temp, 1);
	return(t);
}

