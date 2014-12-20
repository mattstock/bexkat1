int si;
unsigned *ioptr;

void foo(void) {
  ioptr = (void *)0xff410000;
  for (si=0; si < 512; si++) {
    *ioptr = 0x40106000;
    ioptr++;
  }
  ioptr = (void *)0xff400000;
  *ioptr = 0x40106000;
}
