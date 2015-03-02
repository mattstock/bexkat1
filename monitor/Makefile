CC = ~/lcc/lcc
#CFLAGS = -Wf-d
OBJCOPY = bexkat1-elf-objcopy
OBJDUMP = bexkat1-elf-objdump
AS = bexkat1-elf-as
LD = bexkat1-elf-ld

CCTARGET=bexkat1/bexkat1000
LD_SCRIPT = profile.ld
TEMP := $(shell mktemp)

.PHONY: all clean

all: monitor.hex frametests.s frametests.hex memtests.s memtests.hex stacktests.hex conditionals.s conditionals.hex conditionals-simple.hex types.s types.hex multiply.s multiply.hex multiply-simple.hex fib.s fib.hex structures.s structures.hex fp.s fp.hex pretty.s pretty.hex memtests-simple.hex

clean:
	rm -f *.o *.srec *.hex memtests stacktests monitor monitor.s frametests frametests.s memtests.s conditionals conditionals.s conditionals-simple types.s types multiply.s multiply multiply-simple fib.s fib spi.s spi spi-simple structures.s structures fp.s fp pretty.s pretty memtests-simple

%.s: %.c
	$(CC) -S $(CFLAGS) -Wf-target=$(CCTARGET) -o $@ $^

%.o: %.s
	$(AS) -EL -o $@ $^

%.srec: %
	$(OBJCOPY) -O srec $< $@

%.hex: %
	$(OBJCOPY) -O ihex $< $(TEMP)
	egrep -v "^:02000004" $(TEMP) | egrep -v "^:04000005" > $@	

memtests: memtests.o
	$(LD) -EL -o $@ $^ -T $(LD_SCRIPT)
monitor: monitor.o
	$(LD) -EL -o $@ $^ -T $(LD_SCRIPT)
stacktests: stacktests.o
	$(LD) -EL -o $@ $^ -T $(LD_SCRIPT)
frametests: frametests.o
	$(LD) -EL -o $@ $^ -T $(LD_SCRIPT)
conditionals: conditionals.o
	$(LD) -EL -o $@ $^ -T $(LD_SCRIPT)
conditionals-simple: conditionals-simple.o
	$(LD) -EL -o $@ $^ -T $(LD_SCRIPT)
types: types.o
	$(LD) -EL -o $@ $^ -T $(LD_SCRIPT)
multiply: multiply.o
	$(LD) -EL -o $@ $^ -T $(LD_SCRIPT)
multiply-simple: multiply-simple.o
	$(LD) -EL -o $@ $^ -T $(LD_SCRIPT)
fib: fib.o
	$(LD) -EL -o $@ $^ -T $(LD_SCRIPT)
spi: spi.o
	$(LD) -EL -o $@ $^ -T $(LD_SCRIPT)
spi-simple: spi-simple.o
	$(LD) -EL -o $@ $^ -T $(LD_SCRIPT)
structures: structures.o
	$(LD) -EL -o $@ $^ -T $(LD_SCRIPT)
fp: fp.o
	$(LD) -EL -o $@ $^ -T $(LD_SCRIPT)
pretty: pretty.o
	$(LD) -EL -o $@ $^ -T $(LD_SCRIPT)
memtests-simple: memtests-simple.o
	$(LD) -EL -o $@ $^ -T $(LD_SCRIPT)
