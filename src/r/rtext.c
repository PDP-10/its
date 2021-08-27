# include "r.h"

/*

	R Text Formatter
	Text Word Routines

	Copyright (c) 1976, 1977 by Alan Snyder


	ROUTINES:

	c = build_text_word (c, w)	build text, given first
					character
	text_width (w)			return width of text word
	text_ha (w)			return height above baseline
	text_hb (w)			return height below baseline
	output_text (w, hp)		output word given the
					horizontal position
	isul (w)			is word an underline?
	text_init ()			initialization


	INTERNAL ROUTINES:

	ostext (p)		output non-overstruck text word
	ootext (p, hp)		output overstruck text word
	reset_overprint ()	reset for word with overprinting
	setup_overprint ()	set up for word with overprinting
	ocinsert (c)		insert character with overprinting
	ocappend (c)		append character with overprinting
	move_up (p, q, n)	move block of words
	gc ()			word garbage collector
	trcwords (f)		trace accessible words, apply f
	text_mark (w)		mark text word for GC
	text_update (&w)	update reference for GC
	move_word (s, d)	move word from s to d

	REPRESENTATION OF A TEXT WORD:

	The VAL of a text word is an index into the array TCSTORE.
	This index points to the first of a sequence of INTs making
	up the word, as follows:

	0:	width of word (in HU)
	1:	max height of word above baseline (in VU)
	2:	max height of word below baseline (in VU)
	3:	reserved for GC

	Following is a sequence of INTs, terminated by a zero.  There
	are two formats, depending upon whether or not there is
	overprinting in the word.

	FORMAT 1: NO OVERPRINTING

	The sequence consists of TCHARS, where a TCHAR is ONEOF:

		TCUL n		change underlining to (n & 01)
		TCFONT n	change to font 'n'
		TCVOFF v	change vertical offset to 'v'
		TCCHAR c	output the character c

	The initial FONT and VOFF are zero and UL is off.  Note that
	no TCHAR has an integer value of zero (that's why the hacked
	representation of TCUL).

	FORMAT 2: OVERPRINTING

	The sequence consists of a -1 (to distinguish it from the
	format 1), followed by some number of character position
	descriptions.  Each character position description consists
	of an int N giving the number of characters in the position
	(greater than 0), followed by the width of the character
	position plus 1, followed by N OCHARS.  An OCHAR consists
	of two words, described as follows (right adjusted in 16
	bits):

	ochar = struct {int tag1:1, voff:14;
			int tag2:1, :1, ul:1, font:4, char:8};

	The tags are always 1, so that no int is zero.

*/

# define TWHEAD 4		/* number of header words */

# define tchar int
# define TCUL 0
# define TCFONT 1
# define TCVOFF 2
# define TCCHAR 3
# define TCOMASK 03

# define TCSHIFT 14
# define TCVMASK 037777

# ifndef BIGLONG
# ifdef BIGWORD
# define TCSHIFT 16
# define TCVMASK 0177777
# endif
# endif

# define OCSIZE 2
# define OCMASK 037777
# define OCTAG 040000

# ifndef BIGLONG
# ifdef BIGWORD
# define OCMASK 0177777
# define OCTAG 0200000
# endif
# endif

# define ULMASK 01
# define FONTMASK 017
# define CHARMASK 0377
# define CHARSIZE 8
# define FONTSIZE 4

# define tchar_cons(t,v) (((t)<<TCSHIFT)|(v))
# define tchar_type(x) (((x)>>TCSHIFT)&TCOMASK)
# define tchar_val(x) ((x)&TCVMASK)
# define mako1(voff) (OCTAG | (voff))
# define mako2(ul,f,c) ((((((ul)<<FONTSIZE)|(f))<<CHARSIZE)|(c))|OCTAG)

# define appul(u) *wp++ = tchar_cons (TCUL, (u)|02)
# define appfont(f) *wp++ = tchar_cons (TCFONT, (f))
# define appvoff(v) *wp++ = tchar_cons (TCVOFF, (v))
# define appchar(c) *wp++ = tchar_cons (TCCHAR, (c))
# define appo1(voff) *wp++ = mako1 (voff)
# define appo2(ul,f,c) *wp++ = mako2 (ul, f, c)

int	tcstore[tcstore_size];	/* holds reps of all text words */

