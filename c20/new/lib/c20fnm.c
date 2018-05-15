/**********************************************************************

	TOPS-20 filename stuff

	components:
		DEV:<DIR>NAME.TYP.GEN;ATTR
		All components manipulated without punctuation,
		except ATTR.
	Also accepts UNIX format:
		/DEV/DIR1/DIR2/.../DIRn/NAME.TYP.GEN;ATTR
	as equivalent to:
		DEV:<DIR1.DIR2....DIRn>NAME.TYP.GEN;ATTR

Routines:

	fnparse		- parse file name into components

	fngxxx		- extract a given component (xxx = dev, dir, ...)

	fncons		- make a complete filename from components

	fnsdf		- given an old file name and a set of default
			  components, make a new file name using the
			  components as defaults for any components
			  unspecified by the old name

	fnsfd 		- make a new file name given an old file name and 
			  a set of components. Nonzero arguments specify 
			  components; the corresponding components of the 
			  old file name will be changed in the new file name.

	fnstd		- Convert an input string into standard TOPS-20
			  filename format
	

**********************************************************************/



# define FNSIZE 100
# define QUOTE 022 /* ^V */
# define TRUE  1
# define FALSE 0

static char *fnscan(), *fnsmove();	/* forward decls */

/**********************************************************************

	FNPARSE - Parse file name into components.

**********************************************************************/

fnparse (old, dv, dir, nm, typ, gen, attr)
	register char *old;
	char *dv, *dir, *nm, *typ, *gen, *attr;

	{register char *p, *q;
	*dv = *dir = *nm = *typ = *gen = *attr = 0;
	while (*old == ' ') ++old;
	p = fnscan (old, ":<");
	if (*p == 0)		/* must be OK in UNIX format */
		{if (*old == '/')	/* get device part */
			{p = fnscan (++old, "/");
			fnsmove (old, p, dv);
			if (*p == 0) return;
			old = ++p;
			}
		q = dir;
		while (TRUE)		/* get dir parts */
			{p = fnscan (old, "/.;");
			if (*p != '/') break;
			if (q != dir) *q++ = '.';
			fnsmove (old, p, q);
			q += (p - old);
			old = ++p;
			}
		fnsmove (old, p, nm);		/* get name part */
		if (*p == 0) return;
		if (*p == '.')
			{old = ++p;		/* get type part */
			p = fnscan (old, ".;");
			fnsmove (old, p, typ);
			if (*p == 0) return;
			}
		if (*p == '.')
			{old = ++p;		/* get gen part */
			p = fnscan (old, ";");
			fnsmove (old, p, gen);
			if (*p == 0) return;
			}
		fnsmove (p, 0, attr);		/* get attr part */
		return;
		}

	if (*old != '<')
		{p = fnscan (old, ":");
		if (*p == ':')
			{fnsmove (old, p, dv);
			old = ++p;
			}
		}
	if (*old == '<')
		{p = fnscan (++old, ">");
		fnsmove (old, p, dir);
		if (*p == 0) return;
		old = ++p;
		}
	p = fnscan (old, ".;");
	fnsmove (old, p, nm);
	old = p + 1;
	if (*p == '.')
		{p = fnscan (old, ".;");
		fnsmove (old, p, typ);
		old = p + 1;
		if (*p == '.')
			{p = fnscan (old, ";");
			fnsmove (old, p, gen);
			}
		}
	if (*p == ';')
		fnsmove (p, 0, attr);
	}

/**********************************************************************

	FNGxx - Extrace a given component.

**********************************************************************/

char *fngdv (old, buf)
	char *old, *buf;

	{char temp[FNSIZE];
	fnparse (old, buf, temp, temp, temp, temp, temp);
	return (buf);
	}

char *fngdr (old, buf)
	char *old, *buf;

	{char temp[FNSIZE];
	fnparse (old, temp, buf, temp, temp, temp, temp);
	return (buf);
	}

char *fngnm (old, buf)
	char *old, *buf;

	{char temp[FNSIZE];
	fnparse (old, temp, temp, buf, temp, temp, temp);
	return (buf);
	}

char *fngtp (old, buf)
	char *old, *buf;

	{char temp[FNSIZE];
	fnparse (old, temp, temp, temp, buf, temp, temp);
	return (buf);
	}

char *fnggn (old, buf)
	char *old, *buf;

	{char temp[FNSIZE];
	fnparse (old, temp, temp, temp, temp, buf, temp);
	return (buf);
	}

char *fngat (old, buf)
	char *old, *buf;

	{char temp[FNSIZE];
	fnparse (old, temp, temp, temp, temp, temp, buf);
	return (buf);
	}

/**********************************************************************

	FNCONS - Construct a file name from its components.

**********************************************************************/

