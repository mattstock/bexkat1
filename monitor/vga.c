#include <stdio.h>
#include <vga.h>
#include <matrix.h>

void main() {
  matrix_init();
  matrix_put(0,0,0xff);
  for (unsigned int i=0; i < 256; i++) {
    vga_palette(0, i, (i << 16) | (i << 8) | i);
  }
  matrix_put(0,0,0xff00);
  for (int x=0; x < 640; x++)
    for (int y=0; y < 480; y++) {
      vga_point(x, y, x % 256);
    }
  matrix_put(0,0, 0xff0000);
}

