# include "ctype.h"

# define S _S
# define N _N
# define L _L
# define U _U

char _ctype[] {
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	S, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
	N, N, N, N, N, N, N, N, N, N, 0, 0, 0, 0, 0, 0,
	0, U, U, U, U, U, U, U, U, U, U, U, U, U, U, U,
	U, U, U, U, U, U, U, U, U, U, U, 0, 0, 0, 0, 0,
	0, L, L, L, L, L, L, L, L, L, L, L, L, L, L, L,
	L, L, L, L, L, L, L, L, L, L, L, 0, 0, 0, 0, 0};