char *fncons (buf, dv, dir, nm, typ, gen, attr)
	register char *buf;
	char *dv, *dir, *nm, *typ, *gen, *attr;

	{if (dv && *dv)
		{buf = fnsmove (dv, 0, buf);
		*buf++ = ':';
		}
	if (dir && *dir)
		{*buf++ = '<';
		buf = fnsmove (dir, 0, buf);
		*buf++ = '>';
		}
	if (nm) buf = fnsmove (nm, 0, buf);
	if (typ && *typ)
		{*buf++ = '.';
		buf = fnsmove (typ, 0, buf);
		}
	if (gen && *gen)
		{*buf++ = '.';
		buf = fnsmove (gen, 0, buf);
		}
	if (attr && *attr)
		{if (*attr != ';') *buf++ = ';';
		fnsmove (attr, 0, buf);
		}
	return (buf);
	}

/**********************************************************************

	FNSDF - Make a new file name with specified defaults.
	Nonzero arguments specify defaults; the corresponding
	components will be set if they are null.

**********************************************************************/

char *fnsdf (buf, old, dv, dir, nm, typ, gen, attr)
	char *old, *buf, *dv, *dir, *nm, *typ, *gen, *attr;

	{char odv[FNSIZE], odir[FNSIZE], onm[FNSIZE],
	      otyp[FNSIZE], ogen[FNSIZE], oattr[FNSIZE];
	fnparse (old, odv, odir, onm, otyp, ogen, oattr);
	if (dv && *odv == 0) fnsmove (dv, 0, odv);
	if (dir && *odir == 0) fnsmove (dir, 0, odir);
	if (nm && *onm == 0) fnsmove (nm, 0, onm);
	if (typ && *otyp == 0) fnsmove (typ, 0, otyp);
	if (gen && *ogen == 0) fnsmove (gen, 0, ogen);
	if (attr && *oattr == 0) fnsmove (attr, 0, oattr);
	fncons (buf, odv, odir, onm, otyp, ogen, oattr);
	return (buf);
	}

/**********************************************************************

	FNSFD - Make a new file name with specified components.
	Nonzero arguments specify components; the corresponding
	components of the file name will be set.

**********************************************************************/

char *fnsfd (buf, old, dv, dir, nm, typ, gen, attr)
	char *old, *buf, *dv, *dir, *nm, *typ, *gen, *attr;

	{char odv[FNSIZE], odir[FNSIZE], onm[FNSIZE],
	      otyp[FNSIZE], ogen[FNSIZE], oattr[FNSIZE];
	fnparse (old, odv, odir, onm, otyp, ogen, oattr);
	if (dv) fnsmove (dv, 0, odv);
	if (dir) fnsmove (dir, 0, odir);
	if (nm) fnsmove (nm, 0, onm);
	if (typ) fnsmove (typ, 0, otyp);
	if (gen) fnsmove (gen, 0, ogen);
	if (attr) fnsmove (attr, 0, oattr);
	fncons (buf, odv, odir, onm, otyp, ogen, oattr);
	return (buf);
	}

/****************************************************************

	FNSTD - standardize file name in TOPS-20 format

****************************************************************/

fnstd (ins, outs)
	char *ins, *outs;

	{char dev[40], dir[40], name[40], type[40], gen[10], attr[20];
	fnparse (ins, dev, dir, name, type, gen, attr);
	fncons (outs, dev, dir, name, type, gen, attr);
	}

/* Internal procedures */

/* Scan starting from P for any character in M.  Stops if an illegal
 * character is encountered and returns a pointer to a null character.
 */

static char *fnscan (p, m)
	register char *p, *m;

	{while (TRUE)
		{register int c;
		register char *q;
		if ((c = *p++) == QUOTE)
			{c = *p++;
			if (c == 0) return (--p);
			continue;
			}
		if (!fnlegal (c)) return ("");
		q = m;
		while (*q) if (c == *q++) return (--p);
		}
	}

/*
 * Internal routine: FNSMOVE
 *
 * Move characters starting with *FIRST up to (but not
 * including) *AFTER into *DEST.  If AFTER is null, then
 * move characters until a NUL byte is encountered.
 * Always terminate the destination with a NUL byte
 * and return a pointer to the terminating NUL.
 * Stop on illegal characters, don't move them.
 */


static char *fnsmove (first, after, dest)
	register char *first, *after, *dest;

	{register char c;
	if (after && *after)
		while (first < after)
			if (fnlegal (c = *first++)) *dest++ = c;
			else	break;
	else	while (c = *first++)
			if (fnlegal (c)) *dest++ = c;
			else	break;
	*dest = 0;
	return (dest);
	}

static char *legals = {"#%**-.0<>>AZ__az"};

static int fnlegal (c)
	register char c;

	{register char *q;
	q = legals;
	while (*q)
		if (c < *q++) break;
		else if (c <= *q++) return (TRUE);
	return (FALSE);
	}
