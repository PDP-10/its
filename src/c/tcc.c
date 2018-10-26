# include "cc.h"

/*

	C Compiler
	Test C Compiler Command Routine (for CMAC Versions)


	Command format:

		cc {option ...} name1.c name2.c ...

	Options:

		d=xxx	set compiler debugging argument to xxx
		k=	keep intermediate files around
		s=	produce listing of symbol table

	Meaningful debugging arguments:

		a	debug code generator
		d	debug parser
		e	debug parser error recovery
		m	debug macro expander


*/

/*     renamings to allow long names     */

# define construct_output_file_names cnsofn
# define execute_phase execph
# define process_options proopt
# define process_equal_option proeq

# define p_argc phsac
# define p_argv phsav

# define argv_L avl
# define argv_LP avlp
# define argv_P avp
# define argv_C avc
# define argv_M avm
# define argv_E ave
# define argv_S avs

/*     intermediate file names     */

# define fncs "0.cstore"
# define fner "0.error"
# define fnhm "0.hmac"
# define fnma "0.mac"
# define fnno "0.node"
# define fnst "0.string"
# define fnsy "0.symtab"
# define fnto "0.token"
# define fnty "0.typtab"

/*     options     */

char	debug[40];
int	kflag, sflag;

/*     phase information     */

# define nphase 7

# define p_L 0
# define p_LP 1
# define p_P 2
# define p_C 3
# define p_M 4
# define p_E 5
# define p_S 6

char	*p_name[]	{"L", "LP", "P", "C", "M", "E", "S"};
char	*p_prog[]	{"/dsk/c/_l-cm.tbin",
			"/dsk/c/_lp-cm.tbin",
			"/dsk/c/_p-cm.tbin",
			"/dsk/c/_c-cm.tbin",
			"/dsk/c/_m-cm.tbin",
			"/dsk/c/_e-cm.tbin",
			"/dsk/c/_s-cm.tbin"};

char	*argv_L[]	{debug, 0, fnto, fncs, fner, fnst};
char	*argv_LP[]	{debug, 0, fnno, fnty, fner, fnma, fncs, fnst, fnhm, fnsy};
char	*argv_P[]	{debug, fnto, fnno, fnty, fner, fnma, fnhm, fnsy};
char	*argv_C[]	{debug, fner, fnno, fnty, fnma};
char	*argv_M[]	{debug, 0, fncs, fner, fnma, fnst, fnhm};
char	*argv_E[]	{debug, fner, fncs};
char	*argv_S[]	{fncs, fnty, fnsy, 0};

char	*p_argc[]	{6, 10, 8, 5, 7, 3, 4};
char	**p_argv[]	{argv_L, argv_LP, argv_P, argv_C, argv_M,
				argv_E, argv_S};

# define file_name_size 30

/**********************************************************************

	DESCRIPTION OF EXTERNAL-DEFINED ROUTINES USED

	part of C compiler:

		perror - error message processor (if CALL_ERROR config)
		cprint - formatted output (c96.c)

	standard C library:

		copen - open file for input/output
		cclose - close file

	reasonably machine-independent:

		execv - execute program passing vector of args
			(status returned through exccode)
		delete - delete file
		apfname - append new suffix to file name

*/

/**********************************************************************

	THE MAIN PROGRAM

**********************************************************************/

char *sconcat();

