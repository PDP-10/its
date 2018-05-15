# include <c.defs>

/*
	SCANF - C Formatted Input Routine

	Format options:  (upper case treated identically)
		%s	string
		%c	character
		%o	octal
		%d	decimal
		%u	unsigned (= decimal)
		%x	hexadecimal
		%f	F format floating point (without exponent, if poss)
		%e	E format floating point (always with exponent)
		%[...]	string whose chars are only in ...
		%[^...]	string whose chars are NOT in ...

	If * precedes format char (as in %*d) then that item will be
	read, but not assigned to a variable in the variable list.
*/

extern int cin;
extern char scnget ();

scanf (a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15)

# ifdef snyder_compiler
#   define bumpadx ++adx
# else
#   define bumpadx --adx
# endif

{register int *adx, n, fn;
register char *fmt, c;

n = 0;
if (cisfd (a1))	/* file descriptor */
	{fn = a1;
	fmt = a2;
	adx = &a3;
	}
else	{fn = cin;
	fmt = a1;
	adx = &a2;
	}
if ((c = scnget (fn)) < 0) return (-1);		/* check for initial eof */
ungetc (c, fn);
while (c = *fmt++)
	{register int assign, win, width;
	if (c == ' ' || c == '\t' || c == '\n') continue;
	if (c != '%')
		{register char cc;
		while (TRUE)
			{if ((cc = scnget (fn)) < 0) return (n);
			if (cc != ' ' && cc != '\t' && cc != '\n') break;
			}
		if (c == cc) continue;
		ungetc (cc, fn);
		return (n);
		}
	c = *fmt++;
	if (c == '*')
		{assign = FALSE;
		c = *fmt++;
		}
	else	assign = TRUE;
	width = 0;
	while (c >= '0' && c <= '9')
		{width = width * 10 + (c - '0');
		c = *fmt++;
		}
	if (c == 'l' || c == 'h') c = *fmt++;
	switch (c) {
	case 'c':
		win = scnc (fn, assign, *adx, width); break;
	case 'd':
		win = scnd (fn, assign, *adx, width); break;
	case 'e':
	case 'f':
		win = scnf (fn, assign, *adx, width); break;
	case 'o':
		win = scno (fn, assign, *adx, width); break;
	case 's':
		win = scns (fn, assign, *adx, width); break;
	case 'x':
		win = scnx (fn, assign, *adx, width); break;
	case '[':
		{char *p, cc;
		p = fmt;
		while ((cc = *fmt++) && cc != ']');
		win = scnb (fn, assign, *adx, width, p);
		}
		break;
	default:
		win = FALSE;
		}
	if (!win) return (n);
	if (assign)
		{n++;
		bumpadx;
		}
	}
return (n);
}

/* SCNGET - Get a character (returns -1 if eof) */

char scnget (fn)

	{char c;
	c = cgetc (fn);
	if (ceof (fn)) return (-1);
	else	return (c);
	}

/* SCNC - Parse a character */

int scnc (fn, assign, var, width)
	int fn, assign, *var, width;

	{char c;
	if ((c = scnget (fn)) < 0) return (FALSE);
	if (assign) *var = c;
	return (TRUE);
	}

/* SCND - Parse a decimal integer */

int scnd (fn, assign, var, width)
	int fn, assign, *var, width;

	{return (scnint (fn, assign, var, width, 10));
	}

/* SCNO - Parse an octal integer */

int scno (fn, assign, var, width)
	int fn, assign, *var, width;

	{return (scnint (fn, assign, var, width, 8));
	}

/* SCNX - Parse a hexadecimal number */

int scnx (fn, assign, var, width)
	int fn, assign, *var, width;

	{return (scnint (fn, assign, var, width, 16));
	}

/* SCNINT - parse an integer, base specified */

