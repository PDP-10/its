# include "r.h"

/*

	R Text Formatter
	Line Hacking Routines

	Copyright (c) 1976, 1977 by Alan Snyder


	ROUTINES:

	LineReset ()
	LineText (w)
	LineSpace (width)
	LineNLSpace (width)
	LineOffset (width)
	LineCenter ()
	LineRight ()
	LineGlue ()
	LineIGlue ()
	LinePos (pos)
	LineHPos (pos)
	LineTab ()
	LineTabc (w)
	LineNull ()
	LineBreak ()
	LineBrkjust ()
	LineFinish (rc)

	hack_line (a, n, rm)		do centering and right-flushing
	justify_line (a, n, rm)		justify right-margin
	append_token (tag, value)	append token to current line
	find_pos (a, i, n)		find POS in line
	find_right (a, i, n)		find RIGHT in line
	length_line (a, i, j)		determine width of line
	set_line ()			setup line parameters

*/

extern	env	*e;

extern	int	nsmode, vp, next_page_number, line_length, page_empty,
		lvpu;

/**********************************************************************

	LineReset - Reset environment for new line

**********************************************************************/

LineReset ()

	{if (e)
		{e->tn = e->ha = e->hb = 0;
		e->text_seen = FALSE;
		/* the following is just to make HP look reasonable */
		if (e->temp_indent >= 0) e->hp = e->temp_indent;
			else e->hp = e->indent;
		}
	}

/**********************************************************************

	LineText - add text word to line

**********************************************************************/

LineText (w)
	word w;

	{register int i;
	e->partial_word = 0;
	i = text_width (w);
	if (e->text_seen && e->filling && i+e->hp>e->rm)
		LineBrkjust ();
	if (!e->text_seen) set_line ();
	e->hp =+ i;
	LIAText (t_text, w);
	}

/**********************************************************************

	LineSpace

**********************************************************************/

LineSpace (width)
	int width;

	{e->partial_word = 0;
	if (!e->text_seen) set_line ();
	append_token (t_space, width);
	e->hp =+ width;
	}

/**********************************************************************

	LineNLSpace

**********************************************************************/

LineNLSpace (width)
	int width;

	{e->partial_word = 0;
	if (!e->text_seen) set_line ();
	append_token (t_nlspace, width);
	e->hp =+ width;
	}

/**********************************************************************

	LineOffset

**********************************************************************/

LineOffset (width)
	int width;

	{e->partial_word = 0;
	if (!e->text_seen) set_line ();
	if (width < -e->hp) width = -e->hp;
	append_token (t_offset, width + (WVMASK+1)/2);
	e->hp =+ width;
	}

/**********************************************************************

	LineCenter

**********************************************************************/

LineCenter ()

	{e->partial_word = 0;
	if (!e->text_seen) set_line ();
	append_token (t_center, 0);
	}

/**********************************************************************

	LineRight

**********************************************************************/

LineRight ()

	{e->partial_word = 0;
	if (!e->text_seen) set_line ();
	append_token (t_right, 0);
	}


/**********************************************************************

	LineGlue

**********************************************************************/

LineGlue ()

	{token t;
	e->partial_word = PWEATNL|PWCONCAT;
	if (!e->text_seen) return;
	t = e->line_buf[e->tn-1];
	if (token_type(t)==t_nlspace)
		{--e->tn;
		e->hp =- token_val(t);
		}
	}

/**********************************************************************

	LineIGlue

**********************************************************************/

LineIGlue ()

	{e->partial_word =| PWCONCAT;
	}

/**********************************************************************

	LinePos

**********************************************************************/

LinePos (pos)
	int pos;

	{e->partial_word = 0;
	if (!e->text_seen) set_line ();
	if (pos < e->hp) error ("^P position passed");
	e->hp =+ e->space_width;
	if (pos > e->hp) e->hp = pos;
	append_token (t_pos, e->hp);
	}

/**********************************************************************

	LineHPos

**********************************************************************/

LineHPos (pos)
	int pos;

	{e->partial_word = 0;
	if (!e->text_seen) set_line ();
	e->hp = pos;
	append_token (t_hpos, e->hp);
	}

/**********************************************************************

	LineTab

**********************************************************************/

LineTab ()

	{e->partial_word = 0;
	if (!e->text_seen) set_line ();
	e->hp = next_tab (e->hp);
	append_token (t_pos, e->hp);
	}

/**********************************************************************

	LineTabc

**********************************************************************/

LineTabc (w)
	word w;

	{e->partial_word = 0;
	if (!e->text_seen) set_line ();
	LIAText (t_tabc, w);
	}

/**********************************************************************

	LIAText - Add text word to line, updating HA and HB

**********************************************************************/

LIAText (t, w)
	int t;
	word w;

	{register int i;
	if ((i=text_ha (w)) > e->ha) e->ha = i;
	if ((i=text_hb (w)) > e->hb) e->hb = i;
	append_token (t, w);
	}

/**********************************************************************

	LineNull

**********************************************************************/

