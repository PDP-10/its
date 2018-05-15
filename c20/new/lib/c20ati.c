# rename eprint "EPRINT"
# rename fprint "FPRINT"
/**********************************************************************

	ATOI - Convert String to Integer

**********************************************************************/

int atoi (s)
	register char *s;

	{register int i, f, c;
	
	if (s == 0) return (0);
	i = 0;
	f = 1;
	while (*s == '-')
		{++s;
		f = -f;
		}
	while ((c = *s++) >= '0' && c <= '9') i = i * 10 + c - '0';
	if (i < 0)
		{i = -i;	/* treat -<biggest number> specially */
		if (i < 0) return (f > 0 ? -(i + 1) : i);
		}
	return (f > 0 ? i : -i);
	}

/**********************************************************************

	ITOA - Convert Integer to String

	(Returns a pointer to the null character appended to the end.)

**********************************************************************/

char *itoa (n, s)
	register char *s;

	{register int a;
	if (n < 0)
		{*s++ = '-';
		n = -n;
		if (n < 0) n = 0;
		}
	if (a = (n / 10)) s = itoa (a, s);
	*s++ = '0' + n % 10;
	*s = 0;
	return (s);
	}

/**********************************************************************

	FTOA - Convert float to string

**********************************************************************/

int ftoa (d, s, p, f)
	double d;
	char *s, f;
	int p;

	{register int outs, cnt;
	outs = fopen (s, "ws");
	if (f == 'f' || f == 'F') cnt = fprint (d, outs, p);
	else	cnt = eprint (d, outs, p);
	fclose (outs);
	return (cnt);
	}
