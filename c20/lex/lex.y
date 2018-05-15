/*
 * Copyright (c) 1978 Charles H. Forsyth
 */

/*
 *		W A R N I N G
 *
 * This file is NOT identical with ytab.c.  Several changes which were
 * made directly to ytab.c have not been made to lex.y
 *
 * If you have access to yacc and rebuild ytab.c from lex.y, it is
 * essential that you compare the current ytab.c with the new version,
 * incorporating the necessary changes.
 */

/*
 * lex -- grammar/lexical analyser
 */

%{
#include <stdio.h>
#include "lexlex.h"
char	copr[]	"Copyright (c) 1978 Charles H. Forsyth";
struct des {
	struct nfa *d_start;
	struct nfa *d_final;
};
struct nlist {
	struct	nlist	*nl_next;
	struct	nfa	*nl_base;
	struct	nfa	*nl_end;
	struct	nfa	*nl_start;
	struct	nfa	*nl_final;
	char	*nl_name;
} *nlist;
int	strlen;
extern	struct	nfa	*elem();
extern	struct	des	*newdp();
extern	struct	nlist	*lookup();
extern	char		*spccl();
%}
%term NAME CCLASS STRING CONCAT

%left ';'
%left '='
%left '/'
%left '|'
%left '(' NAME STRING CCLASS
%left CONCAT
%left '*'
%%
%{
	struct nfa *np, *nbase;
	char *cp;
	struct des *dp;
	struct trans *tp;
	struct nlist *nl;
	int i, c;
%}
lexfile:
	auxiliary_section translation_section
|
;

auxiliary_section:
	auxiliaries '%' '%'
|	'%' '%'
;

auxiliaries:
	auxiliaries auxiliary
|	auxiliary
;

auxiliary:
	namedef '=' regexp ';' ={
		dp = $3;
		nl = $1;
		np = nl->nl_base;
		nl->nl_start = dp->d_start;
		nl->nl_final = dp->d_final;
		nl->nl_end = nfap;
		printf("NFA for %s\n", nl->nl_name);
		nfaprint(dp->d_start, nl->nl_base);
		nbase = lalloc(i = nl->nl_end-nl->nl_base, sizeof(*nbase),
			"nfa storage");
		copynfa(nl, nbase, dp);
		nl->nl_start = dp->d_start;
		nl->nl_final = dp->d_final;
		nl->nl_end = nbase+i;
		nl->nl_base = nbase;
		nfap = np;
		ignore = spccl(nl->nl_name, "ignore", dp);
		breakc = spccl(nl->nl_name, "break", dp);
		illeg = spccl(nl->nl_name, "illegal", dp);
	}
|	'%' '{'		={ copycode(); }
;

namedef:
	NAME	={
		$$ = lookup($1);
		$$->nl_base = nfap;
		if ($$->nl_start)
			error("%s redefined", $$->nl_name);
	}
;

name:
	NAME	={ $$ = lookup($1); }
;

regexp:
	CCLASS ={
		np = elem(CCL, $1);
		$$ = newdp(np, np->n_succ[0] = elem(FIN));
	}
|	STRING ={
		cp = $1;
		if (strlen == 0) {
			np = elem(EPSILON);
			$$ = newdp(np, np->n_succ[0] = elem(FIN));
			return;
		}
		$$ = np = elem(*cp++);
		while (--strlen > 0)
			np = np->n_succ[0] = elem(*cp++);
		$$ = newdp($$, np->n_succ[0] = elem(FIN));
	}
|	name	={
		if ((nl = $1)->nl_end == 0) {
			error("%s not defined", nl->nl_name);
			nl->nl_base = nl->nl_end = elem(FIN);
			nl->nl_start = nl->nl_final = nl->nl_base;
		}
		$$ = dp = lalloc(1, sizeof(*dp), "dfa input");
		nbase = nfap;
		i = nl->nl_end-nl->nl_base;
		if ((nfap += i) >= &nfa[MAXNFA]) {
			error("Out of NFA nodes");
			exit(1);
		}
		copynfa(nl, nbase, dp);
	}
|	regexp '*' ={
		$$ = dp = $1;
		dp->d_start = newnfa(EPSILON, np = dp->d_start, 0);
		dp->d_final->n_char = EPSILON;
		dp->d_final->n_succ[0] = np;
		dp->d_final->n_succ[1] = np = elem(FIN);
		dp->d_start->n_succ[1] = np;
		dp->d_final = np;
	}
|	regexp '|' regexp ={
		$$ = dp = $1;
		dp->d_start = newnfa(EPSILON, dp->d_start, $3->d_start);
		dp->d_final->n_char = EPSILON;
		dp->d_final = dp->d_final->n_succ[0] = np = elem(FIN);
		dp = $3;
		dp->d_final->n_char = EPSILON;
		dp->d_final->n_succ[0] = np;
		cfree($3);
	}
|	regexp regexp %prec CONCAT ={
		$$ = $1;
		dp = $2;
		np = $$->d_final;
		$$->d_final = dp->d_final;
		np->n_char = dp->d_start->n_char;
		np->n_ccl = dp->d_start->n_ccl;
		np->n_succ[0] = dp->d_start->n_succ[0];
		np->n_succ[1] = dp->d_start->n_succ[1];
		cfree($2);
	}
