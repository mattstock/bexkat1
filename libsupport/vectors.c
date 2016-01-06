#include "vectors.h"

static void dummy(void) {
  while (1);
}

isr _vectors_start[16] = {
  (void *)0x70000000, /* reset */
  dummy, /* mmu fault */
  dummy, /* timer0 */
  dummy, /* timer1 */
  dummy, /* timer2 */
  dummy, /* timer3 */
  dummy, /* uart0 rx */
  dummy, /* uart0 tx */
  dummy, /* trap 0 */
  dummy, /* trap 1 */
  dummy, /* trap 2 */
  dummy, /* trap 3 */
  dummy, /* trap 4 */
  dummy, /* trap 5 */
  dummy, /* trap 6 */
  dummy  /* trap 7 */
};

void set_interrupt_handler(interrupt_slot s, isr f) {
  _vectors_start[s] = f;
}
