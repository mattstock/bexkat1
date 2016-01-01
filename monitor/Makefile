CC = bexkat1-elf-gcc
CFLAGS = -Iinclude
LDFLAGS = -specs=de2.specs
LDLIBS = -Llib -lsupport -lm
OBJCOPY = bexkat1-elf-objcopy
OBJDUMP = bexkat1-elf-objdump
AS = bexkat1-elf-as
LD = bexkat1-elf-ld

TEMP := $(shell mktemp)

OBJECTS = boot.o bootstrap.o pretty.o vga.o memtests.o rtc.o fileio.o tests.o ps2.o
APPS = pretty vga bootstrap memtests rtc fileio tests ps2

.PHONY: all clean lib gcctests kernel install

all: boot.o lib bootstrap.mif gcctests kernel $(APPS)

install: $(APPS)
	cp $(APPS) kernel/kernel /media/mstock/19D5-2529/

clean:
	cd lib; make clean
	cd gcctests; make clean
	cd kernel; make clean
	rm -f *.o *.hex *.mif *.gkd *.expand $(APPS)

lib:
	cd lib; make

gcctests:
	cd gcctests; make

kernel:
	cd kernel; make

%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $^

%.mif: %
	$(OBJCOPY) -O mif $< $@

tests: tests.o
	$(CC) -T profile.ld -nostartfiles -o $@ $^ $(LDLIBS)

bootstrap: bootstrap.o
	$(CC) -T profile.ld -nostartfiles -o $@ $^ $(LDLIBS)
