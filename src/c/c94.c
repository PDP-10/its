# include "cc.h"

/*

	C Compiler
	Routines common to phases C and M

	Copyright (c) 1977 by Alan Snyder

	atoi

*/


/**********************************************************************

	ATOI - convert string to integer

	This routine performs special hacks in case the number is --X,
	where -X is the smallest negative number.  The result in
	this case will be off by one, but at least the sign and
	approximate magnitude will be right.  Hopefully, whatever
	stupid user-written macro results in this condition is only
	looking for relatively small integers.

**********************************************************************/

int atoi (s) char s[];

	{int i, sign, c;
	
	if (!s) return (0);
	i = 0;
	sign = 1;
	while (*s == '-') {++s; sign = -sign;}
	while ((c = *s++)>='0' && c<='9') i = i*10 + c-'0';
	if (i<0)
		{i = -i;
		if (i<0)
			if (sign>0) return (-(i+1));
			else return (i);
		}
	return (sign*i);
	}

