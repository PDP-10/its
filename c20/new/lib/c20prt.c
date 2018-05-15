# include <stdio.h>

/*
	PRINT - C Formatted Print Routine
	Extendable Format Version:
		Print Routines should expect the following
		arguments (n specified when defined):
			1 to n:	n data arguments
			n+1:	file descriptor
			n+2:	field width (0 if none given)
			n+3:	pad character

	Format options:  (upper case treated identically)
		%s	string
		%c	character
		%o	octal
		%d	decimal
		%u	unsigned (= decimal)
		%x	hexadecimal
		%f	F format floating point (without exponent, if poss)
		%e	E format floating point (always with exponent)
		%z	Like %c except repeat characters width times
	If number preceeds format char (as in %4d) then number will be
	minimum field width in which the argument appears.  If the
	number is followed by a '.' and another number, that number is
	the precision (max # chars from a string, # digits to right of
	decimal point in floating point numbers).
	A positive field width will right justify the arg.
	A negative field width will left justify.

	If a 0 immediately follows the %, then the pad character is
	changed to 0 (instead of space).  If the next character after the
	0 is not a digit, then the pad character is changed to that character.
	For example:
		%09d   --  zero pad, width nine.  -- 000000312
		%0*9d  --  pad with *, width nine -- ******312
		%-0*9d --  left justified         -- 312******
	Note that the 0 does NOT mean that the following number is octal.
*/

# rename _print "PRINT"

# define SMALLEST "-34359738368"
# define FALSE 0
# define TRUE  1

static int prcf(), prdf(), pref(), prff(), prof(), prsf(), prxf(), przf();

# define format_table fmttab
# define format_nargs fmtcnt

static int (*format_table[26]) () = {
	0, 0, prcf, prdf, pref, prff, 0, 0,
	0, 0, 0, 0, 0, 0, prof, 0,
	0, 0, prsf, 0, prdf, 0, 0, prxf,
	0, przf};

static int format_nargs [26] = {
	0, 0, 1, 1, 1, 1, 0, 0,
	0, 0, 0, 0, 0, 0, 1, 0,
	0, 0, 1, 0, 1, 0, 0, 1,
	0, 1};

static fmtf (c, p, n)
	int (*p)();
	{if (c >= 'A' && c <= 'Z') c += ('a' - 'A');
	if (c >= 'a' && c <= 'z')
		{if (n >= 0 && n <= 3)
			{format_table [c - 'a'] = p;
			format_nargs [c - 'a'] = n;
			}
		else fprintf (stderr, "bad nargs to FMTF: %d\n", n);
		}
	else fprintf (stderr, "bad character to FMTF: %c\n", c);
	}

#   define adxsub(n) adx[-n]
#   define bumpadx(n) adx -= n

_print (a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15)
{
register int *adx, c, width, prec, n;
register char *fmt;
int rjust, fn, (*p)();
char padc;

if (cisfd(a1))	/* file descriptor */
	{fn = a1;
	fmt = a2;
	adx = &a3;
	}
else	{fn = stdout;
	fmt = a1;
	adx = &a2;
	}
while (c = *fmt++)
	{if (c != '%') putc (c, fn);
	else	{width = 0;
		prec = -1;		/* precision not given */
		rjust = FALSE;		/* right justify off */
		padc = ' ';		/* pad with a space  */
		if (*fmt == '-')	/* then right justify */
			{rjust = TRUE;
			fmt++;
			}
		if (*fmt == '0')	/* then change pad character */
			{fmt++;
			if (*fmt >= '0' && *fmt <= '9') padc = '0';
			else padc = *fmt++;
			}
		while ((c = *fmt) >= '0' && c <= '9')
			width = (width * 10) + (*fmt++ - '0');
	    	if (rjust) width = -width;
		c = *fmt++;
		if (c == '.')
			{prec = 0;
			while ((c = *fmt++) >= '0' && c <= '9')
				prec = (prec * 10) + (c - '0');
			}
		c = lower (c);
		if (c == 'l' || c == 'h')  /* accept LONG and SHORT prefixes */
			{char nc;
			nc = lower (*fmt);
			if (nc == 'd' || nc == 'o' || nc == 'x' ||
			    nc == 'u' || nc == 'e' || nc == 'f')
				{c = nc;
				fmt++;
				}
			}
		if (c >= 'a' && c <= 'z') {
			p = format_table [c - 'a'];
			n = format_nargs [c - 'a'];
			if (p)
				{
				switch (n) {
			case 0:	(*p) (fn, width, prec, padc);
				break;
			case 1:	(*p) (adxsub(0), fn, width, prec, padc);
				break;
			case 2:	(*p) (adxsub(0), adxsub(1),
				      fn, width, prec, padc);
				break;
			case 3:	(*p) (adxsub(0), adxsub(1), adxsub(2),
				      fn, width, prec, padc);
				break;
					}
				bumpadx (n);
				continue;
				}
			putc (c, fn);
			}
		else	putc (c, fn);
		}
	}
}

