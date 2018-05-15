# include <stdio.h>
# include <ctype.h>
# define FALSE 0
# define TRUE  1
/*

	TOPS-20 Portable C Compiler Command Routine


	Compiler Options

	-c	compile only, do not assemble
	-d	generate debugging code
	-f	write errors to file instead of tty
	-g	do not delete assembly language temp file
	-k	keep intermediate files
	-o	run  code optimizer
	-r	ring bell when done
	-l	link file and standard library, producing .EXE file

	p=xxx	predefine symbol xxx (to be 1)
	l=xxx	look in directory xxx for include files

*/

/*     renamings to allow long names */

# define construct_output_file_names cnsofn
# define execute_phase execph
# define write_statistics wrstat
# define print_phase_time prphtm
# define process_options proopt
# define process_minus_option promin
# define process_equal_option proeq

# define phase_name phsnm
# define phase_pname phspnm
# define phase_prog phspr
# define phase_argc phsac
# define phase_argv phsav
# define phase_option phsop
# define phase_et phset
# define phase_pt phspt

# define argv_P avp
# define argv_C avc

/*     program file names */

/* where to look for executable image files */
#   define PREFIX "C:"

/* extension of executable image files */
#   define SUFFIX ".exe"

# define OBJDIR ""

# define INTSUF "i"
# define OBJSUF "obj"
# define OPTSUF "mid"
# define RELSUF "stk"
# define ERRSUF "cerr"
# define EXESUF "exe"

# define ASMFILE "c:casm.exe"
# define LDFILE "sys:stinkr.exe"
# define LIBRARY "c:stdio"

# define FNSIZE 100


/*	options */

int	kflag, cflag, gflag, oflag, rflag, fflag, dflag, lflag;

/* table for pre-defined symbols */

# define maxpds 10
char	*pdstab[maxpds + 1];
char	**pdsptr = {pdstab};

/* tables for #include default directories */

# define maxdirs 5
char	*dfdirs[maxdirs + 1];
char	**dfdptr = {dfdirs};

/* default search directories for # include <> */

# define n10dirs 2
char	*df10dirs[] = {"-IC:", "-ICLIB:"};


/*     phase information */

# define nphase 3

# define phase_P 0
# define phase_C 1
# define phase_O 2

# define extra maxpds + maxdirs

char	*argv_P[2 + extra];
char	*argv_C[4 + extra];
char	*argv_O[2];

char	*phase_name[] = {"P","C","O"};
char	*phase_pname[] = {"cpp","pcc","opt"};
char	phase_prog[nphase][FNSIZE];
int	phase_argc[] = {2, 3, 2};
char	**phase_argv[] = {argv_P, argv_C, argv_O};
int	phase_et[] = {0, 0, 0};
int	phase_pt[] = {0, 0, 0};

static	char	*pdp10_pdefs[] = {"-DPDP10=1", 0}; /* predefined symbols */

# define opsys_name "-DTOPS20=1"

char	*opsys = NULL;

extern char *sconcat ();

/**********************************************************************

	THE MAIN PROGRAM

**********************************************************************/

