######################################################################
#  Makefile
#		LINUX Version
#		=============
#
#   6 July 2012			Created for LINUX     / make /
#
######################################################################

.PHONY:	all clean prep

all:	as1802		\
	as2650		\
	as430		\
	as61860		\
	as6500		\
	as6800		\
	as6801		\
	as6804		\
	as6805		\
	as6808		\
	as6809		\
	as6811		\
	as6812		\
	as6816		\
	as740		\
	as8048		\
	as8051		\
	as8085		\
	as8xcxxx	\
	asavr		\
	asez80		\
	asf2mc8		\
	asf8		\
	asgb		\
	ash8		\
	asm8c		\
	aspic		\
	asrab		\
	asscmp		\
	ascheck		\
	asst6		\
	asst7		\
	asst8		\
	asz8		\
	asz80		\
	aslink		\
	asxscn		\
	asxcnv		\
	s19os9
	
clean:
	rm -f $(SRCASX)*.o
	rm -f $(SRCLNK)*.o
	rm -f $(SRCMISC)*.o
	rm -f $(S19OS9)*.o
	rm -f $(SRC1802)*.o
	rm -f $(SRC2650)*.o
	rm -f $(SRC430)*.o
	rm -f $(SRC6816)*.o
	rm -f $(SRC6500)*.o
	rm -f $(SRC6800)*.o
	rm -f $(SRC6801)*.o
	rm -f $(SRC6804)*.o
	rm -f $(SRC6805)*.o
	rm -f $(SRC6808)*.o
	rm -f $(SRC6809)*.o
	rm -f $(SRC6811)*.o
	rm -f $(SRC6812)*.o
	rm -f $(SRC740)*.o
	rm -f $(SRC61860)*.o
	rm -f $(SRC8048)*.o
	rm -f $(SRC8051)*.o
	rm -f $(SRC8085)*.o
	rm -f $(SRC8XCXXX)*.o
	rm -f $(SRCAVR)*.o
	rm -f $(SRCCHECK)*.o
	rm -f $(SRCEZ80)*.o
	rm -f $(SRCF2MC8)*.o
	rm -f $(SRCF8)*.o
	rm -f $(SRCGB)*.o
	rm -f $(SRCH8)*.o
	rm -f $(SRCM8C)*.o
	rm -f $(SRCPIC)*.o
	rm -f $(SRCRAB)*.o
	rm -f $(SRCSCMP)*.o
	rm -f $(SRCST6)*.o
	rm -f $(SRCST7)*.o
	rm -f $(SRCST8)*.o
	rm -f $(SRCZ8)*.o
	rm -f $(SRCZ80)*.o
	rm -f as1802
	rm -f as2650
	rm -f as430
	rm -f as61860
	rm -f as6500
	rm -f as6800
	rm -f as6801
	rm -f as6804
	rm -f as6805
	rm -f as6808
	rm -f as6809
	rm -f as6811
	rm -f as6812
	rm -f as6816
	rm -f as740
	rm -f as8048
	rm -f as8051
	rm -f as8085
	rm -f as8xcxxx
	rm -f asavr
	rm -f asez80
	rm -f asf2mc8
	rm -f asf8
	rm -f asgb
	rm -f ash8
	rm -f asm8c
	rm -f aspic
	rm -f asrab
	rm -f asscmp
	rm -f ascheck
	rm -f asst6
	rm -f asst7
	rm -f asst8
	rm -f asz8
	rm -f asz80
	rm -f aslink
	rm -f asxscn
	rm -f asxcnv
	rm -f s19os9
	rm -f $(DSTEXE)*

