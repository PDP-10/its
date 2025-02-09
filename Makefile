# Some important environment variables
EMULATOR ?= pdp10-ka

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
WGET ?= wget
TAR ?= tar
EGREP ?= grep -E

ifeq ($(EMULATOR),pdp10-ka)
MCHN ?= KA
else
ifeq ($(EMULATOR),pdp10-kl)
MCHN ?= KL
else
MCHN ?= DB
endif
endif

IMAGES=http://hactrn.kostersitz.com/images
SIMHV3_URL=http://simh.trailing-edge.com/sources

include conf/network

# if user hasn't changed HOSTNAME, and MCHN is not DB, then update HOSTNAME
ifeq ($(HOSTNAME),DB-ITS.EXAMPLE.COM)
  ifneq ($(MCHN),DB)
    HOSTNAME = $(MCHN)-ITS.EXAMPLE.COM
  endif
endif

# The directores listed in SRC, DOC, and BIN are put on the sources tape.
SRC = syseng sysen1 sysen2 sysen3 sysnet kshack dragon channa	\
      _teco_ emacs emacs1 rms klh syshst sra mrc ksc eak gren	\
      bawden l lisp libdoc comlap lspsrc nilcom rwk chprog rg	\
      inquir acount gz sys decsys ecc alan sail kcc kcc_sy c games archy dcp \
      spcwar rwg libmax rat z emaxim rz maxtul aljabr cffk das ell ellen \
      jim jm jpg macrak maxdoc maxsrc mrg munfas paulw reh rlb rlb% share \
      tensor transl wgd zz graphs lmlib pratt quux scheme gsb ejs mudsys \
      draw wl taa tj6 budd sharem ucode rvb kldcp math as imsrc gls demo \
      macsym lmcons dmcg hibou agb gt40 rug maeda ms kle aap common \
      fonts lcf 11logo kmp info aplogo bkph bbn pdp11 chsncp sca music1 \
      moon teach ken lmio1 llogo a2deh chsgtv clib sys3 lmio turnip \
      mits_s rab stan_k bs cstacy kp dcp2 -pics- victor imlac rjl mb bh \
      lars drnil radia gjd maint bolio cent shrdlu vis cbf digest prs jsf \
      decus bsg muds54 hello rrs 2500 minsky danny survey librm3 librm4 \
      klotz atlogo clusys cprog r eb cpm mini nova sits nlogo bee gld mprog2 \
      cfs libmud librm1 librm2 mprog mprog1 mudbug mudsav _batch combat \
      mits_b minits spacy _xgpr_ haunt elf
DOC = info _info_ sysdoc sysnet syshst kshack _teco_ emacs emacs1 c kcc \
      chprog sail draw wl pc tj6 share _glpr_ _xgpr_ inquir mudman system \
      xfont maxout ucode moon acount alan channa fonts games graphs humor \
      kldcp libdoc lisp _mail_ midas quux scheme manual wp chess ms macdoc \
      aplogo _temp_ pdp11 chsncp cbf rug bawden llogo eak clib teach pcnet \
      combat pdl minits mits_s chaos hal -pics- imlac maint cent ksc klh \
      digest prs decus bsg madman hur lmdoc rrs danny netwrk klotz hello \
      clu r mini nova sits jay rjl nlogo mprog2 mudbug cfs hudini shrdlu \
      elf
BIN = sys sys1 sys2 emacs _teco_ lisp liblsp alan sail comlap \
      c decsys graphs draw datdrw fonts fonts1 fonts2 games macsym \
      maint _www_ gt40 llogo bawden sysbin -pics- lmman shrdlu imlac \
      pdp10 madman survey rrs clu clucmp rws mini mudsav mudsys libmud \
      librm1 librm2 librm3 librm4 mbprog mprog1 mprog mprog2 mudbug mudtmp \
      _batch
MINSRC = midas system $(DDT) $(SALV) $(KSFEDR) $(DUMP)

