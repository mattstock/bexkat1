extern unsigned _etext;
extern unsigned _data;
extern unsigned _edata;
unsigned *matrix = (unsigned *)0xff410000;
volatile unsigned *encoder = (unsigned *)0xff400000;
volatile unsigned short *serial0 = (unsigned short *)0xff400010;
volatile unsigned short *serial1 = (unsigned short *)0xff400020;
volatile unsigned short *kbd = (unsigned short *)0xff400030;
volatile unsigned short *sw = (unsigned short *)0xff400040;
volatile unsigned short *serial2 = (unsigned short *)0xff400050;

char rxchar(void);
void delay(void);
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

void delay() {
  unsigned i;
  for (i=0; i < 0x10000; i++);
}

char rxchar(void) {
  unsigned foo;

  foo  = serial0[0];
  while (!(foo & 0x8000)) {
    foo = serial0[0];
    matrix[4] = 0xff000000;
  }
  matrix[5] = 0x00ff0000;
  return (char)(foo & 0xff); 
}
  
void txchar(char c) {
  serial0[0] = (unsigned short)c;
  matrix[1] = 0x0000ff00;
  while (!(serial0[0] & 0x4000)) {
    matrix[2] = 0x0000ff00;
  };
  matrix[3] = 0x0000ff00;
}

void main(void) {
  unsigned i;
  char c;

  for (i=0; i < 10; i++)
    matrix[i] = 0x00000000;
  matrix[0] = 0x0000ff00;
  txchar('b');
  txchar('e');
  txchar('x');
  txchar('k');
  txchar('a');
  txchar('t');
  txchar('\n');
  txchar('\r');
  while (1) {
    c = rxchar();
    txchar(':');
    txchar(c);
  }
}
