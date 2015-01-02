extern unsigned _etext;
extern unsigned _data;
extern unsigned _edata;
unsigned *swptr = (unsigned *)0xff400040;
unsigned *rgbptr = (unsigned *)0xff400000;

// for now, the first function in the object is the one that gets run
// figure this out so we don't feel stupid
void _start(void) {
  unsigned *src = &_etext;
  unsigned *dst = &_data;

  while (dst < &_edata) {
    *dst++ = *src++;
  }
  while (1) {
    rgbptr[0] = (swptr[0] << 24);
  }
}
