/*
 * mapch -- handle escapes within strings
 */

/*
 * mapch.c
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

extern FILE *lexin;

mapch(delim, esc)
{
	register c, octv, n;

	if ((c = lexchar())==delim)
		return(EOF);
	if (c==EOF || c=='\n') {
		lexerror("Unterminated string");
		ungetc(c, lexin);
		return(EOF);
	}
	if (c!=esc)
		return(c);
	switch (c=lexchar()) {
	case 't':
		return('\t');
	case 'n':
		return('\n');
	case 'f':
		return('\f');
	case '\"': case '\'':
		return(c);
	case 'e':
		return('\e');
	case 'p':
		return(033);
	case 'r':
		return('\r');
	case '0': case '1': case '2': case '3':
	case '4': case '5': case '6': case '7':
		octv = c-'0';
		for (n = 1; (c = lexchar())>='0' && c<='7' && n<=3; n++)
			octv = octv*010 + (c-'0');
		ungetc(c, lexin);
		return(octv);
	case '\n':
		yyline++;
		return(mapch(delim, esc));
	}
	return(c);
}
