/* - int.h - header file for C interrupt system */

# define INT_DEFAULT 0
# define INT_IGNORE 1

/* 1-5, 23-35 are user assignable */

# define INT_AOV	6	/* arithmetic overflow */
# define INT_FOV	7	/* floating point overflow */
# define INT_EOF	10	/* end of file */
# define INT_DAE	11	/* data error */
# define INT_QTA	12	/* quota exceeded or disk full */
# define INT_ILI	15	/* illegal instruction */
# define INT_IRD	16	/* illegal memory read */
# define INT_IWR	17	/* illegal memory write */
# define INT_IFT	19	/* inferior process termination */
# define INT_MSE	20	/* system resources exhausted */
# define INT_NXP	22	/* non-existent page */



