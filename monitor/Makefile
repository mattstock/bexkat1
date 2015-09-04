CC = bexkat1-elf-gcc
CFLAGS = -Iinclude
LDSCRIPT = -T profile.ld -nostartfiles
LDFLAGS = $(LDSCRIPT)
LIBS = -Llib -lsupport
OBJCOPY = bexkat1-elf-objcopy
OBJDUMP = bexkat1-elf-objdump
AS = bexkat1-elf-as
LD = bexkat1-elf-ld

TEMP := $(shell mktemp)

.PHONY: all clean lib gcctests kernel install

all: lib gcctests boot.o bootstrap.hex pretty kernel matrix

install: kernel pretty
	cp kernel/kernel pretty /media/mstock/19D5-2529/

clean:
	cd lib; make clean
	cd gcctests; make clean
	cd kernel; make clean
	rm -f *.o *.srec *.hex bootstrap bootstrap.s matrix pretty.s pretty *.gkd *.expand

lib:
	cd lib; make

gcctests:
	cd gcctests; make

kernel:
	cd kernel; make

%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $^

%.srec: %
	$(OBJCOPY) -O srec $< $@

%.hex: %
	$(OBJCOPY) -O ihex $< $(TEMP)
	egrep -v "^:02000004" $(TEMP) | egrep -v "^:04000005" > $@	

bootstrap: bootstrap.o
	$(CC) $(LDFLAGS) -o $@ $^ $(LIBS)

pretty: pretty.o
	$(CC) -specs=de2.specs -o $@ $^ $(LIBS)

matrix: matrix.o
	$(CC) -specs=de2.specs -o $@ $^ $(LIBS)