prep:
	rm -f $(SRCASX)*.o
	rm -f $(SRCLNK)*.o
	rm -f $(SRCMISC)*.o
	rm -f $(S19OS9)*.o
	rm -f $(SRC1802)*.o
	rm -f $(SRC2650)*.o
	rm -f $(SRC430)*.o
	rm -f $(SRC6816)*.o
	rm -f $(SRC6500)*.o
	rm -f $(SRC6800)*.o
	rm -f $(SRC6801)*.o
	rm -f $(SRC6804)*.o
	rm -f $(SRC6805)*.o
	rm -f $(SRC6808)*.o
	rm -f $(SRC6809)*.o
	rm -f $(SRC6811)*.o
	rm -f $(SRC6812)*.o
	rm -f $(SRC740)*.o
	rm -f $(SRC61860)*.o
	rm -f $(SRC8048)*.o
	rm -f $(SRC8051)*.o
	rm -f $(SRC8085)*.o
	rm -f $(SRC8XCXXX)*.o
	rm -f $(SRCAVR)*.o
	rm -f $(SRCCHECK)*.o
	rm -f $(SRCEZ80)*.o
	rm -f $(SRCF2MC8)*.o
	rm -f $(SRCF8)*.o
	rm -f $(SRCGB)*.o
	rm -f $(SRCH8)*.o
	rm -f $(SRCM8C)*.o
	rm -f $(SRCPIC)*.o
	rm -f $(SRCRAB)*.o
	rm -f $(SRCSCMP)*.o
	rm -f $(SRCST6)*.o
	rm -f $(SRCST7)*.o
	rm -f $(SRCST8)*.o
	rm -f $(SRCZ8)*.o
	rm -f $(SRCZ80)*.o
	rm -f as1802
	rm -f as2650
	rm -f as430
	rm -f as61860
	rm -f as6500
	rm -f as6800
	rm -f as6801
	rm -f as6804
	rm -f as6805
	rm -f as6808
	rm -f as6809
	rm -f as6811
	rm -f as6812
	rm -f as6816
	rm -f as740
	rm -f as8048
	rm -f as8051
	rm -f as8085
	rm -f as8xcxxx
	rm -f asavr
	rm -f asez80
	rm -f asf2mc8
	rm -f asf8
	rm -f asgb
	rm -f ash8
	rm -f asm8c
	rm -f aspic
	rm -f asrab
	rm -f asscmp
	rm -f ascheck
	rm -f asst6
	rm -f asst7
	rm -f asst8
	rm -f asz8
	rm -f asz80
	rm -f aslink
	rm -f asxscn
	rm -f asxcnv
	rm -f s19os9


CC=		gcc
CCOPT=		-O3
CCFLAGS=	-Wall -funsigned-char $(CCOPT)

LD=		gcc
LDFLAGS=	-Wall

#  Set ASXBAS relative to this make file.

ASXBAS:=	../../../

SRCASX:=	$(ASXBAS)asxxsrc/
SRCLNK:=	$(ASXBAS)linksrc/
SRCMISC:=	$(ASXBAS)asxxmisc/
SRCS19OS9:=	$(ASXBAS)s19os9/
DSTEXE:=	$(ASXBAS)asxmak/linux/exe/

SRC1802=	$(ASXBAS)as1802/
SRC2650=	$(ASXBAS)as2650/
SRC430=		$(ASXBAS)as430/
SRC61860=	$(ASXBAS)as61860/
SRC6500=	$(ASXBAS)as6500/
SRC6800=	$(ASXBAS)as6800/
SRC6801=	$(ASXBAS)as6801/
SRC6804=	$(ASXBAS)as6804/
SRC6805=	$(ASXBAS)as6805/
SRC6808=	$(ASXBAS)as6808/
SRC6809=	$(ASXBAS)as6809/
SRC6811=	$(ASXBAS)as6811/
SRC6812=	$(ASXBAS)as6812/
SRC6816=	$(ASXBAS)as6816/
SRC740=		$(ASXBAS)as740/
SRC8048=	$(ASXBAS)as8048/
SRC8051=	$(ASXBAS)as8051/
SRC8085=	$(ASXBAS)as8085/
SRC8XCXXX=	$(ASXBAS)as8xcxxx/
SRCAVR=		$(ASXBAS)asavr/
SRCCHECK=	$(ASXBAS)ascheck/
SRCEZ80=	$(ASXBAS)asez80/
SRCF2MC8=	$(ASXBAS)asf2mc8/
SRCF8=		$(ASXBAS)asf8/
SRCGB=		$(ASXBAS)asgb/
SRCH8=		$(ASXBAS)ash8/
SRCM8C=		$(ASXBAS)asm8c/
SRCPIC=		$(ASXBAS)aspic/
SRCRAB=		$(ASXBAS)asrab/
SRCSCMP=	$(ASXBAS)asscmp/
SRCST6=		$(ASXBAS)asst6/
SRCST7=		$(ASXBAS)asst7/
SRCST8=		$(ASXBAS)asst8/
SRCZ8=		$(ASXBAS)asz8/
SRCZ80=		$(ASXBAS)asz80/

