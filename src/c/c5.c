# include "cc.h"

/*

	C Compiler
	Phase E: Error Message Editor

	Copyright (c) 1977 by Alan Snyder

*/

/**********************************************************************

	global variables:

	cstore		holds identifiers
	fn_cstore	name of cstore file
	asgnop		table of =ops for printing operator tokens
	nodeop		table of node symbols
	sterm		table of terminal symbols
	snterm		table of nonterminal symbols
	sq		table of states

	externally defined routines used:

	copen		open file for input/output
	geti		read integer in internal format
	cputc		output character
	cclose		close file
	ceof		test for end-of-file
	cexit		terminate program
	cprint		formatted print
	rcstore		read CSTORE intermediate file

**********************************************************************/

char	cstore[cssiz], *fn_cstore, *getfmt();

char	*asgnop[]		/* for listing of =op's */
	{"=>>","=<<","=+","=-","=*","=/","=%","=&","=^","=|"};

# include "cnop.h"

char *sterm[] {
	"", "-|", "error", ";", "}", "{",
	"]", "[", ")", "(", ":", ",",
	".", "?", "~", "!", "&", "|",
	"^", "%", "/", "*", "-", "+",
	"=", "<", ">", "++", "--", "==",
	"!=", "<=", ">=", "<<", ">>", "->",
	"=op", "&&", "||", "c", "INT", "CHAR",
	"FLOAT", "DOUBLE", "STRUCT", "AUTO", "STATIC", "EXTERN",
	"RETURN", "GOTO", "IF", "ELSE", "SWITCH", "BREAK",
	"CONTINUE", "WHILE", "DO", "FOR", "DEFAULT", "CASE",
	"ENTRY", "REGISTER", "SIZEOF", "LONG", "SHORT", "UNSIGNED",
	"TYPEDEF", "l", "m", "n", "o", "p",
	"q", "r", "s", "identifier", "integer", "floatcon",
	"string", 0};

char *snterm[] {
	"", "$accept", "program", "external_definition", "function_definition", "function_specification",
	"function_body", "formal_declarations", "compound_statement", "init_declarator_list", "init_declarator", "initializer",
	"initial_value_expression_list", "initial_value", "initial_value_expression", "declaration_list", "declaration", "decl_specifiers",
	"type_specifier", "literal_type_specifier", "sc_specifier", "declarator_list", "declarator", "$declarator",
	"dclr", "function_declarator", "parameter_list", "formal_decl_list", "formal_declaration", "type_decl_list",
	"type_declaration", "$type_specifier", "statement_list", "statement", ".expression", "expression_list",
	"expression", "lexpression", "fterm", "type_identifier", "term", "cast_type",
	"null_decl", "while", "do", "for", "switch", "struct",
	"$identifier", "begin", "end", "constant", "c_term", 0};

