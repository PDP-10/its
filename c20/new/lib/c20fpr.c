# include <stdio.h>

/**********************************************************************

	d = atof (s)			parser
	nchars = fprint (d, fd, prec)	write d to fd with prec decimals
	nchars = eprint (d, fd, prec)	(same, but always xxxe+xx format)

	requires:

		putc (c, fd)

	internal routines and tables:

		exps, mants, hpmul, dextract, doround, eform, fform

	PDP10 dependent, system independent

	Note: special effort is applied to get exact conversions!

**********************************************************************/

# rename eprint "EPRINT"
# rename fprint "FPRINT"
# rename hpmul "HPMUL"
# rename dextract "DEXTRACT"
# rename doround "DOROUND"
# rename eform "EFORM"
# rename fform "FFORM"

#define TRUE  1
#define FALSE 0

unsigned hpmul ();

static unsigned exps[] =
      {	halves (0741566, 0111742),		/* -48 */
	halves (0744723, 0534333),		/* -47 */
	halves (0750444, 0231611),		/* -46 */
	halves (0753555, 0300153),		/* -45 */
	halves (0756710, 0560206),		/* -44 */
	halves (0762435, 0346123),		/* -43 */
	halves (0765544, 0637550),		/* -42 */
	halves (0770676, 0007502),		/* -41 */
	halves (0774426, 0604611),		/* -40 */
	halves (0777534, 0345754),		/* -39 */
	halves (0002663, 0437347),		/* -38 */
	halves (0006420, 0163520),		/* -37 */
	halves (0011524, 0220444),		/* -36 */
	halves (0014651, 0264555),		/* -35 */
	halves (0020411, 0660744),		/* -34 */
	halves (0023514, 0235135),		/* -33 */
	halves (0026637, 0304365),		/* -32 */
	halves (0032403, 0472631),		/* -31 */
	halves (0035504, 0411377),		/* -30 */
	halves (0040625, 0513677),		/* -29 */
	halves (0043773, 0036657),		/* -28 */
	halves (0047474, 0723215),		/* -27 */
	halves (0052614, 0110061),		/* -26 */
	halves (0055757, 0132075),		/* -25 */
	halves (0061465, 0370246),		/* -24 */
	halves (0064602, 0666320),		/* -23 */
	halves (0067743, 0444004),		/* -22 */
	halves (0073456, 0166402),		/* -21 */
	halves (0076571, 0624103),		/* -20 */
	halves (0101730, 0171123),		/* -19 */
	halves (0105447, 0113564),		/* -18 */
	halves (0110560, 0736521),		/* -17 */
	halves (0113715, 0126245),		/* -16 */
	halves (0117440, 0165747),		/* -15 */
	halves (0122550, 0223341),		/* -14 */
	halves (0125702, 0270232),		/* -13 */
	halves (0131431, 0363140),		/* -12 */
	halves (0134537, 0657770),		/* -11 */
	halves (0137667, 0633766),		/* -10 */
	halves (0143422, 0701372),		/* -9 */
	halves (0146527, 0461670),		/* -8 */
	halves (0151655, 0376246),		/* -7 */
	halves (0155414, 0336750),		/* -6 */
	halves (0160517, 0426542),		/* -5 */
	halves (0163643, 0334272),		/* -4 */
	halves (0167406, 0111564),		/* -3 */
	halves (0172507, 0534121),		/* -2 */
	halves (0175631, 0463146),		/* -1 */
	halves (0201400, 0000000),		/* 0 */
	halves (0204500, 0000000),		/* 1 */
	halves (0207620, 0000000),		/* 2 */
	halves (0212764, 0000000),		/* 3 */
	halves (0216470, 0400000),		/* 4 */
	halves (0221606, 0500000),		/* 5 */
	halves (0224750, 0220000),		/* 6 */
	halves (0230461, 0132000),		/* 7 */
	halves (0233575, 0360400),		/* 8 */
	halves (0236734, 0654500),		/* 9 */
	halves (0242452, 0013710),		/* 10 */
	halves (0245564, 0416672),		/* 11 */
	halves (0250721, 0522450),		/* 12 */
	halves (0254443, 0023471),		/* 13 */
	halves (0257553, 0630407),		/* 14 */
	halves (0262706, 0576511),		/* 15 */
	halves (0266434, 0157115),		/* 16 */
	halves (0271543, 0212741),		/* 17 */
	halves (0274674, 0055531),		/* 18 */
	halves (0300425, 0434430),		/* 19 */
	halves (0303532, 0743536),		/* 20 */
	halves (0306661, 0534465),		/* 21 */
	halves (0312417, 0031701),		/* 22 */
	halves (0315522, 0640261),		/* 23 */
	halves (0320647, 0410336),		/* 24 */
	halves (0324410, 0545213),		/* 25 */
	halves (0327512, 0676455),		/* 26 */
	halves (0332635, 0456171),		/* 27 */
	halves (0336402, 0374713),		/* 28 */
	halves (0341503, 0074076),		/* 29 */
	halves (0344623, 0713116),		/* 30 */
	halves (0347770, 0675742),		/* 31 */
	halves (0353473, 0426555),		/* 32 */
	halves (0356612, 0334310),		/* 33 */
	halves (0361755, 0023372),		/* 34 */
	halves (0365464, 0114134),		/* 35 */
	halves (0370601, 0137163),		/* 36 */
	halves (0373741, 0367020),		/* 37 */
	halves (0377454, 0732312),		/* 38 */
	halves (0402570, 0120775),		/* 39 */
	halves (0405726, 0145174),		/* 40 */
	halves (0411445, 0677215),		/* 41 */
	halves (0414557, 0257061),		/* 42 */
	halves (0417713, 0132675),		/* 43 */
	halves (0423436, 0770626),		/* 44 */
	halves (0426546, 0566774),		/* 45 */
	halves (0431700, 0324573),		/* 46 */
	halves (0435430, 0204754),		/* 47 */
	halves (0440536, 0246150) };		/* 48 */

