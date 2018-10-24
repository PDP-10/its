# include "gt.h"

/*

	GT Compiler
	Section 5: Error Message Editor

*/

/**********************************************************************

	global variables

	sterm		table of GT terminal symbols
	snterm		table of GT nonterminal symbols
	sq		table of states

**********************************************************************/

extern char cstore[], *eopch[];

char *sterm[] {
	"", "-|", "error", ";", "(", ")", "[", "]", ":", ",", "|",
	"~", "amop", "TYPENAMES", "ALIGN", "POINTER", "CLASS",
	"CONFLICT", "TYPE", "MEMNAMES", "MACROS", "SIZE", "INDIRECT",
	"REGNAMES", "RETURNREG", "SAVEAREASIZE", "OFFSETRANGE",
	"M", "idn", "integer", "string", 0};

char *snterm[] {
	"", "$accept", "program", "$s1", "$s2", "$s1.list", "s1",
	"$s2.list", "s2", "$or", "$r", "$t", "$o", "$m", "$o.list",
	"$m.list", "$size", "s.list", "$align", "a.list", "$pointer",
	"p.list", "$class", "c.list", "$offsetrange", "or.list",
	"$returnreg", "r.list", "$type", "t.list", "$conflict",
	"x.list", "$oploc", "$saveareasize", "s.elem", "a.elem",
	"p.elem", "c.elem", "r.elem", "t.elem", "x.elem", "int_list",
	"idn_list", "$typenames", "$memnames", "$regnames", "or.elem",
	"oploc_list", "oploc", "oplist", "op1", "op2", "op3", "opl",
	"ope", "clobber", "macro", "name_list", "cstring_list",
	"cstring", "ope2", "name", "amop_list", 0};

int sq[] {
	0, 0, 4098, 4099, 4101, 4100, 4103, 13, 19, 23, 4102, 4139,
	4140, 4141, 26, 4105, 4120, 14, 15, 16, 17, 21, 25, 4104,
	4112, 4114, 4116, 4118, 4126, 4129, 4, 4, 4, 28, 4121,
	4142, 24, 4106, 4122, 29, 4115, 4131, 28, 4117, 4132, 28,
	4119, 4133, 4, 4127, 4136, 29, 4113, 4130, 29, 28, 4138,
	4138, 4138, 4, 3, 9, 28, 4123, 4134, 18, 4107, 4124, 4,
	3, 9, 4, 3, 9, 4, 3, 9, 28, 3, 9, 4, 3, 9, 3, 9, 5, 5,
	5, 29, 9, 4142, 4, 3, 9, 28, 4125, 4135, 12, 4108, 4110,
	4128, 4145, 4138, 4131, 29, 4132, 4138, 4133, 9, 4136,
	4138, 4130, 28, 3, 3, 3, 9, 29, 5, 4138, 4134, 4, 3, 9,
	8, 20, 4128, 4, 11, 22, 27, 28, 29, 4143, 4144, 4146, 4149,
	4150, 5, 5, 5, 28, 5, 29, 5, 5, 5, 4138, 4135, 4145, 12,
	28, 4109, 4111, 4152, 4153, 4157, 4150, 4150, 4144, 9,
	10, 5, 5, 5, 4152, 4, 30, 4154, 4155, 4157, 8, 5, 4147,
	4149, 4150, 4150, 4156, 4155, 8, 9, 9, 4148, 4149, 4156,
	6, 4151, 9, 4138, 3, 4156, 7, 5, 8, 30, -1};

/**********************************************************************

	ERROR MESSAGES

**********************************************************************/

char *m1000[] {
/* 1000 */	"INVALID CHARACTER",
/* 1001 */	"INVALID ESCAPE CHARACTER",
/* 1002 */	"UNRECOGNIZED ABSTRACT MACHINE OPERATOR",
/* 1003 */	"INVALID MANIFEST CONSTANT DEFINITION",
/* 1004 */	"INVALID COMPILER CONTROL LINE",
/* 1005 */	"INVALID ESCAPE CONTROL LINE"
	};

char *m2000[] {
/* 2000 */	0,
/* 2001 */	"UNTERMINATED STRING CONSTANT",
/* 2002 */	"MULTIPLE TYPENAMES STATEMENTS IGNORED",
/* 2003 */	"MULTIPLE REGNAMES STATEMENTS IGNORED",
/* 2004 */	"MULTIPLE MEMNAMES STATEMENTS IGNORED",
/* 2005 */	"RETURN REGISTER FOR %t REDEFINED",
/* 2006 */	"%q DELETED",
/* 2007 */	"SYNTAX ERROR. PARSE SO FAR:     ",
/* 2008 */	" %q",
/* 2009 */	"ALIGNMENT FACTORS MUST INCREASE",
/* 2010 */	" _ ",
/* 2011 */	" %t",
/* 2012 */	"DELETED:  ",
/* 2013 */	"SKIPPED:  ",
/* 2014 */	"MISSING SAVEAREASIZE STATEMENT",
/* 2015 */	"SIZE OF %t REDECLARED",
/* 2016 */	"SIZE OF %t NOT SPECIFIED",
/* 2017 */	"MACRO %t REDEFINED",
/* 2018 */	"ATTEMPT TO MIX REGISTER AND MEMORY IN LOCATION EXPRESSION",
/* 2019 */	0,
/* 2020 */	"ALIGNMENT OF TYPE %t REDECLARED",
/* 2021 */	"INVALID ALIGMENT CLASS %d",
/* 2022 */	"NO POINTER CLASS CAN RESOLVE TYPE %t",
/* 2023 */	"ALIGNMENT CLASS FOR %t NOT SPECIFIED",
/* 2024 */	"SMALLEST ALIGNMENT FACTOR MUST BE 1",
/* 2025 */	0,
/* 2026 */	"UNDEFINED POINTER CLASS %t",
/* 2027 */	"UNDEFINED REGISTER %t",
/* 2028 */	"UNDEFINED DATA TYPE %t",
/* 2029 */	"UNDEFINED MEMORY REFERENCE TYPE %t"
	};