main (argc, argv)
char *argv[];
{
	extern FILE *stdout;
	FILE *f;
	int snum, cc, i, ttyflag;
	cal start_time;
	char *fargv[50], buffer[2000];
	char src_name[FNSIZE],
	     int_name[FNSIZE],
	     obj_name[FNSIZE],
	     opt_name[FNSIZE],
	     rel_name[FNSIZE],
	     err_name[FNSIZE],
	     exe_name[FNSIZE];
	char *fptr;
	char nambuf[2][FNSIZE];
	char cmdbuf[100];

	--argc;	/* skip over program name */
	++argv;
	argc = process_options (argc, argv);
	argc = exparg (argc, argv, fargv, buffer);
	argv = fargv;

	pp_setup ();	/* set up preprocessor arguments */

	nambuf[0][0] = '<';	/* for re-directed input */
	nambuf[1][0] = '>';	/* for re-directed output */

	for (snum = 0; snum < argc; ++snum) {
		char name[FNSIZE];

		strcpy (src_name, argv[snum]);

	/*	check that source file exists */

		if ((f = fopen (src_name, "r")) == NULL) {
			char ext[FNSIZE];

			fngtp (src_name, ext);
			if (*ext == 0) {
				fnsfd (src_name, src_name, 0, 0, 0, "c", 0, 0);
				f = fopen (src_name, "r");
			}
			if (f == NULL) {
				printf ("Can't Find '%s'.\n", src_name);
				continue;
			}
		}
		fclose (f);
		fngnm (src_name, name);	/* get name part of file spec */
		for (fptr=name;*fptr!=0;fptr++)
			*fptr = upperr(*fptr);

#ifdef SHORTNAME
		name[6] = 0;	/* print only six chars to match macro */
#endif

		now (&start_time);

	/*	construct output file names from source file name */

		construct_output_file_names (src_name, int_name, obj_name, 
					     opt_name, rel_name, err_name,
					     exe_name);

		for (i = 0; i < nphase; ++i) phase_pt[i] = -1;

#ifdef PHASEPRINT
		printf ("CPP:\t%s\n",name);
#else
		printf ("C:\t%s\n",name);
#endif
		fflush (stdout);

		argv_P[0] = src_name;	/* name of source file */
		argv_P[1] = &nambuf[1][0]; /* >intname for redirected output */
		strcpy (&nambuf[1][1],int_name); /* get intname */
		cc = execute_phase (phase_P);	/* reu preprocessor */
		if (!cc) {

#ifdef PHASEPRINT
			printf ("PCC:\t%s\n",name);
			fflush (stdout);
#endif

			argv_C[0] = &nambuf[0][0]; /* input from int file */
			strcpy (&nambuf[0][1],int_name);
			argv_C[1] = &nambuf[1][0]; /* output to obj file */
			strcpy (&nambuf[1][1],obj_name);
			argv_C[2] = name; /* tell pcc the module name */
			if (fflag) {
				cmdbuf[0] = '%';
				strcpy (cmdbuf + 1,err_name);
				argv_C[3]  = cmdbuf;
				phase_argc[phase_C] = 4;
			}
			cc = execute_phase (phase_C);
		}
		if (!kflag) unlink (int_name);

		if (oflag) {
			argv_O[0] = &nambuf[0][0];
			strcpy (&nambuf[0][1],obj_name);
			argv_O[1] = &nambuf[1][0];
			strcpy (&nambuf[1][1],opt_name);
#ifdef PHASEPRINT
			printf ("OPT:\t%s\n",name);
			fflush(stdout);
#endif
			cc = execute_phase (phase_O);
			if (!kflag) unlink (obj_name);
		}
		else	strcpy (opt_name, obj_name);

		stats(src_name, &start_time);  
		
		if (cc) {
			if (!gflag) unlink (opt_name);
		}
		else if (!cflag) {

#ifdef PHASEPRINT
			printf ("CASM:\t%s\n",name);
			fflush(stdout);
#endif

			cc = assemble (opt_name, rel_name);
			if (!cc) {
				if (!gflag) unlink (opt_name);
				if (lflag) {
					load( rel_name, exe_name );
					unlink( rel_name );
				}
			}
		}
		if (rflag) {
			putc ('\007', stdout);
			fflush (stdout);
		}
	}
	if (rflag) {
		putc ('\007', stdout);
		fflush (stdout);
	}
}

/**********************************************************************

	PROCESS_OPTIONS - Process options in command arguments
		and remove options from argument list.

**********************************************************************/

int process_options (argc, argv)
char *argv[];
{
	char *s, **ss, **dd;
	int n, opt;

	kflag = cflag = gflag = rflag = FALSE;

	dd = ss = argv;
	n = 0;
	while (--argc >= 0) {
		s = *ss++;
		if (s[0] == '-') process_minus_option (s + 1);
		else if ((opt = s[0]) && s[1] == '=')
			process_equal_option (opt, s + 2);
		else	{
			*dd++ = s;
			++n;
		}
	}
	return (n);
}

/**********************************************************************

	PROCESS_MINUS_OPTION

**********************************************************************/

