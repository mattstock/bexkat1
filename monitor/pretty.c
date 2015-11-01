#include <stdarg.h>
#include "misc.h"
#include "matrix.h"
#include "serial.h"
#include <stdio.h>
#include <stdlib.h>
#include "vectors.h"

void matrix_fade(void) {
  unsigned short i;
  unsigned a;
  for (i=0; i < 16*32; i++) {
    a = matrix[i];
    if ((a & 0xff0000) >= 0x10000)
      a -= 0x10000;
    else
      a &= 0xffff;
    if ((a & 0xff00) >= 0x100)
      a -= 0x100;
    else
      a &= 0xff00ff;
    if ((a & 0xff) >= 0x1)
      a -= 0x1;
    else
      a &= 0xffff00;
    matrix[i] = a; 
  }
}

void main(void) {
  char c;
  unsigned val;
  unsigned short x, y;

  x = 16;
  y = 8;
  val = 0x00808080;

  srand(39854);
  while (1) {
    matrix_fade();
    c = (char) (rand() % 4);
    switch (c) {
      case 0:
        if (x > 0)
          x--;
        break;
      case 1:
        if (x < 31)
          x++;
        break;
     case 2:
       if (y > 0)
         y--;
       break;
     case 3:
       if (y < 15)
         y++;
       break;
    }  
    c = (char) (rand() % 4);
    switch (c) {
      case 0:
        val += 0x0f;
        break;
      case 1:
        val += 0xf00;
        break;
      case 2:
        val += 0xf0000;
        break;
      case 3:
        val += 0xf000000;
        break;
    }  
    matrix_put(x,y, val);
  }
}