.SUFFIXES:	.c .o

%.o: %.c
	$(CC) $(CCFLAGS) -I$(SRCMISC) -I$(SRCASX) -c $< -o $@


ASXX =	asdata.o asexpr.o aslex.o aslist.o	\
	asmain.o asmcro.o asout.o assubr.o	\
	assym.o	asdbg.o

ASXXSRC =	$(addprefix $(SRCASX),$(ASXX))

$(ASXXSRC):	$(SRCMISC)alloc.h $(SRCASX)asxxxx.h


####################################################################
# AS1802
####################################################################

AS1802 =	1802mch.o 1802pst.o

AS1802SRC =	$(addprefix $(SRC1802),$(AS1802))

$(AS1802SRC):	$(SRCMISC)alloc.h $(SRCASX)asxxxx.h $(SRC1802)1802.h

as1802:	$(ASXXSRC) $(AS1802SRC)
	$(LD) $(LDFLAGS) $(ASXXSRC) $(AS1802SRC) -o as1802
	cp as1802 -T $(DSTEXE)as1802
	strip $(DSTEXE)as1802
	chmod 755 $(DSTEXE)as1802


####################################################################
# AS2650
####################################################################

AS2650 =	s26adr.o s26mch.o s26pst.o

AS2650SRC =	$(addprefix $(SRC2650),$(AS2650))

$(AS2650SRC):	$(SRCMISC)alloc.h $(SRCASX)asxxxx.h $(SRC2650)s2650.h

as2650:	$(ASXXSRC) $(AS2650SRC)
	$(LD) $(LDFLAGS) $(ASXXSRC) $(AS2650SRC) -o as2650
	cp as2650 $(DSTEXE)as2650
	strip $(DSTEXE)as2650
	chmod 755 $(DSTEXE)as2650


####################################################################
# AS430
####################################################################

AS430 =		m430adr.o m430mch.o m430pst.o

AS430SRC =	$(addprefix $(SRC430),$(AS430))

$(AS430SRC):	$(SRCMISC)alloc.h $(SRCASX)asxxxx.h $(SRC430)m430.h

as430:	$(ASXXSRC) $(AS430SRC)
	$(LD) $(LDFLAGS) $(ASXXSRC) $(AS430SRC) -o as430
	cp as430 $(DSTEXE)as430
	strip $(DSTEXE)as430
	chmod 755 $(DSTEXE)as430

####################################################################
# AS61860
####################################################################

AS61860 =	s6186adr.o s6186mch.o s6186pst.o

AS61860SRC =	$(addprefix $(SRC61860),$(AS61860))

$(AS61860SRC):	$(SRCMISC)alloc.h $(SRCASX)asxxxx.h $(SRC61860)s61860.h

as61860:	$(ASXXSRC) $(AS61860SRC)
	$(LD) $(LDFLAGS) $(ASXXSRC) $(AS61860SRC) -o as61860
	cp as61860 $(DSTEXE)as61860
	strip $(DSTEXE)as61860
	chmod 755 $(DSTEXE)as61860


####################################################################
# AS6500
####################################################################

AS6500 =	r65adr.o r65mch.o r65pst.o

AS6500SRC =	$(addprefix $(SRC6500),$(AS6500))

$(AS6500SRC):	$(SRCMISC)alloc.h $(SRCASX)asxxxx.h $(SRC6500)r6500.h

as6500:	$(ASXXSRC) $(AS6500SRC)
	$(LD) $(LDFLAGS) $(ASXXSRC) $(AS6500SRC) -o as6500
	cp as6500 $(DSTEXE)as6500
	strip $(DSTEXE)as6500
	chmod 755 $(DSTEXE)as6500


####################################################################
# AS6800
####################################################################

AS6800 =	m00adr.o m00mch.o m00pst.o

AS6800SRC =	$(addprefix $(SRC6800),$(AS6800))

$(AS6800SRC):	$(SRCMISC)alloc.h $(SRCASX)asxxxx.h $(SRC6800)m6800.h

