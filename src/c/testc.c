/*

	TESTC - Program to test C Compiler

	This program evokes all of the CMAC macros.

*/

/**********************************************************************

	data for testing global data definition and initialization

**********************************************************************/

int	e1;
int	e2 9;
int	e3 {2*6};
int	e4[5] {0, 1, 2, 3, 4};

static int	i1;
static int	i2 -13;
static int	i3 {4096};
static int	i4[5] {0, -1, -2, -3, -4};

char	c1;
char	c2 'a';
char	c3 {'b'};
char	c4[5] {'A', 'B', 'C', 'D', 'E'};

int	*p1 {&i2};
char	*p2[2] {"foo", &c3};
int	*p3;


/**********************************************************************

	small functions for testing functions

**********************************************************************/

int f1 (z) {return z+3;}
int f2 (x, y) {return x-y;}

/**********************************************************************

	MAIN - control routine

**********************************************************************/

main ()

	{cprint ("C Testing Program.\n");
	tcond ();
	tint ();
	tincr ();
	tbit ();
	tclass (5, -9999);
	tfunc (f1);
	tswitch ();
	cprint ("Done.\n");
	}

error (i)

	{cprint ("*** Error No. %d ***\n", i);}

/**********************************************************************

	TCOND - test conditionals and logical operations

**********************************************************************/

tcond ()

	{int i, j;

	cprint ("Testing Conditionals.\n");

	if (0) error (10);
	if (1) ; else error (20);
	i = 0;
	if (i) error (30);
	if (i > 0) error (40);
	if (i < 0) error (50);
	if (i != 0) error (60);
	if (i == 0) ; else error (70);
	if (i <= 0) ; else error (80);
	if (i >= 0) ; else error (90);
	if (i > 0) i = 4; else i = 3;
	if (i != 3) error (100);
	if (i == 0) error (110);
	if (i == 4) error (120);
	i = 0;
	j = 0;
	if (i && j) error (130);
	if (i || j) error (140);
	if (!i) ; else error (150);
	j = 1;
	if (i && j) error (160);
	if (i || j) ; else error (170);
	if (!j) error (180);
	i = 2;
	if (i && j) ; else error (190);
	if (i || j) ; else error (200);
	if (!i) error (210);
	}

/**********************************************************************

	TINT - test integer arithmetic

**********************************************************************/

tint ()

	{int i, j, k;
	int x0, x1, x2, x3, x4;

	cprint ("Testing Integer Arithmetic.\n");

	x0=0;x1=1;x2=2;x3=3;x4=4;
	if (x0 != 0) error (10);
	if (x1 > 1) error (20);
	if (x2 < 2) error (30);
	if (x3 <= 3) ; else error (31);
	if (x4 >= 4) ; else error (32);
	if (x1 + x2 != x3) error (40);
	if (x1 * x3 != x3) error (50);
	if (x4 / x2 != x2) error (60);
	if (x4 % x3 != x1) error (70);
	i = 56;
	j = -102;
	k = 7;
	if (i*j + i*k != i*(j+k)) error (80);
	if (i*(k+3) + j*(k+3) != (i+j)*(k+3)) error (90);
	j =+ i;
	if (j != -46) error (100);
	if ((j =+ i) != 10 || j != 10) error (110);
	if (++j != 11 || j != 11) error (120);
	if (j++ != 11 || j != 12) error (130);
	if (--j != 11 || j != 11) error (140);
	if (j-- != 11 || j != 10) error (150);
	if (-j != k-17) error (160);
	if ((j =* 2) != 20 || j != 20) error (170);
	if ((j =- 13) != k || j != k) error (180);
	if ((j =% 4) != 3 || j != 3) error (190);
	if ((i =/ 14) != x4 || i != x4) error (200);
	if (3 + 5 - 12 * 40 != -472) error (210);
	if (-5 * 10 != -448/56 + 68%9 - 47) error (220);
	if (k*1 != 0+k) error (230);
	if (k/1 != k || k != k-0) error (240);
	if (i*0) error (250);
	}

