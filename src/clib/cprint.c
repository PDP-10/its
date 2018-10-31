/*

	CPRINT - C Formatted Print Routine

	Extendable Format Version:
		Print Routines should expect the following
		arguments (n specified when defined):
			1 to n:	n data arguments
			n+1:	file descriptor
			n+2:	field width (0 if none given)

*/

# define WORDMASK 077777777777
# define SMALLEST "-34359738368"

extern int cin, cout, cerr;
int prc(), prd(), pro(), prs();

static int (*format_table[26]) () {
	/* a */ 0, 0, prc, prd, 0, 0, 0, 0,
	/* i */ 0, 0, 0, 0, 0, 0, pro, 0,
	/* q */ 0, 0, prs, 0, 0, 0, 0, 0,
	/* y */ 0, 0};

static int format_nargs [26] {
	/* a */ 0, 0, 1, 1, 0, 0, 0, 0,
	/* i */	0, 0, 0, 0, 0, 0, 1, 0,
	/* q */ 0, 0, 1, 0, 0, 0, 0, 0,
	/* y */ 0, 0};

deffmt (c, p, n)	int (*p)();

	{if (c >= 'A' && c <= 'Z') c =+ ('a' - 'A');
	if (c >= 'a' && c <= 'z')
		{if (n >= 0 && n <= 3)
			{format_table [c - 'a'] = p;
			format_nargs [c - 'a'] = n;
			}
		else cprint (cerr, "bad nargs to DEFFMT: %d\n", n);
		}
	else cprint (cerr, "bad character to DEFFMT: %c\n", c);
	}

fmtf (c, p, n) { deffmt (c, p, n); }

cprint (a1,a2,a3,a4,a5,a6,a7,a8)

	{int *adx, c, width;
	char *fmt;
	int fn, (*p)(), n;

	if (cisfd(a1))	/* file descriptor */
		{fn = a1;
		fmt = a2;
		adx = &a3;
		}
	else
		{fn = cout;
		fmt = a1;
		adx = &a2;
		}

	while (c= *fmt++)

		{if (c!='%') cputc (c,fn);
		else
			{width = 0;
			while ((c = *fmt)>='0' && c<='9')
				width = (width*10) + (*fmt++ - '0');
			c = *fmt++;
			if (c >= 'A' && c <= 'Z') c =+ ('a' - 'A');
			if (c >= 'a' && c <= 'z')
				{p = format_table [c - 'a'];
				n = format_nargs [c - 'a'];
				if (p)
					{switch (n) {
			case 0:		(*p) (fn, width); break;
			case 1:		(*p) (adx[0], fn, width); break;
			case 2:		(*p) (adx[0], adx[1], fn, width); break;
			case 3:		(*p) (adx[0], adx[1], adx[2], fn, width); break;
						}
					adx =+ n;
					continue;
					}
				cputc (c, fn);
				}
			else cputc (c, fn);
			}
		}
	}

/**********************************************************************

	PRO - Print Octal Integer

**********************************************************************/

pro (i, f, w)

	{int b[30], *p, a;

	if (!cisfd(f)) f = cout;
	if (w<0 || w>200) w = 0;
	p = b;
	while (a = ((i>>3) & WORDMASK))
		{*p++ = (i&07) + '0';
		i = a;
		}
	*p++ = i+'0';
	if (i) *p++ = '0';
	i = w - (p-b);
	while (--i>=0) cputc (' ', f);
	while (p > b) cputc (*--p, f);
	}

/**********************************************************************

	PRD - Print Decimal Integer

**********************************************************************/

prd (i, f, w)

	{int b[30], *p, a, flag;

	flag = 0;
	if (!cisfd(f)) f = cout;
	if (w<0 || w>200) w = 0;
	p = b;
	if (i < 0) {i = -i; flag = 1;}
	if (i < 0) {stcpy (SMALLEST, b); p = b+slen(b); flag = 0;}
	else
		{while (a = i/10)
			{*p++ = i%10 + '0';
			i = a;
			}
		*p++ = i+'0';
		}
	if (flag) *p++ = '-';
	i = w - (p-b);
	while (--i>=0) cputc (' ', f);
	while (p > b) cputc (*--p, f);
	}

/**********************************************************************

	PRS - Print String

**********************************************************************/

prs (s, f, w)	char *s;

	{int i;

	if (!cisfd(f)) f = cout;
	if (w<0 || w>200) w = 0;
	i = (w > 0 ? w - slen (s) : 0);
	while (--i >= 0) cputc (' ', f);
	while (i = *s++) cputc (i, f);
	}

/**********************************************************************

	PRC - Print Character

**********************************************************************/

prc (c, f, w)

	{int i;

	if (!cisfd(f)) f = cout;
	if (w<0 || w>200) w = 0;
	i = w - 1;
	while (--i >= 0) cputc (' ', f);
	cputc (c, f);
	}