int sq[] {
	0, 0, 4098, 9, 21, 40, 41, 42, 43, 44,
	45, 46, 47, 61, 63, 64, 65, 66, 75, 4099,
	4100, 4101, 4112, 4113, 4114, 4115, 4116, 4121, 4135, 4143,
	75, 4121, 4121, 40, 42, 40, 40, 9, 61, 75,
	4102, 4103, 4114, 4115, 4123, 4124, 4126, 4127, 9, 21,
	75, 4121, 10, 4105, 4106, 4118, 4119, 4120, 4116, 3,
	4114, 9, 7, 5, 75, 4144, 8, 8, 75, 4122,
	4126, 5, 4104, 4145, 4124, 9, 21, 75, 4117, 4118,
	4120, 75, 4120, 4120, 10, 9, 14, 15, 22, 76,
	4147, 4148, 11, 3, 5, 16, 22, 75, 76, 77,
	78, 4107, 4109, 9, 7, 8, 6, 4147, 4125, 4126,
	5, 8, 11, 75, 4111, 4112, 4113, 3, 9, 14,
	15, 16, 21, 22, 27, 28, 48, 49, 50, 52,
	53, 54, 55, 56, 57, 58, 59, 60, 62, 76,
	77, 78, 4104, 4128, 4129, 4132, 4134, 4136, 4139, 4140,
	4141, 4142, 75, 11, 3, 8, 4147, 4147, 4148, 4148,
	4148, 21, 20, 19, 23, 22, 33, 34, 25, 26,
	31, 32, 29, 30, 16, 18, 17, 37, 38, 13,
	4106, 4121, 22, 76, 4108, 4109, 4110, 4147, 75, 76,
	77, 8, 6, 4147, 6, 4, 4126, 4125, 75, 10,
	4128, 4112, 4115, 4137, 75, 4132, 4136, 4136, 4136, 4136,
	4136, 4136, 4136, 3, 4132, 75, 4132, 4133, 9, 3,
	3, 10, 4147, 75, 9, 4136, 4, 4146, 75, 4129,
	3, 21, 20, 19, 23, 22, 33, 34, 25, 26,
	31, 32, 29, 30, 16, 18, 17, 37, 38, 13,
	24, 36, 11, 9, 27, 28, 7, 12, 35, 9,
	4129, 9, 9, 4118, 8, 4147, 4147, 4147, 4147, 4147,
	4147, 4147, 4147, 4147, 4147, 4147, 4147, 4147, 4147, 4147,
	4147, 4147, 4147, 4147, 76, 4, 11, 6, 4, 4129,
	4146, 9, 21, 4138, 8, 8, 3, 3, 4132, 4129,
	10, 10, 4137, 4132, 4132, 4132, 4132, 4132, 4132, 4132,
	4132, 4132, 4132, 4132, 4132, 4132, 4132, 4132, 4132, 4132,
	4132, 4132, 4132, 4132, 4132, 4131, 4132, 8, 4132, 75,
	75, 4132, 55, 4130, 4132, 4132, 10, 4, 4110, 8,
	4138, 4138, 7, 4136, 8, 4129, 4129, 8, 10, 11,
	8, 6, 8, 9, 3, 8, 4147, 8, 6, 4147,
	4129, 4132, 4132, 4129, 4132, 4130, 4129, 9, 6, 51,
	8, 3, 8, 4129, 3, 4130, 8, 4129, -1};

/**********************************************************************

	ERROR MESSAGES

**********************************************************************/

char *m1000[] {

/* 1000 */	"INVALID CHARACTER",
/* 1001 */	"UNTERMINATED COMMENT",
/* 1002 */	"CHARACTER CONSTANT TOO LONG",
/* 1003 */	"UNTERMINATED CHARACTER CONSTANT",
/* 1004 */	"%t: BAD FUNCTION RETURN TYPE CHANGED TO POINTER",
/* 1005 */	"%t: INVALID USE OF FUNCTION TYPE CHANGED TO POINTER",
/* 1006 */	"UNUSED AUTOMATIC VARIABLE: %t",
/* 1007 */	0,
/* 1008 */	0,
/* 1009 */	0,
/* 1010 */	"INVALID RENAME CONTROL LINE",
/* 1011 */	"UNTERMINATED COMPILE-TIME CONDITIONAL",
/* 1012 */	"INVALID MANIFEST CONSTANT DEFINITION",
/* 1013 */	"INVALID COMPILER CONTROL LINE",
/* 1014 */	"INVALID INCLUDE CONTROL LINE",
/* 1015 */	0,
/* 1016 */	0,
/* 1017 */	"TOO FEW ARGUMENTS IN MACRO INVOCATION",
/* 1018 */	"AUTOMATIC EXTERNAL DEFINITIONS NOT ALLOWED",
/* 1019 */	"CLASS DECLARATIONS NOT ALLOWED FOR FUNCTIONS",
/* 1020 */	"INVALID IFDEF OR IFNDEF CONTROL LINE",
/* 1021 */	"%t: FUNCTIONS MUST BE EXTERNAL",
/* 1022 */	"%t: INVALID INITIALIZER TYPE",
/* 1023 */	"%t: TOO MANY INITIALIZERS",
/* 1024 */	"%t: INITIALIZATION OF AUTO VARIABLES NOT IMPLEMENTED",
/* 1025 */	0,
/* 1026 */	"%t: INITIALIZATION NOT ALLOWED",
/* 1027 */	"%t NOT A PARAMETER",
/* 1028 */	"EMITOP(C): NO MACRO FOR OP %o",
/* 1029 */	"CHOOSE(C): NO OPLOC FOR OP %o",
/* 1030 */	"INVALID UNDEFINE",
/* 1031 */	"%t: INVALID ARRAY SIZE SPECIFICATION",
/* 1032 */	"%t: BIT FIELD NOT IN STRUCTURE DEFINITION",
/* 1033 */	"%t: INVALID BIT FIELD WIDTH",
/* 1034 */	"%t: BIT FIELD MUST BE INT"
		};

