# include <c.defs>

/**********************************************************************

	TOPS-20 Display Terminal Hacking

  isdisplay () => bool		return true if terminal is known display
  dpytype () => int		return terminal type code
  utyi () => c			read character without echoing
  tyo (c)			output character (buffered)
  utyo (c)			output character (unbuffered)
  tyos (s)			output string by repeated tyo (c)
  tyo_flush ()			flush output buffer
  spctty (c)			perform display function:
				C: clear screen
				T: move cursor to top of screen
				L: erase to end-of-line
				E: erase to end-of-screen
				D: move cursor down
				K: erase next character (avoid overprinting)
				B: backspace
  dpymove (ln, cn)		Move cursor to given LineNumber and
				ColumnNumber (<0,0> is top)
  dpyreset ()			Restore original terminal mode.
  dpyinit ()			Forces later re-initialization by resetting
				flags

  Note: use of any display routine changes the terminal mode to allow
  escape sequences to be output and turns page mode off.  Dpyreset should
  be called to reset the terminal to its original state before
  termination.

  Output is normally buffered.  The output buffer is flushed implicitly by
  UTYI, UTYO, and DPYRESET, and is flushed explicitly by TYO_FLUSH.
  UTYI does image input, but you must turn page mode on/off yourself if
  you care about it.

**********************************************************************/

# ifdef TOPS20
#   define IMLAC 4		/* not a standard code */
#   define DATAMEDIA 100	/* non-existent */
#   define HP264X 6		/* standard ? */
#   define VT52 15
#   define VT100 18		/* currently implemented as a VT52 */
#   define HEATH 20		/* currently implemented as a VT52 */
#   define HP262X 21		/* non-standard: implemented as HP264X */
# endif

# ifdef TENEX
#   define IMLAC 10		/* not a standard code */
#   define DATAMEDIA 11		/* At SUMEX-AIM */
#   define HEATH 18		/* currently implemented as a VT52 */
#   define HP264X 101		/* these are not defined ... */
#   define VT52 102
#   define VT100 103
#   define HP262X 104
# endif

static int ttype;	/* terminal type */
static int dflag;	/* is-display flag */
static int iflag;	/* own variable initialization flag */
static int cflag;	/* mode flag: TRUE => control-chars mode */
static int omode;	/* original terminal mode */

# define TYOSIZ 1000
static char tyobuf[TYOSIZ], *ctyop {tyobuf};

# define PRIIN 0100
# define PRIOU 0101

dpysetup ()

	{/* NOTE: This is called ONLY by C20IO, to make sure things are
		cool in a dumped and restarted program, etc. */
	cflag = FALSE;
	iflag = FALSE;
	}

int isdisplay ()

	{if (iflag) return (dflag);
	/* own variable initialization */
	iflag = TRUE;
	ttype = SYSGYP (PRIOU);
	dflag = (ttype == HP264X || ttype == VT52 || ttype == HP262X ||
		 ttype == IMLAC || ttype == VT100 || ttype == HEATH ||
		 ttype == DATAMEDIA);
	if (!dflag) return (FALSE);
	if (ttype == HEATH)
		{dpyon ();
		tyos ("\033<\033[?2h");
		dpyreset ();
		/* put into Heath (VT52 compatible) mode */
		ttype = VT52;
		}
	else if (ttype == HP262X) ttype = HP264X;
	else if (ttype == VT100)
		/* VT100 now implemented only as a VT52 */
		{dpyon ();
		tyos ("\033<\033[?2l");
		dpyreset ();
		/* put it in VT52 mode */
		ttype = VT52; /* pretend it's a VT52 */
		}
# if 0
	if (ttype == VT100)
		/* (someday) make sure its in ANSI mode */
		{dpyon ();
		tyos ("\033<");
		dpyreset ();
		}
# endif
	return (TRUE);
	}

int dpytype ()

	{if (!iflag) isdisplay ();
	return (ttype);
	}

dpyinit ()

	{if (iflag)
		{dpyreset ();
		iflag = FALSE;
		}
	}

dpyreset ()

	{if (!iflag) isdisplay ();
	tyo_flush ();
	if (cflag)
		{/* restore mode */
		SYSDOBE (PRIOU);
		_SFMOD (PRIOU, omode);
		_STPAR (PRIOU, omode);
		cflag = FALSE;
		}
	}

