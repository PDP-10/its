# ifndef unix
# include "c/c.defs"
# endif

/*

	This program counts characters and lines of files.
	With the -c option, C comments and non-data spaces,
	tabs, and new-lines are not counted.

*/

# ifdef unix
# define cprint printf
# endif

int cflag 0;
long int tchars, tlines;

# ifdef unix

main (argc, argv) char **argv;

	{cmain (argc, argv);
	}

# endif

#ifndef unix

main (argc, argv) char **argv;

	{char buffer[2000], *outv[100];
	argc = exparg (argc, argv, outv, buffer);
	cmain (argc, outv);
	}

# endif

cmain (argc, argv) char *argv[];

	{char *s;
	int i;

	if (argc < 2)
		{cprint ("Usage: count {-c} file ...\n");
		cprint ("Options: -c (don't count C comments, blanks)\n");
		return;
		}

	for (i=1;i<argc;++i)
		{s = argv[i];
		if (s[0]=='-')
			{switch (s[1]) {
			case 'c': cflag=1; break;
			default: cprint ("Unrecognized option: '%s'\n", s+1);
				}
			}
		else count_file (s);
		}
	cprint ("%8D%8D  total\n", tchars, tlines);
	}

count_file (s)
	char *s;

	{register char c;
	long int lines, chars, linepos;
	int f, in_string, in_char;

	f = copen (s, 'r');
	if (f == -1)
		{cprint ("\tcan't open '%s'\n", s);
		return;
		}

	lines = 0;
	chars = 0;
	linepos = 0;
	in_string = 0;
	in_char = 0;

	if (cflag)
		while (1)
			{c = cgetc (f);
			again:
			if (c<=0 && ceof (f)) break;
			if (c=='\n')
				{if (chars > linepos) lines=lines+1;
				linepos = chars;
				}
			if (!in_string && !in_char)
				{if (c=='/')
					{if ((c = cgetc (f)) == '*')
						{skp_comment (f);
						continue;
						}
					chars=chars+1;
					goto again;
					}
				if (c=='\n' || c=='\t' || c==' ')
					continue;
				}
			if (c=='"' && !in_char) in_string = !in_string;
			if (c=='\'' && !in_string) in_char = !in_char;
			if (c=='\\')
				{c = cgetc (f);
				chars = chars+2;
				continue;
				}
			chars=chars+1;
			}				
	else
		while (1)
			{c = cgetc (f);
			if (c<=0 && ceof (f)) break;
			chars=chars+1;
			if (c == '\n') lines=lines+1;
			}
	cclose (f);
	cprint ("%8D%8D  %s\n", chars, lines, s);
	tlines =+ lines;
	tchars =+ chars;
	}

skp_comment (f)

	{int c;

	while (c = cgetc (f))
		{while (c == '*')
			{c = cgetc (f);
			if (c == '/') return;
			}
		}
	}