as6800:	$(ASXXSRC) $(AS6800SRC)
	$(LD) $(LDFLAGS) $(ASXXSRC) $(AS6800SRC) -o as6800
	cp as6800 $(DSTEXE)as6800
	strip $(DSTEXE)as6800
	chmod 755 $(DSTEXE)as6800


####################################################################
# AS6801
####################################################################

AS6801 =	m01adr.o m01mch.o m01pst.o

AS6801SRC =	$(addprefix $(SRC6801),$(AS6801))

$(AS6801SRC):	 $(SRCMISC)alloc.h $(SRCASX)asxxxx.h $(SRC6801)m6801.h

as6801:	$(ASXXSRC) $(AS6801SRC)
	$(LD) $(LDFLAGS) $(ASXXSRC) $(AS6801SRC) -o as6801
	cp as6801 $(DSTEXE)as6801
	strip $(DSTEXE)as6801
	chmod 755 $(DSTEXE)as6801


####################################################################
# AS6804
####################################################################

AS6804 =	m04adr.o m04mch.o m04pst.o

AS6804SRC =	$(addprefix $(SRC6804),$(AS6804))

$(AS6804SRC):	$(SRCMISC)alloc.h $(SRCASX)asxxxx.h $(SRC6804)m6804.h

as6804:	$(ASXXSRC) $(AS6804SRC)
	$(LD) $(LDFLAGS) $(ASXXSRC) $(AS6804SRC) -o as6804
	cp as6804 $(DSTEXE)as6804
	strip $(DSTEXE)as6804
	chmod 755 $(DSTEXE)as6804


####################################################################
# AS6805
####################################################################

AS6805 =	m05adr.o m05mch.o m05pst.o

AS6805SRC =	$(addprefix $(SRC6805),$(AS6805))

$(AS6805SRC):	$(SRCMISC)alloc.h $(SRCASX)asxxxx.h $(SRC6805)m6805.h

as6805:	$(ASXXSRC) $(AS6805SRC)
	$(LD) $(LDFLAGS) $(ASXXSRC) $(AS6805SRC) -o as6805
	cp as6805 $(DSTEXE)as6805
	strip $(DSTEXE)as6805
	chmod 755 $(DSTEXE)as6805


####################################################################
# AS6808
####################################################################

AS6808 =	m08adr.o m08mch.o m08pst.o

AS6808SRC =	$(addprefix $(SRC6808),$(AS6808))

$(AS6808SRC):	$(SRCMISC)alloc.h $(SRCASX)asxxxx.h $(SRC6808)m6808.h

as6808:	$(ASXXSRC) $(AS6808SRC)
	$(LD) $(LDFLAGS) $(ASXXSRC) $(AS6808SRC) -o as6808
	cp as6808 $(DSTEXE)as6808
	strip $(DSTEXE)as6808
	chmod 755 $(DSTEXE)as6808


####################################################################
# AS6809
####################################################################

AS6809 =	m09adr.o m09mch.o m09pst.o

AS6809SRC =	$(addprefix $(SRC6809),$(AS6809))

$(AS6809SRC):	$(SRCMISC)alloc.h $(SRCASX)asxxxx.h $(SRC6809)m6809.h

as6809:	$(ASXXSRC) $(AS6809SRC)
	$(LD) $(LDFLAGS) $(ASXXSRC) $(AS6809SRC) -o as6809
	cp as6809 $(DSTEXE)as6809
	strip $(DSTEXE)as6809
	chmod 755 $(DSTEXE)as6809


####################################################################
# AS6811
####################################################################

AS6811 =	m11adr.o m11mch.o m11pst.o

AS6811SRC =	$(addprefix $(SRC6811),$(AS6811))

$(AS6811SRC):	$(SRCMISC)alloc.h $(SRCASX)asxxxx.h $(SRC6811)m6811.h

as6811:	$(ASXXSRC) $(AS6811SRC)
	$(LD) $(LDFLAGS) $(ASXXSRC) $(AS6811SRC) -o as6811
	cp as6811 $(DSTEXE)as6811
	strip $(DSTEXE)as6811
	chmod 755 $(DSTEXE)as6811


####################################################################
# AS6812
####################################################################

AS6812 =	m12adr.o m12mch.o m12pst.o

AS6812SRC =	$(addprefix $(SRC6812),$(AS6812))

