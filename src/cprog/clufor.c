#include "c/c.defs"
extern int cout;

int sflag, tflag, dflag, indent, fin, fout;
char fname[100], ofname[100];
filespec fs;

int s_handler ()
	{cexit (1);}

main (argc, argv)
	char *argv[];

	{on (ctrls_interrupt, s_handler);
	indent = 0;
	sflag = tflag = FALSE;
	fname[0] = 0;
	do_args (argc-1, argv+1);
	if (fname[0] == 0)
		{cprint ("No file name given.\n");
		cexit (1);
		}
	while (TRUE)
		{int this, next;
		char linebuf[400];
		if (ceof (fin)) break;
		rdline (linebuf, &this, &next);
		if (linebuf[0]==0 && ceof(fin)) break;
		if (dflag) cputc ('\n', fout);
		putline (linebuf, indent+this);
		indent = indent+next;
		if (indent < 0) indent = 0;
		}
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
		{cprint ("Usage: clufor {-s} {-t} name\n\n");
		cprint ("Input taken from name.clu or name.>\n");
		cprint ("Output written to same file name, or TTY if -t given.\n");
		cprint ("If -s given, some long comments are trimmed.\n");
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
		case 's':	sflag = TRUE; return;
		case 't':	tflag = TRUE; return;
		case 'd':	dflag = TRUE; return;
			}
	cprint ("Unrecognized option: -%s.\n", s);
	cexit (1);
	}

do_file (s)
	char *s;

	{fparse (s, &fs);
	fs.fn2 = csto6 ("CLU");
	prfile (&fs, fname);
	fin = copen (fname, 'r');
	if (fin == OPENLOSS)
		{fs.fn2 = csto6 (">");
		prfile (&fs, fname);
		fin = copen (fname, 'r');
		if (fin == OPENLOSS)
			{cprint ("Unable to open %s.\n", fname);
			cexit (1);
			}
		}
	if (tflag) fout = cout;
	else
		{fs.fn1 = csto6 ("_CLUFO");
		fs.fn2 = csto6 (">");
		prfile (&fs, ofname);
		fout = copen (ofname, 'w');
		if (fout == OPENLOSS)
			{cprint ("Unable to open output file.\n");
			cexit (1);
			}
		}
	}

struct _idnentry {char *name; int this, next;};
typedef struct _idnentry idnentry;

idnentry idntab[]
	{"proc",	0,	2,
	"iter",		0,	2,
	"if",		0,	2,
	"while",	0,	2,
	"for",		0,	2,
	"begin",	0,	2,
	"tagcase",	0,	2,
	"except",	0,	2,
	"when",		-1,	0,
	"tag",		-1,	0,
	"others",	-1,	0,
	"else",		-1,	0,
	"elseif",	-1,	0,
	"end",		-2,	-2,
	0};

idnentry spectab[]
	{"[",		0,	2,
	"(",		0,	2,
	"{",		0,	2,
	"]",		0,	-2,
	")",		0,	-2,
	"}",		0,	-2,
	0};

rdline (linebuf, pthis, pnext)
	char *linebuf;
	int *pthis, *pnext;

	{int this, next, c, inchar, instring, atbeginning, nidn;
	char *p, *idn, *incomment;

	this = -1000;
	next = 0;
	atbeginning = TRUE;
	p = linebuf;
	while (c = cgetc (fin))
		{if (c == '\n') break;
		if (atbeginning)
			{if (c==' ' || c=='\t') continue;
			atbeginning = FALSE;
			}
		*p++ = c;
		}
	*p++ = 0;
	idn = 0;
	instring = FALSE;
	incomment = 0;
	inchar = FALSE;
	nidn = 0;
	p = linebuf;
	for (;;++p)
		{c = *p;
		if (incomment && c) continue;
		if (inchar)
			{if (c=='\'') inchar = FALSE;
			else if (c=='\\')
				{c = *++p;
				if (c >= '0' && c <= '7')
					p =+ 2;
				}
			if (c) continue;
			}
		if (instring)
			{if (c=='"') instring = FALSE;
			else if (c=='\\')
				{c = *++p;
				if (c >= '0' && c <= '7')
					p =+ 2;
				}
			if (c) continue;
			}
		if (alpha (c))
			{if (!idn) idn = p;
			}
		else
			{if (idn)
				{int d;
				d = *p;
				*p = 0;
				doidn (idn, &this, &next, ++nidn);
				*p = d;
				idn = 0;
				}
			if (c=='"') instring=TRUE;
			else if (c=='\'') inchar=TRUE;
			else if (c=='%') incomment=p;
			else dospecial (c, &this, &next);
			}
		if (c == 0) break;
		}
	--p;
	if (sflag && incomment)
		{char *e;
		e = p;
		while (p>incomment && *p=='%') --p;
		if (p==incomment)
			{if (e > linebuf + 80) p = linebuf+80;
			else p = e;
			}
		}
	while (p>=linebuf && (*p==' ' || *p=='\t')) --p;
	*++p = 0;
	if (this == -1000) this = 0;
	*pthis = this;
	*pnext = next;
	}

doidn (p, pthis, pnext, nidn)
	char *p;
	int *pthis, *pnext;

	{idnentry *e;
	e = idntab;
	while (e->name)
		{if (stcmp (p, e->name))
			{int this, next;
			this = e->this;
			next = e->next;
			if (nidn == 1) *pthis = this;
			*pnext =+ next;
			if (dflag)
				cprint ("(%s=%d,%d)", p, this, next);
			return;
			}
		++e;
		}
	}

dospecial (c, pthis, pnext)
	char c;
	int *pthis, *pnext;

	{idnentry *e;
	e = spectab;
	while (e->name)
		{if (c == e->name[0])
			{int this, next;
			this = e->this;
			next = e->next;
			*pnext =+ next;
			if (dflag)
				cprint ("('%c'=%d)", c, next);
			return;
			}
		++e;
		}
	}

putline (linebuf, indentation)
	char *linebuf;

	{if (indentation>16) indentation = 16;
	if (indentation>0)
		{cputc ('\t', fout);
		indentation =- 2;
		}
	while (--indentation>=0) {cputc (' ', fout); cputc (' ', fout);}
	cprint (fout, "%s\n", linebuf);
	}

int alpha (c)
	{return ((c>='a' && c<='z') || (c>='A' && c<='Z') || (c=='_'));
	}
