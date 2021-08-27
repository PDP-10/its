# include "r.h"

/*

	R Text Formatter
	LPT Output Routines

	Copyright (c) 1976, 1977 by Alan Snyder


	ROUTINES:

	lpt_init ()
	set_lpt ()

	lpt_header ()
	lpt_char (c)
	lpt_eow ()
	lpt_vp (pos, ha, hb)
	lpt_space (width, pos)
	lpt_eol (pos, ha, hb)
	lpt_eop ()
	lpt_eof ()

*/

extern	int	nvui, nhui, dvpw, dvpl, vsp, superfactor;
extern	int	olvpu, fout, printing, oul, ovoff, Znpage;
static	int	need2 {FALSE};
# define ESC 033

/**********************************************************************

	LPT_INIT - Initialize

**********************************************************************/

lpt_init ()

	{;}

/**********************************************************************

	SET_LPT - Set Device

**********************************************************************/

set_lpt ()

	{nvui = 6;
	nhui = 10;
	dvpw = 132;
	dvpl = 60;
	vsp = 0;
	superfactor = 1;
	}

/**********************************************************************

	LPT_HEADER - Output file header

**********************************************************************/

lpt_header () {;}

/**********************************************************************

	LPT_CHAR - Output actual text character.

**********************************************************************/

lpt_char (c)

	{extern int tul, tfont, tvoff;
	extern fontdes *font_table[];
	int ul;

	if (!printing) return;
	if (tvoff != ovoff)
		{int old_voff, new_voff, diff;
		old_voff = ovoff + min_voff;
		new_voff = tvoff + min_voff;
		diff = new_voff - old_voff;
		if (diff > 0) while (--diff >= 0)
			{outc (ESC);
			outc ('u');
			need2 = TRUE;
			}
		else while (++diff <= 0)
			{outc (ESC);
			outc ('d');
			need2 = TRUE;
			}
		ovoff = tvoff;
		}
	ul = tul;
	switch (font_table[tfont]->fmode) {
		case f_underline:	ul = TRUE; break;
		case f_overprint:	outc (c); outc ('\b'); break;
		case f_caps:		if (c>='a' && c<='z') c =- 'a'-'A';
					break;
		}
	if (ul && c != '_')
		{outc ('_');
		outc ('\b');
		}
	if (c == ESC) {outc (ESC); need2 = TRUE;}
	outc (c);
	}

/**********************************************************************

	LPT_EOW - Output whatever necessary at end of word.

**********************************************************************/

lpt_eow ()

	{;}

/**********************************************************************

	LPT_VP - Output whatever is necessary to set up the
		vertical position of the next line at vertical
		position POS, having a height above the base
		line of HA and a height below the baseline of HB.

**********************************************************************/

lpt_vp (pos, ha, hb)

	{int i;

	if (printing)
		{i = pos-olvpu-1;
		if (i<0)
		   while (++i<=0) {outc (ESC); outc ('p'); need2 = TRUE;}
		else while (--i>=0) outc ('\n');
		olvpu = pos-1;
		}
	}

/**********************************************************************

	LPT_SPACE - Output a space of given width or tab to
		the given horizontal position.

**********************************************************************/

lpt_space (width, pos)

	{if (width==0 || !printing) return;
	if (width>0) {while (--width>=0) outc (' ');}
	else while (++width<=0) outc ('\b');
	}

/**********************************************************************

	LPT_EOL - Output whatever is necessary to terminate
		the current line, which is at vertical position POS
		and has height above baseline HA and height below
		baseline HB.

**********************************************************************/

lpt_eol (pos, ha, hb)

	{if (printing)
		{outc ('\n');
		olvpu = pos+hb;
		}
	}

/**********************************************************************

	LPT_EOP - Output whatever is necessary to terminate
		the current page.

**********************************************************************/

lpt_eop ()

	{if (printing)
		{outc ('\014');
		++Znpage;
		olvpu = 0;
		}
	}

/**********************************************************************

	LPT_EOF - Output whatever is necessary to terminate
		the output file.

**********************************************************************/

lpt_eof ()

	{if (need2) cprint ("Note: postprocessing needed.\n");}
