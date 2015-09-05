int gi1, gi2;
char gs[] = "hello";

char bar(char c) {
  return c+'0';
}

int foo(int a) {
  int b;
  b=6;
  return bar('a');
}

void main(void) {
  char ls[] = "bargle";
  char a;
  a = ls[0];
  a = ls[1];
  a = ls[2];
  a = ls[3];
  a = ls[4];
}
