#include "vectors.h"

extern void *_start(void);

static void dummy(void) {
  asm("halt");
}

vector_t _vectors_start[] __attribute__ ((aligned (4))) = {
			     {JMPD, (void *)_start}, /* reset */
			     {JMPD, dummy}, /* mmu fault */
			     {JMPD, dummy}, /* timer0 */
			     {JMPD, dummy}, /* timer1 */
			     {JMPD, dummy}, /* timer2 */
			     {JMPD, dummy}, /* timer3 */
			     {JMPD, dummy}, /* uart0 rx */
			     {JMPD, dummy}, /* uart0 tx */
			     {JMPD, dummy}, /* illegal instruction */
			     {JMPD, dummy}, /* cpu1 */
			     {JMPD, dummy}, /* cpu2 */
			     {JMPD, dummy}, /* cpu3 */
			     {JMPD, dummy}, /* trap 0 */
			     {JMPD, dummy}, /* trap 1 */
			     {JMPD, dummy}, /* trap 2 */
			     {JMPD, dummy} /* trap 3 */
};

void set_interrupt_handler(interrupt_slot s, isr f) {
  _vectors_start[s].vect = f;
}

void set_exception_handler(interrupt_slot s, esr f) {
  _vectors_start[s].vect = (isr)f;
}
