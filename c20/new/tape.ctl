! CTL file to make PCC20 Distribution tape
! JTW 3/26/82
@define tape: mta0:
@enable
@delete c:pcc.stat.*
@dumper
*tape tape:
*list tape.files
*ssname DOC FILES
*save <c.doc>*.*.*
*ssname SYS: FILES
*save sys:cc.exe,sys:stinkr.exe,sys:midas.exe
*ssname <C> FILES
*save ps:<c>*.*.*
*ssname INCLUDE FILES
*save ps:<c.include>*.*.*
*ssname CLIB: FILES 
*save <c.lib>*.*.*
*ssname SOURCE FILES
*save ps:<c.sources>*.*.*
*unload
*exit
@undelete c:pcc.stat
@disable
@logout