# These are not included on the tape.
DOCIGNORE=-e '\.(jpeg|pdf|info|md)$$' -e '^(dcg|github)$$'
# These are on the minsys tape.
BINIGNORE=-e '^(ka10|kl10|ks10|minsys)$$'
# These are on the minsrc tape.
SRCIGNORE=-e '^(system|midas)$$'

SUBMODULES = dasm itstar klh10 mldev simh sims supdup cbridge \
	tapeutils tv11 pdp6 vt05 tek4010 chaosnet-tools ncp

# These files are used to create bootable tape images.
RAM = bin/ks10/boot/ram.262
NSALV = bin/ks10/boot/salv.rp06
DSKDMP = bin/ks10/boot/dskdmp.rp06

KLH10=tools/klh10/tmp/bld-ks-its/kn10-ks-its
SIMH=tools/simh/BIN/pdp10
KA10=tools/sims/BIN/pdp10-ka
KL10=tools/sims/BIN/pdp10-kl
KS10=tools/sims/BIN/pdp10-ks
SIMHV3=tools/simhv3/BIN/pdp10
ITSTAR=tools/itstar/itstar
WRITETAPE=tools/tapeutils/tapewrite
MAGFRM=tools/dasm/magfrm
GT40=tools/simh/BIN/pdp11 $(OUT)/bootvt.img
TV11=tools/tv11/tv11
XGP11=tools/tv11/xgp11
PDP6=tools/pdp6/emu/pdp6
KLFEDR=tools/dasm/klfedr
DATAPOINT=tools/vt05/dp3300
VT52=tools/vt05/vt52
TEK=tools/tek4010/tek4010
SIMH_IMLAC=tools/simh/BIN/imlac $(OUT)/ssv22.iml
IMP=tools/simh/BIN/h316
NCPD=tools/ncp/src/ncpd

H3TEXT=$(shell cd build; ls h3text.*)
NAMES=$(shell cd build; ls names.*)
DDT=$(shell cd src; ls sysen1/ddt.* syseng/lsrtns.* syseng/msgs.* syseng/datime.* syseng/ntsddt.*)
SALV=$(shell cd src; ls kshack/nsalv.* syseng/format.* syseng/rfn.*)
KSFEDR=$(shell cd src; ls kshack/ksfedr.*)
DUMP=$(shell cd src; ls syseng/dump.* sysnet/netwrk.*)
SMF:=$(addprefix tools/,$(addsuffix /.gitignore,$(SUBMODULES)))
OUT=out/$(EMULATOR)

all: its $(OUT)/stamp/test $(OUT)/stamp/emulators \
	tools/supdup/supdup tools/cbridge/cbridge \
	tools/chaosnet-tools/shutdown

its: $(SMF) $(OUT)/stamp/its

