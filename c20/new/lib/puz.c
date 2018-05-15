/* an undocumented, compute-bound program from forest baskett */


#define	size	511	/* d*d*d - 1 */
#define	classMax 3
#define	typeMax	12
#define	d	8
#define	true	1
#define	false	0

#define	pieceCount	pCount
#define	pieceMax	pMax

/*type	pieceClass =	0..classMax;
	pieceType =	0..typeMax;
	position =	0..size;*/

int
	pieceCount[classMax+1],
	class[typeMax+1],
	pieceMax[typeMax+1],
	puzzle[size+1],
	m,n,
	i,j,k,
	kount;
short	p[typeMax+1][size+1];

int fit (i, j) int i, j;
{
register int	k, *plim, *puz; register short *piece;

	k = pieceMax[i];
	piece = &p[i][0];
	plim = &puzzle[j+k];
	for (puz = &puzzle[j]; puz <= plim; puz++)
		if( *piece++ && *puz ) return(false);
	return(true);
}

int place (i, j) int i, j;
{
register int k, *pjk, *pklim; register short *pik, *plim;

	pik = p[i];
	pjk = &puzzle[j];
	plim = &pik[pieceMax[i]];
	while (pik <= plim)
	       {
		if( *pik ) *pjk = true;
		pik++; pjk++;
	       }
	pieceCount[class[i]]--;
	pjk = &puzzle[j];
	for (k = j; k <= size; k++)
	       {
		if( ! *pjk ) return(k);
		pjk++;
	       }
	printf("puzzle filled\n");
	return(0);
};

remove(i, j) int i, j;
{
register int *pjk, *pklim; register short *pik, *plim;

	pik = p[i];
	pjk = &puzzle[j];
	plim = &pik[pieceMax[i]];
	while (pik <= plim)
	       {
		if( *pik ) *pjk = false;
		pik++; pjk++;
	       }
	pieceCount[class[i]]++;
}

int trial(j) int j;
{

register int i, k, *ci;

	ci = class;
	for( i = 0; i <= typeMax; i++)
		if( pieceCount[*ci++] )
			if( fit (i, j) ) {
				k = place (i, j);
				if( trial(k) || (k == 0) ) {
					printf("piece %d at %d\n",i+1,k+1);
					kount++;
					return(true);
				} else remove (i, j);
			};
	kount++;
	return(false);
}

main(){
	for( m = 0; m <= size; m++) puzzle[m] = true;
	for( i = 1; i <= 5; i++) for( j = 1; j <= 5; j++) for( k = 1; k <= 5; k++)
		puzzle[i+d*(j+d*k)] = false;
	for( i = 0; i <= typeMax; i++) for( m = 0; m <= size; m++) p[i][m] = false;
	for( i = 0; i <= 3; i++) for( j = 0; j <= 1; j++) for( k = 0; k <= 0; k++)
		p[0][i+d*(j+d*k)] = true;
	class[0] = 0;
	pieceMax[0] = 3+d*1+d*d*0;
	for( i = 0; i <= 1; i++) for( j = 0; j <= 0; j++) for( k = 0; k <= 3; k++)
		p[1][i+d*(j+d*k)] = true;
	class[1] = 0;
	pieceMax[1] = 1+d*0+d*d*3;
	for( i = 0; i <= 0; i++) for( j = 0; j <= 3; j++) for( k = 0; k <= 1; k++)
		p[2][i+d*(j+d*k)] = true;
	class[2] = 0;
	pieceMax[2] = 0+d*3+d*d*1;
	for( i = 0; i <= 1; i++) for( j = 0; j <= 3; j++) for( k = 0; k <= 0; k++)
		p[3][i+d*(j+d*k)] = true;
	class[3] = 0;
	pieceMax[3] = 1+d*3+d*d*0;
	for( i = 0; i <= 3; i++) for( j = 0; j <= 0; j++) for( k = 0; k <= 1; k++)
		p[4][i+d*(j+d*k)] = true;
	class[4] = 0;
	pieceMax[4] = 3+d*0+d*d*1;
	for( i = 0; i <= 0; i++) for( j = 0; j <= 1; j++) for( k = 0; k <= 3; k++)
		p[5][i+d*(j+d*k)] = true;
	class[5] = 0;
	pieceMax[5] = 0+d*1+d*d*3;
	for( i = 0; i <= 2; i++) for( j = 0; j <= 0; j++) for( k = 0; k <= 0; k++)
		p[6][i+d*(j+d*k)] = true;
	class[6] = 1;
	pieceMax[6] = 2+d*0+d*d*0;
	for( i = 0; i <= 0; i++) for( j = 0; j <= 2; j++) for( k = 0; k <= 0; k++)
		p[7][i+d*(j+d*k)] = true;
	class[7] = 1;
	pieceMax[7] = 0+d*2+d*d*0;
	for( i = 0; i <= 0; i++) for( j = 0; j <= 0; j++) for( k = 0; k <= 2; k++)
		p[8][i+d*(j+d*k)] = true;
	class[8] = 1;
	pieceMax[8] = 0+d*0+d*d*2;
	for( i = 0; i <= 1; i++) for( j = 0; j <= 1; j++) for( k = 0; k <= 0; k++)
		p[9][i+d*(j+d*k)] = true;
	class[9] = 2;
	pieceMax[9] = 1+d*1+d*d*0;
	for( i = 0; i <= 1; i++) for( j = 0; j <= 0; j++) for( k = 0; k <= 1; k++)
		p[10][i+d*(j+d*k)] = true;
	class[10] = 2;
	pieceMax[10] = 1+d*0+d*d*1;
	for( i = 0; i <= 0; i++) for( j = 0; j <= 1; j++) for( k = 0; k <= 1; k++)
		p[11][i+d*(j+d*k)] = true;
	class[11] = 2;
	pieceMax[11] = 0+d*1+d*d*1;
	for( i = 0; i <= 1; i++) for( j = 0; j <= 1; j++) for( k = 0; k <= 1; k++)
		p[12][i+d*(j+d*k)] = true;
	class[12] = 3;
	pieceMax[12] = 1+d*1+d*d*1;
	pieceCount[0] = 13;
	pieceCount[1] = 3;
	pieceCount[2] = 1;
	pieceCount[3] = 1;
	m = 1+d*(1+d*1);
	kount = 0;
	if( fit(0, m) ) n = place(0, m); else printf("error 1\n");
	if( trial(n) ) printf("success in %d\n", kount); 
	else printf("failure\n");
}
