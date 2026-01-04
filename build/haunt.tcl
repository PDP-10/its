log_progress "ENTERING BUILD SCRIPT: HAUNT"

cwd "haunt"

# build ops4
complr {"haunt;_haunt;ops4 lsp"}

# dump ops4
respond "*" "lisp\013"
respond "Alloc?" "n\r"
respond "*" "(load '((haunt) ops4 load))"
respond "T" "(dump-it)"
respond ":\$Job Suspended\$" ":pdump haunt;ts ops4\r"
type ":kill\r"

# build compile haunt lisp code
complr {"haunt;_haunt;comman lsp" "haunt;_haunt;haunt lsp"
        "haunt;_haunt;slurp lsp" "haunt;_haunt;tlist lsp"
        "haunt;_haunt;user lsp"}

# dump haunt
respond "*" ":haunt;ops4\r"
respond "(CREATED" "(load '((haunt) haunt load))"
respond ":\$Job Suspended\$" ":sl sys;purqio >\r"
respond "*" ":pdump haunt;ts haunt\r"
type ":kill\r"

# make available in SYS:
make_link "sys3;ts haunt" "haunt;ts haunt"
make_link "sys3;ts ops4" "haunt;ts ops4"
