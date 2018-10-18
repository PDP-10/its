/*

DATE - Date Hacking Routines

These routines recognize three representations for dates:

(1)	CAL -	calender date, a system-independent representation
		consisting of a record containing six integers
		for the year, month, day, hour, minute, and second

(2)	FDATE - the ITS date representation used in file directories

(3)	UDATE -	the UNIX date representation, seconds since
		Jan 1, 1970, GMT.

(4)	TDATE - the TOPS-20 date representation

The routines:

	u2cal (udate, cd)	- convert udate to cal
	udate = cal2u (cd)	- convert cal to udate
	f2cal (fdate, cd)	- convert fdate to cal
	fdate = cal2f (cd)	- convert cal to fdate
	t2cal (tdate, cd)
	tdate = cal2t (cd)
	prcal (cd, fd)		- print cal (CIO)


*/

# define ZONE 5		/* offset of local zone from GMT */
struct _cal {int year, month, day, hour, minute, second;};
# define cal struct _cal

static	int	month_tab1[] {0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334};
static	int	month_tab2[] {0, 31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335};
static	int	year_tab[] {0, 365, 2*365, 3*365+1};

# define four_years (4*365+1)

static	char	*month_name[] {
		"Jan", "Feb", "Mar", "Apr", "May", "Jun",
		"Jul", "Aug", "Sep", "Oct", "Nov", "Dec"};

# rename srctab "SRCTAB"

u2cal (udate, cd)	cal *cd;

	{udate =- (ZONE*60*60);
	cd->second = udate%60; udate =/ 60;
	cd->minute = udate%60; udate =/ 60;
	cd->hour = udate%24; udate =/ 24;
	cd->year = 1970 + 4*(udate/four_years);
	udate =% four_years;
	cd->year =+ srctab (year_tab, 4, &udate);
	cd->month = srctab (cd->year%4==0 ? month_tab2 : month_tab1,
		12, &udate) + 1;
	cd->day = udate + 1;
	}

int cal2u (cd)	cal *cd;

	{int udate, year;

	year = cd->year;
	udate = cd->second + 60*(cd->minute + 60*(cd->hour + 24*(cd->day-1)));
	udate =+ (year%4==0 ? month_tab2 : month_tab1) [cd->month-1] * 60*60*24;
	year =- 1970;
	if (year<0) year=0;
	udate =+ 60*60*24*(four_years*(year/4) + year_tab[year%4]);
	udate =+ (ZONE*60*60);
	return (udate);
	}

f2cal (fdate, cd)	cal *cd;

	{cd->year = 1900 + ((fdate>>27) & 0177);
	if ((cd->month = (fdate>>23) & 017) > 12) cd->month = 0;
	cd->day = (fdate>>18) & 037;
	fdate = (fdate & 0777777) >> 1;
	cd->second = fdate % 60;
	fdate =/ 60;
	cd->minute = fdate % 60;
	cd->hour = fdate / 60;
	}

int cal2f (cd)	cal *cd;

	{int fdate;

	fdate = 2*(cd->second + 60*(cd->minute + 60*cd->hour));
	fdate =| cd->day << 18;
	fdate =| cd->month << 23;
	fdate =| (cd->year - 1900) << 27;
	return (fdate);
	}

t2cal (tdate, cd)	cal *cd;

	{int vec[3], udate;
	SYSODCNV (tdate, 0, vec);
	cd->year = vec[0] >> 18;
	cd->month = (vec[0] & 0777777) + 1;
	cd->day = (vec[1] >> 18) + 1;
	udate = vec[2] & 0777777;
	cd->second = udate%60; udate =/ 60;
	cd->minute = udate%60; udate =/ 60;
	cd->hour = udate%24;
	}

int cal2t (cd) cal *cd;

	{char buf[100];
	int f;
	f = copen (buf, 'w', "s");
	cprint (f, "%d/%d/%d %d:%d:%d", cd->month, cd->day, cd->year,
		cd->hour, cd->minute, cd->second);
	cclose (f);
	return (SYSIDTIM (mkbptr (buf), 0));
	}

prcal (cd, f)	cal *cd;

	{char *s;
	int m;
	m = cd->month-1;
	if (m>=0 && m<=11) s = month_name[m];
	else s = "?";
	cprint (f, "%s%3d%5d ", s, cd->day, cd->year);
	cputc (cd->hour/10+'0', f);
	cputc (cd->hour%10+'0', f);
	cputc (':', f);
	cputc (cd->minute/10+'0', f);
	cputc (cd->minute%10+'0', f);
	cputc (':', f);
	cputc (cd->second/10+'0', f);
	cputc (cd->second%10+'0', f);
	}

int srctab (tab, sz, n)		int *tab, sz, *n;

	{int *p, i;

	p = tab+sz;
	i = *n;

	while (--p>=tab)
		{if (*p <= i)
			{*n = i - *p;
			return (p-tab);
			}
		}
	return (0);
	}
