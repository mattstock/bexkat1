static const char hello[] = "hello world";
int si;

unsigned short *ioptr = (void *)0xff40100;

void foo(void) {
  for (si=0; si < 200; si++) {
    *ioptr = 0xff0f;
    ioptr++;
  }
}
