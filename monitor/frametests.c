void foo(unsigned,unsigned);

void main(void) {
  foo((unsigned)0x11112222,(unsigned)0x33334444);
}

void foo(unsigned a, unsigned b) {
  unsigned c,d,e,f;

  c = a + b;
  d = a - b;
  e = a << b;
  f = 7;
}
