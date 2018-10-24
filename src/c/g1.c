# include "gt.h"

/*

	GT Compiler
	Section 1: Lexical Analyzer

*/

/**********************************************************************

	A token consists of a TAG and an INDEX.
	The valid token TAGs are listed in the include file.
	The interpretation of the INDEX is dependent upon the TAG:

	T_AMOP		the number of the abstract_machine_operator
	TIDN		index of identifier name in CSTORE
	TINTCON		value of integer constant
	TSTRING		index of source representation in CSTORE
	others		the line number upon which the token appeared

**********************************************************************/

char *keyn[] {
	"typenames",
	"align",
	"pointer",
	"class",
	"conflict",
	"type",
	"memnames",
	"macros",
	"size",
	"indirect",
	"regnames",
	"returnreg",
	"saveareasize",
	"offsetrange",
	"m",
	0};

int keyv[] {
	_TYPENAMES,
	_ALIGN,
	_POINTER,
	_CLASS,
	_CONFLICT,
	_TYPE,
	_MEMNAMES,
	_MACROS,
	_SIZE,
	_INDIRECT,
	_REGNAMES,
	_RETURNREG,
	_SAVEAREASIZE,
	_OFFSETRANGE,
	_M};

/*	character type array	*/

# define _ALPHA 50	/* identifier or keyword */
# define _DIGIT 51	/* constant or identifier */
# define _QUOTE 52	/* character string indicator */
# define _AMOP 53	/* character beginning an abstract_machine_operation */
# define _EOL 54	/* newline */
# define _BLANK 55	/* blank, tab, VT, FF, CR */
# define _BAD 56	/* invalid character */
# define _MINUS 57	/* minus sign: integer or AMOP */
# define _NAME		(typ[t]==_ALPHA || typ[t]==_DIGIT)

int typ[] {
_BAD,	_BAD,	_BAD,	_BAD,	_BAD,	_BAD,	_BAD,	_BAD,
_BAD,	_BLANK,	_EOL,	_BLANK,	_BLANK,	_BLANK,	_BAD,	_BAD,
_BAD,	_BAD,	_BAD,	_BAD,	_BAD,	_BAD,	_BAD,	_BAD,
_BAD,	_BAD,	_BAD,	_BAD,	_BAD,	_BAD,	_BAD,	_BAD,
_BLANK,	_AMOP,	_QUOTE,	_BAD,	_BAD,	_AMOP,	_AMOP,	_BAD,
_LPARN,	_RPARN,	_AMOP,	_AMOP,	_COMMA,	_MINUS,	_AMOP,	_AMOP,
_DIGIT,	_DIGIT,	_DIGIT,	_DIGIT,	_DIGIT,	_DIGIT,	_DIGIT,	_DIGIT,
_DIGIT,	_DIGIT,	_COLON,	_SEMI,	_AMOP,	_AMOP,	_AMOP,	_AMOP,
_BAD,	_ALPHA,	_ALPHA,	_ALPHA,	_ALPHA,	_ALPHA,	_ALPHA,	_ALPHA,
_ALPHA,	_ALPHA,	_ALPHA,	_ALPHA,	_ALPHA,	_ALPHA,	_ALPHA,	_ALPHA,
_ALPHA,	_ALPHA,	_ALPHA,	_ALPHA,	_ALPHA,	_ALPHA,	_ALPHA,	_ALPHA,
_ALPHA,	_ALPHA,	_ALPHA,	_LBRAK,	_BAD,	_RBRAK,	_AMOP,	_ALPHA,
_BAD,	_ALPHA,	_ALPHA,	_ALPHA,	_ALPHA,	_ALPHA,	_ALPHA,	_ALPHA,
_ALPHA,	_ALPHA,	_ALPHA,	_ALPHA,	_ALPHA,	_ALPHA,	_ALPHA,	_ALPHA,
_ALPHA,	_ALPHA,	_ALPHA,	_ALPHA,	_ALPHA,	_ALPHA,	_ALPHA,	_ALPHA,
_ALPHA,	_ALPHA,	_ALPHA,	_BAD,	_OR,	_BAD,	_NOT,	_BAD};

