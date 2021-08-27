# include "c/c.defs"

# define JCLSIZE 200
# define INPUTSIZE 2000

extern int cout, cerr;
int fd, ifd, scripting, jj, filein, ich, sch;

main (argc, argv)
	int argc;
	char *argv[];

	{char *pname, *jcl, jclbuf[JCLSIZE], inbuf[INPUTSIZE], buf[30];
	int n;

	argc = options (argc, argv);
	n = get_buf (jclbuf, JCLSIZE, 033, "Command: ");
	if (n>0) --n;
	jclbuf[n] = 0;
	if (n==0) return;

	n = get_buf (inbuf, INPUTSIZE, 033, "Input: ");
	if (n>0) --n;
	inbuf[n] = 0;
	if (n>0)
		{filein = TRUE;
		ifd = copen (inbuf, 'r', "s");
		}
	else while (TRUE)
		{n = get_buf (inbuf, INPUTSIZE, 033, "Input file name: ");
		if (n>0) --n;
		inbuf[n] = 0;
		if (n==0)
			{cprint ("No input.\n");
			break;
			}
		if (n>0)
			{ifd = copen (inbuf, 'r');
			if (ifd != OPENLOSS)
				{filein = TRUE;
				break;
				}
			}
		}

	jcl = pname = jclbuf;
	while (*jcl != ' ' && *jcl) ++jcl;
	if (*jcl == ' ')
		{*jcl = 0;
		while (*++jcl == ' ');
		}

	gtprog (pname, buf);
	fd = copen ("junk", 'w');
	if (fd == OPENLOSS)
		{cprint (cerr, "Unable to open output file\n");
		cexit (1);
		}
	if (!scripting) valret (":PROCEED\r");
	execs (buf, jcl);
	close (fd);
	}

options (argc, argv)
	char *argv[];

	{char *s, **ss;

	scripting = FALSE;
	--argc;
	ss = ++argv;
	while (--argc >= 0)
		{s = *argv++;
		if (s[0] == '-')
			scripting = TRUE;
		else *ss++ = s;
		}
	return (ss - argv);
	}

gtprog (pname, buf)
	char *pname, *buf;

	{filespec f;
	int ch;

	fparse (pname, &f);
	if (f.dev==0) f.dev = csto6 ("DSK");
	if (f.dir==0) f.dir = rsname ();
	if (f.fn2==0)
		{f.fn2 = f.fn1;
		f.fn1 = csto6 ("TS");
		}
	if ((ch = open (&f, 0)) < 0)
		{f.dir = csto6 ("SYS1");
		if ((ch = open (&f, 0)) < 0)
			{f.dir = csto6 ("SYS");
			if ((ch = open (&f, 0)) < 0)
				{cprint (cerr, "Can't find %s\n", pname);
				cexit (1);
				}
			}
		}
	close (ch);
	prfile (&f, buf);
	}

foo1 (s)	/* feed input to job */

	{int c;
	foo2 (sch);	/* first collect any output */
	j_stop (jj);
	while (TRUE)
		{if (ifd == OPENLOSS) c = utyi ();
		else c = cgetc (ifd);
		if (c <= 0)
			{if (ifd != OPENLOSS) cclose (ifd);
			ifd = OPENLOSS;
			continue;
			}
		if (c == '\n') c = '\r';
		uoiot (s, c);
		break;
		}
	j_start (jj);
	}

foo2 (s)	/* eat output from job */

	{j_stop (jj);
	if (scripting) j_take_tty (jj);
	while (TRUE)
		{int c;
		c = uiiot (s);
		if (c<0) break;
		cputc (c, fd);
		if (scripting) utyo (c);
		}
	if (scripting) j_give_tty (jj);
	j_start (jj);
	}

/*

	TRNSTY - Translate a job's TTY to connect to an STY.

	Args:	STYCHN - the STY channel
		JOB    - ITS job spec for the job
		FLAGS  - direction bits
				bit 0 => input
				bit 1 => output


*/

trnsty (stychn, job, flags)

	{int ttychn;
	filespec f, g;

	ttychn = rsuset (0100+stychn);	/* the corresponding TTY chan */
	ttychn =>> 18;
	g.dev = csto6("T00") +
		((((ttychn>>3)<<6) | (ttychn&7))<<18);
	f.dev = csto6("TTY");
	g.dir = f.dir = g.fn1 = f.fn1 = g.fn2 = f.fn2 = 0;
	return (tranad (job, &f, &g, 0200000 | (flags&3)));
	}

/*

	EXECS - Execute a Program With A Given
		Command String

	Returns:

		-5	Job valretted something and was
			not continued.
		-4	Internal fatal error.
		-3	Unable to load program file.
		-2	Unable to create job.
		-1	Unable to open program file.
		0	Job terminated normally.
		other	Job terminated abnormally with said PIRQ

	Sets:

		exctime - job's CPU time in 1/60 sec. units
		exccode - contents of job's loc 1 at termination

*/

int exctime 0;
int exccode 0;

execs (pname, args)	char *pname, *args;

	{int i, j, block[5];
	char *s, buf[40];
	filespec f;

	j = jj = j_fload (pname);
	if (j<0) return (j);

	sch = fopen ("STY:", 010);
	if (filein) ich = fopen ("STY:", 001);
	trnsty (sch, j_ch (j), filein ? 3 : 2);
	on (channel0_interrupt+sch, foo2);
	if (filein) on (channel0_interrupt+ich, foo1);
	block[0] = -1;
	block[1] = 88;
	block[2] = 0;
	block[3] = 0;
	block[4] = 0011000001000;
	cnsset (sch, block);

	j_sjcl (j, args);
	j_give_tty (j);
	j_start (j);

	while (TRUE)
		{if ((i = j_sts (j)) == 0)
			{foo2 (sch);
			sleep (10);
			continue;
			}
		/* i = j_wait (j); */
		j_take_tty (j);
		switch (i) {

	case -1:	return (-4);
	case -2:	i = 0;
			break;
	case -3:	s = j_valret (j);
			if (s) cprint ("Job valrets: %s\n", s);
			else puts ("Job .VALUE 0");
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
			sleep (15);		/* wait for system to stop me */
			j_give_tty (j);
			j_start (j);
			continue;
	default:	break;
			}
		break;
		}

	close (sch);
	if (filein) close (ich);
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
