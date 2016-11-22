## DDT cheat sheet for Unix users

To get access to a terminal, first type ^Z (Control-Z).  After that,
you can log in.

The `$` character represents typing ESC.

| Unix command  | DDT command          | Colon command            |
| ------------- | -------------------- | ------------------------ |
| login user    | user$u               | :login user              |
| logout        | $$u                  | :logout                  |
| TERM=vt52     |                      | :tctyp vt52              |
| TERM=vt100    |                      | :crtsty vt100            |
| ls            | ^F                   | :listf                   |
| ls dir        | dir^F                | :listf dir               |
| ls /          | ^R m.f.d. (file)     | :print m.f.d. (file)     |
| more file     | ^R file              | :print file              |
| mkdir dir     | ^R dir;..new. (udir) | :print dir;..new. (udir) |
| cd dir        | dir$$s               | :cwd dir                 |
| cp f1 f2      | $^R f1,f2            | :copy f1,f2              |
| rm file       | ^O file              | :delete file             |
| ln f1 f2      | $^O f1,f2            | :link f1,f2              |
| mv f1 f2      | $$^O f1,f2           | :rename f1,f2            |
| mv file dir   |                      | :move file,dir           |
| emacs         | emacs^K              | :emacs                   |
| ps            | $$v                  | :listj                   |
| kill pid      | pid$^X               | :job pid  :kill          |
| sudo -u u cmd | u$^S cmd             |                          |
| top           |                      | :peek                    |
| ^U            | ^D                   |                          |
| ^C            | ^G                   |                          |
| ^Z            | ^Z                   |                          |
| ^D            | ^C                   |                          |
| fg            | $P                   | :continue                |
| bg            | ^P                   | :proceed                 |
