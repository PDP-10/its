# include "s.h"

int pname;			/* program name */
syment	*hshtab[HSHSIZE];
syment symtab[MAXSYMS];
syment *csymp, *esymp;
progent progs[MAXPROGS];
progent *cprog, *zprog;
fxlist freelist;

syminit ()

	{csymp = symtab;
	esymp = symtab + MAXSYMS;
	cprog = progs;
	zprog = progs + MAXPROGS;
	freelist = 0;
	}

stpname (n) name n;
	{pname = n & NAMMASK;
	}

symsprog ()

	{if (cprog >= zprog) fatal ("too many programs");
	cprog->n = 0;
	cprog->p = csymp;
	}

symeprog ()

	{cprog->n = pname;
	++cprog;
	}

symbol symfind (n) name n;

	{symbol p;
	int h;

	n =& NAMMASK;
	h = n % HSHSIZE;
	p = hshtab[h];
	while (p) if (symname(p) == n) return (p); else p=p->next;
	if (csymp>=esymp) fatal ("too many symbols");
	p = csymp++;
	p->sym = n;
	p->val = 0;
	p->next = hshtab[h];
	hshtab[h] = p;
	return (p);
	}

symdef (p, val) symbol p; int val;

	{if (!symdefined (p)) sfixups (p->val, val);
	p->sym =| SYMDBIT;
	p->val = val;
	}

sfixups (l, val) fxlist l; int val;

	{while (l)
		{fxlist next;
		dofixup (l->f, val);
		next = l->p;
		fcreturn (l);
		l = next;
		}
	}	

symaddfix (p, f) symbol p; fixup f;

	{if (symdefined (p))
		bletch ("attempt to add fixup to defined symbol");
	else
		{fxlist l, fcalloc ();
		l = fcalloc ();
		l->f = f;
		l->p = p->val;
		p->val = l;
		}
	}

symulist ()	/* works on original table only */

	{symbol p;
	progent *pp;
	int ucount, lcount;
	name pn, opn;

	pp = progs;
	opn = ucount = 0;
	for (p=symtab;p<csymp;++p)
		{name n;
		int defined;
		while (p == pp->p && pp<cprog)
			{pn = pp->n;
			++pp;
			}
		n = symname (p);
		defined = symdefined (p);
		if (defined) continue;
		if (++ucount == 1)
			cprint ("\n\n --- Undefined Symbols ---");
		if (opn != pn)
			{cprint ("\n\nProgram %x\n", pn);
			opn = pn;
			lcount = 7;
			}
		if (++lcount == 8)
			{cprint ("\n");
			lcount = 0;
			}
		if (lcount != 0) cprint ("\t");
		cprint ("%x", n);
		}
	if (ucount) cprint ("\n");
	}

symlist ()	/* works on rehashed table only */

	{int h;
	cprint ("\n\n --- SYMBOL TABLE ---\n\n");
	for (h=0;h<=02000;++h)
		{symbol p;
		p = hshtab[h];
		while (p)
			{name n;
			int defined;
			n = symname (p);
			defined = symdefined (p);
			cprint ("\t%x\t", n);
			if (defined) cprint ("%13o", symvalue (p));
			else cprint ("    undefined");
			cprint ("\n");
			p = p->next;
			}
		}
	}

symsort ()

	{symungo ();	/* remove undefined symbols */
	symrehash ();	/* rehash, on value */
	}


symungo ()	/* remove undefined symbols */

	{symbol p, q;
	q = symtab;
	for (p=symtab;p<csymp;++p)
		if (symdefined (p))
			{q->sym = p->sym;
			q->val = p->val;
			++q;
			}
	csymp = q;
	}

symrehas ()	/* rehash, on value */

	{symbol p;
	int h;

	for (h=0;h<HSHSIZE;++h) hshtab[h] = 0;
	for (p=symtab;p<csymp;++p)
		{int v;
		symbol current, previous;
		v = symvalue (p);
		if (v & 0777777000000) h = 02000;
		else h = (v >> 8);
		current = hshtab[h];
		previous = 0;
		while (TRUE)
			{if (current==0 || symvalue(current) > v)
				{p->next = current;
				if (previous) previous->next = p;
				else hshtab[h] = p;
				break;
				}
			previous = current;
			current = current->next;
			}
		}
	}

symwrite (jch, ofd)

	{int count, h;
	count = csymp - symtab;
	sostart (count, jch, ofd);
	for (h=0;h<=02000;++h)
		{symbol p;
		p = hshtab[h];
		while (p)
			{soentry (p, jch, ofd);
			p = p->next;
			}
		}
	soend (count, jch, ofd);
	}

fxlist fcalloc ()

	{fxlist p, ep;

	if (freelist==0)
		{freelist = salloc (2*NLALLOC);
		p = freelist;
		ep = p + (NLALLOC-1);
		while (p < ep)
			{p->p = p+1;
			++p;
			}
		ep->p = 0;
		}
	p = freelist;
	freelist = p->p;
	return (p);
	}

fcreturn (p) fxlist p;

	{p->p = freelist;
	freelist = p;
	}
