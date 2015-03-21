#ifndef _MONITOR_H_
#define _MONITOR_H_

unsigned *matrix = (unsigned *)0x00800000;
volatile unsigned int *serial0 = (unsigned int *)0x00800800;
volatile unsigned int *serial1 = (unsigned int *)0x00800808;
volatile unsigned short *sw = (unsigned short *)0x00800810;

#endif
