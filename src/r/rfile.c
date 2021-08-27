# include "r.h"

/*

	R Text Formatter
	File Output Routines

	Copyright (c) 1976, 1977 by Alan Snyder


	ROUTINES:

	fil_open (aflag)
	fil_write (s)
	fil_close ()
	fil_init ()

*/

int	wfile {OPENLOSS};

extern	char ofname[];

/**********************************************************************

	FIL_INIT - Initialize

**********************************************************************/

fil_init ()

	{;}

/**********************************************************************

	FIL_OPEN - Open new output file.

**********************************************************************/

fil_open (aflag)

	{register ac s;
	fil_close ();
	s = get_text ();
	if (aflag) wfile = openappend (ac_string (s));
		else wfile = openwrite (ac_string (s));
	if (wfile == OPENLOSS)
		error ("unable to create auxiliary file '%s'", s);
	ac_unlink (s);
	}

/**********************************************************************

	FIL_WRITE_STRING - Write encoded string to file.

**********************************************************************/

fil_write_string (s)
	ac s;

	{char *p;
	int count, c;

	if (wfile == OPENLOSS)
		{error ("no output file open");
		return;
		}
	p = ac_string (s);
	count = ac_size (s);
	while (--count >= 0)
		{c = *p++;
		switch (c) {
	case '#':	--count; c = *p++;
			if (c == '0') {cputc ('#', wfile); continue;}
			if (c >= '1' && c <= '9')
				{c = c-'0';
				while (--c >= 0) cputc ('\\', wfile);
				--count;
				c = *p++;
				}
			switch (c) {
			case ' ':	cputc ('', wfile);
			case '.':
			case '\'':	break;
			default:	c = c - ('a' - 1);
					}
			cputc (c, wfile);
			continue;
	default:	if ((c >= 1 && c <= 26) || c == '\\')
				cputc ('', wfile);
			cputc (c, wfile);
			}
		}
	}

/**********************************************************************

	FIL_CLOSE - Close open file.

**********************************************************************/

fil_close ()

	{if (wfile == OPENLOSS) return;
	cclose (wfile);
	wfile = OPENLOSS;
	}
