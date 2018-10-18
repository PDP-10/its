# include "c/c.defs"
# include "c/its.bits"

/*
 *
 *	CIO - C I/O Routines (written in C)
 *
 *	Routines:
 *
 *	fd = copen (fname, mode, opt)
 *	c = getchar ()
 *	gets (s)
 *	putchar (c)
 *	puts (s)
 *	ch = mopen (f, mode)
 *	rc = mclose (ch)
 *	rc = fparse (s, f)
 *	s = prfile (f, s)
 *	ch = fopen (fname, mode)
 *	ch = open (&filespec, mode)
 *	argc = fxarg (argc, argv)
 *	n = prsarg (in, out, argv, job)
 *	valret (s)
 *	c6 = ccto6 (c)
 *	c = c6toc (c6)
 *	w = csto6 (s)
 *	s = c6tos (w, s)
 *
 *	Internal routines:
 *
 *	c0init ()	[called by startup routine]
 *	fd = c0open (fname, mode)
 *	w = cons (lh, rh)
 *	s = filscan (b, s)
 *	s = c6q2s (w, s)
 *
 *	Variables:
 *
 *	cin - standard input channel
 *	cout - standard output channel
 *	cerr - standard error output channel
 *
 *	cinfn - standard input file name (if redirected)
 *	coutfn - standard output file name (if redirected)
 *	cerrfn - standard errout file name (if redirected)
 *
 *
 */

# rename c0fcbs "C0FCBS"
# rename gettab "GETTAB"
# rename puttab "PUTTAB"
# rename clotab "CLOTAB"
# rename gc_bad "GC$BAD"
# rename pc_bad "PC$BAD"
# rename cl_bad "CL$BAD"
# rename prsarg "PRSARG"
# rename fcbtab "FCBTBL"
# rename tty_input_channel "TYICHN"
# rename tty_output_channel "TYOCHN"
# rename setappend "SETAPP"

# define _magic 37621		/* a magic number for validation */
# define buf_siz 0200
# define fcb_siz 7
# define NCHANNEL 10		/* number of CHANNELs */

# define phyeof_flag 001
# define open_flag 002
# define write_flag 004
# define tty_flag 010
# define unset_flag 020

# define QUOTE 021		/* control-Q, for file names */

# define _DSK     0446353000000	/* sixbit for DSK */
# define _GREATER 0360000000000	/* sixbit for > */
# define _TTY     0646471000000	/* sixbit for TTY */
# define _FILE    0164651544516	/* sixbit for .FILE. */
# define _DIR     0104451621100	/* sixbit for (DIR) */

channel	cin,			/* standard input unit */
	cout,			/* standard output unit */
	cerr;			/* standard error output unit */

char	*cinfn,		/* standard input file name, if redirected */
	*coutfn,	/* standard output file name, if redirected */
	*cerrfn;	/* standard errout file name, if redirected */

int	cerrno;			/* system OPEN error codes returned here */

extern	int c0fcbs[], fcbtab[], puttab[], gettab[], clotab[],
	gc_bad[], pc_bad[], cl_bad[];

/**********************************************************************

	COPEN - CIO Open File

	Open a file, given a file name, an optional mode, and an
	optional options string.  The possible modes are

		'r' - read
		'w' - write
		'a' - append

	The default mode is read.  Normally, I/O is character oriented
	and produces text files.  In particular, the lines of a text
	file are assumed (by the user) to be separated by newline
	characters with any conversion to the system format performed
	by the I/O routines.

	If an options string is given and contains the character "b",
	then I/O is integer (word) - oriented and produces image files.

	I/O to and from character strings in core is accomplished by
	including "s" in the options string and supplying a character
	pointer to the string to be read or written into as the first
	argument to COPEN.  Closing a string open for write will
	append a NULL character to the string and return a character
	pointer to that character.

	COPEN returns a CHANNEL, which is a pointer to a control block.
	The external variables CIN, COUT, and CERR contain already-open
	channels for standard input, standard output, and standard
	error output, respectively.

	COPEN returns OPENLOSS in case of error.  The system error code is
	stored in CERRNO.

**********************************************************************/

