# include "r.h"
# ifdef HAVE_XGP

/*

	R Text Formatter
	XGP Output Routines

	Copyright (c) 1976, 1977 by Alan Snyder


	ROUTINES:

	xgp_init ()
	set_xgp ()

	OUTPUT ROUTINES:

	xgp_header ()
	xgp_char (c)
	xgp_eow ()
	xgp_vp (pos, ha, hb)
	xgp_space (width, pos)
	xgp_eol (pos, ha, hb)
	xgp_eop ()
	xgp_eof ()

*/

extern	env	*e;
extern	int	nvui, nhui, dvpw, dvpl, vsp, superfactor;
extern	int	olvpu, fout, printing, ofont, oul, ovoff, ulpos, uldpos,
		ulthick, uldthick, page_length, Znpage;

static	int	header_out {FALSE};

/**********************************************************************

	XGP_INIT - Initialize

**********************************************************************/

xgp_init ()

	{;}

/**********************************************************************

	SET_XGP - Set Device

**********************************************************************/

set_xgp ()

	{ulpos = uldpos = -1;
	ulthick = uldthick = 2;
	nvui = 192;
	nhui = 200;
	dvpw = 1632;
	dvpl = infinity;
	vsp = 6;
	superfactor = 2;
	}

/**********************************************************************

	XGP_HEADER - Output file header

**********************************************************************/

xgp_header ()

	{;}

xgp_rheader ()

	{extern char version[];
	extern ac date_ac;
	extern char ofname[], *ac_string();
	int i;
	char buf[10];

	header_out = TRUE;
	outs (";SKIP 1\n;TOPMAR 0\n;BOTMAR 0\n;LFTMAR 0\n;VSP 0\n");
	outs (";SQUISH\n;SIZE ");
	i = vu2mil (page_length);
	i2a (i/1000, buf);
	outs (buf);
	i =% 1000;
	if (i)
		{i2a (i, buf);
		outc ('.');
		if (i<10) outc ('0');
		if (i<100) outc ('0');
		outs (buf);
		}
	outs ("\n;KSET ");
	for (i=0;i<max_fonts;++i)
		{outs (font_name (i));
		if (i != max_fonts-1) outc (',');
		}
	outc ('\n'); outs ("R "); outs (version);
	outs (" (" ); outs (ac_string (date_ac)); outs (") ");
	outs (ofname); outs ("\n\014");
	}

/**********************************************************************

	XGP_CHAR - Output actual text character.

**********************************************************************/

xgp_char (c)

	{extern int tul, tfont, tvoff;

	if (!printing) return;
	if (tfont != ofont)
		{outi (0177);
		outi (1);
		outi (tfont);
		ofont = tfont;
		ovoff = -min_voff;	/* font select resets voff */
		}
	if (tul != oul) xgpul (oul = tul);
	if (tvoff != ovoff)
		{int old_xgp_voff, xgp_voff;
		old_xgp_voff = ovoff + min_voff;
		xgp_voff = tvoff + min_voff;
		if (xgp_voff > 63 || xgp_voff < -64)
			{int diff;
			diff = xgp_voff - old_xgp_voff;
			if (diff > 0)
				{while (diff >= 63)
					{outi (0177); outi (1); outi (052); outi (63);
					diff =- 63;
					}
				if (diff > 0)
				    {outi (0177); outi (1); outi (052); outi (diff);}
				}
			else
				{while (diff <= -64)
					{outi (0177); outi (1); outi (052); outi (-64);
					diff =+ 64;
					}
				if (diff < 0)
				    {outi (0177); outi (1); outi (052); outi (diff);}
				}
			}
		else
			{outi (0177); outi (1); outi (043); outi (xgp_voff);}
		ovoff = tvoff;
		}
	if (c>015 && c<0177 || c>0 && c<010 || c==013) /* normal */
		{outi (c);
		return;
		}
	outi (0177);
	outi (c);
	return;
	}

/**********************************************************************

	XGP_EOW - Output whatever necessary at end of word.

**********************************************************************/

xgp_eow ()

	{if (oul && printing) xgpul (oul = FALSE);
	}

/**********************************************************************

	XGP_VP - Output whatever is necessary to set up the
		vertical position of the next line at vertical
		position POS, having a height above the base
		line of HA and a height below the baseline of HB.

**********************************************************************/

xgp_vp (pos, ha, hb)

	{int i;

	if (printing)
		{if (!header_out) xgp_rheader ();
		i = pos-ha+1;	/* top of line */
		if (i <= olvpu) error ("output lines overlap");
		else
			{outi (0177);
			outi (3);
			outi (i>>7);
			outi (i&0177);
			}
		}
	}

/**********************************************************************

	XGP_SPACE - Output a space of given width or tab to
		the given horizontal position.

**********************************************************************/

xgp_space (width, pos)

	{if (width==0 || !printing) return;
	if (width >= -64 && width<64)
		{outi (0177);
		outi (2);
		outi (width & 0177);
		}
	else
		{outi (0177);
		outi (1);
		outi (040);
		outi (pos>>7);
		outi (pos&0177);
		}
	}

/**********************************************************************

	XGP_EOL - Output whatever is necessary to terminate
		the current line, which is at vertical position POS
		and has height above baseline HA and height below
		baseline HB.

**********************************************************************/

xgp_eol (pos, ha, hb)

	{if (printing)
		{outc ('\n');
		ovoff = -min_voff;
		olvpu = pos+hb;
		}
	}

/**********************************************************************

	XGP_EOP - Output whatever is necessary to terminate
		the current page.

**********************************************************************/

xgp_eop ()

	{if (printing && olvpu > 0)
		{if (!header_out) xgp_rheader ();
		outc ('\014');
		++Znpage;
		olvpu = 0;
		}
	}

/**********************************************************************

	XGP_EOF - Output whatever is necessary to terminate
		the output file.

**********************************************************************/

xgp_eof ()

	{if (printing && !header_out) xgp_rheader ();
	}

/**********************************************************************

	XGPUL - Output XGP Underline code

**********************************************************************/

xgpul (ul)

	{outi (0177);
	outi (1);
	if (ul) {outi (046);}
	else
		{outi (051);
		if (ulthick < 1) outi (1);
		    else if (ulthick > 127) outi (127);
		    else outi (ulthick);
		if (ulpos < -63) outi (63);
		    else if (ulpos > 64) outi (-64);
		    else outi (-ulpos);
		}
	}

# endif /* HAVE_XGP */
