# define vms 1
/*
 * 		     * * *   W A R N I N G    * * *
 *
 * This file has been hand-modified from that which was produced by Yacc
 * from 'lex.y'. If you plan on rebuilding this with Yacc, be SURE to run
 * the virgin supplied 'lex.y' thru Yacc first, do a source compare of it's
 * output 'ytab.c' with this file, and note & understand the manual mods
 * that were made here.
 *						Bob Denny
 *
 * Modified 02-Dec-80 Bob Denny -- Conditionalized debug code for smaller size
 *   				   YYSMALL no longer used.
 *				   Removed hackish accent grave's.
 *			     01	   Moved calls do dfa build, min, print and
 *				    write, and to stat() to lex.c, so this
 *				    module could be put in overlay region.
 *				    Moved impure data out into ytdata.c to
 *				    go to the root.
 *
 *          29-May-81 Bob Denny -- Define yysterm fwd. Remove from LEXLEX.H.
 *                                   for RSX overlaying.
 *          19-Mar-82 Bob Denny -- New compiler and library. Typcasts needed.
 *				    Conditionally compile remote formats, not
 *				    supported in VAX C.
 * More     03-May-82 Bob Denny -- Final touches, remove unreferenced autos
 */

#include <stdio.h>
#include "ytab.h"
#include <ctype.h>

extern char *yysterm[];	/* Hack forward definition */

#line 9 "lex.y"
#include "lexlex.h"

#define streq(a,b)	(stcmp(a,b) != 0)

/* char	copr[] = "Copyright (c) 1978 Charles H. Forsyth";*/

struct des {
	struct nfa *d_start;
	struct nfa *d_final;
};
extern struct nlist {						/* 01+ */
	struct	nlist	*nl_next;
	struct	nfa	*nl_base;
	struct	nfa	*nl_end;
	struct	nfa	*nl_start;
	struct	nfa	*nl_final;
	char	*nl_name;
} *nlist;							/* 01- */
extern	int	str_length;
extern	struct	nfa	*elem();
extern	struct	des	*newdp();
extern	struct	nlist	*lookup();
#define yyclearin yychar = -1
/* #define yyerrok yyerrflag = 0 */
extern int yychar, yyerrflag;

#ifndef	YYSTYPE
#define	YYSTYPE	int
#endif
#ifndef	YYVCOPY
#define	YYVCOPY(x,y)	(x)=(y)
#endif

extern YYSTYPE yyval;						/* 01+ */
extern YYSTYPE *yypv;
extern YYSTYPE yylval;



extern int	nlook;
extern int	yyline;
extern char	*breakc;
extern char	*ignore;
extern char	*illeg;						/* 01- */

