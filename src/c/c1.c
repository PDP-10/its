# include "cc.h"

/*

        C COMPILER
        Phase L: Lexical Analyzer

	Copyright (c) 1976, 1977, 1978 by Alan Snyder

*/


/**********************************************************************

	VARIABLES

**********************************************************************/

/*	character type array

	_LETTER - letter or _ (identifier or keyword)
	_DIGIT - digit (constant or identifier)
	_QUOTE - quote mark (character string)
	_MCOP - possible beginning of multiple-character operator
	_EOL - newline
	_BLANK - blank, tab, vertical tab, form feed, cr
	_INVALID - invalid character
	_SQUOTE - apostrophe (character constant)
	_PERIOD - period (operator or beginning of float constant)
	_ESCAPE - (the escape character)
	_CONTROL - compiler control line indicator

	50+ - single-character operator, typ[c]=token.tag+50	*/

int typ[] {
_INVALID,_INVALID,_INVALID,_INVALID,_INVALID,_INVALID,_INVALID,_INVALID,
_INVALID,_BLANK,_EOL,_BLANK,_BLANK,_BLANK,_INVALID,_INVALID,
_INVALID,_INVALID,_INVALID,_INVALID,_INVALID,_INVALID,_INVALID,_INVALID,
_INVALID,_INVALID,_INVALID,_INVALID,_INVALID,_INVALID,_INVALID,_INVALID,
_BLANK,_MCOP,_QUOTE,_CONTROL,_INVALID,69,_MCOP,_SQUOTE,
59,58,71,_MCOP,61,_MCOP,_PERIOD,_MCOP,
_DIGIT,_DIGIT,_DIGIT,_DIGIT,_DIGIT,_DIGIT,_DIGIT,_DIGIT,
_DIGIT,_DIGIT,60,53,_MCOP,_MCOP,_MCOP,63,
_INVALID,_LETTER,_LETTER,_LETTER,_LETTER,_LETTER,_LETTER,_LETTER,
_LETTER,_LETTER,_LETTER,_LETTER,_LETTER,_LETTER,_LETTER,_LETTER,
_LETTER,_LETTER,_LETTER,_LETTER,_LETTER,_LETTER,_LETTER,_LETTER,
_LETTER,_LETTER,_LETTER,57,_ESCAPE,56,68,_LETTER,
_INVALID,_LETTER,_LETTER,_LETTER,_LETTER,_LETTER,_LETTER,_LETTER,
_LETTER,_LETTER,_LETTER,_LETTER,_LETTER,_LETTER,_LETTER,_LETTER,
_LETTER,_LETTER,_LETTER,_LETTER,_LETTER,_LETTER,_LETTER,_LETTER,
_LETTER,_LETTER,_LETTER,55,_MCOP,54,64,_INVALID };

/*	translation table	*/

int trt[] {
000,001,002,003,004,005,006,007,010,' ','\n',' ',' ',' ',016,017,
020,021,022,023,024,025,026,027,030,031,032,033,034,035,036,037,
' ','!','"','#','$','%','&','\'','(',')','*','+',',','-','.','/',
'0','1','2','3','4','5','6','7','8','9',':',';','<','=','>','?',
0100,'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O',
'P','Q','R','S','T','U','V','W','X','Y','Z','[','\\',']','^','_',
0140,

# ifdef BOTHCASE
     'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o',
'p','q','r','s','t','u','v','w','x','y','z',
# endif

# ifndef BOTHCASE
     'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O',
'P','Q','R','S','T','U','V','W','X','Y','Z',
# endif
                                            '{','|','}','~',0177 };

/* two-character operator tables */

char	*op2s[] {
	"++", "--", "==", "!=", "<=", ">=", "<<", ">>", "->", "&&",
	"||", "/*", "=+", "=-", "=*", "=/", "=%", "=&", "=^", "=|", 0};
int	op2v[] {
	27, 28, 29, 30, 31, 32, 33, 34, 35, 37,
	38, 0, 102, 103, 104, 105, 106, 107, 108, 109};
char	op1c[] {
	'=', '+', '-', '!', '<', '>', '&', '|', '/', 0};
int	op1v[] {
	24, 23, 22, 15, 25, 26, 16, 17, 20};

/* keyword table */

