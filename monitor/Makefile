CC = ~/lcc/lcc
CFLAGS = -Wf-d
OBJCOPY = bexkat1-elf-objcopy
OBJDUMP = bexkat1-elf-objdump
AS = bexkat1-elf-as
LD = bexkat1-elf-ld

CCTARGET=bexkat1/bexkat1000
LD_SCRIPT = profile.ld
TEMP := $(shell mktemp)

.PHONY: all clean

all: monitor.hex frametests.s frametests.hex memtests.s memtests.hex stacktests.hex conditionals.hex conditionals.s conditionals-simple.hex types.s types.hex

clean:
	rm -f *.o *.srec *.hex memtests stacktests monitor frametests frametests.s memtests.s conditionals conditionals.s conditionals-simple types.s types

%.s: %.c
	$(CC) -S $(CFLAGS) -Wf-target=$(CCTARGET) -o $@ $^

%.o: %.s
	$(AS) -o $@ $^

%.srec: %
	$(OBJCOPY) -O srec $< $@

%.hex: %
	$(OBJCOPY) -O ihex $< $(TEMP)
	egrep -v "^:02000004" $(TEMP) | egrep -v "^:04000005" > $@	

memtests: memtests.o
	$(LD) -o $@ $^ -T $(LD_SCRIPT)
monitor: monitor.o
	$(LD) -o $@ $^ -T $(LD_SCRIPT)
stacktests: stacktests.o
	$(LD) -o $@ $^ -T $(LD_SCRIPT)
frametests: frametests.o
	$(LD) -o $@ $^ -T $(LD_SCRIPT)
conditionals: conditionals.o
	$(LD) -o $@ $^ -T $(LD_SCRIPT)
conditionals-simple: conditionals-simple.o
	$(LD) -o $@ $^ -T $(LD_SCRIPT)
types: types.o
	$(LD) -o $@ $^ -T $(LD_SCRIPT)
