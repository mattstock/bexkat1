#include "monitor.h"

extern unsigned _etext;
extern unsigned _data;
extern unsigned _edata;

unsigned int addr;
unsigned short data;

// Serial IO stuff
void serial_putbin(unsigned port,
		   char *list,
		   unsigned short len);
void serial_putchar(unsigned port, char);
short serial_getline(unsigned port,
		     char *str, 
		     unsigned short *len);
void serial_printhex(unsigned port, unsigned val);
char serial_getchar(unsigned port);
void serial_print(unsigned port, char *);
void serial_srec(unsigned port);

// LED matrix stuff
void matrix_init(void);
void matrix_put(unsigned, unsigned, unsigned);

// misc functions
void delay(unsigned int limit);
unsigned char random(unsigned int);
static char *int2hex(int v);

// conversion stuff
static char nibble2hex(char n);
static char *byte2hex(char b);
static char *short2hex(short s);
static char *int2hex(int v);
int hextoi(char s);

void main(void);

// for now, the first function in the object is the one that gets run
// we mark the entry point in the object code, but we need a program loader
// to use it
void _start(void) {
  unsigned *src = &_etext;
  unsigned *dst = &_data;

  while (dst < &_edata) {
    *dst++ = *src++;
  }
  main();
}

char helpmsg[] = "\n? = help\np hhhh = set high address page\nr llll xx = read xx bytes of page hhhh llll and display\nw llll xx = write byte xx to location hhhh llll\ns = s-record upload\n\n";

unsigned char random(unsigned int r_base) {
  static unsigned char y;
  static unsigned int r;

  if (r == 0 || r == 1 || r == -1)
    r = r_base;
  r = (9973 * ~r) + (y % 701);
  y = (r >> 24);
  return y;
}

void delay(unsigned int limit) {
  unsigned i;
  for (i=0; i < limit; i++);
}

char serial_getchar(unsigned port) {
  unsigned result;
  volatile unsigned *p;

  switch (port) {
  case 0:
    p = serial0;
    break;
  case 1:
    p = serial1;
    break;
  default:
    p = serial0;
  }

  result  = p[0];
  while ((result & 0x8000) == 0)
    result = p[0];
  return (char)(result & 0xff); 
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

void serial_srec(unsigned port) {
  unsigned short done = 0;
  char c;
  unsigned char len;
  char type;
  unsigned char sum;
  char *s;

  while (!done && (serial_getchar(port) == 'S')) {
    type = serial_getchar(port);
    //    switch (type) {
    // case '0':
      len = hextoi(serial_getchar(port));
      len = (len << 4) + hextoi(serial_getchar(port));
      sum = len;
      while (len != 0) {
	c = hextoi(serial_getchar(port));
	c = (c << 4) + hextoi(serial_getchar(port));
	sum += c;
	serial_printhex(port, sum);
	serial_putchar(port, '\n');
	len--;
      }
      if (sum != 0xff) {
	done = 1;
	serial_print(0, "checksum fail!?\n");
      }
      /* break;
    case '1':
      len = hextoi(serial_getchar(port));
      len = (len << 4) + hextoi(serial_getchar(port));
      sum = 0;
      break;
    case '2':
      len = hextoi(serial_getchar(port));
      len = (len << 4) + hextoi(serial_getchar(port));
      sum = 0;
      break;
    case '3':
      len = hextoi(serial_getchar(port));
      len = (len << 4) + hextoi(serial_getchar(port));
      sum = 0;
      break;
    case '9':
      done = 1;
      break;
    case '8':
      done = 1;
      break;
    case '7':
      done = 1;
      break;
      }*/
  }
}

void serial_putchar(unsigned port, char c) {
  volatile unsigned *p;

  switch (port) {
  case 0:
    p = serial0;
    break;
  case 1:
    p = serial1;
    break;
  default:
    p = serial0;
  }

  while (!(p[0] & 0x2000));
  p[0] = (unsigned)c;
}

static char nibble2hex(char n) {
  char x = (n & 0xf);
  static const char hex[] = "0123456789abcdef";
  if (x >= 0 || x <= 15)
    return hex[n & 0xf];
  else
    return 'n';
}

static char *byte2hex(char b) {
  static char buf[3];
  buf[0] = nibble2hex(b >> 4);
  buf[1] = nibble2hex(b);
  buf[2] = '\0';
  return buf;
}

static char *short2hex(short s) {
  static char buf[5];
  unsigned short i;

  for (i=0; i < 4; i++)
    buf[i] = nibble2hex(s >> (12 - i*4));
  buf[4] = '\0';
  return buf;
}

static char *int2hex(int v) {
  static char buf[9];
  unsigned short i;
  
  for (i=0; i < 8; i++)
    buf[i] = nibble2hex(v >> (28 - i*4));
  buf[8] = '\0';
  return buf;
}  

void serial_printhex(unsigned port, unsigned val) {
  char *x = int2hex(val);
  serial_print(port, x);
}

void serial_print(unsigned port, char *str) {
  char *c = str;

  while (*c != '\0') {
    serial_putchar(port, *c);
    c++;
  }
}

short serial_getline(unsigned port,
		     char *str, 
		     unsigned short *len) {
  unsigned short i=0;
  char c;

  while (1) {
    c = serial_getchar(port);
    if (c >= ' ' && c <= '~') {
      serial_putchar(port, c);
      str[i++] = c;
    }
    if (c == '\r' || c == '\n') {
      str[i] = '\0';
      return i;
    }
    if (c == 0x03) {
      str[0] = '\0';
      return -1;
    }
    if ((c == 0x7f || c == 0x08) && i > 0) {
      serial_putchar(port, c);
      i--;
    }
  }
  return 0;
}	

void matrix_put(unsigned x, unsigned y, unsigned val) {
  if (y > 15 || x > 31)
    return;
  matrix[y*32+x] = val;
}

void serial_dumpmem(unsigned port,
		    unsigned addr, 
		    unsigned short len) {
  short i;
  unsigned *pos = (unsigned *)addr;
  
  serial_print(port, "\n");
  for (i=0; i < len; i += 4) {
    serial_printhex(port, addr+4*i);
    serial_print(port, ": ");
    serial_printhex(port, pos[i]);
    serial_print(port, " ");
    serial_printhex(port, pos[i+1]);
    serial_print(port, " ");
    serial_printhex(port, pos[i+2]);
    serial_print(port, " ");
    serial_printhex(port, pos[i+3]);
    serial_print(port, "\n");
  }
}

void main(void) {
  unsigned short size=20;
  char buf[20];
  char *msg;
  short val;
  short *ref;

  addr = 0xff100000;
  while (1) {
    serial_print(0, "\nBexkat1 [");
    serial_printhex(0, addr);
    serial_print(0, "] > ");
    msg = buf;
    serial_getline(0, msg, &size);
    switch (msg[0]) {
    case '?':
      serial_print(0, helpmsg);
      break;
    case 'a':
      msg++;
      while (*msg != '\0') {
	addr = (addr << 4) + hextoi(*msg);
	msg++;
      }
      break;
    case 's':
      serial_print(0, "\nstart srec upload...\n");
      serial_srec(0);
      break;
    case 'r':
      serial_dumpmem(0, addr, 32);
      break;
    case 'w':
      msg++;
      while (*msg != '\0') {
	val = (val << 4) + hextoi(*msg);
	msg++;
      }
      ref = (short *)addr;
      *ref = val;
      serial_print(0, "\n");
      break;
    default:
      serial_print(0, "\nunknown commmand: ");
      serial_print(0, msg);
      serial_print(0, buf);
    }
  }
}