/*	translation table	*/

int trt[] {
000,001,002,003,004,005,006,007,010,' ','\n',' ',' ',' ',016,017,
020,021,022,023,024,025,026,027,030,031,032,033,034,035,036,037,
' ','!','"','#','$','%','&','\'','(',')','*','+',',','-','.','/',
'0','1','2','3','4','5','6','7','8','9',':',';','<','=','>','?',
0100,'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o',
'p','q','r','s','t','u','v','w','x','y','z','[','\\',']','^','_',
0140,'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o',
'p','q','r','s','t','u','v','w','x','y','z','{','|','}','~',0177 };

/*	hash table, holds keywords and identifiers	*/

# define hentry struct _hentry
hentry
	{char *hnp;	/* pointer to string in cstore */
	int hclass;	/* 1 - identifier, >1 - keyword type,
			   <=0 - manifest constant, index in mcdef */
	};

/*	identifier classes	*/

# define h_idn 1

hentry	hshtab[hshsize], *lookup(), *lookx();
int	hshused 0;	/* number of entries used */

/*	character store:  holds keywords and identifiers */

char cstore[cssiz];
char *cscsp -1;		/* current string pointer: points to first
			   unused character in cstore */
char *cscnp -1;		/* current name pointer: points to last unused
			   character in cstore */
char *cp;		/* pointer to working string */

/*	communication between lexical routines	*/

extern int lextag, lexindex, lexline;

int	ccard,			/* indicates that current
				   tokens should be interpreted
				   by the lexical phase */
	lccard,			/* lgetc local ccard */
 	c,			/* current untranslated input char */
	t,			/* current translated input char */
	peekt,			/* lookahead translated character */
	truncate;		/* indicates that cstore is full */

/*	FILES		*/

int	f_source -1;		/* source file */

extern char	*fn_source;

int	i_line,			/* current line number */
	i_eof,			/* indicates end-of-file */
	i_nlflag;			/* indicates first char of line */

/*	manifest constants		*/

int 	jdefine,		/* index of "DEFINE" in hashtab */
	mcdef[mcdsz],		/* storage of manifest constant
				   definitions		*/
	*cmcdp {mcdef};		/* pointer to next free word in mcdef */

char *eopch[] {
	"-ui", "-ud", "++bi", "++ai", "--bi", "--ai", ".bnot", "!", 
	".lseq", "", ".sw", "++bc", "++ac", "--bc", "--ac", "&u0", 
	"&u1", "&u2", "&u3", "*u", "==0p0", "==0p1", "==0p2", "==0p3", 
	"!=0p0", "!=0p1", "!=0p2", "!=0p3", "", "", "", "", 
	".ci", ".cf", ".cd", ".ic", ".if", ".id", ".ip0", ".ip1", 
	".ip2", ".ip3", ".fc", ".fi", ".fd", ".dc", ".di", ".df", 
	".p0i", ".p0p1", ".p0p2", ".p0p3", ".p1i", ".p1p0", ".p1p2", ".p1p3", 
	".p2i", ".p2p0", ".p2p1", ".p2p3", ".p3i", ".p3p0", ".p3p1", ".p3p2", 
	"+i", "=+i", "+d", "=+d", "-i", "=-i", "-d", "=-d", 
	"*i", "=*i", "*d", "=*d", "/i", "=/i", "/d", "=/d", 
	"%", "=%", "<<", "=<<", ">>", "=>>", "&", "=&", 
	"^", "=^", ".or", "=or", "&&", ".tvor", "-p0p0", "=", 
	".argi", ".argd", ".arg0", ".arg1", ".arg2", ".arg3", "+p0", "+p1", 
	"+p2", "+p3", "-p0", "-p1", "-p2", "-p3", "", "", 
	".cc", ".ii", ".ff", ".dd", ".p0p0", ".p1p1", ".p2p2", ".p3p3", 
	"", "?", ".", "call", "float", "string", "int", "idn",
	"==i", "!=i", "<i", ">i", "<=i", ">=i", "==d", "!=d",
	"<d", ">d", "<=d", ">=d", "==p0", "!=p0", "<p0", ">p0",
	"<=p0", ">=p0", "==p1", "!=p1", "<p1", ">p1", "<=p1", ">=p1",
	"==p2", "!=p2", "<p2", ">p2", "<=p2", ">=p2", "==p3", "!=p3",
	"<p3", ">p3", "<=p3", ">=p3", "", "", "", "",
	"++bf", "++af", "--bf", "--af", "++bd", "++ad", "--bd", "--ad",
	"++bp0", "++ap0", "--bp0", "--ap0", "++bp1", "++ap1", "--bp1", "--ap1",
	"++bp2", "++ap2", "--bp2", "--ap2", "++bp3", "++ap3", "--bp3", "--ap3"};

