/* SETJMP.H for DECsystem-20 C */

typedef int jump_buf [3];

/* jump_buf[0] is return address for setjmp call */
/* jump_buf[1] is sp just before setjmp call */
/* jump_buf[2] is fp just before setjmp call */
