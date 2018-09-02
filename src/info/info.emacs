
!* -*-TECO-*- *!

!* This is the EMACS init for INFO.  It sets up the EMACS/INFO environment
   necessary for dumping a new INFO EJ file.
 *!

 :i*INFO m.vEditor Name	    !* Editor Name and ..J must match!
 :i..jINFO			    !* when the initial ^R is entered!
				    !* so that our *Initialization* gets called.!
 :i**INFO*m(m.m Select Buffer)


!* Create startup macro to be run when we're 'd.!
 @:i*|	m(m.mLoad Library)INFO    !* load the INFO library!
	fj :0k hfx1 0fsmodif		    !* Q1 gets JCL, sans CR.  It is MM INFO Enter's arg.!
	:m..l
     | m.vMM & Startup INFO

!* When ^K'd, we do a ^R, thus executing this string and entering INFO.!
 @:i*|  fq1"l :i1'
	qINFO *Initialization* U*Initialization*
	0fsmode mac
	m(m.mInfo Enter)1
	160000. fs exit
     | m.v*Initialization*
 q*Initialization* m.vINFO *Initialization*

 fs osteco"e
   m(m.aPURIFYDump Environment)EMACS;TSINFO >'
 "#
   m(m.aPURIFYDump Environment)<EMACS>NINFO.EXE'

 FTINFO Dumped

 160000. fs exit
