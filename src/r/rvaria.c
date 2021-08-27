# include "r.h"
# ifdef HAVE_VARIAN

/*

	R Text Formatter
	VSORT/VARIAN Output Routines


	ROUTINES:

	vn_init ()
	set_vn ()

	OUTPUT ROUTINES:

	vn_header ()
	vn_char (c)
	vn_eow ()
	vn_vp (pos, ha, hb)
	vn_space (width, pos)
	vn_eol (pos, ha, hb)
	vn_eop ()
	vn_eof ()

*/

	int	read_id,write_id,curvpos,curhpos;

extern	env	*e;
extern	int	nvui, nhui, dvpw, dvpl, vsp, superfactor;
extern	int	fout, printing, ofont, oul, ovoff, Znpage;

/**********************************************************************

	VN_INIT - Initialize

**********************************************************************/

vn_init ()

	{;}

/**********************************************************************

	SET_VN - Set Device

**********************************************************************/

set_vn ()

	{nvui = 200;
	nhui = 200;
	dvpw = 1700;
	dvpl = 2047;
	vsp = 6;
	superfactor = 2;
	}

/**********************************************************************

	VN_HEADER - Output font names and exec VSORT

**********************************************************************/

vn_header ()

	{extern char ofname[];
	int i;

	curvpos = curhpos = 0;
	if (fork()) { close(read_id); return(0); }
	close(0);
	close(write_id);
	dup(read_id);
	execl("/usr/bin/rvsort","/usr/bin/rvsort",ofname,
	 font_name(0),font_name(1),font_name(2),
	 font_name(3),font_name(4),font_name(5),font_name(6),font_name(7),0);
	error("VN_HEADER: can't do exec");
	exit(0);
	}

/**********************************************************************

	VN_CHAR - Output actual text character.

**********************************************************************/

vn_char (c)

	{extern int tul, tfont, tvoff;
	extern fontdes *font_table[];
	register int hpos,vpos;

	if (!printing) return;
	ofont = tfont;
	oul = tul;
	ovoff = tvoff;

	hpos = curhpos - font_table[ofont]->flkern[c]
	       + font_table[ofont]->cpadj;
	vpos = (dvpl-curvpos) + (ovoff+min_voff);
	outword((hpos<<5) | ((vpos>>6)&037));
	outword((vpos<<10) | ((ofont&07)<<7) | (c&0177));
	if (oul)
	 { vpos =- 2;
	   outword((hpos<<5) | ((vpos>>6)&037));
	   outword((vpos<<10) | ((ofont&07)<<7) | ('_'&0177));
	 }
	curhpos =+ font_table[ofont]->fwidths[c];
	return;
	}

outword (w)
	{ outi(w&0377); outi((w>>8)&0377); }

/**********************************************************************

	VN_EOW - Output whatever necessary at end of word.

**********************************************************************/

vn_eow ()

	{if (oul && printing) oul = FALSE;
	}

/**********************************************************************

	VN_VP - Output whatever is necessary to set up the
		vertical position of the next line at vertical
		position POS, having a height above the base
		line of HA and a height below the baseline of HB.

**********************************************************************/

vn_vp (pos, ha, hb)

	{if (printing) curvpos = pos;
	}

/**********************************************************************

	VN_SPACE - Output a space of given width or tab to
		the given horizontal position.

**********************************************************************/

vn_space (width, pos)

	{if (width==0 || !printing) return;
	curhpos = pos;
	}

/**********************************************************************

	VN_EOL - Output whatever is necessary to terminate
		the current line, which is at vertical position POS
		and has height above baseline HA and height below
		baseline HB.

**********************************************************************/

vn_eol (pos, ha, hb)

	{;}

/**********************************************************************

	VN_EOP - Output whatever is necessary to terminate
		the current page.

**********************************************************************/

vn_eop ()

	{if (printing) {outword(-1); outword(-1); ++Znpage;}
	}

/**********************************************************************

	VN_EOF - Output whatever is necessary to terminate
		the output file.

**********************************************************************/

vn_eof ()

	{;}

# endif /* HAVE_VARIAN */
