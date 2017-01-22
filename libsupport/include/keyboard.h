#ifndef KEYBOARD_H
#define KEYBOARD_H

#include <machine.h>

extern volatile unsigned int * const keyboard;

#define KEYBOARD_SIZE 1
#define KEYBOARD_VALUE 0

extern unsigned int keyboard_count(void);
extern unsigned int keyboard_getevent(void);
extern unsigned char keyboard_getchar(void);

#endif
