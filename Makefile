ITSTAR=${PWD}/tools/itstar/itstar
WRITETAPE=${PWD}/tools/tapeutils/tapewrite

all: out/rp0.dsk

out/rp0.dsk: build/simh/init out/minsys.tape out/salv.tape out/dskdmp.tape build/build.tcl
	expect -f build/build.tcl

out/minsys.tape: $(ITSTAR)
	mkdir -p out
	cd bin; $(ITSTAR) -cf ../$@ _ sys sys3 sysbin
	cd src; $(ITSTAR) -rf ../$@ system

out/salv.tape: $(WRITETAPE) bin/boot/ram.262 bin/boot/salv.rp06
	mkdir -p out
	$(WRITETAPE) -n 2560 $@ bin/boot/ram.262 bin/boot/salv.rp06

out/dskdmp.tape: $(WRITETAPE) bin/boot/ram.262 bin/boot/dskdmp.rp06
	mkdir -p out
	$(WRITETAPE) -n 2560 $@ bin/boot/ram.262 bin/boot/dskdmp.rp06

$(ITSTAR):
	cd tools/itstar; make

$(WRITETAPE):
	cd tools/tapeutils; make

clean:
	rm -rf out