yyacr(__np__){

#line 40 "lex.y"
	struct nfa *np, *nbase;
	char *cp;
	struct des *dp;
	struct trans *tp;
	struct nlist *nl;
	int i, c;

switch(__np__){

case 7:
#line 64 "lex.y"
{
		dp = yypv[3];
		nl = yypv[1];
		np = nl->nl_base;
		nl->nl_start = dp->d_start;
		nl->nl_final = dp->d_final;
		nl->nl_end = nfap;
#ifdef DEBUG
		fprintf(lexlog, "NFA (auxiliary definition) for %s\n",
				nl->nl_name);
		nfaprint(dp->d_start, nl->nl_base);
#endif
		nbase = lalloc(i = nl->nl_end-nl->nl_base, sizeof(*nbase),
			"nfa storage");
		copynfa(nl, nbase, dp);
		nl->nl_start = dp->d_start;
		nl->nl_final = dp->d_final;
		nl->nl_end = nbase+i;
		nl->nl_base = nbase;
		nfap = np;
		spccl(nl->nl_name, "ignore", dp, &ignore);
		spccl(nl->nl_name, "break", dp, &breakc);
		spccl(nl->nl_name, "illegal", dp, &illeg);
	} break;
case 8:
#line 85 "lex.y"
{ copycode(); } break;
case 9:
#line 89 "lex.y"
{
		yyval = lookup(yypv[1]);
		((struct nlist *)yyval)->nl_base = nfap;
		if (((struct nlist *)yyval)->nl_start)
#ifdef vms
			yyemsg("redefined", ((struct nlist *)yyval)->nl_name);
#else
			yyemsg("%s redefined", ((struct nlist *)yyval)->nl_name);
#endif
	} break;
case 10:
#line 98 "lex.y"
{ yyval = lookup(yypv[1]); } break;
case 11:
#line 102 "lex.y"
{
		np = elem(CCL, yypv[1]);
		yyval = newdp(np, np->n_succ[0] = elem(FIN));
	} break;
case 12:
#line 106 "lex.y"
{
		cp = yypv[1];
		if (str_length == 0) {
			np = elem(EPSILON);
			yyval = newdp(np, np->n_succ[0] = elem(FIN));
			return;
		}
		yyval = np = elem(*cp++);
		while (--str_length > 0)
			np = np->n_succ[0] = elem(*cp++);
		yyval = newdp(yyval, np->n_succ[0] = elem(FIN));
	} break;
case 13:
#line 118 "lex.y"
{
		if ((nl = yypv[1])->nl_end == 0) {
#ifdef vms
			yyemsg("not defined", nl->nl_name);
#else
			yyemsg("%s not defined", nl->nl_name);
#endif
			nl->nl_base = nl->nl_end = elem(FIN);
			nl->nl_start = nl->nl_final = nl->nl_base;
		}
		yyval = dp = lalloc(1, sizeof(*dp), "dfa input");
		nbase = nfap;
		i = nl->nl_end-nl->nl_base;
		if ((nfap += i) >= &nfa[MAXNFA]) {
			yyemsg("Out of NFA nodes", NULL);
			exit(1);
		}
		copynfa(nl, nbase, dp);
	} break;
case 14:
#line 133 "lex.y"
{
		yyval = dp = yypv[1];
		dp->d_start = newnfa(EPSILON, np = dp->d_start, 0);
		dp->d_final->n_char = EPSILON;
		dp->d_final->n_succ[0] = np;
		dp->d_final->n_succ[1] = np = elem(FIN);
		dp->d_start->n_succ[1] = np;
		dp->d_final = np;
	} break;
case 15:
#line 142 "lex.y"
{
		yyval = dp = yypv[1];
		dp->d_start = newnfa(EPSILON, dp->d_start,
			((struct des *)yypv[3])->d_start);
		dp->d_final->n_char = EPSILON;
		dp->d_final = dp->d_final->n_succ[0] = np = elem(FIN);
		dp = yypv[3];
		dp->d_final->n_char = EPSILON;
		dp->d_final->n_succ[0] = np;
		free(yypv[3]);
	} break;
case 16:
#line 152 "lex.y"
{
		yyval = yypv[1];
		dp = yypv[2];
		np = ((struct des *)yyval)->d_final;
		((struct des *)yyval)->d_final = dp->d_final;
		np->n_char = dp->d_start->n_char;
		np->n_ccl = dp->d_start->n_ccl;
		np->n_succ[0] = dp->d_start->n_succ[0];
		np->n_succ[1] = dp->d_start->n_succ[1];
		free(yypv[2]);
	} break;
case 17:
#line 163 "lex.y"
{ yyval = yypv[2]; } break;
case 18:
#line 167 "lex.y"
{
		ending();
	trans1:
#ifdef DEBUG
		fprintf(lexlog, "\nNFA for complete syntax\n");
		fprintf(lexlog, "state 0\n");
		for (tp = trans; tp < trnsp; tp++)
			fprintf(lexlog, "\tepsilon\t%d\n", tp->t_start-nfa);
		for (tp = trans; tp < trnsp; tp++)
			nfaprint(tp->t_start, nfa);
#else
		;
#endif
								/* 01 */
	} break;
case 19:
#line 182 "lex.y"
{ goto trans1; } break;
case 22:
#line 191 "lex.y"
{
		llactr();
	} break;
case 23:
#line 197 "lex.y"
{ dp = yypv[1];  newtrans(dp->d_start, dp->d_final); } break;
case 24:
#line 198 "lex.y"
{ copycode(); } break;
case 25:
#line 199 "lex.y"
{
		ending();
		while ((c = get()) != EOF)
			putc(c, llout);
	} break;
case 26:
#line 207 "lex.y"
{ action(); } break;
case 27:
#line 211 "lex.y"
{
		if (nlook >= NBPW)
#ifdef vms
			yyemsg("Too many translations with lookahead", NULL);
#else
			yyemsg("More than %d translations with lookahead",
					NBPW);
#endif
		yyval = dp = yypv[1];
		np = dp->d_final;
		np->n_char = EPSILON;
		np->n_flag |= LOOK;
		np->n_succ[0] = ((struct des *)yypv[3])->d_start;
		dp->d_final = ((struct des *)yypv[3])->d_final;
		np->n_look = nlook;
		dp->d_final->n_look = nlook++;
		dp->d_final->n_flag |= FLOOK;
		free(yypv[3]);
	} break;
}
}
int yyeval = 256; /* yyerrval */

