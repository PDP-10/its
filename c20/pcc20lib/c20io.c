# include <c.defs>
# undef channel
# undef _channel

/*
 *
 *	C20IO - C TOPS-20/TENEX I/O Routines (written in C)
 *
 *	Routines:
 *
 *	fd = copen (fname, mode, opt)
 *	setprompt (s)
 *	c = cgetc (fd)
 *	ungetc (c, fd)
 *	i = cgeti (fd)
 *	cputc (c, fd)
 *	cputi (i, fd)
 *	b = ceof (fd)
 *	cflush (fd)
 *	i = tell (fd)
 *	seek (fd, offset, mode)
 *	rew (fd)
 *	b = istty (fd)
 *	cclose (fd)
 *	c = getchar ()
 *	p = gets (s)
 *	putchar (c)
 *	puts (s)
 *	closall ()
 *	b = cisfd (fd)
 *	s = username ()
 *	sleep (nsec)
 *	stkdmp ()	(dummy only)
 *
 *	System-dependent routines:
 *
 *	jfn = cjfn (fd) 
 *	valret (s)	[TOPS-20 only]
 *
 *	Internal routines:
 *
 *	nonempty = refill_buffer (p)
 *	change_direction (p)
 *	n = rdtty (p->buf)
 *	ttychar (c)
 *	new = calc_hpos (strt, end, old)
 *	setup ()
 *	n = parse (s, v)
 *	setio ()
 *	fd = c0open (fname, mode)
 *	errout (s)
 *	p = mkbptr (s)
 *	p = consbp (siz, s)
 *	copen_options (mode, opt, pdir, ptype, pappend, pnew, pthaw, pbsize)
 *	c = channel_allocate ()
 *	channel_free (c, free);		free <==> free I/O buffers
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

# rename copen_options "COPTNS"
# rename channel_allocate "CHALLC"
# rename channel_free "CHFREE"

# define EOL 037		/* newline on TENEX */
# define QUOTE 026		/* control-V, for file names */
# define ARGQUOTE '\\'		/* for command args */

# define FILBUFPGS 1
# define FILBUFSIZ (FILBUFPGS << 9)
# define UBUFSIZ 15
# define PIPSIZ 4096
# define TTYLINSIZ 120

	/* file types */

# define FTTY 0		/* interactive terminal (primary I/O only) */
# define FTEXT 1	/* text file, other terminals */
# define FBIN 2		/* binary file */
# define FSTR 3		/* string I/O */
# define FPIPE 4	/* pipe (special hack file) */

# define UFLAG 010	/* indicates UNGETC'ed units available */
# define FUTTY (FTTY|UFLAG)	/* "unget" versions of these */
# define FUTEXT (FTEXT|UFLAG)
# define FUBIN (FBIN|UFLAG)
# define FUSTR (FSTR|UFLAG)
# define FUPIPE (FPIPE|UFLAG)

# define EFLAG 020		/* indicates EOF on channel */
# define FETTY (FTTY|EFLAG)	/* eof versions */
# define FETEXT (FTEXT|EFLAG)
# define FEBIN (FBIN|EFLAG)
# define FESTR (FSTR|EFLAG)
# define FEPIPE (FPIPE|EFLAG)

	/* file directions */
	/*   possible states are: */
	/*	FREAD (reading only) */
	/*	FWRITE (writing only) */
	/*	FREAD | FWRITE (reading and writing, currently writing) */
	/*	FREAD | FWRITE | FREADING (both, currently reading) */

# define FREAD 1
# define FWRITE 2
# define FREADING 4		/* currently reading */

typedef struct _channel {
	int jfn;		/* JFN */
	struct _channel *next;	/* next channel in CHANLIST */
	int ftype;		/* file type (see above) */
	int direction;		/* I/O direction */
	int bsize;		/* byte size */
	int bptr;		/* byte pointer into buffer */
	int devtype;		/* for optimization in istty */
	int bcnt;		/* number positions free/avail */
	int eof;		/* end-of-file flag (never reset) */
	int *buf;		/* buffer */
	int *ubuf;		/* unget buffer */
	int ucnt;		/* unget count */
	} *channel;

channel	c0open (), channel_allocate ();

struct _channel	cinblk,			/* standard input unit */
		coutblk,		/* standard output unit */
		cerrblk;		/* standard error output unit */

int	cin, cout, cerr;

char	*cinfn,		/* standard input file name, if redirected */
	*coutfn,	/* standard output file name, if redirected */
	*cerrfn;	/* standard errout file name, if redirected */

int	cerrno;			/* system OPEN error codes returned here */

# define tty_prompt tprmpt
# define tty_ptr tptr

static char *tty_prompt;		/* terminal prompt string */
static int tty_eof;			/* set when (unquoted) ^@, ^Z typed */
static char tty_line[TTYLINSIZ+1];	/* current output line (for prompt) */
static char *tty_ptr;			/* pointer to end of tty_line */

# rename refill_buffer "REFILL"
# rename change_direction "CHANGE"

