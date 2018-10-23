# include "c/c.defs"

/*

	ITS filename cluster

	components:
		DEV:DIR;NAME TYP
		All components manipulated without punctuation.

	routines:
		s = fngdv (old, buf)		return DEV (in buf)
		s = fngdr (old, buf)		return DIR (in buf)
		s = fngnm (old, buf)		return NAME (in buf)
		s = fngtp (old, buf)		return TYP (in buf)
		s = fnggn (old, buf)		return null GEN (in buf)
		s = fngat (old, buf)		return null ATTR (in buf)
		s = fnsdf (buf, old, dv, dir, nm, typ, gen, attr)
						set null components of OLD
						new value in BUF
						(ignore 0 args)
		s = fnsfd (buf, old, dv, dir, nm, typ, gen, attr)
						set components of OLD
						new value in BUF
						(ignore 0 args)
		fnparse (old, dv, dir, nm, typ, gen, attr)
						parse OLD into components

*/

fnparse (old, dv, dir, nm, typ, gen, attr)
	char *old, *dv, *dir, *nm, *typ, *gen, *attr;

	{filespec temp;
	fparse (old, &temp);
	c6tos (temp.dev, dv);
	c6tos (temp.dir, dir);
	c6tos (temp.fn1, nm);
	c6tos (temp.fn2, typ);
	gen[0] = 0;
	attr[0] = 0;
	}

char *fngdv (old, buf)
	char *old, *buf;

	{filespec temp;
	fparse (old, &temp);
	c6tos (temp.dev, buf);
	return (buf);
	}

char *fngdr (old, buf)
	char *old, *buf;

	{filespec temp;
	fparse (old, &temp);
	c6tos (temp.dir, buf);
	return (buf);
	}

char *fngnm (old, buf)
	char *old, *buf;

	{filespec temp;
	fparse (old, &temp);
	c6tos (temp.fn1, buf);
	return (buf);
	}

char *fngtp (old, buf)
	char *old, *buf;

	{filespec temp;
	fparse (old, &temp);
	c6tos (temp.fn2, buf);
	return (buf);
	}

char *fnggn (old, buf)
	char *old, *buf;

	{buf[0] = 0;
	return (buf);
	}

char *fngat (old, buf)
	char *old, *buf;

	{buf[0] = 0;
	return (buf);
	}

char *fnsdf (buf, old, dv, dir, nm, typ, gen, attr)
	char *old, *buf, *dv, *dir, *nm, *typ, *gen, *attr;

	{filespec temp;
	fparse (old, &temp);
	if (dv && temp.dev==0) temp.dev = csto6 (dv);
	if (dir && temp.dir==0) temp.dir = csto6 (dir);
	if (nm && temp.fn1==0) temp.fn1 = csto6 (nm);
	if (typ && temp.fn2==0) temp.fn2 = csto6 (typ);
	prfile (&temp, buf);
	return (buf);
	}

char *fnsfd (buf, old, dv, dir, nm, typ, gen, attr)
	char *old, *buf, *dv, *dir, *nm, *typ, *gen, *attr;

	{filespec temp;
	fparse (old, &temp);
	if (dv) temp.dev = csto6 (dv);
	if (dir) temp.dir = csto6 (dir);
	if (nm) temp.fn1 = csto6 (nm);
	if (typ) temp.fn2 = csto6 (typ);
	prfile (&temp, buf);
	return (buf);
	}
