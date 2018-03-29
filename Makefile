EMULATOR ?= simh

include conf/network

# The directores listed in SRC, DOC, and BIN are put on the sources tape.
SRC = system syseng sysen1 sysen2 sysen3 sysnet kshack dragon channa	\
      midas _teco_ emacs emacs1 rms klh syshst sra mrc ksc eak gren	\
      bawden _mail_ l lisp libdoc comlap lspsrc nilcom rwk chprog rg	\
      inquir acount gz sys decsys ecc alan sail kcc kcc_sy c games archy dcp \
      spcwar rwg libmax rat z emaxim rz maxtul aljabr cffk das ell ellen \
      jim jm jpg macrak maxdoc maxsrc mrg munfas paulw reh rlb rlb% share \
      tensor transl wgd zz graphs lmlib pratt nschem scheme gsb
DOC = info _info_ sysdoc sysnet syshst kshack _teco_ emacs emacs1 c kcc chprog
BIN = sys2 emacs _teco_ lisp liblsp alan inquir sail comlap c decsys moon graphs

SUBMODULES = dasm itstar klh10 mldev simh sims supdup tapeutils

# These files are used to create bootable tape images.
RAM = bin/ks10/boot/ram.262
NSALV = bin/ks10/boot/salv.rp06
DSKDMP = bin/ks10/boot/dskdmp.rp06

KLH10=${PWD}/tools/klh10/tmp/bld-ks-its/kn10-ks-its 
SIMH=${PWD}/tools/simh/BIN/pdp10
KA10=${PWD}/tools/sims/BIN/ka10
ITSTAR=${PWD}/tools/itstar/itstar
WRITETAPE=${PWD}/tools/tapeutils/tapewrite
MAGFRM=${PWD}/tools/dasm/magfrm

H3TEXT=$(shell cd build; ls h3text.*)
SMF:=$(addprefix tools/,$(addsuffix /.gitignore,$(SUBMODULES)))

all: $(SMF) out/$(EMULATOR).stamp tools/supdup/supdup

out/klh10.stamp out/simh.stamp: out/rp0.dsk
	touch $@

out/sims.stamp: out/rp03.2 out/rp03.3
	touch $@

out/rp0.dsk: build/simh/init out/minsys.tape out/salv.tape out/dskdmp.tape build/build.tcl out/sources.tape build/$(EMULATOR)/stamp
	PATH=${PWD}/tools/simh/BIN:$$PATH expect -f build/$(EMULATOR)/build.tcl $(IP) $(GW)

out/rp03.2 out/rp03.3: out/ka-minsys.tape out/magdmp.tap out/sources.tape
	expect -f build/$(EMULATOR)/build.tcl $(IP) $(GW)

out/magdmp.tap: $(MAGFRM)
	cd bin/ka10/boot; $(MAGFRM) @.ddt @.salv > ../../../$@

out/minsys.tape: $(ITSTAR)
	mkdir -p out
	cd bin/ks10; $(ITSTAR) -cf ../../$@ _ sys
	cd bin; $(ITSTAR) -rf ../$@ sys

out/ka-minsys.tape: $(ITSTAR)
	mkdir -p out
	cd bin/ka10; $(ITSTAR) -cf ../../$@ _ sys
	cd bin; $(ITSTAR) -rf ../$@ sys

out/sources.tape: $(ITSTAR) build/$(EMULATOR)/stamp src/syshst/$(H3TEXT)
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
	cp=0; ca=0; \
	test $(CHAOS) != no && cp=1 && ca=$(CHAOS); \
	x=`echo $(IP) | tr . ,`; \
	sed -e "s/%IP%/$$x/" \
	    -e 's/%NETMASK%/$(NETMASK)/' \
	    -e "s/%CHAOSP%/$$cp/" \
	    -e "s/%CHAOSA%/$$ca/" < build/klh10/config.203 > src/system/config.203
	touch $@

build/simh/stamp: $(SIMH) start
	cp build/simh/config.* src/system
	touch $@

build/sims/stamp: $(KA10) start
	cp build/sims/config.* src/system
	touch $@

build/klh10/dskdmp.ini: build/klh10/dskdmp.txt Makefile
	cp=';'; ca=''; \
	test $(CHAOS) != no && cp='' && ca='myaddr=$(CHAOS) $(CHAFRIENDS)'; \
	sed -e 's/%IP%/$(IP)/' \
	    -e 's/%GW%/$(GW)/' \
	    -e "s/%CHAOSP%/$$cp/" \
	    -e "s|%CHAOSA%|$$ca|" < $< > $@

src/syshst/$(H3TEXT): build/$(H3TEXT)
	test $(CHAOS) != no && c="CHAOS $(CHAOS), "; \
	sed -e 's/%IP%/$(IP)/' \
	    -e 's/%HOSTNAME%/$(HOSTNAME)/' \
	    -e "s/%CHAOS%/$$c/" < $< > $@
	cat conf/hosts >> $@

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

$(KA10):
	cd tools/sims; make ka10 TYPE340=y

$(ITSTAR):
	cd tools/itstar; make

$(WRITETAPE):
	cd tools/tapeutils; make

$(MAGFRM):
	cd tools/dasm; make

tools/supdup/supdup:
	cd tools/supdup; make

$(SMF):
	git submodule update --init `dirname $@`

clean:
	rm -rf out start build/*/stamp src/system/config.* src/syshst/h3text.*
