#

/*
 *
 * FPRINT - Floating-Point Print Routine
 *
 * requires:
 *
 * i = dtruncate (d)
 * i = dround (d)
 * d = dabs (d)
 * cputc (c, fd)
 *
 * internal routines and tables:
 *
 * fp3, fp4, fp5, fp6, ft0, ft1, ft10
 *
 */

static double ft0[] {1e1, 1e2, 1e4, 1e8, 1e16, 1e32};
static double ft1[] {1e-1, 1e-2, 1e-4, 1e-8, 1e-16, 1e-32};
static double ft10[] {1e0, 1e1, 1e2, 1e3, 1e4, 1e5, 1e6, 1e7};
double dabs ();

fprint (d, fd)
	double d;

	{if (d<0) {cputc ('-', fd); d = dabs (d);}
	if (d>0)
		{if (d < 1.0) {fp4 (d, 0, fd); return;}
		else if (d >= 1e8) {fp4 (d, 1, fd); return;}
		}
	fp3 (d, fd);
	}

fp3 (d, fd)	/* print positive double */
	double d;

	{int i, n;
	double fraction;

	i = dtruncate (d);
	fraction = d - i;
	n = fp5 (i, fd);	/* return # of digits printed */
	cputc ('.', fd);
	n = 8 - n;
	fraction =* ft10[n];
	i = dround (fraction);
	fp6 (i, n, fd);		/* prints n digits */
	}

fp4 (d, flag, fd)
	double d;

	{int c, e;

	c = 6;
	e = 0;
	while (--c >= 0)
		{e =<< 1;
		if (flag ? d >= ft0[c] : d <= ft1[c])
			{++e;
			d =* (flag ? ft1[c] : ft0[c]);
			}
		}
	if (d < 1.0) {++e; d =* 10.0;}
	fp3 (d, fd);
	cputc ('e', fd);
	cputc (flag ? '+' : '-', fd);
	fp5 (e, fd);
	}

int fp5 (i, fd)	/* print decimal integer, return # of digits printed */

	{int a;

	if (a = i/10) a = fp5 (a, fd);
	else a = 0;
	cputc (i%10 + '0', fd);
	return (a+1);
	}

int fp6 (i, n, fd)	/* print decimal integer given # of digits */

	{if (n>0)
		{if (n>1) fp6 (i/10, n-1, fd);
		cputc (i%10 + '0', fd);
		}
	}
