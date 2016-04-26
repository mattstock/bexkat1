#include <setjmp.h>
#include <stdio.h>



void main(void) {
  jmp_buf ex_buf;

  if (!setjmp(ex_buf)) {
    iprintf("set with some success\n");
    longjmp(ex_buf,200);
    iprintf("this should be dead code\n");
  } else {
    iprintf("longjmp() worked\n");
  }

  while (1);
}
