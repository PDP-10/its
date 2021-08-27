# include "r.h"

/*

	R Text Formatter
	Common Output Routines

	Copyright (c) 1976, 1977 by Alan Snyder


	ROUTINES:

	output_line (a, n, ha, hb, pos)
	bad ()			detect call before initialization

*/

int	fout,			/* output file descriptor */
	printing {TRUE},	/* printing mode */
	ofont {0},		/* current output font */
	oul {FALSE},		/* current output underline mode */
	ovoff {-min_voff},	/* current output vertical offset */
	olvpu {0},		/* current output last vertical position used */
				/* used to enforce device constraints, if any */
	ulpos {0},		/* underline position -- 
					actual init is device-dependent */
	uldpos {0},		/* default underline position */
	ulthick {0},		/* underline thickness */
	uldthick {0};		/* default underline thickness */

extern	env	*e;
extern	int	current_page_offset;

/**********************************************************************

	OUTPUT_LINE - Output the line A[N] with height above the
		baseline HA, height below the baseline HB, and
		vertical position of baseline POS.
		Set LVPU to the last vertical position actually used.
		Page offset handled by this routine.

**********************************************************************/

output_line (a, n, ha, hb, pos)	token a[];

	{token t;
	word tabc;
	int hp, lhp, i, val, width, j, frame, d;

	if (!printing) return;
	output_vp (pos, ha, hb);
	hp = current_page_offset;
	lhp = 0;
	tabc = -1;

	for (i=0;i<n;++i)
		{t = a[i];
		val = token_val (t);
		switch (token_type (t)) {

case t_text:	if (hp != lhp) output_space (hp-lhp, hp);
		output_text (val, hp);
		lhp = (hp =+ text_width (val));
		continue;

case t_offset:	val =- (WVMASK+1)/2; /* fall through */
case t_space:
case t_nlspace:	hp =+ val;
		continue;

case t_hpos:	tabc = -1;
		/* fall through */

case t_pos:	if (tabc != -1)
			{if (hp!=lhp) output_space (hp-lhp, hp);
			lhp = hp;
			}
		hp = val + current_page_offset;
		if (tabc != -1 && hp > lhp)
			{width = text_width (tabc);
			if (width >= e->space_width) frame=width;
				else frame = e->space_width;
			d = lhp % frame;
			if (d>0 && !isul (tabc))
				{d = frame - d;
				output_space (d, lhp+d);
				lhp =+ d;
				}
			j = (hp - lhp) / frame;
			d = frame - width;
			while (--j >= 0)
				{output_text (tabc, lhp);
				lhp =+ frame;
				if (d>0) output_space (d, lhp);
				}
			if (hp-lhp >= width)
				{output_text (tabc, lhp);
				lhp =+ width;
				}
			}
		tabc = -1;
		continue;

case t_tabc:	tabc = val;
		continue;

case t_null:	continue;

default:	barf ("OUTPUT_LINE: bad token type %d", token_type (t));
		continue;
			}
		}

	output_eol (pos, ha, hb);
	}
