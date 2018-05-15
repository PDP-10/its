#include <stdio.h>

#ifdef	vms
#include	"c:lex.h"
#else
#include	<lex.h>
#endif

/*)LIBRARY
*/

extern	char	*llp2;

lexpeekc()
{
	return(llend<llp2? *llend&0377: EOF);
}
