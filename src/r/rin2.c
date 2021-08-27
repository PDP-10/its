# include "r.h"

/*

	R Text Formatter
	Input Insertion Routines

	Copyright (c) 1976, 1977 by Alan Snyder


	These routines handle the insertion of text from number
	registers, string registers, and macro arguments.

*/

extern	ac	margs[max_icb][max_args];
extern	int	mdotflag[max_icb];
extern	int	maclev, ftrace;

insert_argument ()

	{register ichar ic;

	if (ftrace>=0) cprint (ftrace, "^a");
	ic = getc2 ();
	if ((ic>='0' && ic<='9') || ic=='.')
		{if (maclev>0)
			{if (ic=='.')
				{if (mdotflag[maclev]) push_char ('1');
				else push_char ('0');
				}
			else
				{register ac s;
				s = margs[maclev][ic-'0'];
				if (s) push_ac (s);
				}
			}
		else error ("invalid macro argument reference (^A): no active macro");
		}
	else
		{error ("invalid macro argument reference (^A): no argument number");
		push_char (ic);
		}
	}

insert_number ()

	{ac	s;
	register ichar ic;
	int	incr, mode, val;
	idn	name;
	static	char r[40];

	if (ftrace>=0) cprint (ftrace, "^n");
	incr = 0;
	mode = 0;
	ic = getc2 ();
	if (ic == '?')
		{mode = '?';
		ic = getc2 ();
		}
	else
		{if (ic == '+' || ic == '-')
			{incr = ic;
			ic = getc2 ();
			}
		if (ic == '.' || ic == ':' || ic == ',' || ic == ';')
			{mode = ic;
			ic = getc2 ();
			}
		}
	s = ac_alloc (20);
	while (alpha (ic))
		{ac_xh (s, ic);
		ic = getc2 ();
		}
	if (ic != '!') push_char (ic);
	if (ac_size (s) == 0)
		{error ("invalid number register reference (^N): no name specified");
		ac_unlink (s);
		return;
		}
	name = make_ac_idn (s);
	ac_unlink (s);
	if (mode == '?')
		push_char (nr_find (name) >= 0 ? '1' : '0');
	else
		{switch (incr) {
			case '+':	val = nr_incr (name); break;
			case '-':	val = nr_decr (name); break;
			default:	val = nr_value (name);
				}
		switch (mode) {

case '.':	i2sr (val, r); break;	/* lower case roman numerals */
case ':':	i2r (val, r); break;	/* upper case roman numerals */
case ',':	i2al (val, 'a', r); break;	/* lower case alpha */
case ';':	i2al (val, 'A', r); break;	/* upper case alpha */
default:	i2a (val, r); break;		/* arabic */
				}

		s = ac_create (r);
		push_ac (s);
		ac_unlink (s);
		}
	}

insert_string ()

	{ac	s;
	ichar	ic;
	idn	name;
	int	mode;

	if (ftrace>=0) cprint (ftrace, "^s");
	s = ac_alloc (20);
	mode = 0;
	ic = getc2 ();
	if (ic == '?')
		{mode = '?';
		ic = getc2 ();
		}
	while (alpha (ic))
		{ac_xh (s, ic);
		ic = getc2 ();
		}
	if (ic != '!') push_char (ic);
	if (ac_size (s) == 0)
		{error ("invalid string register reference (^S): no name specified");
		ac_unlink (s);
		return;
		}
	name = make_ac_idn (s);
	ac_unlink (s);
	if (mode == '?')
		push_char (sr_find (name) >= 0 ? '1' : '0');
	else
		{s = sr_value (name);
		push_ac (s);
		ac_unlink (s);
		}
	}
