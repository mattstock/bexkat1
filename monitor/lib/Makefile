CC = ~/lcc/lcc
CFLAGS = -I../include
AS = bexkat1-elf-as
AR = bexkat1-elf-ar

CCTARGET=bexkat1/bexkat1000
TEMP := $(shell mktemp)

.PHONY: all clean

all: libsupport.a

clean:
	rm -f *.o *.a *.s

%.s: %.c
	$(CC) -S $(CFLAGS) -Wf-target=$(CCTARGET) -o $@ $^

%.o: %.s
	$(AS) -EB -o $@ $^

libsupport.a: serial.o misc.o matrix.o lcd.o mmc.o ff.o gettime.o
	$(AR) rcs -o $@ $^
