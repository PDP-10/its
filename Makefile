EMULATOR ?= simh

SRC = system syseng sysen1 sysen2 sysnet kshack dragon channa midas _teco_ emacs rms klh syshst sra mrc ksc cstacy gren bawden emacs1 _mail_ l lisp liblsp libdoc comlap
DOC = info _info_ sysdoc kshack _teco_ emacs emacs1
MINSYS = _ sys sys2 sys3 device emacs _teco_ sysbin inquir

RAM = bin/boot/ram.262
NSALV = bin/boot/salv.rp06
DSKDMP = bin/boot/dskdmp.rp06

KLH10=${PWD}/tools/klh10/tmp/bld-ks-its/kn10-ks-its 
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
	rm -f src/system/config.*
	cp build/$(EMULATOR)/config.* src/system
	rm -f src/*/*~
	cd src; $(ITSTAR) -cf ../$@ $(SRC)
	cd doc; $(ITSTAR) -rf ../$@ $(DOC)

out/salv.tape: $(WRITETAPE) $(RAM) $(NSALV)
	mkdir -p out
	$(WRITETAPE) -n 2560 $@ $(RAM) $(NSALV)

out/dskdmp.tape: $(WRITETAPE) $(RAM) $(DSKDMP)
	mkdir -p out
	$(WRITETAPE) -n 2560 $@ $(RAM) $(DSKDMP)

build/klh10/stamp: $(KLH10)
	touch $@

$(KLH10):
	cd tools/klh10; \
	./autogen.sh; \
	mkdir tmp; \
	cd tmp; \
	export CONFFLAGS_USR=-DKLH10_DEV_DPTM03=0; \
	../configure --bindir=${PWD}/build/klh10; \
	make base-ks-its; \
	make -C bld-ks-its install

$(ITSTAR):
	cd tools/itstar; make

$(WRITETAPE):
	cd tools/tapeutils; make

clean:
	rm -rf out
