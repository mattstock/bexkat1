unsigned i;
unsigned *matrixptr;
unsigned *rgbptr;

void foo(void) {
  while (1) {
    rgbptr = (void *)0xff400004;
    matrixptr = (void *)0xff410000;
    for (i=0; i < 512; i++) {
      if (*rgbptr < 4)
        matrixptr[i] = 0x40106000 + (*rgbptr << 9);
      else
	matrixptr[i] = 0x00500000 + (*rgbptr << 12);
    }
    rgbptr = (void *)0xff400000;
    *rgbptr = 0x40106000;
  }
}
