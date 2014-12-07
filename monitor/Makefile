CC = ~/lcc/lcc
OBJCOPY = bexkat1-elf-objcopy
OBJDUMP = bexkat1-elf-objdump
AS = bexkat1-elf-as
LD = bexkat1-elf-ld

CCTARGET=bexkat1/bexkat1000
LD_SCRIPT = profile.ld

.PHONY: all clean

all: monitor.srec

clean:
	rm monitor.s monitor.o monitor monitor.srec

monitor.s: monitor.c
	$(CC) -S -Wf-target=$(CCTARGET) -o $@ $^ 

monitor.o: monitor.s
	$(AS) -o $@ $^

monitor.srec: monitor
	$(OBJCOPY) -O srec $< $@

monitor: monitor.o
	$(LD) -o $@ $^ # -T $(LD_SCRIPT)