char	*keys[] {
	"int",
	"char",
	"float",
	"double",
	"struct",
	"auto",
	"static",
	"extern",
	"return",
	"goto",
	"if",
	"else",
	"switch",
	"break",
	"continue",
	"while",
	"do",
	"for",
	"default",
	"case",
	"entry",
	"register",
	"sizeof",
	"long",
	"short",
	"unsigned",
	"typedef",
	0};


/**********************************************************************

	HASH TABLE

**********************************************************************/

# define h_idn 0	/* identifier */
# define h_key 1	/* keyword */
# define h_man 2	/* manifest constant */
# define h_mac 3	/* macro */
# define h_arg 4	/* macro argument */

# define hentry struct _hentry
hentry
	{char *hnp;		/* pointer to string in cstore */
	int hclass;		/* class (idn, key, man, mac, arg) */
	int hval;};		/* value:
					key: token TAG
					man: index in MCDEF of def
					mac: index in MCDEF of def
					arg: argument number
					*/

hentry	hshtab[hshsize];	/* the hash table */
int	hshused 0;		/* number of entries used */
hentry	*lookup(), *lookx();

/**********************************************************************

	TOKEN Input Control Blocks (for macro processing)

**********************************************************************/

# define ticb struct _ticb
ticb
	{int	titype;		/* type of current token source */
	int	*tiptr;		/* ptr to position within def */
	ticb	*tinext;	/* ptr to next ICB on stack or free */
	int	tiargc;		/* number of arguments */
	int	tiap[maxargs];	/* ptrs to args */
	int	tiab[margbsz];	/* args */
	};

ticb	*cticb;			/* the current token ICB (0 if none) */
ticb	*fticb;			/* pointer to chain of free token ICBs */
ticb	*ti_get();

# define ti_mac 0		/* read from macro def */
# define ti_man 1		/* read from manfst const or macro arg */

/**********************************************************************

	INPUT Control Blocks (for multiple input files)

**********************************************************************/

struct	_icb	{
	int	fileno,		/* file descriptor */
		lineno,		/* line number */
		eof,		/* end-of-file flag */
		nlflag;		/* new-line flag */
		};

# define icb struct _icb

icb	icbs[maxicb];		/* the input stack */
int	icblev;			/* index of current ICB */

int	i_file,			/* top-level ICB for efficiency */
	i_line 1,
	i_eof FALSE,
	i_nlflag TRUE;

/**********************************************************************

	CSTORE - character store: holds keywords, identifiers,
	and floating-point literals in source form

**********************************************************************/

char	cstore[cssiz],
	*cwp,			/* points to beginning of working area */
	*cp,			/* points to first unused character */
	*ecstore;		/* points to last char in cstore */

/**********************************************************************

	communication between lexical routines

**********************************************************************/

# ifndef MERGE_LP

int 	lextag,			/* token.tag */
	lexindex,		/* token.index */
	lexline 1;		/* token.line */

# endif
# ifdef MERGE_LP

extern int lextag, lexindex, lexline;

# endif

int	stloc 0,		/* string location counter */
	ccard 0,		/* indicates currently processing
				   compiler control line */
	mcdflv 0,		/* depth of macro definition processing */
 	cc,			/* current untranslated input char */
	tt,			/* current translated input char */
	ttype,			/* type of current translated input char */
	truncate,		/* indicates that cstore is full */
	lexcount 0;		/* number of characters in lookahead buffer */

char	lexbuff[5];		/* lookahead buffer */

/*	FILES		*/

int	f_source,		/* source file */
	f_string;		/* string output file */

char	*fn_source,
	*fn_cstore,
	*fn_string;

# ifndef MERGE_LP

int 	f_token,		/* token output file */
	f_error -1;		/* error output file */

char 	*fn_token,
	*fn_error;

# endif

/*	asgnop table, used to recognize =op's	*/

int asgnop[]
	{7,9,8,6,5,4,3,2,51,51,51,51,51,51,51,51,51,1,0};

/*	compiler control line table	*/

cclent	ccltab [maxccl];		/* holds names and routines for CCLs */
int	nccl 0;				/* number of CCLs defined */
int	jendif;				/* various special identifiers */
int	jend;
int	jifdef;
int	jifndef;

/*	manifest constants		*/

int 	mcdef[mcdsz],		/* storage of manifest constant definitions */
	*cmcdp {mcdef},		/* pointer to next free word in mcdef */

/*	rename control line	*/

	sw_flag;		/* flag to inhibit writing of string
				   constants on the string file */