/**********************************************************************

	PRZF - Print Character N Times

**********************************************************************/

static przf (chr, f, num, prec, padc)
	register int num;
	int f;
	char chr, padc;

	{while (--num >= 0) putc (chr, f);
	}

/**********************************************************************

	PROF - Print Octal Integer

**********************************************************************/

static prof (i, f, w, prec, padc)
	register unsigned i;
	int f, w;
	char padc;

	{char b[30];
	register char *p;
	register int nd;

	p = b;
	do	{*p++ = (i & 07) + '0';
		i >>= 3;
		} while (i);
	nd = p - b;
	if (w > 0) przf (padc, f, w - nd, prec, padc);
	while (p > b) putc (*--p, f);
	if (w < 0) przf (padc, f, (-w) - nd, prec, padc);
	}

/**********************************************************************

	PRDF - Print Decimal Integer

**********************************************************************/

static prdf (i, f, w, prec, padc)
	register int i;
	int f, w;
	char padc;

	{char b[30];
	register char *p;
	register int flag, nd;

	flag = 0;
	p = b;
	if (i < 0) {i = -i; flag = 1;}
	if (i < 0)
		{strcpy (b,SMALLEST);
		p = b + strlen (b);
		flag = 0;
		}
	else	{do	{*p++ = i % 10 + '0';
			i /= 10;
			} while (i);
		}
	if (flag) *p++ = '-';
	nd = p - b;
	if (w > 0) przf (padc, f, w - nd, 0, padc);
	while (p > b) putc (*--p, f);
	if (w < 0) przf (padc, f, (-w) - nd, 0, padc);
	}

/**********************************************************************

	PRSF - Print String

**********************************************************************/

static prsf (s, f, w, prec, padc)
	int f, w, prec;
	register char *s;
	char padc;

	{register int i, nd;
	nd = strlen (s);
	if (prec >= 0 && nd > prec) nd = prec;
	prec = (w >= 0 ? w : -w) - nd;
	if (prec <= 0) w = 0;
	if (w > 0) przf (padc, f, prec, 0, padc);
	while (--nd >= 0) putc (*s++, f);
	if (w < 0) przf (padc, f, prec, 0, padc);
	}

/**********************************************************************

	PRCF - Print Character

**********************************************************************/

static prcf (c, f, w, prec, padc)
	int f, w;
	char c, padc;

	{if (w > 0) przf (padc, f, w - 1, prec, padc);
	putc (c, f);
	if (w < 0) przf (padc, f, (-w) - 1, prec, padc);
	}

/**********************************************************************

	PRXF - Print Hexadecimal

**********************************************************************/

static prxf (i, f, w, prec, padc)
	register unsigned i;
	int f, w;
	char padc;

	{char b[30];
	register char *p;
	register int nd;

	p = b;
	do	{register char c;
		c = i & 017;
		if (c < 10) c += '0';
		else	c += ('A' - 10);
		*p++ = c;
		i >>= 4;
		} while (i);
	nd = p - b;
	if (w > 0) przf (padc, f, w - nd, prec, padc);
	while (p > b) putc (*--p, f);
	if (w < 0) przf (padc, f, (-w) - nd, prec, padc);
	}

/**********************************************************************

	PREF - Print Floating Point Number, E format

**********************************************************************/

# rename eprint "EPRINT"

static pref (d, f, w, prec, padc)
	double d;
	int f, w;
	char padc;

	{char b[30];
	register char *p, c;
	register int nd, chn;

	if (prec < 0) prec = 6;
	chn = fopen (b, "ws");
	nd = eprint (d, chn, prec);
	fclose (chn);
	if (w > 0) przf (padc, f, w - nd, prec, padc);
	p = b;
	while (c = *p++) putc (c, f);
	if (w < 0) przf (padc, f, (-w) - nd, prec, padc);
	}

/**********************************************************************

	PRFF - Print Floating Point Number, F format

**********************************************************************/

#rename fprint "FPRINT"

static prff (d, f, w, prec, padc)
	double d;
	int f, w;
	char padc;

	{char b[30];
	register char *p, c;
	register int nd, chn;

	if (prec < 0) prec = 6;
	chn = fopen (b, "ws");
	nd = fprint (d, chn, prec);
	fclose (chn);
	if (w > 0) przf (padc, f, w - nd, prec, padc);
	p = b;
	while (c = *p++) putc (c, f);
	if (w < 0) przf (padc, f, (-w) - nd, prec, padc);
	}


