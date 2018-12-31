#ifndef VECTORS_H
#define VECTORS_H

typedef void (*isr)(void);
typedef int (*esr)(void);

#define INTERRUPT_HANDLER(x) static void x() __attribute__ ((interrupt_handler));
#define EXCEPTION_HANDLER(x) static int x() __attribute__ ((exception_handler));
#define sti() asm("sti")
#define cli() asm("cli")

#define JMPD (0xc0000001)
typedef struct {
  unsigned int jmp;
  isr vect;
} vector_t;

typedef enum {
  intr_reset,
  intr_mmu,
  intr_timer0,
  intr_timer1,
  intr_timer2,
  intr_timer3,
  intr_rx_uart0,
  intr_tx_uart0,
  intr_illop,
  intr_cpu1,
  intr_cpu2,
  intr_cpu3,
  intr_trap0,
  intr_trap1,
  intr_trap2,
  intr_trap3,
} interrupt_slot;

extern void set_interrupt_handler(interrupt_slot s, isr f);
extern void set_exception_handler(interrupt_slot s, esr f);

#endif

