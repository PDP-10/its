!	The purpose of this hack is to much MIDAS rel files
!	and insert ENTRY blocks before each module with INTERNs

	program hack
	integer wrd,typ,lh,rh,len,buffer,ptr,recnum
	common ptr,buffer(10000)

	call opnfil
	recnum=0
1	read(20,end=999) wrd
	recnum=recnum+1
	call stuff(wrd)

	typ=lh(wrd)
	len=rh(wrd)
!	type *,'record: ', recnum,' type ',typ, ', length ',len
	if( typ == 0) then		!illegal
		stop '? type 0 block read'
	else if( typ == 1 ) then	!code
		call copy(len)
	else if( typ == 2 ) then	!symbols
		call type2
	else if( typ == 3 ) then	!hiseg
		call copy(len)
	else if( typ == 4 ) then	!entry
		type *, '% ENTRY block read.. copying...'
		call copy(len)
	else if( typ == 5 ) then	!end
		call copy(len)
		call copy1
		call dump
	else if( typ == 6 ) then	!name
		call copy(len)
	else if( typ == 7 ) then	!start
		type *,'% START block read.. copying...'
		call copy(len)
	else
		type *,'? Unknown block ', typ,' @ record ',recnum
		stop 'quitting'
	end if
	goto 1

999	close(20)
	close(21)
	type *, recnum, ' records copied'
	end

	subroutine opnfil
	character*20 name

	type *,'input file'
	accept 1000, name
1000	format(a)
	open(20,dialog=name,mode='image',access='seqin')

	type *,'output file'
	accept 1000, name
	open(21,dialog=name,mode='image',access='seqout')
	end

	subroutine copy(l)
	integer l,wrd,cnt,t,i,ptr

	cnt=l
10	if( cnt == 0 ) return
	call copy1			!copy relocation

	t=cnt
	if( cnt > 18 ) t=18
	do i=1,t
		call copy1
		cnt=cnt-1
	end do
	goto 10
	end

	subroutine copy1
	integer wrd
	read(20,end=999) wrd
	call stuff(wrd)
	return
999	stop '? EOF in copy1'
	end

	subroutine type2(l)
	integer l,l2,wrd,t,ptr,tfld,bits

	l2=l				!copy length

10	if( l2 <= 0 ) return		!if no more words, return
	call copy1			!copy relocation
	t=l2
	if( t > 18 ) t=18		!upto 18 words

20	read(20,end=999) wrd		!read symbol name
	call stuff(wrd)
	bits=tfld(wrd)			!get type bits
	if(bits == 4 .OR. bits == 24 .OR. bits == 44 ) then !entry?
		call mkent(wrd)
	end if
	call copy1			!copy value
	l2=l2-2
	t=t-2
	if( t > 0 ) goto 20
	goto 10

999	stop '? eof in type2'
	end

	subroutine stuff(w)
	integer w,ptr,buffer
	common ptr,buffer(10000)
	ptr=ptr+1
	if( ptr > 10000) stop '? write overflow'
	buffer(ptr)=w
	end

	subroutine dump
	integer ptr,buffer
	common ptr,buffer(10000)
	if( ptr == 0 ) return
	call dmpent
	write(21) (buffer(i), i=1,ptr)
	ptr=0
	end

	subroutine mkent(n)
	integer n,cnt,buf
	common /ent/ cnt,buf(100)
	if( cnt == 100 ) call dmpent
	cnt = cnt + 1
	buf(cnt) = n
	end

	subroutine dmpent
	integer cnt,ptr,t,buf
	common /ent/ cnt,buf(100)

100	if( cnt == 0 ) return		!none to do
	ptr=1				!start at first one
	write(21) cnt+"4000000		!entry block

110	if( cnt == 0 ) return		!any more?
	write(21) 0			!reloc for next 18 (must be 0)
	t=cnt
	if( t > 18 ) t=18		!do upto 18

120	write(21) buf(ptr)		!write name
	ptr=ptr+1
	t=t-1
	cnt=cnt-1
	if( t > 0 ) goto 120		!anymore in this group?

	goto 110			!no, do next group
	end