# include <stdio.h>

/*

DATE - Date and Time Hacking Routines

These routines recognize three representations for dates:

(1)	CAL -	calender date, a system-independent representation
		consisting of a record containing six integers
		for the year, month, day, hour, minute, and second

(2)	UDATE -	the UNIX date representation, seconds since
		Jan 1, 1970, GMT.

(3)	TDATE - the TOPS-20 date representation


The routines:

	u2cal (udate, cd)	- convert udate to cal
	udate = cal2u (cd)	- convert cal to udate
	t2cal (tdate, cd)	- convert tdate to cal
	tdate = cal2t (cd)	- convert cal to tdate
	prcal (cd, fd)		- pretty-print cal block to a file
	pr60th (time, fd)	- pretty-print time (60th's sec) to file
	now (cp)		- fill *cp wih the current time and date
	rtime ()		- return runtime for this job in 60th/sec
	etime ()		- return logged-in time in 60th's
	cputime ()		- return runtime for this process in 60th's
	fcmdat (fp, cp)		- *cp gets the creation/modification date
				   of the file pointed to by fp
*/

# define ZONE 5		/* offset of local zone from GMT */

# define month_tab1 mtab1
# define month_tab2 mtab2

static int month_tab1[] = {0,31,59,90,120,151,181,212,243,273,304,334};
static int month_tab2[] = {0,31,60,91,121,152,182,213,244,274,305,335};
static int year_tab[] = {0,365,2*365,3*365+1};

# define four_years (4*365+1)

static char *month_name[] = {
		"Jan", "Feb", "Mar", "Apr", "May", "Jun",
		"Jul", "Aug", "Sep", "Oct", "Nov", "Dec"};

# define TRUE  1
# define FALSE 0

static int srctab (tab, sz, n)
int *tab, sz, *n;
{
	register int *p, i;

	p = tab + sz;
	i = *n;

	while (--p >= tab) {
		if (*p <= i) {
			*n = i - *p;
			return (p - tab);
		}
	}
	return (0);
}

u2cal (udate, cd)
register cal *cd;
int udate;
{
	udate -= (ZONE * 60 * 60);
	cd->second = udate % 60; udate /= 60;
	cd->minute = udate % 60; udate /= 60;
	cd->hour = udate % 24; udate /= 24;
	cd->year = 1970 + 4 * (udate / four_years);
	udate %= four_years;
	cd->year += srctab (year_tab, 4, &udate);
	cd->month = srctab (cd->year % 4 == 0 ? month_tab2 : month_tab1,
			    12, &udate) + 1;
	cd->day = udate + 1;
}

int cal2u (cd)
register cal *cd;
{
	register int udate, year;

	year = cd->year;
	udate = cd->second + 60 * (cd->minute + 60 *
					(cd->hour + 24 * (cd->day - 1)));
	udate += (year % 4 == 0 ? month_tab2 : month_tab1) [cd->month - 1]
			* 60 * 60 * 24;
	year -= 1970;
	if (year < 0) year = 0;
	udate += 60 * 60 * 24 * (four_years * (year / 4) + year_tab[year % 4]);
	udate += (ZONE * 60 * 60);
	return (udate);
}

t2cal (tdate, cd)
register cal *cd;
{
	unsigned vec[3];
	register int udate;
	_ODCNV (tdate, 0, vec);
	cd->year = vec[0] >> 18;
	cd->month = (vec[0] & 0777777) + 1;
	cd->day = (vec[1] >> 18) + 1;
	udate = vec[2] & 0777777;
	cd->second = udate % 60; udate /= 60;
	cd->minute = udate % 60; udate /= 60;
	cd->hour = udate % 24;
}

int cal2t (cd)
register cal *cd;
{
	char buf[100];
	FILE *f;

	f = fopen (buf, "ws");
	fprintf (f, "%d/%d/%d %d:%d:%d", cd->month, cd->day, cd->year,
		cd->hour, cd->minute, cd->second);
	fclose (f);
	return (_IDTIM (mkbptr (buf), 0));
}

prcal (cd, f)
register cal *cd;
FILE *f;
{
	register char *s;
	register int m;
	m = cd->month - 1;
	if (m >= 0 && m <= 11) s = month_name[m];
	else s = "?";
	fprintf (f, "%s%3d,%5d %02d:%02d:%02d", s, cd->day, cd->year,
		cd->hour, cd->minute, cd->second);
}

pr60th (time, file)
int time;
FILE *file;
{
	register int ss, sc, mn, hour, zs;

	if (time < 0) time = -time;
	zs = TRUE;
	ss = time % 60;
	time = time / 60;
	sc = time % 60;
	time = time / 60;
	mn = time % 60;
	hour = time / 60;
	if (hour) {
		fprint (file, "%3d:", hour);
		zs = FALSE;
	}
	else fprint (file, "    ");
	xput2 (mn, file, zs);
	if (zs && mn == 0) putc (' ', file);
	else	{
		putc (':', file);
		zs = FALSE;
	}
	if (zs && !sc) fprint (file, " 0");
	else	{
		xput2 (sc, file, zs);
		zs = FALSE;
	}
	putc ('.', file);
	xput2 (ss, file, FALSE);
	}

static xput2 (val, file, zs)
FILE *file;
{
	register int num;
	num = val / 10;
	if (num > 0 || !zs) {
		putc ('0' + num, file);
		zs = FALSE;
	}
	else	putc (' ', file);
	num = val % 10;
	if (num > 0 || !zs) putc ('0' + num, file);
	else	putc (' ', file);
}

now (cp)
cal *cp;
{
	t2cal (_GTAD (), cp);
}

int rtime ()
{
	int rt, ct;
	_RUNTM (-5, &rt, &ct);
	return (rt * 60 / 1000);
}

int etime ()
{
	int rt, ct;
	_RUNTM (-5, &rt, &ct);
	return (ct * 60 / 1000);
}

int cputime ()
{
	int rt, ct;
	_RUNTM (0400000, &rt, &ct);
	return (rt * 60 / 1000);
}

fcmdat (f, cp)
FILE *f;
cal *cp;
{
	int q;
	_RTAD (fileno(f), &q, 1);
	t2cal (q, cp);
}


