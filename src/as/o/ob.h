#define MAXEXIT 12
#define MAXNODE 2200
#define NOT_EVAL -1000
#include "o.h"

typedef int rotation;

struct _exit {
	int data;

		/* encoded as follows:

		bit 23:17 - position
		bit 16 - goodness flag
		bit 15:4 - next bnode (number)
		bit 3:0 - rotation factor for viewing next node
		*/

	};

#define getpos(e) (((e)->data>>17) & 0177)
#define getnext(e) (((e)->data>>4) & 07777)
#define getgood(e) (((e)->data>>16) & 01)
#define getrot(e) ((e)->data & 017)

#define consexit(e,pos,good,rot,next)((e)->data=((((((pos<<1)|good)<<12)|next)<<4)|rot))
#define setgood(e) ((e)->data =| (1<<16))

struct _bnode {
	int nodenum;		/* node number - for identification */
	int nmoves;		/* number of exiting moves */

# ifdef GENBOOK
	int eval;		/* evaluation (NOT_EVAL if not evalled) */
	int depth;		/* depth of node in search tree */
	board b;		/* current position */
	color c;		/* side to move */
# endif

	struct _exit moves[MAXEXIT];	/* the exits */
					/* must be last */
	};

typedef struct _exit exit;
typedef struct _bnode bnode;

# define R0 0
# define R90 1
# define R180 2
# define R270 3
# define H0 4
# define H90 5
# define H180 6
# define H270 7
# define V0 8
# define V90 9
# define V180 10
# define V270 11

extern bnode *bnlist[MAXNODE];
extern bnode *curbn;
extern bnode *bnfind();
extern rotation currot;
extern int nnodes;
extern position movlst[];

# define forallpos(p,pp) for(pp=movlst;(p = *pp++)>=0;)