static unsigned mants[] =
      {	halves (0566111, 0742473),		/* -48 */
	halves (0723534, 0333211),		/* -47 */
	halves (0444231, 0611026),		/* -46 */
	halves (0555300, 0153233),		/* -45 */
	halves (0710560, 0206102),		/* -44 */
	halves (0435346, 0123651),		/* -43 */
	halves (0544637, 0550624),		/* -42 */
	halves (0676007, 0502771),		/* -41 */
	halves (0426604, 0611673),		/* -40 */
	halves (0534345, 0754252),		/* -39 */
	halves (0663437, 0347325),		/* -38 */
	halves (0420163, 0520505),		/* -37 */
	halves (0524220, 0444626),		/* -36 */
	halves (0651264, 0555774),		/* -35 */
	halves (0411660, 0744575),		/* -34 */
	halves (0514235, 0135735),		/* -33 */
	halves (0637304, 0365324),		/* -32 */
	halves (0403472, 0631304),		/* -31 */
	halves (0504411, 0377565),		/* -30 */
	halves (0625513, 0677523),		/* -29 */
	halves (0773036, 0657450),		/* -28 */
	halves (0474723, 0215571),		/* -27 */
	halves (0614110, 0061127),		/* -26 */
	halves (0757132, 0075355),		/* -25 */
	halves (0465370, 0246324),		/* -24 */
	halves (0602666, 0320011),		/* -23 */
	halves (0743444, 0004013),		/* -22 */
	halves (0456166, 0402407),		/* -21 */
	halves (0571624, 0103111),		/* -20 */
	halves (0730171, 0123733),		/* -19 */
	halves (0447113, 0564351),		/* -18 */
	halves (0560736, 0521443),		/* -17 */
	halves (0715126, 0245754),		/* -16 */
	halves (0440165, 0747563),		/* -15 */
	halves (0550223, 0341520),		/* -14 */
	halves (0702270, 0232044),		/* -13 */
	halves (0431363, 0140226),		/* -12 */
	halves (0537657, 0770274),		/* -11 */
	halves (0667633, 0766353),		/* -10 */
	halves (0422701, 0372023),		/* -9 */
	halves (0527461, 0670430),		/* -8 */
	halves (0655376, 0246536),		/* -7 */
	halves (0414336, 0750132),		/* -6 */
	halves (0517426, 0542161),		/* -5 */
	halves (0643334, 0272616),		/* -4 */
	halves (0406111, 0564570),		/* -3 */
	halves (0507534, 0121727),		/* -2 */
	halves (0631463, 0146314),		/* -1 */
	halves (0400000, 0000000),		/* 0 */
	halves (0500000, 0000000),		/* 1 */
	halves (0620000, 0000000),		/* 2 */
	halves (0764000, 0000000),		/* 3 */
	halves (0470400, 0000000),		/* 4 */
	halves (0606500, 0000000),		/* 5 */
	halves (0750220, 0000000),		/* 6 */
	halves (0461132, 0000000),		/* 7 */
	halves (0575360, 0400000),		/* 8 */
	halves (0734654, 0500000),		/* 9 */
	halves (0452013, 0710000),		/* 10 */
	halves (0564416, 0672000),		/* 11 */
	halves (0721522, 0450400),		/* 12 */
	halves (0443023, 0471240),		/* 13 */
	halves (0553630, 0407510),		/* 14 */
	halves (0706576, 0511432),		/* 15 */
	halves (0434157, 0115760),		/* 16 */
	halves (0543212, 0741354),		/* 17 */
	halves (0674055, 0531647),		/* 18 */
	halves (0425434, 0430110),		/* 19 */
	halves (0532743, 0536132),		/* 20 */
	halves (0661534, 0465561),		/* 21 */
	halves (0417031, 0701446),		/* 22 */
	halves (0522640, 0261760),		/* 23 */
	halves (0647410, 0336354),		/* 24 */
	halves (0410545, 0213024),		/* 25 */
	halves (0512676, 0455631),		/* 26 */
	halves (0635456, 0171177),		/* 27 */
	halves (0402374, 0713617),		/* 28 */
	halves (0503074, 0076563),		/* 29 */
	halves (0623713, 0116320),		/* 30 */
	halves (0770675, 0742004),		/* 31 */
	halves (0473426, 0555202),		/* 32 */
	halves (0612334, 0310443),		/* 33 */
	halves (0755023, 0372554),		/* 34 */
	halves (0464114, 0134543),		/* 35 */
	halves (0601137, 0163674),		/* 36 */
	halves (0741367, 0020653),		/* 37 */
	halves (0454732, 0312413),		/* 38 */
	halves (0570120, 0775116),		/* 39 */
	halves (0726145, 0174341),		/* 40 */
	halves (0445677, 0215615),		/* 41 */
	halves (0557257, 0061160),		/* 42 */
	halves (0713132, 0675414),		/* 43 */
	halves (0436770, 0626347),		/* 44 */
	halves (0546566, 0774041),		/* 45 */
	halves (0700324, 0573052),		/* 46 */
	halves (0430204, 0754732),		/* 47 */
	halves (0536246, 0150120) };		/* 48 */

