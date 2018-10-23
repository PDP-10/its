# include "clib/c.defs"
# include "clib/its.bits"

/**********************************************************************

	JOBs - Inferior Process Management
	ITS Version

**********************************************************************/

/*

	The representation of a job is an integer with a value from
	0 to 7, indicating the inferior number.

	Routines:

	j_create (jname) => # or error code

	j_load (filespec) => # or error code
	j_fload (file_name) => # or error code
	j_cload (channel, jname) => # or error code
	j_own (uname, jname) => # or error code

		error code:

		-1	unable to open program file
		-2	unable to create job
		-3	unable to load job
		-4	fatal error
		-5	(OWN) no such job
		-6	(OWN) job not yours

	j_start (#) => rc	(return code: non-zero => error)
	j_stop (#) => rc
	j_disown (#) => rc
	j_forget (#) => rc
	j_kill (#) => rc
	j_snarf (#, inferior_name) => rc
				(disown named inferior from stopped job)
	j_give_tty (#) => rc
	j_take_tty (#) => rc

	j_grab_tty ()		(grab tty if given to some inferior
				 and stop job)
	j_retn_tty ()		(return tty to inferior and restart)

	j_wait (#) => status	(waits for non-zero status)
	j_sts (#) => status

	j_onchange (f)		(set handler for status changes)

	j_sjcl (#, s) => rc	(set jcl for job)
	j_jcl (#) => s		(get jcl)
	j_ch (#) => ch		(return block image output channel to job)
	j_name (#, filespec)	(set filespec to job name)

	j_val (#) => s		(return string valretted by job)
	j_fval (#)		(flush valret string; or call cfree)

	Job Status:

		-5 => stopped, ^Z typed
		-4 => stopped (by superior)
		-3 => stopped, valret
		-2 => stopped, requested suicide
		-1 => no job
		 0 => running
		>0 => stopped, value is job's first interrupt word

*/

# define MAXJOBS 8
# define VALBUFSIZ 200

/*	job status values	*/

# define js_attn -5
# define js_stopped -4
# define js_valret -3
# define js_suicide -2
# define js_nojob -1
# define js_running 0

/*	useful SIXBIT numbers */

/*  Fixed by BGS 9/14/79 because of MOVNI bug
# define _USR 0656362000000
# define _TS  0646300000000
# define _DSK 0446353000000
# define _FOO 0465757000000
# define _GR  0360000000000 */	/* > */

#define _USR csto6("USR")
#define _TS  csto6("TS")
#define _DSK csto6("DSK")
#define _FOO csto6("FOO")
#define _GR  csto6(">")

/*	internal tables		*/

# rename job_channels "JOBCHN"
# rename job_status "JOBSTS"
# rename job_jcl "JOBJCL"
# rename job_valret "JOBVAL"
# rename job_name "JOBNAM"
# rename job_xname "JOBXNM"
# rename job_wait "JOBWAT"

int	job_status[MAXJOBS]		{js_nojob, js_nojob, js_nojob, js_nojob,
					js_nojob, js_nojob, js_nojob, js_nojob};
int	job_channels[MAXJOBS]		{-1, -1, -1, -1, -1, -1, -1, -1};
char	*job_jcl[MAXJOBS];
char	*job_valret[MAXJOBS];
int	job_name[MAXJOBS];
int	job_xname[MAXJOBS];
int	job_wait -1;
static int jobtty {-1}, jobotty, jobosts, (*jchandler)();

/*	the routines	*/

int	j_fload (file_name)	char *file_name;

	{filespec f;

	fparse (file_name, &f);
	return (j_load (&f));
	}

int	j_load (f)		filespec *f;

	{int pch, xjname;

	if (f->dev == 0) f->dev = _DSK;
	if (f->dir == 0) f->dir = rsname ();
	pch = mopen (f, BII);
	if (pch<0) return (-1);
	xjname = (f->fn1 == _TS ? f->fn2 : f->fn1);
	return (j_cload (pch, xjname));
	}

