# Some important environment variables
EMULATOR ?= simh

# Sometimes you _really_ need to use a different `touch` or `rm`.
TOUCH ?= touch
MKDIR ?= mkdir -p
EXPECT ?= expect
CP ?= cp
RM ?= rm
LN ?= ln
SED ?= sed
TEST ?= test
GIT ?= git
CAT ?= cat

include conf/network

# The directores listed in SRC, DOC, and BIN are put on the sources tape.
SRC = syseng sysen1 sysen2 sysen3 sysnet kshack dragon channa	\
      _teco_ emacs emacs1 rms klh syshst sra mrc ksc eak gren	\
      bawden _mail_ l lisp libdoc comlap lspsrc nilcom rwk chprog rg	\
      inquir acount gz sys decsys ecc alan sail kcc kcc_sy c games archy dcp \
      spcwar rwg libmax rat z emaxim rz maxtul aljabr cffk das ell ellen \
      jim jm jpg macrak maxdoc maxsrc mrg munfas paulw reh rlb rlb% share \
      tensor transl wgd zz graphs lmlib pratt quux scheme gsb ejs mudsys \
      draw wl taa tj6 budd sharem ucode rvb kldcp math as imsrc gls demo \
      macsym lmcons dmcg hack hibou agb gt40 rug maeda ms kle aap common \
      fonts zork 11logo kmp info aplogo bkph bbn pdp11 chsncp sca music1 \
      moon teach ken lmio1
DOC = info _info_ sysdoc sysnet syshst kshack _teco_ emacs emacs1 c kcc \
      chprog sail draw wl pc tj6 share _glpr_ _xgpr_ inquir mudman system \
      xfont maxout ucode moon acount alan channa fonts games graphs humor \
      kldcp libdoc lisp _mail_ midas quux scheme manual wp chess ms macdoc \
      aplogo _klfe_ pdp11 chsncp cbf rug bawden
BIN = sys2 emacs _teco_ lisp liblsp alan inquir sail comlap c decsys \
      graphs draw datdrw fonts fonts1 fonts2 games macsym maint imlac \
      _www_ hqm gt40
MINSRC = midas system $(DDT) $(SALV) $(KSFEDR) $(DUMP)

# These are not included on the tape.
DOCIGNORE=-e '\.(jpeg|pdf|info|md)$$' -e '^(dcg|github)$$'
# These are on the minsys tape.
BINIGNORE=-e '^(ka10|ks10|sys)$$'
# These are on the minsrc tape.
SRCIGNORE=-e '^(system|midas)$$'

SUBMODULES = dasm itstar klh10 mldev simh sims supdup tapeutils

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
GT40=tools/simh/BIN/pdp11 $(OUT)/bootvt.img

H3TEXT=$(shell cd build; ls h3text.*)
DDT=$(shell cd src; ls sysen1/ddt.* syseng/lsrtns.* syseng/msgs.* syseng/datime.*)
SALV=$(shell cd src; ls kshack/nsalv.* syseng/format.* syseng/rfn.*)
KSFEDR=$(shell cd src; ls kshack/ksfedr.*)
DUMP=$(shell cd src; ls syseng/dump.* sysnet/netwrk.*)
SMF:=$(addprefix tools/,$(addsuffix /.gitignore,$(SUBMODULES)))
OUT=out/$(EMULATOR)

all: $(SMF) $(OUT)/stamp tools/supdup/supdup

check: all check-dirs

out/klh10/stamp: $(OUT)/rp0.dsk
	$(TOUCH) $@

out/simh/stamp: $(OUT)/rp0.dsk $(GT40)
	$(TOUCH) $@

out/sims/stamp: $(OUT)/rp03.2 $(OUT)/rp03.3 $(GT40)
	$(TOUCH) $@

$(OUT)/rp0.dsk: build/simh/init $(OUT)/minsys.tape $(OUT)/minsrc.tape $(OUT)/salv.tape $(OUT)/dskdmp.tape build/build.tcl $(OUT)/sources.tape build/$(EMULATOR)/stamp
	PATH="$(CURDIR)/tools/simh/BIN:$$PATH" expect -f build/$(EMULATOR)/build.tcl $(IP) $(GW)

$(OUT)/rp03.2 $(OUT)/rp03.3: $(OUT)/ka-minsys.tape $(OUT)/minsrc.tape $(OUT)/magdmp.tap $(OUT)/sources.tape
	$(EXPECT) -f build/$(EMULATOR)/build.tcl $(IP) $(GW)

$(OUT)/magdmp.tap: $(MAGFRM)
	cd bin/ka10/boot; ../../../$(MAGFRM) @.ddt @.salv > ../../../$@