download: $(SMF) $(OUT)/stamp/pdp10
	$(WGET) $(IMAGES)/$(EMULATOR).tgz
	$(TAR) xzf $(EMULATOR).tgz
	$(MKDIR) $(OUT)/stamp
	$(TOUCH) $(OUT)/stamp/touch
	$(CP) -r $(EMULATOR)/syshst $(OUT)
	$(CP) -r $(EMULATOR)/system $(OUT)
	$(CP) $(EMULATOR)/*.tape $(OUT)
	$(CP) $(EMULATOR)/rp0* $(OUT)
	-$(CP) $(EMULATOR)/*.rim $(OUT)
	$(CP) $(EMULATOR)/dskdmp* $(OUT)
	$(TOUCH) $(OUT)/stamp/its

check: all check-dirs

out/klh10/stamp/its: $(OUT)/rp0.dsk
	$(MKDIR) $(OUT)/stamp
	$(TOUCH) $@

out/klh10/stamp/emulators:
	$(MKDIR) $(OUT)/stamp
	$(TOUCH) $@

out/simh/stamp/its: $(OUT)/rp0.dsk
	$(MKDIR) $(OUT)/stamp
	$(TOUCH) $@

out/simh/stamp/emulators: $(GT40) $(VT52)
	$(MKDIR) $(OUT)/stamp
	$(TOUCH) $@

out/pdp10-ka/stamp/its: $(OUT)/rp03.2 $(OUT)/rp03.3
	$(MKDIR) $(OUT)/stamp
	$(TOUCH) $@

out/pdp10-ka/stamp/emulators: $(GT40) $(TV11) $(XGP11) $(PDP6) $(DATAPOINT) $(VT52) $(TEK) $(SIMH_IMLAC) $(IMP) $(NCPD)
	$(MKDIR) $(OUT)/stamp
	$(TOUCH) $@

out/pdp10-kl/stamp/its: $(OUT)/rp04.1
	$(MKDIR) $(OUT)/stamp
	$(TOUCH) $@

out/pdp10-kl/stamp/emulators: $(VT52) $(TEK) $(IMP) $(NCPD)
	$(MKDIR) $(OUT)/stamp
	$(TOUCH) $@

out/pdp10-ks/stamp/its: $(OUT)/rp0.dsk
	$(MKDIR) $(OUT)/stamp
	$(TOUCH) $@

out/pdp10-ks/stamp/emulators: $(GT40) $(VT52)
	$(MKDIR) $(OUT)/stamp
	$(TOUCH) $@

out/simhv3/stamp/its: $(OUT)/rp0.dsk
	$(MKDIR) $(OUT)/stamp
	$(TOUCH) $@

out/simhv3/stamp/emulators: $(GT40) $(VT52)
	$(MKDIR) $(OUT)/stamp
	$(TOUCH) $@

$(OUT)/rp0.dsk: build/simh/init $(OUT)/minsys.tape $(OUT)/minsrc.tape $(OUT)/salv.tape $(OUT)/dskdmp.tape build/build.tcl $(OUT)/sources.tape $(OUT)/stamp/pdp10
	PATH="$(CURDIR)/tools/$(EMULATOR)/BIN:$$PATH" expect -f build/$(EMULATOR)/build.tcl $(IP) $(GW)

$(OUT)/rp03.2 $(OUT)/rp03.3: $(OUT)/ka-minsys.tape $(OUT)/minsrc.tape $(OUT)/magdmp.tap $(OUT)/sources.tape
	$(EXPECT) -f build/$(EMULATOR)/build.tcl $(IP) $(GW)

$(OUT)/rp04.1: $(OUT)/kl-minsys.tape $(OUT)/minsrc.tape $(OUT)/kl-magdmp.tap $(OUT)/sources.tape
	$(EXPECT) -f build/$(EMULATOR)/build.tcl $(IP) $(GW)

$(OUT)/magdmp.tap: $(MAGFRM)
	cd bin/ka10/boot; ../../../$(MAGFRM) magdmp.bin @.ddt salv.bin > ../../../$@

$(OUT)/kl-magdmp.tap: $(MAGFRM)
	cd bin/kl10/boot; ../../../$(MAGFRM) magdmp.bin @.ddt salv.bin > ../../../$@

$(OUT)/stamp/touch: build/timestamps.txt
	build/stamp.sh $<
	$(MKDIR) $(OUT)/stamp
	$(TOUCH) $@

$(OUT)/minsrc.tape: $(OUT)/stamp/touch $(ITSTAR)
	$(MKDIR) $(OUT)
	$(ITSTAR) -cf $@ -C src $(MINSRC)
	$(ITSTAR) -rf $@ -C $(OUT) system

$(OUT)/minsys.tape: $(OUT)/stamp/touch $(ITSTAR) $(OUT)/system
	$(MKDIR) $(OUT)
	$(ITSTAR) -cf $@ -C bin/ks10 _ sys
	$(ITSTAR) -rf $@ -C bin/minsys sys

$(OUT)/ka-minsys.tape: $(OUT)/stamp/touch $(ITSTAR) $(OUT)/system
	$(MKDIR) $(OUT)
	$(ITSTAR) -cf $@ -C bin/ka10 _ sys
	$(ITSTAR) -rf $@ -C bin/minsys sys

leftparen:=(
rightparen:=)
KLDCPDIR=$(OUT)/_klfe_/kldcp.$(leftparen)dir$(rightparen)

$(OUT)/kl-minsys.tape: $(OUT)/stamp/touch $(ITSTAR) $(OUT)/system $(KLDCPDIR)
	$(MKDIR) $(OUT)
	$(ITSTAR) -cf $@ -C $(OUT) _klfe_
	$(ITSTAR) -rf $@ -C bin/kl10 _ sys
	$(ITSTAR) -rf $@ -C bin/minsys sys

$(KLDCPDIR): $(KLFEDR)
	$(MKDIR) $(OUT)/_klfe_
	$(KLFEDR) > "$(OUT)/_klfe_/kldcp.$(leftparen)dir$(rightparen)"

$(OUT)/sources.tape: $(OUT)/stamp/touch $(ITSTAR) $(OUT)/stamp/pdp10 $(OUT)/syshst/$(H3TEXT) $(OUT)/_mail_/$(NAMES)
	$(MKDIR) $(OUT)
	$(RM) -f src/*/*~
	$(ITSTAR) -cf $@ -C src $(SRC)
	$(ITSTAR) -rf $@ -C doc $(DOC)
	$(ITSTAR) -rf $@ -C bin $(BIN)
	$(ITSTAR) -rf $@ -C $(OUT) syshst
	$(ITSTAR) -rf $@ -C $(OUT) _mail_