#line 228 "lex.y"

/*
 * Lexical analyser
 * (it isn't done with lex...)
 */
extern char	buffer[150];					/* 01 */
extern int	str_length;					/* 01 */

yylex()
{
	register c;
	register char *cp;
	int lno;

	if (yyline == 0)
		yyline++;
loop:
	c = get();
	if (isupper(c)) {
		name(c);
		for (cp = yylval; c = *cp; cp++)
			if (isupper(c))
				*cp = tolower(c);
		return(STRING);
	} else if (islower(c) || c == '_') {
		name(c);
		return(NAME);
	}
	switch (c) {
	case EOF:
		return(0);

	case '[':
		return(cclass());

	case '(':
	case ')':
	case '{':
	case '}':
	case '*':
	case '|':
	case '=':
	case ';':
	case '%':
		return(c);

	case '/':
		if ((c = get()) != '*') {
			un_get(c);
			return('/');
		}
		lno = yyline;
		for (; c != EOF; c = get())
			if (c == '*')
				if ((c = get()) == '/')
					goto loop; else
					un_get(c);
		yyline = lno;
		yyemsg("End of file in comment", NULL);

	case '\'':
	case '"':
		yylval = buffer;
		string(c);
		return(STRING);

	case '\n':
	case ' ':
	case '\t':
		goto loop;

	default:
		yylval = buffer;
		buffer[0] = c;
		buffer[1] = 0;
		str_length = 1;
		return(STRING);
	}
}

extern char	ccl[(NCHARS+1)/NBPC];				/* 01 */

cclass()
{
	register c, i, lc;
	int compl;

	compl = 0;
	for (i = 0; i < sizeof ccl; i++)
		ccl[i] = 0;
	if ((c = get()) == '^')
		compl++; else
		un_get(c);
	lc = -1;
	while ((c = mapc(']')) != EOF) {
		if (c == '-' && lc >= 0) {
			if ((c = mapc(']')) == EOF)
				break;
			for (i = lc; i <= c; i++)
				ccl[i/NBPC] |= 1<<(i%NBPC);
			lc = -1;
			continue;
		}
		ccl[c/NBPC] |= 1<<(c%NBPC);
		lc = c;
	}
	if (compl) {
		for (i = 0; i < sizeof ccl; i++)
			ccl[i] ^= -1;
		if (aflag == 0)
			for (i = 0200; i < (1<<NBPC); i++)
				ccl[i/NBPC] &= ~(1 << (i%NBPC));
	}
	yylval = newccl(ccl);
	return(CCLASS);
}

string(ec)
{
	register char *cp;
	register c;

	for (cp = buffer; (c = mapc(ec)) != EOF;)
		*cp++ = c;
	*cp = 0;
	str_length = cp-buffer;
}

mapc(ec)
{
	register c, v, i;

	if ((c = get()) == ec)
		return(EOF);
	switch(c) {
	case EOF:
		yyemsg("End of file in string", NULL);
		return(c);

	case '\\':
		if ((c = get()) >= '0' && c <= '7') {
			i = 0;
			for (v = 0; c>='0' && c<='7' && i++<3; c = get())
				v = v*010 + c-'0';
			un_get(c);
			return(v&0377);
		}
		switch (c) {
		case 'n':
			return('\n');

		case 't':
			return('\t');

		case 'b':
			return('\b');

		case 'r':
			return('\r');

		case '\n':
			yyline++;
			return(mapc(ec));
		}

	default:
		return(c);
	}
}

name(c)
register c;
{
	register char *cp;

	for (yylval=cp=buffer; isalpha(c) || isdigit(c) || c=='_'; c=get())
		*cp++ = c;
	*cp = 0;
	str_length = cp-buffer;
	un_get(c);
}

/*
 * Miscellaneous functions
 * used only by lex.y
 */
