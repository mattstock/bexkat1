CC = bexkat1-elf-gcc
CFLAGS = -Iinclude -specs=de2.specs
AS = bexkat1-elf-as
AR = bexkat1-elf-ar
RANLIB = bexkat1-elf-ranlib

TEMP := $(shell mktemp)

.PHONY: all clean install

all: libsupport.a

install: libsupport.a
	cp libsupport.a /usr/local/bexkat1-elf/lib
	cp include/*.h /usr/local/bexkat1-elf/include

clean:
	rm -f *.o *.a

%.s: %.c
	$(CC) -S $(CFLAGS) -o $@ $^

%.o: %.s
	$(AS) -EB -o $@ $^

libsupport.a: serial.o misc.o matrix.o lcd.o spi.o rtc.o debug.o vga.o timers.o keyboard.o codec.o mandelbrot.o i2c.o
	$(AR) rcs -o $@ $^
	$(RANLIB) $@
