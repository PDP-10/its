# include "c/c.defs"
# include "c/its.bits"

# define max_arcs 12	/* maximum number of archives */
# define max_files 300	/* maximum number of files per directory */

extern int cin, cout, cerr;

int arcs[max_arcs];
int narcs;

# define filename struct _filename
struct _filename {int name1, name2;};

# define namelist struct _namelist
struct _namelist {int nnames; filename names[max_files];};

namelist arcns[max_arcs];
namelist dsknames;

main (argc, argv)
	char *argv[];

	{int i;

	if (argc<2)
		{cprint ("usage: clean dir ...\n");
		return;
		}

	setup ();
	i = 1;
	while (i<argc) clean (argv[i++]);
	}

clean (s)	/* clean directory s */
	char *s;

	{filespec f;
	filename *fp;
	int n;

	fparse (s, &f);
	if (f.dev)
		{cprint (cerr, "%s: device may not be specified\n", s);
		return;
		}
	if (f.dir==0 && f.fn1) {f.dir=f.fn1; f.fn1=0;}
	if (f.dir==0)
		{cprint (cerr, "%s: directory must be specified\n", s);
		return;
		}
	if (f.fn1 || f.fn2)
		{cprint (cerr, "%s: file names may not be specified\n", s);
		return;
		}
	for (n=0;n<narcs;++n)
		{f.dev = arcs[n];
		arcns[n].nnames = rddir (&f, arcns[n].names, 05);
		}
	f.dev = csto6 ("DSK");
	dsknames.nnames = rddir (&f, dsknames.names, 05);

	fp = dsknames.names;
	n = dsknames.nnames;
	while (--n >= 0)
		{f.fn1 = fp->name1;
		f.fn2 = fp->name2;
		dofile (&f);
		++fp;
		}
	}

dofile (fs)
	filespec *fs;

	{int dskin, dsktim, dsklen, i, n, name1, name2;
	filename *fp;
	
	dskin = open (fs, UAI);
	if (dskin < 0) return;
	if (rdmpbt (dskin) == 0)
		{close (dskin);
		return; /* must be backed up */
		}
	dsktim = rfdate (dskin);
	dsklen = fillen (dskin);
	close (dskin);
	name1 = fs->fn1;
	name2 = fs->fn2;

	for (i=0;i<narcs;++i)
		{n = arcns[i].nnames;
		fp = arcns[i].names;
		while (--n >= 0)
			{if (fp->name1==name1 && fp->name2==name2)
				if (doarc (fs, dsktim, dsklen, i)) return;
				else break;
			++fp;
			}
		}
	}

doarc (fs, dsktim, dsklen, n)
	filespec *fs;

	{int arcin, odev, arcnam;
	char buf[100], bufa[20];

	arcnam = arcs[n];
	odev = fs->dev;
	fs->dev = arcnam;
	arcin = open (fs, UAI);
	fs->dev = odev;
	if (arcin < 0) return (FALSE);
	if (rfdate (arcin) == dsktim && fillen (arcin) == dsklen)
		{close (arcin);
		prfile (fs, buf);
		c6tos (arcnam, bufa);
		cprint ("Delete %s (in %s)? ", buf, bufa);
		if (ask ()) sysdelete (fs);
		return (TRUE);
		}
	close (arcin);
	return (FALSE);
	}

int ask ()

	{int c;

	while (TRUE)
		{c = lower (utyi ());
		if (c=='y') {tyos ("yes\r"); return (TRUE);}
		if (c=='n') {tyos ("no\r"); return (FALSE);}
		tyo (07);
		}
	}

setup ()

	{char buf[4];
	int n;

	stcpy ("ARC", buf);
	arcs [narcs++] = csto6 (buf);
	for (n=0;n<=9;++n)
		{buf[2] = n+'0';
		arcs [narcs++] = csto6 (buf);
		}
	}
