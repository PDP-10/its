# include "c.defs"

/* program to dump and compare binary files */

# define decimal 0
# define octal 1
# define compare 2
# define compare_ascii 3
# define byte 4

extern int cout;
int sflag;

main ()

	{int i, i2, j, fin, fin2, mode, s_handler();
	char buf[100], *p;

	on (ctrls_interrupt, s_handler);

	while (TRUE)
		{cprint ("\nI ");
		gets (buf);

		if (!buf[0]) return;
		if (buf[1] != ' ')
			{cprint ("Bad command.\n");
			continue;
			}
		switch (lower (buf[0])) {
	case 'd':	mode = decimal; break;
	case 'o':	mode = octal; break;
	case 'c':	mode = compare; break;
	case 'a':	mode = compare_ascii; break;
	case 'b':	mode = byte; break;
	default:	cprint ("Bad command.\n");
			continue;
			}

		if (mode == compare || mode == compare_ascii)
			{p = buf+2;
			while (i = *p)
				if (i==' ') {*p++ = '\0';break;} else ++p;
			}
		fin = copen (buf+2, 'r', "b");
		if (fin == -1)
			{cprint ("Unable to open '%s'.\n", buf+2);
			continue;
			}
		fin2 = -1;
		if (mode == compare || mode == compare_ascii)
			{fin2 = copen (p, 'r', "b");
			if (fin2 == -1)
				{cprint ("Unable to open '%s'.\n", p);
				cclose (fin);
				continue;
				}
			}
		j=0;
		sflag = FALSE;
		i = cgeti (fin);
		while (!ceof(fin) && !sflag)
			{switch (mode) {

	case decimal:	cprint ("%d", i);
			cputc (((j&7)==7) ? '\n' : '\t', cout);
			break;

	case octal:	cprint ("%o", i);
			cputc (((j&7)==7) ? '\n' : '\t', cout);
			break;

	case byte:	if (i >= 0 && i <= 0177)
				{if (i < 040 || i == 0177)
					{cputc ('^', cout);
					i =^ 0100;
					}
				cputc (i, cout);
				}
			else cprint ("%d", i);
			cputc (((j&037)==037) ? '\n' : ' ', cout);
			break;

	case compare_ascii:
	case compare:	i2 = cgeti (fin2);
			if (ceof(fin2))
				{cprint ("File 2 ends at loc %d.\n", j);
				goto done;
				}
			if (mode==compare)
				{if (i != i2)
					cprint ("%5d: %5d %5d\n", j, i, i2);
				}
			else if (mode==compare_ascii)
				{i =>> 1;
				i2 =>> 1;
				if (i != i2)
					{cprint ("%5d: ", j);
					pascii (i);
					cprint ("\t");
					pascii (i2);
					cprint ("\n");
					}
				}
			break;
			}
		++j;
		i = cgeti (fin);
		}

done:		if (fin2 >= 0)
			{i2 = cgeti (fin2);
			if (!ceof (fin2) && !sflag)
				cprint ("File 1 ends at loc %d.\n", j);
			cclose (fin2);
			}
		cclose (fin);
		}
	}

pascii (w)

	{int i;

	cputc ('"', cout);
	for (i=28;i>=0;i=-7)
		puta ((w>>i) & 0177);
	cputc ('"', cout);
	}

puta (c)

	{if (c<040 || c==0177)
		{cputc ('^', cout);
		cputc (c ^ '@', cout);
		}
	else cputc (c, cout);
	}

s_handler ()

	{sflag = TRUE;
	}
