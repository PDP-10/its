# Some important environment variables
EMULATOR ?= simh

# Sometimes you _really_ need to use a different `touch` or `rm`.
TOUCH ?= touch
MKDIR ?= mkdir -p
EXPECT ?= expect
RM ?= rm
LN ?= ln
SED ?= sed
TEST ?= test
GIT ?= git
CAT ?= cat

include conf/network

# The directores listed in SRC, DOC, and BIN are put on the sources tape.
SRC = system syseng sysen1 sysen2 sysen3 sysnet kshack dragon channa	\
      midas syshst mrc ksc sra
XSRC = _teco_ emacs emacs1 rms klh eak gren	\
      bawden _mail_ l lisp libdoc comlap lspsrc nilcom rwk chprog rg	\
      inquir acount gz sys decsys ecc alan sail kcc kcc_sy c games archy dcp \
      spcwar rwg libmax rat z emaxim rz maxtul aljabr cffk das ell ellen \
      jim jm jpg macrak maxdoc maxsrc mrg munfas paulw reh rlb rlb% share \
      tensor transl wgd zz graphs lmlib pratt quux scheme gsb ejs mudsys \
      draw wl taa tj6 budd sharem ucode rvb kldcp math as imsrc gls demo \
      macsym lmcons dmcg hack hibou agb gt40
DOC = info _info_ sysdoc sysnet syshst kshack
XDOC = _teco_ emacs emacs1 c kcc \
      chprog sail draw wl pc tj6 share _glpr_ _xgpr_ inquir mudman system \
      xfont maxout ucode moon acount alan channa fonts games graphs humor \
      kldcp libdoc lisp _mail_ midas quux scheme manual
BIN = sys2
XBIN = emacs _teco_ lisp liblsp alan inquir sail comlap c decsys moon \
      graphs draw datdrw fonts fonts1 fonts2 games macsym maint imlac \
      _www_

SUBMODULES = dasm itstar klh10 mldev simh sims supdup tapeutils

ITSCONFIG = $(notdir $(wildcard build/$(EMULATOR)/config.*))

# These files are used to create bootable tape images.
RAM = bin/ks10/boot/ram.262
NSALV = bin/ks10/boot/salv.rp06
DSKDMP = bin/ks10/boot/dskdmp.rp06

KLH10=tools/klh10/tmp/bld-ks-its/kn10-ks-its
SIMH=tools/simh/BIN/pdp10
KA10=tools/sims/BIN/ka10
ITSTAR=tools/itstar/itstar
WRITETAPE=tools/tapeutils/tapewrite
MAGFRM=tools/dasm/magfrm

H3TEXT=$(shell cd build; ls h3text.*)
SMF:=$(addprefix tools/,$(addsuffix /.gitignore,$(SUBMODULES)))
OUT=out/$(EMULATOR)

all: $(SMF) $(OUT)/stamp tools/supdup/supdup

out/klh10/stamp out/simh/stamp: $(OUT)/rp0.dsk
	$(TOUCH) $@

out/sims/stamp: $(OUT)/rp03.2 $(OUT)/rp03.3
	$(TOUCH) $@

$(OUT)/rp0.dsk: build/simh/init $(OUT)/minsys.tape $(OUT)/salv.tape $(OUT)/dskdmp.tape build/build.tcl $(OUT)/sources.tape build/$(EMULATOR)/stamp
	PATH="$(CURDIR)/tools/simh/BIN:$$PATH" expect -f build/$(EMULATOR)/build.tcl $(IP) $(GW)

$(OUT)/rp03.2 $(OUT)/rp03.3: $(OUT)/ka-minsys.tape $(OUT)/magdmp.tap $(OUT)/sources.tape
	$(EXPECT) -f build/$(EMULATOR)/build.tcl $(IP) $(GW)

$(OUT)/magdmp.tap: $(MAGFRM)
	cd bin/ka10/boot; ../../../$(MAGFRM) @.ddt @.salv > ../../../$@

$(OUT)/minsys.tape: $(ITSTAR)
	$(MKDIR) $(OUT)
	$(ITSTAR) -cf $@ -C bin/ks10 _ sys
	$(ITSTAR) -rf $@ -C bin sys

$(OUT)/ka-minsys.tape: $(ITSTAR)
	$(MKDIR) $(OUT)
	$(ITSTAR) -cf $@ -C bin/ka10 _ sys
	$(ITSTAR) -rf $@ -C bin sys

