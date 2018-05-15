# include "s.h"

/**********************************************************************

	STINKR

	A relocating loader.  Semi-compatible with "STINK" on
	the M.I.T. ITS machines.  Does not implement a number
	of the hairier features of STINK.  However, does implement
	multiple segments (not just two).

	Written by Alan Snyder for the implementation of C.

**********************************************************************/

int pass;			/* current pass (1 or 2) */
int npass;			/* number of passes (1 or 2) */
int debug, pflag, sflag;	/* option flags */
int nlfile;			/* number of files loaded */
name iname[MAXINIT];		/* name(s) of init routine */
int iloc[MAXINIT];		/* location(s) of init routine */
int ninit;			/* number of init routines */
char oname[FNSIZE];		/* name of output file */
char *combuf;			/* command buffer (2-pass only) */
int comfd;			/* command buffer output file */

extern int segaorg[], segsiz[], nsegs;

main (argc, argv) char *argv[];

	{int prname();
	extern int cin;
	char buffer[1000], *outv[100];
	int i;

	npass = pass = 1;
	ninit = 0;
	setprompt ("=");
	fmtf ('x', prname, 1);
	syminit ();
	jinit ();
	linit ();
	--argc;
	++argv;
	argc = options (argc, argv);
	argc = exparg (argc, argv, outv, buffer);
	argv = outv;
	if (argc == 0) docom (cin);
	else while (--argc>=0) dofile (*argv++);
	if (npass==2)
		{int oo, osz, n;
		cclose (comfd);
		oo = ORIGIN_0;
		osz = 0;
		for (n=0; n<nsegs; ++n)
			{int o;
			o = segaorg[n];
			switch (o) {
			case ONEXT:	o = oo + osz; break;
			case OPAGE:	o = oo + osz;
					o = (o + PAGE_MASK) & ~PAGE_MASK;
					}
			segaorg[n] = o;
			oo = o;
			osz = segsiz[n];
			}
		pass = 2;
		comfd = copen (combuf, 'r', "s");
		docom (comfd);
		cclose (comfd);
		}
	symulist ();
	for (i=0;i<ninit;++i)
		{symbol s;
		iloc[i] = -1;
		s = symfind (iname[i]);
		if (symdefined (s)) iloc[i] = symvalue (s);
		else error ("initialization routine %x undefined", iname[i]);
		}
	symsort ();
	if (sflag) symlist ();
	jsetup ();
	lexit ();
	jexit ();
	}

int options (argc, argv) char *argv[];

	{char **ss, **dd, *s;

	ss = dd = argv;
	while (--argc >= 0)
		{s = *ss++;
		if (s[0] == '-') opt1 (s+1);
		else if (s[0] && s[1]=='=') opt2 (s[0], s+2);
		else *dd++ = s;
		}
	return (dd - argv);
	}

opt1 (s) char *s;

	{int c;
	while (c = *s++) switch (lower (c)) {
		case 'd':	debug = TRUE; break;
		case 'p':	pflag = TRUE; break;
		case 's':	sflag = TRUE; break;
		default:	error ("unrecognized option: %c", c);
		}
	}

opt2 (c, s) char *s;

	{switch (lower (c)) {
	default: error ("unrecognized option: %c=%s", c, s);
		}
	}

dofile (s) char *s;

	{int f, c;
	char fn[FNSIZE];

	stcpy (s, fn);
	f = sopen (fn, 'r', "");
	if (f == OPENLOSS) return;
	c = cgetc (f);
	cclose (f);
	if (c<2) loadfile (fn);	/* its a REL file, we hope */
	else comfile (fn);
	}

comfile (fn) char *fn;

	{int f;
	char buf[FNSIZE];

	stcpy (fn, buf);
	f = sopen (buf, 'r', "");
	if (f == OPENLOSS) return;
	docom (f);
	cclose (f);
	}

docom (f) int f;

	{while (TRUE)
		{char buf[500], *s;
		int command, c;
		s = buf;
		while ((c = cgetc (f)) && c != '\n') *s++ = c;
		*s = 0;
		if (buf[0] == 0 && ceof (f)) break;
		command = lower (buf[0]);
		if (command == 0 || command == ';') continue;
		if (buf[1] != 0 && buf[1] != ' ')
			{error ("bad command: %s", buf);
			continue;
			}
		switch (command) {
			case 's':	defseg (buf+2); continue;
			case 'l':	loadfile (buf+2);
					continue;
			case 'x':	comfile (buf+2); continue;
			case 'i':	definit (buf+1); continue;
			case 'o':	stcpy (buf+2, oname); continue;
			case 'q':	return;
			case '?':	prhelp (); continue;
			default:	error ("bad command: %s", buf);
			}
		}
	}

