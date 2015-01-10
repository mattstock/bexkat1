#ifndef _MONITOR_H_
#define _MONITOR_H_

unsigned *matrix = (unsigned *)0xff410000;
volatile unsigned *encoder = (unsigned *)0xff400000;
volatile unsigned short *serial0 = (unsigned short *)0xff400010;
volatile unsigned short *serial1 = (unsigned short *)0xff400020;
volatile unsigned short *serial2 = (unsigned short *)0xff400050;
volatile unsigned short *kbd = (unsigned short *)0xff400030;
volatile unsigned char *sw = (unsigned char *)0xff400040;

#endif
