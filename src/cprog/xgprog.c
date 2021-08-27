# include "c/c.defs"

/*
 *
 *	XGPROG
 *
 *	Prepare program files for printing on XGP, produces output for
 *	XGP or R.  Hacks tabs to work with variable width fonts.  Puts
 *	C or CLU reserved words in bold face.  Converts obscure control
 *	characters to ^X format.
 *
 */

# define ESC 033
# define QUOTE 021
# define OUTBUFSZ 500

extern	char *help_message, *clutab[], *ctab[];
extern int cerr;

# define SMALLFONT 0
# define NORMALFONT 1
# define BIGFONT 2

int col, fin, fout, pagelen, lineno, pageno, char_width;
int fontflag, no_headers, raw, xgp;
int outbuf[OUTBUFSZ], *eoutbuf, *coutbuf;
char *dirnm;
char **keytab 0;

# ifdef unix

main (argc, argv) char **argv;

	{cmain (argc, argv);
	}

# endif

#ifndef unix

main (argc, argv) char **argv;

	{char xyzbuf[2000], *xyzvec[100];
	argc = exparg (argc, argv, xyzvec, xyzbuf);
	cmain (argc, xyzvec);
	}

# endif

cmain (argc, argv)	int argc; char *argv[];

	{argc = do_options (argc, argv);
	if (argc <= 0) return;
	set_fonts ();
	if (outheader ()) return;
	while (--argc >= 0) dofile (*argv++);
	cclose (fout);
	}

set_fonts ()

	{if (fontflag == BIGFONT)
		{char_width = 24;
		pagelen = 36;
		}
	else if (fontflag == SMALLFONT)
		{char_width = 12;
		pagelen = 78;
		}
	else
		{char_width = 16;
		pagelen = 60;
		}
	}

dofile (fn)
	char *fn;

	{char fnbuf[40], namebuff[100];
	int c, prev_c, key, in_comment, n;
	cal cd;

	stcpy (dirnm, fnbuf);
	stcpy (fn, fnbuf+slen (dirnm));
	fin = copen (fnbuf, 'r');
	if (fin < 0)
		{eprint ("Unable to open '%s'\n", fnbuf);
		return;
		}
	col = 1;
	f2cal (rfdate (itschan (fin)), &cd);
	lineno = 0;
	pageno = 0;
	in_comment = FALSE;
	prev_c = 0;

	if (!xgp)
		{outs (".nr _page 0\n");
		if (no_headers) outs (".nr print_headers 0\n");
			else
			{outs (".sr _name ");
			outs (fn);
			outnl ();
			outs (".sr _date ");
			oflush ();
			prcal (&cd, fout);
			outs ("\n.nr print_headers 1\n");
			}
		}

	while (TRUE)

		{c = cgetc (fin);
		if (ceof (fin)) break;
		if (xgp)
			{if (lineno == 0) xgpheader (fn, &cd);
			if (col == 1) outpos (0);
			}
		n = 0;
		if (keytab && !in_comment)	/* boldface keywords */
			{while (alpha(c)) {namebuff[n++] = c; c = cgetc(fin);}
			if (n>0)
				{namebuff[n] = 0;
				key = iskey(namebuff);
				if (key)
					{if (stcmp(namebuff,"cluster"))
						need (25);
					else if (stcmp(namebuff,"proc"))
						need (15);
					if (fontflag == SMALLFONT) begunder ();
					 else outbold ();
					}
				outs (namebuff);
				if (key)
					{if (fontflag == SMALLFONT) endunder ();
					 else outnormal ();
					}
				col =+ n;
				}
			}

		switch (c) {

	case '\t':	while (c=='\t' || c==' ')
				{if (c == '\t') col = ((((col-1)>>3) + 1)<<3) + 1;
				else ++col;
				c = cgetc(fin);
				}
			if (c!='\n') outpos (col-1);
			ungetc (c, fin);
			break;

	case '\n':	if (keytab==clutab) in_comment = FALSE;
			outnl ();
			col = 1;
			if (xgp && ++lineno > pagelen)
				{outnp ();
				lineno = 0;
				}
			break;

	case '\p':	if (col==1)
				{if (xgp)
					{outnp ();
					lineno = 0;
					}
				else outs (".ne 6i\n");
				break;
				}
	case 000:
	case 001:
	case 002:
	case 003:
	case 004:
	case 005:
	case 006:
	case 007:
	case 013:
	case 016:
	case 017:
	case 020:
	case 021:
	case 022:
	case 023:
	case 024:
	case 025:
	case 026:
	case 027:
	case 030:
	case 031:
	case 032:
	case 033:
	case 034:
	case 035:
	case 036:
	case 037:	if (raw) outtext (c);
			else
				{if (c==ESC)
					{outtext ('$');
					outbs ();
					outtext ('0');
					}
				else
					{outtext ('^');
					c =^ 0100;
					outtext (c);
					}
				}
			++col;
			break;

	case '%':	outtext (c);
			++col;
			if (keytab==clutab) in_comment = TRUE;
			break;

	case '*':	if (prev_c == '/' && keytab==ctab)
				in_comment = TRUE;
			outtext (c);
			++col;
			break;

	case '/':	if (prev_c == '*' && keytab==ctab)
				in_comment = FALSE;
			outtext (c);
			++col;
			break;

	case '\b':	--col;
			outbs ();
			break;

	default:	outtext (c);
			++col;
			}
		prev_c = c;
		}
	if (col != 1) outnl ();
	cclose (fin);
	if (xgp)
		{if (lineno>0) outnp ();
		}
	else outs (".bp\n");
	}

