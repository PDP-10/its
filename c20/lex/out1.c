/*
 * Copyright (c) 1978 Charles H. Forsyth
 *
 * Modified 02-Dec-80 Bob Denny -- Conditionalize debug code for smaller size
 *			     01	-- Removed ending() function code from here
 *				    to lex.c, so ytab.c code could share the
 *				    same overlay region as this module.
 *			     02 -- Removed nfaprint(), llactr(), newcase(),
 *				    cclprint(), chprint() and setline(),
 *				    the rest of this can share an overlay.
 *				    They're in 'out2.c'. This is now 'out1.c'.
 *          29-May-81 Bob Denny -- More extern hacking for RSX overlaying.
 *          19-Mar-82 Bob Denny -- New compiler and library
 *          03-May-82 Bob Denny -- Final touches, remove unreferenced autos
 *          28-Aug-82 Bob Denny -- Put "=" into table initializers to make
 *                                  new compiler happy. Add "-s" code to
 *				    supress "#include <stdio.h>" in output.
 *				    Tables output 8 values/line instead of
 *				    16.  Overran R.H. edge on 3 digit octals.
 *				    Change output format for readability.
 *	    31-Aug-82 Bob Denny -- Add lexswitch( ...) to llstin so table
 *				    name selected by -t switch is automatically
 *				    switched-to at yylex() startup time.  Removed
 *				    hard reference to "lextab" from yylex();
 *				    This module generates extern declaration
 *				    for forward reference.
 */

/*
 * lex -- output human- and machine-readable tables
 */

#include <stdio.h>
#include "lexlex.h"

extern char *ignore;
extern char *illeg;
extern char *breakc;

char	strdec[] = {"\n\
struct lextab %s =\t{\n\
\t\t\t%d,\t\t/* Highest state */\n\
\t\t\t_D%s\t/* --> \"Default state\" table */\n\
\t\t\t_N%s\t/* --> \"Next state\" table */\n\
\t\t\t_C%s\t/* --> \"Check value\" table */\n\
\t\t\t_B%s\t/* --> \"Base\" table */\n\
\t\t\t%d,\t\t/* Index of last entry in \"next\" */\n\
\t\t\t%s,\t\t/* --> Byte-int move routine */\n\
\t\t\t_F%s\t/* --> \"Final state\" table */\n\
\t\t\t_A%s\t/* --> Action routine */\n\
\t\t\t%s%s\t/* Look-ahead vector */\n\
"};

char ptabnam[] = { "         " };

/*
 * Print the minimised DFA,
 * and at the same time,
 * construct the vector which
 * indicates final states by
 * associating them with
 * their translation index.
 * (DFA printout supressed ifndef DEBUG. RBD)
 */
dfaprint()
{
	register struct move *dp;
	register struct dfa *st;
	register i;
	int fi, k, l;

	vstart("int _F%s", tabname);
#ifdef DEBUG
	fprintf(lexlog, "\nMinimised DFA for complete syntax\n");
#endif
	for (i = 0; i < ndfa; i++) {
#ifdef DEBUG
		fprintf(lexlog, "\nstate %d", i);
#endif
		st = &dfa[i];
		k = -1;
		if (fi = st->df_name->s_final) {
			k = nfa[fi].n_trans - trans;
#ifdef DEBUG
			fprintf(lexlog, " (final %d[%d])", fi, k);
#endif
			if (nfa[fi].n_flag&FLOOK) {
				k |= (nfa[fi].n_look+1)<<11;
#ifdef DEBUG
				fprintf(lexlog, " restore %d", nfa[fi].n_look);
#endif
			}
		}
		if (l = st->df_name->s_look)
#ifdef DEBUG
			fprintf(lexlog, " look-ahead %o", l);
#else
			;
#endif
		vel(" %d,", k);
#ifdef DEBUG
		k = st->df_name->s_group->s_els[0];
		if (k!=i) {
			fprintf(lexlog, " deleted\n");
			continue;
		}
		fprintf(lexlog, "\n");
		for (dp = st->df_base; dp < st->df_max; dp = range(st, dp))
		if (st->df_default)
		      fprintf(lexlog, "\t.\tsame as %d\n", st->df_default-dfa);
#endif
	}
	vel(" -1,");	/* blocking state */
	vend();
}

#ifdef DEBUG

range(st, dp)
register struct dfa *st;
register struct move *dp;
{
	int low, high, last;
	struct set *s;
	register a;

	while (dp < st->df_max && dp->m_check!=st)
		dp++;
/***************************************************
 * This always returns given the above statement ! *
 ***************************************************/
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
	if (s->s_state==NULL)
		fprintf(lexlog, "\tNULL\n"); else
		fprintf(lexlog, "\t%d\n", s->s_state-dfa);
	return(dp);
}
#endif