char *m4000[] {
/* 4000 */	"NAME TABLE OVERFLOW",
/* 4001 */	"NAME TABLE OVERFLOW",
/* 4002 */	"MACRO DEFINITION OVERFLOW",
/* 4003 */	"PROGRAM TOO COMPLICATED. PARSER STACK OVERFLOW.",
/* 4004 */	"MANIFEST CONSTANT DEFINITION TABLE OVERFLOW",
/* 4005 */	"PROGRAM TOO LARGE: SYMBOL TABLE OVERFLOW",
/* 4006 */	"TOO MANY NAMED MACROS",
/* 4007 */	0,
/* 4008 */	0,
/* 4009 */	0,
/* 4010 */	0,
/* 4011 */	0,
/* 4012 */	"I GIVE UP",
/* 4013 */	"TYPENAMES STATEMENT MISSING",
/* 4014 */	"REGNAMES STATEMENT MISSING",
/* 4015 */	"MEMNAMES STATEMENT MISSING",
/* 4016 */	"TOO MANY POINTER CLASSES",
/* 4017 */	"TOO MANY REGISTERS",
/* 4018 */	"TOO MANY REGISTER CLASSES",
/* 4019 */	"TOO MANY DATA TYPES",
/* 4020 */	"TOO MANY MEMORY REFERENCE TYPES",
/* 4021 */	"POINTER STATEMENT MISSING",
/* 4022 */	"TYPE STATEMENT MISSING",
/* 4023 */	"OPLOC STATEMENTS MISSING",
/* 4024 */	"MACROS MISSING",
/* 4025 */	"RETURNREG STATEMENT MISSING"
	};

char *m6000[] {
/* 6000 */	"T(P): ATTEMPT TO REFERENCE TOKEN %d",
/* 6001 */	"POP(P): STACK ERROR",
/* 6002 */	"LEX(P): TOKEN BUFFER OVERFLOW",
/* 6003 */	"SETSP(P): STACK POINTER TOO SMALL",
/* 6004 */	"SETSP(P): STACK POINTER TOO LARGE",
/* 6005 */	"LEX(P): INCONSISTENT TOKEN POINTERS",
/* 6006 */	"PARSE(P): ATTEMPT TO POP EMPTY PARSER STACK"
	};

/**********************************************************************

	DTOKEN - Print Token

**********************************************************************/

dtoken (type, index)

	{extern int cout;
	ptoken (&type, cout);
	}

/**********************************************************************

	EPRINT - Error Editor Formatted Print Routine

**********************************************************************/

eprint (fmt, x1, x2) char *fmt;

	{int *argp, x, c;
	char *s;

	argp = &x1;			/* argument pointer */
	while (c = *fmt++)
		{if (c != '%') eputc (c);
		else
			{x = *argp++;
			switch (c = *fmt++) {

case 'd':	/* decimal */	if (x<0) {x = -x; eputc ('-');}
				eprd (x);
				break;
case 'q':	/* parser state */
				x = sq[x];
				if (x<0) break;
				if (x<010000) eprint ("%s", sterm[x]);
				else eprint ("<%s>", snterm[x-010000]);
				break;
case 's':	/* string */	s = x;
				while (c = *s++) eputc (c);
				break;
case 't':	/* token */	dtoken (x, *argp++);
				break;
default:			eputc (c);
				--argp;
				}
			}
		}
	}

/**********************************************************************

	EPRD - Print Positive Decimal Integer

**********************************************************************/

eprd (n)

	{int a;
	if (a=n/10) eprd (a);
	eputc (n%10+'0');
	}

/**********************************************************************

	EPUTC - Write a character onto standard output unit.

	Break lines which exceed 60 characters.

**********************************************************************/

eputc (c)

	{static int column;
	extern int cout;

	if (column >= 59 && c == ' ') c = '\n';
	else if (column >= 80 && c != '\n')
		{cputc ('\n', cout); column = 0;
		}
	cputc (c, cout);
	if (c=='\n') column=0; else ++column;
	}

/**********************************************************************

	ERROR - Print Error Message

**********************************************************************/

error (errno, lineno, p1, p2)

	{char *f, *getfmt();

	if (lineno>0) eprint ("\n%d:  ", lineno);
	if (errno>=6000) eprint ("COMPILER ERROR.  ");

	if (errno < 2000)
		f = getfmt (errno-1000, m1000, sizeof m1000);
	else if (errno < 4000)
		f = getfmt (errno-2000, m2000, sizeof m2000);
	else if (errno < 6000)
		f = getfmt (errno-4000, m4000, sizeof m4000);
	else f = getfmt (errno-6000, m6000, sizeof m6000);

	if (f==0) {f = "ERROR %d"; p1=errno;}
	eprint (f, p1, p2);
	if (errno>=4000) cleanup (1);
	}

/**********************************************************************

	GETFMT - get format given
		N - relative error number
		T - error message table
		Z - size of error message table

**********************************************************************/

char *getfmt (n, t, z)
	char *t[];

	{int nm;

	nm = z / sizeof t[0];
	if (n < 0 || n >= nm) return (0);
	return (t[n]);
	}
