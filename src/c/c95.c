# include "cc.h"

/*

	C Compiler
	Routines common to phases L, P, C, M

	Copyright (c) 1977 by Alan Snyder

	error
	xopen

*/

/**********************************************************************

	ERROR - C Compiler Error Message Writer

	Append an error record on the error file, f_error.
	If the error is a fatal error (error number >= 4000)
	call the cleanup routine to exit.

**********************************************************************/

int maxerr 0;

error (errno, p1, p2, p3, p4, p5, p6)

	{extern int f_error;
	extern char *fn_error;
	int i, *ip;

	if (errno > maxerr) maxerr = errno;
	if (f_error == -1) 
		f_error = xopen (fn_error, MAPPEND, BINARY);
	ip = &errno;
	for (i=0;i<7;i++) puti (*ip++, f_error);
	if (errno >= 4000) cleanup (1);
	}


/**********************************************************************

	XOPEN - Open File with Error Detection

	open file given 

		file - name of file
		mode - mode of file
		opt - string of system-dependent options

	If unable to open print a message and exit.
	Otherwise, return the file number.

**********************************************************************/

int xopen (file, mode, opt)
	char *file, *opt;
	int mode;

	{int i;

	i = copen (file, mode, opt);
	if (i == OPENLOSS)
		{cprint ("Unable to open '%s'.\n", file);
		cexit (100);
		}
	return (i);
	}

