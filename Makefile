EMULATOR ?= simh

include conf/network

# The directores listed in SRC, DOC, and BIN are put on the sources tape.
SRC = system syseng sysen1 sysen2 sysen3 sysnet kshack dragon channa	\
      midas _teco_ emacs emacs1 rms klh syshst sra mrc ksc eak gren	\
      bawden _mail_ l lisp libdoc comlap lspsrc nilcom rwk chprog rg	\
      inquir acount gz sys decsys ecc alan sail kcc kcc_sy c games archy dcp \
      spcwar rwg libmax rat z emaxim rz maxtul aljabr cffk das ell ellen \
      jim jm jpg macrak maxdoc maxsrc mrg munfas paulw reh rlb rlb% share \
      tensor transl wgd zz graphs lmlib pratt quux scheme gsb ejs mudsys \
      draw wl taa tj6 budd sharem ucode rvb kldcp math
DOC = info _info_ sysdoc sysnet syshst kshack _teco_ emacs emacs1 c kcc \
      chprog sail draw wl pc tj6 share _glpr_ _xgpr_ inquir mudman system \
      xfont maxout ucode moon acount alan channa fonts games graphs humor \
      kldcp libdoc lisp _mail_ midas quux scheme
BIN = sys2 emacs _teco_ lisp liblsp alan inquir sail comlap c decsys moon \
      graphs draw datdrw fonts fonts1 fonts2 games macsym maxer1

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
OUT=out/$(EMULATOR)

all: $(SMF) $(OUT)/stamp tools/supdup/supdup

out/klh10/stamp out/simh/stamp: $(OUT)/rp0.dsk
	touch $@

out/sims/stamp: $(OUT)/rp03.2 $(OUT)/rp03.3
	touch $@

$(OUT)/rp0.dsk: build/simh/init $(OUT)/minsys.tape $(OUT)/salv.tape $(OUT)/dskdmp.tape build/build.tcl $(OUT)/sources.tape build/$(EMULATOR)/stamp
	PATH=${PWD}/tools/simh/BIN:$$PATH expect -f build/$(EMULATOR)/build.tcl $(IP) $(GW)

$(OUT)/rp03.2 $(OUT)/rp03.3: $(OUT)/ka-minsys.tape $(OUT)/magdmp.tap $(OUT)/sources.tape
	expect -f build/$(EMULATOR)/build.tcl $(IP) $(GW)

$(OUT)/magdmp.tap: $(MAGFRM)
	cd bin/ka10/boot; $(MAGFRM) @.ddt @.salv > ../../../$@

$(OUT)/minsys.tape: $(ITSTAR)
	mkdir -p $(OUT)
	cd bin/ks10; $(ITSTAR) -cf ../../$@ _ sys
	cd bin; $(ITSTAR) -rf ../$@ sys

$(OUT)/ka-minsys.tape: $(ITSTAR)
	mkdir -p $(OUT)
	cd bin/ka10; $(ITSTAR) -cf ../../$@ _ sys
	cd bin; $(ITSTAR) -rf ../$@ sys

$(OUT)/sources.tape: $(ITSTAR) build/$(EMULATOR)/stamp $(OUT)/syshst/$(H3TEXT)
	mkdir -p $(OUT)
	rm -f src/*/*~
	cd src; $(ITSTAR) -cf ../$@ $(SRC)
	#cd doc; $(ITSTAR) -rf ../$@ $(DOC)
	cd bin; $(ITSTAR) -rf ../$@ $(BIN)
	cd $(OUT); $(ITSTAR) -rf ../../$@ system syshst
	-cd user; $(ITSTAR) -rf ../$@ *

$(OUT)/salv.tape: $(WRITETAPE) $(RAM) $(NSALV)
	mkdir -p $(OUT)
	$(WRITETAPE) -n 2560 $@ $(RAM) $(NSALV)

$(OUT)/dskdmp.tape: $(WRITETAPE) $(RAM) $(DSKDMP)
	mkdir -p $(OUT)
	$(WRITETAPE) -n 2560 $@ $(RAM) $(DSKDMP)

start: build/$(EMULATOR)/start
	ln -s $< $*

build/klh10/stamp: $(KLH10) start build/klh10/dskdmp.ini
	mkdir -p $(OUT)/system
	cp=0; ca=0; \
	test $(CHAOS) != no && cp=1 && ca=$(CHAOS); \
	x=`echo $(IP) | tr . ,`; \
	sed -e "s/%IP%/$$x/" \
	    -e 's/%NETMASK%/$(NETMASK)/' \
	    -e "s/%CHAOSP%/$$cp/" \
	    -e "s/%CHAOSA%/$$ca/" < build/klh10/config.203 > $(OUT)/system/config.203
	touch $@

build/simh/stamp: $(SIMH) start
	mkdir -p $(OUT)/system
	cp build/simh/config.* $(OUT)/system
	touch $@

build/sims/stamp: $(KA10) start
	mkdir -p $(OUT)/system
	cp build/sims/config.* $(OUT)/system
	touch $@

build/klh10/dskdmp.ini: build/klh10/dskdmp.txt Makefile
	cp=';'; ca=''; \
	test $(CHAOS) != no && cp='' && ca='myaddr=$(CHAOS) $(CHAFRIENDS)'; \
	sed -e 's/%IP%/$(IP)/' \
	    -e 's/%GW%/$(GW)/' \
	    -e "s/%CHAOSP%/$$cp/" \
	    -e "s|%CHAOSA%|$$ca|" < $< > $@

$(OUT)/syshst/$(H3TEXT): build/$(H3TEXT)
	mkdir -p $(OUT)/syshst
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
	rm -rf out start build/*/stamp
