
#
/*
 * Copyright (c) 1978 Charles H. Forsyth
 */

/*
 * lex -- output human- and machine-readable tables
 */

#include <stdio.h>
#include "lexlex.h"

extern int sflag;

char	strdec[] = {"\n\
struct\tlextab\t%s = {\n\
\t%d,\t/* last state */\n\
\t_D%s,\t/* defaults */\n\
\t_N%s,\t/* next */\n\
\t_C%s,\t/* check */\n\
\t_B%s,\t/* base */\n\
\t%d,\t/* last in base */\n\
\t%s,\t/* byte-int move routines */\n\
\t_F%s,\t/* final state descriptions */\n\
\t_A%s,\t/* action routine */\n\
\t%s%s,\t/* look-ahead vector */\n\
"};

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
				fprintf(lexlog,
					"\tepsilon  %d\n", np->n_succ[i]-base);
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
	fprintf(lexlog, "\n");
	if (np->n_succ[0])
		nfaprint(np->n_succ[0], base);
	if (np->n_succ[1])
		nfaprint(np->n_succ[1], base);
}

cclprint(cp)
register char *cp;
{
	register i;

	for (i = 0; i < NCHARS; i++)
		if (cp[i/NBPC]&(1<<(i%NBPC)))
			chprint(i);
}

chprint(ch)
{
	register char *s;

	ch &= 0377;
	switch (ch) {
	case '\t':
		s = "\\t";
		break;
	case '\n':
		s = "\\n";
		break;
	case '\b':
		s = "\\b";
		break;
	case '\r':
		s = "\\r";
		break;
	default:
		fprintf(lexlog, (ch<040 || ch>=0177) ? "\\%o": "%c", ch);
		return;
	}
	fprintf(lexlog, s);
}


/*
 * print the minimised DFA,
 * and at the same time,
 * construct the vector which
 * indicates final states by
 * associating them with
 * their translation index.
 */
dfaprint()
{
	register struct move *dp;
	register struct dfa *st;
	register i;
	int fi, k, l;

	vstart("int _", "F", tabname);
	fprintf(lexlog, "\nMinimised DFA for complete syntax\n");
	for (i = 0; i < ndfa; i++) {
		fprintf(lexlog, "\nstate %d", i);
		st = &dfa[i];
		k = -1;
		if (fi = st->df_name->s_final) {
			k = nfa[fi].n_trans - trans;
			fprintf(lexlog, " (final %d[%d],)", fi, k);
			if (nfa[fi].n_flag&FLOOK) {
				k |= (nfa[fi].n_look+1)<<11;
				fprintf(lexlog, " restore %d", nfa[fi].n_look);
			}
		}
		if (l = st->df_name->s_look)
			fprintf(lexlog, " look-ahead %o", l);
		veld(k);
/*
		k = st->df_name->s_group->s_els[0];
		if (k!=i) {
			fprintf(lexlog, " deleted\n");
			continue;
		}
*/
		fprintf(lexlog, "\n");
		for (dp = st->df_base; dp < st->df_max; dp = range(st, dp))
			;
		if (st->df_default)
			fprintf(lexlog, "\t.\tsame as %d\n",
				st->df_default-dfa);
	}
	veld(-1);	/* blocking state */
	vend();
}

range(st, dp)
register struct dfa *st;
register struct move *dp;
{
	int low, high, last;
	struct set *s;
	register a;

	while (dp < st->df_max && dp->m_check!=st)
		dp++;
	if (dp >= st->df_max)
		return(dp);
	low = dp - st->df_base;
/*
	s = dp->m_next->s_group->s_els[0];
*/
	s = dp->m_next;
	for (last = low-1; dp < st->df_max &&
			   dp->m_check==st &&
			   (a = dp - st->df_base)==last+1 &&
/*
			   dp->m_next->s_state->s_els[0]==s; dp++)
*/
			   dp->m_next==s; dp++)
		last = a;
	high = last;
	fprintf(lexlog, "\t");
	if (high==low)
		chprint(low);
	else {
		fprintf(lexlog, "[");
		if (high-low > 4) {
			chprint(low);
			fprintf(lexlog, "-");
			chprint(high);
		} else {
			while (low<=high)
				chprint(low++);
		}
		fprintf(lexlog, "]");
	}
	if (s == NULL || s->s_state == NULL)
		fprintf(lexlog, "\tNULL\n");
	else
		fprintf(lexlog, "\t%d\n", s->s_state-dfa);
	return(dp);
}

