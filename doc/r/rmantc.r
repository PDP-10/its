.dv xgp
.fo 0 25vg
.fo 1 25vgb
.fo 2 25vgi
.fo 3 40vg
.fo 4 75vbee
.fo 5 18fg
.fo 6 31as
.fo 7 31vg
.fo 8 25as
.fo 9 22fg
.fo F 2AS
.
.tr @
.nr both_sides 1
.sr list_left_margin 500m
.sr list_right_margin 500m
.
.sr asterisk 1**
.sr newline 1newline*
.sr tab 1tab*
.sr quote 8'*
.sr dot dodot()
.
.so r.macros
.
.nr page 2
.begin_table_of_contents 2
.
.
.de index  req page
.elements "\0@.@\1"
.em
.
.so rws/column.rmac
.
.de do_index
.sp 3
Request Index
.sp 2
.new_font 0
.in 0
.ir 0
.ta .5i 1.5i 2i 3i 3.5i 4.5i 5i 6i
.fi
.so rman.index
.hx inter_column_spacing 400m
.columns 4 1 0 0 0 800m
.nf
.new_font 7
.em
.
.
.so rman.toc
.nr verbose 1
