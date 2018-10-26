# include "cc.h"

/*

	C COMPILER
	Phase M: Macro Expansion
	Section 1: Target-Machine-Independent Code

	Copyright (c) 1977 by Alan Snyder

*/

extern	int	macdef[],mdeflist[],nmacdef[],nnmacs,mdflsz,nmacros;
extern	char	*mcstore,*nmacname[];
extern	int	nfn;
extern	char	*fn[],*(*ff[])();

/*     types     */

# define icb struct _icb
icb	{int (*mgetc)();	/* get character routine */
	int *locp;		/* pointer to OPLOC description */
	int base[3];		/* REF bases of operands, result */
	int argc;		/* number of macro args */
	char *cp;		/* pointer to current string */
	char *argv[10];		/* pointer to macro args */
	char argbuff[100];	/* buffer for args */
	icb *next;		/* chain of ICBs */
	};

/*	for efficiency, the MGETC, LOCP, and CP fields of the
	current ICB are maintained in the following variables	*/

int	(*mgetc)();
int	*locp;
char 	*cp;

extern	int rfile(), rstring(), rquote(), rmacro(), reof();

# define hentry struct _hentry
hentry	{char *hname;
	int hflag;
	char (*hf)();
	};

icb	*cicb,
	*ficb;

int	mflag,
	mfile,
	f_error -1,
	f_output -1;

char	*fn_mac,
	*fn_hmac,	/* header macros */
	*fn_string,
	*fn_cstore,
	*fn_error,
	*fn_output,
	cstore[cssiz];

/*	functions	*/

icb	*icb_get();
hentry	*mlook();

/**********************************************************************

	Macro Processor:  Main Routine

**********************************************************************/

main (argc, argv)
	int argc;
	char *argv[];

	{mcontrol (argc, argv);
	cleanup (0);
	}

mcontrol (argc, argv)
	int argc;
	char *argv[];

	{int i;

	msetup (argc, argv);
	for (i=0;i<nfn;++i) enter (fn[i], -1, ff[i]);
	for (i=0;i<nnmacs;++i) enter (nmacname[i], i, 0);
	if (rcstore()) cexit (100);
	f_output = xopen (fn_output, MWRITE, TEXT);
	icb_init ();
	exp_file (fn_hmac);
	exp_file (fn_mac);
	cclose (f_output);
	}

/**********************************************************************

	MSETUP - process phase arguments

**********************************************************************/

msetup (argc, argv)
	int argc;
	char *argv[];

	{char *s;
	int c;

	if (argc < 8)
		{cprint ("Phase M called with too few arguments.\n");
		cexit (100);
		}
	fn_output = argv[2];
	fn_cstore = argv[3];
	fn_error = argv[4];
	fn_mac = argv[5];
	fn_string = argv[6];
	fn_hmac = argv[7];
	s = argv[1];
	while (c = *s++) if (c == 'm') mflag = TRUE;
	}

/**********************************************************************

	EXP_FILE - expand given file

**********************************************************************/

exp_file (name)
	char *name;

	{register int c;

	mfile = xopen (name, MREAD, TEXT);
	icb_stack (icb_get (rfile, 0, NULL));
	while (c = mget() & 0377) cputc (c, f_output);
	}

/**********************************************************************

	MGET - Top Level Get-Character Routine

	Implements '#', '%', and '\\' conventions.

**********************************************************************/

mget()

	{register int c;

	for (;;)
		{if ((c = (*mgetc)()) == '#') {esharp (); continue;}
		else if (c=='%') {emacro (); continue;}
		else if (c == '\\')
			switch (c=(*mgetc)()) {
			case '\n':	continue;
			case 't':	return ('\t');
			case 'n':	return ('\n');
			case 'r':	return ('\r');
			default:	return (c | 0400);
				}
		else return (c);
		}
	}

/**********************************************************************

	ESHARP - expand # sequence (arg ref or %name call)

**********************************************************************/

