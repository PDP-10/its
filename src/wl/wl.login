:STINK WL
1L DECSYS;DECBOT BIN
.JBSA/STRT
56/107
:
********* OK, now do the following *********
	:DELETE DATDRW;NODIPS OBIN
	:RENAME DATDRW;NODIPS BIN, NODIPS OBIN
	:PDUMP  DATDRW;NODIPS BIN	; This is the file linked to by SYS1;TS NODIPS
	:GO
	"TOP MODE"
	XRESIDENT		;read in NDIPS.DIP and dump it out

