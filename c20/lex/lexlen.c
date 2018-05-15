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

lexlength()
/*
 * Return the length of the current token
 */
{
	return(llend - llbuf);
}
