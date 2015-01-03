extern unsigned _etext;
extern unsigned _data;
extern unsigned _edata;
unsigned *swptr = (void *)0xff400040;
unsigned *matrixptr = (void *)0xff410000;
unsigned *rgbptr = (void *)0xff400000;

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

void main(void) {
  int a;
  unsigned b;
  matrixptr[0] = 0x0000ff00;
  while (1) {
    b = swptr[0] * 31;
    a = swptr[0] * -20;
    matrixptr[1] = a;
    matrixptr[2] = b;
  } 
}
