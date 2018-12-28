#include "serial.h"
#include "matrix.h"
#include <string.h>
#include <sys/types.h>
#include <stdio.h>
#include <stdarg.h>
#include <stdlib.h>

volatile uint32_t * const seg = (uint32_t *)0x30000000;
volatile uint32_t * const mem = (uint32_t *)0x40000000;

#define BOTTOM (0*1024*1024)
#define TOP (16*1024*1024+1)
#define HEX 1

void main(void) {
  uint32_t val;
  
  srand(1000);
  
  serial_printf(0, "Write test:\n");
  for (uint32_t pos=BOTTOM; pos < TOP; pos ++) {
    val = rand();
    mem[pos] = val;
#ifdef PRINT
    serial_printf(0, "%08x ", val);
    if ((pos+1) % 8 == 0)
      serial_printf(0, "\n");
#endif
#ifdef HEX
    if (pos % 0x10000 == 0)
      for (int i=0; i < 4; i++)
	seg[i+4] = (pos >> 4*(i+4)) & 0xf;
#endif
  }

  serial_printf(0, "Read test:\n");

  srand(1000);

  for (uint32_t pos=BOTTOM; pos < TOP; pos ++) {
    val = rand();
    if (val != mem[pos]) {
      serial_printf(0, "failed at %08x %08x %08x\n", pos, mem[pos], val);
      asm("halt");
    }
#ifdef PRINT
    serial_printf(0, "%02x %02x %02x %02x ",
		  val >> 24, (val >> 16) & 0xff, (val >> 8) & 0xff, val & 0xff);
    if ((pos+1) % 8 == 0)
    serial_printf(0, "\n"); 
#endif
#ifdef HEX
    if (pos % 0x10000 == 0)
      for (int i=0; i < 4; i++)
	seg[i+4] = (pos >> 4*(i+4)) & 0xf;
#endif
    } 
  serial_printf(0, "Done!\n");
  while (1);
}
