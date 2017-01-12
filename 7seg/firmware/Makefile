CC=avr-gcc
OBJCOPY=avr-objcopy
CFLAGS=-mmcu=attiny88 -Os
PROGFLAGS=-B10 -p t88 -c $(ISP) -e
#ISP=avrisp2
ISP=jtag3isp

all: led led.hex

clean:
	rm -f *.o *.hex led

%.hex: %
	$(OBJCOPY) -j .text -j .data -O ihex $< $@

install: led.hex
	avrdude $(PROGFLAGS) -U flash:w:led.hex
