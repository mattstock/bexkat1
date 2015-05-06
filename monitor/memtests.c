unsigned *swptr = (unsigned *)0xff400040;
unsigned *rgbptr = (unsigned *)0xff400000;

void main(void) {
  while (1) {
    rgbptr[0] = (swptr[0] << 24);
  }
}
