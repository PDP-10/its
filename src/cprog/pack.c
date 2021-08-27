# define append_file appfil
# define process_options propt
# define process_args proarg
# define open_output_file opout
# define perform_command percom

/**********************************************************************

	PACK - FILE STUFFER

	command arguments:
		-c	don't check for unfriendly characters
		-s	slow output (for pseudo-FTPing)
		l=foo	list file name (default: paklst >)
		@foo	execute foo as command file
		other	append named file

**********************************************************************/

extern int cout, cerr;
int lstout -1;
int cflag {'+'};
int sflag 0;
char *lstfn {"paklst"};
char dir[100];

/**********************************************************************

	The array FRC indicates which characters are friendly.

**********************************************************************/

int frc[0200] {
	0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 1, 0, 0, 0,
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0,
	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0};

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

cmain (argc, argv) char *argv[];

	{if (argc>1) process_options (argc-1, argv+1);
	open_list_file ();
	if (argc>1) process_args (argc-1, argv+1);
	cprint (cout, "QQQQQQQQQQ\n");
	}

/**********************************************************************

	PROCESS_OPTIONS

	Process command options.

**********************************************************************/

process_options (argc, argv)
	int argc;
	char *argv[];

	{char *s;
	int c;

	while (--argc>=0)
		{s = *argv++;
		c = s[0];
		if (c=='-' || c=='+')
			{switch (lower (s[1])) {
			case 'c':	cflag = c; break;
			case 's':	sflag = 1; break;
			default:	cprint (cerr, "Unrecognized option: %s\n", s);
				}
			argv[-1] = 0;
			}
		else if (s[1]=='=')
			{switch (lower (s[0])) {
			case 'l':	lstfn = s+2; break;
			default:	cprint (cerr, "Unrecognized option: %s\n", s);
				}
			argv[-1] = 0;
			}
		}
	}

/**********************************************************************

	OPEN_LIST_FILE

**********************************************************************/

int open_list_file ()

	{lstout = copen (lstfn, 'w');
	if (lstout == -1)
		{cprint (cerr, "unable to open list file\n");
		}
	}

/**********************************************************************

	PROCESS_ARGS

	Process non-option command arguments.

**********************************************************************/

process_args (argc, argv) char *argv[];

	{char *s;

	while (--argc >= 0) if (s = *argv++)
		{if (s[0]=='@') execute_file (s+1);
		else append_file (s, s);
		}
	}

/**********************************************************************

	EXECUTE_FILE (S)

	Execute named file as command file.

**********************************************************************/

execute_file (s)	char *s;

	{int f;
	char buf[200];

	f = copen (s, 'r');
	if (f == -1)
		{lprint ("unable to open '%s'\n", s);
		return;
		}
	while (!ceof (f))
		{char *p;
		int c;
		p = buf;
		while (c = cgetc (f))
			{if (c == '\n') break;
			*p++ = c;
			}
		*p = 0;
		if (!buf[0])	
			{cclose (f);
			return;
			}	
		perform_command (buf);
		}
	}

/**********************************************************************

	PERFORM_COMMAND (S)

	Perform command S from command file.

**********************************************************************/

perform_command (s) char *s;

	{char *s1, *s2, buf[200];
	int c;

	c = s[0];
	if (c=='*' || c==0)	/* comment line */
		{lprint ("%s\n", s);
		return;
		}
	if (s[1]=='=')
		{s = s+2;
		switch (lower (c)) {
			case 'd':	stcpy (s, dir); break;
			default:	lprint ("Unrecognized Option: %s\n", s-2);
				}
		return;
		}
	s1 = s2 = s;
	while ((c = *s2++) != ' ' && c);
	if (c==0) s2 = s; else s2[-1] = 0;
	if (dir[0])
		append_file (setfdir (buf, s1, dir), s2);
	else append_file (s1, s2);
	}

/**********************************************************************

	APPEND_FILE (S1, S2)

	Append file S1 to the output file.  Use S2 as the
	name of the file in the output file.

**********************************************************************/

append_file (s1, s2)	char *s1, *s2;

	{int n, c, lastc, f, i, bad;

	lprint ("%s", s2);
	i = 25 - slen (s2);
	if (i<1) i = 1;
	while (--i>=0) lprint (" ");
	f = copen (s1, 'r');
	if (f == -1)
		lprint ("*** unable to open ***");
	else
		{cprint (cout, "QQQQQQQQQQ %s\n", s2);
		n = 0;
		bad = 0;
		lastc = -1;
		c = cgetc (f);
		while (!ceof (f))
			{lastc = c;
			++n;
			if (cflag && !frc[c]) ++bad;
			cputc (c, cout);
			if (sflag && (n&0177)==0) sleep (180);
			c = cgetc (f);
			}
		if (lastc != '\n' && n>0)
			{++n;
			cputc ('\n', cout);
			}
		cclose (f);
		lprint ("%d", n);
		if (bad>0) lprint (" *** %d bad characters", bad);
		}
	lprint ("\n");
	}

int lower (c)
	{if (c>='A' && c<='Z') return (c + ('a'-'A'));
	return (c);
	}

lprint (fmt, a, b, c)
	char *fmt;

	{if (lstout>=0) cprint (lstout, fmt, a, b, c);}
