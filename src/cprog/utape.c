# include "c/c.defs"

/*

	UTAPE - UNIX tape handler

*/

/*     interface with MAGTAPE routines     */

# rename checksum "CHECKSUM"
# rename char_in_buffer "CHARINBUF"

extern int checksum, char_in_buffer;

/*     renamings to handle long names     */

# define get_length_and_time gtlntm
# define set_default_directory setdfd
# define switch_case_handling swcshd
# define merge_case mrgcas
# define save_old_files svofiles

# define COMTABSZ 50
# define NAMEBFSZ 1000

extern int cin, cout;

struct _dirent {
	int	mode;
	int	uid;
	int	gid;
	int	size;
	int	time;
	int	tapa;
	char	name[32];
	char	realname[32];	/* used for updating */
	};
# define dirent struct _dirent

# define max_ent 496
struct _direct {
	dirent	entries[max_ent];	/* the entries */
	int	nentries;		/* how many */
	};
# define direct struct _direct

int merge_case TRUE;
int d_read FALSE;
int cc;
int fin;
char *tempdir[20];

direct direc;
direct tdirec;		/* temporary directory for updating */
int uid, gid;

char *blskip(),	*gettname();
dirent *find();

int sflag;

shandler ()
	{sflag = TRUE;
	}

main (argc, argv)	int argc; char *argv[];

	{int c, c1, f;
	char buf[200];

	on (ctrlg_interrupt, 1);
	on (ctrls_interrupt, shandler);

	f = 0;
	fin = cin;
	c6tos (rsname (), tempdir);

	while (TRUE)

		{if (getline (": ", buf)) return;

		c = lower (buf[0]);
		c1 = lower (buf[1]);

		switch (c) {

	case 'l':	rdir();
			f = getfile (buf+1);
			prdir (f, &direc);
			if (f != cout) cclose (f);
			break;

	case 'r':	if (c1=='t') readt (buf+2, true);
			else if (c1=='f') readt (buf+2, false);
			else if (c1=='a') rdall ();
			else rfiles ();
			break;

	case 'h':	set_default_directory (buf+1);
			break;

	case 'i':	initt();
			break;

	case 'u':	update();
			break;

	case '?':	lcommands();
			break;

	case 'c':	switch_case_handling ();
			break;

	case 'w':	if (c1=='t') writt (buf+2, TRUE);
			else if (c1=='f') writt (buf+2, FALSE);
			else goto unrec;
			break;

	case 'q':	clos8();
			return;

	case 'x':	if (fin != cin)
				{cprint ("XFILE within XFILE\n");
				cclose (fin);
				fin = cin;
				break;
				}
			fin = copen (blskip (buf+1), 'r');
			if (fin == -1)
				{cprint ("Unable to open command file\n");
				fin = cin;
				}
			break;

unrec:	default:	cprint ("Unrecognized command: %s\n", buf);
			break;
			}
		}
	}


/**********************************************************************

	RFILES - Read Files Command

**********************************************************************/

rfiles ()

	{struct	command {dirent *p; char *name;};
	struct command comtab[COMTABSZ], *cp, *ep;
	dirent	*p;
	char	*s1, *s2, namebuf[NAMEBFSZ];

	cp = comtab; ep = comtab + COMTABSZ;
	s1 = namebuf; s2 = namebuf + NAMEBFSZ;

	rdir ();
	while (cp < ep)
		{if (getline ("file=", s1)) return (-1);
		if (s1[0] == '\0') break;
		p = find (s1, &direc);
		if (p)
			{cp->p = p;
			cp->name = s1;
			if (getline ("to=", s1)) return (-1);
			if (s1[0]=='\0') cp->name = p->name;
			else s1 =+ slen(s1);
			*s1++ = '\0';
			if (s1 >= s2) break;
			++cp;
			}
		}
	ep = cp;
	cp = comtab;
	while (cp < ep)
		{rdfile (cp->p, cp->name);
		++cp;
		}
	}