process_minus_option (s)
char *s;
{
	int c;

	while (c = *s) {
		*s++ = c = lower (c);
		switch (c) {
		case 'k':	kflag = TRUE; break;
		case 'c':	cflag = TRUE; break;
		case 'g':	gflag = TRUE; break;
		case 'o':	oflag = TRUE; break;
		case 'r':	rflag = TRUE; break;
		case 'f':	fflag = TRUE; break;
		case 'd':	dflag = TRUE; break;
		case 'l':	lflag = TRUE; break;
		default:	printf ("Unrecognized option: -%c\n", c);
				break;
		}
	}
}	

/**********************************************************************

	PROCESS_EQUAL_OPTION

**********************************************************************/

process_equal_option (opt, s)
char *s;
{
	char *r;
	int c;

	switch (opt = lower (opt)) {
	case 'p':	if (pdsptr < pdstab + maxpds) {
				static char pdss[maxpds][20];
				r = &pdss[pdsptr - pdstab][0];
				*pdsptr++ = r;
				sconcat (r, 3, "-D", s + 2, "=1");
			}
			else printf ("Sorry, too many pre-defined symbols.\n");
			return;

	case 'l':	if (dfdptr < dfdirs + maxdirs) {
				*dfdptr++ = s;
				s[0] = '-';
				s[1] = 'I';
			}
			else printf ("Sorry, too many search directories.\n");
			return;

	default:	printf ("Unrecognized option: %c=%s\n", opt, s);
		}
}

/**********************************************************************

	PP_SETUP

	Add pre-defined symbols and search directories to ARGV_P

**********************************************************************/

pp_setup ()
{
	char **p, *q;

	/* add defined search directories to preproc args */
	p = df10dirs;
	while (p < df10dirs + n10dirs) add_arg (phase_P, *p++);
	p = dfdirs;
	while (p < dfdptr) add_arg (phase_P, *p++);
	
	/* add predefined symbols to preprocessor args */
	p = pdp10_pdefs;
	add_arg (phase_P, *p);	/* add system predefined symbols */
	if (q = opsys) {
		if (strcmp (q, "-DTOPS20=1")) add_arg (phase_P, "-UTOPS20");
		add_arg (phase_P, q);
	}
	p = pdstab;	/* add user predefined symbols */
	while (p < pdsptr) add_arg (phase_P, *p++);
}

/**********************************************************************

	ADD_ARG - append an argument to the list for the given phase

**********************************************************************/

add_arg (phs, arg)
char *arg;
{
	phase_argv[phs][phase_argc[phs]++] = arg;
}

/**********************************************************************

	CONSTRUCT_OUTPUT_FILE_NAMES

	Construct assembler, relocatable, and symbol table listing
	file names from source file name.

**********************************************************************/

construct_output_file_names (src_name, int_name, obj_name, opt_name, rel_name, err_name,exe_name)
char *src_name,*int_name,*obj_name,*opt_name,*rel_name,*err_name,*exe_name;
{
	fnsfd (obj_name, src_name, "", OBJDIR, 0, OBJSUF, 0, 0);
	fnsfd (opt_name, obj_name, 0, 0, 0, OPTSUF, 0, 0);
	fnsfd (int_name, obj_name, 0, 0, 0, INTSUF, 0, 0);
	if (!cflag) fnsfd (rel_name, obj_name, 0, 0, 0, RELSUF, 0, 0);
	if (fflag) fnsfd (err_name, obj_name, 0, 0, 0, ERRSUF, 0, 0);
	if (lflag) fnsfd (exe_name, obj_name, 0, 0, 0, EXESUF, 0, 0);
}

/**********************************************************************

	EXECUTE PHASE

**********************************************************************/

execute_phase (n)
int n;
{
	extern int exctime, exccode;
	int t;

	set_program_name (n);
	t = etime ();
	if (execv (phase_prog[n], phase_argc[n], phase_argv[n])) {
		printf ("Unable to execute phase %s\n", phase_name[n]);
		return (-1);
	}
	phase_et[n] = etime () - t;	/* elapsed time */
	phase_pt[n] = exctime;		/* runtime */
	return (exccode);
}

