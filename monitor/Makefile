CC = bexkat1-elf-gcc
BOARD = de2
#BOARD = max10
LDFLAGS = -specs=$(BOARD).specs
#LDLIBS = -lsupport -lm
OBJCOPY = bexkat1-elf-objcopy
OBJDUMP = bexkat1-elf-objdump
AS = bexkat1-elf-as
LD = bexkat1-elf-ld
RANLIB = bexkat1-elf-ranlib
CFLAGS = -Os

TEMP := $(shell mktemp)

APPS = pretty vga timertest rtc 

.PHONY: all clean gcctests kernel install

all: boot-bootstrap

boot-%: rom-%.mif
	rm -f $(BOARD)rom.mif
	cp $< $(BOARD)rom.mif

install: $(APPS)
	cp $(APPS) /media/mstock/6874-28D3/
	cd kernel; make install

clean:
	cd gcctests; make clean
	cd kernel; make clean
	rm -f *.o *.hex *.bin *.mif *.gkd *.expand $(APPS) rom-*

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

timertest: timertest.o vectors.o
	$(CC) $(LDFLAGS) -o $@ $^

librawsd.a: ff.o mmc.o gettime.o
	$(AR) rcs -o $@ $^
	$(RANLIB) $@

rom-tests: tests.s
	$(CC) -T profile-$(BOARD).ld -nostartfiles -o $@ $< $(LDFLAGS)

fileio: fileio.o
	$(CC) $(LDFLAGS) -o $@ $^

rom-%: %.o vectors.o boot-$(BOARD).o
	$(CC) -T profile-$(BOARD).ld -nostartfiles -o $@ $< vectors.o $(LDFLAGS) -L. $(LDLIBS) -lrawsd