/**********************************************************************

	TFUNC - test function calling

**********************************************************************/

tfunc (x)	int (*x)();

	{cprint ("Testing Function Calling.\n");

	if ((*x)(4) != 7) error (10);
	x = f2;
	if ((*x)(7,2) != 5) error (20);
	}

/**********************************************************************

	TSWITCH - test switch statement

**********************************************************************/

tswitch ()

	{cprint ("Testing Switch Statements.\n");

	tsw1 (0);
	tsw1 (1);
	tsw1 (2);
	tsw1 (3);
	tsw1 (4);
	tsw1 (-2);
	tsw1 (-5);
	tsw1 (-10000);
	tsw1 (4000);
	tsw1 (15);
	tsw2 (0);
	tsw2 (1);
	tsw2 (2);
	tsw2 (3);
	tsw2 (4);
	tsw2 (-2);
	tsw2 (-5);
	tsw2 (-10000);
	tsw2 (4000);
	tsw2 (15);
	}

/**********************************************************************

	support routines for testing of switch statement

**********************************************************************/

tsw1 (i)

	{switch (i) {

	error (10);
	break;
	error (20);
case 4:
	if (i!=4) error (30);
	break;
	error (40);
case 2:
	if (i!=2) error (50);
case 3:
	if (i!=3 && i!=2) error (60);
	break;
	error (70);
case 0:
	if (i!=0) error (80);
	break;
case -2:
	if (i != -2) error (90);
	break;
default:
	if (i == -2 || i == 0 || i == 2 || i == 3 || i == 4)
		error (100);
	}
	}

tsw2 (i)

	{int j;

	j = -9;

	switch (i) {

	error (200);
	break;
	error (210);
case -10000:
	if (i != -10000) error (220);
	break;
	error (230);
case 3:
	if (i != 3) error (240);
	j = 3;
case -5:
	if (i != -5 && i != 3) error (250);
	if (i == 3 && j != 3) error (251);
	break;
case 4000:
	if (i != 4000) error (260);
	j = 36;
	break;
default:
	if (i == -10000 || i == 3 || i == -5 || i == 4000)
		error (270);
	if (i == 1) j = 24;
	}

	if (i == 3 && j != 3) error (280);
	if (i == 4000 && j != 36) error (290);
	if (i == 1 && j != 24) error (300);
	}

/**********************************************************************

	TINCR - test increment and decrement operations

**********************************************************************/

tincr ()

	{int i, *p, a[3];

	cprint ("Testing Increment and Decrement Operations.\n");

	i = 0;
	if (i) error (4000);
	++i;
	if (i != 1) error (4010);
	++i;
	if (i != 2) error (4020);
	i++;
	if (i != 3) error (4030);
	i++;
	if (i != 4) error (4040);
	i--;
	if (i != 3) error (4050);
	i = -10;
	--i;
	if (i != -11) error (4060);
	++i;
	if (i != -10) error (4070);
	if (--i != -11) error (4080);
	if (i != -11) error (4090);
	if (i-- != -11) error (4100);
	if (i != -12) error (4110);
	if (++i != -11) error (4120);
	if (i != -11) error (4130);
	if (i++ != -11) error (4140);
	if (i != -10) error (4150);

	a[0] = 10;
	a[1] = 11;
	a[2] = 12;

	p = a+1;
	if (*p != 11) error (4160);
	if (*--p != 10) error (4170);
	if (*p != 10) error (4180);
	if (*p++ != 10) error (4190);
	if (*p != 11) error (4200);
	if (*++p != 12) error (4210);
	if (*p != 12) error (4220);
	if (*p-- != 12) error (4230);
	if (*p != 11) error (4240);
	}

/**********************************************************************

	TBIT - test bit hacking operations

**********************************************************************/

