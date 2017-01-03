#include "vectors.h"

static void dummy(void) {
  asm("halt");
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
  dummy, /* illegal instruction */
  dummy, /* cpu1 */
  dummy, /* cpu2 */
  dummy, /* cpu3 */
  dummy, /* trap 0 */
  dummy, /* trap 1 */
  dummy, /* trap 2 */
  dummy /* trap 3 */
};

void set_interrupt_handler(interrupt_slot s, isr f) {
  _vectors_start[s] = f;
}

void set_exception_handler(interrupt_slot s, esr f) {
  _vectors_start[s] = (isr)f;
}