xgpheader (fn, cd)
	char fn[];
	cal *cd;

	{int savbuf[OUTBUFSZ], count, *p, *q, factor;
	factor = 8;
	if (fontflag == SMALLFONT) factor = 10;
	p = outbuf;
	q = savbuf;
	count = 0;
	while (p < coutbuf) {*q++ = *p++; ++count;}
	coutbuf = outbuf;
	lineno = 1;
	++pageno;
	outnl ();
	outnl ();
	outnl ();
	if (fontflag == SMALLFONT)
		{outnl ();
		outnl ();
		}
	if (!no_headers)
		{outpos (0);
		begunder ();
		outs (fn);
		outpos (4*factor);
		oflush ();
		prcal (cd, fout);
		outpos (9*factor);
		oflush ();
		cprint (fout, "Page %d", pageno);
		endwunder ();
		}
	outnl ();
	outnl ();
	p = savbuf;
	coutbuf = outbuf;
	while (--count >= 0) *coutbuf++ = *p++;
	}

alpha (c)	/* is c alphanumeric */

	{if (c>='a' && c<='z') return (TRUE);
	if (c>='A' && c<='Z') return (TRUE);
	if (c>='0' && c<='9') return (TRUE);
	if (c=='_') return (TRUE);
	return (FALSE);
	}

s_lower (s)	char *s;	/* convert to lower case */
	{int c;
	while (c = *s)
		{if (c>='A' && c<='Z') *s = c + ('a'-'A');
		++s;
		}
	}

iskey (s)	char *s;

	{int i;
	char *p;

	i = 0;
	while (p = keytab[i++]) if (stcmp (s,p)) return (TRUE);
	return (FALSE);
	}

eprint (fmt, a1, a2, a3, a4, a5)
	{cprint (cerr, fmt, a1, a2, a3, a4, a5);}


do_options (argc, argv)
	char **argv;

	{char *s, **ss;
	int c, n;

	ss = argv;
	--argc; ++argv;

	if (argc<1)
		{puts (help_message);
		return (0);
		}

	fontflag = NORMALFONT;
	no_headers = FALSE;
	raw = FALSE;
	dirnm = "";
	xgp = TRUE;

	n = 0;
	while (--argc >= 0)
		{s = *argv++;
		if (s[0] == '-')	/* option */
			{++s;
			s_lower (s);
			if (stcmp(s, "c")) keytab = ctab;
			else if (stcmp(s, "clu")) keytab = clutab;
			else if (stcmp(s, "none")) keytab = 0;
			else if (stcmp(s, "b")) fontflag = BIGFONT;
			else if (stcmp(s, "s")) fontflag = SMALLFONT;
			else if (stcmp(s, "nh")) no_headers = TRUE;
			else if (stcmp(s, "raw")) raw = TRUE;
			else if (stcmp(s, "r")) xgp = FALSE;
			else eprint ("Unrecognized option: %s\n", s);
			continue;
			}
		if (s[0] && s[1]=='=')	/* = option */
			{s_lower (s);
			c = s[0];
			s =+ 2;
			switch (c) {
			case 'd':		/* set default directory */
					dirnm = s;
					break;
			default:	eprint ("Unrecognized = option: %c\n", c);
					}
			continue;
			}
		*ss++ = s;
		++n;
		}
	return (n);
	}

outheader ()

	{char *header;
	fout = copen (xgp ? "output.xgp" : "output.r", 'w');
	if (fout < 0)
		{eprint ("Unable to open output file\n");
		return (1);
		}
	header =

".dv xgp\n\
.fo 0 %s\n\
.fo 1 %s\n\
.de hd\n\
.ev header\n\
.rs\n\
.nf\n\
.nr _page \\+_page\n\
.if \\print_headers\n\
.vp 0.5i\n\
\\1\\_name%c\\_datePage \\_page\\*\n\
.en\n\
.ev\n\
'vp 1i\n\
'sp\n\
.ns\n\
.em\n\
.de ft\n\
'bp\n\
.em\n\
.st hd 0\n\
.st ft 10.5i\n\
.eo .75i\n\
.oo .75i\n\
.ll 7.25i\n\
'nf\n";		

	if (xgp) header = ";SKIP 1\n;TOPMAR 0\n;BOTMAR 0\n;LFTMAR 0\n\
;KSET %s,%s\n\p";

	if (fontflag == BIGFONT)
		cprint (fout, header, "31vg", "31vgb", 3);
	else if (fontflag == SMALLFONT)
		cprint (fout, header, "18fg", "18fg", 3);
	else cprint (fout, header, "25vg", "25vgb", 3);
	coutbuf = outbuf;
	eoutbuf = outbuf+(OUTBUFSZ-1);
	return (0);
	}