/**********************************************************************

	COPEN - CIO Open File

	Open a file, given a file name, an optional mode, and an
	optional options string.  The possible modes are

		'r' - read
		'w' - write
		'a' - append
		'b' - both (read and write, new file, exclusive access)
		'u' - update (read and write, exclusive access)
		'm' - modify (read and write, non-exclusive access)

	The default mode is read.  Normally, I/O is character oriented
	and produces text files.  In particular, the lines of a text
	file are assumed (by the user) to be separated by newline
	characters with any conversion to the system format performed
	by the I/O routines.

	If an options string is given and contains the character "b",
	then I/O is integer (word) - oriented and produces image files.

	If the options string begins with digits, they are
	interpreted as a decimal integer to use as the byte size
	when opening the channel.  Text I/O is defaultly 7-bit,
	and binary I/O is defaultly 36-bit.  The byte size field
	is ignored for TTY and in core string I/O.

	I/O to and from character strings in core is accomplished by
	including "s" in the options string and supplying a character
	pointer to the string to be read or written into as the first
	argument to COPEN.  Closing a string open for write will
	append a NULL character to the string and return a character
	pointer to that character.

	If the filename attributes include ;PIPE, then a pipe will be
	opened using the given file name (with the ;PIPE removed from
	the name, of course).  Pipe I/O is always in 36-bit units; the
	byte size is ignored.  See C20PIP for more details.  ;PIPE is
	looked for only if the "s" option is not given.

	COPEN returns a CHANNEL, which is a pointer to a control block.
	The external variables CIN, COUT, and CERR contain already-open
	channels for standard input, standard output, and standard
	error output, respectively.

	COPEN returns OPENLOSS in case of error.  The system error code
	is stored in CERRNO.

**********************************************************************/

channel copen (fname, mode, opt)
	char *fname, *opt;

	{register channel p;
	int append;		/* TRUE if append mode */
	int thawed;		/* TRUE if thawed access */
	int direction;		/* read or write */
	int new;		/* new file ? */
	int reading, writing, both;	/* for each direction */
	int ftype;		/* file type */
	int jfn, bsize;		/* the actual jfn, desired byte size */
	int pipe;		/* is it to be a pipe ? */
	char fnbuf[100];	/* buffer for standardizing file name */

	cerrno = 0;
	copen_options (mode, opt, &direction, &ftype,
		       &append, &new, &thawed, &bsize);
	reading = ((direction & FREAD) != 0);
	writing = ((direction & FWRITE) != 0);
	both = (reading && writing);
	if (ftype == FSTR)	/* string I/O */
		{if (both) return (OPENLOSS);
		if (append) while (*fname) ++fname;
		jfn = 0;
		bsize = 36;
		}
	else if (*fname == 0 && ftype == FTEXT)
		/* primary I/O */
		{if (both) return (OPENLOSS);
		if (reading) jfn = 0100;
		else	jfn = 0101;
		bsize = 7;	/* byte size always 7 bits */
		}
	else	{/* is it to be a pipe ? */
		if (fnpipe (fname, fnbuf))
			{if (both) return (OPENLOSS);	/* one way only! */
			jfn = p = copen (fnbuf, 'm', "36b");
			if (jfn == OPENLOSS) return (OPENLOSS);
			jfn = p->jfn;
			if ((pipe = mkpipe ()) < 0)
				{/* no pipes avail; discard jfn, aborting */
				SYSCLOSF (halves (0004000, jfn));
				channel_free (p, TRUE);
				return (OPENLOSS);
				}
			bsize = 36;
			ftype = FPIPE;
			}
		else	{int oflag;		/* must GTJFN, OPENF */
			oflag = halves (1, 0);	/* GTJFN short form */
			if (new) oflag |= halves (0400000, 0);
					 /* "output" use */
			if (reading && !writing)
				oflag |= halves (0100000, 0);
					/* require old file */
			jfn = SYSGTJFN (oflag, mkbptr (fnbuf));
			if (jfn >= 0600000)
				{cerrno = jfn;
				return (OPENLOSS);
				}
			oflag = 0;
			if (reading) oflag = 0200000;
			if (writing)
				{if (append) oflag = 020000;
				else oflag |= 0100000;
				if (thawed) oflag |= 02000;
				}
			cerrno = SYSOPENF (jfn, oflag | (bsize << 30));
			if (cerrno)
				{SYSRLJFN (jfn);
				return (OPENLOSS);
				}
			}
		}

	if (ftype == FPIPE) p->jfn = pipe;
	else	{if ((p = channel_allocate ()) == 0)
			{if (ftype != FSTR)
				SYSCLOSF (halves (0004000, jfn));
				/* close, aborting */
			return (OPENLOSS);
			}
		p->jfn = jfn;
		}
	p->ftype = ftype;
	p->direction = direction;
	p->bsize = bsize;
		/* strings use a byte pointer, too, for uniform code */
		/* in other routines (cgetc, cputc) */
	if (ftype == FSTR) p->bptr = consbp (36, fname);
	if (ftype == FTEXT && istty (p) && (jfn == 0100 || jfn == 0101))
		p->ftype = FTTY;	/* really the terminal ? */
	if (p->ftype == FTTY)
		{if (reading)
			{p->buf = pg_get (FILBUFPGS);
			p->bcnt = 0;
			p->bsize = 36;
			tty_eof = FALSE;
			}
		/* no output buffer required (C20TTY keeps buffer) */
		}
	else if (p->ftype == FTEXT || p->ftype == FBIN || p->ftype == FPIPE)
		{if (p->ftype != FPIPE) p->buf = pg_get (FILBUFPGS);
		if (writing)
			{p->bcnt = FILBUFSIZ * (36 / bsize);
			p->bptr = consbp (bsize, p->buf);
			}
		else	p->bcnt = 0;
		}
	if (p->ftype == FPIPE) spipe (p->jfn, jfn, writing, PIPSIZ);
	return (p);
	}

/**********************************************************************

	FNPIPE - standardize filename and see if it is pipe

**********************************************************************/

