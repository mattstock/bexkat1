#ifndef _SERIAL_H
#define _SERIAL_H

extern volatile unsigned int * const serial0;
extern volatile unsigned int * const serial1;

extern void serial_printf(unsigned port, const char *format, ...);
extern void serial_putbin(unsigned port,
		   char *list,
		   unsigned short len);
extern void serial_putchar(unsigned port, char);
extern short serial_getline(unsigned port,
		     char *str, 
		     unsigned short *len);
extern void serial_printhex(unsigned port, unsigned val);
extern char serial_getchar(unsigned port);
extern void serial_print(unsigned port, const char *);
extern void serial_dumpmem(unsigned port,
			   unsigned addr,
			   unsigned short len);

#endif