int	j_cload (pch, xjname)
	channel pch;

	{int j, jch, start;

	j = j_create (xjname);
	if (j<0)
		{close (pch);
		return (j);
		}
	jch = job_channels[j];

	/* load program */

	if (sysload (jch, pch))
		{uclose (jch);
		close (pch);
		return (-3);
		}

	/* get starting address of program */

	sysread (pch, &start, 1);
	close (pch);

	/* set starting address of job */

	wuset (jch, UPC, start & 0777777);
	return (j);
	}

int	j_create (xjname)

	{int jch, i, inc, count, flag;
	filespec jf;

	/* set up job name */

	jf.dev = _USR;
	jf.dir = 0;
	jf.fn1 = 0;
	jf.fn2 = xjname;

	/* make job name unique */

	flag = FALSE;
	while ((jch = open (&jf, OLD + BII)) >= 0)
		{close (jch);
		if (!flag)
			{flag = TRUE;
			i = jf.fn2;
			count = 0;
			while ((i&077)==0) {i =>> 6; ++count;}
			if (count>0)
				{count = 6*(count-1);
				jf.fn2 =| ccto6('0') << count;
				inc = 1 << count;
				}
			else
				{jf.fn2 = (jf.fn2 & ~077) | ccto6('0');
				inc = 1;
				}
			}
		else	jf.fn2 =+ inc;
		}

	/* create job */

	jch = open (&jf, BIO);
	if (jch<0) return (-2);
	reset (jch);

	/* set job's NAMEs */

	wuset (jch, USNAME, rsname());
	wuset (jch, UXJNAME, xjname);

	return (j_xxx (jch, xjname));
	}

/**********************************************************************

	J_OWN - attach job as inferior

**********************************************************************/

int j_own (uname, jname)

	{filespec fs;
	int jch, j, w, sts;

	fs.dev = _USR;
	fs.dir = 0;
	fs.fn1 = uname;
	fs.fn2 = jname;

	if ((jch = open (&fs, OLD + BII)) < 0) return (-5);
	close (jch);
	if ((jch = open (&fs, BIO)) < 0) return (-5);
	if (status (jch) != 061)
		{close (jch); return (-6);}
	j = j_xxx (jch, jname);
	if (ruset (jch, USTOP) & BUSRC)
		{w = ruset (jch, UPIRQ);
		if (w & PICZ) sts = js_attn;
		else if (w & PIVAL) sts = js_valret;
		else if (w) sts = w;
		else sts = js_stopped;
		wuset (jch, UAPIRQ, PJTTY+PIIOC+PIARO+PICZ+PIVAL);
		}
	else sts = js_running;
	job_status[j] = sts;
	return (j);
	}

/**********************************************************************

	J_XXX - common processing for new inferior

**********************************************************************/

int j_xxx (jch, xjname)

	{int i, inf_no, option, j_handler();

	/* get inferior number */

	i = ruset (jch, UINF) >> 18;
	inf_no = 0;
	if (i) while (!(i&1)) {i=>>1; ++inf_no;}

	/* set up interrupt handler */

	on (inferior0_interrupt+inf_no, j_handler);
	option = ruset (jch, UOPTION);
	wuset (jch, UOPTION, option | OPTBRK);

	/* clean up */

	job_channels[inf_no] = jch;
	if (job_status[inf_no] == js_nojob)
		{job_status[inf_no] = js_stopped;
		job_jcl[inf_no] = 0;
		job_valret[inf_no] = 0;
		}
	job_name[inf_no] = ruset (jch, UJNAME);
	job_xname[inf_no] = xjname;

	return (inf_no);
	}

int j_start (j)

	{int ch;

	if (j<0 || j>=MAXJOBS) return (-1);
	ch = job_channels[j];
	if (ch<0) return (-1);
	wuset (ch, USTOP, 0);
	job_status[j] = js_running;
	return (0);
	}

