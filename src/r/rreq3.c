# include "r.h"

/*

	R Text Formatter
	More Request Handlers

	Copyright (c) 1976, 1977 by Alan Snyder


*/

extern int allow_neg, device, cin, cout;
extern env *e;
ichar svscan ();

dv_com ()

	{idn	name;
	int	i;
	extern	idn dev_tab[];

	name = get_name ();
	if (name < 0) return;
	for (i=0;i<ndev;++i) if (name==dev_tab[i])
		{device = i;
		return;
		}
	error ("unrecognized device '%s'", idn_string (name));
	}

fo_com ()

	{int	n;
	ac	s;

	n = get_font (-1);
	s = get_text ();
	if (n >= 0) set_font (n, ac_string (s));
	ac_unlink (s);
	}

fs_com ()

	{int n;

	n = get_font (-1000);
	if (n != -1)
		{if (n == -1000) n = popfont ();
		else pushfont (e->ifont);
		set_cfont (n);
		set_pfont (n);
		}
	}

so_com ()

	{ac	s;
	int	f;
	char buffer[FNSIZE];

	s = get_text ();
	getc1 ();
	f = openread (ac_string (s), buffer);
	if (f != OPENLOSS) push_file (f, ac_create (buffer));
	else error ("unable to open '%a'", s);
	ac_unlink (s);
	push_char (i_newline);
	}

nx_com ()

	{ac	s;
	int	f;
	char buffer[FNSIZE];

	s = get_text ();
	pop_file ();
	if (ac_size (s) > 0)
		{f = openread (ac_string (s), buffer);
		if (f != OPENLOSS) push_file (f, ac_create (buffer));
		else error ("unable to open '%a'", s);
		}
	ac_unlink (s);
	push_char (i_newline);
	}
	
tm_com ()

	{ac s;

	s = get_text ();
	cprint ("%a\n", s);
	ac_unlink (s);
	}

rl_com ()

	{idn name;	/* string register being defined */
	ac s;		/* message printed */
	char buf[200];	/* input */

	name = get_name ();
	s = get_text ();
	if (name >= 0)
		{cprint ("%a", s);
		gets (buf);
		sr_enter (name, ac_create (buf));
		}
	ac_unlink (s);
	}

rd_com ()

	{ac s;

	s = get_text ();
	getc1 (); 
	if (ac_size (s) > 0) cprint ("%a\n", s);
	else cputc (07, cout);
	push_file (cin, 0);
	push_char (i_newline);
	ac_unlink (s);
	}

nr_com ()

	{idn	name;	/* number register name */
	int	n;	/* new value */

	name = get_name ();
	n = get_int (0, 0);
	if (name >= 0) nr_enter (name, n);
	}

xn_com ()

	{idn	name;	/* number register name */

	name = get_name ();
	if (name >= 0) nr_undef (name);
	}

sr_com ()

	{idn	name;	/* string register name */
	ac	s;	/* new value */

	name = get_name ();
	s = get_string ();
	if (name >= 0) sr_enter (name, ac_trim (s));
	else ac_unlink (s);
	}

xs_com ()

	{idn	name;	/* string register name */

	name = get_name ();
	if (name >= 0) sr_undef (name);
	}

nd_com ()

	{idn	name;	/* number register name */
	int	n;	/* new value */

	name = get_name ();
	n = get_int (0, 0);
	if (name >= 0 && nr_find (name) < 0) nr_enter (name, n);
	}

sd_com ()

	{idn	name;	/* string register name */
	ac	s;	/* new value */

	name = get_name ();
	s = get_string ();
	if (name >= 0 && sr_find (name) < 0) sr_enter (name, ac_trim (s));
	else ac_unlink (s);
	}

nv_com ()

	{idn	name;	/* number register name */
	int	n;	/* new value */

	name = get_name ();
	n = get_int (0, 0);
	if (name >= 0) nv_define (name, n);
	}

sv_com ()

	{idn	name;	/* string register name */
	ac	s;	/* new value */

	name = get_name ();
	s = get_string ();
	if (name >= 0) sv_define (name, s);
	else ac_unlink (s);
	}

hx_com ()

	{register idn name, val;

	name = get_name ();
	val = rdhx ();
	if (name >= 0) nr_enter (name, hu2mil (val));
	}

hv_com ()

	{register idn name, val;

	name = get_name ();
	val = rdhx ();
	if (name >= 0) nv_define (name, hu2mil (val));
	}

int rdhx()

	{register int sum, h;
	sum = 0;
	allow_neg = TRUE;
	while ((h = get_hu (-infinity, 0)) != -infinity) sum =+ h;
	allow_neg = FALSE;
	return (sum);
	}

