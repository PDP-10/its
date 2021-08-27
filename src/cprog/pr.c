# include "c/c.defs"
# define default_length 60

/*
 *   print file with headings
 *   2+head+2+text+5
 */

int	ncol	1;
char	*header;
int	col;
int	icol;
int	file, fout;
#define	BUFS	5120
char	buffer[BUFS];
char	*bufp, *ebufp;
int	line;
char	*colp[72];
int	nofile;
int	ifiles[10];
int	peekc;
int	fpage;
int	page;
int	colw;
int	nspace;
int	width	72;
int	length	default_length;
int	plength {default_length-5};
int	margin	10;
int	ntflg;
int	mflg;
int	index[72];
int	nmbflag;
int 	pg_incr;
int	tabc;
int	mode;
cal	mtime;	/* file date or current date */
char	cbuf[40];

# ifdef unix

main (argc, argv) char **argv;

	{cmain (argc, argv);
	}

# endif

#ifndef unix

main (argc, argv) char **argv;

	{char xyzbuf[2000], *xyzvec[100];
	if (argc==2 && argv[1][0]=='?' && argv[1][1]==0)
		{help ();
		return;
		}
	argc = exparg (argc, argv, xyzvec, xyzbuf);
	cmain (argc, xyzvec);
	}

# endif

cmain (argc, argv)
	char *argv[];

	{int nfdone, f;
	extern int onintr(), cout;

	fout = cout;
	on (ctrlg_interrupt, onintr);
	on (ctrls_interrupt, onintr);
	no_msgs ();
	ebufp = &buffer[BUFS];

	for (nfdone=0; argc>1; argc--)
		{argv++;
		if (**argv == '-')
			{switch (*++*argv) {
			case 'h':
				if (argc>=2) {
					header = *++argv;
					argc--;
				}
				continue;

			case 't':
				ntflg++;
				continue;

			case 'l':
				length = getn(++*argv);
				continue;

			case 'n':
				nmbflag++;
				continue;
			case 'w':
				width = getn(++*argv);
				continue;

			case 's':
				if (*++*argv) tabc = **argv;
				else tabc = '\t';
				continue;

			case 'm':
				mflg++;
				continue;

			case 'o':
				if (argc>=2) {
					f = copen (*++argv, 'w');
					argc--;
					if (f != OPENLOSS) fout = f;
					}
				continue;

			default:
				ncol = getn(*argv);
				continue;
			}
		} else if (**argv == '+') {
			fpage = getn(++*argv);
		} else {
			print(*argv, argv, argc-1);
			nfdone++;
			if (mflg) break;
			}
		}
	if (nfdone==0)
		{mflg=0;
		print(0);
		}
	onintr ();
	}

onintr() {cexit (0);}
no_msgs() {;}

print (fp, argp, argc)
	char *fp;
	char **argp;

	{register int sncol, sheader;
	int i;
	extern int cin;

	if (ntflg) margin = 0;
	else margin = 10;
	if (length <= margin) length = default_length;
	if (width <= 0) width = 72;
	if (ncol>72 || ncol>width)
		{error ("Too many columns");
		cexit(1);
		}
	if (mflg)
		{pmopen (argp, argc);
		ncol = nofile;
		fp = 0;
		}
	colw = width/ncol;
	sncol = ncol;
	sheader = header;
	plength = length-5;
	if (ntflg) plength = length;
	if (--ncol<0) ncol = 0;
	if (fp)
		{file = copen (fp, 'r');
		if (file == OPENLOSS) {cant (fp); return;}
		gt_fdate (file, &mtime);
		}
	else
		{file = cin;
		now (&mtime);
		}
	if (header == 0) header = fp;
	if (nmbflag)
		{if (mflg)
			for (i=0; i<= ncol; i++)
				{index[i] = 1;
				pg_incr = 0;
				}
		else
			for (i=0; i<= ncol; i++)
				{index[i] = i * (length - 10) + ntflg*10 + 1;
				pg_incr = ncol * (length - 10) + ntflg*15;
				}
			}
	ptime (&mtime, cbuf);
	page = 1;
	icol = 0;
	colp[ncol] = bufp = buffer;
	while (mflg ? nofile>0 : tpgetc(ncol)>0)
		{if (mflg==0)
			{colp[ncol]--;
			if (colp[ncol] < buffer)
				colp[ncol] = ebufp;
			}
		line = 0;
		if (ntflg==0)
			{pputs("\n\n");
			pputs(cbuf);
			pputs("  ");
			pputs(header);
			pputs(" Page ");
			putd(page);
			pputs("\n\n\n");
			}
		putpage();
		if (nmbflag)
			for (i=0; i<=ncol; i++)
				index[i] =+ pg_incr;
		if (ntflg==0) put_ff ();
		page++;
		}
	if (file != cin) cclose (file);
	ncol = sncol;
	header = sheader;
	}

pmopen (ap, ac)
	char **ap;

	{register char **ss, *s;
	register int n;
	int f;

	ss = ap;
	n = ac;
	while (--n >= 0)
		{s = *ss++;
		if ((f = copen (s, 'r')) == OPENLOSS)
			{cant (s);
			continue;
			}
		ifiles[nofile] = f;
		if (++nofile>=10)
			{error ("Too many args");
			cexit(1);
			}
		}
	}

cant (s)
	char *s;

	{error ("Can't open %s", s);}