/**********************************************************************

	ATOF - Convert string to float

**********************************************************************/

static int biggest = {halves (0377777, 07777777)};
static double *pbig = {&biggest};

double atof (s)
	register char *s;

	{register int e, c;
	register unsigned frac;
	int negexp, isneg, sigcnt, adjust;
	unsigned holder;
	double *pdouble;

	if (s == 0 || *s == 0) return (0.0);
	negexp = isneg = FALSE;
	e = sigcnt = adjust = frac = 0;
	while (*s == '-' || *s == '+')
		{if (*s == '-') isneg = !isneg;
		++s;
		}
	while ((c = *s++) >= '0' && c <= '9')
		{if (c == '0' && sigcnt == 0) continue;
		if (sigcnt < 10)
			{frac = frac * 10 + (c - '0');
			++sigcnt;
			}
		else	++adjust;
		}
        if (c == '.')
		{while ((c = *s++) >= '0' && c <= '9')
			{if (c == '0' && sigcnt == 0) --adjust;
			else if (sigcnt >= 10) continue;
			else	{frac = frac * 10 + (c - '0');
				++sigcnt;
				--adjust;
				}
			}
		}
        if (c == 'e' || c == 'E')
		{while (*s == '-' || *s == '+')
			{if (*s == '-') negexp = !negexp;
			++s;
			}
		while ((c = *s++) >= '0' && c <= '9')
			e = e * 10 + (c - '0');
		}
	if (frac == 0) return (0.0);
	if (negexp) e = -e;
	adjust += e;
	if (adjust < -48) return (0.0);
	else if (adjust > 38) return (isneg ? -(*pbig) : *pbig);

	sigcnt = 0;	/* now use sigcnt to remember # of shifts */
	while (!(frac & halves (0400000, 0)))	/* normalize */
		{frac <<= 1;
		++sigcnt;
		}
	frac = hpmul (frac, mants[adjust + 48], &negexp); /* high prec mult */
	while (!(frac & halves (0400000, 0)))	/* normalize */
		{frac <<= 1;
		++sigcnt;
		}
	frac >>= 8;
	if (frac & 01)			/* round and maybe shift one more */
		{++frac;
		if (frac & halves (0776000, 0))
			{frac >>= 1;
			--sigcnt;
			}
		}
	frac >>= 1;			/* now have fraction -- need exp */
	e = exps[adjust + 48] >> 27;
	if (e & 0400) e |= halves (0777777, 0777000);
	e += (36 - sigcnt);
	if (e < 0) return (0.0);
	else if (e >= 0400) return (isneg ? -(*pbig) : *pbig);

	holder = (e << 27) | frac;
	if (isneg) holder = -holder;
	pdouble = &holder;
	return (*pdouble);
	}

