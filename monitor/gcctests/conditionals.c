#include "matrix.h"

volatile unsigned short *sw = (unsigned short *)0x00800810;

void draw(unsigned x, unsigned y, unsigned val, unsigned exp) {
    matrix[y*32+x] = (val == exp ? 0x000000ff : 0x0000ff00);
}

int foo(int x, int m) {
  int y;

  y = x;
  return m < 0 ? 1/y : y;
}

void main(void) {
  unsigned v1,v2, a1, a2, a3;
  int s1, s2;

  while (1) {
    v1 = 3;
    v2 = 3;
    s1 = -4;
    s2 = -4;
    a1 = 1;
    a2 = 0;
    a3 = 0;
    if (sw[0] == 1) { // <
      v1 = 13;
      v2 = 15;
      s1 = -5;
      s2 = -4;
      a1 = 0;
      a2 = 1;
      a3 = 0;
    }
    if (sw[0] == 2) { // < pos
      v1 = 0;
      v2 = 15;
      s1 = 5;
      s2 = 14;
      a1 = 0;
      a2 = 1;
      a3 = 0;
    }
    if (sw[0] == 3) { // > pos
      v1 = 10;
      v2 = 1;
      s1 = 5;
      s2 = 4;
      a1 = 0;
      a2 = 0;
      a3 = 1;
    }
    if (sw[0] == 4) { // > neg
      v1 = 1;
      v2 = 0;
      s1 = -5;
      s2 = -14;
      a1 = 0;
      a2 = 0;
      a3 = 1;
    }
    if (sw[0] == 5) { // > split
      v1 = 255;
      v2 = 254;
      s1 = 5;
      s2 = -1;
      a1 = 0;
      a2 = 0;
      a3 = 1;
    }
    draw(15,0,v1 <= v2, a2 || a1);
    draw(16,0,v1 == v2, a1);
    draw(17,0,v1 >= v2, a3|| a1);
    draw(15,1,v1 <  v2, a2);
    draw(16,1,v1 != v2, !a1);
    draw(17,1,v1 >  v2, a3);
    draw(15,2,s1 <= s2, a2||a1);
    draw(16,2,s1 == s2, a1);
    draw(17,2,s1 >= s2, a3||a1);
    draw(15,3,s1 <  s2, a2);
    draw(16,3,s1 != s2, !a1);
    draw(17,3,s1 > s2, a3); 
  } 
}