/**********************************************************************

	SET_PROGRAM_NAME

	Construct the file name of program for the given phase.

**********************************************************************/

set_program_name (n)
int n;
{
	char *r, *s;

	r = PREFIX;
	s = SUFFIX;
	sconcat (phase_prog[n], 4, r, phase_pname[n],".",s);
}

/**********************************************************************

	STATS - write statistics to stat file

**********************************************************************/

# define STATFILE1 "C:pcc.stat"


stats (src_name, st)
char *src_name;
cal *st;
{
	FILE *f;
	int flag, i;
	char temp[50];

	flag = TRUE;
	f = fopen (STATFILE1, "a");
# ifdef statfile2
	if (f == NULL) f = fopen (STATFILE2, "a");
# endif
	if (f == NULL) return;
	putc ('\n', f);
	strcpy (temp,username ());
	fprintf (f, "%s - ", temp);
	prcal (st, f);
	fprintf (f, " - ");
	fngdr (src_name, temp);
	if (temp[0]) {
		slower (temp);
		fprintf (f, "%s/", temp);
	}
	fngnm (src_name, temp);
	slower (temp);
	fprintf (f, "%s", temp);

# define hack if (flag) {fprint (f, " ("); flag = FALSE;} else putc (' ', f)

	if (cflag || gflag || kflag) {
		hack;
		if (cflag) putc ('c', f);
		if (gflag) putc ('g', f);
		if (kflag) putc ('k', f);
	}
	if (!flag) putc (')', f);

	fprintf (f, "\n\n");
	for (i = 0; i < nphase; ++i) print_phase_time (i, f);
	fclose (f);
}

/**********************************************************************

	PRINT_PHASE_TIME - As Part Of Statistics

**********************************************************************/

print_phase_time (n, f)
FILE *f;
{
	if (phase_pt[n] != -1) {
		fprint (f, phase_name[n]);
		if (!phase_name[n][1]) putc (' ', f);
		fprint (f, " P=");
		pr60th (phase_pt[n], f);
		fprint (f, " E=");
		pr60th (phase_et[n], f);
		putc ('\n', f);
	}
}

/**********************************************************************

	ASSEMBLE - Create the relocatable file from the assembler file

	return TRUE iff an error occurred

**********************************************************************/

int assemble (obj_name, rel_name)
char *obj_name, *rel_name;
{
# ifdef TENEX
	/* TENEX can't run MIDAS as an inferior -- sigh */
	fprint ("OUTPUT on %s\n", obj_name);
	return (TRUE);
}
# else

	char *s, temp[100];
	FILE *f;

	/* construct Assembler command line */

	strcpy (temp, rel_name);
	strcat (temp, " _ ");
	strcat (temp, obj_name);
	strcat (temp, " (w)", s);

	/* execute Assembler */
	if (execs (ASMFILE, temp)) {
		fprint (stderr,"Unable to Assemble.\n");
		return (TRUE);
	}

	/* construct Assembler record file name */

	fnsfd (temp, obj_name, 0, 0, 0, "err", 0, 0);

	/* examine Assembler record file */

	f = fopen (temp, "r");
	if (f != NULL) {	/* look for '-' <digit>+ '\t' */
		register int c;

		while ((c = getc (f)) != EOF) {
			if (c == '-') {
				c = getc (f);
				if (!isdigit (c)) continue;
				while (isdigit (c)) c = getc (f);
				if (c != '\t') continue;
				fprint (stderr, "Assembler Errors.\n");
				fclose (f);
				return (TRUE);
			}
		}
		fclose (f);
		unlink(temp);
	}
	return (FALSE);
}

load (rn,en)
char *rn, *en;
{
	char buf[50];
	FILE *tfile;

	tmpnam(buf);
	if ((tfile = fopen(buf,"w")) == NULL) return( TRUE );
	fprintf(tfile,"x %s\nl %s\no %s\nq\n",LIBRARY,rn,en);
	fclose(tfile);
	if (execs (LDFILE, buf)) {
		fprint (stderr,"Unable to load.\n");
		return (TRUE);
	}
	unlink( buf );
	return( FALSE );
}
# endif
