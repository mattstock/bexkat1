#ifndef KEYBOARD_H
#define KEYBOARD_H

unsigned int *keyboard;

#define KEYBOARD_SIZE 1
#define KEYBOARD_VALUE 0

extern unsigned int keyboard_count(void);
extern unsigned int keyboard_getevent(void);

#endif
