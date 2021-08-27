# include "r.h"

/*

	R Text Formatter
	TOPS-20 Version System-Dependent Code

	Copyright (c) 1977, 1978 by Alan Snyder

*/

/*	system-dependent values	*/

# define trace1_ext "rta"		/* lo-level trace file */
# define trace2_ext "rtb"		/* hi-level trace file */

struct _cal {int year, month, day, hour, minute, second;};
# define cal struct _cal

/**********************************************************************

	Default output routines

**********************************************************************/

# ifdef USE_PORTABLE_OUTPUT

extern int fout;
outc(c) {cputc ((c), fout);}		/* output ascii char */
outi(c) {cputc ((c) | 0400, fout);}	/* output image char */
outs(str) {cprint (fout, "%s", (str));}	/* output string */
ocls() {cclose (fout);}			/* close output */
oopn(fname) {return (copen (fname, 'w'));}	/* open output */

# endif

/**********************************************************************

	OPENINPUT - Open Input File

**********************************************************************/

int openinput ()

	{extern char ofname[], ifname[], *fname;
	int f;

	f = copen (fname, 'r');
	if (f == OPENLOSS)
		{fnsdf (ifname, fname, 0, 0, "OUTPUT", "R", 0, 0);
		f = copen (ifname, 'r');
		}
	if (f == OPENLOSS) return (f);
	SYSJFNS (mkbptr (ifname), cjfn (f), 0211110000001);
	fnsfd (ofname, ifname, "", 0, 0, "", "", "");
	fnsdf (ofname, ofname, 0, 0, "OUTPUT", 0, 0, 0);
	return (f);
	}

/**********************************************************************

	OPENOUTPUT - Open output file.

**********************************************************************/

int openoutput ()

	{extern char ofname[];
	extern int device;
	char *suffix;
	int f;

	switch (device) {
		case d_lpt:	suffix = "LPT"; break;
		case d_xgp:	suffix = "XGP"; break;
		default:	suffix = "LOS";
		}
	fnsfd (ofname, ofname, 0, 0, 0, suffix, 0, 0);
	f = oopn (ofname);
	if (f == OPENLOSS) f = oopn ("r.out");
	if (f == OPENLOSS) fatal ("can't open output file");
	return (f);
	}

/**********************************************************************

	OPENREAD - Open "Included" File

**********************************************************************/

int openread (name, realname) char *name, *realname;

	{int fd;

	fd = copen (name, 'r');
	if (fd == OPENLOSS)
		{char buffer[FNSIZE];
		fnsdf (buffer, name, 0, "R", 0, 0, 0, 0);
		fd = copen (buffer, 'r');
		}
	if (fd != OPENLOSS)
		SYSJFNS (mkbptr (realname), cjfn (fd), 0211110000001);
	return (fd);
	}

/**********************************************************************

	OPENWRITE - Open auxiliary output file.

**********************************************************************/

int openwrite (suffix) char *suffix;

	{extern char ofname[];
	char buffer[FNSIZE];

	fnsfd (buffer, ofname, 0, 0, 0, suffix, 0, 0);
	return (copen (buffer, 'w'));
	}

/**********************************************************************

	OPENAPPEND - Open auxiliary output file.

**********************************************************************/

int openappend (suffix) char *suffix;

	{extern char ofname[];
	char buffer[FNSIZE];

	fnsfd (buffer, ofname, 0, 0, 0, suffix, 0, 0);
	return (copen (buffer, 'a'));
	}

/**********************************************************************

	OPENSTAT - Open Statistics File

**********************************************************************/

int openstat ()

	{int f;

	f = copen ("<r>r.stat", 'a');
	if (f==OPENLOSS) f = copen ("<mdl>r.stat", 'a');
	if (f==OPENLOSS) f = copen ("r.stat", 'a');
	return (f);
	}

/**********************************************************************

	INTERACTIVE - Are we interactive?

**********************************************************************/

int interactive ()

	{extern int cout;
	return (istty (cout));
	}

/**********************************************************************

	OPENTRACE - Open trace files.

**********************************************************************/

opentrace ()

	{extern char ofname[];
	extern int etrace, e2trace;
	char trace1_name[FNSIZE], trace2_name[FNSIZE];

	fnsfd (trace1_name, ofname, 0, 0, 0, trace1_ext, 0, 0);
	fnsfd (trace2_name, ofname, 0, 0, 0, trace2_ext, 0, 0);
	etrace = copen (trace1_name, 'w');
	e2trace = copen (trace2_name, 'w');
	}