int fnpipe (fname, fnbuf)
	char *fname, *fnbuf;

	{char dev[40], dir[40], name[40], type[40], gen[10], attr[20];
	register char *p, *q, *qq;
	int ispipe;
	fnparse (fname, dev, dir, name, type, gen, attr);
	p = q = attr;
	ispipe = FALSE;
	while (TRUE)
		{register char c;
		qq = q;
		c = *q++ = *p++;
		if (c == 0) break;
		while (TRUE)
			{c = *q++ = *p++;
			if (c == 0 || c == ';') break;
			}
		--p;
		*--q = 0;
		if (qq[0] == ';' &&
		    lower (qq[1]) == 'p' &&
		    lower (qq[2]) == 'i' &&
		    lower (qq[3]) == 'p' &&
		    lower (qq[4]) == 'e' &&
		    qq[5] == 0)
			{ispipe = TRUE;
			q = qq;
			}
		else	*q = c;
		}
	fncons (fnbuf, dev, dir, name, type, gen, attr);
	return (ispipe);
	}

/**********************************************************************

	SETPROMPT - set the terminal prompt string used when
		getting a line of edited input from the terminal

**********************************************************************/

setprompt (s)
	char *s;

	{tty_prompt = s;
	return (0);
	}

/**********************************************************************

	CGETC

**********************************************************************/

int cgetc (p)
	register channel p;

	{register int c;

	switch (p->direction) {
	case FWRITE:
		return (EOF_VALUE);	/* can't read */
	case (FREAD | FWRITE):
		change_direction (p);
		}

	switch (p->ftype) {

	case FTEXT:	/* these all just try to ILDB from the buffer, */
	case FTTY:	/* and refill it if empty, noting EOF as necessary */
	case FBIN:
	case FPIPE:
		while (--p->bcnt < 0)
			if (!refill_buffer (p))
				{p->eof = TRUE;
				p->ftype |= EFLAG;
				return (EOF_VALUE);
				}
		c = ildb (&p->bptr);
# ifdef TENEX
		/* NULLs can appear in the middle of text - ignore them */
		if (c == '\000' && p->ftype == FTEXT) return (cgetc (p));
# endif
		/* converts CRLF to newline on text input */
		if (c == '\r' && p->ftype == FTEXT)
			{char peekchar;
			if ((peekchar = cgetc (p)) == '\n') return ('\n');
			ungetc (peekchar, p);
			return (c);
			}
		return (c);

	case FSTR:
		if ((c = ildb (&p->bptr)) == 0)
			{p->ftype = FESTR;
			p->eof = TRUE;
			return (EOF_VALUE);
			}
		return (c);

	case FUTTY:	/* return any UNGETC'ed units; ubuf is used as a */
	case FUTEXT:	/* stack, and ucnt indicates the number of items */
	case FUBIN:	/* pushed back.  We must restore the correct type */
	case FUSTR:	/* when the stack becomes empty. */
	case FUPIPE:
		c = p->ubuf[--p->ucnt];
		if (p->ucnt == 0)
			{p->ftype &= ~UFLAG;
			if (p->eof) p->ftype |= EFLAG;
			}
		return (c);

	case FETTY:	/* at EOF, keep returning EOF_VALUE */
	case FETEXT:
	case FEBIN:
	case FESTR:
	case FEPIPE:
		return (EOF_VALUE);
		}
	}

/****************************************************************

	REFILL_BUFFER - internal routine to get another input
		buffer full for the specified channel

****************************************************************/

int refill_buffer (p)
	register channel p;

	{register int nc, nbytes, bp;
	bp = consbp (p->bsize, p->buf);	/* cons new byte pointer */
	switch (p->ftype) {
	case FTTY:
		nc = rdtty (p->buf);		/* special case */
		break;
	case FTEXT:
	case FBIN:
		nbytes = FILBUFSIZ * (36 / p->bsize);
		nc = SYSSIN (p->jfn, bp, -nbytes, 0);
		nc += nbytes;
		break;
	case FPIPE:
		nc = rdpipe (p->jfn, bp, FILBUFSIZ);
		}
	p->bptr = bp;	/* store new byte pointer */
	p->bcnt = nc;	/* store available count */
	return (nc != 0);	/* say if got any */
	}

/**********************************************************************

	UNGETC - push a unit back on an input channel

**********************************************************************/

ungetc (c, p)
	register channel p;

	{switch (p->direction) {
	case FWRITE:
		return;
	case (FWRITE | FREAD):
		change_direction (p);
		}
	if (p->ubuf == 0)	/* alloc a buffer, if necessary */
		{p->ubuf = salloc (UBUFSIZ);
		p->ucnt = 0;
		}
	else if (p->ucnt >= UBUFSIZ) return;	/* punt if full */
	if (p->ucnt == 0)	/* change state if previously empty */
		{p->ftype &= ~EFLAG;
		p->ftype |= UFLAG;
		}
	p->ubuf[p->ucnt++] = c;		/* finally, push unit */
	}

/**********************************************************************

	CGETI - INTs are encoded as SIXBITs on text streams

**********************************************************************/

int cgeti (p)
	channel p;

	{register int btype;
	btype = p->ftype & ~(UFLAG | EFLAG);	/* get basic type */
	if (btype == FTEXT)
		{register int i, j;
		i = 0;
		for (j = 6; j > 0; --j)  i = (i << 6) + cgetc (p) - 040;
		return (i);
		}
	else	return (cgetc (p));
	}

/**********************************************************************

	CPUTC

**********************************************************************/

