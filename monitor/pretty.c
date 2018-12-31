#include <stdarg.h>
#include "misc.h"
#include "matrix.h"
#include "spi.h"
#include "serial.h"
#include <stdio.h>
#include <stdlib.h>

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
  unsigned val, pot;
  unsigned short x, y;
  unsigned tick = 0;

  x = 0;
  y = 0;
  val = 0x00808080;

  srand(39854);
  while (1) {
    tick++;
    sysio[0] = tick;
    if (sysio[1] & 0x4)
      matrix_fade();
    else 
      delay(1000);
    if (sysio[1] & 0x2) {
      switch (rand() % 4) {
      case 0:
        x = (x < 31 ? x+1 : 0);
        break;
      case 1:
	x = (x > 0 ? x-1 : 31);
        break;
      case 2:
	y = (y < 15 ? y+1 : 0);
        break;
      case 3:
	y = (y > 0 ? y-1 : 15);
        break;
      }
    } else {
      if ((tick % 10) == 0) {
        x++;
        if (x == 32) {
	  x = 0;
	  if (y == 15)
	    y = 0;
	  else
	    y++;
        }
      }
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
