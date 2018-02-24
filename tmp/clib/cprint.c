/*
	CPRINT - C Formatted Print Routine
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
		%z	Like %c except repeat characters width times
	If number preceeds format char (as in %4d) then number will be
	minimum field width in which the argument appears.
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

# define WORDMASK 077777777777
# define SMALLEST "-34359738368"

extern int cin, cout, cerr;
int prcf(), prdf(), prof(), prsf(), przf();

static int (*format_table[26]) () {
	/* a */ 0, 0, prcf, prdf, 0, 0, 0, 0,
	/* i */ 0, 0, 0, 0, 0, 0, prof, 0,
	/* q */ 0, 0, prsf, 0, 0, 0, 0, 0,
	/* y */ 0, przf};

static int format_nargs [26] {
	/* a */ 0, 0, 1, 1, 0, 0, 0, 0,
	/* i */	0, 0, 0, 0, 0, 0, 1, 0,
	/* q */ 0, 0, 1, 0, 0, 0, 0, 0,
	/* y */ 0, 1};

fmtf (c, p, n)
int (*p)();
{
    if (c >= 'A' && c <= 'Z')
	c =+ ('a' - 'A');
    if (c >= 'a' && c <= 'z')
    {
	if (n >= 0 && n <= 3)
	{
	    format_table [c - 'a'] = p;
	    format_nargs [c - 'a'] = n;
	}
	else
	    cprint (cerr, "bad nargs to FMTF: %d\n", n);
    }
    else
	cprint (cerr, "bad character to FMTF: %c\n", c);
}


cprint (a1,a2,a3,a4,a5,a6,a7,a8)
{
    int *adx, c, width, rjust;
    char *fmt, padc;
    int fn, (*p)(), n;

    if (cisfd(a1))	/* file descriptor */
    {
	fn = a1;
	fmt = a2;
	adx = &a3;
    }
    else
    {
	fn = cout;
	fmt = a1;
	adx = &a2;
    }

    while (c= *fmt++)
    {
	if (c!='%')
	    cputc (c,fn);
	else
	{
	    width = 0;
	    rjust = 0;		/* right justify off */
	    padc = ' ';		/* pad with a space  */
	    if (*fmt == '-')	/* then right justify */
	    {
		rjust++;
		fmt++;
	    }
	    if (*fmt == '0')	/* then change pad character */
	    {
		fmt++;
		if (*fmt >= '0' && *fmt <= '9')
		    padc = '0';
		else
		    padc = *fmt++;
	    }
	    while ((c = *fmt)>='0' && c<='9')
		width = (width*10) + (*fmt++ - '0');
	    if (rjust)
		width = -width;
	    c = *fmt++;
	    if (c >= 'A' && c <= 'Z')
		c =+ ('a' - 'A');
	    if (c >= 'a' && c <= 'z')
	    {
		p = format_table [c - 'a'];
		n = format_nargs [c - 'a'];
		if (p)
		{
		    switch (n)
		    {
			case 0:
			    (*p) (fn, width, padc);
			    break;
			case 1:
			    (*p) (adx[0], fn, width, padc);
			    break;
			case 2:
			    (*p) (adx[0], adx[1], fn, width, padc);
			    break;
			case 3:
			    (*p) (adx[0], adx[1], adx[2], fn, width, padc);
			    break;
		    }
		    adx =+ n;
		    continue;
		}
		cputc (c, fn);
	    }
	    else
		cputc (c, fn);
	}
    }
}


/*
 * put out num many characters
 */
przf (chr, f, num, padc)
int num, f;
char chr;
{
    while (--num >= 0)
	cputc (chr, f);
}

/**********************************************************************

	PROF - Print Octal Integer

**********************************************************************/

prof (i, f, w, padc)
{
    int b[30], *p, nd;

    p = b;
    do {
	*p++ = (i&07) + '0';
	i = (i >> 3) & WORDMASK;
    } while (i);
    nd = p - b;
    if (w > 0) przf (padc, f, w - nd, padc);
    while (p > b) cputc (*--p, f);
    if (w < 0) przf (padc, f, -w - nd, padc);
}

/**********************************************************************

	PRDF - Print Decimal Integer

**********************************************************************/

prdf (i, f, w, padc)
{
    int b[30], *p, flag, nd;

    flag = 0;
    p = b;
    if (i < 0) {i = -i; flag = 1;}
    if (i < 0)
    {
	stcpy (SMALLEST, b);
	p = b+slen(b);
	flag = 0;
    }
    else
    {
	do
	{
	    *p++ = i%10 + '0';
	    i =/ 10;
	} while (i);
    }
    if (flag) *p++ = '-';
    nd = p - b;
    if (w > 0) przf (padc, f, w - nd, padc);
    while (p > b) cputc (*--p, f);
    if (w < 0) przf (padc, f, -w - nd, padc);
}

/**********************************************************************

	PRSF - Print String

**********************************************************************/

prsf (s, f, w, padc)
char *s;
{
    int i, nd;

    nd = slen (s);
    if (w > 0) przf (padc, f, w - nd, padc);
    while (i = *s++) cputc (i, f);
    if (w < 0) przf (padc, f, -w - nd, padc);
}

/**********************************************************************

	PRCF - Print Character

**********************************************************************/

prcf (c, f, w, padc)
{
    if (w > 0) przf (padc, f, w - 1, padc);
    cputc (c, f);
    if (w < 0) przf (padc, f, -w - 1, padc);
}