char *m2000[] {

/* 2000 */	"LINE TOO LONG",
/* 2001 */	"UNTERMINATED STRING CONSTANT",
/* 2002 */	"NOTHING TO BREAK FROM",
/* 2003 */	"NOTHING TO CONTINUE",
/* 2004 */	"CASE NOT IN SWITCH",
/* 2005 */	"DEFAULT NOT IN SWITCH",
/* 2006 */	"%q DELETED",
/* 2007 */	"SYNTAX ERROR. PARSE SO FAR:     ",
/* 2008 */	" %q",
/* 2009 */	"TYPE OF EXPRESSION IN GOTO IS INVALID",
/* 2010 */	" |_ ",
/* 2011 */	" %t",
/* 2012 */	"DELETED:  ",
/* 2013 */	"SKIPPED:  ",
/* 2014 */	"DECLARATION OF %t TOO COMPLICATED",
/* 2015 */	"%t: TOO MANY DIMENSIONS",
/* 2016 */	"INVALID REDECLARATION OF %t",
/* 2017 */	"UNDEFINED LABEL: %t",
/* 2018 */	"INVALID REDEFINITION OF STRUCTURE %t",
/* 2019 */	"INVALID RECURSION IN STRUCTURE DEFINITION",
/* 2020 */	"DUPLICATE CASE IN SWITCH",
/* 2021 */	"MULTIPLE DEFAULT STATEMENTS IN SWITCH",
/* 2022 */	"TYPE OF OPERAND OF %n IS INVALID",
/* 2023 */	"LVALUE REQUIRED AS OPERAND OF %n",
/* 2024 */	"UNDEFINED STRUCTURE: %t",
/* 2025 */	"TYPES OF SUBTRACTED POINTERS MUST BE IDENTICAL",
/* 2026 */	"INVALID CONVERSION OF OPERAND OF %n",
/* 2027 */	"%t UNDEFINED",
/* 2028 */	"CALL OF NON-FUNCTION",
/* 2029 */	"%t NOT A MEMBER OF THE SPECIFIED STRUCTURE",
/* 2030 */	"STRUCTURE REQUIRED",
/* 2031 */	"TYPE CLASH IN CONDITIONAL",
/* 2032 */	"INVALID POINTER COMPARISON",
/* 2033 */	"COPYING OF STRUCTURES NOT IMPLEMENTED",
/* 2034 */	"INVALID POINTER SUBTRACTION",
/* 2035 */	"TEXPR(C): NO MATCH FOR OP %o",
/* 2036 */	"%t: INVALID TYPE OF PARAMETER",
/* 2037 */	"INVALID MACRO DEFINITION",
/* 2038 */	"%t: INITIALIZER MUST BE EXTERNAL OR STATIC",
/* 2039 */	"TOO MANY ARGUMENTS IN FUNCTION CALL",
/* 2040 */	"INVALID USE OF UNDEFINED STRUCTURE %t",
/* 2041 */	"%t IS NOT A TYPE",
/* 2042 */	"INVALID USE OF TYPE NAME %t"
		};

char *m4000[] {

/* 4000 */	"NAME TABLE OVERFLOW",
/* 4001 */	"FLOAT/NAME TABLE OVERFLOW",
/* 4002 */	"TOO MANY NESTED DO/WHILE/FOR/SWITCH GROUPS",
/* 4003 */	"PROGRAM TOO COMPLICATED. PARSER STACK OVERFLOW.",
/* 4004 */	"MANIFEST CONSTANT DEFINITION TABLE OVERFLOW",
/* 4005 */	"PROGRAM TOO LARGE: SYMBOL TABLE OVERFLOW",
/* 4006 */	"TYPE TABLE OVERFLOW.",
/* 4007 */	"DECLARATION TOO COMPLICATED",
/* 4008 */	0,
/* 4009 */	0,
/* 4010 */	"SWITCH TABLE OVERFLOW: TOO MANY CASES",
/* 4011 */	"EXPRESSION TOO COMPLICATED",
/* 4012 */	"I GIVE UP",
/* 4013 */	"FUNCTION TOO LARGE",
/* 4014 */	"TOO MANY MACRO ARGUMENTS",
/* 4015 */	"UNTERMINATED MACRO DEFINITION",
/* 4016 */	"MACRO ARGUMENTS TOO LONG",
/* 4017 */	"UNTERMINATED MACRO INVOCATION",
/* 4018 */	"TOO MANY NESTED MACRO INVOCATIONS",
/* 4019 */	"TOO MANY NESTED INCLUDE FILES"
		};