esharp ()

	{register int c, n;
	register icb *p;
	int argc;
	char **argv, *s;

	c = (*mgetc)();
	if (c <= '9' && c >= '0')	/* arg ref */
		{c =- '0';
		if (c < cicb->argc && (s=((cicb->argv)[c])))
			icb_stack (icb_get (rquote, 0, s));
		return;
		}

	/* must be %NAME call */

	argc = 2;
	switch (c) {	/* which one ? */

	case 'R':	/* RESULT LOCATION */

		n = 1;
		break;

	case 'F':	/* FIRST OPERAND LOCATION */

		n = 3;
		break;

	case 'S':	/* SECOND OPERAND LOCATION */

		n = 5;
		break;

	case 'O':	/* OPERATION NAME */

		argc = 1;
		n = 0;
		break;

	default:	/* bad abbreviation */

		return;
		}

	argv = &(cicb->argv[n]);
	s = aname (argc, argv);
	if (s && *s)	/* something returned */
		{p = icb_get (rstring, argc, s);
		p->argv[0] = argv[0];
		p->argv[1] = argv[1];
		icb_stack (p);
		}
	}

/**********************************************************************

	EMACRO - expand macro invocation

**********************************************************************/

emacro ()

	{register int c;
	register char *q1;
	register icb *p;
	int i, argc, m;
	char name[16], **argv, *s, *q2, *(*f)();
	icb *micb;
	hentry *hp;

	micb = cicb;

	/* collect macro name into NAME buffer */

	q1 = name;
	q2 = name+15;
	while ((c = (*mgetc)()) != '(' || cicb!=micb)
		if (q1<q2) *q1++ = c & 0377;
		else if (!c) return (0);
	*q1 = 0;

	/* Find the Macro Definition */
	/* set either M or F */

	m = -1; f = 0;
	if (name[0]<='9' && name[0]>='0') m = atoi(name);
	else if ((hp=mlook(name))->hname)
		if (hp->hflag == -1) f = hp->hf;  /* C Routine */
			else m=nmacdef[hp->hflag];
	if (f) p = icb_get (rstring, 0, NULL);
		else p = icb_get (rmacro, 0, NULL);

	/* collect arguments into ARGBUFF buffer */

	s = p->argbuff;
	argv = p->argv;
	c = mget();
	if (!(c==')' && micb==cicb))
		{*argv = s;
		while (c)
			{if (micb==cicb && (c==',' || c==')'))
				{*s++ = '\0';
				*++argv = s;
				if (c==')') break;
				}
			else *s++ = c & 0377;
			c = mget();
			}
		}

	argc = argv - (p->argv);

# ifndef SCRIMP

	if (mflag)
		{cprint ("EXPANDING %%%s(", name);
		for (i=0;i<argc;++i)
			{cprint ("%s", p->argv[i]);
			if (i!=argc-1) cprint (",");
			}
		cprint (")\n");
		}

# endif

	p->argc = argc;
	if (f)	/* C routine macro */
		{s = (*(hp->hf))(argc,p->argv);
		if (s && *s)
			{p->cp = s;
			icb_stack(p);
			return;
			}
		}

	if (m>0 && m<=nmacros)	/* machine description macro */
		{p->locp= &mdeflist[macdef[m]];
		if (argc>3) p->base[0] = atoi(p->argv[3]);
		if (argc>5) p->base[1] = atoi(p->argv[5]);
		if (argc>1) p->base[2] = atoi(p->argv[1]);
		icb_stack(p);
		return;
		}
	icb_free (p);
	}

/**********************************************************************

	RFILE - get character from file

**********************************************************************/

int rfile ()

	{register int c;

	if (c = cgetc (mfile)) return (c);
	icb_unstack ();
	return ((*mgetc)());
	}

/**********************************************************************

	RSTRING - get character from string

**********************************************************************/

int rstring ()

	{register int c;

	if (c = *cp++) return (c);
	icb_unstack ();
	return ((*mgetc)());
	}

/**********************************************************************

	RQUOTE - get character from quoted string

**********************************************************************/

int rquote ()

	{register int c;

	if (c = *cp++) return (c | 0400);
	icb_unstack ();
	return ((*mgetc)());
	}

/**********************************************************************

	RMACRO - get character from machine description macro

**********************************************************************/

int rmacro ()

	{register int c, i, *ip;
	int  base, *basep;

new_cp:	if (cp && (c = *cp++)) return (c);
	for (;;)
		{ip = locp;
		if ((i = ip[0]) < 0)
			{icb_unstack ();
			return ((*mgetc)());
			}
		if (i==3)	/* unconditional string */
			{locp =+ 2;
			cp = &mcstore[ip[1]];
			goto new_cp;
			}
		locp =+ 7;	/* string with condition prefix */
		basep = cicb->base;
		for (i=0;i<3;++i)
			{base = *basep++;
			switch (*ip++) {
		case 0:		++ip; continue;
		case 1:		if (base >= 0 && ((*ip++ >> base) & 1))
					continue;
				else break;
		case 2:		if (base < 0 && ((*ip++ >> -base) & 1))
					continue;
				else break;
				}
			break;
			}
		if (i==3)	/* all tests succeeded */
			{cp = &mcstore[*ip];
			goto new_cp;
			}
		}
	}

