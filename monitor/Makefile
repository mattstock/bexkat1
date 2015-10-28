CC = bexkat1-elf-gcc
CFLAGS = -Iinclude
LDSCRIPT = -T profile.ld -nostartfiles
LDFLAGS = $(LDSCRIPT)
LIBS = -Llib -lsupport -lm
OBJCOPY = bexkat1-elf-objcopy
OBJDUMP = bexkat1-elf-objdump
AS = bexkat1-elf-as
LD = bexkat1-elf-ld

TEMP := $(shell mktemp)

.PHONY: all clean lib gcctests kernel install

all: lib gcctests boot.o bootstrap.hex pretty kernel matrix floaters multiply fps serial.hex mandsf manddf vga basic rtc

install: kernel pretty floaters mandsf manddf basic fps vga rtc
	cp kernel/kernel pretty floaters mandsf manddf basic fps vga rtc /media/mstock/19D5-2529/

clean:
	cd lib; make clean
	cd gcctests; make clean
	cd kernel; make clean
	rm -f *.o *.srec *.hex bootstrap bootstrap.s mandsf basic matrix pretty.s pretty multiply fp-simple floaters serial *.gkd *.expand manddf fps vga rtc

lib:
	cd lib; make

gcctests:
	cd gcctests; make

kernel:
	cd kernel; make

%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $^

%.srec: %
	$(OBJCOPY) -O srec $< $@

%.hex: %
	$(OBJCOPY) -O ihex $< $(TEMP)
	egrep -v "^:02000004" $(TEMP) | egrep -v "^:04000005" > $@	

bootstrap: bootstrap.o
	$(CC) $(LDFLAGS) -o $@ $^ $(LIBS)

serial: serial.o
	$(CC) $(LDFLAGS) -o $@ $^ $(LIBS)

pretty: pretty.o
	$(CC) -specs=de2.specs -o $@ $^ $(LIBS)

matrix: matrix.o
	$(CC) -specs=de2.specs -o $@ $^ $(LIBS)

multiply: multiply.o
	$(CC) -specs=de2.specs -o $@ $^ $(LIBS)

floaters: floaters.o
	$(CC) -specs=de2.specs -o $@ $^ $(LIBS)

mandsf: mandsf.o
	$(CC) -specs=de2.specs -o $@ $^ $(LIBS)

manddf: manddf.o
	$(CC) -specs=de2.specs -o $@ $^ $(LIBS)

vga: vga.o
	$(CC) -specs=de2.specs -o $@ $^ $(LIBS)

basic: basic.o
	$(CC) -specs=de2.specs -o $@ $^ $(LIBS)

fps: fps.o
	$(CC) -specs=de2.specs -o $@ $^ $(LIBS)

rtc: rtc.o
	$(CC) -specs=de2.specs -o $@ $^ $(LIBS)
