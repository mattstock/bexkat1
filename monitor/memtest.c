unsigned int b;
unsigned int r = 0x100;
unsigned int b2;

void foo(void) {
  b++;
  r++;
  b2 = r + b;
}
