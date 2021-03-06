#ifndef _MISC_H
#define _MISC_H

#include <machine.h>

extern volatile unsigned int * const sysctrl;
extern volatile unsigned int * const sysio;

// helpers
#define SET_BIT(x,b) x |= (1 << (b))
#define CLEAR_BIT(x,b) x &= ~(1 << (b))

// misc functions
extern void delay(unsigned int limit);
extern unsigned int getstack(void);

// conversion stuff
extern char nibble2hex(char n);
extern char *byte2hex(char b);
extern char *short2hex(short s);
extern char *int2hex(int v);
extern int hextoi(char s);
extern char *itos(unsigned int val, char *s);

#endif