channel copen (fname, mode, opt)
	char *fname;

	{int *fcbp, i, fmode, bmode, its_mode, flags;
	int chan, buffp, state, bcnt, device, c, sflag, *ip;
	char *p, buf[5], *ep;
	filespec f;

	cerrno = 0;
	if (mode<'A' || mode>'z') mode = 'r';
	p = opt;
	if (opt<0100 || opt>=01000000) p = "";
	else if (p[0]<'A' || p[0]>'z') p = "";

	flags = open_flag;
	fmode = 0;
	switch (lower (mode)) {
		case 'r':	fmode = 0; break;
		case 'w':	fmode = 1; break;
		case 'a':	fmode = 2; break;
		default:	cerrno = 012;	 /* mode not available */
				return (OPENLOSS);
			}
	bmode = 0;
	sflag = FALSE;
	while (c = *p++) switch (lower (c)) {
		case 'b':	bmode = 4; break;
		case 's':	sflag = TRUE; break;
			}

	if (c0fcbs[0] != _magic) c0init();	/* initialize */
	for (i=0; i<NCHANNEL; ++i)
		{fcbp = fcbtab[i];
		if (!(fcbp[0] & open_flag)) break;
		}
	if (i>=NCHANNEL)
		{cerrno = 06; /* device full */
		return (OPENLOSS);
		}
	chan = -1;
	buffp = fcbp[0] >> 18;
	if (sflag)	/* string I/O */
		{state = 3;
		if (fmode==2)	/* append */
			while (*fname) ++fname;
		}
	else		/* file I/O */
		{state = 1;
		fparse (fname, &f);	/* parse file name */
		if (f.dev == _TTY	/* TTY special case */
			&& (f.fn1 != _FILE || f.fn2 != _DIR))
			{state = 0;
			bmode = 0;
			device = 0;
			chan = -1;
			flags =| tty_flag;
			}
		else	/* normal case */
			{if (f.dev == 0) f.dev = _DSK;
			if (f.dir == 0) f.dir = rsname();
			if (f.fn2 == 0) f.fn2 = _GREATER;

			its_mode = (fmode==2 ? 0100001 : fmode);
			its_mode =| 2;		/* block mode */
			its_mode =| bmode;	/* image mode */

			if (fmode==2 && !bmode) /* char append */
				{chan = setappend (&f, its_mode, buf, &ep);
				if (chan == -04) /* not found */
					{chan = mopen (&f, its_mode & 077);
					fmode = 1;
					}
				}
			else chan = mopen (&f, its_mode);
			if (chan<0) {cerrno = -chan; return (OPENLOSS);}
			device = status (chan) & 077;	/* device code */
			if (bmode && device<=2)		/* TTY in IMAGE mode ?? */
				{close (chan);
				bmode = 0;
				its_mode =& ~4;
				chan = mopen (&f, its_mode);
				if (chan<0) {cerrno = -chan; return (OPENLOSS);}
				device = status (chan) & 077;
				}
			if (state==1)
				if (buffp==0)
					{buffp = salloc (buf_siz);
					if (buffp == -1)
						{cerrno = 037; /* no core available */
						return (OPENLOSS);
						}
					}
				else
					{i = buf_siz;
					ip = buffp;
					while (--i >= 0) *ip++ = 0;
					}
			}
		}
	bcnt = -1;	/* special initialization hack */
	if (fmode)
		{bcnt = 5*buf_siz;		/* char count */
		if (bmode) bcnt = buf_siz;	/* word count */
		flags =| write_flag;
		}
	if (bmode && !sflag) state = 2;
	if (chan < 0) {flags =| unset_flag; chan = 0;}
	fcbp[0] = (buffp<<18) | ((chan&017)<<14) | ((device&077)<<8) | flags;
	fcbp[2] = bcnt;
	if (sflag) fcbp[1]  = fname;
	else fcbp[1] = cons (bmode ? 0 : 0440700, buffp);
	if (fcbp[3]==0) fcbp[3] = salloc(20);
	else fcbp[3] =& 0777777;
	if (fmode) state =+ 4;
	fcbp[4] = cons (clotab[state], fcbp[5]=gettab[state]);
	fcbp[6] = puttab[state];
	if (fmode==2 && !sflag)	/* file append */
		{i = fillen (chan);
		if (bmode) access (chan, i);	/* access to end of file */
		else if (i>0)
			{access (chan, i-1);	/* write over last word */
			p = buf;
			while (p < ep) cputc (*p++ | 0400, fcbp);
			}
		}
	return (fcbp);
	}

/**********************************************************************

	SETAPPEND - Set up for character append

**********************************************************************/

