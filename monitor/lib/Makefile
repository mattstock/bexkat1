#CC = ~/lcc/lcc
#CFLAGS = -I../include
CC = bexkat1-elf-gcc
CFLAGS = -I../include -specs=de2.specs
AS = bexkat1-elf-as
AR = bexkat1-elf-ar
RANLIB = bexkat1-elf-ranlib

TEMP := $(shell mktemp)

.PHONY: all clean

all: libsupport.a

clean:
	rm -f *.o *.a

%.s: %.c
	$(CC) -S $(CFLAGS) -o $@ $^

%.o: %.s
	$(AS) -EB -o $@ $^

libsupport.a: serial.o misc.o matrix.o lcd.o mmc.o ff.o gettime.o itd.o vectors.o spi.o rtc.o debug.o
	$(AR) rcs -o $@ $^
	$(RANLIB) $@