$(OUT)/salv.tape: $(WRITETAPE) $(RAM) $(NSALV)
	$(MKDIR) $(OUT)
	$(WRITETAPE) -n 2560 $@ $(RAM) $(NSALV)

$(OUT)/dskdmp.tape: $(WRITETAPE) $(RAM) $(DSKDMP)
	$(MKDIR) $(OUT)
	$(WRITETAPE) -n 2560 $@ $(RAM) $(DSKDMP)

$(OUT)/bootvt.bin $(OUT)/aplogo.ptp $(OUT)/ssv22.iml: $(OUT)/output.tape
	$(RM) -rf $(OUT)/tmp
	$(MKDIR) -p $(OUT)/tmp
	$(ITSTAR) -xf $< -C $(OUT)/tmp
	$(CP) $(OUT)/tmp/gt40/bootvt.bin $(OUT)/bootvt.bin
	-$(CP) $(OUT)/tmp/imlac/ssv22.iml $(OUT)/ssv22.iml
	-$(CP) $(OUT)/tmp/aplogo/logo.ptp $(OUT)/aplogo.ptp
	$(RM) -rf $(OUT)/tmp

tools/dasm/palx: tools/dasm/palx.c
	$(MAKE) -C tools/dasm palx

$(OUT)/bootvt.img: $(OUT)/bootvt.bin tools/dasm/palx
	$(MKDIR) out/gt40
	tools/dasm/palx -I < $< > $@

out/pdp10-ka/stamp/test: out/pdp10-ka/stamp/its
	$(KA10) build/pdp10-ka/hhtest.simh
	$(TOUCH) $@

out/simh/stamp/test:

out/klh10/stamp/test:

out/pdp10-kl/stamp/test:

out/pdp10-ks/stamp/test:

out/simhv3/stamp/test:

start: build/$(EMULATOR)/start
	$(LN) -s $< $*

out/klh10/stamp/pdp10:: $(KLH10) start out/klh10/dskdmp.ini
	$(MKDIR) $(OUT)/stamp
	$(TOUCH) $@

out/simh/stamp/pdp10: $(SIMH) start out/simh/boot
	$(MKDIR) $(OUT)/stamp
	$(TOUCH) $@

