CC = gcc
CFLAGS= -std=c99
TOOLS = data2bin

default: $(TOOLS)
	./data2bin
	convert -size 128x64 -depth 8 gray:raw.bmp font88.bmp

clean:
	rm -f *.o $(TOOLS) *.bmp