/**********************************************************************

	REOF - get character at end of file

**********************************************************************/

int reof ()

	{return (0);}

/**********************************************************************

	INPUT CONTROL BLOCK ROUTINES

	ICB_GET		- Allocate Input Control Block
	ICB_INIT	- Initialize Input Control Block Pool
	ICB_STACK	- Push an Input Control Block onto the ICB Stack
	ICB_UNSTACK	- Pop off the top ICB and discard
	ICB_FREE	- Discard an Input Control Block
	ICB_PRINT	- Print an Input Control Block (for debugging)

**********************************************************************/

icb_init()

	{static icb xicb[icb_size];
	icb *p,*q;

	/* set up free chain */

	p = &xicb[icb_size-1];
	p->next = NULL;
	for (q=p;q>xicb;) (--q)->next = p--;
	ficb = q;
	}

icb *icb_get (new_mgetc, new_argc, new_cp)
	int (*new_mgetc)();
	char *new_cp;

	{icb *p;

	/* remove first element of free chain */

	if (!ficb) error (6004, -1);
	p = ficb;
	ficb = p->next;
	p->next = NULL;
	p->mgetc = new_mgetc;
	p->argc = new_argc;
	p->cp = new_cp;
	p->locp = NULL;
	return (p);
	}

icb_stack (p)	icb *p;

	{

# ifndef SCRIMP

	if (mflag) icb_print(p);

# endif

	if (cicb)	/* Current CP and LOCP must be saved.
			   MGETC is assumed not to change, thus
			   any change must be made to both
			   the variable and the ICB field. */

		{cicb->cp = cp;
		cicb->locp = locp;
		}
	p->next = cicb;
	cicb = p;
	mgetc = p->mgetc;
	locp = p->locp;
	cp = p->cp;
	}

icb_unstack()

	{icb *p;

# ifndef SCRIMP

	if (mflag) cprint ("POPPING ICB\n");

# endif

	/*	if throwing away FILE input, close FILE first	*/

	if (mgetc == rfile) cclose (mfile);
	p = cicb->next;
	cicb->next = ficb;
	ficb = cicb;
	cicb = p;

	/*	restore MTYPE, LOCP, and CP		*/

	if (p)
		{mgetc = p->mgetc;
		locp = p->locp;
		cp = p->cp;
		}
	else mgetc = reof;
	}

icb_free(p)	icb *p;

	{p->next = ficb;
	ficb = p;
	}

# ifndef SCRIMP

icb_print(p)	icb *p;

	{int (*f)();

	f = p->mgetc;
	cprint ("PUSHING ");
	if (f == rfile) cprint ("FILE");
	else if (f == rstring) cprint ("STRING \"%s\"", p->cp);
	else if (f == rquote) cprint ("QUOTED STRING \"%s\"", p->cp);
	else if (f == rmacro)
		{cprint ("MACRO, LOCP=%o, ", p->locp);
		cprint ("BASE=(%d,%d,%d)", p->base[0], p->base[1],
			p->base[2]);
		}
	else cprint ("UNKNOWN ICB, MGETC=%o", f);
	cprint ("\n");
	}

# endif

/**********************************************************************

	HASH TABLE ROUTINES

**********************************************************************/

hentry hshtab[mhsize];

hentry *mlook(np) char *np;

	{register int i, u;
	register char *p;

	i=0; p=np;
	while (u = *p++) i =+ u;
	i = (i<<2) & mhmask;

	while (p=hshtab[i].hname)
		if (stcmp(p,np)) break;
		else i = ++i & mhmask;

	return (&hshtab[i]);
	}

enter (s, hflag, hf)	char *s,(*hf)(); int hflag;

	{hentry *hp;

	if (!(hp=mlook(s))->hname)
		{hp->hname = s;
		hp->hflag = hflag;
		hp->hf = hf;
		}
	}

/**********************************************************************

	CLEANUP - Macro Phase Cleanup Routine

**********************************************************************/

cleanup (rcode)

	{cexit (rcode);
	}