char *m6000[] {

/* 6000 */	"T(P): ATTEMPT TO REFERENCE T(%d)",
/* 6001 */	"TTEXPR(C): EMPTY REGISTER SET",
/* 6002 */	"POP(P): ATTEMPT TO POP EMPTY DCL STACK",
/* 6003 */	"ASTMT(C): OP %d IN CASE CHAIN",
/* 6004 */	"ICB_GET(M): NO MORE INPUT CONTROL BLOCKS",
/* 6005 */	"TP2O(P): BAD TYPE",
/* 6006 */	"TO2P(C): BAD TYPE",
/* 6007 */	"CGOP(C): RESULT IN INDETERMINATE MEMORY LOCATION",
/* 6008 */	"LEX(P): TOKEN BUFFER OVERFLOW",
/* 6009 */	"ATTRIB(P): INVALID CLASS",
/* 6010 */	"SETSP(P): BAD STACK POINTER",
/* 6011 */	0,
/* 6012 */	"CGMOVE(C): NON-TEMPORARY MEMORY LOCATION DEMANDED",
/* 6013 */	"FREEREG(C): BAD ARGUMENT",
/* 6014 */	"FIXTYPE(PC): BAD TYPE",
/* 6015 */	"FIXSTR(C): BAD CALL",
/* 6016 */	0,
/* 6017 */	"RESERVE(C): REGISTER %d NOT FREE",
/* 6018 */	"RESERVE(C): CONFLICTED REGISTER %d NOT FREE",
/* 6019 */	"CLEAR(C): BAD ARGUMENT %d",
/* 6020 */	"ERRCIDN(C): BAD CALL",
/* 6021 */	"CLEAR(C): REGISTER %d BAD UCODE",
/* 6022 */	"SAVE1(C): BAD ARGUMENT %d",
/* 6023 */	"SAVE(C): UNABLE TO FREE REGISTER %d",
/* 6024 */	"MMOVE(C): BAD CTYPE %d",
/* 6025 */	"ANAME(M): ADDRESSING ERROR",
/* 6026 */	"FUDGE(C): BAD ARGUMENT",
/* 6027 */	"READ_NODE(C): BAD OP %d AT LOC %d",
/* 6028 */	0,
/* 6029 */	"CGCALL(C): BAD RETURN REGISTER",
/* 6030 */	"CRETURN(C): BAD RETURN REGISTER",
/* 6031 */	"CHOOSE(C): NO ACCEPTABLE OPLOC FOR OP %o",
/* 6032 */	"LEX(P): INCONSISTENT TOKEN POINTERS",
/* 6033 */	"PARSE(P): ATTEMPT TO POP EMTPY PARSER STACK",
/* 6034 */	0,
/* 6035 */	"DP2O(P): BAD DICTIONARY POINTER",
/* 6036 */	0,
/* 6037 */	"RP2O(P): BAD RECORD POINTER",
/* 6038 */	"CGMOVE(C): UNABLE TO MOVE TO DESIRED LOCATION",
/* 6039 */	"CGMOVE(C): BAD LOC ARGUMENT [%d,%d]",
/* 6040 */	"GETREG(C): BAD ARGUMENT",
/* 6041 */	"INZ(P): BAD INITIALIZER",
/* 6042 */	"DEFCCL(L): COMPILER CONTROL LINE TABLE OVERFLOW",
/* 6043 */	"TOKGET(L): UNRECOGNIZED OPERATOR %d",
/* 6044 */	"MARK(C): REGISTER %d ALREADY MARKED",
/* 6045 */	"UNMARK(C): REGISTER %d NOT MARKED",
/* 6046 */	"CG_FARG(C): DOUBLE ARG IS SHARED",
/* 6047 */	"RO2P(C): BAD RECORD OFFSET"
		};

