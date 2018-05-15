/* TOPS-20 C interrupt interface, non-extended-addressing version */

# include <int.h>

# rename chntab "CHNTAB"
# rename prctab "PRCTAB"

extern	int chntab[], prctab[];

static int assigned = 0;	/* interrupt channels assigned to user */
static int ignore() {;}		/* a function which does nothing */

/* reserve PDLOV */
#define reserved halves(0400,0)

/* these channels are not allocatable to the user (0 is for debugger) */
#define system_interrupts halves(0407777, 0760000)

# define halves(l,r) (((l) << 18) | ((r) & 0777777))

iset (chan,proc)
int chan;
int proc;	/* really a pointer to the function to execute */
{
	register unsigned prev, mask;

	mask = (unsigned) 0400000000000 >> chan;
	if (chan < 0 || chan > 35 || (mask & reserved)) return (-1);
	proc &= 0777777;
	prev = prctab[chan];
	switch (proc) {
	case INT_DEFAULT:
		if (prev) {
			_DIC (0400000, mask);		/* interrupt off */
			chntab[chan] &= 0777777;	/* set priority to 0 */
		}
		break;
	case INT_IGNORE:
		proc = (int) ignore;		/* falls through */
	default:
		prctab[chan] = proc;
		if (proc && (prev == 0)) {
			chntab[chan] |= (3 << 18);	/* always priority 3 */
			_AIC (0400000, mask);
		}
	}
	if (prev == (int) ignore) prev = INT_IGNORE;
	return (prev);
}

ialloc ()
{
	register unsigned left, num;

	if ((left = ~(assigned | system_interrupts)) == 0) return (0);
	num = 35;
	while (!(left & 1)) {
		--num;
		left >>= 1;
	}
	assigned |= (unsigned) 0400000000000 >> num;
	return (num);
}

ifree (chan)
int chan;
{
	if (chan >= 0 && chan <= 35) {
	  assigned &= ~((unsigned)0400000000000 >> chan) & ~system_interrupts;
	  iset (chan,INT_DEFAULT);
	}
}

int onchar(chr,proc)
char chr;
int proc;
{
	int intno;

	if ((chr < 0) || (chr > 29))
		return (-1);
	if((intno = ialloc()) < 0)	/* no int channels left */
		return(-1);
	_ati(halves(chr,intno));	/* tie channel to char  */
	iset(intno,proc);		/* tie channel to proc  */
	return(intno);
}
