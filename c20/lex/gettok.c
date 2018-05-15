/*
 * Bob Denny 28-Aug-82  Remove reference to stdio.h
 */
#ifdef	vms
#include	"c:lex.h"
#else
#include	<lex.h>
#endif

/*)LIBRARY
*/

gettoken(lltb, lltbsiz)
char *lltb;
{
	register char *lp, *tp, *ep;

	tp = lltb;
	ep = tp+lltbsiz-1;
	for (lp = llbuf; lp < llend && tp < ep;)
		*tp++ = *lp++;
	*tp = 0;
	return(tp-lltb);
}