tbit ()

	{int i, j;

	cprint ("Testing Bit Hacking Operations.\n");

	i = 0;
	j = -1;
	if (~i != j) error (10);
	if (~~i != i) error (20);
	if (~j != i) error (30);
	if (i & j) error (40);
	if (i | i) error (50);
	if (j ^ j) error (60);
	i = 1;
	if ((i << 1) != 2) error (70);
	if ((i =<< 1) != 2 || i != 2) error (71);
	i = 1;
	if ((i << 8) != 0400) error (80);
	if ((i =<< 8) != 0400 || i != 0400) error (81);
	i = 0404;
	if ((i >> 1) != 0202) error (90);
	if ((i =>> 1) != 0202 || i != 0202) error (91);
	i = 0404;
	if ((i >> 2) != 0101) error (100);
	if ((i >> 6) != 04) error (110);
	i = 0404;
	if ((i ^ 0703) != 0307) error (120);
	if ((i =^ 0703) != 0307 || i != 0307) error (121);
	i = 0404;
	if ((i ^ 0707) != 0303) error (130);
	if ((i =^ 0707) != 0303 || i != 0303) error (131);
	i = 0404;
	if ((i | 030) != 0434) error (140);
	if ((i =| 030) != 0434 || i != 0434) error (141);
	i = 0625;
	if ((i & 0451) != 0401) error (150);
	if ((i =& 0451) != 0401 || i != 0401) error (151);
	}

/**********************************************************************

	TCLASS - test different storage classes

**********************************************************************/

tclass (x, y)	int x, y;

	{int i, j;
	static int k, l;

	cprint ("Testing Storage Classes.\n");

	if (x != 5) error (5010);
	if (y != -9999) error (5020);
	if (k != 0) error (5030);
	if (l != 0) error (5040);
	i = 6;
	j = 9;
	x = i;
	k = y;
	if (i != 6) error (5050);
	if (j != 9) error (5060);
	if (x != 6) error (5070);
	if (y != -9999) error (5080);
	if (k != -9999) error (5090);
	if (l != 0) error (5100);
	if (e1 != 0) error (5110);
	if (e2 != 9) error (5120);
	if (e3 != 12) error (5130);
	if (e4[0] != 0) error (5140);
	if (e4[4] != 4) error (5150);
	if (i1 != 0) error (5160);
	if (i2 != -13) error (5170);
	if (i3 != 4096) error (5180);
	if (i4[1] != -1) error (5190);
	if (i4[3] != -3) error (5200);
	if (c1 != 0) error (5210);
	if (c2 != 'a') error (5220);
	if (c3 != 'b') error (5230);
	if (c4[0] != 'A') error (5240);
	if (c4[4] != 'E') error (5250);
	if (p1 != &i2) error (5260);
	if (p2[0][1] != 'o') error (5270);
	if (p2[1] != &c3) error (5280);
	e2 = i2;
	i1 = e3;
	if (e2 != -13) error (5290);
	e2 = c1;
	if (e2 != 0) error (5300);
	if (i1 != 12) error (5310);
	p1 = &x;
	if (*p1 != 6) error (5320);
	*p1 = 98;
	p1 = &k;
	if (*p1 != -9999) error (5330);
	*p1 = 34;
	if (x != 98) error (5340);
	if (k != 34) error (5350);
	if ((&c4[4] - &c4[1]) != 3) error (5360);
	if ((&e4[2] - &e4[3]) != -1) error (5370);
	if (p3) error (5380);
	if (!p3); else error (5480);
	p1 = &y;
	if (*p1 != y) error (5490);
	*p1 = 77;
	if (y != 77) error (5500);
	}

/**********************************************************************

	output routines

**********************************************************************/

cprint (fmt, x1, x2)	char fmt[], x1[], x2[];

	{int *argp, x, c;
	char *s;

	argp = &x1;	/* argument pointer */
	while (c = *fmt++)
		{if (c != '%') putchar (c);
		else
			{x = *argp++;
			switch (c = *fmt++) {

		case 'd':	/* decimal */
				if (x<0) {x= -x; putchar ('-');}
				cprd (x);
				break;

		case 's':	/* string */
				s = x;
				while (c = *s++) putchar (c);
				break;

		default:	putchar (c);
				argp--;
				}
			}
		}
	}

cprd (n)

	{int a;
	if (a=n/10) cprd (a);
	putchar (n%10+'0');
	}

