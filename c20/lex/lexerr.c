/*
 * lexerr.c
 *
 * Bob Denny 28-Aug-82
 * Move stdio dependencies to lexerr(), lexget(), lexech() and mapch()
 *
 * This is one of 4 modules in lexlib which depend
 * upon the standard I/O package.
 */

#include <stdio.h>
#include <lex.h>

lexerror(s)
{
	if (yyline)
		fprintf(stderr, "%d: ", yyline);
	fprintf(stderr, "%s", s);
	fprintf(stderr, "\n");
}