int cputc (c, p)
	register int c;
	register channel p;

	{switch (p->direction) {
		case FREAD:
			return (c);
		case (FREAD | FWRITE | FREADING):
			change_direction (p);
		}
	switch (p->ftype) {

	case FTTY:	/* newline ==> CRLF; use C20TTY stuff */
		if (c == '\n')
			{tyos ("\r\n");
			tty_ptr = tty_line;
			cflush (p);
			break;
			}
		if (tty_ptr < tty_line + TTYLINSIZ) *tty_ptr++ = c;
		tyo (c);
		break;

	case FTEXT:
		if (c == '\n') cputc ('\r', p);	/* newline ==> CRLF */
	case FBIN:
	case FPIPE:
		while (--p->bcnt < 0)	/* send a full buffer */
			{++p->bcnt;	/* restore count for cflush */
			cflush (p);
			}
	case FSTR:
		idpb (c, &p->bptr);	/* store the unit */
		break;
		}
	return (c);
	}

/**********************************************************************

	CPUTI - INTs are encoded as SIXBITs on text streams

**********************************************************************/

int cputi (i, p)
	unsigned i;
	channel p;

	{int btype;
	btype = p->ftype & ~(UFLAG | EFLAG);	/* get basic type */
	if (btype == FTEXT)
		{cputc ((i >> 30) + 040, p);
		cputc (((i >> 24) & 077) + 040, p);
		cputc (((i >> 18) & 077) + 040, p);
		cputc (((i >> 12) & 077) + 040, p);
		cputc (((i >> 6) & 077) + 040, p);
		cputc ((i & 077) + 040, p);
		return (0);
		}
	else	return (cputc (i, p));
	}

/**********************************************************************

	CEOF

**********************************************************************/

int ceof (p)
	channel p;

	{if (p->ucnt > 0) return (FALSE);
	else	return (p->eof);
	}

/**********************************************************************

	CFLUSH

**********************************************************************/

cflush (p)
	register channel p;

	{register int nbytes, bp, nc;
	switch (p->direction) {
	case FREAD:
	case (FREAD | FWRITE | FREADING):
		p->bcnt = 0;
		p->ucnt = 0;
		p->ftype &= ~UFLAG;	/* restore correct type */
		if (p->eof) p->ftype |= EFLAG;
		return (0);
		}

	switch (p->ftype) {

	case FTTY:
		tyo_flush ();		/* use C20TTY's facilities */
	case FSTR:
		return (0);

	case FTEXT:	/* skip system call if nothing to do; avoids */
	case FBIN:	/* overhead, and any screws if user did a */
	case FPIPE:	/* SYSCLOSF (as in STINKR) */
		nbytes = FILBUFSIZ * (36 / p->bsize);
		bp = consbp (p->bsize, p->buf);
		nc = nbytes - p->bcnt;
		if (nc != 0)
			{if (p->ftype == FPIPE)
				wrpipe (p->jfn, bp, nc);
			else	nc += SYSSOUT (p->jfn, bp, -nc, 0);
			}
		p->bcnt = nbytes;
		p->bptr = bp;
		return (nc);
		}
	}

/**********************************************************************

	CHANGE_DIRECTION - switch between reading and writing
		use only if channel can both read and write!

**********************************************************************/

change_direction (p)
	register channel p;

	{register int dir;
	cflush (p);
	dir = (p->direction ^= FREADING);
	if (dir & FREADING) p->bcnt = 0;	/* was writing, now reading */
	else	{/* was reading, now writing */
		p->eof = FALSE;
		p->ftype &= ~EFLAG;
		p->bcnt = FILBUFSIZ * (36 / p->bsize);
		p->bptr = consbp (p->bsize, p->buf);
		}
	}

/**********************************************************************

	TELL - get position in file

**********************************************************************/

tell (p)
	register channel p;

	{register int btype;
	btype = p->ftype & ~(UFLAG | EFLAG);	/* get basic type */
	if (btype == FTEXT || btype == FBIN)
		{register int pos, n;
		switch (p->direction) {
		case FREAD:
		case (FREAD | FWRITE | FREADING):
			n = -p->bcnt;
			break;
		case FWRITE:
		case (FREAD | FWRITE):
			n = FILBUFSIZ * (36 / p->bsize) - p->bcnt;
			break;
			}
		if ((pos = SYRFPTR (p->jfn)) < 0) return (-1);
		return (pos + n);
		}
	/* TTY, string I/O, or pipe */
	return (0);
	}

/**********************************************************************

	SEEK - set position in file

**********************************************************************/

seek (p, offset, mode)
	register channel p;
	int offset, mode;

	{register int btype;
	btype = p->ftype & ~(UFLAG | EFLAG);	/* get basic type */
	if (btype == FTEXT || btype == FBIN)
		{register int pos;
		if (mode == 1)	/* adjust for buffering */
			{switch (p->direction) {
			case FREAD:
			case (FREAD | FWRITE | FREADING):
				/* not clear p->ucnt should be here ... */
				offset -= p->bcnt + p->ucnt;
				}
			}
		cflush (p);
		switch (mode) {
		case 2: /* relative to end */
			if (SYSSFPTR (p->jfn, -1) < 0) return (-1);
		case 1: /* relative to current */
			if (offset == 0) return (0);
			if ((pos = SYRFPTR (p->jfn)) < 0) return (-1);
			offset += pos;
		case 0:	/* relative to start */
			break;
			}
		p->ftype &= ~EFLAG;
		p->eof = FALSE;
		return (SYSSFPTR (p->jfn, offset));
		}
	/* no effect on TTY, string I/O, or pipes */
	return (0);
	}

/**********************************************************************

	REW - reset to beginning of file

**********************************************************************/

rew (p)
	channel p;

	{return (seek (p, 0, 0));
	}

/**********************************************************************

	ISTTY

**********************************************************************/