/**********************************************************************

	MAIN - Lexical Phase Main Routine

	Receives file names as arguments.
	Opens TOKEN, STRING, and source files.
	Calls LXINIT to perform initialization.

	Copies tokens onto TOKEN file, inserting "line number"
	tokens as appropriate.

**********************************************************************/

# ifndef MERGE_LP

main (argc, argv) int argc; char *argv[];

	{int oldline;

	if (argc < 7)
		{cprint ("Phase L called with too few arguments.\n");
		cexit (100);
		}

	fn_source = argv[2];
	fn_token = argv[3];
	fn_cstore = argv[4];
	fn_error = argv[5];
	fn_string = argv[6];

	f_token = xopen (fn_token, MWRITE, BINARY);

	lxinit();
	oldline = 0;
	do
		{gettok();
		if (lexline != oldline)
			{puti (TLINENO, f_token);
			puti (lexline, f_token);
			oldline = lexline;
			}
		puti (lextag, f_token);
		puti (lexindex, f_token);
		}
	while (lextag != TEOF);
	cleanup (0);
	}

# endif

/**********************************************************************

	GETTOK - GET NEXT TOKEN

	Set variables LEXTAG, LEXINDEX, LEXLINE.
	This level implements Compiler Control Lines.

**********************************************************************/

gettok()

	{int i, line;

	while (TRUE)

		{tokget (FALSE);
		if (lextag == TCONTROL)	/* it's a CCL */
			{line = lexline;
			tokget (TRUE);
			if (lextag==LEXEOF) continue;
			else
				{if (lextag == TIDN)
				    {if (lexindex == jend && mcdflv>0)
					{cskip ();
					lextag = LEXEOF;
					return;
					}
				    for (i=0;i<nccl;++i)
					if (lexindex==ccltab[i].cname)
						{(*ccltab[i].cproc)();
						cskip();
						break;
						}
				    if (i<nccl) continue;
				    }
				error (1013, line);
				}
			cskip ();
			}
		else return;
		}
	}

/**********************************************************************

	IFDEF, IFNDEF Compiler Control Lines

**********************************************************************/

ifdccl () {defskip (FALSE);}
ifnccl () {defskip (TRUE);}
defskip (sense)
	{int c;
	tokget (TRUE);
	if (lextag==TIDN)
		{c = lookx()->hclass;
		if (sense ^ (c != h_man && c != h_mac)) ifskip ();
		}
	else errlex (1020);
	}

/**********************************************************************

	IFSKIP - skip body of #IF, #IFDEF, or #IFNDEF

**********************************************************************/

ifskip ()

	{int if_level, line;

	if_level = 1;
	line = lexline;
	cskip ();
	do
		{tokget (TRUE);
		if (lextag == TCONTROL)
			{tokget (TRUE);
			if (lextag == 50) if_level++;
			else if (lextag==TIDN)
				{if (lexindex==jifdef ||
					lexindex==jifndef) if_level++;
				else if (lexindex==jendif)
					{if (--if_level==0)
						{cskip ();
						break;
						}
					}
				}
			cskip ();
			}
		}
	while (lextag != TEOF);
	if (lextag==TEOF) error (1011, line);
	}

/**********************************************************************

	DEFCCL - Handle DEFINE Compiler Control Line

**********************************************************************/

defccl ()

	{int	k;
	hentry	*hp;

	tokget (TRUE);		/* identifier being defined */
	if (lextag != TIDN) errlex (1012);
	else
		{if (lexcount>0 && trt[lexbuff[lexcount-1]]=='(')
			defmac (TRUE);
		else
			{hp = lookx ();
			k = cmcdp-mcdef;
			do
				{tokget (FALSE);
				deftok();
				}
			while (lextag != LEXEOF);
			--cmcdp; /* 2nd word of EOF not needed */
			sethn (hp, h_man, k);
			}
		}
	}

/**********************************************************************

	UNDCCL - Handle UNDEFINE Compiler Control Line

**********************************************************************/

undccl ()

	{tokget (TRUE);		/* identifier being undefined */
	if (lextag != TIDN) errlex (1030);
	else sethn (lookx (), h_idn, lexindex);
	}

/**********************************************************************

	INCCCL - Handle INCLUDE Compiler Control Line

**********************************************************************/

