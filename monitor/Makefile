CC = bexkat1-elf-gcc
BOARD = de2
#BOARD = max10
LDFLAGS = -specs=$(BOARD).specs
LDLIBS = -lsupport -lm
OBJCOPY = bexkat1-elf-objcopy
OBJDUMP = bexkat1-elf-objdump
AS = bexkat1-elf-as
LD = bexkat1-elf-ld

TEMP := $(shell mktemp)

OBJECTS = boot-$(BOARD).o bootstrap.o pretty.o fmand.o memtests.o rtc.o fileio.o tests.o ps2.o fib.o audiogen.o clock.o fly.o showpic.o setjmp.o hwmand.o
APPS = pretty fmand bootstrap memtests rtc fileio tests ps2 fib audiogen clock fly showpic setjmp hwmand codec codec_w vga

.PHONY: all clean gcctests kernel install

all: boot-$(BOARD).o bootstrap.mif bootstrap.bin tests.mif $(APPS) kernel

install: $(APPS)
	cp $(APPS) /media/mstock/A5BC-530B/
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

tests: tests.o
	$(CC) -T profile-$(BOARD).ld -nostartfiles -o $@ $^ $(LDLIBS)

fileio: fileio.o
	$(CC) $(LDFLAGS) -o $@ $^

bootstrap: bootstrap.o
	$(CC) -T profile-$(BOARD).ld -nostartfiles -o $@ $^ $(LDLIBS)
