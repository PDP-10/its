# include "r.h"
# include "c/c.defs"
# include "c/its.bits"

/*

	R Text Formatter
	ITS Version System-Dependent Code

	Copyright (c) 1977 by Alan Snyder

*/

/*	system-dependent values	*/

# define trace1_ext "rta"		/* lo-level trace file */
# define trace2_ext "rtb"		/* hi-level trace file */

# ifdef USE_PORTABLE_OUTPUT
# define oopn(fname) copen (fname, 'w')		/* open output */
# endif

/**********************************************************************

	OPENINPUT - Open Input File

**********************************************************************/

int openinput ()

	{extern char ofname[], ifname[], *fname;
	int f;

	f = copen (fname, 'r');
	if (f==OPENLOSS) f = copen (apfname (ifname, fname, "r"), 'r');
	setfdir (ofname, fname, "DSK:"); /* set device & resolve defaults */
	if (f != OPENLOSS)
		{filespec fs;
		filnam (itschan (f), &fs);
		if (fs.dev == csto6("DSK")) fs.dev=0;
		prfile (&fs, ifname);
		}
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
		default:	suffix = "LOSER";
		}
	apfname (ofname, ofname+4, suffix); /* HACK !!! */
	f = oopn (ofname);
	if (f<0) f = oopn ("r.out");
	if (f<0) fatal ("can't open output file");
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
		setfdir (buffer, name, "DSK:R;");
		fd = copen (buffer, 'r');
		}
	if (fd != OPENLOSS)
		{filespec fs;
		filnam (itschan (fd), &fs);
		if (fs.dev == csto6("DSK")) fs.dev=0;
		prfile (&fs, realname);
		}
	return (fd);
	}

/**********************************************************************

	OPENWRITE - Open auxiliary output file.

**********************************************************************/

int openwrite (s) char *s;

	{char buffer[FNSIZE];
	fixfname (s, buffer);
	return (copen (buffer, 'w'));
	}

/**********************************************************************

	FIXFNAME - Fix auxiliary file name.  If a single name
		is given, it is used as a suffix to the output
		file name.

**********************************************************************/

fixfname (s, buffer)
	char *s, *buffer;

	{extern char ofname[];
	filespec fs;
	fparse (s, &fs);
	if (fs.dev==0 && fs.dir==0 & fs.fn2==0)
		{c6tos (fs.fn1, buffer);
		apfname (buffer, ofname, buffer);
		}
	else prfile (&fs, buffer);
	}

/**********************************************************************

	OPENAPPEND - Open auxiliary output file.

**********************************************************************/

int openappend (s) char *s;

	{char buffer[FNSIZE];
	fixfname (s, buffer);
	return (copen (buffer, 'a'));
	}

/**********************************************************************

	OPENSTAT - Open Statistics File

**********************************************************************/

int openstat ()

	{int f;

	f = copen ("/dsk/r/r.stat", 'a');
	if (f==OPENLOSS) f = copen ("/dsk/as/r.stat", 'a');
	if (f==OPENLOSS) f = copen ("/dsk/common/r.stat", 'a');
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

	apfname (trace1_name, ofname, trace1_ext);
	apfname (trace2_name, ofname, trace2_ext);
	etrace = copen (trace1_name, 'w');
	e2trace = copen (trace2_name, 'w');
	}

/**********************************************************************

	USERNAME - Return User Name

**********************************************************************/

# define UXUNAME 074

char *username ()

	{static char buffer[7];
	c6tos (rsuset (UXUNAME), buffer);
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

	q = rfdate (itschan (f));
	if (q<0)
		{ftime_ac = ac_create ("?");
		fdate_ac = ac_create ("?");
		}
	else
		{char buffer[FNSIZE];
		cal timex;
		int i;
		f2cal (q, &timex);
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

	now (&timex);
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

	{extern int ghandler();

	on (ctrlg_interrupt, ghandler);		/* ^G */
	}

/**********************************************************************

	RDFONT - Read font file

**********************************************************************/

fontdes *rdfont (f) fontdes *f;

	{int fd, i, h, bl;
	filespec fs;

	fparse (f->fname, &fs);
	if (fs.dev == 0) fs.dev = csto6 ("DSK");
	if (fs.fn2 == 0) fs.fn2 = csto6 ("KST");
	if (fs.fn1 == 0) fs.fn1 = csto6 ("25VG");
	if (fs.dir == 0)
		{fs.dir = rsname ();
		i = open (&fs, BII);
		if (i<0)
			{fs.dir = csto6 ("FONTS");
			i = open (&fs, BII);
			}
		if (i<0)
			{fs.dir = csto6 ("FONTS1");
			i = open (&fs, BII);
			}
		if (i<0) fs.dir=0;
		else close (i);
		}
	prfile (&fs, f->fname);
	fd = copen (f->fname, 'r', "b");
	if (fd<0)
		{error ("unable to open font file: %s", f->fname);
		return (0);
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

/**********************************************************************

	Until the real one shows up...

**********************************************************************/

int alocstat (p, q)
	int *p, *q;

	{return (-1);}
