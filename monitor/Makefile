CC = bexkat1-elf-gcc
#BOARD = de2
BOARD = max10
LDFLAGS = -specs=$(BOARD).specs
LDLIBS = -lsupport -lm
OBJCOPY = bexkat1-elf-objcopy
OBJDUMP = bexkat1-elf-objdump
AS = bexkat1-elf-as
LD = bexkat1-elf-ld
RANLIB = bexkat1-elf-ranlib

TEMP := $(shell mktemp)

OBJECTS = boot-$(BOARD).o bootstrap.o pretty.o fmand.o memtests.o rtc.o tests.o ps2.o fib.o clock.o fly.o setjmp.o hwmand.o 7seg.o serial.o basic.o bootmin.o
APPS = pretty fmand bootstrap memtests rtc tests ps2 fib clock fly setjmp hwmand codec codec_w vga 7seg serial basic bootmin

.PHONY: all clean gcctests kernel install

all: boot-$(BOARD).o tests.mif bootmin.mif

install: $(APPS)
	cp $(APPS) /media/mstock/6874-28D3/
	cd kernel; make install

clean:
	cd gcctests; make clean
	cd kernel; make clean
	rm -f *.o *.hex *.bin *.mif *.gkd *.expand $(APPS)

gcctests:
	cd gcctests; make

kernel: 
	cd kernel; make

%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $^

%.mif: %
	$(OBJCOPY) -O mif $< $@

%.bin: %
	$(OBJCOPY) -O binary $< $@

ff.o: kernel/ff.c
	$(CC) $(CFLAGS) -Ikernel/include -c -o $@ $^

mmc.o: kernel/mmc.c
	$(CC) $(CFLAGS) -Ikernel/include -c -o $@ $^

vectors.o: kernel/vectors.c
	$(CC) $(CFLAGS) -Ikernel/include -c -o $@ $^

gettime.o: kernel/gettime.c
	$(CC) $(CFLAGS) -Ikernel/include -c -o $@ $^

librawsd.a: ff.o mmc.o gettime.o
	$(AR) rcs -o $@ $^
	$(RANLIB) $@


tests: tests.s
	$(CC) -T profile-$(BOARD).ld -nostartfiles -o $@ $^ $(LDFLAGS)

fileio: fileio.o
	$(CC) $(LDFLAGS) -o $@ $^

bootstrap: librawsd.a bootstrap.o vectors.o
	$(CC) -T profile-$(BOARD).ld -nostartfiles -o $@ $^ $(LDFLAGS) -L. $(LDLIBS) -lrawsd

bootmin: librawsd.a bootmin.o vectors.o
	$(CC) -T profile-$(BOARD).ld -nostartfiles -o $@ $^ $(LDFLAGS) -L. $(LDLIBS) -lrawsd
