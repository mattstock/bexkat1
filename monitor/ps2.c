#include <stdio.h>
#include <keyboard.h>
#include "misc.h"

void main() {
  char c;
  int i;
  while (1) {
    if (keyboard_count() > 0)
      iprintf("code = %08x\n", keyboard_getevent());
  }
}
