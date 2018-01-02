CC=avr-gcc
OBJCOPY=avr-objcopy
CFLAGS=-mmcu=attiny88 -Os
PROGFLAGS=-B100 -p t88 -c $(ISP) -e
#ISP=avrisp2
ISP=jtag3isp

all: led led.hex

clean:
	rm -f *.o *.hex led

%.hex: %
	$(OBJCOPY) -j .text -j .data -O ihex $< $@

fuse:
	avrdude -B100 -p t88 -c $(ISP) -U lfuse:w:0xEE:m

install: led.hex
	avrdude $(PROGFLAGS) -U flash:w:led.hex
