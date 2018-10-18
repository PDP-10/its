/*
 *	C PAGE Handling Package
 *
 *	routines:
 *
 *	pg = pg_get (n)
 *	rc = pg_ret (pg, n)
 *	b = pg_exist (pg)
 *	i = pg_nshare (pg)
 *	i = pp_nshare (p)
 *
 */

# include "c.defs"

# rename page_table "PAGTAB"
# rename first_free_page "FFPAGE"

int first_free_page;
extern int page_table [256];
extern int cerr;

/**********************************************************************

	PG_GET - Page Get

	Allocate "n" contiguous unused pages in the address space.
	Return the number of the lowest page allocated, or -1
	if unable to allocate pages.

**********************************************************************/

int pg_get (n)

	{int page, i, top, tp, n_free;

	if (n<1 || n>254) return (-1);
	page = first_free_page;	/* first page we examine */
	top = 256-n;		/* highest possible low page */
	n_free = 0;		/* number of free pages we see */
	while (page <= top)
		{for (i=0;i<n;++i)
			{tp = page+i;
			if (page_table[tp]!=0 || pg_exist(tp)) break;
			else ++n_free;
			}
		if (i>=n) break;	/* success */
		page =+ i+1;
		}
	if (page > top) return (-1);
	for (i=0;i<n;++i) page_table[page+i] = -1;
	if (n_free==n) first_free_page = page+n;
	return (page);
	}

/**********************************************************************

	PG_RET - Page Return

	deallocate "n" pages in the address space and unmap them
	return non-zero on error

**********************************************************************/

int pg_ret (page, n)

	{if (n<1 || page<=0 || page+n>256)
		{cprint (cerr, "PG_RET: invalid page number %d.\n", page);
		return (-1);
		}
	if (page < first_free_page) first_free_page = page;
	while (--n >= 0)
		{page_table[page] = 0;
		corblk (0, -1, page, -1, page);
		++page;
		}
	return (0);
	}

/**********************************************************************

	PG_EXIST - Does page exist in address space?

**********************************************************************/

pg_exist (page_no)

	{int blk[4];

	cortyp (page_no, blk);
	return (page_table[page_no] = (blk[0] != 0));
	}


/**********************************************************************

	PG_NSHARE - Return number of times page is shared

**********************************************************************/

pp_nshare (p)	{return (pg_nshare (p>>10));}

pg_nshare (page_no)

	{int blk[4];

	cortyp (page_no, blk);
	return (blk[3] & 0777777);
	}

