# include "c.defs"

/*

	RMOST - Read the "text" parts of a file.

*/

# define must 5
extern int cout, cerr;

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

	{int	c, a[must], i, j, snum, fd, bflag;
	char	*p, *fname;

	if (argc < 2)
		{cprint ("Usage: RMOST file ...\n");
		cprint ("Options: -b (binary, 1 character per word) -t (text)\n");
		return;
		}
	bflag = FALSE;
	snum = 0;
	while (++snum < argc)
		{fname = argv[snum];
		if (fname[0]=='-')	/* options */
			{p = &fname[1];
			while (c = *p++) switch (lower (c)) {
			case 'b':	bflag=TRUE; break;
			case 't':	bflag=FALSE; break;
				}
			continue;
			}

		fd = copen (fname, 'r', bflag ? "b" : "");
		if (fd == -1)
			{cprint (cerr, "Unable to open '%s'.\n", fname);
			continue;
			}

		cprint ("*** FILE %s ***\n\n", fname);
		c = cgetc (fd);
		while (!ceof (fd))
			{if (bad(c))
				{i = 0;
				while ((bad(c) || i<must) && !ceof (fd))
					{c = cgetc (fd);
					if (!ceof (fd))
						if (bad(c)) i=0;
						else a[i++] = c;
					}
				for (j=0;j<i;++j) cputc (a[j], cout);
				}
			else cputc (c, cout);
			if (!ceof (fd)) c = cgetc (fd);
			}
		cclose (fd);
		cputc ('\n', cout);
		}
	}

int	bad (c)

	{return (!(c=='\t' || c=='\b' || c=='\n'
		|| c>=' ' && c<0177));}

