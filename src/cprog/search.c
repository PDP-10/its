# include "c.defs"

char pattern[200];

main (argc, argv)
	char *argv[];

	{int i, prf();
	char *s;

	if (argc<3)
		{cprint ("usage: search  string file ...\n");
		return;
		}

	stcpy (argv[1], pattern);
	i = 2;
	while (i<argc)
		{s = argv[i++];
		if (magic (s)) mapdir (s, prf);
		else prfs (s);
		}
	}

magic (s)	/* does it contain magic pattern chars? */
	char *s;

	{int c, flag;

	flag = FALSE;
	while (c = *s++) switch (c) {
		case '?':
		case '*':	flag = TRUE; continue;
		case '/':	flag = FALSE; continue;
		case '\\':	if (*s) ++s; continue;
		}
	return (flag);
	}

prf (fs)
	filespec *fs;

	{char buf[50];

	prfile (fs, buf);
	prfs (buf);
	}

prfs (s)
	char *s;

	{char buf[500];
	int f, line, ocin;
	extern int cin;

	ocin = cin;
	cprint ("%s:\n", s);
	f = copen (s, 'r');
	if (f<0)
		{cprint ("\tcan't open\n");
		return;
		}
	cin = f;
	line = 0;
	while (TRUE)
		{gets (buf);
		if (ceof (cin)) break;
		++line;
		if (sindex (pattern, buf) >= 0)
			cprint ("%d: %s\n", line, buf);
		}
	cclose (cin);
	cin = ocin;
	}

