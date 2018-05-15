# include <stdio.h>
# include <ctype.h>

/************************************************************************

	C20IO - C TOPS-20/TENEX I/O Routines 
	Note: Must # include <stdio.h>.
	

	Functions defined, either here, in the auxiliary files of
	the library, or as macros in STDIO.H:

	  Functions similar to UNIX standard I/O:
	 
	fileptr	= fopen	(name, mode)
	fileptr	= freopen (name, mode, fileptr)
	c = getc (fileptr)
	c = fgetc (fileptr)
	i = getw (fileptr)
	c = putc (c, fileptr)
	c = fputc (f, fileptr)
	fclose (fileptr)
	fflush (fileptr)
	exit (errcode)		- flush buffers, close files, and exit
	_exit (errcode)		- just exit. This is continuable
	b = feof (fileptr)
	c = getchar ()
	putchar	(c)
	s = gets (s)
	s = fgets (s, n, fileptr)
	puts (s)
	fputs (s, fileptr)
	putw (i, fileptr)
	i = getw (filptr)
	ungetc (c, fileptr)
	printf (format,	a1, ...)
	fprintf	(fileptr, format, a1, ...)
	sprintf	(buf, format, a1, ...)
	scanf (format, a1, ...)
	fscanf (fileptr, format, a1, ...)
	sscanf (s, format, a1, ...)
	fread (ptr, itemsize, nitems, fileptr)	 these use getw, putw 
	fwrite (ptr, itemsize, nitems, fileptr)
**	fcread (ptr, itemsize, nitems, fileptr)	 these use getc, putc 
**	fcwrite (ptr, itemsize, nitems, fileptr)
	rewind (fileptr)
	fileno (fileptr)
	fseek (fileptr, offset, mode)
	i = ftell (fileptr)
	i = atoi (s)			(in C20ATI.C)
	itoa (n, s)			(in C20ATI.C)
	d = atof (s)			(in C20FPR.C)
	ftoa (d, s, p, f)		(in C20ATI.C)
	i = strcmp (s1,	s2)		(in C20STR.MID)
	strcpy (dest, source)		(in C20STR.MID)
	strcat (dest, source)		(in C20STR.MID)
	i = strlen (s)			(in C20STR.MID)
	sleep(i) 		- sleep i seconds
	unlink (s) 		- delete and expunge the file
	uid = getuid ()		- get user number
	buf = getpw (uid, buf)	- writes user name into	buf
	p = malloc (size)		(in C20MEM.C)
	p = calloc (num, size)		(in C20MEM.C)
	free (ptr)			(in C20MEM.C)

	  Other Routines:

	username () - returns a pointer to string containing users name
	valret (s)  - return a command string to the superior program
	delete (fp) - Delete, but do not expunge, the file
	tmpnam (bp) - Cons a temp file name. Not like the UNIX one at all.

	Routines from stdio not implemented:

	ferror, system, abort, intss, wdleng, nargs, setbuf, gcvt

	See C20PRT.C for information about PRINTF formats.

** = hack routines to provide functionality not otherwise available

**********************************************************************/

static fnpipe();
static refill_buffer(),change_direction();
static istty(),rdtty(),ttychar(),calc_hpos();
static FILE *channel_allocate();
static channel_free();
static setio(),parse(),errout();
static do_options(),fix_primary_io();

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

static FILE *eopen (),*channel_allocate ();
char *pg_get();

static FILE sinfb;			/* standard input file data block */
static FILE soutb;			/* standard output file block */
static FILE serrb;			/* standard error file block */

FILE *stdin,*stdout,*stderr;

static char *sinfn,	/* standard input file name, if redirected */
	    *soutfn,	/* standard output file name, if redirected */
	    *serrfn;	/* standard errout file name, if redirected */

int	cerrno;			/* system OPEN error codes returned here */

# define tty_prompt tprmpt
# define tty_ptr tptr

static char *tty_prompt;		/* terminal prompt string */
static int tty_eof;			/* set when (unquoted) ^@, ^Z typed */
static char tty_line[TTYLINSIZ+1];	/* current output line (for prompt) */
static char *tty_ptr;			/* pointer to end of tty_line */

# define FALSE 0
# define TRUE  1

/**********************************************************************

	FOPEN - Open File

	Open a file, given a file name and an optional options string.  

	The first letter of the options string controls the mode the
	file is opened in. The possible modes are:

		r - read
		w - write
		a - append
		b - both (read and write, new file, exclusive access)
		u - update (read and write, exclusive access)
		m - modify (read and write, non-exclusive access)

	The default mode is read.  Normally, I/O is character oriented
	and produces text files.  In particular, the lines of a text
	file are assumed (by the user) to be separated by newline
	characters with any conversion to the system format performed
	by the I/O routines.

	Any additional characters in the options string specify 
	non-standard file operations or modes. There are several of
	these, as follows:

	If the options string contains the character "b", then I/O is 
	integer (word) - oriented and produces image files.

	If the "additional characters" of the option string begin with
	digits, they are interpreted as a decimal integer to use as
	the byte size when opening the file.  Text I/O is defaultly 
	7-bit, and binary I/O is defaultly 36-bit.  The byte size field
	is ignored for TTY and in core string I/O.

	I/O to and from character strings in core is accomplished by
	including "s" in the options string and supplying a character
	pointer to the string to be read or written into as the first
	argument to FOPEN.  Closing a string open for write will
	append a NULL character to the string and return a character
	pointer to that character.

	If the filename attributes include ;PIPE, then a pipe will be
	opened using the given file name (with the ;PIPE removed from
	the name, of course).  Pipe I/O is always in 36-bit units; the
	byte size is ignored.  See C20PIP for more details.  ;PIPE is
	looked for only if the "s" option is not given.

	FOPEN returns a pointer to a FILE structure which contains
	the necessary information for performing I/O functions using
	the file. The global variables "stdin", "stdout", and "stderr"
	point to already-open channels for the standard input, standard 
	output, and standard error output, respectively.

	FOPEN returns NULL in case of error.  The system error code
	is stored in the global variable "cerrno".

**********************************************************************/