int setappend (fp, mode, buf, epp) filespec *fp; char buf[], **epp;

	{int count, n, chan, wordlen, chanlen, c;
	char *p;

	count = 5;	/* try 5 times */
	while (--count>=0)
		{p = buf;
		chan = mopen (fp, UII);
		if (chan < 0) return (chan);
		wordlen = fillen (chan);
		close (chan);
		chan = mopen (fp, UAI);
		if (chan < 0) return (chan);
		chanlen = fillen (chan);
		if (chanlen > 0)
			{if (chanlen == wordlen) --chanlen;
			    else chanlen = ((chanlen-1)/5)*5;
			access (chan, chanlen);
			n = 5;
			while (--n>=0 && (c = uiiot (chan)) >= 0 && c != 3)
				*p++ = c;
			}
		close (chan);
		*epp = p;
		chan = mopen (fp, mode);
		if (chan<0) return (chan);
		if (wordlen == fillen(chan)) return (chan);
		close (chan);
		}
	return (-012);
	}

/**********************************************************************

	GETCHAR - Read a character from the standard input unit

**********************************************************************/

getchar () {return (cgetc (cin));}

/**********************************************************************

	GETS - Read a string from the standard input unit

**********************************************************************/

gets (p)
	char *p;

	{int c;

	while ((c = cgetc (cin)) != '\n' && c>0) *p++ = c;
	*p = 0;
	}

/**********************************************************************

	PUTCHAR - Output a character to the standard output unit

**********************************************************************/

putchar (c)
	int c;

	{return (cputc (c, cout));}

/**********************************************************************

	PUTS - Output a string to the standard output unit

**********************************************************************/

puts (s)
	char *s;

	{int c;

	while (c = *s++) cputc (c, cout);
	cputc ('\n', cout);
	}

/**********************************************************************

	MOPEN - OPEN FILE

	Open file given filespec and mode.
	Return ITS channel number or -FC if unsuccessful.
	Same as OPEN, except handles TTY specially
		and waits if file is locked.

**********************************************************************/

channel mopen (f, mode)	filespec *f; int mode;

	{int ch, n;

	if (f->dev == _TTY && !(f->fn1 == _FILE && f->fn2 == _DIR))
		return (mode & 1 ? tyoopn() : tyiopn());

	ch = open (f, mode);
	n = 8;
	while (ch == -023 && --n>=0)	/* file locked */
		{sleep (30);
		ch = open (f, mode);
		}
	return (ch);
	}

/**********************************************************************

	MCLOSE - Close ITS channel, unless its the TTY.

**********************************************************************/

mclose (ch)	channel ch;

	{extern int tty_input_channel, tty_output_channel;
	if (ch == tty_input_channel) return (0);
	if (ch == tty_output_channel)
		{tyo_flush ();
		return (0);
		}
	return (close (ch));
	}

/**********************************************************************

	FPARSE - Convert an ASCIZ string representation of an ITS
		file name or a path name to a FILESPEC.

		Return 0 if OK, -1 if bad path name format.

**********************************************************************/

fparse (s, f)	char s[]; filespec *f;

	{int i, c, fnc, n_slash, no_its_chars, n_dot;
	char buf[7], *p, *filscan();

	f->dev = f->dir = f->fn1 = f->fn2 = 0;

	/*	check for path name	*/

	p = s;
	no_its_chars = TRUE;
	n_slash = n_dot = 0;

	while (c = *p++) switch (c) {
	case QUOTE:	if (*p) ++p; break;
	case '.':	++n_dot; break;
	case '/':	++n_slash; break;
	case ' ':
	case ':':
	case ';':	no_its_chars = FALSE; break;
			}

	if (no_its_chars && (n_dot>0 || n_slash>0))

	/*	here if path name	*/

		{p = s;
		if (*p=='/')
			{--n_slash;
			p = filscan (buf, ++p, &n_dot, &n_slash);
			f->dev = csto6(buf);
			c = *p++;
			if (c!='/') return (-1);
			}
		p = filscan (buf, p, &n_dot, &n_slash);
		c = *p++;
		if (c=='/')
			{f->dir = csto6(buf);
			p = filscan (buf, p, &n_dot, &n_slash);
			c = *p++;
			}
		if (c=='.')
			{f->fn1 = csto6(buf);
			p = filscan (buf, p, &n_dot, &n_slash);
			c = *p++;
			}
		if (f->fn1) f->fn2 = csto6(buf);
			else f->fn1 = csto6(buf);
		return (0);
		}

	/*	here if ITS file name	*/

	p = s;
	fnc = i = 0;
	buf[0] = 0;

	do	{c = *p++;
		switch (c) {

	case ':':	f->dev = csto6(buf);
			i = 0;
			break;

	case ';':	f->dir = csto6(buf);
			i = 0;
			break;

	case ' ':
	case 0:		if (buf[0]) switch (fnc++) {
			case 0:	f->fn1 = csto6(buf); break;
			case 1:	f->fn2 = csto6(buf); break;
				}
			i = 0;
			break;

	default:	if (c==QUOTE && *p) c = *p++;
			if (i<6) buf[i++] = c;
			}

		buf[i] = 0;
		}
		while (c);
	return (0);
	}

