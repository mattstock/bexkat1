#include "ff.h"
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>
#include <stdio.h>
#include <errno.h>

char buf[] = "this is a test.\n";

void main(void) {
  int fd;
  FATFS f;
  FRESULT foo;

  iprintf("trying mount\n");
  if (f_mount(&f, "", 1) != FR_OK)
    iprintf("f_mount failed\n");
  else {
    iprintf("f_mount success\n");
    f_mount((void *)0, "", 0);
  }

  fd = open("/testnew.txt", O_CREAT|O_WRONLY);
  if (fd != 4)
    iprintf("I got %d as a file descriptor and errno is %d\n", fd, errno);
  write(fd, buf, strlen(buf));
  close(fd);
  while (1);
}
