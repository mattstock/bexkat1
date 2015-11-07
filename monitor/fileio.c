#include "misc.h"
#include "matrix.h"
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

  fd = open("/testnew.txt", O_CREAT|O_WRONLY);
  if (fd != 4)
    iprintf("I got %d as a file descriptor and errno is %d\n", fd, errno);
  matrix[0] = 0xff;
  write(fd, buf, strlen(buf));
  matrix[1] = 0xff;
  close(fd);
  matrix[2] = 0xff;
  while (1);
}
