/***********************************************************************
*								       *
*      qsort - PDP10 implementation of the quicksort algorithm.	       *
*								       *
*      call - qsort(base, size, width, compar)			       *
*								       *
*	       base - pointer to the base of the array of objects to   *
*		       sort.					       *
*								       *
*	       size - number of objects in the array		       *
*								       *
*	       width - size of each element, in units of char	       *
*		       (like from sizeof)			       *
*								       *
*	       compar -	a function which takes pointers to two	       *
*		       objects as arguments and returns <0 if	       *
*		       the first object is "smaller" than the second,  *
*		       0 if the first is "equal" to the second, and    *
*		       >0 if the first is "greater" than the second.   *
*								       *
***********************************************************************/

/* this file is PDP10 dependant due to use of the "blt" function */
/*	   copyright (C) 1981 by John T. Wroclawski		 */

#define TBUFSIZE 50
#define MINSIZE 10
#include <stdio.h>



qsort(base,size,width,compar)
char *base;
register int width;
int (*compar)();
{
   char tbuf[TBUFSIZE];
   char medval[TBUFSIZE];

   char *median, *top;
   register char *right,*left;		/* working pointers */
   int smallsize;			/* size of divided segment */
   
   if (size < 0) {
      fprintf(stderr,"qsort: negative number of objects\n");
      exit(1);
      }  

   while(MINSIZE < size) {

       top = base + ((size - 1) * width);	/* top element */
       median = base + ((size/2) * width);	/* middle element*/

       /* sort bottom, median, and top elements */
 
       if ((*compar)(base, median) < 0) {	/* low < median */
          if ((*compar)(median,top) > 0) {	/* median < top */
	      blt(median,tbuf,width);	        /* swap median, top */
	      blt(top,median,width);
	      blt(tbuf,top,width);
	      if ((*compar)(base,median) > 0) {	/* low < new median */
	         blt(base,tbuf,width);	        /* swap low, median */
	         blt(median,base,width);
	         blt(tbuf,median,width);
	         }			        /* end of swap low, median */
	      }				        /* end of med > top */
	   }				        /* end of low < median */

      else				        /* here if base > median */

           if((*compar)(median,top) < 0 ) {	/* med and top are ok */
	      blt(base,tbuf,width);	        /* swap low, median */
	      blt(median,base,width);
	      blt(tbuf,median,width);
	      if ((*compar)(median,top) > 0) {	/* new med > top */
	          blt(median,tbuf,width);       /* swap median, top */
	          blt(top,median,width);
	          blt(tbuf,top,width);
		  }			        /* end med > top swap */
	      }				        /* end med, top were ok */

           else {			        /* here if top<median<base */

	      blt(base,tbuf,width);	        /* swap top and bottom */
	      blt(top,base,width);
	      blt(tbuf,top,width);
	      }				        /* end of top-bottom swap */

/* at this point we should have the bottom, middle, and top elements sorted */

/* now start at each end of the list and look for two elements to swap */
/* we must find an item in the lower half of the list which is greater */
/* than the median, and an element in the upper half which is smaller  */
/* than the median. We keep doing this until the pointers pass each    */
/* other, at which point we have split the original list into two parts*/
/* with all things smaller than the median in one and all things larger*/
/* than the median in the other	   				       */

       blt(median,medval,width);	/* save median value */

      left = base;
      right = top;
      while (left < right) {
         left += width;
         while ((*compar)(left,medval) < 0)
	   left += width;

         right -= width;
         while ((*compar)(medval,right) < 0)
	    right -= width;

         if (left < right) {		/* true if not done yet */
	    blt(left,tbuf,width);	/* if so, swap */
	    blt(right,left,width);
	    blt(tbuf,right,width);
	    }				/* end of swap */
         }				/* end of while left < right */

/* at this point we have two lists, as described above		   */
/* now we call ourselves recursively on the smaller of these, and  */
/* then iteratively over the larger				   */

      left = right + width;
      size = (top + width - left) / width;
      smallsize = (right + width - base ) / width;

      if (smallsize < size) {		/* move base,top to larger block */
          register char *tmp;

          tmp = base;
          base = left;
          left = tmp;
          }
      else {
	  register char *tmp;
	  register int tm1;

          tmp = right;
          right = top;
          top = tmp;

          tm1 = size;
          size = smallsize;
          smallsize = tm1;
          }

      if (smallsize != 0 ) {
          if (smallsize < MINSIZE)
	      sisort(left,(right + width - left)/width,width,compar);
          else
	      qsort(left,(right + width - left)/width,width,compar);
          }

       /* now iterate back to beginning of main while loop */

       } /* end of while loop */
    sisort(base,size,width,compar); /* pick up the last bits */
}


static sisort(base,nel,width,compar)	/* insertion sort */
char *base;
register int width;
int (*compar)();
{
   int tbuf[TBUFSIZE];
   register char *top,*hole,*trial;

   if (width > TBUFSIZE) {
       fprintf(stderr,"qsort: objects too big\n");
       exit(1);
       }
   for(top = base + width; top < base + nel*width; top += width) {
       blt(top,tbuf,width);		/* create a hole in the data */
       hole = top;
       trial = top - width;

       while ((base <= trial) && ((*compar)(tbuf,trial) < 0)) {
	   blt(trial,hole,width);
	   hole = trial;
	   trial -= width;
	   }
        blt(tbuf,hole,width); 
       }
}