int j_stop (j)

	{int ch;

	if (j<0 || j>=MAXJOBS) return (-1);
	ch = job_channels[j];
	if (ch<0) return (-1);
	wuset (ch, USTOP, -1);
	job_status[j] = js_stopped;
	return (0);
	}

int j_disown (j)

	{int ch, ec;

	if (j<0 || j>=MAXJOBS) return (-1);
	ch = job_channels[j];
	if (ch < 0) return (-1);
	ec = sysdisown (ch);
	if (ec) return (ec);
	j_flush (j);
	return (0);
	}

int j_forget (j)

	{int ch;
	if (j<0 || j>=MAXJOBS) return (-1);
	ch = job_channels[j];
	if (ch < 0) return (-1);
	close (ch);
	j_flush (j);
	return (0);
	}

int j_kill (j)

	{int ch;

	if (j<0 || j>=MAXJOBS) return (-1);
	ch = job_channels[j];
	if (ch<0) return (-1);
	uclose (ch);
	j_flush (j);
	return (0);
	}

static int code[] {
	0042000000013,	/* .IOPUSH 0,	;(26) DON'T CLOBBER HIM */
	0041000000034,	/* .OPEN 0,34	;(27) OPEN <JOB> */
	0043100000000,	/* .LOSE	;(30) FAIL, CAUSE ERR MSG */
	0042000000027,	/* .DISOWN 0,	;(31) DISOWN <JOB> */
	0042000000014,	/* .IOPOP 0,	;(32) UNCLOBBER HIM */
	0043200000000,	/* .VALUE	;(33) RETURN SUCCESS */
	0000001656362,	/* 1,,'USR	;(34) FILENAME BLOCK */
	0,		/*		;(35) WILL GET UNAME */
	0		/*		;(36) WILL GET JNAME */
	};

int j_snarf (j, jname)

	{int ch, piclr, pirqc, pc, osts, sts;

	if (j<0 || j>=MAXJOBS) return (-1);
	osts = job_status[j];
	if (osts == js_running) return (-1);	/* must be stopped */
	ch = job_channels[j];
	if (ch<0) return (-1);
	code[7] = rsuset (UUNAME);
	code[8] = jname;
	access (ch, 026);
	syswrite (ch, code, 9);
	piclr = ruset (ch, UPICLR);
	wuset (ch, UPICLR, 0);
	pirqc = ruset (ch, UPIRQ);
	wuset (ch, UAPIRQ, pirqc);
	pc = ruset (ch, UPC);
	wuset (ch, UPC, 026);
	j_start (j);
	sts = j_wait (j);
	job_status[j] = osts;
	if (sts == js_valret) sts = 0;
	else {wuset (ch, UAPIRQ, sts); sts = -1;}
	wuset (ch, UPC, pc);
	wuset (ch, UIPIRQ, pirqc);
	wuset (ch, UPICLR, piclr);
	return (sts);
	}

int j_flush (j)

	{char *p;

	job_channels[j] = -1;
	job_status[j] = js_nojob;
	job_name[j] = 0;
	if (p = job_jcl[j])
		{sfree (p);
		job_jcl[j] = 0;
		}
	if (p = job_valret[j])
		{sfree (p);
		job_valret[j] = 0;
		}
	on (inferior0_interrupt+j, 0);
	}

int j_give_tty (j)

	{int ch, rc;

	if (j<0 || j>=MAXJOBS) return (-1);
	ch = job_channels[j];
	if (ch<0) return (-1);
	rc = atty (ch);
	if (rc == 0) jobtty = j;
	return (rc);
	}

int j_take_tty (j)

	{int ch, rc;

	if (j<0 || j>=MAXJOBS) return (-1);
	ch = job_channels[j];
	if (ch<0) return (-1);
	rc = dtty (ch);
	if (rc == 0) jobtty = -1;
	return (rc);
	}

