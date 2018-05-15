
/*
 * lex library header file -- accessed through
 *	#include <lex.h>
 */

/*
 * description of scanning
 * tables.
 * the entries at the front of
 * the struct must remain in
 * place for the assembler routines
 * to find.
 */
struct	lextab {
	int	llendst;		/* Last state number		*/
	char	*lldefault;		/* Default state table		*/
	char	*llnext;		/* Next state table		*/
	char	*llcheck;		/* Check table			*/
	int	*llbase;		/* Base table			*/
	int	llnxtmax;		/* Last in base table		*/

	int	(*llmove)();		/* Move between states		*/
	int	*llfinal;		/* Final state descriptions	*/
	int	(*llactr)();		/* Action routine		*/
	int	*lllook;		/* Look ahead vector if != NULL	*/
	char	*llign;			/* Ignore char vec if != NULL	*/
	char	*llbrk;			/* Break char vec if != NULL	*/
	char	*llill;			/* Illegal char vec if != NULL	*/
};

extern	struct	lextab	*_tabp;

/* extern	FILE	*lexin;	*/	/* scanner input file */

/*PLB #define	lexval	yylval */
#define	LEXERR	256
#define	LEXSKIP	(-1)
/*
 * #define	LEXECHO(fp)	{lexecho((fp));}
 */
extern	int	lexval;
extern	int	yyline;

extern char llbuf[];
extern char *llend;
#define	lextext	llbuf
#define	lexlast llend

#define _lmovb _lmvb
#define _lmovi _lmvi