unsigned hpmul (x, y, plprod)
	register unsigned x, y, *plprod;

	{unsigned x1, x2, x3, y1, y2, y3;
	register unsigned prod, lprod;

	x1 = x >> 24;
	x2 = (x >> 12) & 07777;
	x3 = x & 07777;
	y1 = y >> 24;
	y2 = (y >> 12) & 07777;
	y3 = y & 07777;

	prod = x3 * y3;
	lprod = prod & 07777;
	prod >>= 12;
	prod += (x2 * y3) + (x3 * y2);
	lprod |= (prod & 07777) << 12;
	prod >>= 12;
	prod += (x1 * y3) + (x2 * y2) + (x3 * y1);
	*plprod = lprod | ((prod & 07777) << 24);
	prod >>= 12;
	prod += (x1 * y2) + (x2 * y1);
	prod += (x1 * y1) << 12;
	return (prod);
	}

dextract (d, psign, digits, pexpon)
	double d;
	int *psign, *pexpon;
	char *digits;

	{unsigned dd;
	double *pdd;
	register int exp, maxexp;
	unsigned frac, hfrac;
	int nshift;

	*psign = FALSE;
	if (d == 0.0)		/* special case 0.0 */
		{*digits++ = '0';
		*digits = 0;
		*pexpon = 0;
		return;
		}

	if (d < 0.0)		/* take care of sign stuff */
		{*psign = TRUE;
		d = -d;
		}

	pdd = &dd;		/* prepare to hack */
	*pdd = d;

	exp = -39;		/* find exponent */
	maxexp = 38;
	do	{int avg;
		avg = (exp + maxexp) >> 1;
		if (dd < exps[avg + 48]) maxexp = avg;
		else	exp = avg;
		}
	while ((maxexp - exp) > 1);
	if (exp != maxexp && dd >= exps[maxexp + 48]) ++exp;
	++exp;		/* for . at left */
	
	frac = (dd & halves (0777, 0777777)) << 9;
	frac = hpmul (frac, mants[49 - exp], &hfrac);
	nshift = (dd >> 27) + (exps[49 - exp] >> 27) - 256;
	if (nshift <= 0)
		{hfrac = 1;
		frac = 0;
		}
	else	{hfrac = 0;
		while (--nshift >= 0)
			{hfrac <<= 1;
			if (frac & halves (0400000, 0)) ++hfrac;
			frac <<= 1;
			}
		}
	nshift = 12;
	while (TRUE)
		{*digits++ = hfrac + '0';
		if (--nshift < 0) break;
		hfrac = hpmul (frac, 10, &frac);
		}
	*digits = 0;
	*pexpon = exp;
	}

