:stink lay
1L DECSYS;DECBOT BIN
.JBSA/STRT
56/107
:
********* OK, now do the following *********
	:DELETE DATDRW;Lay OBIN
	:RENAME DATDRW;Lay BIN, Lay OBIN
	:PDUMP  DATDRW;Lay BIN	; This is the file linked to by SYS1;TS LAY
