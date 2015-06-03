int gi1, gi2;

char bar(char c) {
  return c+'0';
}

int foo(int a) {
  int b;
  b=6;
  return bar('a');
}

void main(void) {
  gi1 = foo(4);
}
