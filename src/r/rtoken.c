# include "r.h"

/*

	R Text Formatter
	Token Routines

	Copyright (c) 1976, 1977 by Alan Snyder


	*** TOKEN TYPE ***

	type	val		meaning

	CENTER			center within column or POS
	HPOS	n>=0 (HU)	set horizontal pos (from .HP or HPOS nr)
	NLSPACE	n>=0 (HU)	SPACE created from NL
	NULL			ignore
	POS	n>=0 (HU)	set horizontal pos (from ^P,^C,^R,^I)
	RIGHT			right flush the following text
	SPACE	n>=0 (HU)	horizontal space
	TABC	*		tab replacement word
	TEXT	*		a word of text

	*** REPRESENTATION ***

	BIGWORD:	type[31:27], val[26:0]
	!BIGWORD:	type[15:12], val[11:0]

	*** OPERATIONS ***

	token_cons (type, val) => token
	token_val (token) => val
	token_type (token) => type

*/

# ifndef USE_MACROS

token	token_cons (type, val)

	{register token ttype;

	ttype = type;
	if ((type & ~WOMASK) == 0 && (val & ~WVMASK) == 0)
		return ((ttype<<WSHIFT) | val);
	barf ("TOKEN_CONS: bad token, type %d value %d", type, val);
	return (0);
	}

int	token_val (w)	token w;

	{return (w & WVMASK);}

int	token_type (w)	token w;

	{return ((w>>WSHIFT) & WOMASK);}

# endif /* USE_MACROS */
