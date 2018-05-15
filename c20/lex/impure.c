/*
 * impure.c  -- Impure data for ytab.c and min.c
 *
 * Created 02-Dec-80 Bob Denny -- Impure data from ytab.c and min.c moved
 * here so they can reside in overlays.
 * More     19-Mar-82 Bob Denny -- New C library & compiler
 */
#include <stdio.h>
#include "lexlex.h"
#include "ytab.h"

/*
 * min's
 */
struct set **oldpart;
int **newpart;
int nold;
int nnew;

/*
 * ytab's
 */

struct nlist {
	struct	nlist	*nl_next;
	struct	nfa	*nl_base;
	struct	nfa	*nl_end;
	struct	nfa	*nl_start;
	struct	nfa	*nl_final;
	     } *nlist;

#ifndef YYSTYPE
#define YYSTYPE int
#endif

YYSTYPE yyval = 0;
YYSTYPE *yypv;
YYSTYPE yylval = 0;

int nlook = 0;
int yyline = 0;
char *breakc;
char *ignore;
char *illeg;

char buffer[150];
int str_length;

char ccl[(NCHARS+1)/NBPC];

/*
 * Copied from ytab.c just before yyparse() ... kludgy.
 */
#define YYMAXDEPTH 150

/*
 * These are impure data for the parser driver yyparse().
 */

int yydebug = 0;		/* Make this 1 for yyparse() debugging	*/
YYSTYPE yyv[YYMAXDEPTH];
int yychar = -1;
int yynerrs = 0;
int yyerrflag = 0;