vx_com ()

	{register idn name, val;

	name = get_name ();
	val = rdvx ();
	if (name >= 0) nr_enter (name, vu2mil (val));
	}

vv_com ()

	{register idn name, val;

	name = get_name ();
	val = rdvx ();
	if (name >= 0) nv_define (name, vu2mil (val));
	}

int rdvx()

	{register int sum, v;
	sum = 0;
	allow_neg = TRUE;
	while ((v = get_vu (-infinity, 0)) != -infinity) sum =+ v;
	allow_neg = FALSE;
	return (sum);
	}

sb_com ()

	{idn dest, source;
	int index, length, srclen;
	ac d, src;
	char *s, *end;

	dest = get_name ();
	if (dest == -1) return;
	source = get_name ();
	if (source == -1) return;
	index = get_int (1, 0);
	length = get_int (infinity, 0);
	src = sr_value (source);
	srclen = ac_size (src);
	s = ac_string (src);
	end = s + srclen;
	d = ac_new ();
	if (length > 0)
		{int i;
		if (index < 1) index = 1;
		i = 1;
		while (i < index)
			if (svscan (&s, end) == -1) break;
			else ++i;
		while (length > 0)
			{ichar c;
			c = svscan (&s, end);
			if (c == -1) break;
			append_char (d, c);
			--length;
			}
		}
	sr_enter (dest, d);
	ac_unlink (src);
	}

si_com ()

	{idn dest, source, pattern;
	int skip, index;
	ac src, pat;
	char *s, *p, *se, *pe;

	dest = get_name ();
	if (dest == -1) return;
	pattern = get_name ();
	if (pattern == -1) return;
	source = get_name ();
	if (source == -1) return;
	skip = get_int (0, 0);
	src = sr_value (source);
	pat = sr_value (pattern);
	s = ac_string (src);
	p = ac_string (pat);
	se = s + ac_size (src);
	pe = p + ac_size (pat);

	index = 1;
	ac_unlink (src);
	ac_unlink (pat);
	if (skip < 0) skip = 0;
	while (s < se)
		{char *ts, *tp;
		ichar cs, cp;
		ts = s;
		tp = p;
		while (TRUE)
			{cs = svscan (&ts, se);
			cp = svscan (&tp, pe);
			if (cs != cp || cp == -1) break;
			}
		if (cp == -1)
			if (--skip < 0)
				{nr_enter (dest, index);
				return;
				}
		++index;
		svscan (&s, se);
		}
	nr_enter (dest, 0);
	}

sc_com ()

	{idn dest, source1, source2;
	int len1, len2;
	ac s1, s2;
	char *p1, *p2;

	dest = get_name ();
	if (dest == -1) return;
	source1 = get_name ();
	if (source1 == -1) return;
	source2 = get_name ();
	if (source2 == -1) return;
	s1 = sr_value (source1);
	s2 = sr_value (source2);
	len1 = ac_size (s1);
	len2 = ac_size (s2);
	p1 = ac_string (s1);
	p2 = ac_string (s2);
	ac_unlink (s1);
	ac_unlink (s2);
	nr_enter (dest, svcomp (p1, p2, len1, len2));
	}

svcomp (p1, p2, len1, len2)
	char *p1, *p2;

	{char *e1, *e2;

	e1 = p1+len1;
	e2 = p2+len2;
	while (TRUE)
		{ichar c1, c2;
		c1 = svscan (&p1, e1);
		c2 = svscan (&p2, e2);
		if (c1 != c2)
			{if (c1 < c2) return (-1);
			return (1);
			}
		if (c1 == -1) return (0);
		}
	}

sl_com ()

	{idn dest, source;
	ac src;
	char *s, *end;
	int len;

	dest = get_name ();
	if (dest == -1) return;
	source = get_name ();
	if (source == -1) return;
	src = sr_value (source);
	s = ac_string (src);
	end = s + ac_size (src);
	len = 0;
	while (svscan (&s, end) != -1) ++len;
	ac_unlink (src);
	nr_enter (dest, len);
	}

ichar svscan (s, end)
	char **s, *end;

	{int c;
	if (*s >= end) return (-1);
	c = *(*s)++;
	if (c == '#')
		{c = *(*s)++;
		if (c == '0') return (ichar_cons (i_text, '#'));
		if (c > '0' && c <= '9')
			{int n;
			n = c - '0';
			c = *(*s)++;
			return (ichar_cons (i_protect + n, c));
			}
		if (c == ' ') return (ichar_cons (i_text, ' '));
		return (ichar_cons (i_control, c));
		}
	if (c == ' ') return (ichar_cons (i_control, ' '));
	return (ichar_cons (i_text, c));
	}

