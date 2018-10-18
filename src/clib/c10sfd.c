/**********************************************************************

	SETFDIR - Set File Directory (and defaults)
	(obsolete)

**********************************************************************/

char *setfdir (buf, name, dir)
	char *buf, *name, *dir;

	{filespec	fs1, fs2;
	char		*p;

	fparse (name, &fs1);
	fparse (dir, &fs2);
	if (fs2.dir==0) fs2.dir=fs2.fn1;
	if (fs2.dev) fs1.dev = fs2.dev;
		else if (fs1.dev==0) fs1.dev=csto6("dsk");
	if (fs2.dir) fs1.dir = fs2.dir;
		else if (fs1.dir==0) fs1.dir=rsname();
	p = prfile (&fs1, buf);
	*p = 0;
	return (buf);
	}
