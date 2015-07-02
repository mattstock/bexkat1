unsigned *mem = (unsigned *)0x00004000;

void main(void) {
  int i,f;

  for (i=0; i < 32; i++)
    mem[i] = i;
  for (i=0; i < 32; i++)
    f = mem[i];
  while (1);
}
