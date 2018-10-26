# include "cc.h"
# include "c2.h"

/*

	C COMPILER
	Phase P: Parser
	Section 1: Parser and Control

	Copyright (c) 1976, 1977 by Alan Snyder

*/

/**********************************************************************

	CONTROL VARIABLES

**********************************************************************/

int	f_node,		/* tree output file */
	f_error -1,	/* error message file */
	f_mac,		/* macro output file */
	f_symtab,	/* symbol table output file */
	lc_node 1,	/* node location counter */
	sflag,		/* indicates to write symbol table */
	nodeno 1;

char	*fn_typtab,
	*fn_node,
	*fn_error,
	*fn_mac,
	*fn_hmac,
	*fn_symtab;

# ifndef MERGE_LP

int	f_token;	/* token input file */
char	*fn_token;

# endif

# ifdef MERGE_LP

extern	int	f_source,	/* source file */
		f_string;	/* string file */

extern	char	*fn_source,	/* source file name */
		*fn_string,	/* string file name */
		*fn_cstore;	/* cstore file name */

# endif

char	nodelen [] {
# include "cnlen.h"
	};

/**********************************************************************

	MAIN - PARSER MAIN ROUTINE

**********************************************************************/

# ifdef MERGE_LP
# define MAXN 11
# endif
# ifndef MERGE_LP
# define MAXN 9
# endif

main (argc, argv) int argc; char *argv[];

	{if (argc < MAXN)
		{cprint ("Phase P called with too few arguments.\n");
		cexit (100);
		}

	poptions (argv[1]);
	setfiles (argv);

# ifdef MERGE_LP

	lxinit ();

# endif

	if (argc > MAXN) rtdata (argv[MAXN]);
	pinit ();
	parse ();
	cleanup (0);
	}

/**********************************************************************

	POPTIONS - Process Debugging Options

**********************************************************************/

poptions (s)
	char *s;

	{int c;
	extern int debug, edebug, tflag, xflag;

	while (c = *s++) switch (c) {
		case 'd':	debug = TRUE; break;
		case 'e':	edebug = TRUE; break;
		case 's':	sflag = TRUE; break;
		case 't':	tflag = TRUE; break;
		case 'x':	xflag = TRUE; break;
		}
	}

/**********************************************************************

	SETFILES - Set File Names

**********************************************************************/

setfiles (argv)
	char *argv[];

	{

# ifndef MERGE_LP

	fn_token = argv[2];
	fn_node = argv[3];
	fn_typtab = argv[4];
	fn_error = argv[5];
	fn_mac = argv[6];
	fn_hmac = argv[7];
	fn_symtab = argv[8];

# endif

# ifdef MERGE_LP

	fn_source = argv[2];
	fn_node = argv[3];
	fn_typtab = argv[4];
	fn_error = argv[5];
	fn_mac = argv[6];
	fn_cstore = argv[7];
	fn_string = argv[8];
	fn_hmac = argv[9];
	fn_symtab = argv[10];

# endif

	}

/**********************************************************************

	RTDATA - Read Target Machine Data File

**********************************************************************/

rtdata (fn_tdata)
	char *fn_tdata;

	{int f;

	f = xopen (fn_tdata, MREAD, BINARY);
	tsize[TTCHAR] = geti (f);
	tsize[TTINT] = geti (f);
	tsize[TTFLOAT] = geti (f);
	tsize[TTDOUBLE] = geti (f);
	talign[TTCHAR] = geti (f);
	talign[TTINT] = geti (f);
	talign[TTFLOAT] = geti (f);
	talign[TTDOUBLE] = geti (f);
	calign[0] = geti (f);
	calign[1] = geti (f);
	calign[2] = geti (f);
	calign[3] = geti (f);
	cclose (f);
	}

/**********************************************************************

	CLEANUP - PARSER CLEANUP ROUTINE

**********************************************************************/

cleanup (rcode)

	{extern int maxerr;
	static int level;

	if (++level == 1)
		{

# ifdef MERGE_LP

		cclose (f_string);
		cclose (f_source);
		wcstore ();

# endif

# ifndef MERGE_LP

		cclose (f_token);

# endif

		node (1);
		cclose (f_node);
		sdef ();
		chkdict (dbegin, dgdp);
		wtyptab ();
		if (sflag)
			{wsymtab ();
			cclose (f_symtab);
			}
		}
	cexit (rcode?rcode:maxerr>=2000);
	}

/**********************************************************************

	ERRX - Report error (lineno accessed via external variable)

**********************************************************************/

errx (errno, a1, a2, a3, a4)

	{error (errno, lineno, a1, a2, a3, a4);
	}

/**********************************************************************

	PINIT - PARSER INIT ROUTINE

**********************************************************************/

pinit ()

	{

# ifndef MERGE_LP

	f_token = xopen (fn_token, MREAD, BINARY);

# endif

	f_node = xopen (fn_node, MWRITE, BINARY);
	f_mac = xopen (fn_mac, MWRITE, TEXT);
	if (sflag) f_symtab = xopen (fn_symtab, MWRITE, BINARY);
	ainit ();
	}

/**********************************************************************

	GETTOK - Get Token Routine (When LP not merged)

**********************************************************************/

# ifndef MERGE_LP

int lxeof FALSE;

gettok ()

	{extern int lextag, lexindex, lexline;

	while (TRUE)
		{if (lxeof) lextag = TEOF;
		else
			{lextag = geti (f_token);
			lexindex = geti (f_token);
			if (lextag == TLINENO)
				{lexline = lexindex;
				continue;
				}
			if (lextag <= TEOF) lxeof = TRUE;
			}
		return;
		}
	}

# endif

/**********************************************************************

	PTOKEN - Simple Token Print Routine for Parser Option

**********************************************************************/

ptoken (tp, f)	token *tp;

	{cprint (f, "%4d %6d", tp->tag, tp->index);}

/**********************************************************************

	NODE - PARSER NODE OUTPUT ROUTINE

**********************************************************************/

node (op, p1, p2, p3, p4, p5, p6)

	{int *p, j, k;

	p = &op;
	k = j = nodelen[op];
	while (--k >= 0) puti (*p++, f_node);
	k = lc_node;
	lc_node =+ j;
	return (k);
	}

/**********************************************************************

	PARSER ERROR MESSAGE ROUTINES

**********************************************************************/

synerr (line)		{error (2007, line);}
giveup (line)		{error (4012, line);}
stkovf (line)		{error (4003, line);}
delmsg (line)		{error (2012, line);}
skpmsg (line)		{error (2013, line);}

qprint (q)		{error (2008, -1, q);}
tprint (tp) token *tp;	{error (2011, -1, tp->tag, tp->index);}
pcursor ()		{error (2010, -1);}

stkunf (line)		{error (6033, line);}
tkbovf (line)		{error (6008, line);}
badtwp (line)		{error (6032, line);}
badtok (line, i)	{error (6000, line, i);}
