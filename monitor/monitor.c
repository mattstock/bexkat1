#include "monitor.h"

extern unsigned _etext;
extern unsigned _data;
extern unsigned _edata;

unsigned short page;
unsigned short addr;
unsigned short data;

void serial_putbin(unsigned short port,
		   char *list,
		   unsigned short len);
void serial_putchar(unsigned short, char);
short serial_getline(unsigned short port,
		     char *str, 
		     unsigned short *len);
void serial_printhex(unsigned short port, unsigned val);
char serial_getchar(unsigned short);
void serial_print(unsigned short, char *);
void matrix_init(void);
void matrix_put(unsigned, unsigned, unsigned);

void delay(unsigned int limit);
void main(void);
int hextoi(char *s);
char *itos(unsigned int val, char *s);
unsigned char random(unsigned int);

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

char serial_getchar(unsigned short port) {
  unsigned short result;
  volatile unsigned short *p;

  switch (port) {
  case 0:
    p = serial0;
    break;
  case 1:
    p = serial1;
    break;
  case 2:
    p = serial2;
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
  
int hextoi(char *s) {
  int val = 0;

  while (*s != '\0') {
    if (*s >= '0' && *s <= '9') {
      val = val << 4;
      val += (*s-'0');
    }
    if (*s >= 'a' && *s <= 'f') {
      val = val << 4;
      val += (*s+10-'a');
    }
    if (*s >= 'A' && *s <= 'F') {
      val = val << 4;
      val += (*s+10-'A');
    }
    s++;
  }
  return val;
}

void serial_putchar(unsigned short port, char c) {
  volatile unsigned short *p;

  switch (port) {
  case 0:
    p = serial0;
    break;
  case 1:
    p = serial1;
    break;
  case 2:
    p = serial2;
    break;
  default:
    p = serial0;
  }

  while (!(p[0] & 0x4000));
  p[0] = (unsigned short)c;
}

void serial_printhex(unsigned short port, unsigned val) {
  unsigned short i;
  unsigned char c;

  for (i=0; i < 8; i++) {
    c = (val & 0xf0000000) >> 28;
    val = val << 4;
    if (c > 9)
      c += 'a'-10;
    else
      c += '0';
    serial_putchar(port, c);
  }
}


void serial_print(unsigned short port, char *str) {
  char *c = str;

  while (*c != '\0') {
    serial_putchar(port, *c);
    c++;
  }
}

short serial_getline(unsigned short port,
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

char helpmsg[] = "\n? = help\np hhhh = set high address page\nr llll xx = read xx bytes of page hhhh llll and display\nw llll xx = write byte xx to location hhhh llll\ns = s-record upload\n\n";

void serial_dumpmem(unsigned short port,
		    unsigned addr, 
		    unsigned short len) {
  short i;
  unsigned *pos = (unsigned *)addr;
  
  serial_print(port, "\n");
  for (i=0; i < len; i += 4) {
    serial_printhex(port, addr+8*i);
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
  short *val;

  page = 0x0100;
  addr = 0xa000;
  while (1) {
    serial_print(0, "\nBexkat1 [");
    serial_printhex(0, (page << 16) | addr);
    serial_print(0, "] > ");
    msg = buf;
    serial_getline(0, msg, &size);
    switch (msg[0]) {
    case '?':
      serial_print(0, helpmsg);
      break;
    case 'p':
      msg++;
      page = hextoi(msg);
      break;
    case 'a':
      msg++;
      addr = hextoi(msg);
      break;
    case 'r':
      serial_dumpmem(0, (page << 16) | addr, 32);
      break;
    case 'w':
      msg++;
      val = (short *)((page << 16) | addr);
      *val = hextoi(msg);
      serial_print(0, "\n");
      break;
    default:
      serial_print(0, "\nunknown commmand: ");
      serial_print(0, msg);
      serial_print(0, buf);
    }
  }
}
