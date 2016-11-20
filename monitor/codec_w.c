#include <stdio.h>
#include <unistd.h>
#include <i2c.h>
#include <matrix.h>
#include <serial.h>

void codec_init() {
  i2c_addr(0b11011);
  i2c_regwrite(0x6, 0x22);
  i2c_regwrite(0x0, 0x17);
  i2c_regwrite(0x1, 0x17);
  i2c_regwrite(0x4, 0x12);
  i2c_regwrite(0x5, 0x00);
  i2c_regwrite(0x7, 0x4b);
  i2c_regwrite(0x8, 0x1c);
  usleep(30000);
  i2c_regwrite(0x9, 0x01);
  i2c_regwrite(0x6, 0x02);
} 

void main() {
  codec_init();
}
  
void codec_debug() {
  unsigned char cmd[10];
  unsigned short size = 10;
  unsigned char *p;
  unsigned char reg, val;
  
  serial_print(0,"Codec start\n");
  while (1) {
    serial_print(0,"codec command: ");
    p = cmd;
    serial_getline(0, p, &size);
    serial_print(0,"\n");
    if (p[0] == 'r') {
      for (int i=0; i < 0x0a; i++) { 
        serial_print(0, "reg ");
        serial_printhex(0, i);
        serial_print(0, ": ");
        serial_printhex(0, i2c_regread(i<<1));
        serial_print(0, "\n");
      }
    }
    if (cmd[0] == 'w') {
      reg = val = 0;
      while (*p != ',' && *p != '\0') {
        reg = (reg << 4) + hextoi(*p);
        p++;
      }
      if (*p == ',') {
        p++;
        while (*p != ',' && *p != '\0') {
          val = (val << 4) + hextoi(*p);
          p++;
        }
        i2c_regwrite(reg<<1, val);
      } else
        serial_print(0,"\nformat: w<reg>,<val>\n");
    }
  }
}
