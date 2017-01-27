EMULATOR ?= simh
IP=192.168.1.100
GW=192.168.0.45
NETMASK=255,255,255,248

# The directores listed in SRC, DOC, and BIN are put on the sources tape.
SRC = system syseng sysen1 sysen2 sysen3 sysnet kshack dragon channa	\
      midas _teco_ emacs emacs1 rms klh syshst sra mrc ksc eak gren	\
      bawden _mail_ l lisp libdoc comlap lspsrc nilcom rwk	\
      inquir acount gz sys decsys ecc alan sail kcc
DOC = info _info_ sysdoc sysnet kshack _teco_ emacs emacs1
BIN = sys2 device emacs _teco_ lisp liblsp alan inquir sail comlap

# These directories are put on the minsys tape.
MINSYS = _ sys

# These files are used to create bootable tape images.
RAM = bin/boot/ram.262
NSALV = bin/boot/salv.rp06
DSKDMP = bin/boot/dskdmp.rp06

KLH10=${PWD}/tools/klh10/tmp/bld-ks-its/kn10-ks-its 
SIMH=${PWD}/tools/simh/BIN/pdp10
ITSTAR=${PWD}/tools/itstar/itstar
WRITETAPE=${PWD}/tools/tapeutils/tapewrite

all: out/rp0.dsk tools/supdup/supdup

out/rp0.dsk: build/simh/init out/minsys.tape out/salv.tape out/dskdmp.tape build/build.tcl out/sources.tape build/$(EMULATOR)/stamp
	PATH=${PWD}/tools/simh/BIN:$$PATH expect -f build/$(EMULATOR)/build.tcl $(IP) $(GW)

out/minsys.tape: $(ITSTAR)
	mkdir -p out
	cd bin; $(ITSTAR) -cf ../$@ $(MINSYS)

out/sources.tape: $(ITSTAR) build/$(EMULATOR)/stamp src/syshst/h3text.2012
	mkdir -p out
	rm -f src/*/*~
	cd src; $(ITSTAR) -cf ../$@ $(SRC)
	cd doc; $(ITSTAR) -rf ../$@ $(DOC)
	cd bin; $(ITSTAR) -rf ../$@ $(BIN)
	-cd user; $(ITSTAR) -rf ../$@ *

out/salv.tape: $(WRITETAPE) $(RAM) $(NSALV)
	mkdir -p out
	$(WRITETAPE) -n 2560 $@ $(RAM) $(NSALV)

out/dskdmp.tape: $(WRITETAPE) $(RAM) $(DSKDMP)
	mkdir -p out
	$(WRITETAPE) -n 2560 $@ $(RAM) $(DSKDMP)

start: build/$(EMULATOR)/start
	ln -s $< $*

build/klh10/stamp: $(KLH10) start build/klh10/dskdmp.ini
	x=`echo $(IP) | tr . ,`; sed -e "s/%IP%/$$x/" -e 's/%NETMASK%/$(NETMASK)/' < build/klh10/config.203 > src/system/config.203
	touch $@

build/simh/stamp: $(SIMH) start
	cp build/simh/config.* src/system
	touch $@

build/klh10/dskdmp.ini: build/klh10/dskdmp.txt Makefile
	sed -e 's/%IP%/$(IP)/' -e 's/%GW%/$(GW)/' < $< > $@

src/syshst/h3text.2012: build/h3text.2012
	sed -e 's/%IP%/$(IP)/' < $< > $@

$(KLH10):
	cd tools/klh10; \
	./autogen.sh; \
	mkdir tmp; \
	cd tmp; \
	export CONFFLAGS_USR=-DKLH10_DEV_DPTM03=0; \
	../configure --bindir=${PWD}/build/klh10; \
	make base-ks-its; \
	make -C bld-ks-its install

$(SIMH):
	cd tools/simh; make pdp10

$(ITSTAR):
	cd tools/itstar; make

$(WRITETAPE):
	cd tools/tapeutils; make

tools/supdup/supdup:
	cd tools/supdup; make

clean:
	rm -rf out start build/*/stamp src/system/config.* src/syshst/h3text.*
