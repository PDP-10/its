# include "c.defs"
# include "its.bits"

/**********************************************************************

	FD-ITS
	File Directory Routines
	ITS Version

**********************************************************************/


/**********************************************************************

	FDMAP (P, F)

	Call F(S) for all filenames S that match the pattern P.

**********************************************************************/

static int (*fff)();

fdmap (p, f)
	char *p;
	int (*f)();

	{extern int fdzzzz();
	fff = f;
	mapdirec (p, fdzzzz);
	}

/**********************************************************************

	The following routines are internal and probably should
	not be used by other programs.

**********************************************************************/

fdzzzz (fp)
	filespec *fp;

	{char fn[100];
	prfile (fp, fn);
	(*fff)(fn);
	}

# define DIRSIZ 02000
# define ENTSIZ 5

/*	some useful SIXBIT numbers	*/

# define _FILE_    0164651544516	/* .FILE. */
# define _PDIRP_   0104451621100	/* (DIR) */
# define _DSK_     0446353000000

/**********************************************************************

	MAPDIREC - Perform a function for each file in a
		directory whose name matches a given pattern
		(locked files not included)

**********************************************************************/

mapdirec (pattern, f)
	char *pattern;	/* the file name pattern */
	int (*f)();	/* the function */

	{filespec ff;
	fparse (pattern, &ff);
	return (mapdfs (&ff, f));
	}

mapdfs (fp, f)
	filespec *fp;	/* the parsed pattern */
	int (*f)();	/* the function */

	{int n, v[2*DIRSIZ/ENTSIZ], *p, *q;
	char pat1[10], pat2[10], buf[10];
	filespec fs;

	fs.dev = fp->dev;
	fs.dir = fp->dir;
	fs.fn1 = fp->fn1;
	fs.fn2 = fp->fn2;
	n = rddir (fp, v, 04);
	if (fp->fn1) c6tos (fp->fn1, pat1);
	if (fp->fn2) c6tos (fp->fn2, pat2);
	q = v + 2*n;
	for (p=v; p<q; p=+2)
		{if (fp->fn1)
			{c6tos (p[0], buf);
			if (!smatch (pat1, buf)) continue;
			}
		if (fp->fn2)
			{c6tos(p[1], buf);
			if (!smatch (pat2, buf)) continue;
			}
		fs.fn1 = p[0];
		fs.fn2 = p[1];
		(*f)(&fs);
		}
	}

/**********************************************************************

	RDIREC - Read A Directory

	S is a string specifying a directory.
	V will be filled with pairs of SIXBIT names, one for each file.
	The number of files is returned.

**********************************************************************/

int rdirec (s, v, fs)
	char *s;
	int v[];
	filespec *fs;

	{fparse (s, fs);
	if (!fs->dir) fs->dir = fs->fn1;
	return (rddir (fs, v, 0));
	}

/**********************************************************************

	RDDIR - Read Directory

	Return in V a list of names in the directory specified by FS.
	OPT is used to filter out some files:

		if (opt & 01) no-links
		if (opt & 02) no-backed-up-files
		if (opt & 04) no-locked-files

**********************************************************************/

int rddir (fp, v, opt)
	filespec *fp;
	int v[], opt;

	{int buf[DIRSIZ], f, n, i, *p, d, n1, n2;
	filespec fs;

	fs.dev = fp->dev;
	fs.dir = fp->dir;
	fs.fn1 = _FILE_;
	fs.fn2 = _PDIRP_;
	if (!fs.dev) fs.dev = _DSK_;
	if (!fs.dir) fs.dir = rsname();
	f = open (&fs, BII);
	if (f<0) return (0);
	sysread (f, buf, DIRSIZ);
	close (f);
	n = (DIRSIZ - buf[1]) / ENTSIZ;
	p = buf+buf[1];
	i = 0;
	while (--n >= 0)
		{n1 = *p++;
		n2 = *p++;
		d = *p++ >> 18;		/* random info */
		p =+ 2;
		if (d & 060) continue;	/* should ignore these */
		if (opt & d) continue;	/* optionally ignore */
		*v++ = n1;
		*v++ = n2;
		++i;
		}
	return (i);
	}

/**********************************************************************

	RMFD - Read the Master File Directory

	V will be filled with SIXBIT names, one for each directory,
		sorted.
	The number of directories is returned.

**********************************************************************/

int rdmfd (v)
	int v[];

	{int ch, n, *e, *p, *q, i, j, x;

	ch = fopen ("m.f.d. (file)", BII);
	if (ch<0) return (ch);
	n = sysread (ch, v, DIRSIZ);
	close (ch);
	e = v+n;
	p = v+v[1];
	q = v;
	while (p<e) if (x = *p++) *q++ = x;
	n = q-v-1;	/* -1 for convenience in sort */
	for (i=0; i<n; ++i)
		for (j=i; j<=n; ++j)
			if (v[j] < v[i]) {x=v[i];v[i]=v[j];v[j]=x;}
	++n;
	v[n] = 0;
	return (n);
	}

/**********************************************************************

	a test routine

**********************************************************************/

# ifdef test

main ()

	{char buf[50];

	while (TRUE)
		{cprint ("Pattern: ");
		gets (buf);
		mapdir (buf, prf);
		}
	}

prf (f)
	filespec *f;

	{char buf[100];
	prfile (f, buf);
	cprint ("%s\n", buf);
	}

# endif
