short ss;
const char mystr[] = "hello this is a longer string than usual.";
int si;
long sl;
unsigned short us;
unsigned int ui;
unsigned long ul;
char c;
static int ssi = 4578;

void foo(void);

void foo(void) {
  ui = 4056;
  if (si != 45) {
    c++;
    si = ssi;
  }
  for (si=0; si < 20; si++)
    ui += si;

fail:;

}
