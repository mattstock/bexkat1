CC = bexkat1-elf-gcc
CFLAGS = -I../include
LIBS = -L../lib -lsupport
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
	$(CC) -specs=de2.specs -o $@ $^ $(LIBS)