int istty (p)
	register channel p;

	{unsigned vals[3];

	switch (p->ftype & ~(EFLAG | UFLAG)) {
	case FSTR:
	case FPIPE:
		return (FALSE);
	case FTTY:
		return (TRUE);
		}
	if (p->devtype == -1)	/* this is a trick so DVCHR done only once */
		{register int jfn;
		if ((jfn = p->jfn) == 0100)
			jfn = (unsigned)(SYSGPJFN (0400000)) >> 18;
		else if (p->jfn == 0101) jfn = SYSGPJFN (0400000) & 0777777;
		if (jfn == 0377777)		/* .NULIO */
			p->devtype = 015;	/* .DVNUL */
		else if (jfn == 0677777)	/* .SIGIO */
			p->devtype = 012;	/* .DVTTY (assumption!) */
		else	{SYSDVCHR (p->jfn, vals);
			p->devtype = (vals[1] >> 18) & 0777;
			}
		}
	return ((p->devtype & ~01) == 012);	/* TTY or PTY */
	}

/**********************************************************************

	CCLOSE

**********************************************************************/

cclose (p)
	register channel p;

	{register int ftype;
	ftype = p->ftype & ~(EFLAG | UFLAG);
	if (ftype == FSTR)
		{char *s;
		if (p->direction & FWRITE) idpb (0, &p->bptr);
		s = p->bptr & 0777777;
		channel_free (p, TRUE);
		return (s);
		}
	if (ftype == FTTY)
		{dpyreset ();
		dpyinit ();
		}
	cflush (p);
	if (ftype == FPIPE) clpipe (p->jfn);
	else	SYSCLOSF (p->jfn);	/* close file and release jfn */
	channel_free (p, TRUE);
	return (0);
	}

/**********************************************************************

	GETCHAR - Read a character from the standard input unit

**********************************************************************/

getchar () {return (cgetc (cin));}

/**********************************************************************

	GETS - Read a string from the standard input unit

**********************************************************************/

