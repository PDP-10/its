# include "r.h"

/*

	R Text Formatter
	General Device Information

	Copyright (c) 1976, 1977 by Alan Snyder


	ROUTINES:

	dev_init ()		initialize device routines
	rc = devoption (c)	process possible device option character
	devsetup ()		setup selected device
	devheader ()		output header for device

	To install a new device:

		(1) write device handlers
		(2) add device #, compilation option to r.h
		(3) add device entries to rdev.c
		(4) add device number register to rreg.c
		(5) add device suffix to operating-system files

*/

/*	device table	*/

idn	dev_tab[ndev];
int	device;				/* the output device */

/*	device-dependent parameters	*/

int	superfactor {1};		/* divisor for ^U and ^D */

int	bad();
int	(*po_char)() {bad},
	(*po_eow)() {bad},
	(*po_vp)() {bad},
	(*po_space)() {bad},
	(*po_eol)() {bad},
	(*po_eop)() {bad},
	(*po_eof)() {bad};

int	lpt_char(), lpt_eow(), lpt_vp(), lpt_space(), lpt_eol(),
	lpt_eop(), lpt_eof();

# ifdef HAVE_XGP
int	xgp_char(), xgp_eow(), xgp_vp(), xgp_space(), xgp_eol(),
	xgp_eop(), xgp_eof();
# endif

# ifdef HAVE_VARIAN
int	vn_char(),  vn_eow(),  vn_vp(),  vn_space(),  vn_eol(),
	vn_eop(), vn_eof();
# endif

/**********************************************************************

	DEV_INIT

**********************************************************************/

dev_init ()

	{dev_tab[d_lpt] = make_idn ("lpt");
	dev_tab[d_xgp] = make_idn ("xgp");
	dev_tab[d_varian] = make_idn ("varian");
	device = d_lpt;
	lpt_init ();

# ifdef HAVE_VARIAN
	vn_init ();
# endif

# ifdef HAVE_XGP
	xgp_init ();
# endif
	}

/**********************************************************************

	DEVOPTION - Process possible device option character.
		Return TRUE if it is one.

**********************************************************************/

int devoption (c)
	int c;

	{extern int opt_dev;

	switch (c) {
	case 'l':	opt_dev = d_lpt; break;

# ifdef HAVE_XGP
	case 'x':	opt_dev = d_xgp; break;
# endif

# ifdef HAVE_VARIAN
	case 'v':	opt_dev = d_varian; break;
# endif

	default:	return (FALSE);
		}
	return (TRUE);
	}

/**********************************************************************

	DEVSETUP - Setup selected device

**********************************************************************/

devsetup ()

	{extern int device;
	switch (device) {

case d_lpt:	set_lpt ();
		po_char = lpt_char;
		po_eow = lpt_eow;
		po_vp = lpt_vp;
		po_space = lpt_space;
		po_eol = lpt_eol;
		po_eop = lpt_eop;
		po_eof = lpt_eof;
		return;

# ifdef HAVE_XGP
case d_xgp:	set_xgp ();
		po_char = xgp_char;
		po_eow = xgp_eow;
		po_vp = xgp_vp;
		po_space = xgp_space;
		po_eol = xgp_eol;
		po_eop = xgp_eop;
		po_eof = xgp_eof;
		return;
# endif

# ifdef HAVE_VARIAN
case d_varian:	set_vn ();
		po_char = vn_char;
		po_eow = vn_eow;
		po_vp = vn_vp;
		po_space = vn_space;
		po_eol = vn_eol;
		po_eop = vn_eop;
		po_eof = vn_eof;
		return;
# endif

default:	fatal ("output device unsupported");
		}
	}

/**********************************************************************

	DEVHEADER - Output device header

**********************************************************************/

devheader ()

	{extern int device;
	switch (device) {

case d_lpt:	lpt_header (); break;

# ifdef HAVE_XGP
case d_xgp:	xgp_header (); break;
# endif

# ifdef HAVE_VARIAN
case d_varian:	vn_header (); break;
# endif
		}
	}

/**********************************************************************

	BAD - routine to detect call before initialization

**********************************************************************/

bad ()

	{barf ("R: output routine called before initialization");
	}
