# include <stdio.h>

/**********************************************************************

	EXEC20

**********************************************************************/

int exctime = 0;
int exccode = 0;

# define _NULIO 0377777
# define JCLSIZE 500
# define TRUE  1

/**********************************************************************

	EXECS - Execute a program with a given command string

	Returns:

		-5	Job valretted something and was not continued.
		-4	Internal fatal error.
		-3	Unable to load program file.
		-2	Unable to create job.
		-1	Unable to open program file.
		0	Job terminated normally.
		other	Job terminated abnormally with said PIRQ

	Sets:

		exctime - job's CPU time in 1/60 sec. units
		exccode - contents of job's loc 1 at termination

**********************************************************************/

int execs (pname, args)	
char *pname, *args;
{
	register int rph;	/* relative process handle */
	register int pjfn;	/* jfn for program file */
	register int rc;	/* return code */
	char jcl[JCLSIZE]; 	/* to construct JCL */

	fnstd (pname, jcl);
	pjfn = _GTJFN (halves (0100001, 0), mkbptr (jcl)); 
	if (pjfn >= 0600000) return (-1);

	rph = _CFORK (halves (0200000, 0), 0);
		/* create process, with my capabilities */
	if (rph >= 0600000) {
		_CLOSF (pjfn);
		return (-2);
	}

	rc = _GET (halves (rph, pjfn), 0);	/* load program file */
	_CLOSF (pjfn);				/* release program file */
	if (rc) {
		_KFORK (rph);
		return (-3);
	}
/*	_SPJFN (rph, _NULIO, _GPJFN (0400000) & 0777777);  */

	strcpy(jcl, pname);			/* construct JCL line */
	strcat(jcl, " ");
	strcat(jcl, args);
	_RSCAN (mkbptr (jcl));			/* set JCL */
	_SFRKV (rph, 0);			/* start job */

	while (TRUE) {
		register unsigned sts, code;
		_WFORK (rph);
		sts = _RFSTS (rph);
		code = (sts >> 18) & 07777;

		if (code == 2) break;
		if (code == 3) {
			register int number;
			number = sts & 0777777;
			if (number == 12) {
				int nwork, nused, nperm;
				int usern, dirn, jobn, termn;
				fprintf (stderr, "Disk quota exceeded.\n");
				_GJINF (&usern, &dirn, &jobn, &termn);
				_GTDAL (dirn, &nwork, &nused, &nperm);
				if (nused == nwork) {
					_DELDF (0, dirn);
					_GTDAL (dirn, &nwork, &nused, &nperm);
					if (nused < nwork) {
						fprintf (stderr,
							"%d pages expunged\n",
							nwork - nused);
						goto restart;
					}
				}
			}
			fprintf (stderr,
				"Process terminated, error number %d.\n",
				number);
			_KFORK (rph);
			return (number);
		}
		fprintf (stderr, "Process terminated, status %d.\n", code);
		if (code != 0) break;
	restart:
		_RFORK (rph); 		/* unfreeze it if it was frozen */
		_SFORK (rph, _RFPC (rph));	/* continue it */
	}

	{
		int junk;
		int acs[16];

		_RUNTM (rph, &exctime, &junk);
		exctime = exctime * 60 / 1000;
		_RFACS (rph, acs);
		exccode = acs[1];	
	}

	_KFORK (rph);
	return (0);
}

/**********************************************************************

	EXECV - Execute file given a vector of arguments

**********************************************************************/

int execv (prog, argc, argv)
char *prog, *argv[];
{
	register char **ap, **ep, *p, *s;
	char buff[JCLSIZE];
	register int c;

	p = buff;
	ap = argv;
	ep = argv + argc - 1;

	while (ap <= ep) {
		s = *ap++;
		*p++ = '"';
		while (c = *s++) *p++ = c;
		*p++ = '"';
		*p++ = ' ';
	}

	*p++ = 0;
	return (execs (prog, buff));
}