LineNull ()

	{e->partial_word = 0;
	if (!e->text_seen) set_line ();
	append_token (t_null, 0);
	}

/**********************************************************************

	LineBreak

**********************************************************************/

LineBreak ()

	{if (e->text_seen) LineFinish (FALSE);
	}

/**********************************************************************

	LineBrkjust

**********************************************************************/

LineBrkjust ()

	{if (e->text_seen) LineFinish (TRUE);
	}

/**********************************************************************

	LineFinish (internal routine)

**********************************************************************/

LineFinish (jflag)

	{nsmode = 'n';
	if (e->filling) trim_spaces ();
	if (e->tn == 0) return;
	hack_line (e->line_buf, e->tn, e->rm);
	if (current_adjust_mode () == a_both && (jflag || !e->filling))
		justify_line (e->line_buf, e->tn, e->rm);
	page_empty = FALSE;
	if (lvpu+e->ha > vp) vp = lvpu + e->ha; /* prevent overlap */
	output_line (e->line_buf, e->tn, e->ha, e->hb, vp);
	lvpu = vp + e->hb;
	new_vp (vp + (e->line_spacing * e->default_height + 49)/100);
	LineReset ();
	}

/**********************************************************************

	SET_LINE - Set relevant parameters for current line.

**********************************************************************/

set_line ()

	{if ((e->hp = e->temp_indent) >= 0) e->temp_indent = -1;
	else e->hp = e->indent;
	if (e->hp>0) append_token (t_pos, e->hp);
	switch (current_adjust_mode ()) {
		case a_right:
			append_token (t_right, 0); break;
		case a_center:
			append_token (t_center, 0); break;
			}
	e->rm = line_length - e->right_indent;
	e->text_seen = TRUE;
	}

/**********************************************************************

	TRIM_SPACES - Trim trailing spaces from line.

**********************************************************************/

trim_spaces ()

	{register int i, tag;
	register token t;
	i = e->tn-1;
	while (i >= 0)
		{t = e->line_buf[i];
		tag = token_type (t);
		if (tag != t_space &&
		    tag != t_nlspace &&
		    tag != t_offset) break;
		--i;
		e->hp =- token_val (t);
		}
	e->tn = i+1;
	}

/**********************************************************************

	HACK_LINE - HACK CENTERING AND RIGHT-FLUSHING

**********************************************************************/

hack_line (a, n, rm)	token a[]; int n, rm;

	{int	hp;		/* horizontal position */
	int	last_pos;	/* most recent POS, or 0 */
	token	w;		/* current token */
	int	val;		/* value of current token */
	int	i, j, k;	/* pointers into A */
	int	pos;		/* next POS, or Right Margin */
	int	len1, len2;	/* lengths of text in HU */
	int	fudge, fudge1;	/* fudge factors in HU */
	int	slack;		/* slack space in HU */

	hp = 0;
	last_pos = 0;

	for (i=0;i<n;++i)
		{w = a[i];
		val = token_val (w);
		switch (token_type (w)) {

case t_text:	hp =+ text_width (val);
		continue;

case t_space:
case t_nlspace:	hp =+ val;
		continue;

case t_offset:	hp =+ (val - (WVMASK+1)/2);
		continue;

case t_hpos:
case t_pos:	hp = last_pos = val;
		continue;

case t_center:	j = find_pos (a, i+1, n);
		if (j<0)	/* if no pos, append one */
			{pos = rm;
			a[j=n++] = token_cons (t_pos, pos);
			}
		else pos = token_val (a[j]);

		k = find_right (a, i+1, n);
		if (k>=0 && k<j)	/* centering and right flush */

			{len1 = length_line (a, i+1, k-1);	/* centered text */
			len2 = length_line (a, k+1, j-1); /* righted text */
			}

		else		/* centering but no right flush */

			{len1 = length_line (a, i+1, j-1);
			len2 = 0;
			}

		/* compute slack */

		slack = (pos - len2 - len1 - hp) / 2;
		if (slack < 0) slack = 0;

		/* first crack at centering */

		fudge = pos - last_pos - len1;
		fudge1 = fudge/2;

		/* check for overlap */

		if (last_pos + fudge1 <= hp)	/* overlap on left */
			fudge1 = hp + min (e->space_width, slack);
		else if (fudge-fudge1 <= len2)	/* overlap on right */
			fudge1 = fudge - (len2 + min (e->space_width, slack));

		/* replace CENTER with appropriate POS */

		hp = last_pos + fudge1;
		a[i] = token_cons (t_pos, hp);
		continue;

case t_right:	j = find_pos (a, i+1, n);
		pos = (j>=0 ? token_val (a[j]) : rm);
		len1 = length_line (a, i+1, (j<0 ? n-1 : j-1));

		/* check for overlap */

		if (pos-hp <= len1) hp =+ e->space_width;
		else hp = pos-len1;
		a[i] = token_cons (t_pos, hp);
		continue;

case t_null:
case t_tabc:	continue;

default:	barf ("HACK_LINE: bad token type %d", token_type (w));
		continue;

			}
		}
	}

