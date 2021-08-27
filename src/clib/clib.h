/*  Handy definitions  */

#define OPENLOSS (-1)               /* Returned by COPEN if open fails */

typedef int SIXBIT;                 /* Six characters packed in one word */

typedef struct {                    /* ITS filespec in sixbit */
            SIXBIT dev,                /* Device */
                   fn1,                /* First filename */
                   fn2,                /* Second filename */
                   dir;                /* Directory */
        } filespec;

#define TRUE       1
#define FALSE      0
