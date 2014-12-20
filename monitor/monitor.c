int si;
unsigned *matrixptr;
unsigned *rgbptr;

void foo(void) {
  while (1) {
    rgbptr = (void *)0xff400004;
    matrixptr = (void *)0xff410000;
    for (si=0; si < 512; si++) {
      if (*rgbptr < 4)
        *matrixptr = 0x40106000;
      else
	*matrixptr = 0x00500000;
      matrixptr++;
    }
    rgbptr = (void *)0xff400000;
    *rgbptr = 0x40106000;
  }
}