incccl ()

	{int ifile;

	sw_flag=TRUE;
	cp = cwp;
	tokget (FALSE);		/* read file name */
	if (lextag!=TSTRING) errlex (1014);
	else
		{tokget (FALSE);
		if (lextag!=LEXEOF) errlex (1014);
		else if ((ifile = xopen (cwp,MREAD,TEXT)) >= 0)
			in_push (ifile);
		}
	sw_flag = FALSE;
	}

/**********************************************************************

	RENCCL - Handle RENAME Compiler Control Line

**********************************************************************/

renccl ()

	{int	k;
	hentry	*hp;

	sw_flag=TRUE;
	tokget (TRUE);
	if (lextag==TIDN)
		{hp = lookx ();
		k = cmcdp-mcdef;
		*cwp++ = ' ';		/* prefix string with blank */
		tokget (FALSE);
		if (lextag == TSTRING)
			{lextag=TIDN;
			lexindex=lookup(--cwp)->hnp-cstore;
			deftok();
			tokget (FALSE);
			if (lextag==LEXEOF)
				{deftok();
				sethn (hp, h_man, k);
				sw_flag=FALSE;
				return;
				}
			}
		}
	errlex (1010);
	sw_flag=FALSE;
	}

/**********************************************************************

	MACCCL - Handle MACRO Compiler Control Line

**********************************************************************/

macccl ()

	{tokget (TRUE);
	if (lextag == TIDN) defmac (FALSE);
	else errlex (2037);
	}

/**********************************************************************

	DEFMAC - Define Macro (Flag => #define form)

**********************************************************************/

defmac (flag)

	{int argc;		/* number of formal arguments */
	hentry *argv[maxargs];	/* offset of hash table entries for args */
	int oclass[maxargs];	/* old HCLASS of formal parameters */
	int oval[maxargs];	/* old HVAL of formal parameters */
	int win, line, i, k;
	hentry *hp, *fp;

	++mcdflv;
	argc = 0;
	win = FALSE;
	line = lexline;
	hp = lookx ();
	k = cmcdp-mcdef;
	tokget (TRUE);		/* should be '(' */
	if (lextag == 9)	/* ( */
		{tokget (TRUE);	/* should be formal param or ')' */
		while (lextag == TIDN)
			{fp = lookx ();
			if (argc>=maxargs) errlex (4014);
			argv[argc] = fp;
			oclass[argc] = fp->hclass;
			oval[argc] = fp->hval;
			sethn (fp, h_arg, argc++);
			tokget (TRUE);	/* should be ',' or ')' */
			if (lextag != 11) /* , */ break;
			tokget (TRUE);
			}
		if (lextag == 8)	/* ) */
			{if (!flag) cskip ();
			do	{gettok ();
				if (lextag==TEOF) error (4015, line);
				deftok ();
				}
			while (lextag != LEXEOF);
			--cmcdp;
			sethn (hp, h_mac, k);
			win = TRUE;
			}
		}
	--mcdflv;
	for (i=0;i<argc;++i) sethn (argv[i], oclass[i], oval[i]);
	if (!win) error (2037, line);
	}

/**********************************************************************

	ENDCCL - Handle END and ENDIF Compiler Control Line

**********************************************************************/

endccl ()	{return;}

/**********************************************************************

	TOKGET - (internal) get next token

	Set variables LEXTAG, LEXINDEX, and LEXLINE.  If QUOTE is
	TRUE, do not substitute for manifest constants.

**********************************************************************/

tokget (quote)

	{if (icblev==0) lexline = i_line;

	while (TRUE)
		{if (cticb) switch (cticb->titype) {

	case ti_man:	lextag = *cticb->tiptr++;
			lexindex = *cticb->tiptr++;
			if (lexindex==UNDEF) lexindex=lexline;
			if (lextag) return;
			ti_pop ();
			continue;

	case ti_mac:	lextag = *cticb->tiptr++;
			lexindex = *cticb->tiptr++;
			if (lextag == TMARG)
				{if (lexindex >= cticb->tiargc)
					errlex (1017);
				else in_mc (cticb->tiap[lexindex]);
				continue;
				}
			if (lexindex==UNDEF) lexindex=lexline;
			if (lextag) return;
			ti_pop ();
			continue;
			}
		if (!lgetc()) break;
		truncate = FALSE;
		cp = cwp;		/* working string */
		switch (ttype) {
	case _LETTER:	if (name (quote)) continue;
			return;
	case _PERIOD:	move (tt);
			if (ttype != _DIGIT)
				{lextag = 12;	/* . */
				lexindex = lexline;
				pback (cc);
				return;
				}
			number (TRUE);
			return;
	case _DIGIT:	number (FALSE);
			return;
	case _QUOTE:	string ();
			return;
	case _MCOP:	mcop (quote);
			return;
	case _EOL:	if (ccard) 
				{ccard=FALSE;
				lextag=LEXEOF;
				return;
				}
			if (icblev==0) lexline = i_line;
	case _BLANK:	continue;
	case _ESCAPE:	/* fall through to error message */
	case _INVALID:	errlex (1000);
			continue;
	case _SQUOTE:	charcon ();
			return;
	case _CONTROL:	if (ccard) {errlex (1000); continue;}
			ccard = TRUE;
			lextag = TCONTROL;
			lexindex = 0;
			return;
	default:	/* single character operator */
			lextag = ttype - 50;
			lexindex = lexline;
			return;
			}
		}
	lextag = TEOF;
	lexindex = lexline;
	}

