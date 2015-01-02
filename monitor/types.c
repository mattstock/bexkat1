extern unsigned _etext;
extern unsigned _data;
extern unsigned _edata;
unsigned gui1;
int gi1;
unsigned short gus1;
short gs2;
char gc1;
unsigned char guc1;

void main(void);

// for now, the first function in the object is the one that gets run
// figure this out so we don't feel stupid
void _start(void) {
  unsigned *src = &_etext;
  unsigned *dst = &_data;

  while (dst < &_edata) {
    *dst++ = *src++;
  }
  main();
}

void main(void) {
  unsigned ui1;
  int i1;
  unsigned short us1;
  short s1;
  char c1;
  unsigned char uc1;

  gc1 = (char)-4;
  guc1 = 'a';
  s1 = -1024;
  gus1 = 1024;
  gui1 = 0x00010000;
  ui1 = gui1;
  gi1 = -2;
  gui1 = gi1;
  
}
