## Documentation

- ITS: [intro](info/intro.29), [primer](_info_/its.primer),
  [building](kshack/build.doc),  
  [Getting Started Computing at the AI Lab](ai_wp_235.pdf)
- DDT: [manual](info/ddt.33), [commands](_info_/ddtord.1462),
  [colon commands](_info_/ddt.:cmnds)
- MIDAS: [manual](info/midas.25)
- DUMP: [manual](_info_/dump.info), [format](sysdoc/dump.format)
- TECO: [primer](_teco_/teco.primer), [manual](info/tecman.20),
  [commands](_teco_/tecord.1132)
- CRTSTY: [manual](info/crtsty.39)
- TCTYP: [manual](_info_/tctyp.order)
- DSKDUMP: [commands](sysdoc/dskdmp.order)

### DDT cheat sheet for Unix users

The `$` character represents typing ESC.

| Unix command  | DDT command          | Colon command            |
| ------------- | -------------------- | ------------------------ |
| login user   	| user$u               | :login user              |
| logout       	| $$u                  | :logout                  |
| ls           	| ^F                   | :listf                   |
| ls dir       	| dir^F                | :listf dir               |
| ls /         	| ^R m.f.d. (file)     | :print m.f.d. (file)     |
| more file    	| ^R file              | :print file              |
| mkdir dir    	| ^R dir;..new. (udir) | :print dir;..new. (udir) |
| cd dir       	| dir$$s               | :cwd dir                 |
| cp f1 f2     	| $^R f1,f2            | :copy f1,f2              |
| rm file      	| ^O file              | :delete file             |
| ln f1 f2     	| $^O f1,f2            | :link f1,f2              |
| mv f1 f2     	| $$^O f1,f2           | :rename f1,f2            |
| mv file dir  	|                      | :move file,dir           |
| ps           	| $$v                  | :listj                   |
| killall -9 id	| id$j  $^X            | :job id  :kill           |
| sudo -u u cmd | u$^S cmd             |                          |
| top           |                      | :peek                    |