definit (s) char *s;

	{if (ninit>=MAXINIT)
		{error ("too many initialization routines specified");
		return;
		}
	iname[ninit] = rdname (s);
	++ninit;
	}

prhelp ()

  {puts ("Commands:");
  puts ("  s <o>,<o>,<o>,...    - define segments");
  puts ("            <o> = octal origin, 'n' (next word), or 'p' (next page)");
  puts ("  l <file>             - load file");
  puts ("  x <file>             - execute command file");
  puts ("  i <name>             - specify name of initialization routine");
  puts ("  o <file>             - specify name of output file");
  puts ("  q                    - quit (writes output file)");
  puts ("");
  puts ("Options:");
  puts ("  -s         - print symbol table");
  puts ("  -p         - print tabular representation of object files");
  puts ("  -d         - print debugging information");
  }

defseg (s) char *s;

	{if (nlfile>0) error ("too late to define segments");
	else
		{int need2;
		char *e;

		need2 = FALSE;
		npass = 1;
		nsegs = 0;
		e = s;
		while (nsegs<MAXSEGS)
			{int c, o;
			s = e;
			while (c = *e++)
				if (c==',')
					{e[-1] = 0;
					break;
					}
			if (c == 0 && s[0] == 0) break;
			if (s[1] == 0) switch (lower (s[0])) {
				case 'n':	o = ONEXT; ++need2; break;
				case 'p':	o = OPAGE; ++need2; break;
				default:	o = otoi (s); break;
				}
			else o = otoi (s);
			segaorg[nsegs++] = o;
			if (c == 0) break;
			}
		if (need2) npass = 2;
		}
	}

/**********************************************************************

	SQUOZE code hacking

**********************************************************************/

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
		if (i>=40)
			{error ("bad char %c in name %s", c, s);
			break;
			}
		}
	return (w);
	}

prname (n, fn, w, c) name n;

	{n =& NAMMASK;
	if (n) p40 (n, fn);
	}

p40 (i, fn)
	{int a;
	if (a = i/40) p40 (a, fn);
	i =% 40;
	cputc (tab40[i], fn);
	}

fatal (fmt, a1, a2, a3, a4, a5)
	{error (fmt, a1, a2, a3, a4, a5);
	cexit (1);
	}

error (fmt, a1, a2, a3, a4, a5)
	{cprint ("\n *** ");
	cprint (fmt, a1, a2, a3, a4, a5);
	cprint (" ***\n");
	}

bletch (fmt, a1, a2, a3, a4, a5)
	{cprint ("\n *** internal error: ");
	cprint (fmt, a1, a2, a3, a4, a5);
	cprint (" ***\n");
	cexit (2);
	}

unimplemented ()
	{error ("unimplemented operation");
	}

badfmt ()
	{error ("bad format");
	}

int otoi (s) char *s;

	{int w, c;
	w = 0;
	while (c = *s++)
		{if (c>='0' && c<='7') w = (w<<3) | (c-'0');
		else
			{error ("bad char %c in octal %s", c, s);
			break;
			}
		}
	return (w);
	}

int wswap (w)

	{return ((w << 18) | (w >> 18));
	}

int sopen (fnbuf, m, o) char fnbuf[], *o;
	/* fnbuf is modified to contain actual file name opened */

	{if (o==0) o = "";	/* just in case */
	while (TRUE)
		{int f;
		char temp[FNSIZE];
		fngtp (fnbuf, temp);	/* extract type field of file name */
		if (temp[0]==0 && m == 'r') /* not specified, set default */
			{if (o[0]==0) stcpy ("stinkr", temp);
			else stcpy ("stk", temp);
			fnsdf (fnbuf, fnbuf, 0, 0, 0, temp, 0, 0);
			}
		f = copen (fnbuf, m, o);
		if (f == OPENLOSS)
			{cprint ("\nUnable to open %s\n", fnbuf);
			cprint ("Use what filename instead ('*' to ignore)? ");
			gets (temp);
			if (temp[0] == '*' && temp[1] == 0) return (OPENLOSS);
			if (temp[0]) stcpy (temp, fnbuf);
			}
		else return (f);
		}
	}
