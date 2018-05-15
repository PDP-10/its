/*
 * lexget.c
 *
 * Bob Denny 28-Aug-82
 * Move stdio dependencies to lexerr(), lexget(), lexech() and mapch()
 *
 * This is one of 4 modules in lexlib which depend
 * upon the standard I/O package.
 */

#include <stdio.h>
#ifdef	vms
#include	"c:lex.h"
#else
#include	<lex.h>
#endif

/*)LIBRARY
*/

FILE *lexin;                           /* File pointer moved to here */

lexgetc()
{
	return(getc(lexin));
}
