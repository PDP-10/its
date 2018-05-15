# include "s.h"

int bcount;			/* number of current block in file */
int boffset;			/* offset of current block in file */
int eof;			/* eof flag */
int type;			/* type of current block */
int size;			/* size field of current block */
int adr;			/* address field of current block */
int block[MAXBLOCK];		/* current block from load file */
int *blkp;			/* current location in block */
int *eblk;			/* end of block */
int lfile;			/* current file being loaded */
int loffset;			/* current offset in load file */
int ovflag;			/* flag indicating one value needed */
int value;			/* current standard block value */
int valexists;			/* a value has been defined */
int startadr;			/* program starting address */

int segsiz[MAXSEGS];		/* segment sizes (for 2-pass) */

extern int loc, cseg, nsegs, nvsegs, segvorg[], segvsiz[], debug, pflag;
extern int pass, npass, comfd;
extern char *combuf;

loadfile (s) char *s;

	{char buf[100];
	stcpy (s, buf);
	lfile = sopen (buf, 'r', "b");
	if (lfile != OPENLOSS)
		{if (pass < npass) load1 (buf);
		else load2 (buf);
		}
	}

load1 (s) char *s;	/* load file - first pass of two-pass loading */

	{if (combuf == 0)
		{combuf = calloc (COMSIZ);
		comfd = copen (combuf, 'w', "s");
		}
	cprint (comfd, "l %s\n", s);
	bcount = loffset = eof = 0;
	while (TRUE)
		{rdblock();
		if (eof) break;
		if (bcount > 3) break;
		if (type == 030)	/* define segment block */
			{int n;
			n = 0;
			while (blkp < eblk && n<MAXSEGS)
				{int ssize, vorg;
				vorg = wright (*blkp);
				ssize = wleft (*blkp);
				++blkp;
				segsiz[n] =+ ssize;
				++n;
				}
			}
		}
	cclose (lfile);
	}

load2 (s) char *s; /* load file - last pass (either 1- or 2-pass loading) */

	{if (pflag || debug) cprint ("\n ----- File %s -----\n\n", s);
	bcount = loffset = eof = 0;
	value = 0;
	lsprog ();
	symsprog ();
	while (TRUE)
		{rdblock();
		if (eof) break;
		if (pflag) prblock();
		if (pflag) cprint ("    ");
		doblock();
		if (pflag) cprint ("\n");
		}
	symeprog ();
	leprog ();
	cclose (lfile);
	}

rdblock ()

	{int header, *p, n;

	boffset = loffset;
	eblk = blkp = block;
	header = geti (lfile);
	eof = header>>35;
	type = (header>>25) & 0177;
	size = (header>>18) & 0177;
	adr = header & 0777777;
	++bcount;
	if (eof) return;
	p = block;
	n = size;
	eblk = p + n;
	while (--n >= 0) *p++ = geti (lfile);
	geti (lfile);
	if (ceof (lfile))
		{error ("premature EOF");
		eof = 1;
		}
	loffset =+ (size + 2);
	}

prblock ()

	{cprint ("#%d (%o) type=%d, size=%d, adr=%o\n", bcount,
		boffset,type, size, adr);
	}

doblock ()

	{switch (type) {
	case 001:	ldcom(); break;
	case 002:	absol(); break;
	case 003:	dreloc(); break;
	case 004:	dpname(); break;
	case 005:	lsrch(); break;
	case 006:	commn(); break;
	case 007:	gassn(); break;
	case 010:	locals(); break;
	case 011:	lcond(); break;
	case 012:	elcnd(); break;
	case 013:	dhkill(); break;
	case 014:	eprog(); break;
	case 015:	entries(); break;
	case 016:	externs(); break;
	case 017:	lifneed(); break;
	case 020:	globals(); break;
	case 021:	fixups(); break;
	case 022:	polish(); break;
	case 023:	dlnklst(); break;
	case 024:	dldfile(); break;
	case 025:	dldlib(); break;
	case 026:	dlvar(); break;
	case 027:	dindex(); break;
	case 030:	dhiseg(); break;
	default:	error ("illegal block type");
		}
	}