/**********************************************************************

	RDALL - Read All Files Command.

**********************************************************************/

rdall ()

	{dirent *p;
	int n;

	rdir ();
	p = direc.entries;
	n = direc.nentries;
	while (--n >= 0)
		{rdfile (p, p->name);
		++p;
		}
	}

/**********************************************************************

	RDFILE - Read one file from tape.

**********************************************************************/

rdfile (p, fname)
	dirent *p;
	char *fname;

	{int f;
	f = copen (fname, 'r');
	if (f != OPENLOSS)
		{char buf[100];
		cclose (f);
		cprint ("File %s already exists. Delete it? ", fname);
		gets (buf);
		if (buf[0] != 'y' && buf[0] != 'Y') return;
		}
	f = copen (fname, 'w');
	if (f != OPENLOSS)
		{int l;
		cal cd;
		char_in_buffer = FALSE;
		seek8 (p->tapa);
		l = p->size;
		while (--l >= 9) cputc (get8(), f);
		u2cal (p->time, &cd);
		sfdate (itschan (f), cal2f (&cd));
		cclose (f);
		}
	else cprint ("Unable to open %s\n", fname);
	}

/**********************************************************************

	switch_case_handling

**********************************************************************/

switch_case_handling ()

	{merge_case = !merge_case;
	cprint ("%s\n", merge_case ? "now merged" : "now distinct");
	}

/**********************************************************************

	INITT - Initialize an Empty Tape

**********************************************************************/

initt ()

	{dirent *dp, *ep;
	char buf[40];

	cprint ("Are you sure you want to wipe out this tape? ");
	gets (buf);
	if (buf[0] != 'y' && buf[0] != 'Y')
		{cprint ("SAVED!\n");
		return;
		}
	d_read = FALSE;
	opnw8();
	char_in_buffer = FALSE;
	put8z (512);	/* write first block */

	dp = direc.entries;
	direc.nentries = max_ent;
	ep = dp+max_ent;

	while (dp < ep)
		{dp->mode = 0666;
		dp->uid = 0;
		dp->gid = 0;
		dp->size = 0;
		dp->time = 0;
		dp->tapa = 0;
		dp->name[0] = '\0';
		dp->realname[0] = '\0';
		++dp;
		}
 
	/* write tape directory */

	dp = direc.entries;
	while (dp < ep) wrde (dp++);
	clos8();
	}

/**********************************************************************

	UPDATE - Update a Tape

**********************************************************************/

