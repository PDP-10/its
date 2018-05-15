/*
 * out2.c  --     Some of Lex's output routines for overlaying, moved
 *		  here from the original out.c as part of size reduction
 *		  effort.
 *	Bob Denny
 *	03-Dec-80
 * More...
 *	Bob Denny
 *	29-May-81	RSX overlaying
 *      19-Mar-82 Bob Denny -- New compiler and library
 *	28-Aug-82 Bob Denny -- Change output format for readability. I know
 *				you UNIX hackers are not going to like this
 *				one.  Add code to generate llstin() per
 *				setting of "-s" switch.  Fix cclprint() to
 *				put 16 "characters" on a line. Clean up
 *				nfaprint().
 *      29-Aug-82 Bob Denny -- Move chprint to root. Add llstin() to
 *				default lexin to stdin for standard I/O
 *				and no-op for stand-alone I/O.  Allows
 *				sdtio-specific code to be removed from
 *				yylex().
 *	31-Aug-82 Bob Denny -- Add lexswitch( ...) to llstin so table
 *				name selected by -t switch is automatically
 *				switched-to at yylex() startup time.  Removed
 *				hard reference to "lextab" from yylex();
 *      30-Oct-82 Bob Denny -- Remove lexswitch() from llstin(). Made it
 *                              impossible to do a real lexswitch()! (dumb.)
 *                              Default the table by statically initializing
 *                              it to NULL and doing the lexswitch only if
 *                              _tabp is NULL.
 */

#include <stdio.h>
#include "lexlex.h"

extern int yyline;

#ifdef DEBUG

nfaprint(np, base)
register struct nfa *np;
struct nfa *base;
{
	register i;

	if (np->n_flag&NPRT)
		return;
	np->n_flag |= NPRT;
	fprintf(lexlog, "state %d\n", np-base);
	switch (np->n_char) {
	case EPSILON:
		for (i = 0; i < 2; i++)
			if (np->n_succ[i])
				fprintf(lexlog, "\tepsilon  %d\n", np->n_succ[i]-base);
		break;
	case FIN:
		fprintf(lexlog, "\tfinal state\n");
		break;
	case CCL:
		fprintf(lexlog, "\t[");
		cclprint(np->n_ccl);
		fprintf(lexlog, "]  %d\n", np->n_succ[0]-base);
		break;
	default:
		putc('\t', lexlog);
		chprint(np->n_char);
		fprintf(lexlog, "  %d\n", np->n_succ[0]-base);
		break;
	}
	putc('\n', lexlog);
	if (np->n_succ[0])
		nfaprint(np->n_succ[0], base);
	if (np->n_succ[1])
		nfaprint(np->n_succ[1], base);
}

cclprint(cp)
register char *cp;
{
	register i;
	register nc;

	nc = 0;
	for (i = 0; i < NCHARS; i++)
		{
		if (cp[i / NBPC] & (1 << (i % NBPC)))
			nc += chprint(i);
		if(nc >= 64)
			{
			nc = 0;
			fprintf(lexlog, "\n\t ");
			}
		}
}

#endif


llactr()
{
	/*
  	 * Prior to generating the action routine, create
	 * the llstin() routine, which initializes yylex(),
	 * per the setting of the "-s" switch.  All hardwired
	 * variables have now been removed from yylex(). This
	 * allows analyzers to be independent of the standard
	 * I/O library and the table name.
	 */
	if(sflag == 0)			/* If stdio flavor */
		{
		fprintf(llout, "\n/* Standard I/O selected */\n");
	   	fprintf(llout, "extern FILE *lexin;\n\n");
		fprintf(llout, "llstin()\n   {\n   if(lexin == NULL)\n");
		fprintf(llout, "      lexin = stdin;\n");
		}
	else				/* Stand-alone flavor */
		{
		fprintf(llout, "\n/* Stand-alone selected */\n");
		fprintf(llout, "\llstin()\n   {\n");
		}
	fprintf(llout, "   if(_tabp == NULL)\n");
	fprintf(llout, "      lexswitch(&%s);\n   }\n\n", tabname);
	fprintf(llout, "_A%s(__na__)\t\t/* Action routine */\n   {\n", tabname);
}

newcase(i)
{
	static int putsw;

	if (!putsw++)
		fprintf(llout, "   switch (__na__)\n      {\n");
	fprintf(llout, "\n      case %d:\n", i);
	setline();
}


setline()
{
	fprintf(llout, "\n#line %d \"%s\"\n", yyline, infile);
}