ldcom()
	{if (pflag) cprint ("Loader command: ");
	switch (adr) {
	case 0:		lcassn(); break;
	case 1:		ljump(); break;
	case 2:		lgloc(); break;
	case 3:		lcommon(); break;
	case 4:		lgreloc(); break;
	case 5:		lcvalue(); break;
	case 6:		lgoffset(); break;
	case 7:		loper(); break;
	case 8:		lrgoffset(); break;
	default:	error ("bad loader command");
		}
	}

absol()
	{if (pflag) cprint ("Absolute block");
	setaloc (adr);
	if (pflag) cprint (" at %o", loc);
	standard ();
	}

dreloc()
	{if (pflag) cprint ("Relocatable block");
	if (size > 0 || bcount > 2)	/* avoid MIDAS problem */
		{setrloc (adr);
		if (pflag) cprint (" at %o (segment %d)", loc, cseg);
		standard ();
		}
	}

dpname()
	{if (pflag) cprint ("Program name");
	if (size > 2) badfmt ();
	else
		{name n;
		n = block[0];
		stpname (n);
		if (pflag) cprint (": %x", n);
		}
	}

lsrch()
	{if (pflag) cprint ("Library search");
	unimplemented ();
	}

commn()
	{if (pflag) cprint ("Common block");
	unimplemented ();
	}

gassn()
	{if (pflag) cprint ("Global parameter assignment: ");
	assnb ();
	}

locals()
	{if (pflag) cprint ("Local symbols");
	if (size&1) badfmt ();
	while (blkp<eblk)
		{int sym, val, flags;
		sym = *blkp++;
		val = *blkp++;
		flags = sym >> 32;
		if (pflag)
			{cprint ("\n\t%x %13o", sym, val);
			if (flags & 010) cprint ("  (half-kill)");
			if (flags & 004) cprint ("  (LH reloc)");
			if (flags & 002) cprint ("  (RH reloc)");
			if (flags & 001) cprint ("  (block name)");
			}
		}
	}

lcond()
	{if (pflag) cprint ("Load-time conditional");
	unimplemented ();
	}

elcnd()
	{if (pflag) cprint ("End load-time conditional");
	unimplemented ();
	}

dhkill()
	{if (pflag) cprint ("Local half-killed symbols");
	while (blkp < eblk)
		{int sym;
		sym = *blkp++;
		if (pflag) cprint ("\n\t%x", sym);
		hkill (sym);
		}
	}

eprog()
	{if (pflag) cprint ("End of program");
	unimplemented ();
	}

entries()
	{if (pflag) cprint ("Entries");
	unimplemented ();
	}

externs()
	{if (pflag) cprint ("External symbols");
	unimplemented ();
	}

lifneed()
	{if (pflag) cprint ("Load if needed");
	unimplemented ();
	}

globals()
	{if (pflag) cprint ("Global symbols");
	if (size&1) badfmt ();
	unimplemented ();
	while (blkp < eblk)
		{int sym, val;
		sym = *blkp++;
		val = *blkp++;
		if (pflag) cprint ("\n\t%x %o", sym, val);
		}
	}

fixups()
	{if (pflag) cprint ("Fixups");
	unimplemented ();
	}

polish()
	{if (pflag) cprint ("Polish fixups");
	unimplemented ();
	}

dlnklst()
	{if (pflag) cprint ("Link list");
	unimplemented ();
	}

dldfile()
	{if (pflag) cprint ("Load file");
	unimplemented ();
	}

dldlib()
	{if (pflag) cprint ("Load library");
	unimplemented ();
	}

dlvar()
	{if (pflag) cprint ("Local variables");
	unimplemented ();
	}

dindex()
	{if (pflag) cprint ("Index");
	unimplemented ();
	}

dhiseg()
	{int n;
	if (pflag) cprint ("High segment");
	n = 0;
	while (blkp < eblk && n<MAXSEGS)
		{int ssize, vorg;
		vorg = wright (*blkp);
		ssize = wleft (*blkp);
		++blkp;
		if (pflag || debug)
			cprint ("\n\tsegment %d: origin %o, size %o",
				n, vorg, ssize);
		segvorg[n] = vorg;
		segvsiz[n] = ssize;
		++n;
		}
	if (n>nsegs) error ("more virtual segments used than defined");
	nvsegs = n;
	}

lcassn()
	{if (pflag) cprint ("global parameter assignment: ");
	assnb ();
	}

ljump()
	{int l;
	if (pflag) cprint ("starting address specification");
	l = oneval ();
	if (l) startadr = l;
	if (pflag) cprint (": %o", l);
	}