char *gets (p)
	register char *p;

	{register int c;
	char *s;

	s = p;
	while ((c = cgetc (cin)) != '\n' && c > 0) *p++ = c;
	*p = 0;
	return (s);
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
	register char *s;

	{register int c;

	while (c = *s++) cputc (c, cout);
	cputc ('\n', cout);
	}

/**********************************************************************

	RDTTY - C buffered TTY input editing:
		implements ^@, ^I, ^J, ^L, ^M, ^R, ^U, ^V, ^W, ^Z
		display terminals handled nicely; others still edit

**********************************************************************/

# define alpha(c) ((c>='0'&&c<='9')||(c>='A'&&c<='Z')||(c>='a'&&c<='z'))
# define PRIOU 0101

int rdtty (p)		/* returns number of chars in buffer */
	register int *p;

	{register int *q, *qq, c;
	register char *prompt;		/* standardized prompt */
	int quoteflag, delflag, disp;
	if (tty_eof) return (0);
	q = p;			/* pointer to next char slot */
	delflag = quoteflag = FALSE;
	disp = isdisplay ();	/* flag for display-ness */
	*tty_ptr = 0;
	prompt = tty_line;
	if (*prompt != 0) c = utyi ();
	else	{if (tty_prompt) prompt = tty_prompt;
		c = '\022';		/* simulate ^R to start */
		}
	while (TRUE)
		{register int hpos;	/* calculate cursor position */
		hpos = calc_hpos (p, q, calc_hpos (prompt, 0, 0));

		/* check for end of deleting on non-displays */
		if (delflag && c != '\177')
			{tyo ('\\');
			delflag = FALSE;
			}

		/* check for special characters */
		if (!quoteflag) switch (c) {
		case '\r':
# ifdef TENEX
		case EOL:
# endif
			c = '\n';	/* treat as newline */
		case '\n':
			*q++ = c;	/* insert into buffer */
			break;

		case '\177':	/* rubout - rubout character */
			if (q <= p)	/* beep if none */
				{utyo ('\007');
				c = utyi ();
				continue;
				}
			--q;		/* delete it */
			if (!disp)	/* do non-display rubout stuff */
				{if (!delflag)
					{delflag = TRUE;
					tyo ('\\');
					}
				ttychar (*q);
				c = utyi ();
				continue;
				}
			/* fall through to redisplay code */

		case '\027':	/* ^W - rubout word */
			if (c == '\027')  /* so falling through works */
				{register int cc;
				if (q <= p)	/* beep if none */
					{utyo ('\007');
					c = utyi ();
					continue;
					}
				cc = q[-1];
				while (!alpha (cc) && --q > p) cc = q[-1];
				while (alpha (cc) && --q > p) cc = q[-1];
				}

		case '\025':	/* ^U - rubout line */
			if (c == '\025')  /* so falling through works */
				{if (q <= p)	/* beep if none */
					{utyo ('\007');
					c = utyi ();
					continue;
					}
				q = p;	/* just reset pointer */
				}
			if (disp)	/* redisplay by backing up cursor, */
					/* then kill to end of line */
				{register int nhpos;
				nhpos = calc_hpos (prompt, 0, 0);
				nhpos = calc_hpos (p, q, nhpos);
				while (nhpos < hpos)
					{spctty ('B');
					--hpos;
					}
				spctty ('L');
				tyo_flush ();
				c = utyi ();
				continue;
				}
			/* non-display ^W, ^U fall through here */

		case '\014':	/* ^L - clear and retype */
		case '\022':	/* ^R - just retype */
				/* more cursor, maybe clear */
				if (disp)
					{if (c == '\p') spctty ('C');
					else	tyo ('\r');
					}
				else	tyos ("\r\n");
				tyos (prompt);
				qq = p;
				while (qq < q) ttychar (*qq++);
				if (disp) spctty ('L');	/* zap rest of line */
				tyo_flush ();
				c = utyi ();
				continue;
			}
		/* here is non-special character, or \r or \n */

		/* display all except unquoted newline, ^V */
		if (quoteflag || (c != '\n' && c != '\026'))
			{if (q - p >= FILBUFSIZ - 1)
				{utyo ('\007');	  /* beep if buffer full */
				c = utyi ();
				continue;
				}
			ttychar (c);
			tyo_flush ();
			}

		/* done if unquoted ^@, ^Z, or newline */
		if (!quoteflag && (c == '\000' || c == '\032' || c == '\n'))
			{tty_eof = (c != '\n');
			tyos ("\r\n");
			tyo_flush ();
			tty_ptr = tty_line;
			return (q - p);
			}

		/* adjust quote flag */
		quoteflag = (c == '\026' && !quoteflag);
		/* add all except ^V to buffer */
		if (quoteflag)
			{int omode;	/* permit ^Q/^S to be input */
			omode = _RFMOD (PRIOU);
			if (omode & 2) _STPAR (PRIOU, omode & ~2);
			c = utyi ();
			if (omode & 2) _STPAR (PRIOU, omode);
			}
		else	{*q++ = c;	/* normal case */
			c = utyi ();
			}
		}
	}

/****************************************************************

	TTYCHAR - echo char on terminal
		converts control chars to ^letter, except \t

****************************************************************/

ttychar (c)
	register char c;

	{if (c == '\177')
		{tyos ("^?");
		return;
		}
	if (c < ' ' && c != '\t')
		{tyo ('^');
		c += 0100;
		}
	tyo (c);
	}

/****************************************************************

	CALC_HPOS - calculates position of terminal cursor after
		displaying given string via TTYCHAR

****************************************************************/

int calc_hpos (s, e, h)
	register char *s, *e;
	register int h;

	{/* s = start of string, e = end, h = initial hpos */
	register char c;
	if (e == 0)	/* calculate e if not supplied */
		{e = s;
		while (*e != 0) e++;
		}
	while (s < e)
		{c = *s++;
		if (c == '\t')
			{h = (h + 8) & ~07;  /* assumes first position is 0 */
			continue;
			}
		if (c < ' ' || c == '\177') h++;
		h++;
		}
	return (h);
	}

/**********************************************************************

	CJFN - Return JFN of file.

**********************************************************************/

int cjfn (p)
	channel p;

	{return (p->jfn);}

# define COMSIZE 500	/* size of command buffer */
# define MAXARG 100	/* maximum number of command arguments */

# rename combuf "COMBUF"
# rename argv "ARGV"
# rename argc "ARGC"
# rename setup "$SETUP"
# rename setio "$SETIO"
# rename parse "$PARSE"
# rename errout "ERROUT"
# rename pjflag "PJFLAG"
# rename riflag "RIFLAG"
# ifdef TENEX
# rename dbgflg "DBGFLG"
# endif TENEX

char combuf[COMSIZE];	/* command buffer */
char *argv[MAXARG];	/* command arguments */
int argc;		/* number of command arguments */

/**********************************************************************

	SETUP - Initialization Routine

**********************************************************************/

setup ()

	{register int n;
	tty_eof = FALSE;	/* reset global I/O stuff */
	tty_prompt = "";
	tty_ptr = tty_line;
	cin = &cinblk;
	cout = &coutblk;
	cerr = &cerrblk;
	cinfn = coutfn = cerrfn = 0;
	dpysetup ();		/* reset its stuff, too */
	dpyinit ();

# ifdef TOPS20
	n = SYSRSCAN (0);	/* command line in rescan buffer */
	if (n > 0)
		{register int i;
		SYSSIN (0777777, mkbptr (combuf), n, 0);
		i = n - 1;
		while (i >= 0)	/* remove trailing CR and NLs */
			{register int c;
			c = combuf[i];
			if (c != '\r' && c != '\n') break;
			--i;
			}
		combuf[i+1] = 0;	/* terminate string */
		}
	if (n == 0 || nojcl ())
		/* if run from IDDT or by some EXEC command, then */
		/* no jcl, so give the user a chance ... */
		{combuf[0] = '.';	/* dummy program name */
		combuf[1] = ' ';
		tty_prompt = "Command: ";
		fix_primary_io (cin, copen ("", 'r'));
		gets (&combuf[2]);
		cclose (cin);
		tty_eof = FALSE;	/* just in case */
		tty_prompt = 0;
		}
# endif
# ifdef TENEX
	combuf[0] = '.';			/* hack jcl */
	n = SYSGPJFN (0400000);			/* what is primary input ? */
	if (((unsigned)(n) >> 18) == 0777777)	/* controlling terminal */
		{extern int dbgflg;
		register char c, *p;
		if (dbgflg || _BKJFN (0100) != 0) c = ' ';
		else	c = utyi ();
		if (c == '\r' || c == '\n' || c == EOL) combuf[1] = 0;
		else	{combuf[1] = c;
			tty_prompt = "Command: ";
			if (!dbgflg) tty_ptr = stcpy (tty_prompt, tty_line);
			p = &combuf[2];
			p += rdtty (p);  /* don't copy newline */
			while (p[-1] == '\n' || p[-1] == ' ') *--p = 0;
			tty_eof = FALSE;	/* just in case */
			tty_prompt = 0;
			tty_ptr = tty_line;
			}
		}
	else	{register char *p;
		p = combuf;
		while (TRUE)
			{register char c;
			c = SYSBIN ((unsigned)(n) >> 18);
			if (c == '\r' || c == '\n' || c == EOL || c == 0)
				break;
			*p++ = c;
			}
		*p++ = 0;
		SYSSPJFN (0400000, 0777777, n & 0777777);
		}
# endif TENEX

	argc = parse (combuf, argv);	/* parse command line */
	setio ();	/* maybe redirect I/O */
	}

# ifdef TOPS20
int nojcl ()	/* just to see if RUN was used, or we are in a debugger */

	{char temp[COMSIZE];
	register char *p;
	stcpy (combuf, temp);
	p = temp;
	while (*p)
		{if (*p == ' ') {*p = 0; break;}
		*p = lower (*p); ++p;
		}
	if (stcmp (temp, "run")) return (TRUE);
	if (stcmp (temp, "r")) return (TRUE);
	/* match anything ending in "ddt" */
	if (p - temp >= 3 && stcmp (p - 3, "ddt")) return (TRUE);
	return (FALSE);
	}
# endif TOPS20

static int append, errappend;

/**********************************************************************

	PARSE - Parse Command Arguments

	given:	in -	the command string
		av -	a pointer to a character pointer array
			where pointers to the args should be placed
	returns:	number of arguments

	PJFLAG set to false suppresses parsing and I/O redirection
	RIFLAG set to false suppresses I/O redirection

	Command syntax:

		Arguments beginning with <, >, >>, %, %% do file
			redirection, a la Unix.
		(A < redirection must not have an unmatched '>'
			in the file name.)
		Arguments are separated by spaces.
		Arguments may be surrounded by "s, in which case
			embedded spaces are allowed and embedded
			"s must be doubled.
		^V and \ both prohibit the special interpretation of
			the next character (i.e., space, ", <, >, %)
		A \ is eaten, a ^V is left in the string unless it
			is followed by a - or a ?.

**********************************************************************/

int pjflag {TRUE};	/* set to false in binary file to suppress parsing */
int riflag {TRUE};	/* set to false in binary file to suppress redirect */
			/* of primary I/O; pjflag false also suppresses it */

int parse (in, av)
	register char *in, *av[];

	{register int ac;
	register char *out;

	ac = 0;
	out = in;
	append = errappend = FALSE;
	cinfn = coutfn = cerrfn = 0;

	if (!pjflag)	/* don't parse (except hack ^V, \ as usual) */
		{register int c;
		av[0] = out;
		while (TRUE)		/* get program name */
			{c = *in++;
			if (c == ' ' || c == 0) break;
			*out++ = c;
			}
		*out++ = 0;
		ac++;
		while (c == ' ') c = *in++;
		av[1] = out;
		while (c)		/* get rest of line */
			{if (c == QUOTE)
				{c = *in++;
				if (c != '?' && c != '-') *out++ = QUOTE;
				}
			else if (c == ARGQUOTE) c = *in++;
			*out++ = c;
			c = *in++;
			}
		if (out != av[1]) ac++;
		return (ac);
		}
	while (TRUE)
		{int quoteflag, firstch, secondch;
		register int c;
		register char *s;

		quoteflag = FALSE;

		/* find beginning of next arg */

		c = *in++;
		while (c == ' ') c = *in++;
		if (c == 0) break;
		if (c == '"') {quoteflag = TRUE; c = *in++;}
		if (c == 0) break;
		firstch = c;		/* \< should not be special */
		secondch = *in;		/* >\> should not be special */
		av[ac] = s = out;

		/* scan arg */

		while (TRUE)
			{if (c == 0) break;
			if (quoteflag)
				{if (c == '"')
					{c = *in++;
					if (c != '"') break;
					}
				}
			else if (c == ' ') break;
			if (c == QUOTE || c == ARGQUOTE)
				{if (c == QUOTE)
					{c = *in++;
					if (c != '?' && c != '-')
						*out++ = QUOTE;
					}
				else c = *in++;
				if (c == 0) break;
				}
			*out++ = c;
			c = *in++;
			}

		*out++ = 0;

		/* check for redirection command */

		if (ac == 0 || !riflag) firstch = -1;
		switch (firstch) {
		case '<':	/* if there is a matching '>' then this */
				/* is not a redirection command */
			{register char *p, t;
			int level;
			p = s + 1;
			level = 0;
			while (t = *p++)
				{if (t == QUOTE && *p)
					{++p; continue;}
				if (t == '<') ++level;
				if (t == '>')
					{if (level == 0) break; /* unmatched */
					--level;
					}
				}
			if (s[1] && (t != '>')) cinfn = s+1;
			else if (++ac < MAXARG) av[ac] = out;
			}
			break;
		case '>':
			if (secondch == '>')
				{if (s[2])
					{coutfn = s + 2;
					append = TRUE;
					}
				}
			else	{if (s[1])
					{coutfn = s + 1;
					append = FALSE;
					}
				}
			break;
		case '%':
			if (secondch == '%')
				{if (s[2])
					{cerrfn = s + 2;
					errappend = TRUE;
					}
				}
			else	{if (s[1])
					{cerrfn = s + 1;
					errappend = FALSE;
					}
				}
			break;
		default:
			/* normal argument */
			if (++ac < MAXARG) av[ac] = out;
			}

		if (c == 0) break;
		}
	return (ac > MAXARG ? MAXARG : ac);
	}

/**********************************************************************

	SETIO - Setup standard I/O

**********************************************************************/

setio ()

	{register int f;
	closall ();
	if (cinfn)	/* input is redirected */
		{fix_primary_io (cin, f = c0open (cinfn, 'r'));
		if (f == OPENLOSS) cinfn = 0;
		}
	if (!cinfn) fix_primary_io (cin, c0open ("", 'r'));
	if (coutfn)	/* output is redirected */
		{f = c0open (coutfn, append ? 'a' : 'w');
		fix_primary_io (cout, f);
		if (f == OPENLOSS)
			{errout ("Can't open specified output file.");
			coutfn = 0;
			}
		}
	if (!coutfn) fix_primary_io (cout, c0open ("", 'w'));
	if (cerrfn)	/* errout is redirected */
		{f = c0open (cerrfn, errappend ? 'a' : 'w');
		fix_primary_io (cerr, f);
		if (f == OPENLOSS)
			{errout ("Can't open specified error file.");
			cerrfn = 0;
			}
		}
	if (!cerrfn) fix_primary_io (cerr, copen ("", 'w'));
	}

/**********************************************************************

	C0OPEN - Open with error message

**********************************************************************/

channel c0open (name, mode)

	{register int f;

	f = copen (name, mode, 0);
	if (f == OPENLOSS)
		{errout ("Unable to ");
		if (mode != 'r') errout ("write");
		else	errout ("read");
		errout (" '");
		errout (name);
		errout ("'\r\n");
		}
	return (f);
	}

/**********************************************************************

	ERROUT - Write error message

**********************************************************************/

errout (s)
	char *s;

	{SYSPSOUT (mkbptr (s));
	}

/**********************************************************************

	MKBPTR - Make byte pointer from string

**********************************************************************/

int mkbptr (p)
	int p;

	{return (consbp (36, p));
	}

/****************************************************************

	CONSBP - Make byte pointer given byte size and buffer address

****************************************************************/

int consbp (bs, bp)
	int bs, bp;

	{return (halves (0440000 + (bs << 6), bp));}

/**********************************************************************

	COPEN_OPTIONS - Process mode and options.  Set direction,
		ftype, append, and byte size flags.

**********************************************************************/

int copen_options (mode, opt, pdirection, pftype, pappend, pnew, pthaw, pbsize)
	register char *opt;
	int *pdirection, *pftype, *pappend, *pnew, *pthaw, *pbsize;

	{register int c, x;

	if (mode < 'A' || mode > 'z') mode = 'r';
	c = opt;
	x = 0;
	if (c < 0100 || c >= halves (1, 0)) opt = "";
	else	{while (*opt >= '0' && *opt <= '9')
			x = x * 10 + (*opt++ - '0');
		if (x < 1 || x > 36) x = 0;	/* ignore bad value */
		if (opt[0]<'A' || opt[0]>'z') opt = "";
		}

	*pdirection = FREAD;
	*pappend = FALSE;
	*pnew = FALSE;
	*pthaw = FALSE;
	*pftype = FTEXT;
	*pbsize = 7;
	switch (lower (mode)) {
		case 'a':	*pappend = TRUE; *pdirection = FWRITE;
				break;
		case 'b':	*pnew = TRUE; *pdirection = (FREAD | FWRITE);
				break;
		case 'w':	*pnew = TRUE; *pdirection = FWRITE;
				break;
		case 'm':	*pthaw = TRUE;	/* fall through */
		case 'u':	*pdirection = (FREAD | FWRITE);
		default:	break;
			}
	while (c = *opt++) switch (lower (c)) {
		case 'b':	*pftype = FBIN; *pbsize = 36; break;
		case 's':	*pftype = FSTR; break;
			}
	if (x != 0) *pbsize = x;
	}

/**********************************************************************

	CHANLIST - List of open channels.

**********************************************************************/

channel chanlist;

channel channel_allocate ()

	{register channel p;
	register int sz;

	sz = sizeof (*p) / sizeof (p);
	p = salloc (sz);		/* presumed initialized to zero */
	p->next = chanlist;
	chanlist = p;
	p->devtype = -1;		/* for istty optimization */
	return (p);
	}

channel_free (p, bfree)
	register channel p;

	{register channel q, *qq;

	qq = &chanlist;
	q = *qq;
	while (q)
		{if (q == p)
			{*qq = p->next;	/* unchain */
			if (bfree)
				{if (p->buf) pg_ret (p->buf);
				if (p->ubuf) sfree (p->ubuf);
				}
			if (p != cin && p != cout && p != cerr) sfree (p);
			break;
			}
		qq = &q->next;
		q = *qq;
		}
	}

fix_primary_io (statptr, dynptr)
	channel statptr, dynptr;

	{register channel q, *qq;
	if (dynptr == OPENLOSS) return;
	smove (dynptr, statptr, sizeof (*statptr));
	channel_free (dynptr, FALSE);
	statptr->next = chanlist;
	chanlist = statptr;
	}

/**********************************************************************

	CLOSALL

**********************************************************************/

closall ()

	{while (chanlist) cclose (chanlist);
	}

/**********************************************************************

	CISFD

**********************************************************************/

int cisfd (p)
	channel p;

	{register channel q;

	q = chanlist;
	while (q)
		{if (q == p) return (TRUE);
		q = q->next;
		}
	return (FALSE);
	}

/**********************************************************************

	USERNAME

**********************************************************************/

char *username ()

	{static char buffer[40];
	register int p;
	int un;

	p = &un;
	p |= halves (0777777, 0);
	SYSGJI (-1, p, 2);	/* GETJI - read user number */
	SYSDIRST (mkbptr (buffer), un);
	return (buffer);
	}

/**********************************************************************

	VALRET - return "command string" to superior

**********************************************************************/

# ifdef TOPS20
valret (s) char *s;

	{SYSRSCAN (mkbptr (s));	/* put string in RSCAN buffer */
	SYSRSCAN (0);	/* attach RSCAN buffer to terminal input */
	_HALTF ();	/* return control to superior */
	}
# endif TOPS20

/**********************************************************************
	
	SLEEP (nsec)

**********************************************************************/

sleep (nsec)

	{SYSDSMS (nsec * 1000);}

/**********************************************************************

	STKDMP - a dummy

**********************************************************************/

stkdmp ()

	{;}
