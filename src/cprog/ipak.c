# include "c/c.defs"
# include "c/its.bits"

struct _desc {int name1, name2, date, length;};
# define desc struct _desc

# define MAGIC 0014777252031
# define DSK   0446353000000
# define MASK  0557255727156
# define UMASK 0633126423275
# define BLKSIZ 02000

extern int cout, cerr;
static filespec pakfil;
static int encrypt;
static int verbose;
static int user;
static int loser;
static int dsk_device DSK;

/**********************************************************************

	MAIN ROUTINE

**********************************************************************/

main (argc, argv) char *argv[];

	{char *s, *r;
	int c, putf(), putx();

	--argc; ++argv;
	if (argc < 1) fatal ("Too few arguments");
	deffmt ('f', putf, 1);
	deffmt ('x', putx, 1);
	encrypt = verbose = FALSE;
	user = rsuset (UXUNAME);
	loser = rsuset (UOPTION) & 10000000000;
	fparse (argv[0], &pakfil);
	pakfil.dev = dsk_device;
	if (pakfil.fn2 == 0) pakfil.fn2 = csto6 ("-IPAK-");
	if (argc < 2) s = "l";
	else s = argv[1];
	argc =- 2; argv =+ 2;

	r = s+1;
	while (c = lower (*r++)) switch (c) {
		case 'e':	encrypt = TRUE; break;
		case 'v':	verbose = TRUE; break;
		default:	loser =| 300000; break;
		}

	if (!loser) switch (lower (s[0])) {
	case 'c':	copyc (argc, argv); break;
	case 'm':	movec (argc, argv); break;
	case 'l':	listc (); break;
	case 'r':	readc (argc, argv); break;
	case 'b':	updtc (argc, argv, FALSE); break;
	case 'u':	updtc (argc, argv, TRUE); break;
	case 'd':	deltc (argc, argv); break;
	default:	loser =| 1000; break;
		}

	if (loser) fatal ("Format error");
	}

/**********************************************************************

	COMMAND ROUTINES

**********************************************************************/

listc ()

	{int f;
	desc d;

	f = openread ();
	while (readdesc (f, &d))
		{prdesc (&d);
		skipfile (f, &d);
		}
	close (f);
	}

readc (argc, argv)

	{int f;
	desc d;

	f = openread ();
	while (readdesc (f, &d))
		{if (lmatch (&d, argc, argv)) readfile (f, &d);
		else skipfile (f, &d);
		}
	close (f);
	}

movec (argc, argv)

	{writc (argc, argv, TRUE);}

copyc (argc, argv)

	{writc (argc, argv, FALSE);}

writc (argc, argv, delflg) char **argv;

	{int f;
	char buffer[2000], *outv[100], **fp;

	f = openwrite (FALSE);
	argc = exparg (argc, argv, outv, buffer);
	fp = outv;
	while (--argc >= 0) writefile (*fp++, f, delflg);
	closwrite (f);
	}

updtc (argc, argv, delflg) char *argv[];

	{int in, out;
	desc d;
	char buffer[2000], *outv[100], **fp;

	in = openread ();
	out = openwrite (TRUE);
	while (readdesc (in, &d)) updatfile (&d, in, out, delflg);
	close (in);
	argc = exparg (argc, argv, outv, buffer);
	fp = outv;
	while (--argc >= 0) writefile (*fp++, out, delflg);
	closwrite (out);
	}

deltc (argc, argv) char *argv[];

	{int in, out;
	desc d;

	encrypt = FALSE;
	in = openread ();
	out = openwrite (TRUE);
	while (readdesc (in, &d))
		{if (lmatch (&d, argc, argv))
			{skipfile (in, &d);
			if (verbose) cprint ("%x   deleted\n", &d);
			}
		else writblock (&d, in, out);
		}
	close (in);
	closwrite (out);
	}

/**********************************************************************

	COMMAND SUPPORT ROUTINES

**********************************************************************/

prdesc (dp) desc *dp;

	{prsixbit (dp->name1);
	cputc (' ', cout);
	prsixbit (dp->name2);
	cprint (" %5d    ", dp->length);
	prfdate (dp->date);
	cputc ('\n', cout);
	}

prsixbit (w)

	{char buffer[10];
	int n;

	c6tos (w, buffer);
	n = slen (buffer);
	cprint ("%s", buffer);
	while (n < 6) {cputc (' ', cout); ++n;}
	}

prfdate (w)

	{cal date;

	f2cal (w, &date);
	prcal (&date, cout);
	}

lmatch (dp, argc, argv) desc *dp; char **argv;

	{while (--argc >= 0) if (imatch (*argv++, dp)) return (TRUE);
	return (FALSE);
	}

imatch (s, dp) char *s; desc *dp;

	{filespec fs;
	char pattern[10], buffer[10];

	fparse (s, &fs);
	if (fs.fn1)
		{c6tos (fs.fn1, pattern);
		c6tos (dp->name1, buffer);
		if (!smatch (pattern, buffer)) return (FALSE);
		}
	if (fs.fn2)
		{c6tos (fs.fn2, pattern);
		c6tos (dp->name2, buffer);
		if (!smatch (pattern, buffer)) return (FALSE);
		}
	return (TRUE);
	}

/**********************************************************************

	FILE ROUTINES

**********************************************************************/

