#CC = ~/lcc/lcc
#CFLAGS = -Wf-d -Iinclude
CC = ~/projects/gcc-build/gcc/xgcc
CFLAGS = -Iinclude -B/home/mstock/projects/gcc-build/gcc -B/usr/local/bexkat1-elf/bin/ -B/usr/local/bexkat1-elf/lib/
LDFLAGS = -Llib -lsupport
OBJCOPY = bexkat1-elf-objcopy
OBJDUMP = bexkat1-elf-objdump
AS = bexkat1-elf-as
LD = bexkat1-elf-ld

LD_SCRIPT = profile.ld
TEMP := $(shell mktemp)

.PHONY: all clean lib gcctests

all: lib gcctests boot.o lcd.s lcd.hex monitor.s monitor.hex frametests.s frametests.hex memtests.s memtests.hex stacktests.hex conditionals-simple.hex multiply.s multiply.hex multiply-simple.hex fib.s fib.hex structures.s structures.hex pretty.s pretty.hex memtests-simple.hex serial.s serial.hex random.s random.hex serial-simple.hex vga.s vga.hex ops.s ops.hex matrix.s matrix.hex vararg.s vararg.hex

clean:
	cd lib; make clean
	cd gcctests; make clean
	rm -f *.o *.srec *.hex memtests stacktests monitor monitor.s frametests frametests.s memtests.s conditionals-simple multiply.s multiply multiply-simple fib.s fib spi.s spi spi-simple structures.s structures fp.s fp pretty.s pretty memtests-simple serial serial.s random random.s serial-simple vga.s vga ops lcd lcd.s matrix matrix.s vararg.s vararg *.gkd *.expand

lib:
	cd lib; make

gcctests:
	cd gcctests; make

%.s: %.c
	$(CC) -S $(CFLAGS) -o $@ $^

%.o: %.s
	$(AS) -EB -o $@ $^

%.srec: %
	$(OBJCOPY) -O srec $< $@

%.hex: %
	$(OBJCOPY) -O ihex $< $(TEMP)
	egrep -v "^:02000004" $(TEMP) | egrep -v "^:04000005" > $@	

memtests: memtests.o
	$(LD) -o $@ $^ -T $(LD_SCRIPT)
monitor: monitor.o 
	$(LD) -o $@ $^ -T $(LD_SCRIPT) $(LDFLAGS)
lcd: lcd.o 
	$(LD) -o $@ $^ -T $(LD_SCRIPT) $(LDFLAGS)
stacktests: stacktests.o
	$(LD) -o $@ $^ -T $(LD_SCRIPT)
frametests: frametests.o
	$(LD) -o $@ $^ -T $(LD_SCRIPT)
conditionals-simple: conditionals-simple.o
	$(LD) -o $@ $^ -T $(LD_SCRIPT)
multiply: multiply.o
	$(LD) -o $@ $^ -T $(LD_SCRIPT)
multiply-simple: multiply-simple.o
	$(LD) -o $@ $^ -T $(LD_SCRIPT)
fib: fib.o
	$(LD) -o $@ $^ -T $(LD_SCRIPT) $(LDFLAGS)
spi: spi.o
	$(LD) -o $@ $^ -T $(LD_SCRIPT)
spi-simple: spi-simple.o
	$(LD) -o $@ $^ -T $(LD_SCRIPT)
structures: structures.o
	$(LD) -o $@ $^ -T $(LD_SCRIPT) $(LDFLAGS)
fp: fp.o
	$(LD) -o $@ $^ -T $(LD_SCRIPT)
pretty: pretty.o
	$(LD) -o $@ $^ -T $(LD_SCRIPT) $(LDFLAGS)
memtests-simple: memtests-simple.o
	$(LD) -o $@ $^ -T $(LD_SCRIPT)
serial: serial.o
	$(LD) -o $@ $^ -T $(LD_SCRIPT) $(LDFLAGS)
serial-simple: serial-simple.o
	$(LD) -o $@ $^ -T $(LD_SCRIPT)
random: random.o
	$(LD) -o $@ $^ -T $(LD_SCRIPT) $(LDFLAGS)
vga: vga.o
	$(LD) -o $@ $^ -T $(LD_SCRIPT) $(LDFLAGS)
ops: ops.o
	$(LD) -o $@ $^ -T $(LD_SCRIPT)
matrix: matrix.o
	$(LD) -o $@ $^ -T $(LD_SCRIPT) $(LDFLAGS)
vararg: vararg.o
	$(LD) -o $@ $^ -T $(LD_SCRIPT) $(LDFLAGS)
