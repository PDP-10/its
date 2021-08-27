#include "c/c.defs"

main (argc, argv)
	char *argv[];

	{int ch, fd, fl, n, c;
	char *s;

	if (argc<2 || argc>3)
		{puts ("Usage: rlast file.name {number-of-words}");
		return;
		}

	s = argv[1];
	n = 400;
	if (argc>2) n = atoi (argv[2]);
	fd = copen (s, 'r');
	if (fd == OPENLOSS)
		{puts ("unable to open file");
		return;
		}
	ch = itschan (fd);
	fl = fillen (ch) - n;
	c = '\n';
	if (fl > 0)
		{access (ch, fl);
		while (c = cgetc (fd)) if (c == '\n') break;
		}
	if (c) while (c = cgetc (fd)) putchar (c);
	cclose (fd);
	}

int atoi (s) char s[];

	{int i, sign, c;
	
	if (!s) return (0);
	i = 0;
	sign = 1;
	while (*s == '-') {++s; sign = -sign;}
	while ((c = *s++)>='0' && c<='9') i = i*10 + c-'0';
	if (i<0)
		{i = -i;
		if (i<0)
			if (sign>0) return (-(i+1));
			else return (i);
		}
	return (sign*i);
	}
