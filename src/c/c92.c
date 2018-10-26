# include "cc.h"

/*

	C Compiler
	Routines common to phases L and M

	Copyright (c) 1977 by Alan Snyder

	stcmp

*/


/**********************************************************************

	STCMP - Compare Strings

**********************************************************************/

int stcmp (s1, s2)	char *s1, *s2;

	{register int u;
	while ((u = *s1++) == *s2++) if (!u) return (TRUE);
	return (FALSE);
	}