$(AS6812SRC):	$(SRCMISC)alloc.h $(SRCASX)asxxxx.h $(SRC6812)m6812.h

as6812:	$(ASXXSRC) $(AS6812SRC)
	$(LD) $(LDFLAGS) $(ASXXSRC) $(AS6812SRC) -o as6812
	cp as6812 $(DSTEXE)as6812
	strip $(DSTEXE)as6812
	chmod 755 $(DSTEXE)as6812


####################################################################
# AS6816
####################################################################

AS6816 =	m16adr.o m16mch.o m16pst.o

AS6816SRC =	$(addprefix $(SRC6816),$(AS6816))

$(AS6816SRC):	$(SRCMISC)alloc.h $(SRCASX)asxxxx.h $(SRC6816)m6816.h

as6816:	$(ASXXSRC) $(AS6816SRC)
	$(LD) $(LDFLAGS) $(ASXXSRC) $(AS6816SRC) -o as6816
	cp as6816 $(DSTEXE)as6816
	strip $(DSTEXE)as6816
	chmod 755 $(DSTEXE)as6816


####################################################################
# AS740
####################################################################

AS740 =		m74adr.o m74mch.o m74pst.o

AS740SRC =	$(addprefix $(SRC740),$(AS740))

$(AS740SRC):	$(SRCMISC)alloc.h $(SRCASX)asxxxx.h $(SRC740)m740.h

as740:	$(ASXXSRC) $(AS740SRC)
	$(LD) $(LDFLAGS) $(ASXXSRC) $(AS740SRC) -o as740
	cp as740 $(DSTEXE)as740
	strip $(DSTEXE)as740
	chmod 755 $(DSTEXE)as740


####################################################################
# AS8048
####################################################################

AS8048 =	i48adr.o i48mch.o i48pst.o

AS8048SRC =	$(addprefix $(SRC8048),$(AS8048))

$(AS8048SRC):	$(SRCMISC)alloc.h $(SRCASX)asxxxx.h $(SRC8048)i8048.h

as8048:	$(ASXXSRC) $(AS8048SRC)
	$(LD) $(LDFLAGS) $(ASXXSRC) $(AS8048SRC) -o as8048
	cp as8048 $(DSTEXE)as8048
	strip $(DSTEXE)as8048
	chmod 755 $(DSTEXE)as8048


####################################################################
# AS8051
####################################################################

AS8051 =	i51adr.o i51mch.o i51pst.o

AS8051SRC =	$(addprefix $(SRC8051),$(AS8051))

$(AS8051SRC):	$(SRCMISC)alloc.h $(SRCASX)asxxxx.h $(SRC8051)i8051.h

as8051:	$(ASXXSRC) $(AS8051SRC)
	$(LD) $(LDFLAGS) $(ASXXSRC) $(AS8051SRC) -o as8051
	cp as8051 $(DSTEXE)as8051
	strip $(DSTEXE)as8051
	chmod 755 $(DSTEXE)as8051


####################################################################
# AS8085
####################################################################

AS8085 =	i85mch.o i85pst.o

AS8085SRC =	$(addprefix $(SRC8085),$(AS8085))

$(AS8085SRC):	$(SRCMISC)alloc.h $(SRCASX)asxxxx.h $(SRC8085)i8085.h

as8085:	$(ASXXSRC) $(AS8085SRC)
	$(LD) $(LDFLAGS) $(ASXXSRC) $(AS8085SRC) -o as8085
	cp as8085 $(DSTEXE)as8085
	strip $(DSTEXE)as8085
	chmod 755 $(DSTEXE)as8085


####################################################################
# AS8xcxxx
####################################################################

AS8XCXXX =	ds8adr.o ds8mch.o ds8pst.o

AS8XCXXXSRC =	$(addprefix $(SRC8XCXXX),$(AS8XCXXX))

$(AS8XCXXXSRC):	$(SRCMISC)alloc.h $(SRCASX)asxxxx.h $(SRC8XCXXX)ds8.h

as8xcxxx:	$(ASXXSRC) $(AS8XCXXXSRC)
	$(LD) $(LDFLAGS) $(ASXXSRC) $(AS8XCXXXSRC) -o as8xcxxx
	cp as8xcxxx $(DSTEXE)as8xcxxx
	strip $(DSTEXE)as8xcxxx
	chmod 755 $(DSTEXE)as8xcxxx