$(OUT)/minsrc.tape: $(ITSTAR)
	$(MKDIR) $(OUT)
	$(ITSTAR) -cf $@ -C src $(MINSRC)
	$(ITSTAR) -rf $@ -C $(OUT) system

$(OUT)/minsys.tape: $(ITSTAR) $(OUT)/system
	$(MKDIR) $(OUT)
	$(ITSTAR) -cf $@ -C bin/ks10 _ sys
	$(ITSTAR) -rf $@ -C bin sys

$(OUT)/ka-minsys.tape: $(ITSTAR) $(OUT)/system
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
	$(ITSTAR) -rf $@ -C $(OUT) syshst
	-cd user; ../$(ITSTAR) -rf ../$@ *

$(OUT)/salv.tape: $(WRITETAPE) $(RAM) $(NSALV)
	$(MKDIR) $(OUT)
	$(WRITETAPE) -n 2560 $@ $(RAM) $(NSALV)

$(OUT)/dskdmp.tape: $(WRITETAPE) $(RAM) $(DSKDMP)
	$(MKDIR) $(OUT)
	$(WRITETAPE) -n 2560 $@ $(RAM) $(DSKDMP)

$(OUT)/bootvt.bin: $(OUT)/output.tape
	$(RM) -rf $(OUT)/tmp
	$(MKDIR) -p $(OUT)/tmp
	$(ITSTAR) -xf $< -C $(OUT)/tmp
	$(CP) $(OUT)/tmp/gt40/bootvt.bin $@
	$(RM) -rf $(OUT)/tmp

tools/dasm/palx: tools/dasm/palx.c
	$(MAKE) -C tools/dasm palx

$(OUT)/bootvt.img: $(OUT)/bootvt.bin tools/dasm/palx
	$(MKDIR) out/gt40
	tools/dasm/palx -I < $< > $@

start: build/$(EMULATOR)/start
	$(LN) -s $< $*

build/klh10/stamp: $(KLH10) start build/klh10/dskdmp.ini
	$(TOUCH) $@

build/simh/stamp: $(SIMH) start
	$(TOUCH) $@

build/sims/stamp: $(KA10) start
	$(TOUCH) $@

out/klh10/system:
	$(MKDIR) $(OUT)/system
	cp=0; ca=0; \
	$(TEST) $(CHAOS) != no && cp=1 && ca=$(CHAOS); \
	x=`echo $(IP) | tr . ,`; \
	$(SED) -e "s/%IP%/$$x/" \
	    -e 's/%NETMASK%/$(NETMASK)/' \
	    -e "s/%CHAOSP%/$$cp/" \
	    -e "s/%CHAOSA%/$$ca/" < build/klh10/config.203 > $(OUT)/system/config.203

out/simh/system:
	$(MKDIR) $(OUT)/system
	cp build/simh/config.* $(OUT)/system

out/sims/system:
	$(MKDIR) $(OUT)/system
	cp build/sims/config.* $(OUT)/system

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
	$(RM) -rf tmp; \
	./autogen.sh; \
	$(MKDIR) tmp; \
	cd tmp; \
	export CONFFLAGS_USR=-DKLH10_DEV_DPTM03=0; \
	../configure --enable-lights --bindir="$(CURDIR)/build/klh10"; \
	$(MAKE) -C bld-ks-its; \
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
	$(GIT) submodule sync `dirname $@`
	$(GIT) submodule update --init `dirname $@`

tools/simh/BIN/pdp11:
	$(MAKE) -C tools/simh pdp11

check-dirs: Makefile
	mkdir -p $(OUT)/check
	echo $(SRC) | tr ' ' '\n' | sort > $(OUT)/check/src1
	cd src; ls -1 | egrep -v $(SRCIGNORE) > ../$(OUT)/check/src2
	diff -u $(OUT)/check/src1 $(OUT)/check/src2 > $(OUT)/check/src.diff
	echo $(DOC) | tr ' ' '\n' | sort > $(OUT)/check/doc1
	cd doc; ls -1d */ | tr -d / | sort | \
		egrep -v $(DOCIGNORE) > ../$(OUT)/check/doc2
	diff -u $(OUT)/check/doc1 $(OUT)/check/doc2 > $(OUT)/check/doc.diff
	echo $(BIN) | tr ' ' '\n' | sort > $(OUT)/check/bin1
	cd bin; ls -1 | egrep -v $(BINIGNORE) > ../$(OUT)/check/bin2
	diff -u $(OUT)/check/bin1 $(OUT)/check/bin2 > $(OUT)/check/bin.diff

clean:
	$(RM) -rf out start build/*/stamp