update ()

	{int		i, c, f, tapa, dirsaved, l, saved [max_ent];
	char		buf[200], *s, *r;
	dirent		*p, *ep;

	rdir ();	/* read old directory */
	drcopy (&direc, &tdirec);	/* make temporary directory */

	if (tdirec.nentries==0)
		{uid = 1000;
		gid = 1000;
		}
	else
		{uid = direc.entries[0].uid;
		gid = direc.entries[0].gid;
		}

	/* accept commands */

	while (TRUE)

		{if (getline ("u: ", buf)) return (-1);
		c = lower (buf[0]);
		s = blskip (buf+1);

		switch (c) {

	case '?':	/* list update mode commands */

		uhelp ();
		continue;

	case 'd':	/* delete file */

		delent (&tdirec, s);
		continue;

	case 'l':	/* list directory */

		f = getfile (s);
		prdir (f, &tdirec);
		if (f != cout) cclose (f);
		continue;

	case 'q':	/* quit without writing */

		return;

	case 'u':	/* set uid and gid */

		r = s;
		while (*s) if (*++s == ' ') break;
		if (!*s) s = 0; else *s++ = 0;
		if (r[0]) uid = atoi (r);
		if (s) gid = atoi (s);
		cprint ("uid=%d,gid=%d\n", uid, gid);
		continue;

	case 'r':	/* replace entry */

		r = s;
		while (*s) if (*++s == ' ') break;
		if (!*s) s = r;
		else *s++ = '\0';
		repent (&tdirec, r, s);
		continue;

	case 'i':	/* insert file at specific point */

		r = s;
		while (*s) if (*++s == ' ') break;
		if (!*s)
			{if (tdirec.nentries>0)
				s=tdirec.entries[0].name;
			else s = 0;
			}
		else *s++ = '\0';
		insent (&tdirec, r, s);
		continue;

	case 'a':	/* add new file at end of tape */

		insent (&tdirec, s, 0);
		continue;

	case 'c':	/* continue from crash during writing */

		if (rsdir(saved)) return;
		goto write_label;

	case 'w':	/* write tape (at last) */

		/* first read in all those files which are
		   to remain on the tape */

		save_old_files (&tdirec, saved);

		/* now compute the tape addresses for the new tape */

		tapa = 63;
		p = tdirec.entries;
		ep = tdirec.entries+tdirec.nentries;
		while (p < ep)
			{p->tapa = tapa;
			tapa =+ (p->size + 511) >> 9;
			++p;
			}

		/* clear remaining entries */

		while (ep < tdirec.entries+max_ent)
			{ep->name[0] = 0;
			++ep;
			}

		/* save directory in case of crash */

		if (svdir (saved))
			{cprint ("Will not be able to survive a crash\n");
			dirsaved = FALSE;
			}
		else dirsaved = TRUE;

		cprint ("\nReady to write tape.  Type anything to continue: ");
		gets (buf);

		/* write tape directory */

write_label:	d_read = FALSE;
		char_in_buffer = FALSE;
		opnw8();
		put8z (512);	/* write first block */

		p = tdirec.entries;
		ep = tdirec.entries+max_ent;
		while (p < ep) wrde (p++);

		/* write files */

		p = tdirec.entries;
		while (p < ep)
			{if (p->name[0]==0) break;
			l = (p->size + 511) & ~0777;
			i = p - tdirec.entries;
			s = (saved[i]?gettname(i):p->realname);
			f = copen (s, 'r');
			if (f == OPENLOSS)
				{cprint ("Can't read %s\n", s);
				put8z (l);
				}
			else
				{while (--l >= 0) put8 (cgetc (f));
				cclose (f);
				}
			++p;
			}
		clos8();
		cprint ("Tape successfully written!\n");
		if (dirsaved) delete ("_tape_._dir_");
		i = tdirec.nentries;
		while (--i >= 0) if (saved[i]) delete (gettname(i));
		return;

	default:

		cprint ("Unrecognized command: %s\n", buf);
			}
		}
	}

/**********************************************************************

	UHELP - print update mode help information

**********************************************************************/

uhelp ()

	{cprint (
"Update mode commands:\n\
\ta name\t\t(append file at end of tape)\n\
\tc\t\t(continue from crash during writing)\n\
\td name\t\t(delete file)\n\
\ti name1 name2\t(insert file1 before file2)\n\
\tl { file }\t(list directory {to file})\n\
\tq\t\t(quit without writing)\n\
\tr name1 {name2}\t(replace file1 with file2)\n\
\tw\t\t(write tape)\n\
\tu uid gid\t(set uid and gid)\n");
	}

/**********************************************************************

	SAVE_OLD_FILES - save files which are not being updated

**********************************************************************/

int save_old_files (d, saved)
	direct *d;
	int saved[];

	{int i, f, len, zeroc, c, n;
	dirent *p;
	char buf[20], *s;

	cprint ("Directory to use for temp files (default '%s'): ", tempdir);
	gets (buf);
	if (buf[0]) stcpy (buf, tempdir);
	p = d->entries;
	n = d->nentries;

	for (i=0;i<n;++i)
		{if (p->tapa > 0)
			{f = copen (s = gettname(i), 'w');
			if (f == OPENLOSS)
				{cprint ("Unable to open temp file: %s\n", s);
				return (-1);
				}
			char_in_buffer = FALSE;
			seek8 (p->tapa);
			len = p->size;
			zeroc = 0;
			while (--len >= 0)
				{c = get8();
				if (c) zeroc=0; else ++zeroc;
				cputc (c, f);
				}
			cclose (f);
			p->size =- zeroc;
			saved[i] = TRUE;
			}
		else saved[i] = FALSE;
		++p;
		}
	clos8 ();
	return (0);
	}

