int n(int j) {
  return j * 34 + 17;
}

int a(int x, int y, int z, int b, int c, int d, int e, int f) {
/*  unsigned int h = 32;
  char few[400];
  few[x%400] = '0'; */
  return n(f) + x + y + z + b + c + d + e;
}

void main(void) {
  a(0,1,2,3,4,5,6,7); 
  while (1);
}
