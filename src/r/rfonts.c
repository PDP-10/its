# include "r.h"

/*

	R Text Formatter
	Font Hacking

	Copyright (c) 1976, 1977 by Alan Snyder


	ROUTINES:

	read_font (n)		read in font # n
	bool = font_exists (n)	does font exist?
	s = font_name (n)	return font file name
	h = font_ha (n)		return font height above baseline
	h = font_hb (n)		return font height below baseline
	w = font_width (n, c)	return width of char in font
	set_font (n, s)		set font
	n = fontid (ic)		parse font identification
	fonts_init ()		initialization routine

*/

fontdes *font_table [max_fonts];
extern	int	device;

/**********************************************************************

	FONTS_INIT - Initialization Routine

**********************************************************************/

int	fonts_init ()

	{register int i;

	for (i=0;i<max_fonts;++i) font_table[i] = 0;
	set_font (0, "25vg");
	}

/**********************************************************************

	READ_FONT - Read in specified font.

**********************************************************************/

read_font (n)

	{fontdes *f, *rdfont();

	if (n<0 || n>=max_fonts)
		barf ("READ_FONT: bad font number %d", n);
	else if (f = font_table[n]) f = rdfont (f);
	}

/**********************************************************************

	FONT_EXISTS - Does Font Exist?

**********************************************************************/

int	font_exists (n)

	{if (n<0 || n>=max_fonts) return (FALSE);
	return (font_table[n] != 0);
	}

/**********************************************************************

	FONT_NAME - Return FONT file name

**********************************************************************/

char	*font_name (n)

	{fontdes *f;

	if (n<0 || n>=max_fonts)
		{barf ("FONT_NAME: bad font number %d", n);
		return ("");
		}
	if (f = font_table[n]) return (f->fname);
	return ("");
	}

/**********************************************************************

	FONT_HA - Return FONT height above baseline

**********************************************************************/

# ifndef USE_MACROS

int	font_ha (n)

	{if (device == d_lpt) return (1);
	if (n<0 || n>=max_fonts)
		{barf ("FONT_HA: bad font number %d", n);
		return (24);
		}
	return (font_table[n]->fha);
	}

/**********************************************************************

	FONT_HB - Return FONT height below baseline

**********************************************************************/

int	font_hb (n)

	{if (device == d_lpt) return (0);
	if (n<0 || n>=max_fonts)
		{barf ("FONT_HB: bad font number %d", n);
		return (8);
		}
	return (font_table[n]->fhb);
	}

/**********************************************************************

	FONT_WIDTH - Return width of character in font.

**********************************************************************/

int	font_width (n, c)

	{if (device == d_lpt) return (1);
	if (n < 0 || n >= max_fonts)
		{barf ("FONT_WIDTH: bad font number %d", n);
		return (0);
		}
	return (font_table[n]->fwidths[c]);
	}

# endif /* USE_MACROS */

/**********************************************************************

	SET_FONT - Set Font

**********************************************************************/

set_font (n, s)	char s[];

	{if (n<0 || n>=max_fonts) barf ("SET_FONT: bad font number: %d", n);
	else
		{fontdes *f;
		int l;
		if ((f = font_table[n]) == 0)
			f = font_table[n] = salloc (sizeof(*f)/sizeof(n));
		f->fmode = (n==0 ? f_normal : f_underline);
		l = slen (s);
		if (l>=3 && s[l-1]==')' && s[l-3]=='(')
			{switch (chlower (s[l-2])) {
			case 'n':	f->fmode = f_normal; break;
			case 'u':	f->fmode = f_underline; break;
			case 'o':	f->fmode = f_overprint; break;
			case 'c':	f->fmode = f_caps; break;
			default:	error ("bad font mode '%c'", s[l-2]);
				}
			s[l-3] = 0;
			if (l>3 && s[l-4]==' ') s[l-4] = ' ';
			}
		stcpy (s, f->fname);
		}
	}

/**********************************************************************

	FONTID - Convert character to font number

**********************************************************************/

int fontid (c)
	ichar c;

	{if (c >= '0' && c <= '9') return (c - '0');
	if (c >= 'A' && c <= 'F') return (c - 'A' + 10);
	return (-1);
	}