/**********************************************************************

	NAME - read name

**********************************************************************/

int name (quote)

	{hentry *hp;

	do move (tt); while (_NAME);
	if (truncate) errlex (4001);

	*cp = 0;
	hp = lookup (cwp);
	pback (cc);

	/* what kind of identifier is it? */

	switch (hp->hclass) {
	case h_key:	lextag = hp->hval;
			lexindex = lexline;
			return (0);
	case h_man:	if (!quote)
				{in_mc (mcdef+hp->hval);
				return (1);
				}
	case h_mac:	if (!quote)
				{exmacro (hp->hval);
				return (1);
				}
	case h_arg:	if (!quote)
				{lextag = TMARG;
				lexindex = hp->hval;
				return (0);
				}
	case h_idn:	lextag = TIDN;
			lexindex = hp->hnp - cstore;
			}
	return (0);
	}

/**********************************************************************

	NUMBER - read float or int constant

**********************************************************************/

number (floatflag)

	{int sum, c;

	lextag = TINTCON;
	move (tt);
	if (!floatflag && (tt=='X' || tt=='x') && cwp[0]=='0')
		{sum = 0;
		while (lgetc ())
			{if (tt>='0' && tt<='9')
				sum = (sum<<4) | (tt - '0');
			else if (tt>='A' && tt<='F')
				sum = (sum<<4) | (tt - ('A' - 10));
			else if (tt>='a' && tt<='f')
				sum = (sum<<4) | (tt - ('a' - 10));
			else break;
			}
		if (tt != 'L' && tt != 'l') pback (cc);
		lexindex = sum;
		return;
		}

	while (ttype == _DIGIT) move (tt);
	if (!floatflag && tt=='.')
		{floatflag=TRUE;
		move (tt);
		while (ttype == _DIGIT) move (tt);
		}
	if (tt=='E' || tt=='e')
		{floatflag=TRUE;
		move (tt);
		if (tt=='+' || tt=='-') move (tt);
		while (ttype == _DIGIT) move (tt);
		}
	*cp++ = '\0';
	if ((tt != 'L' && tt != 'l') || floatflag) pback (cc);
	if (floatflag)
		{lexindex = cwp - cstore;
		cwp = cp;
		lextag = TFLOATC;
		}
	else		/* integer */
		{cp = cwp;
		sum = 0;
		if (*cp=='0')	/* octal */
			while (c = *cp++) sum = (sum<<3) | ((c-'0') & 017);
		else	while (c = *cp++) sum = (sum*10) + ((c-'0') & 017);
		lexindex = sum;
		}
	if (truncate) errlex (4001);
	return;
	}

/**********************************************************************

	STRING - read string constant

	Move characters until quote, end-of-file, or unescaped
	newline.

**********************************************************************/

string ()

	{lexindex = stloc;
	lgetc();
	while (tt!='"' && tt!='\0' && tt!='\n')
		{if (ttype == _ESCAPE)
			{if (lgetc()=='\n')
				{i_nlflag=FALSE;
				lgetc();
				continue;
				}
			cc = escape ();
			}
		if (cc=='\0') {swrite('$'); swrite('0');}
		else if (cc=='$') {swrite('$'); swrite('$');}
		else swrite (cc);
		lgetc ();
		}
	if (tt!='"') errlex (2001);
	else lgetc();		/* skip quotation mark */
	if (truncate) errlex (4001);
	lextag = TSTRING;
	swrite ('\0');
	pback (cc);
	}

