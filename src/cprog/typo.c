# include "c/c.defs"

# define salt_file "/dsk/clu/salt.file"
# define w2006_file "/dsk/clu/w2006.list"
# define usort_prog "/dsk/cluobj/ts.usort"
# define sort_prog "/dsk/cluobj/ts.sort"
# define pr_prog "/dsk/cluobj/ts.pr"
# define WDLEN 100

# define process_args pargs
# define process_input pinput
# define process_file pfile
# define process_word pword

# define sort_word_list swlist
# define sort_output soutput

# define read_word rword
# define read_salt rsalt

extern int cin, cout, cerr;

int	fargc;		/* number of file names */
char	**fargv;	/* pointers to file names */

int	eflg;
int	neng;
int	npr;

/*	frequency tables	*/

int	freq2[730];	/* digram frequencies */
int	freq3[19684];	/* trigram frequencies */

int	logtab[256];
float	inctab[256];
char	name[2][20];	/* temp file names */

/**********************************************************************

	MAIN - control routine

**********************************************************************/

main (argc, argv)
	int argc; char *argv[];

	{char *fname;
	register int file0, file1, w2006;

	initialize ();
	process_args (argc, argv);
	if (!neng) read_salt ();
	file0 = make_temp ();
	setup_interrupts ();
	fname = fargv[0];
	while (--fargc>=0) process_input (*fargv++, file0);
	cclose (file0);		/* word list is file0 */
	sort_word_list ();	/* sorted list is file1 */
	if ((file0 = copen (name[0], 'w')) == OPENLOSS)
		err ("create tmp");
	if ((file1 = copen (name[1], 'r')) == OPENLOSS)
		err ("open tmp");
	if ((w2006 = copen (w2006_file, 'r')) == OPENLOSS)
		err ("open w2006");
	process_file (file1, w2006, file0);
	cclose (w2006);
	cclose (file1);
	cclose (file0);
	sort_output ();
	print_output (fname);
	unl ();
	}

/**********************************************************************

	INITIALIZE - initialize some tables

**********************************************************************/

initialize ()

	{register int i;
	double log(), exp(), pow();

	inctab[0] = 1;
	logtab[0] = -10;
	for (i=1; i<256; ++i)
		{inctab[i] = exp (-i/30.497);
		logtab[i] = log (30.*pow (1.0333, i+0.) - 30.) + .5;
		}
	logtab[1] = -10;
	}

/**********************************************************************

	PROCESS_ARGS - process command arguments

**********************************************************************/

process_args (argc, argv)
	int argc;
	char *argv[];

	{register char *s;

	--argc;
	++argv;
	while (argc>0 && (s = *argv)[0] == '-')
		{--argc; ++argv;
		switch (s[1]) {
		default:	cprint (cerr, "Bad option: %c\n", s[1]);
				cexit ();
		case 0:
		case 'n':	neng++; break;

		case '1':
		case 'p':	npr++; break;
				}
		}
	if (argc == 0)	/* no file name => standard input */
		{++argc;
		argv[0] = "-";
		}
	fargv = argv;
	fargc = argc;
	}	

/**********************************************************************

	READ_SALT - read table of initial frequencies

**********************************************************************/

read_salt ()

	{register int fd;

	fd = copen (salt_file, 'r', "b");
	if (fd == OPENLOSS) return;
	read (fd, freq2, 26+2);		/* skip junk */
	read (fd, freq2, 730);		/* digram */
	read (fd, freq3, 19684);	/* trigram */
	cclose (fd);
	}

/**********************************************************************

	MAKE_TEMP - allocate temporary files

**********************************************************************/

int make_temp ()

	{register int i, fd;
	char *stcpy ();

	stcpy ("_typo_.tmpa1", name[0]);
	stcpy ("_typo_.tmpa2", name[1]);
	while ((fd = copen (name[0], 'r')) != OPENLOSS)
		{cclose (fd);
		for (i=0; i<2; ++i) ++name[i][10];
		if (name[0][10] == 'z') err ("create temp file");
		}
	fd = copen (name[0], 'w');
	if (fd == OPENLOSS) err ("create temp file");
	return (fd);
	}

/**********************************************************************

	SETUP_INTERRUPTS - setup interrupt handlers

**********************************************************************/

setup_interrupts ()

	{int unl();
	on (ctrls_interrupt, unl);
	on (ctrlg_interrupt, unl);
	}

/**********************************************************************

	PROCESS_INPUT - read file, computing word list and frequencies

**********************************************************************/

process_input (fname, output)
	char *fname;

	{register int k, l, m;
	int fd, j, c;
	double junk;
	char	realwd[WDLEN], nwd[WDLEN], *wd;

	wd = realwd+1;
	realwd[0] = 0;
	if (fname[0] == '-' && fname[1] == 0) fd = cin;
	else if ((fd = copen (fname, 'r')) == OPENLOSS)
		{cprint (cerr, "cannot open input file: %s\n", fname);
		unl ();
		}
	eflg = 1;
	while ((j = wdval (wd, nwd, fd)) != 0)
		{putw (nwd, output);
		k = -1;
		l = 0;
		m = 1;
		junk = rand()/32768.;
		while (m <= j)
			{c = 27*wd[k++] + wd[l++];
			if (inctab[freq2[c]] > junk) freq2[c]++;
			c = 27*c + wd[m++];
			if (inctab[freq3[c]] > junk) freq3[c]++;
			}
		c = 27*wd[k] + wd[l];
		if (inctab[freq2[c]] > junk) freq2[c]++;
		}
	cclose (fd);
	}

/**********************************************************************

	SORT_WORD_LIST - sort list of words, remove duplicates

**********************************************************************/

