volatile unsigned char * const hex = (unsigned char *)(0x30000000);

unsigned fib(unsigned short x);

unsigned fib(unsigned short x) {
  if (x == 0)
    return 0;
  if (x == 1)
    return 1;
  return fib(x-1) + fib(x-2);
}

void hexprint(unsigned val) {
  for (int i=0; i < 6; i++)
    hex[i] = (char)i;
}

void main(void) {
  for (int i=0; i < 6; i++)
    hex[i] = (char)i;
  asm("halt");
}
