#include "vectors.h"

static void dummy(void) {
  while (1);
}

isr _vectors_start[16] = {
  (void *)0xffff0000, /* reset */
  dummy, /* bus error */
  dummy, /* page fault */
  dummy, /* invalid opcode */
  dummy, /* write fault */
  dummy, /* halt */
  dummy, /* debug */
  dummy, /* interrupt */
  dummy, /* trap 0 */
  dummy, /* trap 1 */
  dummy, /* trap 2 */
  dummy, /* trap 3 */
  dummy, /* trap 4 */
  dummy, /* trap 5 */
  dummy, /* trap 6 */
  dummy  /* trap 7 */
};
