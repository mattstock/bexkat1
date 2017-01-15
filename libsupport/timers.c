#include "timers.h"

volatile unsigned int * const timers = (unsigned int *)TIMER_BASE;

// return timer ticks scaled to roughly ms
// assumes a 100MHz clock.
unsigned int timers_ticks() {
  return timers[TIMER_FREE]/100000;
}