struct nfa *
elem(k, v)
{
	struct nfa *fp;

	fp = newnfa(k, 0, 0);
	if (k == CCL)
		fp->n_ccl = v;
	return(fp);
}

struct des *
newdp(st, fi)
struct nfa *st, *fi;
{
	register struct des *dp;

	dp = lalloc(1, sizeof(*dp), "dfa input");
	dp->d_start = st;
	dp->d_final = fi;
	return(dp);
}

action()
{
	register c;
	int lno, lev;

	newcase(trnsp-trans);
	lno = yyline;
	lev = 0;
	for (; (c = get()) != EOF && (c != '}' || lev); putc(c, llout))
		if (c == '{')
			lev++;
		else if (c == '}')
			lev--;
		else if (c == '\'' || c == '"') {
			putc(c, llout);
			skipstr(c);
		}
	fprintf(llout, "\n         break;\n");
	if (c == EOF) {
		yyline = lno;
		yyemsg("End of file in action", NULL);
	}
}

skipstr(ec)
register ec;
{
	register c;

	while ((c = get()) != ec && c != EOF) {
		putc(c, llout);
		if (c == '\\' && (c = get()) != EOF)
			putc(c, llout);
	}
}


copycode()
{
	int lno;
	register c;

	setlne();
	lno = yyline;
	for (; (c = get()) != EOF; putc(c, llout))
		if (c == '%') {
			if ((c = get()) == '}')
				return;
			un_get(c);
			c = '%';
		}
	yyline = lno;
	yyemsg("Incomplete %{ declaration", NULL);
	exit(1);
}

struct nlist *
lookup(s)
register char *s;
{
	register struct nlist *nl;
	register char *cp;
	int i;
	for (nl = nlist; nl; nl = nl->nl_next)
		if (streq(s, nl->nl_name))
			return(nl);
	nl = lalloc(1, sizeof(*nl), "namelist");
	nl->nl_start = nl->nl_end = nl->nl_base = nl->nl_end = 0;
	nl->nl_next = nlist;
	nlist = nl;
	i = 0;
	nl->nl_name = cp = lalloc(strlen(s) + 1, sizeof(*cp), "namelist");
	strcpy(cp, s);
	return(nl);
}


copynfa(nl, nbase, dp)
struct nlist *nl;
struct des *dp;
struct nfa *nbase;
{
	register struct nfa *np, *ob;
	register j;
	int i;

	ob = nl->nl_base;
	i = nl->nl_end-ob;
/*
 * Assumes Decus compiler: copy(out, in, nbytes)
 */
	copy(nbase, ob, sizeof(*np) * i);
	for (np = nbase; i-- > 0; np++) {
		np->n_flag &= ~NPRT;
		for (j = 0; j < 2; j++)
			if (np->n_succ[j])
				np->n_succ[j] = (np->n_succ[j]-ob)+nbase;
	}
	dp->d_start = (nl->nl_start-ob)+nbase;
	dp->d_final = (nl->nl_final-ob)+nbase;
}

/* #ifdef vms */
copy(out, in, count)
register char	*out;
register char	*in;
register int	count;
/*
 * Block copy for vms -- should be in stdio.lib (in macro)
 */
{
	while (--count >= 0)
		*out++ = *in++;
}
/* #endif */

spccl(nm, isit, dp, where)
char			*nm;
char			*isit;
register struct des	*dp;
char			**where;
{

	if (streq(nm, isit)) {
		if (*where != 0)
#ifdef vms
			yyemsg("Redefinition of class", isit);
#else
			yyemsg("Redefinition of %s class", isit);
#endif
		if (dp->d_start->n_char == CCL &&
				dp->d_start->n_succ[0] == dp->d_final)
			*where = dp->d_start->n_ccl;
		else
#ifdef vms
			yyemsg("Illegal class", isit);
#else
			yyemsg("Illegal %s class", isit);
#endif
	}
}

get()
{
	register int c;

	if ((c = getc(lexin)) == '\n')
		yyline++;
	return(c);
}

un_get(c)
register c;
{
	if (c == '\n')
		yyline--;
	ungetc(c, lexin);
}

