CC = bexkat1-elf-gcc
CFLAGS = -O2 -I../include
LDLIBS = -lsupport -lm
LDFLAGS = -specs=de2.specs
OBJDUMP = bexkat1-elf-objdump
AS = bexkat1-elf-as
LD = bexkat1-elf-ld

TEMP := $(shell mktemp)

.PHONY: all

all: kernel

clean:
	rm -f *.o *.srec *.hex kernel

%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $^

kernel: kernel.o font.o


install: kernel
	cp kernel /media/mstock/A5BC-530B/
