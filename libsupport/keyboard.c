#include "keyboard.h"

volatile unsigned int * const keyboard = (unsigned int *)PS2_BASE;

unsigned int keyboard_count(void) {
  return keyboard[KEYBOARD_SIZE];
}

unsigned int keyboard_getevent(void) {
  return keyboard[KEYBOARD_VALUE];
}

// blocks waiting for a single character
unsigned char keyboard_getchar(void) {
  unsigned char result = 0;

  return result;
  
}
