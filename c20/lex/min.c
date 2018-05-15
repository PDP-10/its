# define MIN 1			/* PLB */
/*
 * Copyright (c) 1978 Charles H. Forsyth
 *
 * Modified 02-Dec-80 Bob Denny -- Conditionalize debug code for smaller size
 *  Also note other mods. Now minimization is turned on at run time by '-m'.
 * More     19-Mar-82 Bob Denny -- New C library & compiler
 *  This routine is unimplemented. Define MIN to turn it on. Have fun.
 */

/*
 * lex -- dfa minimisation routines
 */

#include <stdio.h>
#include "lexlex.h"

#ifdef	MIN
#else
/*
 * Dummy routine
 */
dfamin()
{
}
#endif

#ifdef	MIN
extern int mflag;

member(e, v, i)
register e, *v, i;
{

	while (i--)
		if (e==*v++)
			return(1);
	return(0);
}

extern struct set **oldpart;
extern int **newpart;
extern int nold, nnew;

struct	xlist {
	struct	set	*x_set;
	struct	trans	*x_trans;
	      };

xcomp(a, b)
struct xlist *a, *b;
{
	if (a->x_trans > b->x_trans)
		return(1);
	if (a->x_trans==b->x_trans)
		return(0);
	return(-1);
}

dfamin()
{
	struct xlist *temp, *tp, *xp, *zp;
	struct trans *trp;
	int *tp2, *ip;
	struct set *gp, **xch;
	int i, j, k, niter;

	if(mflag == 0) return;		/*** NOTE ***/

#ifdef DEBUG
	fprintf(lexlog, "\nDFA minimisation (%d states)\n", ndfa);
#endif

	temp = lalloc(ndfa, sizeof(*temp), "minimisation");
	oldpart = lalloc(ndfa, sizeof(*oldpart), "minimisation");
	newpart = lalloc(ndfa*2+1, sizeof(*newpart), "minimisation");
	setlist = 0;
/*
 * partition first into final
 * states which identify different
 * translations, and non-final
 * states.
 */
	tp = temp;
	for (i = 0; i < ndfa; i++, tp++) {
		tp->x_set = dfa[i].df_name;
		if (tp->x_set->s_final)
			tp->x_trans = nfa[tp->x_set->s_final].n_trans; else
			tp->x_trans = 0;
	}
	qsort(temp, tp-temp, sizeof(*tp), xcomp);
	for (xp = temp; xp < tp; xp = zp) {
		ip = newpart;
		for (zp = xp; zp < tp && zp->x_trans==xp->x_trans; zp++)
			*ip++ = zp->x_set->s_state-dfa;
		oldpart[nold++] = newset(newpart, ip-newpart, 0);
	}
	free(temp);
/*
 * create a new partition,
 * by considering each group in
 * the old partition.  For each
 * such group, create new subgroups
 * such that two states are in the
 * same subgroup iff they have
 * transitions on the same set of
 * characters into the same
 * set of groups in the old partition.
 * repeat this process until
 * a fixed point is reached.
 */
	niter = 0;
	do {
		niter++;

#ifdef DEBUG
		fprintf(lexlog, "\n%d groups in partition %d\n", nold, niter);
#endif

		for (i = 0; i < nold; i++) {
			fprintf(lexlog, "group %d: ", i);
			pset(oldpart[i], 0);
			fprintf(lexlog, "\n");
		}
		nnew = 0;
		tp2 = newpart;
		for (i = 0; i < nold; i++) {
			gp = oldpart[i];
			for (j = 0; j < gp->s_len; j++) {
				if (member(gp->s_els[j], newpart, tp2-newpart))
					continue;
				*tp2++ = gp->s_els[j];
				for (k = 0; k < gp->s_len; k++)
					if (k!=j &&
					    !member(gp->s_els[k], newpart,
						tp2-newpart) &&
					    eqstate(gp->s_els[j],gp->s_els[k]))
						*tp2++ = gp->s_els[k];
				*tp2++ = -1;
			}
		}
		*tp2++ = -1;
		for (tp2 = newpart; *tp2 != -1; tp2 = ++ip) {
			for (ip = tp2; *ip != -1; ip++)
				;
			oldpart[nnew++] = newset(tp2, ip-tp2, 0);
		}
		i = nold; nold = nnew; nnew = i;
	} while (nnew!=nold);

#ifdef DEBUG
	if (ndfa==nnew)
		fprintf(lexlog, "\nno states saved by minimisation\n"); else
		fprintf(lexlog, "\n%d states saved by minimisation\n", ndfa-nnew);
#endif

	free(newpart);
	free(oldpart);
}

eqstate(a, b)
{
	register struct move *dp1, *dp2;

/**  dfa vector has no element 'df_moves', transition entries have no elements
        df_char nor df_set. Obviously unimplemented stuff.

	dp1 = dfa[a].df_moves;
	dp2 = dfa[b].df_moves;
	for (; dp1->df_set; dp1++, dp2++)
		if (dp2->df_set==0)
			return(0);
		else if (dp1->df_char != dp2->df_char ||
			 dp1->df_set->s_group != dp2->df_set->s_group)
			return(0);
	return(dp2->df_set==0);
**/

}
#endif