/**********************************************************************

	USERNAME - Return User Name

**********************************************************************/

char *username ()

	{static char buffer[30];
	int un, p;

	p = &un;
	p =| 0777777000000;
	SYSGJI (-1, p, 2);	/* GETJI - read user number */
	SYSDIRST (mkbptr (buffer), un);
	return (buffer);
	}

/**********************************************************************

	GETFDATES - Get File Date and Time from Stream

	Note: the format of dates and times is part of the definition
		of R.

**********************************************************************/

getfdates (f)

	{extern ac fdate_ac, ftime_ac;
	extern char *months[];
	int q;

	SYSRTAD (cjfn (f), &q, 1);
	if (q == -1)
		{ftime_ac = ac_create ("?");
		fdate_ac = ac_create ("?");
		}
	else
		{char buffer[FNSIZE];
		cal timex;
		int i;
		t2cal (q, &timex);
		i = copen (buffer, 'w', "s");
		prcal (&timex, i);
		cclose (i);
		ftime_ac = ac_create (buffer+12);
		i = copen (buffer, 'w', "s");
		cprint (i, "%d %s %d", timex.day, months[timex.month-1], timex.year);
		cclose (i);
		fdate_ac = ac_create (buffer);
		}
	}

/**********************************************************************

	GETDATES - Get Current Date and Time

	Note: the format of dates and times is part of the definition
		of R.

**********************************************************************/

getdates ()

	{extern ac date_ac, time_ac, sdate_ac;
	extern char *months[];
	extern int rmonth, rday, ryear;
	cal timex;
	int i;
	char buffer[FNSIZE];

	i = SYSGAD ();
	t2cal (i, &timex);
	rmonth = timex.month;
	rday = timex.day;
	ryear = timex.year;
	i = copen (buffer, 'w', "s");
	prcal (&timex, i);
	cclose (i);
	buffer[11] = 0;
	sdate_ac = ac_create (buffer);
	time_ac = ac_create (buffer+12);
	i = copen (buffer, 'w', "s");
	cprint (i, "%d %s %d", timex.day, months[timex.month-1], timex.year);
	cclose (i);
	date_ac = ac_create (buffer);
	}

/**********************************************************************

	SETHANDLER - Setup Interrupt Handler

**********************************************************************/

sethandler ()

	{/* extern int ghandler();

	on (ctrlg_interrupt, ghandler) */;		/* ^G */
	}

/**********************************************************************

	RDFONT - Read font file

**********************************************************************/

fontdes *rdfont (f) fontdes *f;

	{int fd, i, h, bl;
	char buffer[FNSIZE];

	/* NEED ITS SYNTAX FOR OUTPUT FILE! */

	fnsdf (buffer, f->fname, 0, 0, "25VG", "KST", 0, 0);
	fd = copen (f->fname, 'r', "b");
	if (fd == OPENLOSS)
		{fnsdf (buffer, buffer, 0, "FONTS", 0, 0, 0, 0);
		fd = copen (buffer, 'r', "b");
		if (fd == OPENLOSS)
			{fnsdf (buffer, buffer, 0, "FONTS1", 0, 0, 0, 0);
			fd = copen (buffer, 'r', "b");
			if (fd == OPENLOSS)
				{error ("unable to open font file: %s", f->fname);
				return (0);
				}
			}
		}
	for (i=0;i<0200;++i) f->fwidths[i] = 0;
	cgeti (fd);	/* KSTID */
	i = cgeti (fd);
	h = i & 0777777;
	bl = (i >> 18) & 0777;
	f->fha = bl + 1;
	f->fhb = h - bl - 1;
	cgeti (fd);	/* first USER ID */
	do
		{i = cgeti (fd) & 0777777;	/* char code */
		if (i >= 0200)
			{error ("font file bad format: %s", f->fname);
			cclose (fd);
			return (0);
			}
		f->fwidths[i] = cgeti (fd) & 0777777;
		while (((i = cgeti (fd)) & 1) == 0)  /* skip matrix */
			if (ceof (fd))
				{error ("font file bad format: %s",
						f->fname);
				return (0);
				}
		} while (i != -1);
	cclose (fd);
	return (f);
	}
