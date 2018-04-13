# Old? Scheme interpreter
respond "*" "complr\013"
respond "_" "scheme;_nschsy\r"
respond "_" "\032"
type ":kill\r"
respond "*" ":lisp\r"
respond "Alloc?" "n"
respond "*" {(load "scheme; nschsy fasl")}
respond "\n" "(schemedump)"
respond "==>" "(quit)"

# Rabbit Scheme compiler
respond "*" ":scheme;scheme\r"
respond "==>" {(schload "scheme; rabbit")}
respond "==>" {(comfile "scheme; rabbit")}
expect -timeout 3600 "COMPILE TIME:"
respond "==>" "(quit)"
respond "*" ":complr\r"
respond "_" "scheme;_rabbit lisp\r"
respond "_" "\032"
type ":kill\r"
respond "*" ":scheme;scheme\r"
respond "==>" {(schload "scheme; rabbit fasl")}
respond "==>" "(dumpit)"
respond "Dump anyway" " "
respond "TS RABBIT" "\r"

# New Scheme interpreter
respond "*" "complr\013"
respond "_" "nschem;scheme interp_schint lsp\r"
respond "_" "nschem;scheme macros_schmac lsp\r"
respond "_" "nschem;scheme uuohan_schuuo lsp\r"
respond "_" "\032"
type ":kill\r"
respond "*" ":lisp scheme (dump)\r"
