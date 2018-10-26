/* Created from disassembly of SAIL file C4220.MID[C,SYS].
 * Care has been taken to match line numbers in the generated
 * MIDAS file. */

extern int mflag;
extern int f_output;
extern char cstore[];
extern char *fn_string;
extern int fn_output;

char *afloat();
char *aidn();
char *aif();
char *aifm();
char *am();
char *aname();
char *apname();
char *astring();
char *ffloat();
char *getbuf();
char *opname();
char *sconcat();
char *asetfno();

#define TEXT "t"
#define BINARY "b"
#define SMALL "-34359738368"

int nfn { 9 };
char *fn[] { "ff", "i", "sr", "n", "if", "ifm", "m", "pname", "setfno" };
char *(*ff[])() { afloat, aidn, astring, aname, aif, aifm, am, apname, asetfno };
int funcn[10];
#define STRING_EMPTY ""
char *regnames[] { "A", "C", "D", "B" };

int packf();
int packc();

char bufff[10][50];
int bufc { 0 };
int packb[4];
int packn[1];

/*
 *
 */
char * asetfno (a, b)
char **b;
{
	stcpy(*b, funcn);
	return "";
}

/*
 *
 *
 *
 *
 *
 *
 */
char *aname (x, y)
char *y;
{
	int a, b;
	char *c, *d;

	a = atoi(*y);
	if (x == 1) return opname(a);
	b = atoi(y[1]);



	if (mflag != 0) cprint("ANAME(%d,%d)\n", a, b);



	if (a >= 0) return regnames[a];
	a = -a;
	d = "";
	if (a >= 9) {
		c = regnames[a - 9];
		if (b != 0) d = sconcat(3, "#1(", c, ")");
		else d = sconcat(3, "(", c, ")");
		goto end;
	}
	switch (a) {
	case 1:
		d = sconcat(3, "<#1-FS", funcn, "-\\%P>(P)");
		goto end;
	case 2:
		return "%i(#1)";
	case 3:
		return "I#1";
	case 4:
		d = sconcat(3, "<#1-FS", funcn, "-\\%A-\\%P>(P)");
		goto end;
	case 5:
		return "L#1";
	case 6:
		return "[#1]";
	case 7:
		return "[%ff(#1)]";
	case 8:
		return "S#1";
	}

	return "";
end:	if (b%1 != 0) error(6025, 0);
	return d;
}

/*
 *
 *
 *
 *
 */
char *opname (x)
{
	switch (x) {
	case 64:
	case 102:
		return "ADD";
	case 68:
	case 94:
	case 106:
		return "SUB";
	case 72:
		return "IMUL";
	case 76:
	case 80:
		return "IDIV";
	case 86:
		return "AND";
	case 90:
		return "IOR";
	case 88:
		return "XOR";
	case 66:
		return "FADR";
	case 70:
		return "FSBR";
	case 74:
		return "FMPR";
	case 78:
		return "FDVR";
	}
	return "";
}

/*
 *
 *
 *
 */
char *aif (a, b)
char **b;
{
	return atoi(*b) != 0 ? "#1" : "#2";
}

/*
 *
 *
 *
 */
char *aifm (x, y)
char **y;
{
	int a;
	if (atoi(*y) == -6) {
		a = atoi(y[1]);
		if (a >= 0 && a <= 262143)
			return "#2"; }
	return "#3";
}

/*
 *
 *
 *
 */
char *am (x, y)
char **y;
{
	return &cstore[atoi(*y)];
}

/*
 *
 *
 *
 */
char *aidn (x, y)
char **y;
{
	char *a, *b, *c;
	int d, e;

	if (x > 0) {
		a = &cstore[atoi(*y)];
		b = c = getbuf();
		if (*a == ' ') {
			++a;
			d = 6;
			while ((e = *a++) != 0 && --d >= 0) {
				if (e == '$')
					e = *a++;
				if (e == '#' || e == '%') *b++ = '\\';
				*b++ = e;
			}

		} else {
			*b++ = 'Z';
			d = 5;
			while ((e = *a++) != 0 && --d >= 0)
				*b++ = e == '_' ? 'J' : e;
		}
		*b = 0;
		return c;
	}
	return "";
}

/*
 *
 *
 *
 *
 */
char * afloat (a, b)
char **b;
{
	return ffloat (atoi (*b));
}
char *ffloat (a)
{
	char *b, *c, *d;
	char e, f;

	d = getbuf();
	f = 0;
	b = &cstore[a];
	c = d;

	while (e = *b++) {
		switch (e) {
		case '.': f = 1;
			*c++ = '.';
			if ((*b < '0') | (*b > '9')) *c++ = '0';
			break;
		case 'e': if (!f) {
			*c++ = '.';
			*c++ = '0';
			f = 1;
			}
			*c++ = '^';
			break;
		default: if (c < d+50) *c++ = e;
		}
	}
	if (f == 0) {
		*c++ = '.';
		*c++ = '0';
	}

	*c++ = 0;
	return d;
}

/*
 *
 *
 *
 *
 */
char *astring (a, b)
{
	int c, d, e;

	d = 0;
	c = xopen(fn_string, 114, BINARY);

	while (1) {
		packf();
		e = cgetc(c);
		if (e <= 0) if (ceof(c)) break;
		cprint (f_output, "S%d:", d);
		d++;
		while (1) {
			if (e == '$') {
				e = cgetc(c);
				d++;
				if (e == '0') e = 0;
				packc(e);
			}
			else {
				packc(e);
				if (e == 0) break;
			}
			e = cgetc(c);
			d++;
		}
	}
	cclose(c);
	packf();
	return "\\";
}

/*
 *
 *
 *
 *
 *
 */
char *apname (a, b)
{
	char *buf;
	buf = getbuf();
	fngnm(fn_output, buf);
	return buf;
}

/*
 */
char *sconcat (x, y, x0, x1, x2, x3)
char *y;
{
	char b;
	char *c;
	char *d;
	char **e;
	char *f;

	f = getbuf();
	e = &y - 1;
	d = f;
	
	while (--x >= 0) {
		c = *++e;
		while (b = *c++) *d++ = b;
	}

	*d = 0;
	return f;
}

/*
 *
 *
 *
 *
 *
 *
 *
 *
 */
char *getbuf ()
{
	if (++bufc >= 10) bufc=0;
	return bufff[bufc];
}

/*
 *
 *
 *
 *
 *
 *
 *
 *
 *
 */
int packc (x)
{
	cprint(f_output, "\t%d\n", x);
}

int packf ()
{
	;
}
