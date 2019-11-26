respond "*" ":midas sysbin;_.teco.;teco\r"
expect ":KILL"
respond "*" ":job teco\r"
respond "*" ":load sysbin;teco bin\r"
sleep 2
respond "*" "dumpit\033g"
sleep 2
respond "TECPUR" "\r"
respond "*" ":kill\r"
respond "*" ":link sys;ts teco,.teco.;tecpur >\r"
respond "*" ":link sys;ts t, sys; ts teco\r"

respond "*" ":link sys2;ts emacs,emacs;ts >\r"
respond "*" ":link sys2;ts ne,emacs;ts >\r"
respond "*" ":emacs\r"
respond "EMACS Editor" "\033xrun\033einit\033? Generate\r"
expect -timeout 1000 -exact { -> DSK: EMACS; [PURE]}
expect -timeout 1000 -exact { -> DSK: EMACS; [PRFY]}
expect -timeout 1000 -exact { -> DSK: EMACS; EINIT}
respond ":EJ" "\033xgenerate\033emacs;aux\033emacs1;aux\r"
respond ":EJ" "\030\003"
respond "*" ":kill\r"

respond "*" ":delete emacs;ts 126\r"
respond "*" ":delete \[prfy\] <\r"
respond "*" ":delete \[pure\] 162\r"

respond "*" "emacs\033\023"
respond "*" ":teco\r"
respond "&" "mmrun\033purify\033dump\033ts 163\033\033"
respond "&" "\003"
respond "*" ":kill\r"
respond "*" ":link sys2;ts edit,sys2;ts emacs\r"
respond "*" ":link sys2;ts e, sys2; ts emacs\r"

# BABYL, BABYLM, CACHE, FIXLIB, IVORY, MKDUMP, OUTLINE-MODE, PL1,
# TEACH-C100, TMACS and WORDAB are generated with IVORY.
respond "*" ":emacs\r"
respond "EMACS Editor" "\033xload\033ivory\r"
respond "\n" "\033xgenerate\033emacs;ivory\033emacs1;ivory\r"
respond ":EJ" "\033xgenerate\033emacs;pl1\033emacs1;pl1\r"
respond ":EJ" "\033xgenerate\033emacs;wordab\033emacs1;wordab\r"
respond ":EJ" "\033xgenerate\033emacs;tmacs\033emacs1;tmacs\033tmucs\r"
respond ":EJ" "\033xgenerate\033emacs;babyl\033emacs1;babyl\033babylm\r"
respond ":EJ" "\030\003"
respond "*" ":kill\r"

respond "*" ":emacs\r"
respond "EMACS Editor" "\033xload\033purify\r"
respond "\n" "\033xgenerate\033emacs;abstr\033emacs1;abstr\r"
respond ":EJ" "\033xgenerate\033emacs;auto-s\033emacs1;auto-s\r"
respond ":EJ" "\033xbare\033emacs1;bare\r"
respond "\n" "\033xgenerate\033emacs;c\033emacs1;c\r"
respond ":EJ" "\033xgenerate\033emacs;delim\033emacs1;delim\r"
respond ":EJ" "\033xgenerate\033emacs;dired\033emacs1;dired\r"
respond ":EJ" "\033xgenerate\033emacs;doclsp\033emacs1;doclsp\r"
respond ":EJ" "\033xgenerate\033emacs;docond\033emacs1;docond\r"
respond ":EJ" "\033xgenerate\033emacs;doctor\033emacs1;doctor\r"
respond ":EJ" "\033xgenerate\033emacs;env\033dcp;eenv\r"
respond ":EJ" "\033xgenerate\033emacs;elisp\033emacs1;elisp\r"
respond ":EJ" "\033xgenerate\033emacs;info\033emacs1;info\r"
respond ":EJ" "\033xgenerate\033emacs;kbdmac\033emacs1;kbdmac\r"
respond ":EJ" "\033xgenerate\033emacs;ledit\033emacs1;ledit\r"
respond ":EJ" "\033xgenerate\033emacs;lispt\033emacs1;lispt\r"
respond ":EJ" "\033xgenerate\033emacs;lsputl\033emacs1;lsputl\r"
respond ":EJ" "\033xgenerate\033emacs;lunar\033moon;lunar\r"
respond ":EJ" "\033xgenerate\033emacs;maxima\033emacs1;maxima\r"
respond ":EJ" "\033xgenerate\033emacs;mazlib\033emacs1;mazlib\r"
respond ":EJ" "\033xgenerate\033emacs;modlin\033emacs1;modlin\r"
respond ":EJ" "\033xgenerate\033emacs;muddle\033emacs1;muddle\r"
respond ":EJ" "\033xgenerate\033emacs;page\033emacs1;page\r"
respond ":EJ" "\033xgenerate\033emacs;pictur\033emacs1;pictur\r"
respond ":EJ" "\033xgenerate\033emacs;qsend\033ejs;qsend\r"
respond ":EJ" "\033xgenerate\033emacs;\[rmai\]\033emacs1;rmailx\033rmailz\r"
respond ":EJ" "\033xgenerate\033emacs;runoff\033emacs1;runoff\r"
respond ":EJ" "\033xgenerate\033emacs;scribe\033emacs1;scribe\r"
respond ":EJ" "\033xgenerate\033emacs;scrlin\033emacs1;scrlin\r"
respond ":EJ" "\033xgenerate\033emacs;slowly\033emacs1;slowly\r"
respond ":EJ" "\033xgenerate\033emacs;sort\033emacs1;sort\r"
respond ":EJ" "\033xgenerate\033emacs;tags\033emacs1;tags\r"
respond ":EJ" "\033xgenerate\033emacs;taggen\033emacs1;taggen\r"
respond ":EJ" "\033xgenerate\033emacs;tdebug\033emacs1;tdebug\r"
respond ":EJ" "\033xgenerate\033emacs;tex\033emacs1;tex\r"
respond ":EJ" "\033xgenerate\033emacs;texmac\033emacs1;texmac\r"
respond ":EJ" "\033xgenerate\033emacs;time\033emacs1;time\r"
respond ":EJ" "\033xgenerate\033emacs;trmtyp\033emacs1;trmtyp\r"
respond ":EJ" "\033xgenerate\033emacs;vt100\033emacs1;vt100\r"
respond ":EJ" "\033xgenerate\033emacs;vt52\033emacs1;vt52\r"
respond ":EJ" "\033xgenerate\033emacs;xlisp\033emacs1;xlisp\r"
respond ":EJ" "\033xgenerate\033emacs;renum\033emacs1;renum\r"
respond ":EJ" "\033xgenerate\033emacs;pascal\033emacs1;pascal\r"

