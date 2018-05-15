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

extern	char	*llp2;

lexchar()
{
	return(llend<llp2? *llend++&0377: lexgetc());
}
