#include "misc.h"
#include "matrix.h"
#include "serial.h"

void matrix_fade(void);

void main(void);

void matrix_fade(void) {
  unsigned short i;
  unsigned a,b;
  unsigned subber;
  for (i=0; i < 16*32; i++) {
    subber=0;
    a = matrix[i];
    b = a & 0xff0000;
    if (b >= 0x70000)
      subber += 0x70000;
    else
      subber += b;
    b = a & 0xff00;
    if (b >= 0x700)
      subber += 0x700;
    else
      subber += b;
    b = a & 0xff;
    if (b >= 0x7)
      subber += 0x7;
    else
      subber += b;
    matrix[i] -= subber; 
  }
}

char katherine[] = { 194, 132, 190, 148, 129, 141 }; 
char rebecca[] = { 148, 131, 172, 131, 196, 131 };

void main(void) {
  char c;
  unsigned val;
  unsigned short x, y;

  x = 16;
  y = 8;
  val = 0x00808080;
//  serial_putbin(1, katherine, 6);
//  delay(0x15000);
//  serial_putbin(1, rebecca, 6);
  while (1) {
    matrix_fade();
    c = random(2010);
    switch (c % 4) {
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
    c = random(2000);
    switch (c % 4) {
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
    delay(0x4000);
  }
}
