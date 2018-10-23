/*

	FILMAP - file mapping routines

	filmap (c, o, s)	map in part of a file
	filunmap (p, s)		unmap part of a file

*/

# include "c.defs"

/**********************************************************************

	FILMAP - map in a part of a disk file
		return a pointer to it

**********************************************************************/

int *filmap (ch, offset, size)

	{int block_no, page_no, word_no, no_pages, i;
	int *p;

	block_no = offset>>10;
	word_no = offset & 01777;
	no_pages = ((word_no + size - 1) >> 10) + 1;
	page_no = pg_get (no_pages);
	if (page_no < 0)
		{puts ("FILMAP: Unable to Allocate Pages.\n");
		return (0);
		}
	for (i=0;i<no_pages;++i)
		if (corblk (0600000, -1, page_no+i, ch, block_no+i))
			{cprint ("FILMAP: Error In Mapping Page %d.\n", block_no+i);
			break;
			}
	p = (page_no<<10)+word_no;
	return (p);
	}

/**********************************************************************

	FILUNMAP - Unmap pages mapped by FILMAP

**********************************************************************/

filunmap (p, size)	int *p;

	{int page_no, word_no, no_pages, p_rep;

	p_rep = p;
	word_no = p_rep & 01777;
	page_no = p_rep >> 10;
	no_pages = ((word_no + size - 1) >> 10) + 1;
	pg_ret (page_no, no_pages);
	}