dpyon ()

	{if (!iflag) isdisplay ();
	tyo_flush ();
	if (!cflag)
		/* binary mode (no translation), but leave page mode alone */
		{int nmode;
		omode = _RFMOD (PRIOU);
		nmode = omode & ~04300;		/* no echo, binary */
		SYSDOBE (PRIOU);
		_SFMOD (PRIOU, nmode);
		cflag = TRUE;
		}
	}

int dpymove (ln, cn)

	{char buf[10];
	if (!iflag) isdisplay ();
	if (!cflag) dpyon ();
	switch (ttype) {
	case IMLAC:
		tyos ("\177\021"); tyo (++ln); tyo (++cn);
		return;
	case HP264X:
		tyos ("\033&a");
		itoa (ln, buf); tyos (buf); tyo ('r');
		itoa (cn, buf); tyos (buf); tyo ('C');
		return;
	case VT100:
		tyos ("\033[");
		if (ln > 0) {itoa (++ln, buf); tyos (buf);}
		tyo (';');
		if (cn > 0) {itoa (++cn, buf); tyos (buf);}
		tyo ('H');
		return;
	case VT52:
		tyos ("\033Y"); tyo (ln + 32); tyo (cn + 32);
		return;
	case DATAMEDIA:	/* do ^L col XOR 0140,  row XOR 0140 */
		tyo ('\014'); tyo (cn ^ 0140); tyo (ln ^ 0140); 
		return;
		}
	}

spctty (c)

	{if (!iflag) isdisplay ();
	if (!cflag) dpyon ();
	switch (ttype) {
	case IMLAC:
		tyo (0177);
		switch (c) {
		case 'B':	tyo (0211-0176); return;
		case 'C':	tyo (0220-0176); return;
		case 'D':	tyo (0212-0176); return;
		case 'E':	tyo (0202-0176); return;
		case 'K':	tyo (0204-0176); return;
		case 'L':	tyo (0203-0176); return;
		case 'T':	tyo (0217-0176);
				tyo (0+1);	/* vertical */
				tyo (0+1);	/* horizontal */
				return;
			}
		return;
	case VT100:
		switch (c) {
		case 'B':	tyos ("\033[D"); return;
		case 'C':	tyos ("\033[H\033[J"); return;
		case 'D':	tyos ("\033[B"); return;
		case 'E':	tyos ("\033[J"); return;
		case 'K':	return;
		case 'L':	tyos ("\033[K"); return;
		case 'T':	tyos ("\033[H"); return;
			}
		return;
	case HP264X:
	case VT52:
		switch (c) {
		case 'B':	tyos ("\033D"); return;
		case 'C':	tyos ("\033H\033J"); return;
		case 'D':	tyos ("\033B"); return;
		case 'E':	tyos ("\033J"); return;
		case 'K':	return;
		case 'L':	tyos ("\033K"); return;
		case 'T':	tyos ("\033H"); return;
			}
		return;
	case DATAMEDIA:
		switch (c) {
		case 'B':	tyo ('\010'); return;
		case 'C':	tyos ("\002\037"); return;
		case 'D':	tyo ('\012'); return;
		case 'E':	tyo ('\037'); return;
		case 'K':	tyo ('\034'); return;
		case 'L':	tyo ('\027'); return;
		case 'T':	tyo ('\002'); return;
			}
		return;
		}
	tyos ("\r\n");
	}

tyo (c)
	{*ctyop++ = c;
	if (ctyop >= tyobuf + (TYOSIZ-2)) tyo_flush ();
	}

tyos (s)
	register char *s;

	{register int c;
	while (c = *s++) tyo (c);
	}

utyo (c)
	{tyo_flush ();
	SYSBOUT (PRIOU, c);
	}
			
int utyi ()
	{register char c;
	if (!iflag) isdisplay ();
	if (!cflag) dpyon ();
	tyo_flush ();
	c = SYSBIN (PRIIN);
	return (c & 0177);
	}

tyo_flush ()
	{if (ctyop > tyobuf)
		{_SOUT (PRIOU, mkbptr (tyobuf), tyobuf - ctyop, 0);
		ctyop = tyobuf;
		}
	}