out/pdp10-ka/stamp/pdp10: $(KA10) start out/pdp10-ka/run
	$(MKDIR) $(OUT)/stamp
	$(TOUCH) $@

out/pdp10-kl/stamp/pdp10: $(KL10) start out/pdp10-kl/run
	$(MKDIR) $(OUT)/stamp
	$(TOUCH) $@

out/pdp10-ks/stamp/pdp10: $(KS10) start out/pdp10-ks/run
	$(MKDIR) $(OUT)/stamp
	$(TOUCH) $@

out/simhv3/stamp/pdp10: $(SIMHV3) start
	$(MKDIR) $(OUT)/stamp
	$(TOUCH) $@

out/klh10/system:
	$(MKDIR) $(OUT)/system
	x=`echo $(IP) | tr . ,`; \
	$(SED) -e "s/%IP%/$$x/" \
	    -e 's/%NETMASK%/$(NETMASK)/' < build/klh10/config.203 > $(OUT)/system/config.203

out/simh/system:
	$(MKDIR) $(OUT)/system
	cp build/simh/config.* $(OUT)/system

out/pdp10-ka/system:
	$(MKDIR) $(OUT)/system
	x=`echo $(IP) | tr . ,`; \
	$(SED) -e "s/%IP%/$$x/" \
	    -e 's/%NETMASK%/$(NETMASK)/' < build/pdp10-ka/config.202 > $(OUT)/system/config.202

out/pdp10-kl/system:
	$(MKDIR) $(OUT)/system
	x=`echo $(IP) | tr . ,`; \
	$(SED) -e "s/%IP%/$$x/" \
	    -e 's/%NETMASK%/$(NETMASK)/' < build/pdp10-kl/config.203 > $(OUT)/system/config.203

out/pdp10-ks/system:
	$(MKDIR) $(OUT)/system
	x=`echo $(IP) | tr . ,`; \
	$(SED) -e "s/%IP%/$$x/" \
	    -e 's/%NETMASK%/$(NETMASK)/' < build/pdp10-ks/config.202 > $(OUT)/system/config.202

out/simhv3/system:
	$(MKDIR) $(OUT)/system
	cp build/simhv3/config.* $(OUT)/system

out/klh10/dskdmp.ini: build/mchn/$(MCHN)/dskdmp.txt Makefile
	$(MKDIR) $(OUT)/stamp
	$(SED) -e 's/%IP%/$(IP)/' \
	    -e 's/%GW%/$(GW)/' < $< > $@

out/simh/boot: build/mchn/$(MCHN)/boot
	$(MKDIR) $(OUT)/stamp
	cp $< $@

out/pdp10-ka/run: build/mchn/$(MCHN)/run
	$(MKDIR) $(OUT)/stamp
	$(SED) -e 's/%IP%/$(IP)/' \
	    -e 's/%GW%/$(GW)/' < $< > $@

out/pdp10-kl/run: build/mchn/$(MCHN)/run
	$(MKDIR) $(OUT)/stamp
	$(SED) -e 's/%IP%/$(IP)/' \
	    -e 's/%GW%/$(GW)/' < $< > $@

out/pdp10-ks/run: build/pdp10-ks/run
	$(MKDIR) $(OUT)/stamp
	$(SED) -e 's/%IP%/$(IP)/' \
	    -e 's/%GW%/$(GW)/' < $< > $@

$(OUT)/syshst/$(H3TEXT): build/$(H3TEXT)
	$(MKDIR) $(OUT)/syshst
	$(SED) -e 's/%IP%/$(IP)/' \
	    -e 's/%HOSTNAME%/$(HOSTNAME)/' \
	    -e 's/%GW%/$(GW)/' \
	    -e 's/%MCHN%/$(MCHN)/' < $< > $@
	$(CAT) conf/hosts >> $@

$(OUT)/_mail_/$(NAMES): build/$(NAMES)
	$(MKDIR) $(OUT)/_mail_
	$(SED) -e 's/%MCHN%/$(MCHN)/' \
	    -e 's/%GW%/$(GW)/' < $< > $@

