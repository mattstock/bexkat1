#include "misc.h"

volatile unsigned int * const sysctrl = (unsigned int *)0x30000000;
volatile unsigned int * const sysio = (unsigned int *)0x30001000;

char nibble2hex(char n) {
  char x = (n & 0xf);
  static const char hex[] = "0123456789abcdef";
  if (x >= 0 || x <= 15)
    return hex[n & 0xf];
  else
    return 'n';
}

char *byte2hex(char b) {
  static char buf[3];
  buf[0] = nibble2hex(b >> 4);
  buf[1] = nibble2hex(b);
  buf[2] = '\0';
  return buf;
}

char *short2hex(short s) {
  static char buf[5];
  unsigned short i;

  for (i=0; i < 4; i++)
    buf[i] = nibble2hex(s >> (12 - i*4));
  buf[4] = '\0';
  return buf;
}

char *int2hex(int v) {
  static char buf[9];
  unsigned short i;
  
  for (i=0; i < 8; i++)
    buf[i] = nibble2hex(v >> (28 - i*4));
  buf[8] = '\0';
  return buf;
}

char *itos(unsigned int val, char *s) {
  unsigned int c;

  c = val % 10;
  val /= 10;
  if (val)
    s = itos(val, s);
  *s++ = (c+'0');
  return s;
}

int hextoi(char s) {
  if (s >= '0' && s <= '9')
    return s-'0';
  if (s >= 'a' && s <= 'f')
    return s+10-'a';
  if (s >= 'A' && s <= 'F')
    return s+10-'A';
  return -1;
}

void delay(unsigned int limit) {
  unsigned i;
  for (i=0; i < limit; i++);
}