/**********************************************************************

	GETTOK - Get Next Token

	Sets variables LEXTAG, LEXINDEX, LEXLINE.  This routine
	implements compiler control lines.

**********************************************************************/

gettok ()

	{while (TRUE)
		{tokget();
		if (ccard)
			{if (lextag==TIDN && lexindex==jdefine)
				defccl ();
			else	{error (1004, lexline);
				while (lextag) tokget();
				}
			continue;
			}
		return;
		}
	}

/**********************************************************************

	DEFCCL - Handle DEFINE Compiler Control Line

**********************************************************************/

defccl ()

	{hentry *hp;
	int k;

	tokget ();
	if (lextag != TIDN)
		{error (1003, lexline);
		while (lextag) tokget ();
		}
	else
		{hp = lookx ();
		k = -(cmcdp-mcdef);
		do
			{tokget();
			if(cmcdp >= &mcdef[mcdsz-1])
				error(4004, lexline);
			*cmcdp++ = lextag;
			if (lextag<TIDN) lexindex = UNDEF;
			*cmcdp++ = lexindex;
			}
		while (lextag);
		--cmcdp;
		hp->hclass = k;
		}
	}

/**********************************************************************

	TOKGET - Internal Get Token Routine

**********************************************************************/

tokget ()

	{static int *mcp, mcflag;
	int	sum, flag, i;
	char	buf[40];
	hentry	*hp;

while (TRUE)
	{if (mcflag)
		{lextag= *mcp++;
		lexindex= *mcp++;
		if (lexindex==UNDEF) lexindex=lexline;
		if (lextag) return;
		mcflag=FALSE;
		}
	if (peekt) t=peekt;
	else t=trt[lgetc()];
	if (!t) break;
	peekt=NULL;
	flag = truncate = FALSE;
	cp = cscsp;		/* character stack pointer */
	lexline = i_line;		/* lgetc current line */
	ccard =| lccard;		/* set control card indicator */
	
	switch (typ[t]) {
	
case _ALPHA:	do move(t); while (_NAME);
		*cp = 0;
		hp = lookup (cscsp);
		peekt = t;
		if (hp->hclass > 1)	/* keyword */
			{lextag = hp->hclass;
			lexindex = lexline;
			}
		else if (hp->hclass <= 0)	/* manifest constant */
			{mcflag = TRUE;
			mcp = mcdef + -hp->hclass;
			continue;
			}
		else			/* identifier */
			{lextag = TIDN;
			lexindex = hp->hnp - cstore;
			if (truncate) error (4001,lexline);
			}
		return;

case _MINUS:	move(0);	/* look at next char */
		if (typ[t] != _DIGIT)
			{peekt = '-';
			goto l_amop;
			}
		flag = TRUE;

case _DIGIT:	/* fall through */

		sum = 0;
		do
			{sum = sum*10 + t-'0';
			move (0);
			} while (typ[t] == _DIGIT);

		lextag = TINTCON;
		lexindex = (flag ? -sum : sum);
		peekt = t;
		return;

case _AMOP:	/* abstract machine operator */

l_amop:		i = 0;
		if (peekt) buf[i++]=peekt;
		do {buf[i++]=t; move(0);}
			while(typ[t]==_AMOP || typ[t]==_ALPHA
				|| typ[t]==_DIGIT || typ[t]==_MINUS );
		peekt = t;
		buf[i]=0;
		for (i=0;i<eopchsz;i++)
			if (stcmp(buf,eopch[i]))
				{lextag = T_AMOP;
				lexindex = i;
				return;
				}
		error (1002, lexline);
		continue;

case _QUOTE:			/* character string */
		lexindex = cscsp - cstore;
		move(0);		/* get next character */
		while (t)
			{if (t=='"')
				{move (0);
				if (t != '"') break;
				}
			move (c);
			}
		if (!t) error (2001, lexline);
		if (truncate) error (4001, lexline);
		lextag = TSTRING;
		cscsp = cp;
		*cscsp++ = 0;
		peekt = t;
		return;

case _EOL:	if (ccard) 
			{ccard=FALSE;
			lextag=LEXEOF;
			return;
			}

case _BLANK:	continue;

case _BAD:	error (1000, lexline);
		continue;

default:	/* single character operator */
		lextag = typ[t];
		lexindex = lexline;
		return;
		}
	}
	lextag = TEOF;
	lexindex = lexline;
	}
	