int	*wp {tcstore};		/* current position in tcstore */
int	*gcwp;			/* trigger GC position */
int	*ewp;			/* overflow position */
int	wwval;			/* "value" of current word */
int	*wsp;			/* pointer to first text of current word */
int	overprint;		/* true if overprinting on this word */
int	w_ha;			/* current HA of word under construction */
int	w_hb;			/* current HB of word under construction */
int	w_width;		/* current width of word under construction */

	/* variables used only if overprinting in current word */

int	ccol;			/* current column number in word */
int	maxcol;			/* maximum value of ccol */
int	wcol;			/* "working" column number */
int	*wcolp;			/* points to rep of "working" column */
int	bserr_flag;		/* BS error already printed for this word */

	/* variables for garbage collection */

word	gcw;			/* word traced by GC if not -1 */
int	nwords;			/* number of words marked */
int	*gc_tab[gc_tab_size];	/* table of marked words */

	/* variables for communication with output routines */
	/* these are essentially extra parameters to output_char */

int	tul;			/* underline mode */
int	tfont;			/* font */
int	tvoff;			/* vertical offset */

extern	int	trt[];		/* translation table */
extern	int	gc_time, Zngc, Zngcw, f2trace, cc_type[], device,
		superfactor;
extern	env	*e;

/**********************************************************************

	TEXT_INIT - Initialization Routine

**********************************************************************/

int	text_init ()

	{ewp = tcstore+tcstore_size;
	gcwp = ewp - 200;
	}

/**********************************************************************

	BUILD_TEXT_WORD - Build text word, given first character and
	optional text word to append to.
	Place text word on queue, return following character.

**********************************************************************/

ichar build_text_word (ic, w)
	ichar ic;
	word w;

	{int	ct, f, v, ty, need_update, voff, *q, tt, lastc;

	/* initialization */

	gcw = w;		/* in case a GC happens */
	if (wp >= gcwp) gc ();
	wwval = wp - tcstore;
	wp[3] = 0;
	wsp = (wp =+ TWHEAD);
	overprint = FALSE;
	need_update = TRUE;

	if (w == -1)	/* initialize for new word */
		{w_ha = w_hb = w_width = lastc = 0;
		if (e->ifont != 0) appfont (e->ifont);
		if (e->iul != 0) appul (e->iul);
		if (e->ivoff != -min_voff) appvoff (e->ivoff);
		}
	else		/* initialize for appending to old word */
		{if (w < 0 || w >= tcstore_size)
			bletch ("BUILD_TEXT_WORD: bad argument");
		q = &tcstore[w];
		w_width = q[0];
		w_ha = q[1];
		w_hb = q[2];
		q =+ TWHEAD;
		while (tt = *q++)
			{*wp++ = tt;
			if (wp>=ewp) fatal("^G'ed word too long");
			/* can't GC here ... we have a reference in hand */
			}
		reset_overprint ();
		if (!overprint)
			{appfont (e->ifont);
			appul (e->iul);
			appvoff (e->ivoff);
			}
		gcw = -1;	/* don't need it anymore */
		if (e->end_of_sentence) lastc = '.'; else lastc = 0;
		}

	do	/* loop until break character is read */
		/* don't trace a break character */

		{v = ichar_val (ic);
		if ((ty = ichar_type (ic)) == i_control)
			{if ((ct = cc_type[v]) == cc_separator) goto done;
			if (ct == cc_universal) goto done;
			}
		trace_character (ic);

		switch (ty) {

case i_control:	switch (v) {

	case 'f':	ic = getc2 ();
			trace_character (ic);
			if (ic == '*') f = popfont ();
			else
				{f = fontid (ic);
				if (f == -1)
					{error ("invalid font (^F) specification: %i",
						ic);
					continue;
					}
				pushfont (e->ifont);
				}
			set_cfont (f);
			if (!overprint) appfont (e->ifont);
			need_update = TRUE;
			continue;

	case 'v':	readvoff ();
			chkvoff ();
			if (!overprint) appvoff (e->ivoff);
			need_update = TRUE;
			continue;

	case 'u':	v = font_ha (e->pfont) / superfactor;
			e->ivoff =+ v;
			if (!overprint) appvoff (e->ivoff);
			need_update = TRUE;
			continue;

	case 'd':	v = font_ha (e->pfont) / superfactor;
			e->ivoff =- v;
			if (!overprint) appvoff (e->ivoff);
			need_update = TRUE;
			continue;

	case 'z':	e->ivoff = -min_voff;
			if (!overprint) appvoff (e->ivoff);
			need_update = TRUE;
			continue;

	case 'b':	e->iul = TRUE;
			if (!overprint) appul (TRUE);
			continue;

	case 'e':	e->iul = FALSE;
			if (!overprint) appul (FALSE);
			continue;

	case 'h':	if (!overprint) setup_overprint ();
			if (ccol==0)
				{if (bserr_flag)
				   error ("backspace past beginning of word");
				bserr_flag = TRUE;
				}
			else --ccol;
			continue;

	default:	error ("unrecognized control character '%c' in word",
				v);
			continue;
			}

case i_text:	lastc = v = trt[v];
		if (overprint)
			{if (ccol <= maxcol) ocinsert (v);
			else ocappend (v);
			++ccol;
			}
		else
			{appchar (v);
			w_width =+ font_width (e->ifont, v);
			}
		if (wp >= gcwp) gc ();
		if (need_update) /* recompute ha and hb */
			{voff = (e->ivoff + min_voff);	/* real VOFF */
			if ((tt = font_ha (e->ifont) + voff) > w_ha) w_ha = tt;
			if ((tt = font_hb (e->ifont) - voff) > w_hb) w_hb = tt;
			}
		continue;
default:	error ("protected control character '%c' in text", v);
		continue;
			}
		}
		/* loop ends here */
		while (ic = getc2 ());

	/* finalization */

done:	e->end_of_sentence = (lastc=='.' || lastc=='?' || lastc=='!');
	wsp[-4] = w_width;
	wsp[-3] = w_ha;
	wsp[-2] = w_hb;
	*wp++ = 0;
	wsp = wp;
	overprint = FALSE;
	return (ic);
	}