####################################################################
# ASAVR
####################################################################

ASAVR =		avradr.o avrmch.o avrpst.o

ASAVRSRC =	$(addprefix $(SRCAVR),$(ASAVR))

$(ASAVRSRC):	$(SRCMISC)alloc.h $(SRCASX)asxxxx.h $(SRCAVR)avr.h

asavr:	$(ASXXSRC) $(ASAVRSRC)
	$(LD) $(LDFLAGS) $(ASXXSRC) $(ASAVRSRC) -o asavr
	cp asavr $(DSTEXE)asavr
	strip $(DSTEXE)asavr
	chmod 755 $(DSTEXE)asavr


####################################################################
# ASCHECK
####################################################################

ASCHECK =	chkadr.o chkmch.o chkpst.o

ASCHECKSRC =	$(addprefix $(SRCCHECK),$(ASCHECK))

$(ASCHECKSRC):	$(SRCMISC)alloc.h $(SRCASX)asxxxx.h $(SRCCHECK)chk.h

ascheck:	$(ASXXSRC) $(ASCHECKSRC)
	$(LD) $(LDFLAGS) $(ASXXSRC) $(ASCHECKSRC) -o ascheck
	cp ascheck $(DSTEXE)ascheck
	strip $(DSTEXE)ascheck
	chmod 755 $(DSTEXE)ascheck


####################################################################
# ASEZ80
####################################################################

ASEZ80 =	ez80adr.o ez80mch.o ez80pst.o

ASEZ80SRC =	$(addprefix $(SRCEZ80),$(ASEZ80))

$(ASEZ80SRC):	$(SRCMISC)alloc.h $(SRCASX)asxxxx.h $(SRCEZ80)ez80.h

asez80:	$(ASXXSRC) $(ASEZ80SRC)
	$(LD) $(LDFLAGS) $(ASXXSRC) $(ASEZ80SRC) -o asez80
	cp asez80 $(DSTEXE)asez80
	strip $(DSTEXE)asez80
	chmod 755 $(DSTEXE)asez80


####################################################################
# ASF2MC8
####################################################################

ASF2MC8 =	f2mc8adr.o f2mc8mch.o f2mc8pst.o

ASF2MC8SRC =	$(addprefix $(SRCF2MC8),$(ASF2MC8))

$(ASF2MC8SRC):	$(SRCMISC)alloc.h $(SRCASX)asxxxx.h $(SRCF2MC8)f2mc8.h

asf2mc8:	$(ASXXSRC) $(ASF2MC8SRC)
	$(LD) $(LDFLAGS) $(ASXXSRC) $(ASF2MC8SRC) -o asf2mc8
	cp asf2mc8 $(DSTEXE)asf2mc8
	strip $(DSTEXE)asf2mc8
	chmod 755 $(DSTEXE)asf2mc8


####################################################################
# ASF8
####################################################################

ASF8 =		f8adr.o f8mch.o f8pst.o

ASF8SRC =	$(addprefix $(SRCF8),$(ASF8))

$(ASF8SRC):	$(SRCMISC)alloc.h $(SRCASX)asxxxx.h $(SRCF8)f8.h

asf8:	$(ASXXSRC) $(ASF8SRC)
	$(LD) $(LDFLAGS) $(ASXXSRC) $(ASF8SRC) -o asf8
	cp asf8 $(DSTEXE)asf8
	strip $(DSTEXE)asf8
	chmod 755 $(DSTEXE)asf8


####################################################################
# ASGB
####################################################################

ASGB =		gbadr.o gbmch.o gbpst.o

ASGBSRC =	$(addprefix $(SRCGB),$(ASGB))

$(ASGBSRC):	$(SRCMISC)alloc.h $(SRCASX)asxxxx.h $(SRCGB)gb.h

asgb:	$(ASXXSRC) $(ASGBSRC)
	$(LD) $(LDFLAGS) $(ASXXSRC) $(ASGBSRC) -o asgb
	cp asgb $(DSTEXE)asgb
	strip $(DSTEXE)asgb
	chmod 755 $(DSTEXE)asgb


####################################################################
# ASH8
####################################################################

ASH8 =		h8adr.o h8mch.o h8pst.o

