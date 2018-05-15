#include <stdio.h>
#ifdef	vms
#include	"c:lex.h"
#else
#include	<lex.h>
#endif
extern int _lmovb();

#line 8 "word.lxi"

char		line[133];
char		*linep		= &line;
int		is_eof		= 0;
int		wordct		= 0;
#define	T_EOL	1
main()
{
	register int	i;
	while ((i = yylex()) != 0) {
		/*
		 * If the "end-of-line" token is  returned
		 * AND  we're really at the end of a line,
		 * read the next line.  Note that T_EOL is
		 * returned  twice when the program starts
		 * because of the nature of the look-ahead
		 * algorithms.
		 */
		if (i == T_EOL && !is_eof && *linep == 0) {
			if (ftty(stdin)) {
				printf("* ");
				fflush(stdout);
			}
			getline();
		}
	}
	printf("%d words\n", wordct);
}
extern struct lextab word;

/* Standard I/O selected */
extern FILE *lexin;

llstin()
   {
   if(lexin == NULL)
      lexin = stdin;
   if(_tabp == NULL)
      lexswitch(&word);
   }

_Aword(__na__)		/* Action routine */
   {
	switch (__na__) {
	case 0:

#line 39 "word.lxi"

			/*
			 * Write each word on a seperate line
			 */
			lexecho(stdout);
			printf("\n");
			wordct++;
			return(LEXSKIP);
		
         break;
	case 1:

#line 48 "word.lxi"

			return(T_EOL);
		
         break;
	case 2:

#line 51 "word.lxi"

			return(LEXSKIP);
		
         break;
	}
	return(LEXSKIP);
}

#line 54 "word.lxi"


getline()
/*
 * Read a line for lexgetc()
 */
{
	is_eof = (fgets(line, sizeof line, stdin) == NULL);
	linep = &line;
}

lexgetc()
/*
 * Homemade lexgetc -- return zero while at the end of an
 * input line or EOF at end of file.  If more on this line,
 * return it.
 */
{
	return((is_eof) ? EOF : (*linep == 0) ? 0 : *linep++);
}

int _Fword[] = {
 -1, 2, 2, 1, 0, 0, -1,
};

#line 74 "word.lxi"

#define	LLTYPE1	char

LLTYPE1 _Nword[] = {
 3, 6, 6, 6, 6, 6, 6, 6, 6, 1, 1, 6, 6, 6, 6, 6,
 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6,
 1, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,
 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,
 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,
 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,
 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,
 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 2,
 2, 2, 2, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6,
 6, 6, 6, 6, 6, 6, 2, 6, 2, 5, 5, 5, 5, 5, 5, 5,
 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
 5, 5, 5, 5, 5,
};

LLTYPE1 _Cword[] = {
 0, -1, -1, -1, -1, -1, -1, -1, -1, 0, 0, -1, -1, -1, -1, -1,
 -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
 1, 2, 2, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
 -1, -1, -1, -1, -1, -1, 1, -1, 2, 4, 4, 4, 4, 4, 4, 4,
 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,
 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,
 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,
 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,
 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,
 4, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5, 5, 5, 5, 5,
 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5,
 5, 5, 5, 5, 5,
};

LLTYPE1 _Dword[] = {
 6, 6, 6, 6, 6, 6,
};

int _Bword[] = {
 0, 118, 120, 0, 120, 214, 0,
};
#define	LLILL	LLILL

char _Zword[] = {
 0377, 0377, 0377, 0377, 0377, 0377, 0377, 0377, 0377, 0377, 0377, 0377, 0377, 0377, 0377, 0377,
 0377, 0377, 0377, 0377, 0377, 0377, 0377, 0377, 0377, 0377, 0377, 0377, 0377, 0377, 0377, 0377,

};

struct	lextab	word = {
	6,	/* last state */
	_Dword,	/* defaults */
	_Nword,	/* next */
	_Cword,	/* check */
	_Bword,	/* base */
	340,	/* last in base */
	_lmovb,	/* byte-int move routines */
	_Fword,	/* final state descriptions */
	_Aword,	/* action routine */
	NULL,	/* look-ahead vector */
	0,	/* no ignore class */
	0,	/* no break class */
	_Zword,	/* illegal class */
};
