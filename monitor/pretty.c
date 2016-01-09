#include <stdarg.h>
#include "misc.h"
#include "matrix.h"
#include "spi.h"
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

unsigned int joystick() {
  unsigned char a0,a1;
  unsigned int ret;
#if 0
  spi_slow();
  CLEAR_BIT(SPI_CTL, JOY_SEL);
  a0 = spi_xfer(0x78);
  a1 = spi_xfer(0x00);
  SET_BIT(SPI_CTL, JOY_SEL);
  ret = (((a0 << 8) | a1) & 0x3ff) << 16;
  CLEAR_BIT(SPI_CTL, JOY_SEL);
  a0 = spi_xfer(0x68);
  a1 = spi_xfer(0x00);
  SET_BIT(SPI_CTL, JOY_SEL);
  ret |= ((a0 << 8) | a1) & 0x3ff;
  return ret;
#endif
  return 0;
}
 
void main(void) {
  char c;
  unsigned val, pot;
  unsigned short x, y;
  unsigned tick = 0;

  x = 16;
  y = 8;
  val = 0x00808080;

  srand(39854);
  while (1) {
    tick++;
    matrix_fade();
    if ((tick % 10) == 0) {
      pot = joystick();
      if (((pot & 0xffff) > 600) && (x < 31))
        x++;
      if (((pot & 0xffff) < 300) && (x > 0))
        x--;
      if (((pot >> 16) < 300) && (y < 15))
        y++;
      if (((pot >> 16) > 600) && (y > 0))
        y--;
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
