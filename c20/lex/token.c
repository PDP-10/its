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

char *
token(cpp)
char **cpp;
{
	if (cpp)
		*cpp = llend;
	return(llbuf);
}
