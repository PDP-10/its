#include "c/c.defs"
int fin, fout;
extern int cout;

/* Random Access Line Printer */

/* Process a text file containing the following control
   characters and escape sequences:

	FF - begin new page
	NL - begin new line
	TAB - go to next tab stop
	BS - move left 1 character position
	SP - move right 1 character position
	ESC u - move up 1 line
	ESC d - move down 1 line
	ESC p - move to beginning of previous line
	ESC ESC - output ESC character

   All motion is limited to being within one output page.

   Produce output containing only FF, NL, BS, and SP
   used as formatting control characters.

*/

#define ESC 033
#define MAXLINES 120
#define MAXCOLS 140
#define MAXCHARS 400

int tflag;
char fname[100], ofname[100];
filespec fs;

int s_handler ()
	{cexit (1);}

main (argc, argv)
	char *argv[];

	{on (ctrls_interrupt, s_handler);
	tflag = FALSE;
	fname[0] = 0;
	do_args (argc-1, argv+1);
	if (fname[0] == 0)
		{cprint ("No file name given.\n");
		cexit (1);
		}
	doit ();
	cclose (fin);
	if (!tflag)
		{fparse (fname, &fs);
		renmwo (itschan (fout), &fs);
		}
	cclose (fout);
	}

do_args (argc, argv)
	char *argv[];

	{if (argc == 0)
		{cprint ("Usage: ralp {-t} name\n\n");
		cprint ("Input taken from name.lpt\n");
		cprint ("Output written to same file, or TTY if -t given.\n");
		cexit (0);
		}
	while (--argc >= 0)
		{char *s;
		s = *argv++;
		if (s[0] == '-') do_option (s+1);
		else if (fname[0])
			{cprint ("Too many file names.\n");
			cexit (1);
			}
		else do_file (s);
		}
	}

do_option (s)
	char *s;

	{int c;
	c = s[0];
	if (s[1] == 0) switch (lower (c)) {
		case 't':	tflag = TRUE; return;
			}
	cprint ("Unrecognized option: -%s.\n", s);
	cexit (1);
	}

do_file (s)
	char *s;

	{fparse (s, &fs);
	fs.fn2 = csto6 ("LPT");
	prfile (&fs, fname);
	fin = copen (fname, 'r');
	if (fin == OPENLOSS)
		{cprint ("Unable to open %s.\n", fname);
		cexit (1);
		}
	if (tflag) fout = cout;
	else
		{fs.fn1 = csto6 ("_RALP");
		fs.fn2 = csto6 (">");
		prfile (&fs, ofname);
		fout = copen (ofname, 'w');
		if (fout == OPENLOSS)
			{cprint ("Unable to open output file.\n");
			cexit (1);
			}
		}
	}




doit ()

	{register int c;
	while ((c = cgetc (fin)) > 0) switch (c) {

	case '\p':	PageOutput (); continue;
	case '\n':	PageNextline (); continue;
	case '\t':	PageHTab (); continue;
	case '\b':	PageBackspace (); continue;
	case ' ':	PageForwardspace (); continue;
	case ESC:	DoEscape (cgetc (fin)); continue;
	default:	PageCharacter (c); continue;
			}
	PageTerminate ();
	}

DoEscape (c)

	{switch (c) {

	case 'u':	PageUp (); return;
	case 'd':	PageDown (); return;
	case 'p':	PagePreviousline (); return;
	case ESC:	PageCharacter (ESC); return;
	default:	PageCharacter (ESC);
			PageCharacter (c);
			}
	}

/**********************************************************************

	PAGE

**********************************************************************/

char *lines[MAXLINES];		/* the inactive lines */
int aln {-1};			/* the active line number */
int ln {0};			/* the current line number */
int nlines {0};			/* number of lines */
int hpos {0};			/* the current horizontal position */

extern char *LineDeactivate ();

PageOutput ()
	{register int i;
	if (aln >= 0) Deactivate ();
	for (i=0;i<nlines;++i)
		{if (lines[i])
			{cprint (fout, "%s\n", lines[i]);
			cfree (lines[i]);
			lines[i] = 0;
			}
		else cputc ('\n', fout);
		}
	cputc ('\p', fout);
	ln = nlines = hpos = 0;
	}

PageTerminate () {if (nlines > 0) PageOutput ();}
PageNextline () {++ln; hpos = 0;}
PagePreviousline () {if (ln > 0) --ln; hpos = 0;}
PageUp () {if (ln > 0) --ln;}
PageDown () {++ln;}
PageBackspace () {if (hpos>0) --hpos;}
PageForwardspace () {++hpos;}
PageHTab () {hpos =+ (8 - (hpos%8));}
PageCharacter (c) {if (ln != aln) Activate (); LineCharacter (c, hpos); ++hpos;}

Deactivate () {lines[aln] = LineDeactivate(); aln = -1;}
Activate ()
	{if (aln >= 0) Deactivate ();
	LineActivate (lines[ln]);
	if (lines[ln])
		{cfree (lines[ln]);
		lines[ln] = 0;
		}
	aln = ln;
	if (aln >= nlines) nlines = aln+1;
	}

/**********************************************************************

	LINE

**********************************************************************/

int chain[MAXCOLS];
char data[MAXCHARS];
int next[MAXCHARS];
int ncol, ndata, nchar /* size needed to store */;

LineActivate (s)
	char *s;

	{int c, i;
	ncol = 0;
	nchar = 1;
	ndata = 0;
	if (s == 0) return;
	i = 0;
	while (c = *s++)
		{if (c == '\b') {if (i>0) --i;}
		else if (c == ' ') ++i;
		else {LineCharacter (c, i); ++i;}
		}
	}

LineCharacter (c, i)

	{while (i >= ncol)
		{++nchar;
		chain[ncol] = -1;
		++ncol;
		}
	if (c != ' ')
		{data[ndata] = c;
		next[ndata] = chain[i];
		if (chain[i] != -1) nchar =+ 2;
		chain[i] = ndata;
		++ndata;
		}
	}

char *LineDeactivate ()

	{register char *p;
	register int i;
	char *s;
	s = p = calloc (nchar);
	for (i=0;i<ncol;++i)
		{int n;
		n = chain[i];
		if (n == -1) *p++ = ' ';
		else while (n >= 0)
			{*p++ = data[n];
			n = next[n];
			if (n >= 0) *p++ = '\b';
			}
		}
	*p++ = 0;
	return (s);
	}
