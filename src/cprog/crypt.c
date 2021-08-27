# define wheel1 wh1
# define wheel2 wh2
# define wheel3 wh3
# define wheel4 wh4
# define wheel5 wh5
# define wheel6 wh6

/*
This routine is an exact implementation of Boris Hagelin's
cryptographic machine.  See U. S. Patent #2,089,603.
Modified 10/5/75 to work with 7-bit characters.
Modified 10/16/75 to be a bit more efficient.
*/

extern int cin, cout;

int	cagetable[] { 0, 1, 1, 2, 2, 3, 4, 4, 5, 6, 8, 8, 9, 10, 12, 16,
	16, 17, 18, 20, 24, 32, 32, 33, 34, 36, 40, 48};
int	warr1[52];
int	warr2[50];
int	warr3[46];
int	warr4[42];
int	warr5[38];
int	warr6[34];
int	*wheel1 warr1;
int	*wheel2 warr2;
int	*wheel3 warr3;
int	*wheel4 warr4;
int	*wheel5 warr5;
int	*wheel6 warr6;
char	key[130];

/*
subroutine to manufacture a wheel
*/

setup(list,n) int list[];
	{int *lp;
	lp = list;
	while(--n){
		*lp = lp+2;
		lp[1] = getbit();
		lp = lp + 2;
		}
	*lp = list;
	lp[1] = getbit();
	}

/*
subroutine to return the next bit from the main routines
argument
*/

getbit(){
	static int i,j;
	int b;
	b = (key[j] >> i) & 1;
	if (i++ > 5) {
		j++;
		i = 0;
		}
	return (b ? -1 : 0);
	}

main(argc,argv)
	int argc;
	char *argv[];

	{char *ip, *jp;
	int temp;
	int random;
	int i,x,y;
	int precious;
	int crypt;
	int cage[27];

/*
copy input key and pad with clever junk
*/

	jp = key;
	*jp++ = 004;
	*jp++ = 034;
	if(argc > 1){
		while (*jp++ = *argv[1]) *argv[1]++ = 4;
		jp--;
		}
	ip = key;
	while (jp < key+128) {
		*jp = jp[-1] ^ *ip++;
		jp++;
	}

/*
manufacture six wheels of various length
*/

	setup(wheel1,26);
	setup(wheel2,25);
	setup(wheel3,23);
	setup(wheel4,21);
	setup(wheel5,19);
	setup(wheel6,17);

/*
set up the cage bars from the key area
*/

	jp = key;
	i = 27;
	while (i--){
	cage[i] = cagetable[*jp++ % 28];
	}

/*
the internal settings are now complete
it's time to turn the crank, running the cage
bars against the wheel lugs.
*/

while (1)
	{precious = cgetc (cin);
	if (ceof (cin)) break;
	temp = 040&wheel1[1] | 020&wheel2[1] | 010&wheel3[1]
		| 004&wheel4[1] | 002&wheel5[1] | 001&wheel6[1];
	wheel1 = *wheel1;
	wheel2 = *wheel2;
	wheel3 = *wheel3;
	wheel4 = *wheel4;
	wheel5 = *wheel5;
	wheel6 = *wheel6;

	random = 0;
	i = 27;
	while (--i>=0){
		if (temp & cage[i]) ++random;
		}

/*
now we have a random number to use to encrypt the input
it is done in such a way that the process is its own
inverse.
*/

	if ( precious=='\n' || precious==' ' || precious=='\r'
		|| precious=='\t') crypt = precious;
	else
		{x = precious & ~077;
		y = precious & 077;
		crypt = x | ((random - y) & 077);
		if (crypt == '\n' || crypt == ' ' || crypt == '\r'
			|| crypt == '\t') crypt = precious;
		}
	cputc (crypt, cout);
	}
}
