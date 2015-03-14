#ifndef _MONITOR_H_
#define _MONITOR_H_

unsigned *matrix = (unsigned *)0x00800000;
volatile unsigned char *serial0 = (unsigned char *)0x00800800;
volatile unsigned char *serial1 = (unsigned char *)0x00800820;
volatile unsigned short *sw = (unsigned short *)0x00800840;
volatile unsigned short *leds = (unsigned short *)0x00800850;

#endif
