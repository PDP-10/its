
/*
 * lexswitch -- switch lex tables
 */

/*
 * Bob Denny 28-Aug-82  Remove reference to stdio.h
 */

#ifdef	vms
#include	"c:lex.h"
#else
#include	<lex.h>
#endif

/*)LIBRARY
*/

struct lextab *
lexswitch(lp)
struct lextab *lp;
{
	register struct lextab *olp;

	olp = _tabp;
	_tabp = lp;
	return(olp);
}
