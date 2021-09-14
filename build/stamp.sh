#!/bin/sh

# Update timestamps to those listed in the file passed as $1.
# Those timestamps are always in Eastern Standard Time.
# If there's no timestamp, we take the latest git author date.


list="$PWD/$1"
OTZ="$TZ"
export TZ

timestamps(){
    for i in */*; do
        set -f
        t=`fgrep -- "$i " "$list" 2>/dev/null`
        if test -n "$t"; then
            set -- $t
            t="$2"
            TZ=EST
        else
            t=`git log -1 --date=format:%Y%m%d%H%M.%S --format=%cd -- "$1"`
            TZ="$OTZ"
        fi
        touch -h -t "$t" -- "$i"
    done
}

(cd bin; timestamps)
(cd doc; timestamps)
(cd src; timestamps)

exit 0