respond ":EJ" "\033xrun\033einit\033? Document\r"
respond "\n" "\030\003"
respond "*" ":kill\r"

respond "*" ":rename emacs;\[rmai\] \021:ej, emacs;\[rmai\] 147\r"

# make TS BABYL
respond "*" ":midas sys3;ts babyl_kmp;babyl\r"
expect ":KILL"

# INFO
# For some unknown reason, we can't use a printing terminal when
# generating a new TSINFO.  Temporarily switch to AAA.
respond "*" ":tctyp aaa\r"
expect ":KILL"
respond "*" "info\033\023"
respond "*" ":emacs\r"
expect "INFO Dumped"
expect ":KILL"
respond "*" ":tctyp la36"
# Race condition here.  Since the terminal type is set to AAA, the CR
# character is stored as %TDCRL in the output buffer.  But if TCTYP
# changes the terminal type to LA36 before the %TDCRL is processed,
# the code outputs nothing since that is the behavior on a printing
# terminal.
send "\r"
expect ":KILL"
# The previous file version was 62, dated 1982-01-05.
respond "*" ":rename emacs; tsinfo >, tsinfo 63\r"
respond "*" ":link sys2;ts info,emacs;tsinfo >\r"
respond "*" ":link sys2;ts h, sys2; ts info\r"

respond "*" ":emacs\r"
respond "EMACS Editor" "\033XLoad Library\033docond\r"
respond "\n" "\030\006"
respond "Find File" "info; infod >\r"
respond "\n" "\033Xdocond\r"
respond "Alternative:" "ITS\r"
respond "\n" "\030\023"
respond "Write File" "info; info 48\r"
respond "Written" "\030\003"
respond "*" ":kill\r"

# VIEW
respond "*" ":emacs\r"
respond "EMACS Editor" "\033xload\033purify\r"
respond "\n" "\033x& compress file\033turnip; view >\r"
respond "Compressing file" "\030\003"
respond "*" ":kill\r"
respond "*" ":tctyp aaa\r"
respond "*" ":cwd kmp\r"
respond "*" "kmp\033\023"
respond "*" ":dumpt \033turnip;view\r"
expect "Dumped to"
respond "*" ":tctyp la36"
# Race condition.  See previous :tctyp la36.
send "\r"
respond "*" ":move turnip; ts view, sys3;\r"

# VDIR
respond "*" ":link sys3; ts vdir, ts view\r"

# RMODE
respond "*" ":link sys1; ts rmode, .teco.;\r"

# Make TECORD within Emacs work
respond "*" ":link info;tecord 999999,.teco.;tecord >\r"