/**********************************************************************

	SAVE DIRECTORY FOR UPDATE

**********************************************************************/

svdir (saved)
	int saved;

	{int	f, *p1, *p2;

	f = copen ("_tape_._dir_", 'w', "b");
	if (f == OPENLOSS)
		{cprint ("Unable to save directory\n");
		return (-1);
		}
	p1 = &tdirec;
	p2 = &tdirec + 1;
	while (p1 < p2) cputi (*p1++, f);
	p1 = saved;
	p2 = saved + max_ent;
	while (p1 < p2) cputi (*p1++, f);
	cclose (f);
	return (0);
	}

/**********************************************************************

	RSDIR - Restore Directory For Update

**********************************************************************/

rsdir (saved)
	int saved[];

	{int	f, *p1, *p2;

	f = copen ("_tape_._dir_", 'r', "b");
	if (f == OPENLOSS)
		{cprint ("Unable to restore directory\n");
		return (-1);
		}
	p1 = &tdirec;
	p2 = &tdirec + 1;
	while (p1 < p2) *p1++ = cgeti (f);
	p1 = saved;
	p2 = saved + max_ent;
	while (p1 < p2) *p1++ = cgeti (f);
	cclose (f);
	return (0);
	}

/**********************************************************************

	READT - Read Entire Tape

	IMAGE==1 => file to be written in IMAGE mode
	IMAGE==0 => file to be written in TEXT mode

**********************************************************************/

readt (s, image)	char *s;

	{int fd, i;

	s = blskip (s);
	if (!*s) s = "from.tape";
	fd = copen (s, 'w', image ? "b" : "");
	if (fd == -1)
		{cprint ("Unable to open %s for output\n", s);
		return;
		}
	d_read = FALSE;
	clos8 ();
	open8 ();
	if (image)
		{i = get32 ();
		while (!eof8 ()) {cputi (i, fd); i = get32 ();}
		}
	else
		{i = get8 ();
		while (!eof8 ()) {cputc (i, fd); i = get8 ();}
		}
	cclose (fd);
	clos8 ();
	}

/**********************************************************************

	WRITT - Write Entire Tape.

	IMAGE==1 => file is image mode
	IMAGE==0 => file is text mode

**********************************************************************/

writt (s, image)	char *s;

	{int fd, i;

	s = blskip (s);
	if (!*s) s = "to.tape";
	fd = copen (s, 'r', image ? "b" : "");
	if (fd == -1)
		{cprint ("Unable to open %s for input\n", s);
		return;
		}
	clos8 ();
	opnw8 ();
	d_read = FALSE;
	if (image)
		{i = cgeti (fd);
		while (!ceof (fd)) {put32 (i); i = cgeti (fd);}
		}
	else
		{i = cgetc (fd);
		while (!ceof (fd)) {put8 (i); i = cgetc (fd);}
		}
	cclose (fd);
	clos8 ();
	}

/**********************************************************************

	BLSKIP - Skip Blanks in String

**********************************************************************/

char *blskip (s)	char *s;

	{while (*s == ' ') ++s;
	return (s);
	}

/**********************************************************************

	GETTNAME - Get name of temp file #n

**********************************************************************/

char *gettname (n)

	{static char buf[30];
	int f;

	f = copen (buf, 'w', "s");
	cprint (f, "%s/_tape_.%d", tempdir, n);
	cclose (f);
	return (buf);
	}

/**********************************************************************

	GETFILE - Get Output File

**********************************************************************/


getfile (s)	char *s;

	{int f;

	s = blskip (s);
	if (s[0])
		{f = copen (s, 'w');
		if (f != -1) return (f);
		}
	return (cout);
	}

/**********************************************************************

	DRCOPY - Copy Directory

**********************************************************************/