|	'(' regexp ')' ={ $$ = $2; }
;

translation_section:
	translations ={
		ending();
	trans1:
		printf("\nNFA for complete syntax\n");
		printf("state 0\n");
		for (tp = trans; tp < transp; tp++)
			printf("\tepsilon\t%d\n", tp->t_start-nfa);
		for (tp = trans; tp < transp; tp++)
			nfaprint(tp->t_start, nfa);
		dfabuild();
		dfamin();
		dfaprint();
		dfawrite();
		stats();
	}
|	={ goto trans1; }
;

translations:
	translations translation
|	llactr translation
;

llactr:
	={
		llactr();
	}
;

translation:
	pattern action ={ dp = $1;  newtrans(dp->d_start, dp->d_final); }
|	'%' '{'		={ copycode(); }
|	'%' '%'		={
		ending();
		while ((c = get()) != EOF)
			putc(c, llout);
	}
;

action:
	'{'	={ action(); }
;

pattern:
	regexp '/' regexp ={
		if (nlook >= NBPW)
			error("More than %d translations with lookahead",NBPW);
		$$ = dp = $1;
		np = dp->d_final;
		np->n_char = EPSILON;
		np->n_flag |= LOOK;
		np->n_succ[0] = $3->d_start;
		dp->d_final = $3->d_final;
		np->n_look = nlook;
		dp->d_final->n_look = nlook++;
		dp->d_final->n_flag |= FLOOK;
		cfree($3);
	}
|	regexp
;

%%
/*
 * Lexical analyser
 * (it isn't done with lex...)
 */
char	buffer[150];

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
			unget(c);
			return('/');
		}
		lno = yyline;
		for (; c != EOF; c = get())
			if (c == '*')
				if ((c = get()) == '/')
					goto loop; else
					unget(c);
		yyline = lno;
		error("End of file in comment");

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
		if (c == '\\') {
			unget(c);
			c = mapch(EOF);
		}
		buffer[0] = c;
		buffer[1] = 0;
		strlen = 1;
		return(STRING);
	}
}

char	ccl[(NCHARS+1)/NBPC];

cclass()
{
	register c, i, lc;
	int compl;

	compl = 0;
	for (i = 0; i < sizeof ccl; i++)
		ccl[i] = 0;
	if ((c = get()) == '^')
		compl++; else
		unget(c);
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
	strlen = cp-buffer;
}

mapc(ec)
{
	register c, v, i;

	if ((c = get()) == ec)
		return(EOF);
	switch(c) {
	case EOF:
		error("End of file in string");
		return(c);

	case '\\':
		if ((c = get()) >= '0' && c <= '7') {
			i = 0;
			for (v = 0; c>='0' && c<='7' && i++<3; c = get())
				v = v*010 + c-'0';
			unget(c);
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
	strlen = cp-buffer;
	unget(c);
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

	newcase(transp-trans);
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
	fprintf(llout, "\n\tbreak;\n");
	if (c == EOF) {
		yyline = lno;
		error("End of file in action");
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

	setline();
	lno = yyline;
	for (; (c = get()) != EOF; putc(c, llout))
		if (c == '%') {
			if ((c = get()) == '}')
				return;
			unget(c);
			c = '%';
		}
	yyline = lno;
	error("Incomplete %{ declaration");
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
	for (cp = s; *cp++;)
		i++;
	nl->nl_name = cp = lalloc(i+1, sizeof(*cp), "namelist");
	while (*cp++ = *s++)
		;
	return(nl);
}

copynfa(nl, nbase, dp)
struct nlist *nl;
struct des *dp;
struct nfa *nbase;
{
	register struct nfa *np, *ob;
	register j;
	int i, ix;

	ob = nl->nl_base;
	i = nl->nl_end-ob;
	copy(ob, sizeof(*np), i, nbase);
	for (np = nbase; i-- > 0; np++) {
		np->n_flag &= ~NPRT;
		for (j = 0; j < 2; j++)
			if (np->n_succ[j])
				np->n_succ[j] = (np->n_succ[j]-ob)+nbase;
	}
	dp->d_start = (nl->nl_start-ob)+nbase;
	dp->d_final = (nl->nl_final-ob)+nbase;
}

char *
spccl(nm, isit, dp)
char *nm, *isit;
register struct des *dp;
{
	if (!streq(nm, isit))
		return(0);
	if (dp->d_start->n_char == CCL &&
	    dp->d_start->n_succ[0] == dp->d_final)
		return(dp->d_start->n_ccl);
	error("Illegal %s class", isit);
	return(0);
}

get()
{
	register c;

	if ((c = getc(stdin)) == '\n')
		yyline++;
	return(c);
}

unget(c)
register c;
{
	if (c == '\n')
		yyline--;
	ungetc(c, stdin);
}

error(s)
char *s;
{
	if (yyline)
		fprintf(stderr, "%d: ", yyline);
	fprintf(stderr, "%r", &s);
	if (yychar > 256)
		fprintf(stderr, " near `%s'", yysterm[yychar-256]);
	else if (yychar < 256 && yychar > 0)
		fprintf(stderr, " near `%c'", yychar);
	fprintf(stderr, "\n");
}
