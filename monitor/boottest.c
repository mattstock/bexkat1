#include "serial.h"
#include "matrix.h"
#include <string.h>
#include <sys/types.h>
#include <stdio.h>
#include <stdarg.h>
#include <stdlib.h>

volatile uint32_t * const seg = (uint32_t *)0x30000000;
volatile uint32_t * const mem = (uint32_t *)0x40000000;

void main(void) {
  uint32_t val;

  srand(10000);
  
  serial_printf(0, "Read/write test:\n");
  for (uint32_t pos=15*1024*1024; pos < 32*1024*1024; pos += 16) {
    val = rand();
    mem[pos] = val;
    if (mem[pos] != val) {
      serial_printf(0, "error [%08x] = %08x (should be %08x)\n",
		    pos, mem[pos], val);
      asm("halt");
    }
    if ((pos % 0x10000) == 0)
    serial_printf(0, "[%08x] complete\n", pos); 
  }

  serial_printf(0, "Read test:\n");
  srand(10000);
  for (uint32_t pos=15*1024*1024; pos < 32*1024*1024; pos += 16) {
    val = rand();
    if (mem[pos] != val) {
      serial_printf(0, "error [%08x] = %08x (should be %08x)\n",
		    pos, mem[pos], val);
      asm("halt");
    }
    if ((pos % 0x8000) == 0)
      serial_printf(0, "[%08x] complete\n", pos);
  }
  
  serial_printf(0, "Done!\n");
  while (1);
}
