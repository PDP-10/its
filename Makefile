EMULATOR ?= simh

SRC = system syseng sysen1 sysen2 sysnet kshack midas _teco_ rms klh
MINSYS = _ sys sys3 device
RAM = bin/boot/ram.262
NSALV = bin/boot/salv.rp06
DSKDMP = bin/boot/dskdmp.rp06

ITSTAR=${PWD}/tools/itstar/itstar
WRITETAPE=${PWD}/tools/tapeutils/tapewrite

all: out/rp0.dsk

out/rp0.dsk: build/simh/init out/minsys.tape out/salv.tape out/dskdmp.tape build/build.tcl out/sources.tape build/$(EMULATOR)/stamp
	expect -f build/$(EMULATOR)/build.tcl

out/minsys.tape: $(ITSTAR)
	mkdir -p out
	cd bin; $(ITSTAR) -cf ../$@ $(MINSYS)

out/sources.tape: $(ITSTAR)
	mkdir -p out
	cd src; $(ITSTAR) -cf ../$@ $(SRC)

out/salv.tape: $(WRITETAPE) $(RAM) $(NSALV)
	mkdir -p out
	$(WRITETAPE) -n 2560 $@ $(RAM) $(NSALV)

out/dskdmp.tape: $(WRITETAPE) $(RAM) $(DSKDMP)
	mkdir -p out
	$(WRITETAPE) -n 2560 $@ $(RAM) $(DSKDMP)

$(ITSTAR):
	cd tools/itstar; make

$(WRITETAPE):
	cd tools/tapeutils; make

clean:
	rm -rf out