$(OUT)/sources.tape: $(ITSTAR) build/$(EMULATOR)/stamp $(OUT)/syshst/$(H3TEXT)
	$(MKDIR) $(OUT)
	$(RM) -f src/*/*~
	$(TOUCH) -d 1981-10-06T19:03:37 'bin/emacs/einit.:ej'
	$(TOUCH) -d 1981-09-19T21:42:56 'bin/emacs/[pure].162'
	$(TOUCH) -d 1981-03-31T20:41:45 'bin/emacs/[prfy].173'
	$(ITSTAR) -cf $@ -C src $(SRC)
	$(ITSTAR) -rf $@ -C doc $(DOC)
	$(ITSTAR) -rf $@ -C bin $(BIN)
	$(ITSTAR) -rf $@ -C $(OUT) system syshst
	-cd user; ../$(ITSTAR) -rf ../$@ *

$(OUT)/salv.tape: $(WRITETAPE) $(RAM) $(NSALV)
	$(MKDIR) $(OUT)
	$(WRITETAPE) -n 2560 $@ $(RAM) $(NSALV)

$(OUT)/dskdmp.tape: $(WRITETAPE) $(RAM) $(DSKDMP)
	$(MKDIR) $(OUT)
	$(WRITETAPE) -n 2560 $@ $(RAM) $(DSKDMP)

start: build/$(EMULATOR)/start
	$(LN) -s $< $*

$(OUT)/system/$(ITSCONFIG): build/$(EMULATOR)/$(ITSCONFIG)
	$(MKDIR) $(OUT)/system
	cp=0; ca=0; \
	$(TEST) $(CHAOS) != no && cp=1 && ca=$(CHAOS); \
	x=`echo $(IP) | tr . ,`; \
	g=`echo $(GW) | tr . ,`; \
	$(SED) -e "s/%IP%/$$x/" \
	    -e "s/%GW%/$$g/" \
	    -e 's/%NETMASK%/$(NETMASK)/' \
	    -e "s/%CHAOSP%/$$cp/" \
	    -e "s/%CHAOSA%/$$ca/" < $< > $@

build/klh10/stamp: $(KLH10) start build/klh10/dskdmp.ini $(OUT)/system/$(ITSCONFIG)
	$(TOUCH) $@

build/simh/stamp: $(SIMH) start $(OUT)/system/$(ITSCONFIG)
	$(TOUCH) $@

build/sims/stamp: $(KA10) start $(OUT)/system/$(ITSCONFIG)
	$(TOUCH) $@

build/klh10/dskdmp.ini: build/klh10/dskdmp.txt Makefile
	cp=';'; ca=''; \
	$(TEST) $(CHAOS) != no && cp='' && ca='myaddr=$(CHAOS) $(CHAFRIENDS)'; \
	$(SED) -e 's/%IP%/$(IP)/' \
	    -e 's/%GW%/$(GW)/' \
	    -e "s/%CHAOSP%/$$cp/" \
	    -e "s|%CHAOSA%|$$ca|" < $< > $@

$(OUT)/syshst/$(H3TEXT): build/$(H3TEXT)
	$(MKDIR) $(OUT)/syshst
	$(TEST) $(CHAOS) != no && c="CHAOS $(CHAOS), "; \
	$(SED) -e 's/%IP%/$(IP)/' \
	    -e 's/%HOSTNAME%/$(HOSTNAME)/' \
	    -e "s/%CHAOS%/$$c/" < $< > $@
	$(CAT) conf/hosts >> $@

$(KLH10):
	cd tools/klh10; \
	./autogen.sh; \
	$(MKDIR) tmp; \
	cd tmp; \
	export CONFFLAGS_USR=-DKLH10_DEV_DPTM03=0; \
	../configure --bindir="$(CURDIR)/build/klh10"; \
	$(MAKE) base-ks-its; \
	$(MAKE) -C bld-ks-its install

$(SIMH):
	$(MAKE) -C tools/simh pdp10

$(KA10):
	$(MAKE) -C tools/sims ka10 TYPE340=y

$(ITSTAR):
	$(MAKE) -C tools/itstar

$(WRITETAPE):
	$(MAKE) -C tools/tapeutils

$(MAGFRM):
	$(MAKE) -C tools/dasm

tools/supdup/supdup:
	$(MAKE) -C tools/supdup

$(SMF):
	$(GIT) submodule update --init `dirname $@`

clean:
	$(RM) -rf out start build/*/stamp
