## DDT cheat sheet for Unix users

To get access to a terminal, first type <kbd>^Z</kbd> (Control-Z).
After that, you can log in.

The ◊ character represents typing <kbd>ESC</kbd>, or holding down the
<kbd>Meta</kbd> key.  On a text terminal, it will show up as `$`.

| Unix command  | DDT command          | Colon command            |
| ------------- | -------------------- | ------------------------ |
| login user    | user◊u               | :login user              |
| logout        | ◊◊u                  | :logout                  |
| TERM=vt52     |                      | :tctyp vt52              |
| TERM=vt100    |                      | :tctyp aaa               |
| TERM=ansi     |                      | :crtsty ansi             |
| clear         | <kbd>^L</kbd>        | :clear                   |
| ls            | <kbd>^F</kbd>        | :listf                   |
| ls -l         | ◊◊<kbd>^F</kbd>      | :lf                      |
| ls dir        | dir<kbd>^F</kbd>     | :listf dir               |
| ls /          | <kbd>^R</kbd> m.f.d. (file)     | :print m.f.d. (file)     |
| ls *.foo      | <kbd>^R</kbd> dir: second foo   | :print dir: second foo   |
| more file     | <kbd>^R</kbd> file              | :print file              |
| mkdir dir     | <kbd>^R</kbd> dir;..new. (udir) | :print dir;..new. (udir) |
| cd dir        | dir◊<kbd>^S</kbd>               | :cwd dir                 |
| /foo/bar      |                                 | :foo;bar                 |
| cp f1 f2      | ◊<kbd>^R</kbd> f1,f2            | :copy f1,f2              |
| rm file       | <kbd>^O</kbd> file              | :delete file             |
| ln f1 f2      | ◊<kbd>^O</kbd> f1,f2            | :link f1,f2              |
| mv f1 f2      | ◊◊<kbd>^O</kbd> f1,f2           | :rename f1,f2            |
| mv file dir   |                      | :move file,dir           |
| emacs         | emacs<kbd>^K</kbd>   | :emacs                   |
| ps            | ◊◊v                  | :listj                   |
| kill pid      | pid◊<kbd>^X</kbd>    | :job pid *then* :kill    |
| kill -9 pid   |                      | :lock *then* pid gun     |
| sudo -u u cmd | u◊◊<kbd>^S</kbd> cmd |                          |
| top           | peek<kbd>^H</kbd>    | :peek                    |
| <kbd>^U</kbd> | <kbd>^D</kbd>        |                          |
| <kbd>^C</kbd> | <kbd>^G</kbd>        |                          |
| <kbd>^Z</kbd> | <kbd>^Z</kbd>        |                          |
| <kbd>^D</kbd> | <kbd>^C</kbd>        |                          |
| fg            | ◊P                   | :continue                |
| bg            | <kbd>^P</kbd>        | :proceed                 |
| man 2 open    |                      | :call open               |
| dmesg         |                      | :sysmsg                  |
| uptime        |                      | :time                    |
