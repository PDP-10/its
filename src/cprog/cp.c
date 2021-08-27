# include "c/c.defs"
# include "c/its.bits"

extern int cerr;

main (argc, argv)
	int argc;
	char *argv[];

	{filespec	f1, f2, f3;
	int	buf[02000], *q;
	int	fin, fout, fdate, nr, nw, count;
	char	cbuf[60];

	if (argc != 3)
		{puts ("Usage: CP from.file to.file");
		return (-1);
		}
	fparse (argv[1], &f1);
	if (!f1.dev) f1.dev = csto6 ("DSK");
	if (!f1.dir) f1.dir = rsname ();
	if (f1.fn1 && !f1.fn2)
		f1.fn2 = csto6 (">");
	fin = open (&f1, BAI);
	if (fin < 0)
		{prfile (&f1, cbuf);
		cprint (cerr, "unable to open input: %s\n", cbuf);
		return (-1);
		}
	fparse (argv[2], &f2);
	if (!f2.dev) f2.dev=f1.dev;
	if (!f2.dir) f2.dir=f1.dir;
	if (!f2.fn1) f2.fn1=f1.fn1;
	if (!f2.fn2) f2.fn2=f1.fn2;
	f3.dev = f2.dev;
	f3.dir = f2.dir;
	f3.fn1 = csto6 ("_copy_");
	f3.fn2 = csto6 ("output");
	fout = open (&f3, BAO);
	if (fout < 0)
		{prfile (&f2, cbuf);
		cprint (cerr, "unable to open output: %s\n", cbuf);
		close (fin);
		return (-1);
		}
	while (TRUE)
		{nr = sysread (fin, buf, 02000);
		if (nr==0) break;
		count = 5;
		q = buf;
		while ((nw = syswrite (fout, q, nr)) != nr)
			{if (--count==0)
				{cprint (cerr, "error in writing\n");
				close (fin);
				close (fout);
				return (-1);
				}
			q =+ nw;
			nr =- nw;
			}
		if (nw != nr) break;
		}
	if ((fdate = rfdate (fin)) != -1) sfdate (fout, fdate);
	close (fin);
	renmwo (fout, &f2);
	close (fout);
	return (0);
	}
