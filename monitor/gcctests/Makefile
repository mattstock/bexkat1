CC = bexkat1-elf-gcc
#LCC = ~/lcc/lcc
#MCC = moxie-elf-gcc
CFLAGS = -I../include
#GCCFLAGS = -dP
#CFLAGS = -I../include -B/home/mstock/projects/gcc-build/gcc -B/usr/local/bexkat1-elf/bin/ -B/usr/local/bexkat1-elf/lib/

.PHONY: all clean

all: types.s conditionals.s fib.s frametests.s fp.s

clean:
	rm -f *.o *.s *.expand *.gkd types.c.* conditionals.c.*

%.s: %.c
	$(CC) -S $(CFLAGS) $(GCCFLAGS) -o $@ $^

%-lcc.s: %.c
	$(LCC) -S $(CFLAGS) -o $@ $^

%-moxie.s: %.c
	$(MCC) -S $(CFLAGS) $(GCCFLAGS) -o $@ $^


%.o: %.s
	$(AS) -EB -o $@ $^