/**********************************************************************

	TEXT_WIDTH - Return width of text word.

**********************************************************************/

# ifndef USE_MACROS

int text_width (w)	word w;

	{return (tcstore[w]);
	}

/**********************************************************************

	TEXT_HA	- Return height of text word above baseline.

**********************************************************************/

int text_ha (w)		word w;

	{return (tcstore[w+1]);
	}

/**********************************************************************

	TEXT_HB	- Return height of text word below baseline.

**********************************************************************/

int text_hb (w)		word w;

	{return (tcstore[w+2]);
	}

# endif /* USE_MACROS */

/**********************************************************************

	OUTPUT_TEXT - Output text word given the horizontal position.

**********************************************************************/

output_text (w, hp)	word w;

	{int	*p;		/* pointer into TCSTORE */

	p = tcstore + w + TWHEAD;
	if (p[0] == -1) ootext (p+1, hp);
	else ostext (p);
	output_eow ();
	}

/**********************************************************************

	ISUL - Is word an underline?

**********************************************************************/

int isul (w) word (w);

	{register tchar *p, tc;
	int c;

	if (w < 0 || w >= tcstore_size)
		{barf ("ISUL: bad argument");
		return (FALSE);
		}
	p = tcstore + w + TWHEAD;
	if (p[0] == -1) return (FALSE);
	c = -1;
	while (tc = *p++)
		{switch (tchar_type (tc)) {
	case TCUL:
	case TCFONT:
	case TCVOFF:	continue;
	case TCCHAR:	if (c != -1) return (FALSE);
			c = tchar_val (tc);
			continue;
			}
		}
	return (c == '_');
	}

/**********************************************************************

	OSTEXT - Output straight text (no overprinting)

**********************************************************************/

ostext (p) register int *p;

	{register tchar tc;		/* TCHAR being processed */
	register int val;		/* current TCHAR value */

	tfont = tul = 0;
	tvoff = -min_voff;
	while (tc = *p++)
		{val = tchar_val (tc);
		switch (tchar_type (tc)) {

case TCUL:	tul = val & 01; continue;
case TCFONT:	tfont = val; continue;
case TCVOFF:	tvoff = val; continue;
case TCCHAR:	output_char (val); continue;
default:	barf ("OSTEXT: bad TCHAR type");
			}
		}
	}

/**********************************************************************

	OOTEXT - Output overstruck text.

**********************************************************************/