heading()
{
	fprintf(llout, "\
\#include <stdio.h>\n\
\#ifdef	vms\n\
\#include	\"c:lex.h\"\n\
\#else\n\
\#include	<lex.h>\n\
\#endif\n");
	fprintf(llout, "extern int _lmov%c();\n",
			(ndfa <= 255) ? 'b' : 'i');
}

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
	fprintf(llout, "extern struct lextab %s;\n", tabname);
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

/*
llactr()
{
	fprintf(llout, "_A%s(__na__) {\n", tabname);
}
*/

newcase(i)
{
	static int putsw;

	if (!putsw++)
		fprintf(llout, "\tswitch (__na__) {\n");
	fprintf(llout, "\tcase %d:\n", i);
	setlne();
}

ending()
{
	static int ended;

	if (ended++)
		return;
	fprintf(llout, "\t}\n\treturn(LEXSKIP);\n}\n");
	setlne();
}

dfawrite()
{
	register struct move *dp;
	register i, a;
	int k, base, nr, c;
	struct dfa *st, *def;
	struct set *xp;

	setlne();
	fprintf(llout, "\n#define\tLLTYPE1\t%s\n", ndfa<=255? "char": "int");
	vstart("LLTYPE1 _", "N", tabname);
	for (i = 0; i <= llnxtmax; i++)
		if (xp = move[i].m_next)
			veld(xp->s_state-dfa); else
			veld(ndfa);
	vend();
	vstart("LLTYPE1 _", "C", tabname);
	for (i = 0; i <= llnxtmax; i++)
		if (st = move[i].m_check)
			veld(st-dfa); else
			veld(-1);
	vend();
	vstart("LLTYPE1 _", "D", tabname);
	for (i = 0; i < ndfa; i++)
		if (def = dfa[i].df_default)
			veld(def-dfa); else
			veld(ndfa); /* refer to blocking state */
	vend();
	vstart("int _", "B", tabname);
	for (i = 0; i < ndfa; i++)
		if (dp = dfa[i].df_base)
			veld(dp-move); else
			veld(0);
	veld(0);	/* for blocking state */
	vend();
	if (nlook) {
		fprintf(llout, "char	*llsave[%d];\n", nlook);
		vstart("int _", "L", tabname);
		a = nlook<=NBPC? NCHARS-1: -1;
		for (i = 0; i < ndfa; i++)
			velo(dfa[i].df_name->s_look&a);
		velo(0);
		vend();
	}
	dospccl(ignore, "LLIGN", "X");
	dospccl(breakc, "LLBRK", "Y");
	dospccl(illeg, "LLILL", "Z");

	fprintf(llout, strdec,
		tabname, ndfa, tabname, tabname, tabname, tabname,
		llnxtmax, ndfa<=255? "_lmovb": "_lmovi", tabname, tabname,
		nlook? "_L": "", nlook? tabname: "NULL");
	refccl(ignore, "ignore", "X");
	refccl(breakc, "break", "Y");
	refccl(illeg, "illegal", "Z");
	fprintf(llout, "};\n");
	fclose(llout);
}

dospccl(cp, s, tag)
register char *cp;
char *s, *tag;
{
	register n;

	if (cp==0)
		return;
	fprintf(llout, "#define\t%s\t%s\n", s, s);
	vstart("char _", tag, tabname);
	for (n = sizeof(ccls[0]); n--;)
		velo(*cp++&0377);
	vend();
}

refccl(cp, nm, tag)
char *cp, *nm, *tag;
{
	if (cp==0)
		fprintf(llout, "\t0,\t/* no %s class */\n", nm); else
		fprintf(llout, "\t_%s%s,\t/* %s class */\n", tag,
			tabname, nm);
}

int	vnl;

static
vstart(def, tag, name)
char		*def, *tag, *name;
{
	vnl = 0;
	fprintf(llout, "\n%s%s%s[] = {\n", def, tag, name);
}

vend()
{
	fprintf(llout, "\n};\n");
}

veld(e)
int		e;
/*
 * Print decimal value e
 */
{
	fprintf(llout, " %d,", e);
	veol();
}

velo(e)
int		e;
/*
 * Print octal value e
 */
{
	fprintf(llout, " 0%o,", e);
	veol();
}

veol()
/*
 * End of line
 */
{
	if ((++vnl & 017) == 0)
		fprintf(llout, "\n");
}

setlne()
{
	fprintf(llout, "\n#line %d \"%s\"\n", yyline, infile);
}
