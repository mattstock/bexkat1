extern unsigned _etext;
extern unsigned _data;
extern unsigned _edata;
unsigned *swptr = (void *)0xff400040;
unsigned *matrixptr = (void *)0xff410000;
unsigned *rgbptr = (void *)0xff400000;

void main(void);
void draw(unsigned, unsigned, unsigned, unsigned);

// for now, the first function in the object is the one that gets run
// figure this out so we don't feel stupid
void _start(void) {
  unsigned *src = &_etext;
  unsigned *dst = &_data;

  while (dst < &_edata) {
    *dst++ = *src++;
  }
  main();
}

void draw(unsigned x, unsigned y, unsigned val, unsigned exp) {
    matrixptr[y*32+x] = (val == exp ? 0x00ff0000 : 0xff000000);
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
    if (swptr[0] == 1) { // <
      v1 = 13;
      v2 = 15;
      s1 = -5;
      s2 = -4;
      a1 = 0;
      a2 = 1;
      a3 = 0;
    }
    if (swptr[0] == 2) { // < pos
      v1 = 0;
      v2 = 15;
      s1 = 5;
      s2 = 14;
      a1 = 0;
      a2 = 1;
      a3 = 0;
    }
    if (swptr[0] == 3) { // > pos
      v1 = 10;
      v2 = 1;
      s1 = 5;
      s2 = 4;
      a1 = 0;
      a2 = 0;
      a3 = 1;
    }
    if (swptr[0] == 4) { // > neg
      v1 = 1;
      v2 = 0;
      s1 = -5;
      s2 = -14;
      a1 = 0;
      a2 = 0;
      a3 = 1;
    }
    if (swptr[0] == 5) { // > split
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