heading()
{
	fprintf(llout,
	 "/*\n * Created by DECUS LEX from file \"%s\" %s\n */\n\n",
	 infile, ctime(0));
	if(sflag == 0)			/* If "standalone" switch off */
		{
		fprintf(llout,
			"/*\n * CREATED FOR USE WITH STANDARD I/O\n */\n\n");
		fprintf(llout, "#\n#include <stdio.h>\n");
		}
	else
		fprintf(llout, "/*\n * CREATED FOR STAND-ALONE I/O\n */\n\n");

	fprintf(llout, "#ifdef vms\n");
	fprintf(llout, "#include \"c:lex.h\"\n#else\n");
	fprintf(llout, "#include <lex.h>\n#endif\n\n");
	fprintf(llout, "extern int _lmov%c();\n",
			(ndfa <= 255) ? 'b' : 'i');
	fprintf(llout, "extern struct lextab %s;\t/* Forward reference */\n\n",
		tabname);
}

								/* 02 */
								/* 01 */
dfawrite()
{
	register struct move *dp;
	register i, a;
	struct dfa *st, *def;
	struct set *xp;
	char *xcp;

	setline();
	fprintf(llout, "\n#define\tLLTYPE1\t%s\n", ndfa<=255? "char": "int");
	vstart("LLTYPE1 _N%s", tabname);
	for (i = 0; i <= llnxtmax; i++)
		if (xp = move[i].m_next)
			vel(" %d,", xp->s_state-dfa); else
			vel(" %d,", ndfa);
	vend();
	vstart("LLTYPE1 _C%s", tabname);
	for (i = 0; i <= llnxtmax; i++)
		if (st = move[i].m_check)
			vel(" %d,", st-dfa); else
			vel(" -1,");
	vend();
	vstart("LLTYPE1 _D%s", tabname);
	for (i = 0; i < ndfa; i++)
		if (def = dfa[i].df_default)
			vel(" %d,", def-dfa); else
			vel(" %d,", ndfa); /* refer to blocking state */
	vend();
	vstart("int _B%s", tabname);
	for (i = 0; i < ndfa; i++)
		if (dp = dfa[i].df_base)
			vel(" %d,", dp-move); else
			vel(" 0,");
	vel(" 0,");	/* for blocking state */
	vend();
	if (nlook) {
		fprintf(llout, "char	*llsave[%d];\n", nlook);
		vstart("int _L%s", tabname);
		a = nlook<=NBPC? NCHARS-1: -1;
		for (i = 0; i < ndfa; i++)
			vel(" 0%o,", dfa[i].df_name->s_look&a);
		vel(" 0,");
		vend();
	}
	dospccl(ignore, "LLIGN", "X");
	dospccl(breakc, "LLBRK", "Y");
	dospccl(illeg, "LLILL", "Z");

	i = (7 - strlen(tabname));	/* Yes, 7 */
	xcp = cpystr(ptabnam, tabname);
	*xcp++ = ',';
	while(i--)
		*xcp++ = ' ';
	*xcp = '\0';
	fprintf(llout, strdec,
		tabname, ndfa, ptabnam, ptabnam, ptabnam, ptabnam,
		llnxtmax, ndfa<=255? "_lmovb": "_lmovi", ptabnam, ptabnam,
		nlook? "_L": "", nlook? ptabnam: "NULL,   ");
	refccl(ignore, "Ignore", "X");
	refccl(breakc, "Break", "Y");
	refccl(illeg, "Illegal", "Z");
	fprintf(llout, "\t\t\t};\n");
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
	vstart("char _%s%s", tag, tabname);
	for (n = sizeof(ccls[0]); n--;)
		vel(" 0%o,", *cp++&0377);
	vend();
}

refccl(cp, nm, tag)
char *cp, *nm, *tag;
{
	if (cp==0)
		fprintf(llout, "\t\t\t0,\t\t/* No %s class */\n", nm);
	else
		fprintf(llout, "\t_%s%s,\t/* %s class */\n", tag, tabname, nm);
}

int	vnl;

vstart(t)
{
	vnl = 0;
	fprintf(llout, "\n%r", &t);
	fprintf(llout, "[] =\n   {\n  ");
}

vend()
{
	fprintf(llout, "\n   };\n");
}

vel(s)
char *s;
{
	fprintf(llout, "%r", &s);
	if ((++vnl&07)==0)
		fprintf(llout, "\n  ");
}
							/* 02 */