openread ()

	{int f, t;

	f = xopen (&pakfil, BII);
	if (f < 0) fatal ("No file");
	if (sysread (f, &t, 1) == 1)
		{if (t == MAGIC)
			{access (f, 0);
			return (f);
			}
		if ((t ^ UMASK) == user) return (f);
		}
	fatal ("Format error");
	}

openwrite (allow)

	{int f, t;
	filespec fs;

	if (!allow)
		{f = xopen (&pakfil, BII);
		if (f >= 0) fatal ("File already exists");
		}
	fs.dev = pakfil.dev;
	fs.dir = pakfil.dir;
	fs.fn1 = csto6 ("_IPAK_");
	fs.fn2 = pakfil.fn1;
	t = user ^ UMASK;
	f = xopen (&fs, BIO);
	if (f < 0) fatal ("Can't create file");
	syswrite (f, &t, 1);
	return (f);
	}

closwrite (f)

	{renmwo (f, &pakfil);
	close (f);
	}

readdesc (f, dp) desc *dp;

	{int i;

	if (sysread (f, &i, 1) != 1) return (FALSE);
	if (i != MAGIC) fatal ("Bad format");
	if (sysread (f, dp, 4) != 4) return (FALSE);
	if (dp->length < 0) fatal ("Bad format");
	return (TRUE);
	}

skipfile (f, dp) desc *dp;

	{access (f, rfpntr (f) + dp->length);}

readfile (f, dp) desc *dp;

	{int in, out, date;
	filespec fs;

	fs.dev = 0;
	fs.dir = 0;
	fs.fn1 = dp->name1;
	fs.fn2 = dp->name2;
	if (verbose) cprint ("%f   ", &fs);
	in = xopen (&fs, BII);
	if (in >= 0)
		{if (verbose) cprint ("already exists, ");
		date = rfdate (in);
		if (date >= dp->date)
			{if (verbose) cprint ("not retrieved\n");
			close (in);
			skipfile (f, dp);
			return;
			}
		close (in);
		}
	out = xopen (&fs, BIO);
	if (out < 0)
		{if (verbose) cprint ("cannot retrieve\n");
		else error ("Can't open output file %f", &fs);
		skipfile (f, dp);
		return;
		}
	copyfile (f, out, dp->length);
	sfdate (out, dp->date);
	close (out);
	if (verbose) cprint ("retrieved\n");
	}

copyfile (in, out, length)

	{int n, buffer[BLKSIZ], *p, *ep;

	while (length > 0)
		{n = length;
		if (n > BLKSIZ) n = BLKSIZ;
		sysread (in, buffer, n);
		if (encrypt)
			{p = buffer;
			ep = buffer + n;
			while (p < ep) *p++ =^ MASK;
			}
		syswrite (out, buffer, n);
		length =- n;
		}
	}

writefile (name, f, delflg) char *name;

	{filespec fs;
	int in;

	fparse (name, &fs);
	in = xopen (&fs, BII);
	if (verbose) cprint ("%f   ", &fs);
	if (in < 0)
		{if (verbose) cprint ("unable to read\n");
		else error ("Can't open input file %f", &fs);
		}
	else writnfile (&fs, in, f, delflg);
	}

writnfile (fp, in, out, delflg) filespec *fp;

	{desc d;

	d.name1 = fp->fn1;
	d.name2 = fp->fn2;
	d.date = rfdate (in);
	d.length = fillen (in);
	writblock (&d, in, out);
	if (delflg) sysdel (fp);
	close (in);
	if (verbose)
		{if (delflg) cprint ("moved\n");
		else cprint ("copied\n");
		}
	}

writblock (dp, in, out) desc *dp;

	{int temp;
	temp = MAGIC;
	syswrite (out, &temp, 1);
	syswrite (out, dp, 4);
	copyfile (in, out, dp->length);
	}

updatfile (dp, in, out, delflg) desc *dp;

	{int date, f, oencrypt;
	filespec fs;

	fs.dev = 0;
	fs.dir = 0;
	fs.fn1 = dp->name1;
	fs.fn2 = dp->name2;
	f = xopen (&fs, BII);
	if (f >= 0)
		{if (verbose) cprint ("%f   ", &fs);
		date = rfdate (f);
		if (date >= dp->date)
			{writnfile (&fs, f, out, delflg);
			skipfile (in, dp);
			return;
			}
		if (verbose) cprint ("not updated\n");
		close (f);
		}
	oencrypt = encrypt;
	encrypt = FALSE;
	writblock (dp, in, out);
	encrypt = oencrypt;
	}

int xopen (fp, mode)	filespec *fp; int mode;

	{if (fp->dev == 0) fp->dev = dsk_device;
	if (fp->dir == 0) fp->dir = rsname();
	return (open (fp, mode));
	}

/**********************************************************************

	PRINTING ROUTINES

**********************************************************************/

putf (fp, f) filespec *fp;

	{char buffer[100];
	prfile (fp, buffer);
	prs (buffer, f);
	}

putx (dp, f) desc *dp;

	{filespec fs;

	fs.dev = 0;
	fs.dir = 0;
	fs.fn1 = dp->name1;
	fs.fn2 = dp->name2;
	putf (&fs, f);
	}

/**********************************************************************

	ERROR ROUTINES

**********************************************************************/

fatal (s, a1, a2)

	{error (s, a1, a2);
	cexit (-1);
	}

error (s, a1, a2)

	{cprint (cerr, s, a1, a2);
	cputc ('\n', cerr);
	}