/**********************************************************************

	FILSCAN - scan for part of file name

**********************************************************************/

char *filscan (b, q, andot, anslash)
	char *b, *q;
	int *andot, *anslash;

	{int c;
	char *p;

	p = q++;
	while (c = *p++)
		{if (c=='/') {--*anslash; break;}
		else if (c=='.')
			{if (--*andot == 0 && *anslash==0 && *p &&
				p!=q) break;}
		else if (c==QUOTE && *p) c = *p++;
		*b++ = c;
		}
	*b = 0;
	return (--p);
	}

/**********************************************************************

	PRFILE - convert FILESPEC to ITS file name

**********************************************************************/

char *prfile(f,p)	filespec *f; char *p;

	{char *c6q2s();
	if (f->dev) {p = c6q2s (f->dev, p); *p++ = ':';}
	if (f->dir) {p = c6q2s (f->dir, p); *p++ = ';';}
	if (f->fn1) {p = c6q2s (f->fn1, p); *p++ = ' ';}
	if (f->fn2) {p = c6q2s (f->fn2, p);}
	*p = 0;
	return (p);
	}

/**********************************************************************

	FOPEN - Open file given file name

**********************************************************************/

channel fopen (fname, mode)	char *fname; int mode;

	{filespec f;

	fparse (fname, &f);
	if (f.dev == 0) f.dev = _DSK;
	if (f.dir == 0) f.dir = rsname();
	return (open (&f, mode));
	}

/**********************************************************************

	OPEN - Open file given filespec

**********************************************************************/

channel open (f, mode)		filespec *f; int mode;

	{channel c;
	int rc;

	c = chnloc();
	if (c<0) return (-014);	/* bad channel number */
	rc = sysopen (c, f, mode);
	if (rc) return (rc);
	return (c);
	}

/**********************************************************************

	FXARG - Process Command Arguments to Set Up
		Redirection of Standard Input and Output

	This routine is called by the C start-up routine.

**********************************************************************/

int fxarg (argc, argv)	int argc; char *argv[];

	{char	**p, **q, *s;
	int	i, append, errappend, f;

	i = argc;	/* number of arguments given */
	argc = 0;	/* number of arguments returned */
	p = argv;	/* source pointer */
	q = argv;	/* destination pointer */

	while (--i >= 0)	/* for each argument given */
		{s = *p++;	/* the argument */
		switch (s[0]) {
		case '<':	if (s[1]) cinfn = s+1; break;
		case '>':	if (s[1] == '>')
					{if (s[2]) {coutfn = s+2; append = TRUE;}}
				else {if (s[1]) {coutfn = s+1; append = FALSE;}}
				break;
		case '%':	if (s[1] == '%')
					{if (s[2]) {cerrfn = s+2; errappend=TRUE;}}
				else {if (s[1]) {cerrfn = s+1; errappend = FALSE;}}
				break;
		default:	/* normal argument */
				++argc; *q++ = s;
				}
		}

	/* now hack the standard file descriptors */

	if (cinfn)	/* input is redirected */
		{f = c0open (cinfn, 'r');
		if (f != OPENLOSS) {cclose (cin); cin = f;}
		}

	if (coutfn)	/* output is redirected */
		{f = c0open (coutfn, append ? 'a' : 'w');
		if (f != OPENLOSS) {cout = f;}
		}

	if (cerrfn)	/* errout is redirected */
		{f = c0open (cerrfn, errappend ? 'a' : 'w');
		if (f != OPENLOSS)
			{if (cerr!=cout) cclose (cerr); cerr = f;}
		}
	return (argc);
	}

/**********************************************************************

	C0OPEN - Open with error message

**********************************************************************/

channel c0open (name, mode)

	{channel f;

	f = copen (name, mode, 0);
	if (f == OPENLOSS) cprint (cerr, "Unable to open '%s'\n", name);
	return (f);
	}

/**********************************************************************

	C0INIT - Initialization for C I/O Routines.
	This routine is normally called first by the C start-up routine.

**********************************************************************/

