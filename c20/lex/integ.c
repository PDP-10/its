
/*
 * integ -- ascii to long (various bases)
 */

/*)LIBRARY
*/

long
integ(cp, base)
char *cp;
register base;
{
	register c;
	long n;

	n = 0;
	while (c = *cp++) {
		if (c>='A' && c<='Z')
			c += 'a'-'A';
		if (c>='a' && c<='z')
			c = (c-'a')+10+'0';
		if (c < '0' || c > base+'0')
			break;
		n = n*base + c-'0';
	}
	return(n);
}
