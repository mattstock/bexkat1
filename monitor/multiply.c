unsigned *swptr = (void *)0xff400040;
unsigned *matrixptr = (void *)0xff410000;
unsigned *rgbptr = (void *)0xff400000;

void main(void);

void main(void) {
  int a;
  unsigned b;
  matrixptr[0] = 0x0000ff00;
  while (1) {
    b = swptr[0] * 31;
    if (b == 31*7)
      matrixptr[1] = 0x00ff0000;
    else
      matrixptr[1] = 0xff000000;
    a = swptr[0] * -20;
    if (a == -140)
      matrixptr[2] = 0x00ff0000;
    else
      matrixptr[2] = 0xff000000;
    if ((a % 10) == 0) 
      matrixptr[3] = 0x00ff0000;
    else
      matrixptr[3] = 0xff000000;
    if ((b / 7) == 31) 
      matrixptr[4] = 0x00ff0000;
    else
      matrixptr[4] = 0xff000000;
  } 
}