/**********************************************************************

	CHARCON - read character constant

**********************************************************************/

charcon ()

	{int c, len;

	lgetc ();	/* skip ' */
	c = len = 0;
	while (tt!='\n' && tt!='\0' && tt!='\'')
		{if (ttype == _ESCAPE)
			{if (lgetc()=='\n')
				{lgetc();continue;}
			cc = escape ();
			}
		c = cc;
		lgetc ();
		++len;
		}
	if (tt!='\'') errlex (1003);
	else if (len>1) errlex (1002);
	lextag = TINTCON;
	lexindex = c;
	}

/**********************************************************************

	MCOP - read possible multi-character operator

**********************************************************************/

mcop (quote)

	{int c1, c2;
	char *s, **ss;

	if (tt=='=')	/* might be 3-character operator */
		{lgetc ();
		if (tt=='<' || tt=='>')
			{c1 = cc;
			c2 = tt;
			lgetc ();
			if (tt == c2)
				return (setop (tt=='<'?101:100,quote));
			pback (cc);
			pback (c1);
			return (setop (24, quote));
			}
		c2 = '=';
		}
	else
		{c2 = tt;
		lgetc ();
		}
	ss = op2s;
	while (s = *ss++) if (s[0]==c2 && s[1]==tt)
		return (setop (op2v[ss-op2s-1], quote));
	pback (cc);
	s = op1c;
	while (c1 = *s++) if (c1==c2)
		return (setop (op1v[s-op1c-1], quote));
	errlex (6043, c2);
	}

/**********************************************************************

	EXMACRO - Expand Macro Call

	Parameter is index of macro def in MCDEF.
	Collect arguments, set up TICB.

**********************************************************************/

exmacro (i)

	{int	argc, level, *ap, *ep, macline;
	ticb	*p;

	macline = lexline;	/* line number of macro call */
	p = ti_get ();		/* TICB for macro expansion */
	ap = p->tiab;		/* where args will go */
	ep = ap + (margbsz-3);	/* end of storage area for args */
	p->titype = ti_mac;
	p->tiptr = &mcdef[i];
	argc = 0;
	gettok ();		/* should be ( */
	if (lextag == 9)
		{gettok ();
		while (lextag != 8 && lextag != TEOF)	/* get args */
			{level = 0;
			if (argc >= maxargs) error (4014, macline);
			p->tiap[argc++] = ap;
			while (TRUE)
				{switch (lextag) {

			case TEOF:	goto arg_done;
			case 9:		++level; break;
			case 11:	if (level <= 0)
						{gettok ();
						goto arg_done;
						}
					break;
			case 8:		if (--level < 0) goto arg_done;
					break;
					}
				if (ap >= ep) error (4016, macline);
				*ap++ = lextag;
				if (lextag<TIDN && lextag!=TEQOP)
					lexindex = UNDEF;
				*ap++ = lexindex;
				gettok ();
				}
arg_done:		*ap++ = LEXEOF;
			}
		if (lextag==TEOF) error (4017, macline);
		}
	p->tiargc = argc;
	ti_push (p);
	}

/**********************************************************************

	TI - Token Input Control Block Operations

	ti_init ()		initialize
	p = ti_get ()		allocate token ICB
	ti_push (p)		push token ICB onto input stack
	ti_pop ()		pop top token ICB
	in_mc (p)		create and push manifest constant ICB

**********************************************************************/

ti_init ()

	{static ticb xticb[maxdepth];
	ticb *p, *q;

	/* set up free chain */

	p = &xticb[maxdepth-1];
	p->tinext = NULL;
	for (q=p; q>xticb; )
		(--q)->tinext = p--;
	fticb = q;
	cticb = 0;
	}

ticb *ti_get ()

	{ticb	*p;

	if (!fticb) errlex (4018);
	p = fticb;
	fticb = p->tinext;
	p->tinext = NULL;
	return (p);
	}

ti_push (p)	ticb *p;

	{p->tinext = cticb;
	cticb = p;
	}

ti_pop ()

	{ticb *p;

	if (cticb)
		{p = cticb->tinext;
		cticb->tinext = fticb;
		fticb = cticb;
		cticb = p;
		}
	}

in_mc (q)	int *q;

	{ticb *p;

	p = ti_get ();
	p->titype = ti_man;
	p->tiptr = q;
	ti_push (p);
	}

