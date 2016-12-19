#include <stdio.h>
#include <vga.h>
#include <matrix.h>
#include <misc.h>

void main() {
  unsigned char ch = 0x00;
  vga_set_mode(0x02);
  for (int y=0; y < 40; y++) {
    for (int x=0; x < 80; x++) {
      vga_fb[80*y+x] = ch++;
    }
  }
  while (1);
}

