unsigned i;
unsigned *matrixptr = (void *)0xff410000;
unsigned *rgbptr;
unsigned *swptr = (void *)0xff400040;

void foo(void) {
  while (1) {
    rgbptr = (void *)0xff400004;
    for (i=0; i < 512; i++) {
      if (*rgbptr < *swptr)
        matrixptr[i] = 0x40106000 + (*rgbptr << 9);
      else
	matrixptr[i] = 0x00500000 + (*rgbptr << 12);
    }
    rgbptr = (void *)0xff400000;
    *rgbptr = 0x40106000;
  }
}
