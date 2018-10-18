# include "c.defs"
# include "its.bits"

/*

	MAKLIB

	*ITS*

	Shared C Library Construction Program

	Loads library stuff from TS CLIB into an inferior.  Writes
	pure part as a sharable file.  Constructs a MIDAS program
	to load the impure part and define all symbols.

	*** Instructions for constructing a new version of the
	    shared C library:

	1.  Edit the file MKCLIB STINKR to contain all of the
	    files you want to be in the library.  See that file
	    for further instructions.
	2.  Create a TS CLIB in the C directory by running Stinkr on
	    MKCLIB STINKR.
	3.  Create a TS MAKLIB using MAKLIB STINKR.
	4.  Run TS MAKLIB.

	The STINKR files are kept in C10LIB.

*/

# define MAXSYMS 4000		/* maximum number of symbols */
# define NAMMASK 0037777777777	/* name mask away flags */
# define SYMMASK 0037777777777	/* symtab mask for name */

struct _syment {int sym, val;};
typedef struct _syment syment;
syment symtab[MAXSYMS];
syment *csymp, *esymp;

main (argc, argv)	char *argv[];

	{int flib, fmak, version, nam, val, npage, pgno, zeroc;
	int j, jch, pch, ilo, ihi, plo, phi, count;
	char svers[20], buf[50], vbuf[100];
	filespec ff;
	syment *p;

	/* open library program file */

	pch = fopen ("TS CLIB", UII);
	if (pch < 0)
		{puts ("Unable to find TS CLIB");
		return;
		}

	/* create an inferior job */

	j = j_create (020);
	if (j < 0)
		{puts ("Unable to create inferior job");
		return;
		}

	j_name (j, &ff);
	jch = open (&ff, UII);
	if (jch < 0)
		{puts ("Unable to open inferior job");
		return;
		}

	/* load CLIB program into inferior */

	if (sysload (jch, pch))
		{puts ("Unable to load TS CLIB");
		return;
		}
	rsymtab (pch);

	flib = copen ("c/[clib].>", 'w', "b");
	if (flib < 0)
		{puts ("Unable to create library file");
		return;
		}
	filnam (itschan (flib), &ff);
	version = ff.fn2;
	c6tos (version, svers);
	apfname (buf, "c/[cmak].foo", svers);
	fmak = copen (buf, 'w');
	if (fmak < 0)
		{puts ("Unable to create maker file");
		cclose (flib);
		delete ("c/clib.>");
		return;
		}
	cprint ("Creating C library version %s\n", svers);
	cprint (fmak, ";\tSHARED C LIBRARY MAKER -- VERSION %s\n\n", svers);
	cprint (fmak, ".INSRT C;NC INSERT\n");
	cprint (fmak, "TITLE CLIB C LIBRARY VERSION %s\n\n", svers);

	p = symtab;
	while (p < csymp)
		{nam = p->sym;
		val = p->val;
		++p;
		prname (nam, fmak, 0);
		cprint (fmak, "\"=%o\n", val);
		}
	cputc ('\n', fmak);

	/* now define impure area */

	ilo = jread (lookup (rdname ("SEG0LO")), jch);
	ihi = jread (lookup (rdname ("SEG1HI")), jch);
	count = ihi - ilo + 1;

	cprint (fmak, "\t.IDATA\n\n");
	zeroc = 0;
	access (jch, ilo);
	while (--count >= 0)
		{val = uiiot (jch);
		if (val)
			{if (zeroc>0) cprint (fmak, "\tBLOCK\t%o\n", zeroc);
			zeroc = 0;
			cprint (fmak, "\t%o\n", val);
			}
		else ++zeroc;
		}
	if (zeroc>0) cprint (fmak, "\tBLOCK\t%o\n", zeroc);
	cputc ('\n', fmak);

	plo = jread (lookup (rdname ("SEG2LO")), jch);
	phi = jread (lookup (rdname ("SEG3HI")), jch);
	phi =+ 0100;
	plo =& ~01777;
	npage = (phi - plo + 02000) >> 10;
	pgno = plo >> 10;

	cprint (fmak, "IPATCH\": BLOCK 40\n\
	.CODE\n\
INIT\":	MOVEI	P,ARGV\n\
	PUSHJ	P,MAPIN\"\n\
	MOVEI	A,ZMAIN\"\n\
	HRRM	A,CALLER\"\n\
	GO	START\"\n\n\
MAPIN:	.CALL	[SETZ\n\
		SIXBIT/OPEN/\n\
		1000,,1		; CHANNEL 1\n\
		[SIXBIT/DSK/]\n\
		[SIXBIT/[CLIB]/]\n\
		[SIXBIT/%s/]\n\
		SETZ [SIXBIT/C/]\n\
		]\n\
	.VALUE	[ASCIZ/: UNABLE TO GET LIBRARY FILE /]\n\
	MOVE	A,[-%d.,,%o]\n\
	.CALL	[SETZ\n\
		'CORBLK\n\
		1000,,200000	; READ-ONLY\n\
		1000,,-1	; PUT IN MY MAP\n\
		A		; AOBJN POINTER\n\
		401000,,1	; FROM FILE\n\
		]\n\
	.VALUE	[ASCIZ/: UNABLE TO MAP IN LIBRARY FILE /]\n\
	.CLOSE	1,\n\
	POPJ	P,\n\n\
MAPOUT\":MOVE	A,[-%d.,,%o]\n\
	.CALL	[SETZ\n\
		'CORBLK\n\
		1000,,0		; DELETE\n\
		1000,,-1	; FROM ME\n\
		400000,,A	; AOBJN POINTER\n\
		]\n\
	.VALUE	[ASCIZ/: CAN'T MAP OUT LIBRARY PAGES /]\n\
	POPJ	P,\n\n\
SINIT\":	MOVE	A,[PUSHJ P,MAPIN]\n\
	MOVEM	A,ISTART\"\n\
	MOVE	A,[PUSHJ P,MAPOUT]\n\
	MOVEM	A,IDONE\"\n\
	GO	LINIT\"\n\n", svers, npage, pgno, npage, pgno);

	cprint (fmak, ".PDATA\NEND INIT\n");
	cclose (fmak);

	count = phi - plo + 1;
	count = (count + 01777) & ~01777;
	access (jch, plo);
	while (--count >= 0)
		{val = uiiot (jch);
		cputi (val, flib);
		}
	cclose (flib);

	fmak = copen (vbuf, 'w', "s");
	cprint (fmak, ":KILL\r:MIDAS C;[CREL] %s _ C;[CMAK] %s\r", svers, svers);
	cclose (fmak);
	valret (vbuf);
	}