ootext (p, hp) register int *p;

	{int	thp;		/* temp horizontal position for overprint */
	int	o2;		/* 2nd word of OCHAR being processed */
	int	n;		/* counter of chars overprinted in one column */
	int	w1;		/* width of overprinted column */
	int	w2;		/* width of character in overprinted column */
	int	s;		/* space needed to center overprinted char */

	while (n = *p++)
		{if (n > 100)
			{barf ("OOTEXT: strange overstruck word");
			return;
			}
		w1 = *p++ - 1;
		thp = hp;
		while (--n >= 0)
			{tvoff = (*p++) & OCMASK;
			o2 = *p++;
			tul = (o2 >> (CHARSIZE+FONTSIZE)) & ULMASK;
			tfont = (o2 >> CHARSIZE) & FONTMASK;
			o2 =& CHARMASK;
			w2 = font_width (tfont, o2);
			s = (w1-w2) >> 1;
			if (s<0) barf ("OOTEXT: overstrike error");
			output_space (hp+s-thp, hp+s);
			output_char (o2);
			thp = hp + s + w2;
			}
		hp =+ w1;
		output_space (hp-thp, hp);
		}
	}

/**********************************************************************

	RESET_OVERPRINT - Reestablish overprint data base for
		word being concatenated to.

**********************************************************************/

reset_overprint ()

	{int *p;

	if (*wsp != -1) return;
	overprint = TRUE;
	ccol = 0;
	p = wcolp = wsp + 1;
	while (wcolp < wp)
		{p = wcolp;
		wcolp =+ (2 + (*wcolp * OCSIZE));
		++ccol;
		}
	maxcol = wcol = ccol - 1;
	wcolp = p;
	bserr_flag = FALSE;
	}

/**********************************************************************

	SETUP_OVERPRINT

**********************************************************************/

setup_overprint ()

	{int font, ul, voff, v;
	register int *p;
	register tchar tc;

	*wp++ = 0;
	wwval = wp-tcstore;
	p = wsp-TWHEAD;
	while (p < wsp) *wp++ = *p++;
	wsp = wp;
	*wp++ = -1;
	ul = font = 0;
	voff = -min_voff;
	ccol = 0;
	while (tc = *p++)
		{v = tchar_val (tc);
		switch (tchar_type (tc)) {
	case TCUL:	ul = v & 01; continue;
	case TCFONT:	font = v; continue;
	case TCVOFF:	voff = v; continue;
	case TCCHAR:	++ccol;
			wcolp = wp;
			*wp++ = 1;
			*wp++ = font_width (font, v) + 1;
			appo1 (voff);
			appo2 (ul, font, v);
			continue;
			}
		}
	wcol = maxcol = ccol - 1;
	bserr_flag = FALSE;
	overprint = TRUE;
	}

/**********************************************************************

	OCINSERT - Insert OCHAR into middle of word.

**********************************************************************/

ocinsert (c)

	{int n, delta;
	register int *p;

	if (wp >= gcwp) gc ();
	if (ccol < wcol)
		{wcol = 0;
		wcolp = wsp + 1;
		}
	while (wcol < ccol)
		{wcolp =+ (2 + (*wcolp * OCSIZE));
		++wcol;
		}
	n = wcolp[0]++;
	p = wcolp + 2 + (n*OCSIZE);
	move_up (p, wp-1, OCSIZE);
	p[0] = mako1 (e->ivoff);
	p[1] = mako2 (e->iul, e->ifont, c);
	wp =+ OCSIZE;
	delta = font_width (e->ifont, c) + 1 - wcolp[1];
	if (delta > 0)
		{wcolp[1] =+ delta;
		w_width =+ delta;
		}
	}

/**********************************************************************

	OCAPPEND - Append OCHAR to end of word.

**********************************************************************/

ocappend (c)

	{int width;

	width = font_width (e->ifont, c);
	*wp++ = 1;
	*wp++ = width + 1;
	appo1 (e->ivoff);
	appo2 (e->iul, e->ifont, c);
	w_width =+ width;
	maxcol = ccol;
	}

/**********************************************************************

	MOVE_UP

	Move a block of words from P to Q up by N words.

**********************************************************************/

move_up (p, q, n) register int *p, *q;

	{register int *r;
	r = q + n;
	while (q >= p) *r-- = *q--;
	}

