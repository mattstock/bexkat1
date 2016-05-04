#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <vga.h>
#include <keyboard.h>

volatile float * const mand =  (float *)0xd0000000;
volatile unsigned int * const mand_control = (unsigned int *)0xd0000020;

#define MAND_X0   0
#define MAND_Y0   1
#define MAND_XN   2
#define MAND_YN   3
#define MAND_RES  4
#define MAND_PUSH 0
#define MAND_POP  1

#define MAX_DEPTH 255

typedef union {
  float f;
  unsigned int i;
} mixel;

typedef struct {
  unsigned active;
  unsigned x;
  unsigned y;
  float sx;
  float sy;
  unsigned loop;
} node;

void main(void) {
  int x,y,active,load_complete;
  node *pool = (node *)malloc(256*sizeof(node));
  float cx, cy, scale, limit;

  cx = 0.1f;
  cy = 0.0f;
  scale = 0.008f;
  limit = 4.0f;
  
  printf("init palette\n");
  for (x=0; x < 256; x++)
    vga_palette(0, x, x | (x<<8));
  vga_set_mode(VGA_MODE_NORMAL);

  printf("init pixel markers\n");
  x = 0;
  y = 0;
  for (active=0; active < 256; active++)
    pool[active].active = 0;
  active=0;
  load_complete = 0;

  printf("clearing queue\n");
  while (mand_control[MAND_POP] != 0)
    mand_control[MAND_POP] = 1;

  do {
    // keep 256 pixels in the hopper
    int seek=0;
    while (!load_complete && active < MAX_DEPTH) {
      // we don't reset the seek value since we're gap-filling
      for (;seek < MAX_DEPTH; seek++)
	if (pool[seek].active == 0)
	  break;
      if (seek == MAX_DEPTH) {
	printf("an unpossible state!\n");
	exit(1);
      }
      pool[seek].active = 1;
      pool[seek].x = x;
      pool[seek].y = y;
      pool[seek].loop = 0;
      pool[seek].sx = cx + (x-320)*scale;
      pool[seek].sy = cy + (y-240)*scale;
      mand[MAND_X0] = pool[seek].sx;
      mand[MAND_Y0] = pool[seek].sy;
      mand[MAND_XN] = pool[seek].sx;
      mand[MAND_YN] = pool[seek].sy;
      mand_control[MAND_PUSH] = 1;
      vga_point(x,y,0);
      active++;
      x++;
      if (x == 640) {
	x=0;
	y++;
	if (y == 480)
	  load_complete=1;
      }
    }

    while (mand_control[MAND_POP] != 0) {
      mand_control[MAND_POP] = 1;
      float result = mand[MAND_RES];
      int work;
      mixel a,b,c,d;
      for (work=0; work < MAX_DEPTH; work++) {
	if (pool[work].active == 0)
	  continue;
#if 0	
	a.f = pool[work].sx;
	b.f = pool[work].sy;
	c.f = mand[MAND_X0];
	d.f = mand[MAND_Y0];
	printf("%d: looking at %08x %08x %08x %08x\n", work, a.i, b.i, c.i, d.i);
#endif
	if (pool[work].sx == mand[MAND_X0] && pool[work].sy == mand[MAND_Y0])
	  break;
      }
      if (work == MAX_DEPTH) {
	printf("a second unpossibility.\n");
	exit(1);
      }

      pool[work].loop++;
      
      if (pool[work].loop == 256 ||
	  result > limit ||
	  fpclassify(result) == FP_INFINITE) {
	vga_point(pool[work].x, pool[work].y, pool[work].loop % 256);
	pool[work].active = 0;
	active--;
      } else {
	mand_control[MAND_PUSH] = 1; // give it another go
      }
    }
  } while (!load_complete);
  printf("done\n");
}