sort_word_list ()

	{if (callsys (usort_prog, "-o", name[1], name[0], 0))
		err ("sort");
	}

process_file (input, w2006, output)

	{char w1[WDLEN], w2[WDLEN];

	read_word (w2006, w2);
	for (;;)
		{if (read_word (input, w1) <= 0) return;
		for (;;)
			{switch (compare_words (w1, w2)) {
			case '<':	process_word (w1, output);
					break;
			case '>':	read_word (w2006, w2);
					continue;
			case '=':	read_word (w2006, w2);
					break;
					}
			break;
			}
		}
	}

int read_word (fd, w)
	char *w;

	{register int c;
	register char *p;

	p = w;
	while ((c = cgetc (fd)) != '\n' && c > 0) *p++ = c;
	*p = 0;
	return (p - w);
	}

int compare_words (w1, w2)
	char *w1, *w2;

	{register char *s1, *s2;
	register int c;

	s1 = w1;
	s2 = w2;
	if (!s2[0]) return ('<');
	while ((c = *s1++) == *s2++) if (!c) return ('=');
	if (c > *--s2) return ('>');
	return ('<');
	}

process_word (w, fd)
	char w[];

	{int wtot, tot, c, j;
	register int k, l, m;
	char wd[WDLEN];

	j = transform_word (w, wd);
	wtot = 0;
	k = 0; l = 1; m = 2;
	while (l <= j)
		{tot = 0;
		c = wd[k++]*27 + wd[l++];
		tot =+ (logtab[freq2[c]]+logtab[freq2[wd[k]*27+wd[l]]]);
		tot =>> 1;
		c = c*27 + wd[m++];
		tot =- logtab[freq3[c] & 0377];
		if(tot > wtot) wtot = tot;
		}
	if (wtot < 0) wtot = 0;
	cprint (fd, "%2d %s\n", wtot, w);
	}

transform_word (w1, w2)
	char *w1, *w2;

	{register int c;
	register char *s1, *s2;

	s1 = w1;
	s2 = w2;
	*s2++ = 0;
	while (c = *s1++) *s2++ = (c - 'a') + 1;
	*s2 = 0;
	return (s2 - w2 - 1);
	}

/**********************************************************************

	SORT_OUTPUT - sort output word list

**********************************************************************/

sort_output ()

	{if (callsys (sort_prog, "+0nr", "+1", "-o", name[0], name[0], 0))
		err ("sort");
	}

/**********************************************************************

	PRINT_OUTPUT - print output word list

**********************************************************************/

print_output (fname)

	{register int c, fd;
	char *ffptr, ffbuf[36], *stcpy(), *s;

	if (!npr)
		{ffptr = ffbuf;
		ffptr = stcpy ("Possible typos's in ", ffptr);
		ffptr = stcpy (fname, ffptr);
		if (callsys (pr_prog, "-3", "-h", ffbuf,
			"-o", name[1], name[0], 0))
				err("pr");
		s = name[1];
		}
	else s = name[0];
	fd = copen (s, 'r');
	if (fd == OPENLOSS) err ("open temp");
	while ((c = cgetc (fd)) > 0) cputc (c, cout);
	cclose (fd);
	}

unl ()

	{register int j;

	j = 2;
	while (--j>=0) delete (name[j]);
	cexit (0);
	}


err (s)
	char s[];

	{cprint (cerr, "cannot %s\n", s);
	unl ();
	}

wdval (wd, nwd, wfile)
	char wd[], nwd[];
	int wfile;

	{static int let, wflg;
	register int j;
beg:
	j = -1;
	if (wflg == 1)
		{wflg = 0;
		goto st;
		}
	while ((let = cgetc (wfile)) != '\n')
		{
st:		switch (let) {
		case -1:
		case 0:		return (0);
		case '%':	if (j != -1) break;
				goto ret;
		case '-':	if ((let = cgetc (wfile)) == '\n')
					{while ((let = cgetc (wfile)) == '\n')
						if (let <= 0) return (0);
					goto st;
					}
				else
					{wflg = 1;
					goto ret;
					}
		case '\'':	if (eflg != 1)
					{if (j < 1) goto beg;
					else break;
					}
		case '.':	if (eflg == 1)
					{while ((let = cgetc (wfile)) != '\n')
						if (let <= 0) return (0);
					goto beg;
					}
				goto ret;
		default:	eflg = 0;
				if (let < 'A') goto ret;
				if (let <= 'Z')
					{wd[++j] = (let - 'A') + 1;
					nwd[j] = let + ('a' - 'A');
					break;
					}
				if (let < 'a' || let > 'z') goto ret;
				wd[++j] = (let - 'a') + 1;
				nwd[j] = let;
				}
		 eflg = 0;
		}
	eflg = 1;
ret:	if (j < 1) goto beg;
	nwd[++j] = '\n';
	wd[j] = 0;
	return (j);
	}

putw (s, fd)
	char *s;

	{register char *p;
	register int c;

	p = s;
	do {cputc (c = *p++, fd);} while (c != '\n');
	}

int rand()

	{static int gorp;
	gorp = (gorp + 625) & 077777;
	return (gorp);
	}

/**********************************************************************

	CALLSYS

**********************************************************************/

callsys (prog, a1, a2, a3, a4, a5, a6, a7)
	char *prog, *a1, *a2, *a3, *a4, *a5, *a6, *a7;

	{extern	int exccode;
	int	c;
	char	**ss;

	ss = &a1;
	c = 0;
	while (*ss++) ++c;

	if (execv (prog, c, &a1))
		{cprint (cerr, "Unable to execute %s\n", prog);
		return (-1);
		}
	return (exccode);
	}

double pow (n, e)
	double n, e;

	{double log(), exp();
	return (exp (e * log(n)));
	}