int jread (loc, jch)

	{access (jch, loc);
	return (uiiot (jch));
	}

/**********************************************************************

	SYMBOL TABLE

**********************************************************************/

rsymtab (ch)

	{int count;
	csymp = symtab;
	esymp = symtab + MAXSYMS;

	uiiot (ch);
	count = -((uiiot (ch) >> 18) | 0777777000000) / 2;
	uiiot (ch);
	uiiot (ch);
	--count;

	while (--count >= 0)
		{int n, val;
		n = uiiot (ch) & SYMMASK;
		val = uiiot (ch);
		csymp->sym = n;
		csymp->val = val;
		++csymp;
		}
	}

int lookup (sym)

	{syment *p;

	for (p = symtab; p < csymp; ++p)
		if (p->sym == sym) return (p->val);
	puts ("symbol missing");
	return (01000000);
	}

char tab40[]	{' ', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
		'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K',
		'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V',
		'W', 'X', 'Y', 'Z', '.', '$', '%'};

rdname (p) char *p;

	{int w, factor, c;
	char *s;
	s = p;
	w = 0;
	factor = (40*40*40*40*40);
	while (c = *s++)
		{int i;
		if (c==' ') continue;
		if (factor == 0) continue;
		if (c>='a' && c<='z') c =+ ('A'-'a');
		for (i=0;i<40;++i)
			if (c == tab40[i])
				{w =+ (i * factor);
				factor =/ 40;
				break;
				}
		if (i>=40) break;
		}
	return (w);
	}

prname (n, fn, w)

	{n =& NAMMASK;
	if (n) p40 (n, fn);
	}

p40 (i, fn)

	{int a;
	if (a = i/40) p40 (a, fn);
	i =% 40;
	if (i) cputc (tab40[i], fn);
	}