drcopy (s, d)
	direct *s, *d;

	{int n;
	dirent *p, *q;

	n = d->nentries = s->nentries;
	p = s->entries;
	q = d->entries;
	while (--n >= 0) demove (p++, q++);
	}

/**********************************************************************

	DELENT - Delete entry in Directory

**********************************************************************/

delent (d, s)
	direct *d;
	char *s;

	{dirent *p, *ep;

	p = find (s, d);
	if (!p)
		{cprint ("File %s not on tape\n", s);
		return;
		}
	ep = d->entries+d->nentries;
	while (p<ep) {demove (p+1, p); ++p;}
	--d->nentries;
	}

/**********************************************************************

	REPENT - Replace a Directory Entry

**********************************************************************/

repent (d, r, s)
	direct *d;	/* the directory */
	char *r;	/* the file to be replaced */
	char *s;	/* the new file */

	{dirent *p, *q;
	char name[32];
	int l;

	extract (r, name);
	p = find (name, d);
	if (!p)
		{cprint ("File %s not on tape\n", name);
		return;
		}
	extract (s, name);
	q = find (name, d);
	if (q && q!=p)
		{cprint ("File %s already on tape\n", name);
		return;
		}
	if (get_length_and_time (s, &l, &(p->time))) return;
	p->mode = 0666;
	p->uid = uid;
	p->gid = gid;
	p->size = l;
	p->tapa = -1;		/* indicates not on tape */
	stcpy (name, p->name);
	stcpy (s, p->realname);
	}

/**********************************************************************

	INSENT - Insert a new entry at a particular point

**********************************************************************/

insent (d, r, s)
	direct *d;	/* the directory */
	char *r;	/* the new file */
	char *s;	/* insert before this, 0 => at end */

	{dirent *p, *q, *ep;
	int l, i;
	char name[32];

	extract (r, name);
	p = find (name, d);
	if (p)
		{cprint ("File %s already on tape\n", name);
		return;
		}
	if (get_length_and_time (r, &l, &i)) return;
	ep = d->entries+d->nentries;
	if (s && (q = find (s, d)))	/* insert before specific file */
		{p = q;
		q = ep;
		while (q > p) {demove (q-1, q); --q;}
		}
	else p = ep;	/* append at end */

	p->mode = 0666;
	p->uid = uid;
	p->gid = gid;
	p->size = l;
	p->tapa = -1;		/* indicates not on tape */
	p->time = i;
	stcpy (name, p->name);
	stcpy (r, p->realname);
	++d->nentries;
	}

/**********************************************************************

	PRDIREC - Print a Listing of a Directory

**********************************************************************/

prdir (f, d)
	int f;		/* the listing file descriptor */
	direct *d;	/* a pointer to the directory */

	{int n;
	dirent *p;

	sflag = FALSE;
	p = d->entries;
	n = d->nentries;
	cprint (f, "\nTAPA    MODE   UID GID  SIZE  TIME                 NAME\n\n");
	while (--n >= 0 && !sflag) prde (p++, f);
	cputc ('\n', f);
	}

/**********************************************************************

	FIND - Find File in Directory,
		Return Pointer To Directory Entry

**********************************************************************/

dirent *find (name, d)
	char *name;	/* file name to be searched for */
	direct *d;	/* pointer to directory */

	{int n;
	dirent *p;

	p = d->entries;
	n = d->nentries;
	while (--n >= 0)
		if (stcmp (name, p->name)) return (p);
		else ++p;
	return (0);
	}

/**********************************************************************

	DEMOVE - Move Directory Entry

**********************************************************************/

demove (s, d)	dirent *s, *d;

	{d->mode = s->mode;
	d->uid = s->uid;
	d->gid = s->gid;
	d->size = s->size;
	d->time = s->time;
	d->tapa = s->tapa;
	stcpy (s->name, d->name);
	stcpy (s->realname, d->realname);
	}

/**********************************************************************

	WRDE - Write Directory Entry

**********************************************************************/

