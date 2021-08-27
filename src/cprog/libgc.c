# include "c/c.defs"
# include "c/its.bits"

# define invisible 010			/* don't change reference date */
# define output_file "libgc.out"
# define _DSK		0446353000000		/* DSK in sixbit */
# define _DOT		0160000000000		/* . in sixbit */

int mpvflag;
mpvh ()

	{setpc (getpc () + 1);
	++mpvflag;
	}

main (argc, argv)
	char *argv[];

	{int mfd[02000];
	int dir[02000];
	int ndir, nfile, i, *fp, w;
	int prfs(), prlo(), pr6(), prer();
	filespec fs;

	deffmt ('f', prfs, 1);
	deffmt ('m', prlo, 1);
	deffmt ('x', pr6, 1);
	deffmt ('e', prer, 1);
	on (mpv_interrupt, mpvh);
	on (ioc_interrupt, mpvh);

	ndir = rdmfd (mfd);
	if (argc>1)
		{w = csto6 (argv[1]);
		for (i=0;i<ndir;++i) if (mfd[i]==w) break;
		if (i>=ndir)
			{cprint ("no directory: %x\n", w);
			i = 0;
			}
		}
	else i = 0;
	for (;i<ndir;++i)
		{fs.dev = _DSK;
		fs.dir = mfd[i];
		if (fs.dir == _DOT) continue;	/* avoid CRASH files */
		nfile = rddir (&fs, dir, 01);	/* ignore links */
		fp = dir;
		while (--nfile>=0)
			{fs.fn1 = *fp++;
			fs.fn2 = *fp++;
			hack (&fs);
			}
		}
	}

/* hackery */

# define _JRST1		0254000000001		/* first word of BIN file */
# define DOTCALL	0043000000000		/* .CALL instruction */
# define _OPEN		0576045560000		/* OPEN in sixbit */
# define _CLIB		0734354514275		/* [CLIB] in sixbit */
# define _C		0430000000000		/* C in sixbit */
# define MOVEI_P	0201740000000		/* MOVEI P, */
# define PUSHJ_P	0260740000000		/* PUSHJ P, */

hack (fp)
	filespec *fp;

	{int pch, pc, j, jch, w, a[4], na, _SETZ;
	char buf[40];
	filespec js;

	mpvflag = 0;
	_SETZ = 1;
	_SETZ =<< 35;
	prfile (fp, buf);
	pch = open (fp, BII+invisible);
	if (pch < 0)
		{if (pch != -04 && pch != -047)
			announce ("*** %f  %e", fp, pch);
		return;
		}
	sysread (pch, &w, 1);
	while (TRUE)
		{if (w == _JRST1) break;
		if (w == 0)
			{sysread (pch, &w, 1);
			if ((w >> 9) == 0600) break;
			}
		close (pch);
		return;
		}
	access (pch, 0);
	j = j_cload (pch, 1);
	if (j < 0 || mpvflag)
		{close (pch);
		if (j != -3)
			announce ("*** %f  CAN'T LOAD\n", fp);
		return;
		}
	j_name (j, &js);
	jch = open (&js, UII);
	pc = ruset (jch, UPC) & 0777777;
	access (jch, pc);
	w = uiiot (jch);	/* first instruction */
	while (!mpvflag)
		{if ((w & 0777777000000) == MOVEI_P)
			{w = uiiot (jch);
			if (mpvflag) break;
			if ((w & 0777777000000) != PUSHJ_P) break;
			w =& 0777777;
			access (jch, w);
			w = uiiot (jch);
			if (mpvflag) break;
			}
		if ((w & 0777777000000) != DOTCALL) break;
		w =& 0777777;	/* address of .CALL block */
		access (jch, w);
		w = uiiot (jch);
		if (mpvflag) break;
		if (w != _SETZ) break;
		w = uiiot (jch);
		if (mpvflag) break;
		if (w != _OPEN) break;
		w = uiiot (jch);
		if (mpvflag) break;
		if (w != 01000000001) break;
		na = 0;
		while (TRUE)
			{if (na>4) break;
			w = uiiot (jch);
			if (mpvflag) break;
			if (w & 0377777000000) break;
			a[na++] = w & 0777777;
			if (w & _SETZ) break;
			}
		if (na != 4) break;
		access (jch, a[0]);
		w = uiiot (jch);
		if (mpvflag) break;
		if (w != _DSK) break;
		access (jch, a[1]);
		w = uiiot (jch);
		if (mpvflag) break;
		if (w != _CLIB) break;
		access (jch, a[3]);
		w = uiiot (jch);
		if (mpvflag) break;
		if (w != _C) break;
		access (jch, a[2]);
		w = uiiot (jch);
		if (mpvflag) break;
		announce ("%f  version %x\n", fp, w);
		break;
		}
	close (jch);
	j_kill (j);
	}

prfs (fp, f, width)
	filespec *fp;

	{char buf[40];
	prfile (fp, buf);
	prs (buf, f);
	}

pr6 (w, f, width)
	{char buf[10];
	c6tos (w, buf);
	prs (buf, f);
	}

# define _ERR_     0456262000000

prer (x, f, width)

	{filespec fs;
	int fd, c;

	fs.dev = _ERR_;
	fs.fn1 = 4;
	fs.fn2 = -x;
	fd = mopen (&fs, UAI);
	if (fd >= 0)
		{while ((c = uiiot (fd)) > 0)
			if (c != '\r' && c != '\p') cputc (c, f);
		close (fd);
		}
	}

prlo (cc, f, width)

	{switch (cc) {
		case -1: prs ("cant open file\n", f); break;
		case -2: prs ("cant create job\n", f); break;
		default: prs ("error\n", f); break;
		}
	}


announce (fmt, a1, a2, a3, a4, a5)

	{int outf;
	extern int cerrno;

	outf = copen (output_file, 'a');
	while (outf == -1 && cerrno == 023)	/* locked */
		{sleep (30);
		outf = copen (output_file, 'a');
		}
	if (outf == -1) cprint (" unable to open output file\n");
	else
		{cprint (outf, fmt, a1, a2, a3, a4, a5);
		cclose (outf);
		}
	if (got_tty () || outf == -1) cprint (fmt, a1, a2, a3, a4, a5);
	}

/**********************************************************************

	GOT_TTY - Do I have the TTY?

**********************************************************************/

int got_tty ()

	{return (! (rsuset (UTTY) & 0400000000000));
	}