/**********************************************************************

	DEFTOK - append the current token to the manifest
		constant definition list

**********************************************************************/

deftok()

	{if(cmcdp>= &mcdef[mcdsz-1])
		errlex (4004);
	*cmcdp++ = lextag;
	if (lextag<TIDN && lextag!=TEQOP)
		lexindex = UNDEF;
	*cmcdp++ = lexindex;
	}

/**********************************************************************

	ESCAPE - read an escape sequence and return the proper value.
	If the escape sequence is not valid, print an error message
	and return a blank.

**********************************************************************/

int escape ()

	{int n, count;

	if (ttype==_ESCAPE) return (tt);
	if (tt>='0' && tt<='7')
		{n = 0;
		count = 3;
		do
			{n = (n<<3) | (tt-'0');
			lgetc ();
			} while (tt>='0' && tt<='7' && --count>0);
		pback (cc);
		return (n);
		}

	switch (tt) {
		case '\'':	return ('\'');
		case '"':	return ('"');
		case 'n':
		case 'N':	return ('\n');
		case 'r':
		case 'R':	return ('\r');
		case 't':
		case 'T':	return ('\t');
		case 'b':
		case 'B':	return ('\b');
		case 'v':
		case 'V':	return (013);
		case 'p':
		case 'P':	return (014);
		default:	errlex (1004);
				return (' ');
				}
	}

/**********************************************************************

	LGETC - LEXICAL PHASE CHARACTER INPUT ROUTINE

	set CC to next input character
	set TT to translation of CC
	set TTYPE to type of TT
	return TT

	Handles included files.
	Provides a lookahead facility.
	Keeps track of line numbers.

**********************************************************************/

int lgetc()

	{if (lexcount > 0) tt = trt[cc=lexbuff[--lexcount]];
	else if (i_eof) tt = trt[cc=LEXEOF];
	else
		{cc = cgetc (i_file);
		if (!cc)
			if (icblev>0)	/* restore state */
				{cclose (i_file);
				in_pop();
				return (lgetc ());
				}
			else
				{i_eof = TRUE;
				cc = LEXEOF;
				}

		if ((tt = trt[cc]) == '\n')
			{++i_line;
			i_nlflag = TRUE;
			}
		else i_nlflag = FALSE;
		}

	ttype = typ[tt];
	return (tt);
	}

/**********************************************************************

	PBACK - Push character back into input stream

**********************************************************************/

pback(c)	char c;

	{lexbuff[lexcount++] = c;}

/**********************************************************************

	IN_PUSH - Push new input file onto stack

**********************************************************************/

in_push (f)	int f;

	{register icb *p;

	if (icblev >= maxicb) errlex (4019);
	p = &icbs[icblev++];
	p->fileno = i_file;
	p->lineno = i_line;
	p->nlflag = i_nlflag;
	p->eof = i_eof;
	i_file = f;
	i_line = 1;
	i_nlflag = TRUE;
	i_eof = FALSE;
	}

/**********************************************************************

	IN_POP - Pop current input file from stack.

**********************************************************************/

in_pop ()

	{register icb *p;

	p = &icbs[--icblev];
	i_file = p->fileno;
	i_line = p->lineno;
	i_nlflag = p->nlflag;
	i_eof = p->eof;
	}

/**********************************************************************

	SETOP - set lextag and lexindex for operator

**********************************************************************/

int setop (i, quote)

	{int l;

	if (i>=100)	/* =op */
		{lextag = TEQOP;
		lexindex = i-100;
		return (0);
		}
	if (i==0)	/* comment */
		{l = lexline;
		while (lgetc ())
			while (tt=='*')
				if (lgetc () == '/')
					return (tokget (quote));
		error (1001, l);
		return (tokget (quote));
		}
	lextag = i;
	lexindex = lexline;
	return (0);
	}

/**********************************************************************

	KEYWORD - enter a keyword in the hash table

**********************************************************************/

keyword (s, tag) char *s; int tag;

	{fixname (s);
	sethn (lookup (s), h_key, tag);
	}

/**********************************************************************

	LXINIT - initialization for the lexical phase

**********************************************************************/