putpage()

	{register int lastcol, i, c;
	int j;

	if (ncol==0)
		{while (line<plength)
			{if (nmbflag)
				{putd(index[0]++);
				putcp('\t');
				}
			while((c = tpgetc(0)) && c!='\n' && c!='\p')
				putcp(c);
			putcp('\n');
			line++;
			if (c=='\p') break;
			}
		return;
		}
	colp[0] = colp[ncol];
	if (mflg==0) for (i=1; i<=ncol; i++)
		{colp[i] = colp[i-1];
		for (j = margin; j<length; j++)
			while((c=tpgetc(i))!='\n')
				if (c=='\p')
					{while(j<length)
						{++j;
						*colp[i]++ = '\n';
						if (++bufp >= ebufp)
							bufp = buffer;
						}
					break;
					}
				else if (c==0) break;
		}
	while (line<plength)
		{lastcol = colw;
		for (i=0; i<ncol; i++)
			{if (nmbflag && col+8 < lastcol)
				{putd(index[i]++);
				putcp('\t');
				col =+ 8;
				}
			while ((c=pgetc(i)) && c!='\n' && c!='\p')
				if (col<lastcol || tabc!=0)
					put(c);
			if (c=='\p') return;
			if (c==0 && ntflg) return;
			if (tabc) put(tabc);
			else while (col<lastcol) put(' ');
			lastcol =+ colw;
			}
		if (nmbflag && col + 8 < lastcol)
			{putd(index[ncol]++);
			putcp('\t');
			col =+ 8;
			}
		while ((c = pgetc(ncol)) && c!='\n' && c!='\p') put(c);
		if (c=='\p') return;
		put('\n');
		}
	}

tpgetc (ai)

	{register int c, i;

	i = ai;
	if (mflg)
		{if (ifiles[i] == OPENLOSS) return ('\n');
		if ((c = cgetc(ifiles[i])) <= 0)
			{cclose (ifiles[i]);
			ifiles[i] = OPENLOSS;
			if (--nofile <= 0) return(0);
			return('\n');
			}
		if (c=='\p' && ncol>0) c = 0;
		return(c);
		}
	if (colp[i] == bufp)
		{c = cgetc (file);
		*colp[i]++ = (c=='\p' ? '\n' : c);
		if (++bufp >= ebufp) bufp = buffer;
		}
	else c = *colp[i]++;
	if (colp[i] >= ebufp) colp[i]=buffer;
	return (c);
	}

pgetc (i)

	{register int c;

	if (peekc)
		{c = peekc;
		peekc = 0;
		}
	else c = tpgetc(i);
	if (tabc) return(c);
	switch (c) {
	case '\t':	icol++;
			if ((icol&07) != 0) peekc = '\t';
			return (' ');
	case '\n':	icol = 0;
			break;
	case 010:
	case 033:	icol--;
			break;
		}
	if (c >= ' ') icol++;
	return (c);
	}

pputs (as)
	char *as;

	{register int c;
	register char *s;

	if ((s=as)==0) return;
	while (c = *s++) put(c);
	}

putd (an)

	{register int a, n;

	n = an;
	if (a = n/10) putd(a);
	put(n%10 + '0');
	}

put (ac)

	{register int ns, c;

	c = ac;
	if (tabc)
		{putcp(c);
		if (c=='\n') line++;
		return;
		}
	switch (c) {
	case ' ':	nspace++;
			col++;
			return;
	case '\n':	col = 0;
			nspace = 0;
			line++;
			break;
	case 010:
	case 033:	if (--col<0) col = 0;
			if (--nspace<0) nspace = 0;
		}
	while (nspace)
		{if (nspace>2 && col > (ns=((col-nspace)|07)))
			{nspace = col-ns-1;
			putcp('\t');
			}
		else
			{nspace--;
			putcp(' ');
			}
		}
	if (c >= ' ') col++;
	putcp(c);
	}

getn(ap)
	char *ap;

	{register int n, c;
	register char *p;

	p = ap;
	n = 0;
	while ((c = *p++) >= '0' && c <= '9')
		n = n*10 + c - '0';
	return(n);
	}

putcp(c)

	{if (page >= fpage) cputc (c, fout);}

gt_fdate (f, p)
	cal *p;

	{f2cal (rfdate (itschan (f)), p);}

ptime (p, s)
	cal *p;
	char *s;

	{int f;

	f = copen (s, 'w', "s");
	prcal (p, f);
	cclose (f);
	}

put_ff ()

	{ /* while (line<length) put('\n'); */
	cputc ('\p', fout);
	}

error (f, a1, a2)
	char *f;

	{extern int cerr;

	cprint (cerr, f, a1, a2);
	cputc ('\n', cerr);
	}

help ()

	{cprint ("Usage: pr {options} file ...\n");
	cprint ("Options:\n");
	cprint ("\t-h string (set header line)\n");
	cprint ("\t-t (use TTY format)\n");
	cprint ("\t-l123 (set page length)\n");
	cprint ("\t-w123 (set page width)\n");
	cprint ("\t-n (print line numbers)\n");
	cprint ("\t-sc (set tab character to c)\n");
	cprint ("\t-m (print 1 file per column)\n");
	cprint ("\t-o file (output to named file)\n");
	cprint ("\t-123 (set number of columns)\n");
	cprint ("\t+123 (number of first page to print)\n");
	}
