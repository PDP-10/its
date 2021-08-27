# define NBPW 32

struct _fchar {
	int width;	/* raster width */
	int height;	/* raster height */
	int lefthang;	/* amount raster extends left of character */
	int righthang;	/* amount raster extends right of character */
	int *raster;	/* raster bit array */
	};
# define fchar struct _fchar

struct _font {
	int kstid;
	int height;
	int baseline;
	int colpos;
	fchar chars[128];
	};
# define font struct _font

extern int cerr;
font x, y;
int debug;

main (argc, argv)
	char **argv;

	{extern int cin, cout;
	int c, n, filter;

	--argc;
	++argv;
	n = 2;
	filter = 0;
	if (argc>0)
		{c = argv[0][0];
		if (c=='d') debug = 1;
		if (c=='f') filter = 1;
		else if (c > '0' && c < '9') n = c - '0';
		}
	rfont (&x, cin);
	times (&x, &y, n);
	if (filter) smooth (&y);
	wfont (&y, cout);
	}

rfont (f, s)
	font *f;

	{int i;
	fchar *fc;

	f->kstid = rdint (s);
	f->height = rdint (s);
	f->baseline = rdint (s);
	f->colpos = rdint (s);
	for (i=0;i<128;++i) f->chars[i].width = 0;
	while (rdraster (f, s));
	return (0);
	}

int rdint (s)

	{int i, c;

	c = cgetc (s);
	i = 0;
	while (c >= '0' && c <= '9')
		{i = (i * 10) + (c - '0');
		c = cgetc (s);
		}
	while (c > 0 && c != '\n') c = cgetc (s);
	return (i);
	}

int rdoctal (s)

	{int i, c;

	c = cgetc (s);
	i = 0;
	while (c == '\p') c = cgetc (s);
	while (c >= '0' && c <= '7')
		{i = (i * 8) + (c - '0');
		c = cgetc (s);
		}
	while (c > 0 && c != '\n') c = cgetc (s);
	return (i);
	}

int rdraster (f, s)
	font *f;

	{int code, size, height, width, row, col, end, left, right;
	int lefthang, righthang;
	int *temp, *p, *q, nwords;
	fchar *fc;

	code = rdoctal (s);
	if (ceof (s)) return (0);
	if (code < 0 || code >= 128)
		{cprint (cerr, "bad char code: %d\n", code);
		return (0);
		}
	fc = &(f->chars[code]);
	fc->width = rdint (s);		/* raster width */
	width = rdint (s);		/* logical width */

	lefthang = rdint (s);		/* left kern */
	left = 0;
	if (lefthang < 0)
		{left = -lefthang;
		lefthang = 0;
		}
	else if (lefthang > 0) width =+ lefthang;

	right = left + fc->width;
	righthang = 0;
	if (right > width)
		{righthang = right - width;
		width =+ righthang;
		}

	height = 2 * f->height;		/* fudge factor */
	size = height * width;
	temp = p = salloc ((size + (NBPW-1)) / NBPW);
	end = 0;
	for (row = 0; row < height && !end; ++row)
		{for (col = 0; col < width && !end; ++col)
			{if (col < left) continue;
			switch (cgetc (s)) {
			case ' ':	continue;
			case '\n':	col = width; continue;
			case 0:
			case '\p':	end = 1; continue;
			default:	bset (p, row*width+col);
					continue;
				}
			}
		}
	if (col > 0) ++row;
	fc->height = height = row;
	fc->lefthang = lefthang;
	fc->righthang = righthang;
	fc->width = width;
	size = height * width;
	nwords = (size + (NBPW-1)) / NBPW;
	fc->raster = q = salloc (nwords);
	while (--nwords >= 0) *q++ = *p++;
	sfree (temp);
	if (debug)
		cprint (cerr, "Code %o: [%d, %d, %d]\n",
			lefthang, righthang, width);
	return (1);
	}

wfont (f, s)
	font *f;

	{int i;

	cprint ("%d KSTID\n", f->kstid);
	cprint ("%d HEIGHT\n", f->height);
	cprint ("%d BASELINE\n", f->baseline);
	cprint ("%d COLUMN POSITION\n", f->colpos);
	for (i=0;i<128;++i) praster (f, i, s);
	}

praster (f, code, s)
	font *f;

	{int size, height, width, row, col, spaces;
	int *p;
	fchar *fc;

	fc = &(f->chars[code]);
	width = fc->width;
	if (width == 0) return;

	cprint ("\p%o CHARACTER CODE\n", code);
	cprint ("%d RASTER WIDTH\n", fc->width);
	cprint ("%d CHARACTER WIDTH\n", width - fc->lefthang - fc->righthang);
	cprint ("%d LEFT KERN\n", fc->lefthang);

	height = fc->height;
	size = height * width;
	p = fc->raster;
	for (row = 0; row < height; ++row)
		{spaces = 0;
		for (col = 0; col < width; ++col)
			if (bget (p, row*width+col))
				{while (spaces > 0)
					{cprint (" ");
					--spaces;
					}
				cprint ("@");
				}
			else ++spaces;
		cprint ("\n");
		}
	}


times (f1, f2, n)
	font *f1, *f2;

	{int code, *p1, *p2, row, col, width, height, size, width1;
	fchar *fc1, *fc2;

	f2->kstid = f1->kstid;
	f2->height = n*f1->height;
	f2->baseline = n*f1->baseline;
	f2->colpos = n*f1->colpos;
	
	for (code=0;code<128;++code)
		{fc1 = &(f1->chars[code]);
		fc2 = &(f2->chars[code]);
		width = fc2->width = n*(width1 = fc1->width);
		fc2->lefthang = n*fc1->lefthang;
		fc2->righthang = n*fc1->righthang;
		fc2->height = height = n*fc1->height;
		size = height * width;
		p1 = fc1->raster;
		fc2->raster = p2 = salloc ((size + (NBPW-1)) / NBPW);
		for (row = 0; row < height; ++row)
			for (col = 0; col < width; ++col)
				if (bget (p1, (row/n)*width1 + (col/n)))
					bset (p2, row*width+col);
		}
	}

smooth (f)
	font *f;

	{int code, i, j, io, jo, height, width, *old, *new, *p, *q;
	int nwords, size;
	fchar *fc;

	for (code = 0; code < 128; ++ code)
		{fc = &(f->chars[code]);
		height = fc->height;
		width = fc->width;
		old = fc->raster;
		size = height*width;
		nwords = (size + (NBPW - 1)) / NBPW;
		new = salloc (nwords);
		p = old;
		q = new;
		i = nwords;
		while (--i >= 0) *q++ = *p++;

# macro fetch (x, y)
	bget (old, (x)*width+(y))

# end

		for (i = 1; i < height-1; ++i)
			for (j = 1; j < width-1; ++j)
				{io = (i%2 ? 1 : -1);
				jo = (j%2 ? 1 : -1);
				if (fetch (i,j) == 0 &&
				    fetch (i-io,j) == 0 &&
				    fetch (i-io,j-jo) == 0 &&
				    fetch (i,j-jo) == 0)
				if (fetch (i-io,j+jo) &&
				    fetch (i,j+jo) &&
				    fetch (i+io,j+jo) &&
				    fetch (i+io,j) &&
				    fetch (i+io,j-jo))
					bset (new, i*width+j);
				}
		fc->raster = new;
		sfree (old);
		}
	}
