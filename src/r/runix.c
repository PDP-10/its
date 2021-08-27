# include "r.h"

/*

	R Text Formatter
	DSSR UNIX Version System-Dependent Code

*/

/*	system-dependent values	*/

# define trace1_ext "rt1"		/* lo-level trace file */
# define trace2_ext "rt2"		/* hi-level trace file */

struct fonthdr { char name[6];
		 long kstid;
		 char xcpadj,base;
		 int height;
	       };

struct charhdr { char ascii,id[5];
		 int lkern,rwidth,cwidth,nbytes;
	       };

char directory[FNSIZE];
char *font_dir "/sys/fonts";

/**********************************************************************

	CPUTM - return cpu time

**********************************************************************/

cputm()

	{struct tbuffer { long user,system,childu,childs; } xxx;
	int i;

	times(&xxx);
	i = xxx.user;
	return(i);
	}
	
/**********************************************************************

	OPENINPUT - Open Input File

**********************************************************************/

int openinput ()

	{extern char *fname;
	char buffer[FNSIZE];
	int f;

	f = copen (fname, 'r');
	if (f==OPENLOSS) 
		{parsefn(directory,fname,"r",buffer,3);
		f = copen (buffer, 'r');
		}
	if (f != OPENLOSS)
		{parsefn(directory,fname,"r",buffer,0);
		stcpy(buffer,fname);
		}
	return (f);
	}

/**********************************************************************

	OPENOUTPUT - Open output file.

**********************************************************************/

int openoutput ()

	{extern char ofname[], *fname;
	extern int device, read_id, write_id;
	char *suffix;
	int f, fildes[2];

	switch (device) {
		case d_lpt:	suffix = "lpt"; break;
		case d_xgp:	suffix = "xgp"; break;

		case d_varian:	if ((f = pipe(fildes)) == -1)
					{fatal("can't open pipe to vsort");
					return(f);
					}
				read_id = fildes[0];
				write_id = fildes[1];
				parsefn(directory,fname,"vv",ofname,3);
				return(fildes[1]);

		default:	suffix = "loser";
		}
	parsefn(directory,fname,suffix,ofname,3);
	f = copen (ofname,'w');
	if (f == OPENLOSS) f = copen ("r.out",'w');
	if (f == OPENLOSS) fatal ("can't open output file");
	return (f);
	}

/**********************************************************************

	OPENREAD - Open "Included" File

**********************************************************************/

int openread (name, realname) char *name, *realname;

	{int f;
	char buffer[FNSIZE], scratch[FNSIZE];

	f = copen (name, 'r');
	stcpy (name, buffer);
	if (f == OPENLOSS)
		{stcpy (directory, scratch);
		parsefn (scratch,name,"r",buffer,3);
		f = copen (buffer, 'r');
		if (f == OPENLOSS)
			{stcpy("/usr/r",scratch);
			parsefn(scratch,name,"r",buffer,3);
			f = copen (buffer, 'r');
			}
		}
	stcpy (buffer, realname);
	return(f);
	}

/**********************************************************************

	OPENWRITE - Open auxiliary output file.

**********************************************************************/

int openwrite (suffix) char *suffix;

	{extern char ofname[];
	char buffer[FNSIZE];

	parsefn(directory,ofname,suffix,buffer,3);
	return (copen (buffer, 'w'));
	}

/**********************************************************************

	OPENAPPEND - Open auxiliary output file.

**********************************************************************/

int openappend (suffix) char *suffix;

	{extern char ofname[];
	char buffer[FNSIZE];

	parsefn(directory,ofname,suffix,buffer,3);
	return (copen (buffer, 'a'));
	}

/**********************************************************************

	OPENSTAT - Open Statistics File

**********************************************************************/

int openstat ()

	{return(copen ("/usr/r/r.stat", 'a'));}

/**********************************************************************

	INTERACTIVE - Are we interactive?

**********************************************************************/

int interactive ()

	{extern int cout;
	return (ttyn(cout)!='x');
	}

/**********************************************************************

	OPENTRACE - Open trace files.

**********************************************************************/

opentrace ()

	{extern char *fname;
	extern int etrace, e2trace;
	char trace1_name[FNSIZE], trace2_name[FNSIZE];

	parsefn(directory,fname,trace1_ext,trace1_name,3);
	parsefn(directory,fname,trace2_ext,trace2_name,3);
	etrace = copen (trace1_name, 'w');
	e2trace = copen (trace2_name, 'w');
	}

