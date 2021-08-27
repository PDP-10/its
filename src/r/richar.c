# include "r.h"

/*

	R Text Formatter
	Input Character Routines

	Copyright (c) 1976, 1977 by Alan Snyder


	ROUTINES:

	type = ichar_type (ic)
	val = ichar_val (ic)
	ic = ichar_cons (type, value)
	ichar_print (ic, fd)

	REPRESENTATION OF AN ICHAR:

	An ICHAR is represented as an integer consisting of 2 fields:

	bits 14-9	T (type)
	bits 8-0	V (value)

	The possible ICHARs:

	T=0		Text character; V is ASCII code.
	T=1		R control character; V is ASCII designation
			character.
	T>10		An R control character protected by T-10
			protection characters; V is the ASCII designation
			character.

*/

# ifndef USE_MACROS

int ichar_type (ic) {return ((ic>>9) & 077);}
int ichar_val (ic) {return (ic & 0777);}

int ichar_cons (type, value)

	{if (value>>9) barf ("ICHAR_CONS: bad value %d", value);
	if (type>>6) barf ("ICHAR_CONS: bad type %d", type);
	return ((type<<9)|value);
	}

# endif

/**********************************************************************

	ICHAR_PRINT - Print an ICHAR

	Ichar_print prints an ICHAR in a readable form.

**********************************************************************/

ichar_print (ic, fd)

	{int type, val;

	type = (ic>>9) & 077;
	val = ic & 0777;

	switch (type) {

case i_text:	switch (val) {

	case ' ':	cprint (fd, "b_"); break;
	case '\r':	cprint (fd, "\\r"); break;
	case '\n':	cprint (fd, "\\n"); break;
	case '\014':	cprint (fd, "\\014"); break;
	case '^':	cprint (fd, "^_"); break;
	case '\\':	cprint (fd, "\\_"); break;
	default:	cputc (val, fd); break;
			}
		break;

case i_control:

		switch (val) {

	case 'G':	break;	/* internal: don't print */
	case 'j':	cputc ('\n', fd); break;
	case ' ':	cputc (' ', fd); break;
	case 0:		cprint (fd, "^@"); break;
	default:	cputc ('^', fd); cputc (val, fd); break;
			}
		break;

default:	if (type > i_protect)
			{while (type > i_protect)
				{cputc ('\\', fd);
				--type;
				}
			ichar_print (ichar_cons (i_control, val), fd);
			}
		}
	}
