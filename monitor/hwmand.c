#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <vga.h>
#include <keyboard.h>
#include <mandelbrot.h>

#define MAX_DEPTH 255

typedef union {
  float f;
  unsigned int i;
} mixel;

void main(void) {
  int x,y,active,load_complete;
  float cx, cy, scale;

  cx = -0.9f;
  cy = -0.2f;
  scale = 0.001f;
  
  printf("init palette\n");
  for (x=0; x < 256; x++)
    vga_palette(0, x, x | (x<<8));
  vga_set_mode(VGA_MODE_NORMAL);

  printf("init pixel markers\n");
  x = 0;
  y = 0;
  load_complete = 0;
  active = 0;
  
  printf("clearing queue\n");
  while (MAND_CONTROL != 0)
    MAND_CONTROL = MAND_POP;

  do {
    // keep 256 pixels in the hopper
    while (!load_complete && active < MAX_DEPTH) {
      MAND_X0 = cx + (x-320)*scale;
      MAND_Y0 = cy + (y-240)*scale;
      MAND_X0I = x;
      MAND_Y0I = y;
      MAND_CONTROL = MAND_PUSH;
      vga_point(x,y,0);
      active++;
      y++;
      if (y == 480) {
	y=0;
	x++;
	if (x == 640)
	  load_complete=1;
      }
    }

    while (MAND_CONTROL != 0) {
      MAND_CONTROL = MAND_POP;
      vga_point(MAND_X0I, MAND_Y0I, MAND_LOOP % 256);
      active--;
    }
  } while (!load_complete);
  printf("done\n");
}
