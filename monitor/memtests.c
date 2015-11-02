#include <stdio.h>

unsigned *mem = (unsigned *)0xc0000000;

#define MEG (1024*1024)
#define FULL (32*1024*1024)
void main(void) {
  int i,f;

  for (i=0; i < FULL; i++) {
    if (i % MEG == 0)
      iprintf("%d MB write\n", i);
    mem[i] = i;
  }
  for (i=0; i < FULL; i++) {
    if (i % MEG == 0)
      iprintf("%d MB read\n", i);
    if (i != mem[i])
      iprintf("%d failed\n");
  }
  while (1);
}