#ifdef vms
yyemsg(s, arg)
char *s;
char *arg;
{
	if (yyline)
		fprintf(stderr, "%d: ", yyline);
	fprintf(stderr, "%s", s);
	if(arg != NULL)
		fprintf(stderr, ": \"%s\"", arg);
#else
yyemsg(s)
char *s;
{
	if (yyline)
		fprintf(stderr, "%d: ", yyline);
	fprintf(stderr, "%r", &s);
#endif
	if (yychar > 256)
		fprintf(stderr, " near '%s'", yysterm[yychar-256]);
	else if (yychar < 256 && yychar > 0)
		fprintf(stderr, " near '%c'", yychar);
	fprintf(stderr, "\n");
}







int nterms = 15;
int nnonter = 13;
int nstate = 41;
char *yysterm[] = {
"error",
"NAME",
"CCLASS",
"STRING",
"CONCAT",
0 };

char *yysnter[] = {
"$accept",
"lexfile",
"auxiliary_section",
"translation_section",
"auxiliaries",
"auxiliary",
"namedef",
"regexp",
"name",
"translations",
"translation",
"llactr",
"pattern",
"action" };
#
extern int yychar;

int yylast = 245;
yyexcp(s){
	extern int yydef[];
	switch(s){
	case 1:
		if( yychar == 0 ) return( -1 );
		return( 0 );
	case 2:
		if( yychar == 0 ) return( 19 );
		return( 22 );
		}
	}

yyact[] = {

  23,  40,  32,  23,  29,  32,  23,  15,  32,  23,
  31,  32,  23,  35,  32,  18,  26,  13,  23,  32,
  34,  23,  37,  11,   4,   5,  16,  28,  17,  12,
  19,  19,  10,   9,  22,   6,  27,  25,   3,   8,
   2,   1,   0,   0,  36,   0,   0,   0,   0,   0,
   0,   0,   0,   0,  38,   0,  39,   0,   0,   0,
   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,
   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,
   0,   0,   0,   0,  33,   0,   0,  33,   0,   0,
  33,   0,   0,  33,   0,   0,  30,   0,   0,   0,
   0,   0,  14,  14,   0,   0,   0,   0,   0,   0,
   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,
   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,
   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,
   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,
   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,
   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,
   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,
   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,
   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,
   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,
   0,   0,   0,   0,   0,   0,   0,  24,  20,  21,
  24,  20,  21,  24,  20,  21,  24,  20,  21,  24,
  20,  21,   0,   0,   0,  24,  20,  21,  24,  20,
  21,   0,   0,   7,   7 };
yypact[] = {

 -13,-2000,-2000, -14, -20,-1000, -54,-1000,-1000, -22,
 -22, -21,-1000,-1000,-1000, -19,-1000,-119, -27, -34,
-1000,-1000,-1000, -19,-1000,-1000,-1000, -37,-1000,-1000,
-1000,-1000,-1000, -19, -23, -19, -40,-1000, -28, -31,
-1000 };
yypgo[] = {

   0,  41,  40,  39,  38,  25,  35,  20,  34,  33,
  26,  32,  28,  27 };
yyr1[] = {

   0,   1,   1,   2,   2,   4,   4,   5,   5,   6,
   8,   7,   7,   7,   7,   7,   7,   7,   3,   3,
   9,   9,  11,  10,  10,  10,  13,  12,  12,  -1 };
yyr2[] = {

   0,   2,   0,   3,   2,   2,   1,   4,   2,   1,
   1,   1,   1,   1,   2,   3,   2,   3,   1,   0,
   2,   2,   0,   2,   2,   2,   1,   3,   1,  -1 };
yychk[] = {

   0,  -1,  -2,  -4,  37,  -5,  -6, 257,  -3,  -9,
 -11,  37,  -5,  37, 123,  61, -10, -12,  37,  -7,
 258, 259,  -8,  40, 257, -10,  37,  -7, -13, 123,
 123,  37,  42, 124,  -7,  47,  -7,  59,  -7,  -7,
  41 };
yydef[] = {

   2,  -2,  -2,   0,   0,   6,   0,   9,   1,  18,
   0,   0,   5,   4,   8,   0,  20,   0,   0,  28,
  11,  12,  13,   0,  10,  21,   3,   0,  23,  26,
  24,  25,  14,   0,  16,   0,   0,   7,  15,  27,
  17 };

# define YYFLAG1 -1000
# define YYFLAG2 -2000

/* test me on cases where there are more than one reduction
per state, leading to the necessity to look ahead, and other
arcane flows of control.
*/
# define YYMAXDEPTH 150

/*	parser for yacc output	*/
/* extern YYSTYPE yyval;	-- defined in the table file
 * extern YYSTYPE yylval;	-- defined in the table file
 * extern YYSTYPE *yypv;	-- defined in the table file
 */

#ifdef	DEBUG
#define	LOGOUT	lexlog
#endif

extern int yydebug; /* 1 for debugging */			/* 01+ */

extern YYSTYPE yyv[YYMAXDEPTH]; /* where the values are stored */
extern int yychar; /* current input token number */
extern int yynerrs ;  /* number of errors */
extern int yyerrflag ;  /* error recovery flag */		/* 01- */


yyparse() {

/* extern int yypgo[], yyr1[], yyr2[], yyact[], yypact[];
 * extern int yydef[], yychk[];
 * extern int yylast, yyeval;
 */
   int yys[YYMAXDEPTH];
   int yyj;
   register yyn, yystate, *yyps;

   yystate = 0;
   yychar = -1;
   yynerrs = 0;
   yyerrflag = 0;
   yyps= &yys[0]-1;
   yypv= &yyv[0]-1;

 yystack:    /* put a state and value onto the stack */

#ifdef DEBUG
   if( yydebug  )
	fprintf(LOGOUT, "state %d, value %d, char %d\n",yystate,yyval,yychar);
#endif

   *++yyps = yystate;
   *++yypv = yyval;

 yynewstate:

   yyn = yypact[yystate];

   if( yyn<= YYFLAG1 ){ /* simple state */
      if( yyn == YYFLAG2 && yychar<0 ) yychar = yylex();
      goto yydefault;
      }

   if( yychar<0 ) yychar = yylex();
   if( (yyn += yychar)<0 || yyn >= yylast ) goto yydefault;

   if( yychk[ yyn=yyact[ yyn ] ] == yychar ){ /* valid shift */
      yychar = -1;
      yyval = yylval;
      yystate = yyn;
      if( yyerrflag > 0 ) --yyerrflag;
      goto yystack;
      }

 yydefault:
   /* default state action */

   if( (yyn=yydef[yystate]) == -2 ) yyn = yyexcp( yystate );

  if( yyn == -1 ){ /* accept */
      return( 0 );
      }

   if( yyn == 0 ){ /* error */
      /* error ... attempt to resume parsing */

      switch( yyerrflag ){

      case 0:   /* brand new error */

         ++yynerrs;
         yyemsg("syntax error", NULL);

      case 1:
      case 2: /* incompletely recovered error ... try again */

         yyerrflag = 3;

         /* find a state where "error" is a legal shift action */

         while ( yyps >= yys ) {
            yyn = yypact[*yyps] + yyeval;
            if( yyn>= 0 && yyn < yylast && yychk[yyact[yyn]] == yyeval ){
               yystate = yyact[yyn];  /* simulate a shift of "error" */
               goto yystack;
               }
            yyn = yypact[*yyps];

            /* the current yyps has no shift onn "error", pop stack */

#ifdef DEBUG
            if(yydebug)
		fprintf(LOGOUT, "error recovery pops state %d, uncovers %d\n",
			*yyps, yyps[-1]);
#endif

            --yyps;
            --yypv;
            }

         /* there is no state on the stack with an error shift ... abort */

    abort:
         return(1);


      case 3:  /* no shift yet; clobber input char */

#ifdef DEBUG
         if (yydebug)
		fprintf(LOGOUT, "error recovery discards char %d\n", yychar );
#endif

         if( yychar == 0 ) goto abort; /* don't discard EOF, quit */
         yychar = -1;
         goto yynewstate;   /* try again in the same state */

         }

      }

   /* reduction by production yyn */

#ifdef DEBUG
      if(yydebug) fprintf(LOGOUT, "reduce %d\n",yyn);
#endif

      yyps -= yyr2[yyn];
      yypv -= yyr2[yyn];
/*    YYVCOPY(yyval,yypv[1]);
 */   yyval = yypv[1];
      yyacr(yyn);
         /* consult goto table to find next state */
      yyn = yyr1[yyn];
      yyj = yypgo[yyn] + *yyps + 1;
      if( yyj>=yylast || yychk[ yystate = yyact[yyj] ] != -yyn )
	yystate = yyact[yypgo[yyn]];
      goto yystack;  /* stack new state and value */

   }