lgloc()
	{if (pflag) cprint ("global location assignment");
	unimplemented ();
	}

lcommon()
	{if (pflag) cprint ("reset COMMON origin");
	unimplemented ();
	}

lgreloc()
	{if (pflag) cprint ("reset global relocation constant");
	unimplemented ();
	}

lcvalue()
	{if (pflag) cprint ("loader conditional on value");
	unimplemented ();
	}

lgoffset()
	{if (pflag) cprint ("set global offset");
	unimplemented ();
	}

loper()
	{if (pflag) cprint ("load-time instruction execution");
	unimplemented ();
	}

lrgoffset()
	{if (pflag) cprint ("reset global offset");
	unimplemented ();
	}

assnb()
	{int sym, val;
	sym = *blkp++;
	val = oneval();
	dodef (sym, val, TRUE);
	}

oneval()

	{int result;
	value = 0;
	valexists = FALSE;
	++ovflag;
	standard ();
	--ovflag;
	result = value;
	value = 0;
	if (!valexists) error ("missing value");
	return (result);
	}

hkill(n) name n;
	{int flags;
	flags = n >> 32;
	if (flags & 001)
		{symbol s;
		s = symfind (n);
		symhkill (s);
		}
	}

standard()

	{int codeword, code, n, sym, data;
	while (blkp < eblk)
		{codeword = *blkp++;
		n = 12;
		while (--n >= 0 && blkp < eblk)
			{code = (codeword >> 33);
			codeword =<< 3;
			data = *blkp++;
			switch (code) {
	case 0:		value =+ data; outval ();
			continue;
	case 1:		value =+ wcons(wleft(data),reloc(wright(data)));
			outval ();
			continue;
	case 2:		value =+ wcons(reloc(wleft(data)),wright(data));
			outval ();
			continue;
	case 3:		value =+ wcons(reloc(wleft(data)),
				reloc(wright(data)));
			outval ();
			continue;
	case 4:		sym = data;
			value =+ getval (sym, 0);
			continue;
	case 5:		sym = data;
			value =+ getval (sym, 1);
			continue;
	case 6:		linkreq (data, *blkp++);
			continue;
	case 7:		if (--n<0)
				{if (blkp>=eblk) {badfmt();return;}
				codeword = *blkp++;
				n = 11;
				}
			code = (codeword >> 33);
			codeword =<< 3;
			*--blkp = data;
			switch (code) {
	case 0:		defsym (); continue;
	case 1:		comrel (); continue;
	case 2:		lclglo (); continue;
	case 3:		libreq (); continue;
	case 4:		rdfsym (); continue;
	case 5:		glomul (); continue;
	case 6:		defdot (); continue;
	default:	error ("bad extend code");
					}
				}
			}
		}
	}

outval ()

	{if (ovflag)
		{valexists=TRUE;
		blkp = eblk;
		}
	else
		{jwrite (loc, value);
		value = 0;
		setloc(loc+1);
		}
	}

defsym ()

	{int sym, val;
	sym = *blkp++;
	val = *blkp++;
	dodef (sym, val, FALSE);
	}

comrel ()
	{if (pflag) cprint ("\n\tcommon relocation");
	++blkp;
	unimplemented ();
	}

lclglo ()
	{if (pflag) cprint ("\n\tlocal to global recovery");
	++blkp;
	unimplemented ();
	}

libreq ()
	{if (pflag) cprint ("\n\tlibrary request");
	++blkp;
	unimplemented ();
	}

rdfsym ()
	{int sym, val;
	sym = *blkp++;
	val = *blkp++;
	dodef (sym, val, TRUE);
	}
	
glomul ()
	{if (pflag) cprint ("\n\tmultiply next global");
	unimplemented ();
	}

defdot ()
	{int sym, flags;
	if (pflag) cprint ("\n\t  define symbol");
	sym = *blkp++;
	flags = sym >> 32;
	if (pflag)
		{if (flags & 001) cprint (" global");
			else cprint ("  local");
		cprint (" %x = . (%o)", sym, loc);
		}
	if (flags & 001)
		{symbol s;
		s = symfind (sym);
		if (symdefined (s) && symvalue (s) != loc)
			error ("%x multiply defined", sym);
		else symdef (s, loc);
		}
	}
