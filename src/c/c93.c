# include "cc.h"

/*

	C Compiler
	Routines common to phases M and E

	Copyright (c) 1977 by Alan Snyder

	rcstore

*/


/**********************************************************************

	RCSTORE - Read CSTORE routine

**********************************************************************/

int rcstore ()

	{extern char *fn_cstore, cstore[];
	char *cp, c, *ep;
	int f;

	f = copen (fn_cstore, MREAD, BINARY);
	if (f == OPENLOSS)
		{cprint ("Unable to open '%s'.\n", fn_cstore);
		return (TRUE);
		}
	cp = cstore;
	ep = &cstore[cssiz];

	while (cp < ep)
		{c = cgetc (f);
		if (c <= 0 && ceof (f)) break;
		*cp++ = c;
		}
	cclose (f);
	return (FALSE);
	}

