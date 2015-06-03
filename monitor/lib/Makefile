#CC = ~/lcc/lcc
CC = ~/projects/gcc-build/gcc/xgcc
CFLAGS = -I../include -B/home/mstock/projects/gcc-build/gcc -B/usr/local/bexkat1-elf/bin/ -B/usr/local/bexkat1-elf/lib/
AS = bexkat1-elf-as
AR = bexkat1-elf-ar

TEMP := $(shell mktemp)

.PHONY: all clean

all: libsupport.a

clean:
	rm -f *.o *.a *.s

%.s: %.c
	$(CC) -S $(CFLAGS) -o $@ $^

%.o: %.s
	$(AS) -EB -o $@ $^

libsupport.a: serial.o misc.o matrix.o lcd.o mmc.o ff.o gettime.o
	$(AR) rcs -o $@ $^
