#!/bin/sh

out="$PWD/$1"

mkdir .tmp
cp bin/ka10/boot/* .tmp
cd .tmp
../tools/itstar/itstar xf $out/reboot.tape
mv _/salv.bin .
../tools/dasm/magfrm magdmp.bin @.ddt salv.bin > $out/magdmp2.tap
cd ..
rm -rf .tmp
exit 0
