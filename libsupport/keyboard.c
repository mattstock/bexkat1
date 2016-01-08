#include "keyboard.h"

unsigned int *keyboard = (unsigned int *)0x30004000;

unsigned int keyboard_count(void) {
  return keyboard[KEYBOARD_SIZE];
}

unsigned int keyboard_getevent(void) {
  return keyboard[KEYBOARD_VALUE];
}
