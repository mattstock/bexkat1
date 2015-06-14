#CC = ~/lcc/lcc
#LCCDEBUG = -Wf-d
#CFLAGS = -Iinclude $(LCCDEBUG)
CC = bexkat1-elf-gcc
CFLAGS = -Iinclude
LDFLAGS = -Llib -lnosys -lsupport
OBJCOPY = bexkat1-elf-objcopy
OBJDUMP = bexkat1-elf-objdump
AS = bexkat1-elf-as
LD = bexkat1-elf-ld

LD_SCRIPT = profile.ld
TEMP := $(shell mktemp)

.PHONY: all clean lib gcctests

all: lib gcctests lcd.hex monitor.hex frametests.hex memtests.hex stacktests.hex conditionals-simple.hex multiply.hex multiply-simple.hex fib.hex structures.hex pretty.hex memtests-simple.hex serial.hex random.hex serial-simple.hex vga.hex ops.hex matrix.hex vararg.hex conditionals.hex

clean:
	cd lib; make clean
	cd gcctests; make clean
	rm -f *.o *.srec *.hex memtests stacktests monitor monitor.s frametests frametests.s memtests.s conditionals-simple multiply.s multiply multiply-simple fib.s fib spi.s spi spi-simple structures.s structures fp.s fp pretty.s pretty memtests-simple serial serial.s random random.s serial-simple vga.s vga ops lcd lcd.s matrix matrix.s vararg.s vararg *.gkd *.expand conditionals conditionals.s

lib:
	cd lib; make

gcctests:
	cd gcctests; make

%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $^

%: %.o
	$(CC) $(LDFLAGS) -o $@ $^

%.srec: %
	$(OBJCOPY) -O srec $< $@

%.hex: %
	$(OBJCOPY) -O ihex $< $(TEMP)
	egrep -v "^:02000004" $(TEMP) | egrep -v "^:04000005" > $@	