int scnint (fn, assign, var, width, base)
	int fn, assign, *var, width, base;

	{register int i;
	int neg, win;
	register char c;
	if (!skpblk (fn)) return (FALSE);
	i = 0;
	win = neg = FALSE;
	while (TRUE)
		{if ((c = scnget (fn)) < 0) return (FALSE);
		if (c == '-') neg = !neg;
		else if (c != '+') break;
		}
	while (TRUE)
		{register char cc;
		cc = c;
		if (c >= '0' && c <= '9') cc = c - '0';
		else if (c >= 'a' && c <= 'z') cc = c - 'a' + 10;
		else if (c >= 'A' && c <= 'Z') cc = c - 'A' + 10;
		else if (c == ' ' || c == '\t' || c == '\n')
			{win = TRUE;
			break;
			}
		else break;
		if (cc >= base) break;
		i = i * base + cc;
		if (--width == 0 || (c = scnget (fn)) < 0)
			{win = TRUE;
			break;
			}
		}
	if (c >= 0) ungetc (c, fn);
	if (win)
		{if (neg) i = -i;
		if (assign) *var = i;
		}
	return (win);
	}

/* SCNF - Parse a floating point number of this form: */
/*	[- | +] ddd [.] ddd [ E [- | +] ddd ] */

int scnf (fn, assign, var, width)
	int fn, assign;
	register int width;
	double *var;

	{char buf[100];
	register char c, *p;

	if (width <= 0 || width > 100) width = 100;
	p = buf;
	if (!skpblk (fn)) return (FALSE);
	c = scnget (fn);
	if (c == '-' || c == '+')
		{*p++ = c;
		if (--width == 0) goto finish;
		if ((c = scnget (fn)) < 0) return (FALSE);
		}
	while (TRUE)
		{if (c >= '0' && c <= '9') *p++ = c;
		else 	break;
		if (--width == 0 || (c = scnget (fn)) < 0) goto finish;
		}
	if (c == '.')
		{*p++ = c;
		if (--width == 0 || (c = scnget (fn)) < 0) goto finish;
		else	while (TRUE)
				{if (c >= '0' && c <= '9') *p++ = c;
				else 	break;
				if (--width == 0 || (c = scnget (fn)) < 0)
					goto finish;
				}
		}
	if (c == 'e' || c == 'E')
		{*p++ = c;
		if (--width == 0) goto finish;
		c = scnget (fn);
		if (c == '-' || c == '+')
			{*p++ = c;
			if (--width == 0) goto finish;
			c = scnget (fn);
			}
		while (TRUE)
			{if (c >= '0' && c <= '9') *p++ = c;
			else 	break;
			if (--width == 0 || (c = scnget (fn)) < 0) goto finish;
			}
		}
	if (c >= 0) ungetc (c, fn);
	if (c != ' ' && c != '\t' && c != '\n') return (FALSE);
finish:	*p++ = 0;
	if (assign) *var = atof (buf);
	return (TRUE);
	}

/* SCNS - Read a string */

int scns (fn, assign, var, width)
	int fn, assign, width;
	register char *var;

	{register char c;
	if (!skpblk (fn)) return (FALSE);
	while (TRUE)
		{if ((c = scnget (fn)) < 0 || c == ' ' || c == '\n') break;
		if (assign) *var++ = c;
		if (--width == 0) goto done;
		}
	if (c >= 0) ungetc (c, fn);
done:	if (assign) *var++ = 0;
	return (TRUE);
	}

/* SCNB - Scan a string of the bracket form */

int scnb (fn, assign, var, width, matchers)
	int fn, assign, width;
	char *var, *matchers;

	{register char c;
	int member[128], nots;
	nots = FALSE;
	if (*matchers == '^')
		{nots = TRUE;
		matchers++;
		}
	sfill (member, 128, nots);
	nots = !nots;
	while ((c = *matchers++) && c != ']') member[c] = nots;
	while (TRUE)
		{if ((c = scnget (fn)) < 0 || !member[c]) break;
		if (assign) *var++ = c;
		if (--width == 0) goto done;
		}
	if (c >= 0) ungetc (c, fn);
done:	if (assign) *var = 0;
	return (TRUE);
	}

/* SKPBLK - Skips blank things; returns TRUE if won, FALSE if EOF reached */

int skpblk (fn)

	{while (TRUE)
		{register char c;
		if ((c = scnget (fn)) < 0) return (FALSE);
		if (c != ' ' && c != '\t' && c != '\n')
			{ungetc (c, fn);
			return (TRUE);
			}
		}
	}
