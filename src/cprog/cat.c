# include "c.defs"

/*
 *
 *	CAT - concatenate files
 *
 */

# define _DSK_     0446353000000
# define _ERR_     0456262000000

extern int cin, cout, cerr, cerrno;

main (argc, argv) char **argv;

	{char buffer[2000], *outv[100];

	argc = exparg (argc, argv, outv, buffer);
	cmain (argc, outv);
	}

cmain (argc, argv)
	int argc;
	char *argv[];

	{int fd, i, shandler ();
	extern int sflag;

	sflag = FALSE;
	on (ctrlg_interrupt, shandler);
	on (ctrls_interrupt, shandler);
	setprompt (":");

	if (argc <= 1) typfil (cin);
	else for (i=1;i<argc;++i)
		{fd = eopen (argv[i], 'r');
		if (fd != OPENLOSS) typfil (fd);
		}
	}

/**********************************************************************

	TYPFIL

**********************************************************************/

typfil (fd)

	{int c;
	while (((c = cgetc (fd)) > 0 || !ceof (fd)) && !sflag)
		cputc (c, cout);
	cclose (fd);
	}

/**********************************************************************

	EOPEN - Open with error detection

**********************************************************************/

int eopen (name, mode)
	char *name;

	{int fd;
	filespec f;

	if (stcmp (name, "-")) return (cin);
	fparse (name, &f);
	fd = xopen (&f, mode);
	if (fd == OPENLOSS) pr_err (&f, cerrno);
	return (fd);
	}

/**********************************************************************

	XOPEN - Open, setting defaults

**********************************************************************/

int xopen (fp, mode)
	filespec *fp;

	{char buf[40];
	if (!fp->dev) fp->dev = _DSK_;
	if (!fp->dir) fp->dir = rsname ();
	prfile (fp, buf);
	return (copen (buf, mode));
	}

/**********************************************************************

	PR_ERR - Print Open Error Message

**********************************************************************/

pr_err (fp, x)
	filespec *fp;

	{filespec f;
	int fd, c;
	char *buf[40];

	prfile (fp, buf);
	cprint (cerr, "  %s  ", buf);

	f.dev = _ERR_;
	f.fn1 = 4;
	f.fn2 = x;
	fd = mopen (&f, 0);
	if (fd >= 0)
		{while ((c = uiiot (fd)) > 0)
			if (c != '\r' && c != '\p') cputc (c, cerr);
		close (fd);
		}
	}

/**********************************************************************

	INTERRUPT HANDLER

**********************************************************************/

int sflag;
shandler ()
	{sflag = TRUE;
	reset (tyoopn ());
	}
