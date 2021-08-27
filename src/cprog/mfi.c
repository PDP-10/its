# include "c.defs"

struct _data {int year; double idiv, iasv, cdiv, fasv, factor, factor2;};
# define data struct _data

extern int cin, cout, cerr;

main (argc, argv)

	{char name[20];
	data info[30];
	int n, f, pr_val ();
	double rd_val (), comp2 ();

	deffmt ('v', pr_val, 1);	/* extend cprint formats */

	f = cin;
	while (TRUE)
		{if (rd_name (f, name)) break;
		n = 0;
		while (TRUE)
			{if (rd_info (f, name, info, n)) break;
			++n;
			}
		prstat (name, info, n);
		}
	}

int rd_info (f, name, info, n)
	char name[];
	data info[];

	{int year;
	data *p, *q;

	p = &info[n];
	q = p-1;

	year = rd_year (f);
	if (year <= 0) return (TRUE);
	if (n>0 && year != q->year+1)
		{cprint (cerr, "Year %d out of sequence\n", year);
		year = q->year+1;
		}
	p->year = year;
	p->idiv = rd_val (f);
	p->iasv = rd_val (f);
	p->cdiv = rd_val (f);
	p->fasv = rd_val (f);
	if (n>0 && p->iasv != q->fasv)
		{cprint (cerr, "Year %d incorrect initial value\n", year);
		p->iasv = q->fasv;
		}
	p->factor2 = p->fasv/(p->iasv - p->idiv - p->cdiv);
	p->factor = comp2 (p->iasv, p->fasv, p->idiv, p->cdiv);
	return (FALSE);
	}

prstat (name, info, n)
	char name[];
	data info[];
	int n;

	{int i, j;
	double value, future, yield ();
	data *p;

	cprint ("\n\n%s:\n\n", name);
	value = 100.0;
	for (i=0;i<n;++i)
		{p = &info[i];
		value =* p->factor;
		future = 100.0;
		for (j=i;j<n;++j) future =* info[j].factor;
		cprint ("%d:  %v %v %v %v ", p->year,
			p->iasv, p->idiv, p->cdiv, p->fasv);
		cprint ("%v (%v) %v %v %v\n",
			(p->factor-1.)*10000.,
			(p->factor2-1.)*10000., value,
			yield (100.0, value, i+1)*10000.,
			yield (100.0, future, n-i)*10000.);
		}
	}

int rd_name (f, name)
	char *name;

	{int c;

	while (TRUE)
		{c = cgetc (f);
		if (c <= 0) return (TRUE);
		if (c != ' ' && c != '\n') break;
		}
	do
		{*name++ = c;
		c = cgetc (f);
		}
	while (c && c != '\n');
	*name = 0;
	return (FALSE);
	}

int rd_year (f)

	{int i, c;

	i = 0;
	c = skipb (f);
	while (TRUE)
		{if (c <= 0) return (-1);
		if (c < '0' || c > '9') return (i);
		i = (i * 10) + (c - '0');
		c = cgetc (f);
		}
	}

double rd_val (f)

	{int i, n, c;

	i = 0;
	n = 0;
	c = skipb (f);
	while (TRUE)
		{if (c == '.') break;
		if (c < '0' || c > '9') return (i * 100.);
		i = (i * 10) + (c - '0');
		c = cgetc (f);
		}

	while (TRUE)
		{c = cgetc (f);
		if (c < '0' || c > '9')
			{while (n < 2) {++n; i =* 10;}
			return (i);
			}
		if (n < 2) {++n; i = (i * 10) + (c - '0');}
		}
	}

int skipb (f)

	{int c;

	while ((c = cgetc (f)) == ' ');
	return (c);
	}

pr_val (d)
	double d;

	{int dollars, cents, sign;

	sign = 1;
	if (d < 0) {sign = -1; d = -d;}
	dollars = sign * dtruncate (d / 100.);
	cents = dround (d) % 100;
	cprint ("%4d.", dollars);
	if (cents < 10) cprint ("0%d", cents);
		else cprint ("%2d", cents);
	}

double yield (initial, final, n)
	double initial, final;

	{double exp (), log ();
	return (exp (log (final/initial) / n) - 1.0);
	}

double comp2 (initial, final, idiv, cdiv)
	double initial, final, idiv, cdiv;

	{double x, j, a, b, c, sqrt ();

	j = idiv/2.0;
	x = initial-cdiv-j;
	a = x*x;
	b = -j*j-2.0*x*final;
	c = final*final;
	return ((-b+sqrt(b*b-4.0*a*c))/(2.0*a));
	}

