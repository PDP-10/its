:stink d
1L DECSYS;DECBOT BIN
.JBSA/STRT
56/107
:
********* OK, now do the following *********
	:DELETE DATDRW;D OBIN
	:RENAME DATDRW;D BIN, D OBIN
	:PDUMP  DATDRW;D BIN	; This is the file linked to by SYS1;TS D