c0init ()

	{int *p, i;

	c0fcbs[0] = _magic;
	p = &c0fcbs[1];
	i = NCHANNEL*fcb_siz;
	while (--i >= 0) *p++ = 0;
	i = NCHANNEL;
	while (--i >= 0)	
		{p = &c0fcbs[fcb_siz*i+5];
		p[0] = cons (cl_bad, gc_bad);
		p[1] = gc_bad;
		p[2] = pc_bad;
		}

	cin = copen ("/tty", 'r', 0);		/* standard input */
	cout = cerr = copen ("/tty", 'w', 0);	/* standard output */

	/* These calls do not actually open the TTY, the TTY is
	automatically opened when I/O is done to it.  This is helpful
	for allowing C programs to run without the TTY. */
	}

/**********************************************************************

	VALRET - Valret a String

**********************************************************************/

valret (s)	char *s;

	{int len, bp1, bp2, buf, c, flag;

	flag = FALSE;
	len = slen (s);
	buf = salloc (len/5 + 1);
	if (buf<=0)
		{buf=s;		/* gross hack */
		flag = TRUE;
		}
	bp1 = bp2 = 0440700000000 | buf;

	while (TRUE)
		{c = *s++;
		if (c=='\n') c='\r';
		idpb (c, &bp1);
		if (!c) break;
		}

	val7ret (bp2);
	if (flag) cquit(1); else sfree (buf);
	}

/**********************************************************************

	PRSARG - Parse JCL Arguments (PDP-10 ITS)

	given:	in -	an advance byte pointer to the JCL
		out -	a pointer to a character buffer where the
			arguments should be placed
		argv -	a pointer to a character pointer array
			where pointers to the args should be placed
		job -	the sixbit XJNAME
		narg -	the maximum number of arguments
	returns:	number of arguments

**********************************************************************/

int prsarg (in, out, argv, job, narg)
	char *out, *argv[];

	{int c, argc;
	char *c6tos();

	argc = 1;
	argv[0] = out;
	out = c6tos (job, out);
	*out++ = 0;
	argv[1] = out;

	while (c = ildb (&in))
		{switch (c) {
	case '\r':	break;
	case QUOTE:	*out++ = ildb (&in); continue;
	case ' ':	continue;
	case '"':	while (c = ildb (&in))
				{switch (c) {
			case '\r':	break;
			case QUOTE:	*out++ = ildb (&in); continue;
			case '"':	break;
			default:	*out++ =  c; continue;
					}
				break;
				}
			*out++ = 0;
			if (++argc < narg) argv[argc] = out;
			if (c=='"') continue;
			break;
	default:	*out++ = c;
			while (c = ildb (&in))
				{switch (c) {
			case '\r':	break;
			case ' ':	break;
			case QUOTE:	*out++ = ildb (&in); continue;
			default:	*out++ = c; continue;
					}
				break;
				}
			*out++ = 0;
			if (++argc < narg) argv[argc] = out;
			if (c==' ') continue;
			break;
			}
		break;
		}
	return (argc>narg ? narg : argc);
	}

/**********************************************************************

	CONS - construct word from left and right halves

**********************************************************************/

int cons (lh, rh) {return (((lh & 0777777) << 18) | (rh & 0777777));}


/**********************************************************************

	CCTO6 - convert ascii character to sixbit character

**********************************************************************/

char ccto6 (c) char c;

	{return (((c>=040 && c<0140) ? c+040 : c) & 077);}

/**********************************************************************

	C6TOC - convert sixbit character to ascii character

**********************************************************************/

char c6toc (c) char c;

	{return (c+040);}

/**********************************************************************

	CSTO6 - convert ascii string to left-justified sixbit

**********************************************************************/

int csto6 (s) char *s;

	{int c,i,j;

	i=0;
	j=30;
	while (c = *s++) if (j>=0)
		{i =| (ccto6(c)<<j);
		j =- 6;
		}
	return (i);
	}

/**********************************************************************

	C6TOS - convert left-justified sixbit word to ascii string

**********************************************************************/

char *c6tos (i, p)	int i; char *p;

	{int c,j;

	j = 30;
	while (j>=0 && (c = (i>>j)&077))
		{*p++ = c6toc(c); j =- 6;}
	*p = 0;
	return (p);
	}

/**********************************************************************

	C6Q2S - convert left-justified sixbit word to ascii string,
		inserting QUOTE characters, where necessary

**********************************************************************/

char *c6q2s (i, p)	int i; char *p;

	{int c, j;

	j = 30;
	while (j>=0)
		{c = c6toc ((i>>j) & 077);
		if (c==' ' || c==':' || c==';') *p++ = QUOTE;
		*p++ = c;
		if (! (i & ((1<<j) - 1))) break;
		j =- 6;
		}
	*p = 0;
	return (p);
	}

