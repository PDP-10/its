#include <stdio.h>
#ifdef	vms
#include	"c:lex.h"
#else
#include	<lex.h>
#endif
extern int _lmovb();

#line 1 "foo.lxi"

main() {
	int res;
	res = yylex();
	printf("lexval=\t%d\nyylex()=\t%d\n", lexval, res);
}
extern struct lextab foo;

/* Standard I/O selected */
extern FILE *lexin;

llstin()
   {
   if(lexin == NULL)
      lexin = stdin;
   if(_tabp == NULL)
      lexswitch(&foo);
   }

_Afoo(__na__)		/* Action routine */
   {
	switch (__na__) {
	case 0:

#line 11 "foo.lxi"
 printf("foo");
		
         break;
	}
	return(LEXSKIP);
}

#line 13 "foo.lxi"

int _Ffoo[] = {
 -1, -1, -1, 0, -1,
};

#line 13 "foo.lxi"

#define	LLTYPE1	char

LLTYPE1 _Nfoo[] = {
 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,
 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,
 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,
 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,
 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,
 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,
 4, 2, 1, 2, 1, 2, 3, 2, 1,
};

LLTYPE1 _Cfoo[] = {
 -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
 -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
 -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
 -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
 -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
 -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
 -1, 0, 0, 1, 1, 2, 2, 3, 3,
};

LLTYPE1 _Dfoo[] = {
 4, 4, 4, 4,
};

int _Bfoo[] = {
 0, 2, 4, 6, 0,
};

struct	lextab	foo = {
	4,	/* last state */
	_Dfoo,	/* defaults */
	_Nfoo,	/* next */
	_Cfoo,	/* check */
	_Bfoo,	/* base */
	104,	/* last in base */
	_lmovb,	/* byte-int move routines */
	_Ffoo,	/* final state descriptions */
	_Afoo,	/* action routine */
	NULL,	/* look-ahead vector */
	0,	/* no ignore class */
	0,	/* no break class */
	0,	/* no illegal class */
};