int j_grab_tty ()

	{if (jobtty >= 0)
		{int rc;
		jobotty = jobtty;
		jobosts = job_status[jobtty];
		j_stop (jobtty);
		rc = j_take_tty (jobtty);
		if (rc && jobosts==0) j_start (jobtty);
		return (rc);
		}
	jobotty = -1;
	return (0);
	}

int j_retn_tty ()

	{if (jobtty < 0 && jobotty >= 0)
		{j_give_tty (jobotty);
		if (jobosts == 0) j_start (jobotty);
		jobotty = -1;
		}
	}

int j_wait (j)

	{int sts;

	if (j<0 || j>=MAXJOBS) return (-1);
	job_wait = j;
	sts = wfnz (&job_status[j]);
	job_wait = -1;
	return (sts);
	}

int j_onchange (f) int (*f)();

	{jchandler = f;
	}

int j_sts (j)

	{if (j<0 || j>=MAXJOBS) return (-1);
	return (job_status[j]);
	}

int j_sjcl (j, s)	char *s;

	{char *buf, *p;
	int ch, i;

	if (j<0 || j>=MAXJOBS) return (-1);
	ch = job_channels[j];
	if (ch<0) return (-1);
	if (*s==0)
		{if (buf = job_jcl[j])	/* flush previous */
			{i = ruset (ch, UOPTION) & ~OPTCMD;
			wuset (ch, UOPTION, i);
			sfree (buf);
			job_jcl[j] = 0;
			}
		return (0);
		}
	i = salloc (slen (s) + 2);
	if (i <= 0) return (-1);
	buf = i;
	stcpy (s, buf);
	p = buf;
	while (*p) ++p;
	if (p==buf || p[-1]!='\r')
		{p[0] = '\r';
		p[1] = 0;
		}
	job_jcl[j] = buf;
	wuset (ch, UOPTION, OPTCMD);
	}

char *j_jcl (j)

	{if (j<0 || j>=MAXJOBS) return (0);
	return (job_jcl[j]);
	}

int j_ch (j)

	{if (j<0 || j>=MAXJOBS) return (-1);
	return (job_channels[j]);
	}

int j_name (j, f)	filespec *f;

	{f->dev = _USR;
	f->dir = 0;
	f->fn1 = runame();
	if (j>=0 && j<MAXJOBS)
		{f->fn2 = job_name[j];
		return (f->fn2 == 0);
		}
	f->fn2 = 0;
	return (-1);
	}

char *j_val (j)

	{if (j<0 || j>=MAXJOBS) return (0);
	return (job_valret[j]);
	}

j_fval (j)

	{if (j<0 || j>=MAXJOBS) return;
	if (job_valret[j] == 0) return;
	cfree (job_valret[j]);
	job_valret[j] = 0;
	}

j_handler (j)

	{int ch, w, opt, old_status;

	if (j<0 || j>=MAXJOBS) return;
	ch = job_channels[j];
	if (ch<0) return;

	old_status = job_status[j];
	w = ruset (ch, UPIRQ);
	wuset (ch, UAPIRQ, PJTTY+PIIOC+PIARO+PICZ+PIVAL);
	opt = ruset (ch, UOPTION);
	if ((opt & OPTOPC)==0 && (w & IBACKUP))
		wuset (ch, UPC, ruset (ch, UPC) - 1);

	job_status[j] = w;
	if (w & PICZ)				/* ^Z typed */
		{job_status[j] = js_attn;
		return;
		}
	if (w & PIVAL)				/* .VALUE */
		jdovalue (j);
	else if (w & PIBRK)			/* .BREAK */
		jdobrk (j);

	if (j != job_wait && job_status[j] != old_status && jchandler)
		(*jchandler)(j,job_status[j]);
	}