main (argc, argv)	int argc; char *argv[];

	{int	snum, cc, f;
	char	*source;
	char	obj_name[file_name_size], sym_name[file_name_size];

	--argc;
	++argv;
	argc = process_options (argc, argv);
	for (snum = 0; snum < argc; ++snum)
		{source = argv[snum];

	/*	check that source file exists		*/

		if ((f = copen (source, MREAD, TEXT)) == OPENLOSS)
			{cprint ("Can't Find '%s'.\n", source);
			continue;
			}
		cclose (f);

		cprint ("%s:\n", source);

	/*	fix debug arg	*/

		if (sflag) sconcat (debug, 2, debug, "s");

	/*	construct output file names from source file name	*/

		construct_output_file_names (source, obj_name, sym_name);

	/*	create empty ERROR file for phases to append to	*/

		cclose (copen (fner, MWRITE, BINARY));

	/*	set the variable phase arguments	*/

		argv_L[1] = source;
		argv_LP[1] = source;
		argv_M[1] = obj_name;
		argv_S[3] = sym_name;

	/*	now execute the phases	*/

# ifdef MERGE_LP

		cc = execute_phase (p_LP);

# endif

# ifndef MERGE_LP

		cc = execute_phase (p_L);
		if (!cc) cc = execute_phase (p_P);

# endif

		if (!cc) cc = execute_phase (p_C);
		if (!cc) cc = execute_phase (p_M);

# ifdef CALL_ERROR

		perror (fner, fncs);

# endif

# ifndef CALL_ERROR

		execute_phase (p_E);

# endif

		if (sflag) execute_phase (p_S);

		if (!kflag)
			{delete (fnto);
			delete (fncs);
			delete (fner);
			delete (fnno);
			delete (fnsy);
			delete (fnma);
			delete (fnhm);
			delete (fnst);
			delete (fnty);
			}
		}
	}

/**********************************************************************

	PROCESS_OPTIONS - Process options in command arguments
		and remove options from argument list.

**********************************************************************/

int process_options (argc, argv)
	char *argv[];

	{char *s, **ss, **dd;
	int n, opt;

	kflag = sflag = FALSE;
	dd = ss = argv;
	n = 0;
	while (--argc >= 0)
		{s = *ss++;
		if ((opt = s[0]) && s[1] == '=')
			process_equal_option (opt, s+2);
		else
			{*dd++ = s;
			++n;
			}
		}
	return (n);
	}

/**********************************************************************

	PROCESS_EQUAL_OPTION

**********************************************************************/

process_equal_option (opt, s)
	char *s;

	{char *r;
	int c;

	switch (opt = lower (opt)) {
	case 'd':	r = debug;
			while (c = *s++) *r++ = lower (c);
			*r = 0;
			return;
	case 'k':	kflag = TRUE; return;
	case 's':	sflag = TRUE; return;
	default:	cprint ("Unrecognized option: %c=%s\n", opt, s);
			}
	}

/**********************************************************************

	CONSTRUCT_OUTPUT_FILE_NAME

	Construct output file names from source file name.

**********************************************************************/

construct_output_file_names (source, obj_name, sym_name)
	char *source, *obj_name, *sym_name;

	{apfname (obj_name, source, "MIDAS");
	apfname (sym_name, source, "SYMTAB");
	}

/**********************************************************************

	EXECUTE PHASE

**********************************************************************/

int execute_phase (n)	int n;

	{extern int exccode;	/* set by execv to phase return code */
	int	c;
	char	*s;

	if (execv (p_prog[n], p_argc[n], p_argv[n]))
		{cprint ("Unable to execute phase %s\n", p_name[n]);
		return (-1);
		}
	s = p_name[n];
	while (c = *s++) cprint ("%c\n", c);
	return (exccode);
	}

/**********************************************************************

	LOWER - Convert Character To Lower Case

**********************************************************************/

int lower (c)

	{if (c >= 'A' && c <= 'Z') c =+ ('a' - 'A');
	return (c);
	}

/**********************************************************************

	SCONCAT - String Concatenate

	concatenate strings S1 ... Sn into buffer B
	return B

**********************************************************************/

char *sconcat (b, n, s1, s2, s3, s4, s5, s6, s7, s8)
	char *b, *s1, *s2, *s3, *s4, *s5, *s6, *s7, *s8;

	{char **s, *p, *q;
	int c;

	q = b;
	s = &s1;

	while (--n >= 0)
		{p = *s++;
		while (c = *p++) *q++ = c;
		}

	*q = 0;
	return (b);
	}

