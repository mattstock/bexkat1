#include "matrix.h"
#include <stdio.h>
#include "misc.h"

unsigned int *kbd = (unsigned int *)0x30004000;
unsigned int *mouse = (unsigned int *)0x30005000;

void main() {
  char c;
  int i;
  while (1) {
    matrix_put(3,1,0xff);
    sysctrl[0] = kbd[1]; 
    if (kbd[1] > 0)
      iprintf("code = %08x\n", kbd[0]);
  }
}
