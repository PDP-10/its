# include <c.defs>

/**********************************************************************

	PR60TH - Print time in 1/60 sec.

	Print time HH:MM:SS.XX on file FILE.
	TIME is in units of 1/60 sec.

**********************************************************************/

pr60th (time, file)

	{register int ss, sc, mn, hour, zs;

	if (time < 0) time = -time;
	zs = TRUE;
	ss = time % 60;
	time = time / 60;
	sc = time % 60;
	time = time / 60;
	mn = time % 60;
	hour = time / 60;
	if (hour)
		{cprint (file, "%3d:", hour);
		zs = FALSE;
		}
	else cprint (file, "    ");
	xput2 (mn, file, zs);
	if (zs && mn == 0) cputc (' ', file);
	else	{cputc (':', file);
		zs = FALSE;
		}
	if (zs && !sc) cprint (file, " 0");
	else	{xput2 (sc, file, zs);
		zs = FALSE;
		}
	cputc ('.', file);
	xput2 (ss, file, FALSE);
	}

xput2 (val, file, zs)

	{register int num;
	num = val / 10;
	if (num > 0 || !zs)
		{cputc ('0' + num, file);
		zs = FALSE;
		}
	else	cputc (' ', file);
	num = val % 10;
	if (num > 0 || !zs) cputc ('0' + num, file);
	else	cputc (' ', file);
	}
