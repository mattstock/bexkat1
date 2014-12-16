CC = ~/lcc/lcc
OBJCOPY = bexkat1-elf-objcopy
OBJDUMP = bexkat1-elf-objdump
AS = bexkat1-elf-as
LD = bexkat1-elf-ld

CCTARGET=bexkat1/bexkat1000
LD_SCRIPT = profile.ld

.PHONY: all clean

all: monitor.srec monitor.hex monitor-symbolic.s test

clean:
	rm monitor.s monitor.o monitor monitor.srec monitor.hex test.o test

monitor-symbolic.s: monitor.c
	$(CC) -S -Wf-target=symbolic -o $@ $^ 

monitor.s: monitor.c
	$(CC) -S -Wf-target=$(CCTARGET) -o $@ $^ 

monitor.o: monitor.s
	$(AS) -o $@ $^

monitor.srec: monitor
	$(OBJCOPY) -O srec $< $@

monitor.hex: monitor
	$(OBJCOPY) -O ihex $< $@

monitor: monitor.o
	$(LD) -o $@ $^ -T $(LD_SCRIPT)

test.o: test.s
	$(AS) -o $@ $^

test: test.o
	$(LD) -o $@ $^ -T $(LD_SCRIPT)