lxinit ()

	{int i;
	char *s, **ss;

	f_string = xopen (fn_string, MWRITE, BINARY);
	f_source = xopen (fn_source, MREAD, TEXT);

	cwp = cp = cstore;
	ecstore = &cstore[cssiz-1];
	i_file = f_source;
	ti_init ();

	i = 40;
	ss = keys;
	while (s = *ss++) keyword (s, i++);

	def_ccl ("include", incccl);
	def_ccl ("define", defccl);
	def_ccl ("undefine", undccl);
	def_ccl ("rename", renccl);
	jifdef = def_ccl ("ifdef", ifdccl);
	jifndef = def_ccl ("ifndef", ifnccl);
	jendif = def_ccl ("endif", endccl);
	def_ccl ("macro", macccl);
	jend = def_ccl ("end", endccl);
	}

/**********************************************************************

	DEF_CCL - Define Compiler Control Line Name and Handler

**********************************************************************/

int def_ccl (ccl_name, handler)	char *ccl_name; int (*handler)();

	{int i;

	fixname (ccl_name);
	if (nccl >= maxccl) error (6042, 0);
	i = ccltab[nccl].cname = lookup(ccl_name)->hnp - cstore;
	ccltab[nccl].cproc = handler;
	++nccl;
	return (i);
	}

/**********************************************************************

	FIXNAME - Fix Literal Name

**********************************************************************/

fixname (p)
	char *p;

	{
# ifndef BOTHCASE
	register char c;
	while (c = *p) *p++ = trt[c];
# endif
	return;
	}

/**********************************************************************

	LOOKUP - lookup or enter a symbol in the hash table

**********************************************************************/

hentry *lookup (np) char *np;

	{int	i, u, h;
	char	*p, *ep;
	hentry	*hp;

	h = i = 0;
	p = np;
	while (u = *p++) {i =+ (u << h); if (++h == 8) h = 0;}
	if (i<0) i = -i;
	i =% hshsize;

	/* search entries until found or empty */

	while (ep = hshtab[i].hnp)
		if (stcmp(np,ep)) return (&hshtab[i]);
		else if (++i>=hshsize) i=0;

	/* not found, so enter */

	if (++hshused >= hshsize) errlex (4000);

	hp = &hshtab[i];
	hp->hnp = cwp;
	hp->hclass = h_idn;

	if (np == cwp) cwp = p;	/* name already in place */
	else while (*cwp++ = *np++);	/* move name */

	return (hp);
	}

/**********************************************************************

	LOOKX - lookup current identifier

**********************************************************************/

hentry *lookx ()
	{return (lookup (&cstore[lexindex]));}

/**********************************************************************

	SETHN - Set Hash Table Entry

**********************************************************************/

sethn (hp, class, val)
	hentry *hp;

	{hp->hclass = class;
	hp->hval = val;
	}

/**********************************************************************

	MOVE - move a character into the character buffer
		and advance the input

**********************************************************************/

int move (c) char c;

	{if (cp<ecstore) *cp++ = c; else truncate=TRUE;
	return (lgetc());
	}

/**********************************************************************

	CSKIP - SKIP UNTIL END OF COMPILER CONTROL LINE

**********************************************************************/

cskip ()

	{sw_flag =| 04;
	while (lextag != LEXEOF && lextag != TEOF) tokget (TRUE);
	sw_flag =& ~04;
	}

/**********************************************************************

	SWRITE - write a character of a string constant

		If SW_FLAG, place it in CSTORE.
		Otherwise, write it on to the STRING file and
		increment STLOC.

**********************************************************************/

swrite (c)	char c;

	{if (sw_flag)
		if (cp<ecstore) *cp++ = c;
		else truncate = TRUE;
	else
		{cputc (c, f_string);
		++stloc;
		}
	}

/**********************************************************************

	CLEANUP - LEXICAL PHASE CLEANUP ROUTINE

	Write out CSTORE and exit.

**********************************************************************/

# ifndef MERGE_LP

cleanup (rcode)

	{extern int maxerr;

	wcstore ();
	cexit (rcode?rcode:maxerr>=2000);
	}

# endif

/**********************************************************************

	WCSTORE - Write CSTORE onto intermediate file

**********************************************************************/

wcstore ()

	{extern char *fn_cstore, cstore[];
	char *p;
	int f;

	f = xopen (fn_cstore, MWRITE, BINARY);
	p = cstore;

	while (p < cwp) cputc (*p++, f);
	cclose (f);
	}

/**********************************************************************

	ERRLEX - Announce error, line number from lexline

**********************************************************************/

errlex (errno, a1, a2, a3, a4) {error (errno, lexline, a1, a2, a3, a4);}