/**********************************************************************

	ERROR EDITOR PHASE - MAIN ROUTINE

**********************************************************************/

# ifndef CALL_ERROR

main (argc, argv)	int argc; char *argv[];

	{if (argc < 4)
		{cprint ("C7 Called With Too Few Arguments.\n");
		cexit (100);
		}

	cexit (perror (argv[2], argv[3]));
	}

# endif

/**********************************************************************

	PERROR - Error Editor Processing Routine

**********************************************************************/

perror (fner, fncs)

	{int f_error, lineno, i, p[5], errno, cst_read;
	char *f;

	fn_cstore = fncs;
	cst_read = FALSE;

	f_error = copen (fner, MREAD, BINARY);
	if (f_error == OPENLOSS) return (0);

	while (TRUE)
		{errno = geti (f_error);
		if (errno==0)
			{if (cst_read) eputc ('\n');
			cclose (f_error);
			return (0);
			}
		lineno = geti (f_error);
		if (!cst_read)
			{if (rcstore ()) return (0);
			cst_read = TRUE;
			}
		for (i=0;i<5;i++) p[i] = geti (f_error);
		if (lineno>0) eprint ("\n%d:  ", lineno);
		if (errno>=6000) eprint ("COMPILER ERROR.  ");

		if (errno < 2000)
			f = getfmt (errno-1000, m1000, sizeof m1000);
		else if (errno < 4000)
			f = getfmt (errno-2000, m2000, sizeof m2000);
		else if (errno < 6000)
			f = getfmt (errno-4000, m4000, sizeof m4000);
		else f = getfmt (errno-6000, m6000, sizeof m6000);

		if (f==0) {f = "ERROR %d"; p[0]=errno;}
		eprint (f, p[0], p[1], p[2], p[3], p[4]);
		}
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

/**********************************************************************

	EPRINT - Error PRINT Routine

**********************************************************************/

eprint (fmt,x1,x2,x3,x4,x5,x6,x7,x8,x9)	char fmt[];

	{int *argp, x, c;
	char *s;

	argp = &x1;	/* argument pointer */
	while (c = *fmt++)
		{if (c != '%') eputc (c);
		else
			{x = *argp++;
			switch (c = *fmt++) {

		case 'd':	/* decimal */
				if (x<0) {x= -x; eputc ('-');}
				eprd (x);
				break;

		case 'q':	/* parser state */
				x = sq[x];
				if (x<0) break;
				if (x<010000) eprint ("%s", sterm[x]);
				else eprint ("<%s>", snterm[x-010000]);
				break;

		case 's':	/* string */
				s = x;
				while (c = *s++) eputc (c);
				break;

		case 't':	/* token */
				dtoken (x, *argp++);
				break;

		case 'n':	/* node op */
				eprint ("%s", nodeop[x]);
				break;

		case 'm':	/* string in cstore */
				eprint ("%s", &cstore[x]);
				break;

		default:	eputc (c);
				argp--;
				}
			}
		}
	}

/**********************************************************************

	EPRD - Print Decimal

**********************************************************************/

eprd (n)

	{int a;
	if (a=n/10) eprd (a);
	eputc (n%10+'0');
	}

/**********************************************************************

	EPUTC - write a character onto standard output

	Break lines which exceed 60 characters.

**********************************************************************/

eputc (c)

	{static int column;
	extern int cout;

	if (column >= 59 && c == ' ') c = '\n';
	else if (column >= 80 && c != '\n')
		{cputc ('\n', cout);
		column = 0;
		}
	cputc (c, cout);
	if (c=='\n') column = 0;
	else ++column;
	}

/**********************************************************************

	DTOKEN - Print symbolic representation of token

**********************************************************************/

dtoken (tag, index)

	{if (tag >= TIDN) switch (tag) {

case TIDN:	if (index == UNDEF) {eprint ("unnamed"); break;}
		if (index >= cssiz)	/* structure type or member */
			index =- cssiz;

case TFLOATC: 	eprint ("%s", &cstore[index]);
		break;

case TINTCON:	eprint ("%d", index);
		break;

case TSTRING:	eprint ("\"\"");
		break;
		}

	else if (tag == TEQOP) eprint ("%s", asgnop[index]);
	else eprint ("%s", sterm[tag]);
	}

