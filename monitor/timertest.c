#include "serial.h"
#include "kernel/include/vectors.h"
#include "timers.h"
#include "misc.h"
#include "matrix.h"

INTERRUPT_HANDLER(timer0)
static void timer0(void) {
  timers[4] = timers[12] + 0x8000;
  timers[1] = 0x1;
  serial_putchar(0, 'b');
  matrix_put(0,0,0xff);
}

void main() {
  timers[4] = timers[12] + 0x8000;
  set_interrupt_handler(intr_timer0, timer0);
  timers[0] |= 0x11;
  sti();

  while (1) {
    serial_putchar(0, 'a');
    delay(10000);
  }
}
