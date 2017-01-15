#include "timers.h"

volatile unsigned int * const timers = (unsigned int *)TIMER_BASE;

unsigned int ticks() {
  return timers[TIMER_FREE];
}