ASH8SRC =	$(addprefix $(SRCH8),$(ASH8))

$(ASH8SRC):	$(SRCMISC)alloc.h $(SRCASX)asxxxx.h $(SRCH8)h8.h

ash8:	$(ASXXSRC) $(ASH8SRC)
	$(LD) $(LDFLAGS) $(ASXXSRC) $(ASH8SRC) -o ash8
	cp ash8 $(DSTEXE)ash8
	strip $(DSTEXE)ash8
	chmod 755 $(DSTEXE)ash8


####################################################################
# ASM8C
####################################################################

ASM8C =		m8cadr.o m8cmch.o m8cpst.o

ASM8CSRC =	$(addprefix $(SRCM8C),$(ASM8C))

$(ASM8CSRC):	$(SRCMISC)alloc.h $(SRCASX)asxxxx.h $(SRCM8C)m8c.h

asm8c:	$(ASXXSRC) $(ASM8CSRC)
	$(LD) $(LDFLAGS) $(ASXXSRC) $(ASM8CSRC) -o asm8c
	cp asm8c $(DSTEXE)asm8c
	strip $(DSTEXE)asm8c
	chmod 755 $(DSTEXE)asm8c


####################################################################
# ASPIC
####################################################################

ASPIC =		picadr.o picmch.o picpst.o

ASPICSRC =	$(addprefix $(SRCPIC),$(ASPIC))

$(ASPICSRC):	$(SRCMISC)alloc.h $(SRCASX)asxxxx.h $(SRCPIC)pic.h

aspic:	$(ASXXSRC) $(ASPICSRC)
	$(LD) $(LDFLAGS) $(ASXXSRC) $(ASPICSRC) -o aspic
	cp aspic $(DSTEXE)aspic
	strip $(DSTEXE)aspic
	chmod 755 $(DSTEXE)aspic


####################################################################
# ASRAB
####################################################################

ASRAB =		rabadr.o rabmch.o rabpst.o

ASRABSRC =	$(addprefix $(SRCRAB),$(ASRAB))

$(ASRABSRC):	$(SRCMISC)alloc.h $(SRCASX)asxxxx.h $(SRCRAB)rab.h

asrab:	$(ASXXSRC) $(ASRABSRC)
	$(LD) $(LDFLAGS) $(ASXXSRC) $(ASRABSRC) -o asrab
	cp asrab $(DSTEXE)asrab
	strip $(DSTEXE)asrab
	chmod 755 $(DSTEXE)asrab


####################################################################
# ASSCMP
####################################################################

ASSCMP =	scmpadr.o scmpmch.o scmppst.o

ASSCMPSRC =	$(addprefix $(SRCSCMP),$(ASSCMP))

$(ASSCMPSRC):	$(SRCMISC)alloc.h $(SRCASX)asxxxx.h $(SRCSCMP)scmp.h

asscmp:	$(ASXXSRC) $(ASSCMPSRC)
	$(LD) $(LDFLAGS) $(ASXXSRC) $(ASSCMPSRC) -o asscmp
	cp asscmp $(DSTEXE)asscmp
	strip $(DSTEXE)asscmp
	chmod 755 $(DSTEXE)asscmp


####################################################################
# ASST6
####################################################################

ASST6 =		st6adr.o st6mch.o st6pst.o

ASST6SRC =	$(addprefix $(SRCST6),$(ASST6))

$(ASST6SRC):	$(SRCMISC)alloc.h $(SRCASX)asxxxx.h $(SRCST6)st6.h

asst6:	$(ASXXSRC) $(ASST6SRC)
	$(LD) $(LDFLAGS) $(ASXXSRC) $(ASST6SRC) -o asst6
	cp asst6 $(DSTEXE)asst6
	strip $(DSTEXE)asst6
	chmod 755 $(DSTEXE)asst6


####################################################################
# ASST7
####################################################################

ASST7 =		st7adr.o st7mch.o st7pst.o

ASST7SRC =	$(addprefix $(SRCST7),$(ASST7))

$(ASST7SRC):	$(SRCMISC)alloc.h $(SRCASX)asxxxx.h $(SRCST7)st7.h