wrde (p)	dirent *p;

	{char *s;
	int i, c;

	checksum = 0;
	i = 32;
	s = p->name;
	while (c = *s++)
		{put8 (c);
		--i;
		}
	put8z (i);
	put16 (p->mode);
	put8 (p->uid);
	put8 (p->gid);
	put32 (p->size);
	put32 (p->time);
	put16 (p->tapa);
	put8z (16);
	put16 ((-checksum) & 0177777);
	}

/**********************************************************************

	PRDE - Print Directory Entry

**********************************************************************/

prde (p, f)	dirent *p;

	{int i;
	char *name, *realname;

	name = p->name;
	realname = p->realname;
	i = p->tapa;
	if (i>0) cprint (f, "%4d ", i);
	else cprint (f, "     ");

	prmode (p->mode, f);
	cprint (f, " %3d %3d %6d ", p->uid, p->gid, p->size);
	prutime (p->time, f);
	cprint (f, " %s", name);
	if (realname[0] && stcmp (name, realname) == 0)
		cprint (f, " (%s)", realname);
	cputc ('\n', f);
	}

/**********************************************************************

	PRMODE - Print File Mode Word

**********************************************************************/

prmode (w, f)

	{
	cputc (w & 0400 ? 'r' : '-', f);
	cputc (w & 0200 ? 'w' : '-', f);
	cputc (w & 0100 ? 'x' : '-', f);
	cputc (w & 0040 ? 'r' : '-', f);
	cputc (w & 0020 ? 'w' : '-', f);
	cputc (w & 0010 ? 'x' : '-', f);
	cputc (w & 0004 ? 'r' : '-', f);
	cputc (w & 0002 ? 'w' : '-', f);
	cputc (w & 0001 ? 'x' : '-', f);
	}

/**********************************************************************

	PRUTIME - Print UNIX Calender Time
		(Seconds Since 1970)

**********************************************************************/

prutime (w, f)

	{cal cd;

	u2cal (w, &cd);
	prcal (&cd, f);
	}

/**********************************************************************

	GET8 - Read One Byte From Tape

**********************************************************************/

get8 ()

	{int i;

	if (char_in_buffer)
		{char_in_buffer = FALSE;
		return (cc);
		}

	i = get16();
	cc = i>>8;	/* return low-order byte first */
	char_in_buffer = TRUE;
	return (i & 0377);
	}

/**********************************************************************

	GET32 - Read A 32-Bit Integer From Tape

**********************************************************************/

get32 ()

	{return ((get16() << 16) | get16());
	}

/**********************************************************************

	PUT8 - Write A Byte Onto Tape

**********************************************************************/

put8 (c)

	{if (char_in_buffer)
		{char_in_buffer = FALSE;
		put16 ((c<<8) | cc);
		}
	else
		{cc = c;
		char_in_buffer = TRUE;
		}
	}

/**********************************************************************

	PUT8Z - Write Zero Bytes Onto Tape

**********************************************************************/

put8z (n)

	{while (n--) put8 (0);
	}

/**********************************************************************

	PUT32 - Write A 32-Bit Integer Onto Tape

**********************************************************************/

put32 (i)

	{put16 (i>>16);
	put16 (i & 0177777);
	}

/**********************************************************************

	RDDE - Read Directory Entry From Tape

**********************************************************************/

rdde (p)	dirent *p;

	{int i,c;
	char *s;

	p->realname[0] = 0;
	checksum = 0;
	c = get8();
	if (c==0)	/* empty entry */
		{i = 63;
		while (i--) get8();
		return (1);
		}
	s = p->name;
	*s++ = c;
	i = 31;
	while (i--) *s++ = get8();
	p->mode = get16();
	p->uid = get8();
	p->gid = get8();
	p->size = get32();
	p->time = get32();
	p->tapa = get16();
	i = 8;
	while (i--) get16();
	i = checksum;
	if (i != (-get16() & 0177777)) return (-1);
	return (0);
	}

/**********************************************************************

	RDIREC - Read Directory From Tape

**********************************************************************/

