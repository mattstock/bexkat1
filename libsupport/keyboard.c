#include "keyboard.h"

volatile unsigned int * const keyboard = (unsigned int *)PS2_BASE;

unsigned int keyboard_count(void) {
  return keyboard[KEYBOARD_SIZE];
}

unsigned int keyboard_getevent(void) {
  return keyboard[KEYBOARD_VALUE];
}