asst7:	$(ASXXSRC) $(ASST7SRC)
	$(LD) $(LDFLAGS) $(ASXXSRC) $(ASST7SRC) -o asst7
	cp asst7 $(DSTEXE)asst7
	strip $(DSTEXE)asst7
	chmod 755 $(DSTEXE)asst7


####################################################################
# ASST8
####################################################################

ASST8 =		st8adr.o st8mch.o st8pst.o

ASST8SRC =	$(addprefix $(SRCST8),$(ASST8))

$(ASST8SRC):	$(SRCMISC)alloc.h $(SRCASX)asxxxx.h $(SRCST8)st8.h

asst8:	$(ASXXSRC) $(ASST8SRC)
	$(LD) $(LDFLAGS) $(ASXXSRC) $(ASST8SRC) -o asst8
	cp asst8 $(DSTEXE)asst8
	strip $(DSTEXE)asst8
	chmod 755 $(DSTEXE)asst8


####################################################################
# ASZ8
####################################################################

ASZ8 =		z8adr.o z8mch.o z8pst.o

ASZ8SRC =	$(addprefix $(SRCZ8),$(ASZ8))

$(ASZ8SRC):	$(SRCMISC)alloc.h $(SRCASX)asxxxx.h $(SRCZ8)z8.h

asz8:	$(ASXXSRC) $(ASZ8SRC)
	$(LD) $(LDFLAGS) $(ASXXSRC) $(ASZ8SRC) -o asz8
	cp asz8 $(DSTEXE)asz8
	strip $(DSTEXE)asz8
	chmod 755 $(DSTEXE)asz8


####################################################################
# ASZ80
####################################################################

ASZ80 =		z80adr.o z80mch.o z80pst.o

ASZ80SRC =	$(addprefix $(SRCZ80),$(ASZ80))

$(ASZ80SRC):	$(SRCMISC)alloc.h $(SRCASX)asxxxx.h $(SRCZ80)z80.h

asz80:	$(ASXXSRC) $(ASZ80SRC)
	$(LD) $(LDFLAGS) $(ASXXSRC) $(ASZ80SRC) -o asz80
	cp asz80 $(DSTEXE)asz80
	strip $(DSTEXE)asz80
	chmod 755 $(DSTEXE)asz80


####################################################################
# ASLINK
####################################################################

ASLINK =	lkmain.o lkhead.o lkarea.o lkbank.o	\
		lkdata.o lkeval.o lklex.o lklibr.o	\
		lklist.o lkrloc.o lkrloc3.o lkrloc4.o	\
		lksym.o lkout.o lknoice.o lksdcdb.o

ASLINKSRC =	$(addprefix $(SRCLNK),$(ASLINK))

$(ASLINK):	$(SRCMISC)alloc.h $(SRCLNK)aslink.h

aslink:	$(ASLINKSRC)
	$(LD) $(LDFLAGS) $(ASLINKSRC) -o aslink
	cp aslink $(DSTEXE)aslink
	strip $(DSTEXE)aslink
	chmod 755 $(DSTEXE)aslink


####################################################################
# ASXCNV
####################################################################

$(SRCMISC)asxxconv.o:	$(SRCASX)asxxxx.h
asxcnv:	$(SRCMISC)asxxconv.o
	$(LD) $(LDFLAGS) $(SRCMISC)asxxconv.o -o asxcnv
	cp asxcnv $(DSTEXE)asxcnv
	strip $(DSTEXE)asxcnv
	chmod 755 $(DSTEXE)asxcnv


####################################################################
# ASXSCN
####################################################################

$(SRCMISC)asxxscan.o:	$(SRCASX)asxxxx.h
asxscn:	$(SRCMISC)asxxscan.o
	$(LD) $(LDFLAGS) $(SRCMISC)asxxscan.o -o asxscn
	cp asxscn $(DSTEXE)asxscn
	strip $(DSTEXE)asxscn
	chmod 755 $(DSTEXE)asxscn


####################################################################
# S19OS9
####################################################################

$(SRCS19OS9)s19os9.o:	$(SRCASX)asxxxx.h
s19os9:	$(SRCS19OS9)s19os9.o
	$(LD) $(LDFLAGS) $(SRCS19OS9)s19os9.o -o s19os9
	cp s19os9 $(DSTEXE)s19os9
	strip $(DSTEXE)s19os9
	chmod 755 $(DSTEXE)s19os9


### end ############################################################


