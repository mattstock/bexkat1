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

.PHONY: all clean lib gcctests

all: lib gcctests boot.o bootstrap.hex pretty

clean:
	cd lib; make clean
	cd gcctests; make clean
	rm -f *.o *.srec *.hex bootstrap bootstrap.s pretty.s pretty *.gkd *.expand

lib:
	cd lib; make

gcctests:
	cd gcctests; make

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
