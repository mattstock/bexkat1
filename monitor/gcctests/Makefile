CC = ~/projects/bexkat1/gcc-build/gcc/xgcc
LCC = ~/lcc/lcc
MCC = ~/projects/moxie/gcc-build/gcc/xgcc
MCFLAGS = -B/home/mstock/projects/moxie/gcc-build/gcc -B/usr/local/moxie-elf/bin -B/usr/local/moxie-elf/lib -dP
CFLAGS = -I../include
GCCFLAGS = -B/home/mstock/projects/bexkat1/gcc-build/gcc -B/usr/local/bexkat1-elf/bin/ -B/usr/local/bexkat1-elf/lib/ -dP
#CFLAGS = -I../include -B/home/mstock/projects/gcc-build/gcc -B/usr/local/bexkat1-elf/bin/ -B/usr/local/bexkat1-elf/lib/

.PHONY: all clean

all: types.s conditionals.s types-lcc.s types-moxie.s fib.s fib-lcc.s

clean:
	rm -f *.o *.s *.expand *.gkd types.c.* conditionals.c.*

%.s: %.c
	$(CC) -S $(CFLAGS) $(GCCFLAGS) -o $@ $^

%-lcc.s: %.c
	$(LCC) -S $(CFLAGS) -o $@ $^

%-moxie.s: %.c
	$(MCC) -S $(CFLAGS) $(MCFLAGS) -o $@ $^


%.o: %.s
	$(AS) -EB -o $@ $^
