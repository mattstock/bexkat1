CC = bexkat1-elf-gcc
CFLAGS = -Iinclude
#LDSCRIPT = -T de2.ld
LDSCRIPT = -T profile.ld -nostartfiles
LDFLAGS = $(LDSCRIPT)
LIBS = -Llib -lsupport
OBJCOPY = bexkat1-elf-objcopy
OBJDUMP = bexkat1-elf-objdump
AS = bexkat1-elf-as
LD = bexkat1-elf-ld

TEMP := $(shell mktemp)

.PHONY: all clean lib gcctests

all: lib gcctests boot.o lcd.hex monitor.hex frametests.hex memtests.hex stacktests.hex conditionals-simple.hex multiply.hex multiply-simple.hex fib.hex structures.hex pretty memtests-simple.hex serial.hex random.hex serial-simple.hex vga.hex ops.hex matrix.hex vararg.hex conditionals.hex vectors.hex

clean:
	cd lib; make clean
	cd gcctests; make clean
	rm -f *.o *.srec *.hex memtests stacktests monitor monitor.s frametests frametests.s memtests.s conditionals-simple multiply.s multiply multiply-simple fib.s fib spi.s spi spi-simple structures.s structures fp.s fp pretty.s pretty memtests-simple serial serial.s random random.s serial-simple vga.s vga ops lcd lcd.s matrix matrix.s vararg.s vararg *.gkd *.expand conditionals conditionals.s vectors vectors.s

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

lcd: lcd.o
	$(CC) $(LDFLAGS) -o $@ $^ $(LIBS)

monitor: monitor.o
	$(CC) $(LDFLAGS) -o $@ $^ $(LIBS)

frametests: frametests.o
	$(CC) $(LDFLAGS) -o $@ $^ $(LIBS)

memtests: memtests.o
	$(CC) $(LDFLAGS) -o $@ $^ $(LIBS)

stacktests: stacktests.o
	$(CC) $(LDFLAGS) -o $@ $^ $(LIBS)

conditionals-simple: conditionals-simple.o
	$(CC) $(LDFLAGS) -o $@ $^ $(LIBS)

multiply: multiply.o
	$(CC) $(LDFLAGS) -o $@ $^ $(LIBS)

multiply-simple: multiply-simple.o
	$(CC) $(LDFLAGS) -o $@ $^ $(LIBS)

memtests-simple: memtests-simple.o
	$(CC) $(LDFLAGS) -o $@ $^ $(LIBS)

serial-simple: serial-simple.o
	$(CC) $(LDFLAGS) -o $@ $^ $(LIBS)

fib: fib.o
	$(CC) $(LDFLAGS) -o $@ $^ $(LIBS)

structures: structures.o
	$(CC) $(LDFLAGS) -o $@ $^ $(LIBS)

pretty: pretty.o
	$(CC) -specs=de2.specs -o $@ $^ $(LIBS)

serial: serial.o
	$(CC) $(LDFLAGS) -o $@ $^ $(LIBS)

random: random.o
	$(CC) $(LDFLAGS) -o $@ $^ $(LIBS)

vga: vga.o
	$(CC) $(LDFLAGS) -o $@ $^ $(LIBS)

ops: ops.o
	$(CC) $(LDFLAGS) -o $@ $^ $(LIBS)

matrix: matrix.o
	$(CC) $(LDFLAGS) -o $@ $^ $(LIBS)

vararg: vararg.o
	$(CC) $(LDFLAGS) -o $@ $^ $(LIBS)

conditionals: conditionals.o
	$(CC) $(LDFLAGS) -o $@ $^ $(LIBS)

vectors: vectors.o
	$(CC) $(LDFLAGS) -o $@ $^ $(LIBS)

