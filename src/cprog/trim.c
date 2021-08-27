# define default_width 70

extern int cin, cout;

main (argc, argv)
	char *argv[];

	{int c, col, n;

	if (argc>1) n = atoi (argv[1]);
	else n = default_width;
	if (n < 0) n = 0;

	col = 0;
	while (c = cgetc (cin))
		{if (++col > n && c == ' ') c = '\n';
		if (c=='\n') col = 0;
		cputc (c, cout);
		}
	}

int atoi (s) char s[];

	{int i, sign, c;
	
	if (!s) return (0);
	i = 0;
	sign = 1;
	while (*s == '-') {++s; sign = -sign;}
	while ((c = *s++)>='0' && c<='9') i = i*10 + c-'0';
	return (sign*i);
	}