/**********************************************************************

	GC -- word garbage collector

**********************************************************************/

gc ()

	{extern env *env_tab[];
	int i, start_time;
	int *l, *q, *r, *move_word(), text_mark(), text_update();
	register int **pp, **qq, **rr;

	++Zngc;
	start_time = cputm ();
	nwords = 0;

	/* mark */

	trcwords (text_mark);

	/* compute new locations of valid text words */

	l = tcstore;
	if (nwords <= gc_tab_size)	/* all in table! */
		{rr = &gc_tab[nwords];
		for (pp=gc_tab;pp<rr-1;++pp)
			for (qq=pp+1;qq<rr;++qq)
				if (*qq<*pp)
					{r = *pp;
					*pp = *qq;
					*qq = r;
					}
		for (i=0;i<nwords;++i)
			{r = (q = gc_tab[i]) + 3;
			if (!*r) bletch ("GC: word table incorrect");
			*r = l;
			while (*++r);
			++r;
			l =+ (r-q);
			}
		}
	else	/* table overflowed, must sweep */
		{q = tcstore;
		while (q < wp)
			{r = q+3;
			if (*r) /* marked? */
				{*r = l;
				while (*++r);
				++r;
				l =+ (r-q);
				q = r;
				}
			else
				{q =+ TWHEAD;
				while (*q++);
				}
			}
		}

	/* update references */

	trcwords (text_update);

	/* recompact */

	l = tcstore;
	if (nwords <= gc_tab_size)	/* all in table! */
		for (i=0;i<nwords;++i)
			l = move_word (gc_tab[i], l);
	else
		{q = tcstore;
		while (q < wp)
			{if (q[3]) l = move_word (q, l);
			q =+ TWHEAD;
			while (*q++);
			}
		}

	if (wsp < wp)
		{q = wsp-TWHEAD;
		wsp = l+TWHEAD;
		wwval = l-tcstore;
		i = q - l;
		if (i < 0 || i >= tcstore_size)
			bletch ("GC: bad wsp or wp");
		while (q < wp) *l++ = *q++;
		if (overprint) wcolp =- i;
		}
	wp = l;
	if (wp < tcstore || wp >= tcstore+tcstore_size)
		bletch ("GC: bad new wp");
	if (wp >= gcwp) fatal ("word storage overflow");
	gc_time =+ (cputm () - start_time);
	Zngcw =+ nwords;
	}

/**********************************************************************

	TRCWORDS - Trace accessible words and apply function given
		word location.

**********************************************************************/

trcwords (f) int (*f)();

	{int i, j, t;
	register token w, *ww;
	env *ee;

	if (gcw != -1)
		{gcw = token_cons (t_text, gcw);
		(*f)(&gcw);
		gcw = token_val (gcw);
		}
	for (i=0;i<max_env;++i)
		{if (ee = env_tab[i])
			{j = ee->tn;
			ww = &ee->line_buf[0];
			while (--j >= 0)
				{w = *ww;
				t = token_type (w);
				if (t == t_text || t == t_tabc) (*f)(ww);
				++ww;
				}
			}
		}
	}

/**********************************************************************

	TEXT_MARK - mark text word

**********************************************************************/

text_mark (ww) token *ww;

	{register int i, *p;

	p = tcstore + token_val (*ww);
	if (p[3]==0)
		{p[3] = -1;
		i = nwords;
		if (++nwords <= gc_tab_size) gc_tab[i] = p;
		}
	}

/**********************************************************************

	TEXT_UPDATE

**********************************************************************/

text_update (ww) token *ww;

	{register token w;
	register int *p;
	int *q;

	w = *ww;
	p = tcstore + token_val (w);
	q = p[3];
	*ww = token_cons (token_type (w), q-tcstore);
	}

/**********************************************************************

	MOVE_WORD - internal GC routine

**********************************************************************/

int *move_word (q, l)
	register int *q;	/* source */
	int *l;			/* destination */

	{register int *r;
	r = q[3];
	if (r != l) bletch ("MOVE_WORD: GC phase error");
	r[0] = q[0];
	r[1] = q[1];
	r[2] = q[2];
	r[3] = 0;
	r =+ TWHEAD;
	q =+ TWHEAD;
	while (*r++ = *q++);
	return (r);
	}