int fprint (d, fd, p)
	double d;
	register int p;
	int fd;

	{register int cnt;
	char buf[15];
	int minus, expon, ndigs;

	cnt = 0;
	if (p < 0) p = 0;
	else if (p > 22) p = 22;

	dextract (d, &minus, buf, &expon);

	if (minus)
		{putc ('-', fd);
		++cnt;
		}
	ndigs = expon + p;
	if (ndigs <= 0 || expon > 8)
		{expon += doround (buf, p + 1);
		return (cnt + eform (fd, buf, expon, p));
		}
	expon += doround (buf, ndigs);
	return (cnt + fform (fd, buf, expon, p));
	}

int doround (p, n)
	register char *p;

	{register char *q;

	if (n >= 12) n = 12;
	else if (n <= 0) n = 1;
	q = &p[n];
	if (n < 12 && p[n] >= '5')
		{while (TRUE)
			{*q = 0;
			if (++(*--q) <= '9') break;
			if (q == p)
				{p[0] = '1';
				p[1] = 0;
				return (1);
				}
			}
		++q;
		}
	while (TRUE)
		{*q = 0;
		if (q <= p || *--q != '0') break;
		}
	return (0);
	}

int eform (fd, q, expon, p)
	register char *q;

	{register int cnt, ndigs;
	char buf[5];

	if (*q) putc (*q++, fd);
	else	putc ('0', fd);
	putc ('.', fd);
	cnt = p + 3;
	while (--p >= 0)
		{if (*q) putc (*q++, fd);
		else	putc ('0', fd);
		}
	putc ('e', fd);
	if (--expon < 0)
		{expon = -expon;
		putc ('-', fd);
		}
	else	putc ('+', fd);
	itoa (expon, buf);
	q = buf;
	while (*q)
		{putc (*q++, fd);
		++cnt;
		}
	return (cnt);
	}

int fform (fd, q, expon, p)
	register char *q;

	{register int cnt;
	cnt = 0;
	while (*q && *q == '0' && expon > 1)
		{--expon;
		++q;
		}
	while (expon > 0)
		{if (*q) putc (*q++, fd);
		else	putc ('0', fd);
		--expon;
		++cnt;
		}
	putc ('.', fd);
	cnt += (p + 1);
	while (--p >= 0)
		{if (expon >= 0 && *q) putc (*q++, fd);
		else	putc ('0', fd);
		++expon;
		}
	return (cnt);
	}

int eprint (d, fd, p)
	double d;
	int fd, p;

	{char buf[15];
	int cnt, minus, expon;

	cnt = 0;
	if (p < 0) p = 0;
	else if (p > 22) p = 22;

	dextract (d, &minus, buf, &expon);
	expon += doround (buf, p + 1);
	if (minus)
		{putc ('-', fd);
		++cnt;
		}
	return (cnt + eform (fd, buf, expon, p));
	}
