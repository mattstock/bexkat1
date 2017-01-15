#ifndef TIMERS_H
#define TIMERS_H

#include <machine.h>

/* register defines */
#define TIMER_CONTROL 0
#define TIMER_STATUS 1
#define TIMER_COMPARE0 4
#define TIMER_COMPARE1 5
#define TIMER_COMPARE2 6
#define TIMER_COMPARE3 7
#define TIMER_COUNTER0 8
#define TIMER_COUNTER1 9
#define TIMER_COUNTER2 10
#define TIMER_COUNTER3 11
#define TIMER_FREE 12

extern volatile unsigned int * const timers;

extern unsigned int timers_ticks();

#endif
