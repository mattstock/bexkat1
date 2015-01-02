extern unsigned _etext;
extern unsigned _data;
extern unsigned _edata;
unsigned *swptr = (void *)0xff400040;
unsigned *matrixptr = (void *)0xff410000;
unsigned *rgbptr = (void *)0xff400000;

void foo(unsigned);
void delay(void);
void main(void);

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

void delay() {
  unsigned i;
  for (i=0; i < 0x100000; i++);
}

void foo(unsigned a) {
  matrixptr[1] = a;
}

void main(void) {
  matrixptr[0] = 0x0000ff00;
  matrixptr[1] = 0x00000000;
  matrixptr[2] = 0x00000000;
  while (1) {
    delay();
    foo(swptr[0] << 16);
    delay();
    matrixptr[2] = 0xff000000;
  } 
}
