CC = bexkat1-elf-gcc
LDFLAGS = -specs=de2.specs
LDLIBS = -lsupport -lm
OBJCOPY = bexkat1-elf-objcopy
OBJDUMP = bexkat1-elf-objdump
AS = bexkat1-elf-as
LD = bexkat1-elf-ld

TEMP := $(shell mktemp)

OBJECTS = boot.o bootstrap.o pretty.o vga.o memtests.o rtc.o fileio.o tests.o ps2.o fib.o
APPS = pretty vga bootstrap memtests rtc fileio tests ps2 fib

.PHONY: all clean gcctests kernel install

all: boot.o bootstrap.mif tests.mif $(APPS)

install: $(APPS)
	cp $(APPS) /media/mstock/A5BC-530B/

clean:
	cd gcctests; make clean
	cd kernel; make clean
	rm -f *.o *.hex *.mif *.gkd *.expand $(APPS)

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

fileio: fileio.o
	$(CC) $(LDFLAGS) -o $@ $^

bootstrap: bootstrap.o
	$(CC) -T profile.ld -nostartfiles -o $@ $^ $(LDLIBS)
