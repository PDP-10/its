# include "c.defs"

# define PAGE_SHIFT 10
# ifdef tops20
#    define PAGE_SHIFT 9
# endif

# define PAGE_SIZE (1<<PAGE_SHIFT)
# define PAGE_MASK (PAGE_SIZE-1)
# define NPAGES (01000000/PAGE_SIZE)

# define ORIGIN_0 0100
# define ORIGIN_1 0400000
# ifdef tops20
#    define ORIGIN_0 0140
# endif

# define FNSIZE 200		/* file name size */

# define MAXBLOCK 0200		/* maximum size of block */
# define MAXSEGS 16		/* maximum number of segments */
# define MAXSYMS 4000		/* maximum number of symbols */
# define MAXPROGS 100		/* maximum number of programs */
# define MAXINIT 10		/* maximum number of init routines */
# define NLALLOC 01000		/* number of list cells allocated at once */
# define COMSIZ 3000		/* command buffer size */

# define HSHSIZE 1791		/* hash table size, must be >= 1025 */
# define NWINDOW 4		/* number of windows onto inferior */

# define NAMMASK 0037777777777	/* name mask away flags */
# define SYMMASK 0037777777777	/* symtab mask for name */
# define SYMDBIT 0400000000000	/* symtab 'defined' bit */
# define SYMHBIT 0200000000000	/* symtab 'half kill' bit */

# define DDTHBIT 0400000000000	/* DDT symtab 'half kill' bit */
# define DDTGBIT 0040000000000	/* DDT symtab 'global' bit */

# define ONEXT -1		/* segment origin at next word */
# define OPAGE -2		/* segment origin at next page */

/*
 *	symbol types
 *
 *	program = record [n: name, vals: sequence[symbol]]
 *	symbol = oneof [undefined: list[fixup], defined: int]
 *	fixup = record [
 *		subtract: boolean,
 *		swap: boolean,
 *		action: oneof [word, right, left, ac],
 *		location: int
 *		]
 */

typedef int fixup;
struct _fxcell {fixup f; struct _fxcell *p;};
typedef struct _fxcell fxcell;
typedef struct _fxcell *fxlist;
struct _syment {int sym, val; struct _syment *next;};
typedef struct _syment syment;
typedef struct _syment *symbol;
typedef int name;
struct _progent {name n; symbol p;};
typedef struct _progent progent;

# define fixsub(x) ((x) & 010000000)
# define fixswap(x) ((x) & 04000000)
# define fixact(x) (((x) >> 18) & 03)
# define fixloc(x) ((x) & 0777777)
# define fixcons(sub,swap,act,loc) ((sub)<<21|(swap)<<20|(act)<<18|(loc))
# define fa_word 0
# define fa_right 1
# define fa_left 2
# define fa_ac 3

# define symdefined(z) ((z)->sym<0)
# define symname(z) (((z)->sym)&SYMMASK)
# define symvalue(z) ((z)->val)
# define symfixups(z) ((z)->val)
# define symhkill(z) ((z)->sym =| SYMHBIT)
# define symhkilled(z) ((z)->sym & SYMHBIT)

# define wleft(w) ((w)>>18)
# define wright(w) ((w)&0777777)
# define wcons(l,r) (((l)<<18)|((r)&0777777))
