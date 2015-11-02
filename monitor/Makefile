CC = bexkat1-elf-gcc
CFLAGS = -Iinclude
LDFLAGS = -specs=de2.specs
LDLIBS = -Llib -lsupport -lm
OBJCOPY = bexkat1-elf-objcopy
OBJDUMP = bexkat1-elf-objdump
AS = bexkat1-elf-as
LD = bexkat1-elf-ld

TEMP := $(shell mktemp)

OBJECTS = boot.o bootstrap.o pretty.o mandsf.o vga.o memtests.o
APPS = pretty mandsf vga bootstrap memtests

.PHONY: all clean lib gcctests kernel install

all: boot.o lib bootstrap.hex gcctests kernel $(APPS)

install: $(APPS)
	cp $(APPS) /media/mstock/19D5-2529/

clean:
	cd lib; make clean
	cd gcctests; make clean
	cd kernel; make clean
	rm -f *.o *.hex *.gkd *.expand $(APPS)

lib:
	cd lib; make

gcctests:
	cd gcctests; make

kernel:
	cd kernel; make

%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $^

%.hex: %
	$(OBJCOPY) -O ihex $< $(TEMP)
	egrep -v "^:02000004" $(TEMP) | egrep -v "^:04000005" > $@	

bootstrap: bootstrap.o
	$(CC) -T profile.ld -nostartfiles -o $@ $^ $(LDLIBS)