/**********************************************************************

	JUSTIFY_LINE - Justify Right Margin

**********************************************************************/

justify_line (a, n, rm)	token a[]; int n, rm;

	{int	j;		/* pointer into A */
	int	len;		/* length of justifiable text */
	int	nspaces;	/* number of SPACEs in justifiable text */
	token	w;		/* current token */
	int	val;		/* value of current token */
	int	pos;		/* left-most position of justification */
	int	text_seen;	/* text seen so far in scan */
	int	fudge;		/* width of SPACE to use up */
	int	per;		/* basic increment per SPACE */
	int	nmore;		/* number of SPACEs which get 1 more HU */
	int	incr;		/* increment to current space width */
	static	int spr;	/* spread direction: 0 => left */

	len = 0;
	nspaces = 0;
	pos = 0;
	text_seen = FALSE;

	/* Scan the line from right to left to determine the
	   justifiable text.  Spaces to the right of all text
	   are converted to nulls.  Scanning is terminated by
	   a POS or HPOS.  */

	for (j=n-1;j>=0;--j)
		{w = a[j];
		val = token_val (w);
		switch (token_type (w)) {

case t_text:	len =+ text_width (val);
		text_seen = TRUE;
		continue;

case t_offset:	len =+ val - (WVMASK+1)/2;
		continue;

case t_space:
case t_nlspace:	if (!text_seen) a[j] = token_cons (t_null, 0);
		else
			{len =+ val;
			++nspaces;
			}
		continue;

case t_hpos:
case t_pos:	pos = val;
		break;

case t_tabc:	a[j] = token_cons (t_null, 0);	/* meaningless */
case t_null:	continue;

default:	barf ("JUSTIFY_LINE: bad token type %d", token_type (w));
		continue;
			}
		break;
		}

	if (len == 0) return;	/* no text to justify */

	/* Now scan from left to right, removing spaces that are
	   before the first text word from the justifiable region. */

	while (++j < n)
		{w = a[j];
		switch (token_type (w)) {
	case t_text:	break;
	case t_space:
	case t_nlspace:	val = token_val (w);
			--nspaces; len =- val; pos =+ val; continue;
	case t_offset:	val = token_val (w) - (WVMASK+1)/2;
			pos =+ val;
			continue;
	case t_null:	continue;
	default:	barf ("JUSTIFY_LINE: bad token type %d", token_type (w));
			continue;
			}
		break;
		}

	fudge = rm - pos - len;		/* amount of space to use up */

	if (fudge==0) return;
	if (nspaces==0)
		{error ("unable to justify right margin: no justifiable spaces");
		return;
		}
	if (fudge<0)
		{error ("unable to justify right margin: line too long");
		return;
		}

	per = fudge / nspaces;
	nmore = fudge % nspaces;

	--j;
	while (++j < n)		/* process SPACEs in justifiable text */
		{int t;
		t = token_type (w = a[j]);
		if (t == t_space || t == t_nlspace)
			{incr = per;
			if (spr==0)	/* left spread */
				{if (--nmore>=0) ++incr;}
			else		/* right spread */
				{if (--nspaces < nmore) ++incr;}
			a[j] = token_cons (t_space, token_val(w)+incr);
			}
		}
	spr = !spr;
	}

/**********************************************************************

	APPEND_TOKEN - Append token to current line

**********************************************************************/

append_token (tag, value)
	int tag, value;

	{if (e->tn >= (max_tokens - 2))
		fatal ("line too long -- line buffer overflow");
	e->line_buf[e->tn++] = token_cons (tag, value);
	}

/**********************************************************************

	FIND_POS - Find first POS token in line A[I:N-1].
		Return -1 if none.

**********************************************************************/

int find_pos (a, i, n)	token a[];

	{while (i<n)
		{if (token_type (a[i]) == t_pos) return (i);
		++i;
		}
	return (-1);
	}

/**********************************************************************

	FIND_RIGHT - Find first RIGHT token in line A[I:N-1].
		Return -1 if none.

**********************************************************************/

int find_right (a, i, n)	token a[];

	{while (i<n)
		{if (token_type (a[i]) == t_right) return (i);
		++i;
		}
	return (-1);
	}

/**********************************************************************

	LENGTH_LINE - Return horizontal length of line A[I:J]

**********************************************************************/

int length_line (a, i, j)	token a[];

	{token w;
	int len, val;

	len = 0;
	while (i<=j)
		{w = a[i++];
		val = token_val(w);
		switch (token_type(w)) {

case t_text:	len =+ text_width (val);
		continue;

case t_offset:	val =- (WVMASK+1)/2; /* fall through */
case t_space:
case t_nlspace:	len =+ val;
		continue;

case t_hpos:
case t_pos:
case t_tabc:
case t_null:	continue;

case t_right:	error ("superfluous ^R");
		continue;

case t_center:	error ("superfluous ^C");
		continue;

default:	barf ("LENGTH_LINE: bad token type %d", token_type (w));
		continue;
			}
		}

	return (len);
	}