FILE *fopen (fname, opt)
char *fname,*opt;
{
	register FILE *p;
	int append;			/* TRUE if append mode */
	int thawed;			/* TRUE if thawed access */
	int direction;			/* read or write */
	int new;			/* new file ? */
	int reading, writing, both;	/* for each direction */
	int ftype;			/* file type */
	int jfn, bsize;			/* the actual jfn, desired byte size */
	int pipe;			/* is it to be a pipe ? */
	char fnbuf[100];		/* buf for standardizing file name */

	cerrno = 0;
	do_options (opt,&direction,&ftype,&append,&new,&thawed,&bsize);
	reading = ((direction & FREAD) != 0);
	writing = ((direction & FWRITE) != 0);
	both = (reading && writing);
	if (ftype == FSTR) {		/* string I/O */
		if (both) return (NULL);
		if (append) while (*fname) ++fname;
		jfn = 0;
		bsize = 36;
	}
	else if (*fname == 0 && ftype == FTEXT) {	/* primary I/O */
		if (both) return (NULL);
		if (reading) jfn = 0100;
		else	jfn = 0101;
		bsize = 7;			/* byte size always 7 bits */
	}
	else	{				/* is it to be a pipe ? */
		if (fnpipe (fname, fnbuf)) { 
			if (both) return(NULL); /*one way only!*/
			p = fopen (fnbuf, "m36b");
			if (p == NULL) return (NULL);
			jfn = p->jfn;
			if ((pipe = mkpipe ()) < 0) {
				/* no pipes avail; discard jfn, aborting */
				_CLOSF (halves (0004000, jfn));
				channel_free (p, TRUE);
				return (NULL);
			}
			bsize = 36;
			ftype = FPIPE;
		}
		else	{		/* must GTJFN, OPENF */
			int oflag;

			oflag = halves (1, 0);	/* GTJFN short form */
			if (new) 
				/* "output" use */
				oflag |= halves (0400000, 0);
			if (reading && !writing)
				/* require old file */
				oflag |= halves (0100000, 0);
			jfn = _GTJFN (oflag, mkbptr (fnbuf));
			if (jfn >= 0600000) {
				cerrno = jfn;
				return (NULL);
			}
			oflag = 0;
			if (reading) oflag = 0200000;
			if (writing) {
				if (append) oflag = 020000;
				else oflag |= 0100000;
				if (thawed) oflag |= 02000;
			}
			cerrno = _OPENF (jfn, oflag | (bsize << 30));
			if (cerrno) {
				_RLJFN (jfn);
				return (NULL);
			}
		}
	}
	/* file open, now set up FILE block */

	if (ftype == FPIPE) p->jfn = pipe;
	else	{
		if ((p = channel_allocate ()) == 0) {
			if (ftype != FSTR)
				/* close, aborting */
				_CLOSF (halves (0004000, jfn));
			return (NULL);
		}
		p->jfn = jfn;
	}
	p->ftype = ftype;
	p->direction = direction;
	p->bsize = bsize;
		/* strings use a byte pointer, too, for uniform code */
		/* in other routines */
	if (ftype == FSTR) p->bptr = consbp (36, fname);
	if (ftype == FTEXT && istty (p) && (jfn == 0100 || jfn == 0101))
		p->ftype = FTTY;	/* really the terminal ? */
	if (p->ftype == FTTY) {
		/* output buffering handled by C20TTY */
		if (reading) {
			p->buf = pg_get (FILBUFPGS);
			p->bcnt = 0;
			p->bsize = 36;
			tty_eof = FALSE;
		}
	}
	else if (p->ftype == FTEXT || p->ftype == FBIN || p->ftype == FPIPE) {
		if (p->ftype != FPIPE) p->buf = pg_get (FILBUFPGS);
		if (writing) {
			p->bcnt = FILBUFSIZ * (36 / bsize);
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

static int fnpipe (fname, fnbuf)
char *fname, *fnbuf;
{
	char dev[40], dir[40], name[40], type[40], gen[10], attr[20];
	register char *p, *q, *qq;
	int ispipe;

	fnparse (fname, dev, dir, name, type, gen, attr);
	p = q = attr;
	ispipe = FALSE;
	while (TRUE) {
		register char c;

		qq = q;
		c = *q++ = *p++;
		if (c == 0) break;
		while (TRUE) {
			c = *q++ = *p++;
			if (c == 0 || c == ';') break;
		}
		--p;
		*--q = 0;
		if (qq[0] == ';' &&
		   (qq[1] == 'p' || qq[1] == 'P') &&
		   (qq[2] == 'i' || qq[2] == 'I') &&
		   (qq[3] == 'p' || qq[3] == 'P') &&
		   (qq[4] == 'e' || qq[4] == 'E') &&
		   qq[5] == 0) {
			ispipe = TRUE;
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
{
	tty_prompt = s;
	return (0);
}

/**********************************************************************

	FREOPEN - open a different file with the same FILE pointer

**********************************************************************/

FILE *freopen (name, mode, file)
char *name, *mode;
{
	int i;
	fclose (file);
	return (fopen (name, mode));
}


/**********************************************************************

	GETC

**********************************************************************/

int getc (p)
register FILE *p;
{
	register int c;

	switch (p->direction) {
	case FWRITE:
		return (EOF);	/* can't read */
	case (FREAD | FWRITE):
		change_direction (p);
	}

	switch (p->ftype) {

	case FTEXT:	/* these all just try to ILDB from the buffer, */
	case FTTY:	/* and refill it if empty, noting EOF as necessary */
	case FBIN:
	case FPIPE:
		while (--p->bcnt < 0)
			if (!refill_buffer (p)) {
				p->eof = TRUE;
				p->ftype |= EFLAG;
				return (EOF);
			}
		c = ildb (&p->bptr);
/* # ifdef TENEX ... Twenex does this on FORTRAN text I/O */
		/* NULLs can appear in the middle of text - ignore them */
		if (c == '\000' && p->ftype == FTEXT) return (getc (p));
/*  # endif  */
		/* converts CRLF to newline on text input */
		if (p->ftype == FTEXT && c == '\r') {
			char peekchar;

			if ((peekchar = getc (p)) == '\n') return ('\n');
			ungetc (peekchar, p);
		}
		return (c);

	case FSTR:
		if ((c = ildb (&p->bptr)) == 0) {
			p->ftype = FESTR;
			p->eof = TRUE;
			return (EOF);
		}
		return (c);

	case FUTTY:	/* return any UNGETC'ed units; ubuf is used as a */
	case FUTEXT:	/* stack, and ucnt indicates the number of items */
	case FUBIN:	/* pushed back.  We must restore the correct type */
	case FUSTR:	/* when the stack becomes empty. */
	case FUPIPE:
		c = p->ubuf[--p->ucnt];
		if (p->ucnt == 0) {
			p->ftype &= ~UFLAG;
			if (p->eof) p->ftype |= EFLAG;
		}
		return (c);

	case FETTY:	/* at EOF, keep returning EOF_VALUE */
	case FETEXT:
	case FEBIN:
	case FESTR:
	case FEPIPE:
		return (EOF);
	}
}

/****************************************************************

	REFILL_BUFFER - internal routine to get another input
		buffer full for the specified channel

****************************************************************/

static int refill_buffer (p)
register FILE *p;
{
	register int nc, nbytes, bp;

	bp = consbp (p->bsize, p->buf);		/* cons new byte pointer */
	switch (p->ftype) {
	case FTTY:
		nc = rdtty (p->buf);		/* special case */
		break;
	case FTEXT:
	case FBIN:
		nbytes = FILBUFSIZ * (36 / p->bsize);
		nc = _SIN (p->jfn, bp, -nbytes, 0);
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
register FILE *p;
{
	switch (p->direction) {
	case FWRITE:
		return;
	case (FWRITE | FREAD):
		change_direction (p);
	}
	/* alloc a buffer, if necessary */
	if (p->ubuf == NULL) {
		p->ubuf = malloc (UBUFSIZ);
		p->ucnt = 0;
	}
	/* punt character if full */
	else if (p->ucnt >= UBUFSIZ) return;
	/* change state if previously empty */
	if (p->ucnt == 0) {
		p->ftype &= ~EFLAG;
		p->ftype |= UFLAG;
	}
	p->ubuf[p->ucnt++] = c;		/* finally, push unit */
}

/**********************************************************************

	GETW - INTs are encoded as SIXBITs on text streams

**********************************************************************/

int getw (p)
register FILE *p;
{
	register int btype;

	btype = p->ftype & ~(UFLAG | EFLAG);	/* get basic type */
	if (btype == FTEXT) {
		register int i, j;

		i = 0;
		for (j = 6; j > 0; --j)  i = (i << 6) + getc (p) - 040;
		if (feof(p)) return (EOF);
		else return (i);
	}
	else	return (getc (p));
}

/**********************************************************************

	PUTC

**********************************************************************/

int putc(c, p)
register int c;
register FILE *p;
{
	switch (p->direction) {
		case FREAD:
			return (c);
		case (FREAD | FWRITE | FREADING):
			change_direction (p);
	}
	switch (p->ftype) {

	case FTTY:	/* newline ==> CRLF; use C20TTY stuff */
		if (c == '\n') {
			tyos ("\r\n");
			tty_ptr = tty_line;
			fflush (p);
			break;
		}
		if (tty_ptr < tty_line + TTYLINSIZ) *tty_ptr++ = c;
		tyo (c);
		break;

	case FTEXT:
		if (c == '\n') putc ('\r', p);	/* newline ==> CRLF */
	case FBIN:
	case FPIPE:
		while (--p->bcnt < 0) {		/* send a full buffer */
			++p->bcnt;		/* restore count for fflush */
			fflush (p);
		}
	case FSTR:
		idpb (c, &p->bptr);	/* store the unit */
		break;
	}
	return (c);
}

/**********************************************************************

	PUTW - INTs are encoded as SIXBITs on text streams

**********************************************************************/

int putw(i, p)
register unsigned i;
register FILE *p;
{
	int btype;

	btype = p->ftype & ~(UFLAG | EFLAG);	/* get basic type */
	if (btype == FTEXT) {
		putc ((i >> 30) + 040, p);
		putc (((i >> 24) & 077) + 040, p);
		putc (((i >> 18) & 077) + 040, p);
		putc (((i >> 12) & 077) + 040, p);
		putc (((i >> 6) & 077) + 040, p);
		putc ((i & 077) + 040, p);
		return (0);
	}
	else	return (putc (i, p));
}

/**********************************************************************

	FEOF

**********************************************************************/

int feof (p)
FILE *p;
{
	if (p->ucnt > 0) return (FALSE);
	else	return (p->eof);
}

/**********************************************************************

	FFLUSH

**********************************************************************/

fflush (p)
register FILE *p;
{
	register int nbytes, bp, nc;
	
	switch (p->direction) {
	case FREAD:
	case (FREAD | FWRITE | FREADING):	/* flush buffers */
		p->bcnt = 0;
		p->ucnt = 0;
		p->ftype &= ~UFLAG;		/* restore correct type */
		if (p->eof) p->ftype |= EFLAG;
		return(EOF);
	}

	switch (p->ftype) {

	case FTTY:
		tyo_flush ();		/* use C20TTY's facilities */
	case FSTR:
		return (EOF);

	case FTEXT:	/* skip system call if nothing to do; avoids */
	case FBIN:	/* overhead, and any screws if user did a _CLOSF */
	case FPIPE:
		nbytes = FILBUFSIZ * (36 / p->bsize);
		bp = consbp (p->bsize, p->buf);
		nc = nbytes - p->bcnt;
		if (nc != 0) {
			if (p->ftype == FPIPE)
				wrpipe (p->jfn, bp, nc);
			else	nc += _SOUT (p->jfn, bp, -nc, 0);
		}
		p->bcnt = nbytes;
		p->bptr = bp;
		return (nc);
	}
}

/**********************************************************************

	PRINTF, FPRINTF, SPRINTF - formatted printing routines

	These all use a set of basic formatted printing routines
	contained in the file CPRINT.C

**********************************************************************/

# rename _print "PRINT"

printf (a, b, c, d, e, f, g, h, i, j, k, l, m, n)
{
	_print (stdout, a, b, c, d, e, f, g, h, i, j, k, l, m, n);
}

fprintf	(a, b, c, d, e,	f, g, h, i, j, k, l, m, n, o)
{
	_print (a, b, c, d, e, f, g, h, i, j, k, l, m, n, o);
}

sprintf	(s, a, b, c, d,	e, f, g, h, i, j, k, l, m, n)
char *s;
{
	register FILE *fp;
	fp = fopen (s, "ws");
	 _print (fp, a, b, c, d, e, f, g, h, i, j, k, l, m, n);
	fclose (fp);
}

/**********************************************************************

	SCANF, FSCANF, SSCANF - formatted text input routines

	These all use the basic text input routines in SCANF.C

**********************************************************************/

# rename _scanf "SCANF"

scanf (fmt, a, b, c, d, e, f, g, h, i, j, k, l, m)
char *fmt;
{
	return (_scanf (stdin, fmt, a, b, c, d, e, f, g, h, i, j, k, l, m));
}

fscanf (fp, fmt, a, b, c, d, e, f, g, h, i, j, k, l, m)
FILE *fp; 
char *fmt;
{
	return (_scanf (fp, fmt, a, b, c, d, e, f, g, h, i, j, k, l, m));
}

sscanf (s, fmt, a, b, c, d, e, f, g, h, i, j, k, l, m)
char *s, *fmt;
{
	int result;
	FILE *fp;

	fp = fopen (s, "rs");
	result = _scanf (fp, fmt, a, b, c, d, e, f, g, h, i, j, k, l, m);
	fclose (fp);
	return (result);
}



/**********************************************************************

	CHANGE_DIRECTION - switch between reading and writing
		use only if channel can both read and write!

**********************************************************************/

static change_direction (p)
register FILE *p;
{
	register int dir;

	fflush (p);
	dir = (p->direction ^= FREADING);
	if (dir & FREADING) p->bcnt = 0;	/* was writing, now reading */
	else	{				/* was reading, now writing */
		p->eof = FALSE;
		p->ftype &= ~EFLAG;
		p->bcnt = FILBUFSIZ * (36 / p->bsize);
		p->bptr = consbp (p->bsize, p->buf);
	}
}

/**********************************************************************

	FTELL - get position in file

**********************************************************************/

ftell (p)
register FILE *p;
{
	register int btype;

	btype = p->ftype & ~(UFLAG | EFLAG);	/* get basic type */
	if (btype == FTEXT || btype == FBIN) {
		register int pos, n;

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
		if ((pos = _RFPTR (p->jfn)) < 0) return (-1);
		return (pos + n);
	}
	/* TTY, string I/O, or pipe */
	return (0);
}

/**********************************************************************

	FSEEK - set position in file

**********************************************************************/

fseek (p, offset, mode)
register FILE *p;
int offset, mode;
{
	register int btype;

	btype = p->ftype & ~(UFLAG | EFLAG);	/* get basic type */
	if (btype == FTEXT || btype == FBIN) {
		register int pos;

		if (mode == 1)			/* adjust for buffering */
			{switch (p->direction) {
			case FREAD:
			case (FREAD | FWRITE | FREADING):
				/* not clear p->ucnt should be here ... */
				offset -= p->bcnt + p->ucnt;
			}
		}
		fflush (p);
		switch (mode) {
		case 2: /* relative to end */
			if (_SFPTR (p->jfn, -1) < 0) return (-1);
		case 1: /* relative to current */
			if (offset == 0) return (0);
			if ((pos = _RFPTR (p->jfn)) < 0) return (-1);
			offset += pos;
		case 0:	/* relative to start */
			break;
		}
		p->ftype &= ~EFLAG;
		p->eof = FALSE;
		return (_SFPTR (p->jfn, offset));
	}
	/* no effect on TTY, string I/O, or pipes */
	return (-1);
}

/**********************************************************************

	REWIND - reset to beginning of file

**********************************************************************/

rewind (p)
FILE *p;
{
	return (fseek (p, 0, 0));
}

/**********************************************************************

	ISTTY

**********************************************************************/

static int istty (p)
register FILE *p;
{
	unsigned vals[3];

	switch (p->ftype & ~(EFLAG | UFLAG)) {
	case FSTR:
	case FPIPE:
		return (FALSE);
	case FTTY:
		return (TRUE);
	}
	if (p->devtype == -1) {	/* this is a trick so DVCHR done only once */
		register int jfn;

		if ((jfn = p->jfn) == 0100)
			jfn = (unsigned)(_GPJFN (0400000)) >> 18;
		else if (p->jfn == 0101) 
			jfn = _GPJFN (0400000) & 0777777;
		if (jfn == 0377777)		/* .NULIO */
			p->devtype = 015;	/* .DVNUL */
		else if (jfn == 0677777)	/* .SIGIO */
			p->devtype = 012;	/* .DVTTY (assumption!) */
		else	{
			_DVCHR (p->jfn, vals);
			p->devtype = (vals[1] >> 18) & 0777;
		}
	}
	return ((p->devtype & ~01) == 012);	/* TTY or PTY */
}

/**********************************************************************

	FCLOSE - Close a file. This doesn't do enough error checking yet

**********************************************************************/

fclose (p)
register FILE *p;
{
	register int ftype;

	ftype = p->ftype & ~(EFLAG | UFLAG);
	if (ftype == FSTR) {
		int s;

		if (p->direction & FWRITE) idpb (0, &p->bptr);
		s = p->bptr & 0777777;
		channel_free (p, TRUE);
		return (s);
	}
	if (ftype == FTTY) {
		dpyreset ();
		dpyinit ();
	}
	fflush (p);
	if (ftype == FPIPE) clpipe (p->jfn);
	else	_CLOSF (p->jfn);	/* close file and release jfn */
	channel_free (p, TRUE);
	return (0);
}


/**********************************************************************

	GETS - Read a string from the standard input unit

**********************************************************************/

char *gets (p)
register char *p;
{
	register int c;
	char *s;

	s = p;
	while ((c = getc (stdin)) != '\n' && c > 0) *p++ = c;
	*p = 0;
	return (s);
}

/**********************************************************************

	FGETS - read a string from a file

**********************************************************************/

char *fgets (s,	n, f)
char *s;
FILE *f;
{
	register char *sp;
	register int c;

	sp = s;
	while (--n > 0 && (c = getc (f)) != EOF)
		if ((*sp++ = c)	== '\n') break;
	*sp = 0;
	if (c == EOF &&	sp == s) return	(NULL);
	return (s);
}

/**********************************************************************

	PUTS - Output a string to the standard output unit

**********************************************************************/

puts (s)
register char *s;
{
	register int c;

	while (c = *s++) putc (c, stdout);
	putc ('\n', stdout);
}

/**********************************************************************

	FPUTS - write a string to a file

**********************************************************************/

fputs (s, f)
register char *s;
FILE *f;
{	
	register int c;
	while (c = *s++) putc (c, f);
}

/**********************************************************************

	FREAD, FCREAD - read data from a file to a buffer
			fread uses getw, for binary files
			fcread uses getc, generally better 
			  for text files

**********************************************************************/

fread (buf, size, number, f)
int *buf;
FILE *f;
{
	register int i, j, k;
	for (i = 0; i < number; ++i) {
		j = size;
		while (--j >= 0) {
			k = getw (f);
			if (feof (f)) return (i);
			*buf++ = k;
		}
	}
	return (i);
}

fcread (buf, size, number, f)
char *buf;
FILE *f;
{
	register int i, j, k;
	for (i = 0; i < number; ++i) {
		j = size;
		while (--j >= 0) {
			k = getc (f);
			if (feof (f)) return (i);
			*buf++ = k;
		}
	}
	return (i);
}

/**********************************************************************

	FWRITE, FCWRITE - write data from a buffer to a file
			  fwrite uses putw
			  fcwrite uses putc

**********************************************************************/

fwrite (buf, size, number, f)
register int *buf, size;
FILE *f;
{	
	size *= number;
	while (--size >= 0) putw (*buf++, f);
	return (number);
}

fcwrite (buf, size, number, f)
register char *buf;
register int size;
FILE *f;
{
	size *= number;
	while (--size >= 0) putc (*buf++, f);
	return (number);
}


/**********************************************************************

	RDTTY - C buffered TTY input editing:
		implements ^@, ^I, ^J, ^L, ^M, ^R, ^U, ^V, ^W, ^Z
		display terminals handled nicely; others still edit

**********************************************************************/

# define alpha(c) ((c>='0'&&c<='9')||(c>='A'&&c<='Z')||(c>='a'&&c<='z'))
# define PRIOU 0101

static int rdtty (p)		/* returns number of chars in buffer */
register int *p;
{
	register int *q, *qq, c;
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

static ttychar (c)
register char c;
{
	if (c == '\177') {
		tyos ("^?");
		return;
	}
	if (c < ' ' && c != '\t') {
		tyo ('^');
		c += 0100;
	}
	tyo (c);
}

/****************************************************************

	CALC_HPOS - calculates position of terminal cursor after
		displaying given string via TTYCHAR

****************************************************************/

static int calc_hpos (s, e, h)
register char *s, *e;
register int h;
{
	/* s = start of string, e = end, h = initial hpos */
	register char c;
	if (e == 0) {	/* calculate e if not supplied */
		e = s;
		while (*e != 0) e++;
	}
	while (s < e) {
		c = *s++;
		if (c == '\t') {
			h = (h + 8) & ~07;  /* assumes first position is 0 */
			continue;
		}
		if (c < ' ' || c == '\177') h++;
		h++;
	}
	return (h);
}



# define COMSIZE 500	/* size of command buffer */
# define MAXARG 100	/* maximum number of command arguments */

# rename combuf "COMBUF"
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

# rename setup "SETUP"

setup ()
{
	register int n;
	tty_eof = FALSE;	/* reset global I/O stuff */
	tty_prompt = "";
	tty_ptr = tty_line;
	stdin = &sinfb;
	stdout = &soutb;
	stderr = &serrb;
	sinfn = soutfn = serrfn = NULL;
	dpysetup ();		/* reset C20TTY stuff, too */
	dpyinit ();

# ifdef TOPS20
	n = _RSCAN (0);	/* command line in rescan buffer */
	if (n > 0) {
		register int i;

		_SIN (0777777, mkbptr (combuf), n, 0);
		i = n - 1;
		while (i >= 0) {	/* remove trailing CR and NLs */
			register int c;
			c = combuf[i];
			if (c != '\r' && c != '\n') break;
			--i;
		}
		combuf[i+1] = 0;	/* terminate string */
	}
	if (n == 0 || nojcl ()) {
		/* if run from IDDT or by some EXEC command, then */
		/* no jcl, so give the user a chance ... */
		combuf[0] = '.';	/* dummy program name */
		combuf[1] = ' ';
		tty_prompt = "Command: ";
		fix_primary_io (stdin, fopen ("", "r"));
		gets (&combuf[2]);	/* get a command string */
		fclose (stdin);
		tty_eof = FALSE;	/* just in case */
		tty_prompt = 0;
	}
# endif
# ifdef TENEX
	combuf[0] = '.';			/* hack jcl */
	n = _GPJFN (0400000);			/* what is primary input ? */
	if (((unsigned)(n) >> 18) == 0777777) {	/* controlling terminal */
		extern int dbgflg;
		register char c, *p;
		if (dbgflg || _BKJFN (0100) != 0) c = ' ';
		else	c = utyi ();
		if (c == '\r' || c == '\n' || c == EOL) combuf[1] = 0;
		else	{
			combuf[1] = c;
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
	else	{
		register char *p;
		p = combuf;
		while (TRUE) {
			register char c;
			c = _BIN ((unsigned)(n) >> 18);
			if (c == '\r' || c == '\n' || c == EOL || c == 0)
				break;
			*p++ = c;
		}
		*p++ = 0;
		_SPJFN (0400000, 0777777, n & 0777777);
	}
# endif TENEX

	argc = parse (combuf, argv);	/* parse command line */
	setio ();			/* maybe redirect I/O */
}

# ifdef TOPS20
int nojcl () {	/* just to see if RUN was used, or we are in a debugger */
	
	char temp[COMSIZE];
	register char *p;
	strcpy (temp,combuf);
	p = temp;
	while (*p) {
		if (*p == ' ') {
			*p = 0; 
			break;
		}
		*p = isupper(*p) ? tolower(*p) : (*p); 
		++p;
	}
	if (!strcmp (temp, "run")) return (TRUE);
	if (!strcmp (temp, "r")) return (TRUE);
	/* match anything ending in "ddt" */
	if (p - temp >= 3 && !strcmp (p - 3, "ddt")) 
		return (TRUE);
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

int pjflag  = TRUE;	/* set to false in binary file to suppress parsing */
int riflag  = TRUE;	/* set to false in binary file to suppress redirect */
			/* of primary I/O; pjflag false also suppresses it */

static int parse (in, av)
register char *in, *av[];
{
	register int ac;
	register char *out;

	ac = 0;
	out = in;
	append = errappend = FALSE;
	sinfn = soutfn = serrfn = NULL;

	if (!pjflag) {	/* don't parse (except hack ^V, \ as usual) */
		register int c;
		av[0] = out;
		while (TRUE) {		/* get program name */
			c = *in++;
			if (c == ' ' || c == 0) break;
			*out++ = c;
		}
		*out++ = 0;
		ac++;
		while (c == ' ') c = *in++;
		av[1] = out;
		while (c) {		/* get rest of line */
			if (c == QUOTE) {
				c = *in++;
				if (c != '?' && c != '-') *out++ = QUOTE;
			}
			else if (c == ARGQUOTE) c = *in++;
			*out++ = c;
			c = *in++;
		}
		if (out != av[1]) ac++;
		return (ac);
	}
	while (TRUE) {
		int quoteflag, firstch, secondch;
		register int c;
		register char *s;

		quoteflag = FALSE;

		/* find beginning of next arg */

		c = *in++;
		while (c == ' ') c = *in++;
		if (c == 0) break;
		if (c == '"') {
			quoteflag = TRUE; 
			c = *in++;
		}
		if (c == 0) break;
		firstch = c;		/* \< should not be special */
		secondch = *in;		/* >\> should not be special */
		av[ac] = s = out;

		/* scan arg */

		while (TRUE) {
			if (c == 0) break;
			if (quoteflag) {
				if (c == '"') {
					c = *in++;
					if (c != '"') break;
				}
			}
			else if (c == ' ') break;
			if (c == QUOTE || c == ARGQUOTE) {
				if (c == QUOTE) {
					c = *in++;
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
		case '<': {	/* if there is a matching '>' then this */
				/* is not a redirection command */
			register char *p, t;
			int level;
			p = s + 1;
			level = 0;
			while (t = *p++) {
				if (t == QUOTE && *p) {
					++p; 
					continue;
				}
				if (t == '<') ++level;
				if (t == '>') {
					if (level == 0) break; /* unmatched */
					--level;
				}
			}
			if (s[1] && (t != '>')) sinfn = s+1;
			else if (++ac < MAXARG) av[ac] = out;
			}
			break;
		case '>':
			if (secondch == '>') {
				if (s[2]) {
					soutfn = s + 2;
					append = TRUE;
				}
			}
			else	{
				if (s[1]) {
					soutfn = s + 1;
					append = FALSE;
				}
			}
			break;
		case '%':
			if (secondch == '%') {
				if (s[2]) {
					serrfn = s + 2;
					errappend = TRUE;
				}
			}
			else	{
				if (s[1]) {
					serrfn = s + 1;
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

static setio ()
{
	register FILE *f;
	closall ();
	if (sinfn) {	/* input is redirected */
		fix_primary_io (stdin, f = eopen (sinfn, "r"));
		if (f == NULL) sinfn = 0;
	}
	if (!sinfn) fix_primary_io (stdin, eopen ("", "r"));
	if (soutfn) {	/* output is redirected */
		f = eopen (soutfn, append ? "a" : "w");
		fix_primary_io (stdout, f);
		if (f == NULL) {
			errout ("Can't open specified output file.");
			soutfn = 0;
		}
	}
	if (!soutfn) fix_primary_io (stdout, eopen ("", "w"));
	if (serrfn)	/* errout is redirected */
		{f = eopen (serrfn, errappend ? "a" : "w");
		fix_primary_io (stderr, f);
		if (f == NULL) {
			errout ("Can't open specified error file.");
			serrfn = 0;
		}
	}
	if (!serrfn) fix_primary_io (stderr, fopen ("", "w"));
}

/**********************************************************************

	EOPEN - Open with error message

**********************************************************************/

static FILE *eopen (name, mode)
char *name, *mode;
{
	register FILE *f;

	f = fopen (name, mode);
	if (f == NULL) {
		errout ("Unable to ");
		if (*mode != 'r') errout ("write");
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

static errout (s)
char *s;
{
	_PSOUT (mkbptr (s));
}

/**********************************************************************

	MKBPTR - Make byte pointer from string

**********************************************************************/

int mkbptr (p)
int p;
{
	return (consbp (36, p));
}

/****************************************************************

	CONSBP - Make byte pointer given byte size and buffer address

****************************************************************/

int consbp (bs, bp)
int bs, bp;
{
	return (halves (0440000 + (bs << 6), bp));
}

/**********************************************************************

	DO_OPTIONS - Process mode and options.  Set direction,
		ftype, append, and byte size flags.

**********************************************************************/

static int do_options (opt, pdirection, pftype, 
			  pappend, pnew, pthaw, pbsize)
register char *opt;
int *pdirection, *pftype, *pappend, *pnew, *pthaw, *pbsize;

	{
	register char *c,ch;
	register int x;
	char mode;

	mode = *opt++;			/* pick off first char for mode */

	if (mode < 'A' || mode > 'z') mode = 'r';
	c = opt;
	x = 0;
	if (c < (char *)0100 || c >= (char *) halves (1, 0)) opt = "";
	else	{
		while (*opt >= '0' && *opt <= '9')
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
	switch (isupper(mode) ? tolower(mode) : mode) {
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
	while (ch = *opt++) {
		switch (isupper(ch) ? tolower(ch) : ch) {
		case 'b':
			*pftype = FBIN; 
			*pbsize = 36; 
			break;
		case 's':
			*pftype = FSTR; 
			break;
		}
	}
	if (x) *pbsize = x;
}

/**********************************************************************

	CHANLIST - List of open channels.

**********************************************************************/

static FILE *chanlist;

static FILE *channel_allocate ()
{
	register FILE *p;

	p=(FILE *) malloc(sizeof(struct _file)); /* presumed zeroed */
	p->next = chanlist;
	chanlist = p;
	p->devtype = -1;		/* for istty optimization */
	return (p);
}

static channel_free (p, bfree)
register FILE *p;
{
	register FILE *q, **qq;

	qq = &chanlist;
	q = *qq;
	while (q) {
		if (q == p) {
			*qq = p->next;	/* unchain */
			if (bfree) {
				if (p->buf) pg_ret (p->buf);
				if (p->ubuf) free (p->ubuf);
			}
			if (p != stdin && p != stdout && p != stderr) 
				free (p);
			break;
		}
		qq = &q->next;
		q = *qq;
	}
}

static fix_primary_io (statptr, dynptr)
FILE *statptr, * dynptr;
{
	register FILE *q, **qq;
	if (dynptr == NULL) return;
	blt (dynptr, statptr, sizeof (*statptr));
	channel_free (dynptr, FALSE);
	statptr->next = chanlist;
	chanlist = statptr;
}

/**********************************************************************

	CLOSALL

**********************************************************************/

closall ()
{
	while (chanlist) fclose (chanlist);
}

/**********************************************************************

	CISFD - is p a pointer to a FILE block?

**********************************************************************/

int cisfd (p)
FILE *p;
{
	register FILE *q;

	q = chanlist;
	while (q) {
		if (q == p) return (TRUE);
		q = q->next;
	}
	return (FALSE);
}

/**********************************************************************

	FILE MANIPULATION ROUTINES

	rename (file1, file2)	- rename file1 to file2
	delete (file)		- delete file, do not expunge
	unlink (file)		- delete and expunge file
	fileno (p)		- return jfn of a file opened with fopen
	tmpnam ()		- return a filename usable as a temp file

**********************************************************************/

/**********************************************************************

	RENAME (file1, file2)

	Should work even if a file2 already exists.
	Return 0 if no error.

	*TOPS-20 VERSION*

**********************************************************************/

int rename (s1, s2)
char *s1, *s2;
{
	register int jfn1, jfn2, rc;
	char buf1[100], buf2[100];

	fnstd (s1, buf1);
	fnstd (s2, buf2);
	jfn1 = _GTJFN (halves (0100001, 0), mkbptr (buf1));	/* old file */
	if (jfn1 >= 0600000) return (jfn1);
	jfn2 = _GTJFN (halves (0400001, 0), mkbptr (buf2));	/* new file */
	if (jfn2 >= 0600000) return (jfn2);
	if (rc = _RNAMF (jfn1, jfn2)) {
		_RLJFN (jfn1);
		_RLJFN (jfn2);
		return (rc);
	}
	_RLJFN (jfn2);
	return (0);
}

/**********************************************************************

	DELETE

**********************************************************************/

delete (s)
char *s;
{
	register int jfn;
	char buf[100];
	fnstd (s, buf);
	jfn = _GTJFN (halves (0100001, 0), mkbptr (buf));	/* old file */
	if (jfn < 0600000) {
		_DELF (halves(0, jfn));
		_CLOSF (jfn);
	}
}

/**********************************************************************

	UNLINK - delete and expunge

**********************************************************************/

unlink (s)
char *s;
{
	register int jfn;
	char buf[100];
	fnstd (s, buf);
	jfn = _GTJFN (halves (0100001, 0), mkbptr (buf));	/* old file */
	if (jfn < 0600000) {
		_DELF (halves(0200000, jfn));
	}
}

/**********************************************************************

	FILENO - Return JFN of file.

**********************************************************************/

int fileno (p)
FILE *p;
{
	return (p->jfn);
}

/**********************************************************************

	TMPNAM - fills *bp with a file name usable as a temp file.
		 The name will point to the default device and 
		 directory. The length of the name is limited to 
		 < 50 characters.

**********************************************************************/

char *tmpnam(bp)
char *bp;
{
	register char *p;
	char *username();

	sprintf(bp,"%d%s",_hptim(0),username());
	for (p = bp ; (*p != '\0') && (p < bp+39) ; p++)
		if (*p == '.') *p = '_';
	strcpy (p,".tmp;t");
	return (bp);
}

/**********************************************************************

	STRING ROUTINES

**********************************************************************/
/* these routines are all in the file C20STR.MID, having been written */
/* in assembly for speed */

#ifdef STRINGROUTINES

strcpy (dest, source)
register char *dest, *source;
{
	while (*dest++ = *source++);
	*dest = 0;
}

strcmp (s1, s2)
register char *s1, *s2;
{
	register char c1, c2;
	while ((c1 = *s1++) == (c2 = *s2++) && c1);
	if (c1 < c2) return (-1);
	else if (c2 == 0) return (0);
	else return (1);
}

strcat (dest, source)
register char *dest;
register char *source;
{
	while (*dest) ++dest;
	while (*dest++ = *source++);
	*dest = 0;
}

int strlen (s)
char *s;
{
	register char *e;
	e = s;
	while (*e) ++e;
	return (e - s);
}

#endif STRINGROUTINES

/**********************************************************************

	OTHER ROUTINES

**********************************************************************/

int getuid ()
{	
	int un;
	register int *x;
	x = &un;
	_GJI (-1, halves (0777777,((int)x)), 2);
		/* GETJI - read	user number */
	return (un);
	}


char *getpw (un, buf)
	char *buf;
{
	_DIRST (mkbptr (buf), un);
	return (buf);
}

/**********************************************************************

	USERNAME - return ptr to a buffer containing username

**********************************************************************/

char *username ()
{
	static char buffer[40];
	register int *p;
	int un;

	p = &un;
	p = (int *)((int) p | halves(0777777,0));
	_GJI (-1, p, 2);	/* GETJI - read user number */
	_DIRST (mkbptr (buffer), un);
	return (buffer);
}

/**********************************************************************

	VALRET - return "command string" to superior

**********************************************************************/

# ifdef TOPS20
valret (s) char *s;
{
	_RSCAN (mkbptr (s));	/* put string in RSCAN buffer */
	_RSCAN (0);		/* attach RSCAN buffer to terminal input */
	_HALTF ();		/* return control to superior */
}
# endif TOPS20

/**********************************************************************
	
	SLEEP - go to sleep for n seconds

**********************************************************************/

sleep (nsec)
{
	_DSMS (nsec * 1000);
}