rdir()

	{int i, c;
	dirent *p;

	if (d_read) return;	/* already read in */
	char_in_buffer = FALSE;
	open8 ();
	seek8 (1);		/* first block is empty */
	c = 0;			/* keep count of checksum errors */
	i = max_ent;		/* max_ent possible entries */

	direc.nentries = 0;
	p = direc.entries;

	while (--i >= 0)
		{switch (rdde(p)) {

	case -1:	++c;	/* fall through */
	case 0:		++p; ++direc.nentries; break;
	case 1:		break;
			}
		}
	if (c>0) cprint ("%d checksum errors\n", c);
	d_read = TRUE;
	}

/**********************************************************************

	ATOI - Convert String To Integer

**********************************************************************/

int atoi(s) char s[];

	{int i,f;
	char c;
	if (!s) return(0);
	i=f=0;
	if (*s=='-') {s++; f++;}
	while((c= *s++)>='0' && c<='9') i = i*10 + c-'0';
	return(f?-i:i);
	}

/**********************************************************************

	GETLINE - GET LINE FROM CURRENT FILE
	 return 1 if end of initial input

**********************************************************************/

getline (prompt, buf)	char prompt[], buf[];

	{char *p;
	int c;

	if (fin != cin) cprint ("X");
	cprint (prompt);
	rdline (buf, fin);
	if (ceof (fin))
		if (fin != cin)
			{cclose (fin);
			cprint ("Command file finished\n");
			fin = cin;
			return (getline (prompt, buf));
			}
		else return (1);
	if (merge_case)
		{p = buf;
		while (c = lower (*p)) *p++ = c;
		}
	if (fin != cin) cprint ("%s\n", buf);
	return (0);
	}

/**********************************************************************

	GET_LENGTH_AND_TIME

	Get length of file (in characters) ands its modification
	time.  Return TRUE iff an error occurs.

**********************************************************************/

int get_length_and_time (s, pl, pt)
	char *s;
	int *pl, *pt;

	{int f, count;
	cal cd;

	f = copen (s, 'r');
	if (f == -1)
		{cprint ("Can't open %s\n", s);
		return (TRUE);
		}
	f2cal (rfdate (itschan (f)), &cd);
	*pt = cal2u (&cd);
	count = 0;
	cgetc (f);
	while (!ceof (f)) {++count; cgetc (f);}
	cclose (f);
	*pl = count;
	return (FALSE);
	}

/**********************************************************************

	SET_DEFAULT_DIRECTORY

**********************************************************************/

set_default_directory (s)
	char *s;

	{filespec f;

	fparse (s, &f);
	ssname (f.dir);
	}

/**********************************************************************

	RDLINE

**********************************************************************/

rdline (buf, f)
	char *buf;

	{int c;

	while ((c = cgetc (f)) != '\n' && c) *buf++ = c;
	*buf = 0;
	}

/**********************************************************************

	EXTRACT - Extract short name from full file name.

**********************************************************************/

extract (realname, name)
	char *realname, *name;

	{char *s;
	int c;

	s = realname;
	while (*s) ++s;
	while (s>realname)
		{c = *s;
		if (c == '/') {++s; break;}
		--s;
		}
	stcpy (s, name);
	}

/**********************************************************************

	LCOMMANDS - List Commands

**********************************************************************/

lcommands ()

	{cprint (
"UNIX Magtape Handler\n\
Commands:\n\
\tl - list tape directory (UNIX format)\n\
\tr - read files from tape (UNIX format)\n\
\tra - read all files from tape (UNIX format)\n\
\ti - initialize an empty tape (UNIX format)\n\
\tu - update a tape (UNIX format)\n\
\tq - quit\n\
\th - set default directory\n\
\trf - read file from tape (text mode)\n\
\twf - write file to tape (text mode)\n\
\trt - read entire tape (image mode)\n\
\twt - write entire tape (image mode)\n\
\tx - execute command file\n\
\tc - switch case handling\n");
	}