/**********************************************************************

	MOVE - Move Character Into Buffer and Advance Input

**********************************************************************/

move (u)

	{if (u) if (cp<cscnp-1) *cp++ = u; else truncate=TRUE;
	return (t=trt[c=lgetc()]);
	}

/**********************************************************************

	LOOKUP - lookup or enter a symbol in the hash table

**********************************************************************/

hentry *lookup (np) char *np;

	{int	i, u;
	char	*p, *ep;
	hentry	*hp;

	i = 0;
	p = np;
	while (u = *p++) i =+ (u & 0177);
	if (i<0) i = -i;
	i =% hshsize;

	/* search entries until found or empty */

	while (ep = hshtab[i].hnp)
		if (stcmp(np,ep)) return (&hshtab[i]);
		else if (++i>=hshsize) i=0;

	/* not found, so enter */

	if (++hshused >= hshsize) error (4000,lexline);
	while (--p >= np) *cscnp-- = *p;	/* move name */
	hp = &hshtab[i];
	hp->hnp = cscnp+1;
	hp->hclass = h_idn;
	return (hp);
	}

/**********************************************************************

	LOOKX - lookup current identifier

**********************************************************************/

hentry *lookx ()
	{return (lookup (&cstore[lexindex]));}

/**********************************************************************

	LXINIT - Lexical Phase Initializaton Routine

**********************************************************************/

lxinit()

	{int i;
	char *s;

	f_source = xopen (fn_source, MREAD, TEXT);
	cscsp = cstore;
	cscnp = &cstore[cssiz-1];
	lexline = i_line = 1;
	i_eof = FALSE;
	i_nlflag = TRUE;

	i = 0;
	while (s = keyn[i]) keyword (s, keyv[i++]);

	jdefine=lookup("define")->hnp-cstore;
	}

/**********************************************************************

	KEYWORD - Define a Reserved Word

**********************************************************************/

int keyword (s, type) int type; char *s;

	{lookup(s)->hclass = type;}

/**********************************************************************

	LGETC - Character Input Routine

**********************************************************************/

int lgetc()

	{int ch;

	if (i_eof) return (LEXEOF);

	while (TRUE)
		{ch = cgetc (f_source);
		if (ceof (f_source))
			{i_eof=TRUE;
			return (LEXEOF);
			}
		if (trt[ch]=='\n')
			{++i_line;
			lccard=FALSE;
			i_nlflag=TRUE;
			}
		else if (i_nlflag)
			{i_nlflag=FALSE;
			if (trt[ch]=='#')
				{lccard=TRUE;
				continue;
				}
			}
		return (ch);
		}
	}
