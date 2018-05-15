
/*
 * Copyright (c) 1978 Charles H. Forsyth
 */

/*
 * lex -- find and set base values for `move' vector
 */

#include <stdio.h>
#include "lexlex.h"

/*
 * Choose the best default
 * state for `st'.
 * Only states previous to the
 * current state are considered,
 * as these are guaranteed to
 * exist.
 */
struct dfa *
defalt(st, xsep)
struct dfa *st;
struct xset **xsep;
{
	register struct dfa *dp;
	register unsigned minv, u;
	struct dfa *def;
	struct xset *xse;
	int i;

	xse = *xsep;
	if ((i = xse-sets)==0)
		return(NULL);
	if (lldebug>1)
		fprintf(stderr, "State %d, default:\n", st-dfa);
	minv = -1;
	def = NULL;
	for (dp = dfa; dp < st; dp++)
		if ((u = compat(st, dp, xse)) < minv) {
			if (lldebug>1)
				fprintf(stderr, "\t%d rates %d\n", dp-dfa, u);
			def = dp;
			minv = u;
		}
	if (minv == -1 || 10*(i-minv) < i)
		def = NULL;
	if (lldebug>1 && def)
		fprintf(stderr, "\t%d chosen\n", def-dfa);
	if (def)
		resolve(st, def, xsep);
	return(def);
}

/*
 * State `b' is compatible with,
 * and hence a suitable default state
 * for state `a',
 * if its transitions agree with
 * those of `a', except those for
 * which `a' has transitions to the
 * (alleged) default.
 * Circularity of the default
 * relation is also not allowed.
 * If the state `b' has at least
 * twice as many transitions as `a',
 * it is not even worth considering.
 */
compat(a, b, xse)
struct dfa *a, *b;
struct xset *xse;
{
	register struct dfa *dp;
	register i, c;

	if (a==b || b->df_ntrans >= a->df_ntrans*2)
		return(-1);
	for (dp = b; dp; dp = dp->df_default)
		if (dp == a)
			return(-1);
	i = resolve(a, b, &xse);
	return(i);
}

/*
 * set `sets' to indicate those
 * characters on which the state `a'
 * and its default agree and
 * those characters on which `a'
 * should go to `error' (as the default
 * accepts it, but `a' does not).
 */
resolve(a, def, xsep)
struct dfa *a, *def;
struct xset **xsep;
{
	register struct move *dp;
	register c, i;
	struct xset *xs, *xse;

	xse = *xsep;
	i = xse-sets;
	for (xs = sets; xs < xse; xs++)
		xs->x_defsame = 0;
	for (; def; def = def->df_default)
	for (dp = def->df_base; dp < def->df_max; dp++)
		if (dp->m_check == def) {
			c = dp - def->df_base;
			for (xs = sets; xs < xse; xs++)
				if (c==(xs->x_char&0377)) {
					if (xs->x_set==dp->m_next) {
						xs->x_defsame++;
						i--;
					}
					break;
				}
			if (xs >= xse) {
				xs->x_defsame = 0;
				xs->x_char = c;
				xs->x_set = NULL;
				i++;
				xse++;
			}
		}
	*xsep = xse;
	return(i);
}

/*
 * Choose a base in `move'
 * for the current state.
 * The transitions of that
 * state are in the vector
 * `sets'.
 */
struct move *
stbase(xse)
struct xset *xse;
{
	register a;
	register struct move *base;
	register conflicts;
	struct xset *xs;

	if (xse==sets)
		return(NULL);
	base = move;
	do {
		if (base-move >= NNEXT) {
			error("No space in `move' (stbase)");
			if (lldebug>1)
				dfaprint();
			exit(1);
		}
		conflicts = 0;
		for (xs = sets; xs < xse; xs++) {
			a = xs->x_char&0377;
			if (xs->x_defsame==0 &&
			    (base+a>=move+NNEXT || base[a].m_check!=NULL)) {
				conflicts++;
				base++;
				break;
			}
		}
	} while (conflicts);
	return(base);
}

/*
 * Given a state,
 * its `base' value in `move',
 * and the set of transitions in
 * `sets' (ending near `xse'),
 * set the `move' values.
 */
setbase(st, base, xse)
struct dfa *st;
register struct move *base;
struct xset *xse;
{
	register struct move *dp;
	register struct xset *xs;
	struct move *maxdp;

	st->df_base = base;
	st->df_max = base;
	if (lldebug>1)
		fprintf(stderr, "Setbase: state %d\n", st-dfa);
	if (lldebug>1 && base==0)
		fprintf(stderr, "\tno base\n");
	if (base==NULL)
		return;
	maxdp = base;
	for (xs = sets; xs < xse; xs++)
		if (xs->x_defsame==0) {
			dp = base + (xs->x_char&0377);
			if (dp > maxdp)
				maxdp = dp;
			dp->m_next = xs->x_set;
			dp->m_check = st;
			if (dp-move > llnxtmax)
				llnxtmax = dp-move;
			if (lldebug>1)
			fprintf(stderr, "\t%c nets %d\n",
				xs->x_char&0377, dp-move);
		}
	st->df_max = maxdp+1;
}