$(KLH10):
	cd tools/klh10; \
	$(RM) -rf tmp; \
	./autogen.sh; \
	$(MKDIR) tmp; \
	cd tmp; \
	export CONFFLAGS_USR="-DKLH10_DEV_DPTM03=0 $$CONFFLAGS_USR"; \
	../configure --bindir="$(CURDIR)/build/klh10"; \
	$(MAKE) -C bld-ks-its; \
	$(MAKE) -C bld-ks-its install

$(SIMH):
	$(MAKE) -C tools/simh pdp10

$(KA10):
	$(MAKE) -C tools/sims pdp10-ka

$(KL10):
	$(MAKE) -C tools/sims pdp10-kl

$(KS10):
	$(MAKE) -C tools/sims pdp10-ks

$(SIMHV3): tools/simhv3
	$(MAKE) -C tools/simhv3 pdp10

tools/simhv3: simhv312-4.zip
	unzip $<
	mv sim $@

simhv312-4.zip:
	$(WGET) $(SIMHV3_URL)/$@ || $(WGET) $(SIMHV3_URL)/archive/$@

$(ITSTAR):
	$(MAKE) -C tools/itstar

$(WRITETAPE):
	$(MAKE) -C tools/tapeutils

$(MAGFRM) $(KLFEDR):
	$(MAKE) -C tools/dasm

$(TV11):
	$(MAKE) -C tools/tv11 tv11 CFLAGS=-O3
	$(MAKE) -C tools/tv11/tvcon

$(XGP11):
	$(MAKE) -C tools/tv11 xgp11 CFLAGS=-O3

$(PDP6):
	$(MAKE) -C tools/pdp6/emu

$(DATAPOINT):
	$(MAKE) -C tools/vt05 dp3300

$(VT52):
	$(MAKE) -C tools/vt05 vt52

tek-hack:
	rm -f $(TEK)

$(TEK): tek-hack
	$(MAKE) -C tools/tek4010 tek4010

$(IMP):
	$(MAKE) -C tools/simh h316

$(NCPD):
	$(MAKE) -C tools/ncp/src
	$(MAKE) -C tools/ncp/apps

tools/supdup/supdup:
	$(MAKE) -C tools/supdup

tools/cbridge/cbridge:
	$(MAKE) -C tools/cbridge

tools/chaosnet-tools/shutdown:
	$(MAKE) -C tools/chaosnet-tools

$(SMF):
	$(GIT) submodule sync --recursive `dirname $@`
	$(GIT) submodule update --recursive --init `dirname $@`

tools/simh/BIN/pdp11:
	$(MAKE) -C tools/simh pdp11

tools/simh/BIN/imlac:
	$(MAKE) -C tools/simh imlac

check-dirs: Makefile
	mkdir -p $(OUT)/check
	echo $(SRC) | tr ' ' '\n' | sort > $(OUT)/check/src1
	cd src; ls -1 | $(EGREP) -v $(SRCIGNORE) > ../$(OUT)/check/src2
	diff -u $(OUT)/check/src1 $(OUT)/check/src2 > $(OUT)/check/src.diff
	echo $(DOC) | tr ' ' '\n' | sort > $(OUT)/check/doc1
	cd doc; ls -1d -- */ | tr -d / | sort | \
		$(EGREP) -v $(DOCIGNORE) > ../$(OUT)/check/doc2
	diff -u $(OUT)/check/doc1 $(OUT)/check/doc2 > $(OUT)/check/doc.diff
	echo $(BIN) | tr ' ' '\n' | sort > $(OUT)/check/bin1
	cd bin; ls -1 | $(EGREP) -v $(BINIGNORE) > ../$(OUT)/check/bin2
	diff -u $(OUT)/check/bin1 $(OUT)/check/bin2 > $(OUT)/check/bin.diff

clean:
	$(RM) -rf out start build/*/stamp
