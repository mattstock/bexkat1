typedef void (*isr)(void);

extern isr *_vectors_start;

/*
const isr _vectors_start[2] = {
  (void *)0x44444444,
  (void *)0x55555555
};
*/

void main(void) {
  isr rst = _vectors_start[0];
  isr zero = _vectors_start[1];

  rst();
  zero();
}
