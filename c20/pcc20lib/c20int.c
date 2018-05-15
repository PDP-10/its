# include <c.defs>

# rename handle "HANDLE"	/* avoid name conflict, etc. */
# rename chntab "CHNTAB"
# rename prctab "PRCTAB"

extern	int chntab[], prctab[];

int assigned {0};	/* interrupt channels assigned to user */

# define reserved halves (0000400, 0)		/* PDLOV reserved */
# define system_interrupts halves (0007777, 0760000)

on (x, y)
	{register unsigned prev, mask;
	mask = ((unsigned)(halves (0400000, 0)) >> x);
	if (x < 0 || x > 35 || (mask & reserved)) return (-1);
	y =& 0777777;
	if (y == INT_DEFAULT || y == INT_IGNORE) y = 0;
	prev = prctab[x];
	if (prev && y == 0)
		{_DIC (0400000, mask);
		chntab[x] =& 0777777;
		}
	prctab[x] = y;
	if (y && prev == 0)
		{chntab[x] =| (3 << 18);	/* always level 3 */
		_AIC (0400000, mask);
		}
	return (prev);
	}

ialloc ()
	{register unsigned left, num;
	if ((left = ~(assigned | system_interrupts)) == 0) return (-1);
	num = 35;
	while (!(left & 1))
		{--num;
		left =>> 1;
		}
	assigned =| (halves (0400000, 0) >> num);
	return (num);
	}

ifree (num)
	{if (num >= 0 && num <= 35)
		assigned =& ~(((unsigned)(halves (0400000, 0)) >> num) &
				~system_interrupts);
	}
