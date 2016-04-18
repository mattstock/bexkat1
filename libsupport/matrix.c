#include "matrix.h"
#include <stdlib.h>

unsigned *matrix = (unsigned *)0x20000000;

void matrix_put(unsigned x, unsigned y, unsigned val) {
  if (y > 15 || x > 31)
    return;
  matrix[y*32+x] = val;
}

void matrix_line(unsigned x0, unsigned y0, unsigned x1, unsigned y1, unsigned val) {
  int dx = abs(x1 - x0);
  int sx = (x0<x1 ? 1 : -1);
  int dy = abs(y1 - y0);
  int sy = (y0<y1 ? 1 : -1);
  int err = (dx>dy ? dx : -dy)/2;
  int e2;

  while (1) {
    matrix_put(x0,y0,val);
    if (x0 == x1 && y0 == y1) break;
    e2 = err;
    if (e2 > -dx) { err -= dy; x0 += sx; }
    if (e2 < dy) { err += dx; y0 += sy; }
  }
}

void matrix_circle(unsigned x0, unsigned y0, unsigned r, unsigned val) {
  int d = 1 - r;
  int x = r;
  int y = 0;

  while (y <= x) {
    matrix_put(x+x0, y+y0, val);
    matrix_put(y+x0, x+y0, val);
    matrix_put(x0-x, y+y0, val);
    matrix_put(x0-y, x+y0, val);
    matrix_put(x0-x, y0-y, val);
    matrix_put(x0-y, y0-x, val);
    matrix_put(x+x0, y0-y, val);
    matrix_put(y+x0, y0-x, val);
    y++;
    if (d <= 0) {
      d += 2*y+1;
    } else {
      x--;
      d += 2*(y-x)+1;
    }
  }
}

void matrix_init() {
  unsigned short i;

  for (i=0; i < 16*32; i++)
    matrix[i] = 0;
}

void matrix_bitprint(unsigned row, unsigned val) {
  unsigned int i=0;

  while (i < 32) {
    matrix[row*32+i] = 0x00000000;
    i++;
  }
  i = 31;
  while (val) {
    if (val & 0x1)
      matrix[row*32+i] = 0x00ff0000;
    val = val >> 1;
    i--;
  }
}