/**********************************************************************

	USERNAME - Return User Name

**********************************************************************/

char *username ()

	{static char buffer[FNSIZE];
	if (getpw(getuid(),buffer) == 0)
		{int i;
		i = 0;
		while (buffer[i]!='\0' & buffer[i]!=':') ++i;
		buffer[i] = '\0';
		}
	else buffer[0] = '\0';
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
	int timex[2], i;
	char buffer[FNSIZE], *timevec, *p;
	
	time(timex); timevec = ctime(timex);
	p = buffer;
	for (i=11;i<19;i++) *p++ = timevec[i];
	*p = '\0';
	ftime_ac = ac_create (buffer);
	p = buffer;
	*p++ = timevec[8]; *p++ = timevec[9];
	for (i=3;i<7;i++) *p++ = timevec[i];
	for (i=19;i<24;i++) *p++ = timevec[i];
	*p = '\0';
	fdate_ac = ac_create (buffer);
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
	int timex[2], *rtime;
	int i;
	char buffer[FNSIZE], *timevec, *p;
	
	time(timex); timevec = ctime(timex); rtime = localtime(timex);
	rmonth = rtime[4]+1; rday = rtime[3]; ryear = rtime[5]+1900;
	p = buffer;
	for (i=11;i<19;i++) *p++ = timevec[i];
	*p ='\0';
	time_ac = ac_create (buffer);
	p = buffer;
	*p++ = timevec[8]; *p++ = timevec[9];
	for (i=3;i<7;i++) *p++ = timevec[i];
	for (i=19;i<24;i++) *p++ = timevec[i];
	*p = '\0';
	date_ac = ac_create (buffer);
	sdate_ac = ac_create (buffer);
	}

/**********************************************************************

	SETHANDLER - Setup Interrupt Handler

**********************************************************************/

sethandler ()

	{extern int ghandler();

	signal(2,ghandler);		/* ^B */
	}

/**********************************************************************

	RDFONT - Read font file

**********************************************************************/

fontdes *rdfont (f) fontdes *f;

	{int fd,i;
	struct fonthdr fh;
	struct charhdr ch;
	char buffer[FNSIZE];

	parsefn(font_dir,f->fname,"vft",buffer,3);
	stcpy(buffer,f->fname);
	fd = open(buffer,0);
	if (fd<0)
		{error ("unable to open font file: %s", buffer);
		return (0);
		}
	for (i=0;i<0200;++i) f->fwidths[i] = 0;
	if (read(fd,&fh,sizeof fh) != sizeof fh)
		{error("font file bad format: %s", f->fname);
		 close(fd); return(0); }
	f->fha = fh.base + 1;
	f->fhb = fh.height - fh.base - 1;
	f->cpadj = fh.xcpadj;
	while (read(fd,&ch,sizeof ch))
		{if (ch.ascii >= 0200)
			{error ("font file bad format: %s", f->fname);
			close (fd);
			return (0);
			}
		f->fwidths[ch.ascii] = ch.cwidth;
		f->flkern[ch.ascii] = ch.lkern;
		seek(fd,ch.nbytes,1);
		};
	close (fd);
	return (f);
	}

/******************************************************************************

	Unix-specific routines as described in rextrn.desc

******************************************************************************/

slen(s)
 char *s;

	{ int n; for (n=0; *s++ != '\0'; n++); return(n); }

stcpy(s,d)
 char *s,*d;

	{ while (*d++ = *s++); }

stcmp(s,p)
 char *s,*p;

	{ while (*s != '\0') if (*s++ != *p++) return(0);
	  return (*s == *p); }

char *calloc(n)
 int n;

	{char *s;
	s = alloc(n);
	if (s==0) fatal ("storage overflow");
	return (s);
	}

int *salloc(n)
 int n;

	{return(calloc(2*n));}

sfree(p)
 int *p;

	{ free(p); }

cfree(p)
 char *p;

	{ free(p); }

int alocstat (p, q)
	int *p, *q;

	{return (-1);}

setprompt(s)
 char *s;

	{;}

stkdmp (fd)
	{;}

cisfd (fd)
	{return (fd<20);}

