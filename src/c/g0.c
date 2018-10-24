# include "gt.h"

/*

	GT Compiler
	Section 0: Command Routine

*/

/**********************************************************************

	Command Usage:  GT {-options} source.file

	Output is written on the file "source.gtout".

	Options:
		d - print parser debugging info
		t - print tokens

**********************************************************************/


/**********************************************************************

	External Routines used by GT compiler:

	copen		open file for input/output
	cgetc		read character
	cputc		write character
	ceof		test for end-of-file
	cclose		close file
	cexit		terminate process
	apfname		append suffix to file name
	
	plus C24.C (parser) and C96.C (cprint)

**********************************************************************/

char	*fn_source,
	*fn_out,
	fnbuff[40];

main (argc, argv)	int argc; char *argv[];

	{int	f, i, c;
	extern	int debug, tflag;
	char	*s;

	/*	check for options	*/

	if (argc > 1 && (s = argv[1])[0] == '-') i = 2;
	else {i = 1; s = 0;}

	/*	check for file name	*/

	if (argc <= i)
		{cprint ("Usage: GT description.file\n");
		cexit (100);
		}

	/*	process options     */

	if (s) while (c = *++s) switch (c) {
		case 'd':	debug = TRUE; break;
		case 't':	tflag = TRUE; break;
		default:	cprint ("unrecognized option: '%c'\n", c);
				}

	/*	check that source file exists	*/

	fn_source = argv[i];
	if ((f = copen (fn_source, MREAD, TEXT)) == OPENLOSS)
		{cprint ("Can't Find '%s'.\n", fn_source);
		cexit (100);
		}
	cclose (f);

	apfname (fnbuff, fn_source, "gtout");
	fn_out = fnbuff;

	pinit ();
	parse ();
	cleanup (0);
	}

