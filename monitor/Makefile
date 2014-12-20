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

all: monitor.srec monitor.hex 

clean:
	rm monitor.o monitor monitor.srec monitor.hex test.o test memtest memtest.o memtest.s monitor.s monitor-symbolic.s

%.s: %.c
	$(CC) -S $(CFLAGS) -Wf-target=$(CCTARGET) -o $@ $^

monitor-symbolic.s: monitor.c
	$(CC) -S $(CFLAGS) -Wf-target=symbolic -o $@ $^

%.o: %.s
	$(AS) -o $@ $^

%.srec: %
	$(OBJCOPY) -O srec $< $@

%.hex: %
	$(OBJCOPY) -O ihex $< $(TEMP)
	egrep -v "^:02000004" $(TEMP) | egrep -v "^:04000005" > $@	

memtest: memtest.o
	$(LD) -o $@ $^ -T $(LD_SCRIPT)
monitor: monitor.o
	$(LD) -o $@ $^ -T $(LD_SCRIPT)
test: test.o
	$(LD) -o $@ $^ -T $(LD_SCRIPT)
