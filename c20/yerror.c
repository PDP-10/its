/* sample error actions for OYACC & CC */
struct _token { int type, index, line; };
# define token struct _token
extern int cout;

synerr (line)		{cprint ("\n%d: Syntax Error. Parse So Far:  ", line);}
giveup (line)		{cprint ("\n%d: I Give Up.", line);}
stkovf (line)		{cprint ("\n%d: Parser Stack Overflow", line);}
delmsg (line)		{cprint ("\n%d: Deleted: ", line);}
skpmsg (line)		{cprint ("\n%d: Skipped: ", line);}

qprint (q)		{cputc (' ', cout); prstat (q, cout);}
tprint (tp)		{cputc (' ', cout); ptoken (tp, cout);}
pcursor ()		{prs (" |_", cout);}

stkunf (line)		{cprint ("\n%d: Parser Stack Underflow!", line);}
tkbovf (line)		{cprint ("\n%d: Token Buffer Overflow!", line);}
badtwp (line)		{cprint ("\n%d: Inconsistent Internal Pointers!", line);}
badtok (line, i)	{cprint ("\n%d: Bad Reference to Tok(%d)!", line, i);}

prstat (q, f)

	{char *p;
	extern int sq[];
	extern char *sterm[], *snterm[];

	q = sq[q];
	if (q & 010000) p = snterm[q & 07777];
		else p = sterm[q];
	prs (p, f);
	}