need (n)

	{if (xgp)
		{if (pagelen-lineno < n) newpage ();
		}
	else cprint (fout, ".ne %dl\n", n);
	}

newpage ()

	{cputc ('\p', fout);
	lineno = 0;
	}

begunder ()
	{if (xgp)
		{outi (0177); outi (1); outi (046);}
	else outs ("");
	}

endunder ()
	{if (xgp)
		{outi (0177); outi (1); outi (047); outi (0);}
	else outs ("");
	}

endwunder ()
	{outs ("\177\001\051\004\002");}

outbold ()
	{if (xgp)
		{outi (0177); outi (1); outi (1);}
	else outs ("1");
	}

outnormal ()
	{if (xgp)
		{outi (0177); outi (1); outi (0);}
	else outs ("*");
	}

outpos (n)
	{if (xgp)
		{int pos;
		pos = (n * char_width) + 150;
		if (fontflag == SMALLFONT) pos =+ 100;
		outi (0177);
		outi (1);
		outi (040);
		outi (pos>>7);
		outi (pos&0177);
		}
	else
		{outc ('');
		outc ('(');
		if (n>=100)
			{outc ('0' + n/100);
			n =% 100;
			outc ('0' + n/10);
			n =% 10;
			}
		else if (n>=10)
			{outc ('0' + n/10);
			n =% 10;
			}
		outc ('0' + n);
		outc (')');
		}
	}

outtext (c)
	{if (xgp)
		{if (c>015 && c<0177 || c>0 && c<010 || c==013) /* normal */
			outi (c);
		else
			{outi (0177);
			outi (c);
			}
		}
	else
		{if (c < ' ' || c=='.' || c=='\'' || c==0177 || c=='\\')
			outc (QUOTE);
		outc (c);
		}
	}

outi (c)
	{outc (0400 | c);}

outbs ()
	{outc ('\b');}

outs (s)
	char *s;

	{int c;
	while (c = *s++) outc (c);
	}

outc (c)
	{if (c == '\n') outnl ();
	else *coutbuf++ = c;
	}

outnl ()
	{oflush ();
	cputc ('\n', fout);
	}

oflush ()
	{int *p;
	p = outbuf;
	while (p < coutbuf) cputc (*p++, fout);
	coutbuf = outbuf;
	}

outnp ()
	{oflush ();
	cputc ('\p', fout);
	}

char	*help_message "Usage: XGPROG \"input file\" ...\n\
\n\
File names may be intermixed with options, which then apply\n\
for remaining files in list.  The options are:\n\
\n\
	-c	put C keywords in boldface\n\
	-clu	put CLU keywords in boldface\n\
	-none	put no words in boldface\n\
	-b	use bigger font\n\
	-s	use smaller font\n\
	-nh	no headers in listing\n\
	-raw	output control characters directly\n\
	-r	produce R output file\n\
	d=***	use *** as prefix on file names";

	/* keyword table for CLU */

char *clutab[] {
	"any",
	"array",
	"begin",
	"bool",
	"break",
	"by",		/* old */
	"cand",
	"case",		/* old */
	"char",
	"cluster",
	"cor",
	"cvt",
	"do",
	"down",
	"else",
	"elseif",
	"end",
	"except",
	"false",
	"for",
	"force",
	"has",
	"if",
	"in",
	"int",
	"is",
	"iter",
	"itertype",
	"nil",
	"null",
	"oneof",
	"oper",		/* old */
	"others",
	"out",		/* old */
	"proc",
	"proctype",
	"real",
	"record",
	"rep",
	"repeat",	/* old */
	"return",
	"returns",
	"signal",
	"signals",
	"string",
	"tag",
	"tagcase",
	"then",
	"to",
	"true",
	"type",
	"typecase",	/* old */
	"union",	/* old */
	"until",	/* old */
	"up",
	"when",
	"where",
	"while",
	"yield",
	"yields",
	0 };

	/* keyword table for C */

char *ctab[] {
	"auto",
	"break",
	"case",
	"char",
	"continue",
	"default",
	"do",
	"double",
	"else",
	"extern",
	"float",
	"for",
	"goto",
	"if",
	"int",
	"long",
	"return",
	"short",
	"sizeof",
	"static",
	"struct",
	"switch",
	"union",
	"unsigned",
	"while",
	0 };
