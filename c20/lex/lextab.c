/*
 * Created by DECUS LEX from file "tt1:" Tue Aug 31 21:01:15 1982
 */

/*
 * CREATED FOR USE WITH STANDARD I/O
 */

#
#include <stdio.h>
#ifdef vms
#include "c:lex.h"
#else
#include <lex.h>
#endif

extern int _lmovb();

int _Flextab[] =
   {
   -1, -1,
   };

#line 1 "tt1:"

#define	LLTYPE1	char

LLTYPE1 _Nlextab[] =
   {
   1,
   };

LLTYPE1 _Clextab[] =
   {
   -1,
   };

LLTYPE1 _Dlextab[] =
   {
   1,
   };

int _Blextab[] =
   {
   0, 0,
   };

struct lextab lextab =	{
			1,		/* Highest state */
			_Dlextab, 	/* --> "Default state" table */
			_Nlextab, 	/* --> "Next state" table */
			_Clextab, 	/* --> "Check value" table */
			_Blextab, 	/* --> "Base" table */
			0,		/* Index of last entry in "next" */
			_lmovb,		/* --> Byte-int move routine */
			_Flextab, 	/* --> "Final state" table */
			_Alextab, 	/* --> Action routine */
			NULL,   	/* Look-ahead vector */
			0,		/* No Ignore class */
			0,		/* No Break class */
			0,		/* No Illegal class */
			};
