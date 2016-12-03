
!* -*-TECO-*- *!

!* This is the EMACS init for INFO.  It sets up the EMACS/INFO environment
   necessary for dumping a new INFO EJ file.
 *!

 :i*INFO m.vEditor Name
 :i..jINFO
 m(m.m Select Buffer)*INFO*


!* Create startup macro to be run when we're 'd.!
 @:i*|	m(m.mLoad Library)INFO    !* load the INFO library!
	fj :0k hfx1		    !* Q1 gets JCL, sans CR.  It is MMINFO!
				    !* Enter's arg.!
	:m..l
     | m.vMM & Startup INFO

!* Create ..L macro to be run if we're G'd afterward.!
 @:i..l|
	fs echolines-3"g 3 fs echolinesw'
	
 |

!* When ^K'd, we do a ^R, thus executing this string and entering INFO.!
 @:i*|	@:i*%	m(m.m& Recursive ^R Set Mode)
		m(m.mInfo Enter)
		160000. fs exit
	    % fs ^R enterw
	m(m.m& Recursive ^R Set Mode)
	m(m.mInfo Enter)1
	160000. fs exit
     | fs ^R enterw

 m(m.aPURIFYDump Environment)EMACS;TSINFO >

 FTINFO Dumped

 160000. fs exit
