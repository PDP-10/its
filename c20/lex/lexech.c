/*
 * lexech.c
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

lexecho(fp)
register FILE *fp;
{
	register char *lp;

	for (lp = llbuf; lp < llend;)
		putc(*lp++, fp);
}