jdovalue (j)	/* handle .VALUE */

	{int ch, ich, cmda, n;
	char *p, buf[VALBUFSIZ];
	filespec f;

	ch = job_channels[j];
	job_valret[j] = 0;
	job_status[j] = js_valret;
	cmda = ruset (ch, USV40) & 0777777;
	if (cmda == 0) return;
	if (j_name (j, &f)) return;
	if ((ich = open (&f, UII)) < 0) return;
	access (ich, cmda);
	n = VALBUFSIZ;
	p = buf;
	while (TRUE)
		{int w, i, c;
		w = uiiot (ich);
		for (i=0;i<5;++i)
			{c = (w>>29) & 0177;
			w =<< 7;
			if (c!='\n') {*p++ = c; --n;}
			if (c=='\r') {*p++ = '\n'; --n;}
			if (!c) break;
			if (n<=2)
				{*p++ = c = 0;
				break;
				}
			}
		if (!c) break;
		}
	close (ich);
	if (stcmp (buf, ":KILL\r") || stcmp (buf, ":KILL\r\n"))
		{/* if (job_wait != j) j_kill (j);
		else */ job_status[j] = js_suicide;
		return;
		}
	p = calloc (slen (buf) + 1);
	stcpy (buf, p);
	job_valret[j] = p;
	return;
	}

jdobrk (j)	/* handle .BREAK */
		/* unless there is a 'fatal error', the job status
		   must be changed to something reasonable */

	{int ch, i;
	ch = job_channels[j];
	wuset (ch, UAPIRQ, PIBRK);	/* reset PIRQ bit */
	i = ruset (ch, USV40);		/* the instruction */
	if ((i & ~000740000000) == 042000000033)
		i = 045700160000;	/* .LOGOUT n, */
	switch (i>>18) {		/* opcode */

case 045700:					/* .BREAK 16 */
	/*	if ((i & 020000) && (job_wait != j)) j_kill (j);
		else */ job_status[j] = js_suicide;
		return;

case 045500:					/* .BREAK 12 */
		jdob12 (j, i);
		return;
		}

	j_start (j);
	}

jdob12 (j, i)		/* handle .BREAK 12 */

	{int cmda, ich, och;
	filespec f;

	cmda = i & 0777777;
	if (j_name (j, &f)) return;
	if ((ich = open (&f, UII)) < 0) return;
	if ((och = open (&f, UIO)) < 0)
		{close (ich);
		return;
		}
	access (ich, cmda);
	i = uiiot (ich);
	if (i & 0200000000000)	/* multiple commands */
		{int n, a;
		n = (i>>18) | 0777777000000;
		a = i & 0777777;
		while (n<0)
			{access (och, cmda);
			++n;
			++a;
			uoiot (och, (n<<18) | a);
			access (ich, a-1);
			do_brk (j, ich, och, uiiot (ich));
			}
		}
	else do_brk (j, ich, och, i);
	close (ich);
	close (och);
	j_start (j);
	}

do_brk (j, ich, och, w)		/* do .BREAK 12 command W */

	{int cmd, a, f, i;

	cmd = (w>>18) & 0177777;
	a = w & 0777777;
	access (och, a);
	if (cmd==6)		/* send :PRINT defaults */
		{uoiot (och, _DSK);
		uoiot (och, rsname ());
		uoiot (och, _FOO);
		uoiot (och, _GR);
		return;
		}
	if (cmd==5 && job_jcl[j])
		{f = copen (job_jcl[j], 'r', "s");
		access (ich, a+2);
		while (TRUE)
			{w = 0;
			for (i=0;i<5;++i) w = (w<<7) | (cgetc (f) & 0177);
			w =<< 1;
			uoiot (och, w);
			if ((w & 0377) == 0) break;
			if (uiiot (ich))
				{uoiot (och, 0);
				break;
				}
			}
		cclose (f);
		return;
		}
	if (cmd==10)	/* send XJNAME */
		{uoiot (och, job_xname[j]);
		return;
		}
	}
