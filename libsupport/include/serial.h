#ifndef _SERIAL_H
#define _SERIAL_H

#include <stdarg.h>
#include <machine.h>
#include "console.h"

extern volatile unsigned int * const serial0;
extern volatile unsigned int * const serial1;
extern volatile unsigned int * const serial2;

extern void serial_printf(unsigned port, const char *format, ...);
extern void serial_putbin(unsigned port,
		   char *list,
		   unsigned short len);
extern void serial_putchar(unsigned port, char);
extern short serial_getline(unsigned port,
		     char *str, 
		     unsigned short *len);
extern void serial_ansi_sgr(unsigned port, console_color_t color);
extern void serial_printhex(unsigned port, unsigned val);
extern char serial_gc(unsigned port);
extern char serial_getchar(unsigned port);
extern void serial_print(unsigned port, const char *);
extern void serial_printf(unsigned port, const char *fmt, ...);
extern void serial_vprintf(unsigned port, const char *fmt, va_list argp);

#endif
