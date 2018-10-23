# include "clib/c.defs"

int exctime 0;
int exccode 0;

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

int execs (pname, args)	char *pname, *args;

	{int i, j, ich;
	char *s, buf[40];
	filespec f;

	j = j_fload (pname);
	if (j<0) return (j);

	j_sjcl (j, args);
	j_give_tty (j);
	j_start (j);

	while (TRUE)
		{i = j_wait (j);
		j_take_tty (j);
		switch (i) {

	case -1:	return (-4);
	case -2:	i = 0;
			break;
	case -3:	s = j_valret (j);
			if (s)
				{cprint ("Job valrets: ");
				puts (s);
				}
			else
				{puts ("Job .VALUE 0");
				}
			cprint ("continue? ");
			gets (buf);
			if (buf[0]=='y' || buf[0]=='Y')
				{j_give_tty (j);
				j_start (j);
				continue;
				}
			i = -5;
			break;
	case -5:	wsuset (014, 02);	/* simulate ^Z typed */
			sleep (15);
			j_give_tty (j);
			j_start (j);
			continue;
	default:	cprint ("Unhandled interrupt, continue?  ");
			gets (buf);
			if (buf[0]=='y' || buf[0]=='Y')
				{j_give_tty (j);
				j_start (j);
				continue;
				}
			break;
			}
		break;
		}

	exctime = ruset (j_ch(j), 024) / (16666000./4069.);
	exccode = 0;
	if (!j_name (j, &f) && (ich=open(&f,4))>=0)
		{uiiot (ich);
		exccode = uiiot (ich);
		close (ich);
		}
	j_kill (j);
	return (i);
	}

/**********************************************************************

	EXECV - Execute file given a vector of arguments

**********************************************************************/

int execv (prog, argc, argv)
	char *prog, *argv[];

	{char **ap, **ep, buff[300], *p, *s;
	int c;

	p = buff;
	ap = argv;
	ep = argv + argc - 1;

	while (ap <= ep)
		{s = *ap++;
		*p++ = '"';
		while (c = *s++) *p++ = c;
		*p++ = '"';
		*p++ = ' ';
		}

	*p++ = 0;
	return (execs (prog, buff));
	}
