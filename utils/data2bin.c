#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>

const unsigned font88[] = {
  0x00000000, 0x00000000, //
  0x003e222a, 0x2a223e00, //
  0x003e222a, 0x2a223e00, //
  0x003e222a, 0x2a223e00, //
  0x003e222a, 0x2a223e00, //
  0x003e222a, 0x2a223e00, //
  0x003e222a, 0x2a223e00, //
  0x003e222a, 0x2a223e00, //
  0x003e222a, 0x2a223e00, //
  0x003e222a, 0x2a223e00, //
  0x003e222a, 0x2a223e00, //
  0x003e222a, 0x2a223e00, //
  0x003e222a, 0x2a223e00, //
  0x003e222a, 0x2a223e00, //
  0x003e222a, 0x2a223e00, //
  0x003e222a, 0x2a223e00, //
  0x003e222a, 0x2a223e00, //
  0x003e222a, 0x2a223e00, //
  0x003e222a, 0x2a223e00, //
  0x003e222a, 0x2a223e00, //
  0x003e222a, 0x2a223e00, //
  0x003e222a, 0x2a223e00, //
  0x003e222a, 0x2a223e00, //
  0x003e222a, 0x2a223e00, //
  0x003e222a, 0x2a223e00, //
  0x003e222a, 0x2a223e00, //
  0x003e222a, 0x2a223e00, //
  0x003e222a, 0x2a223e00, //
  0x003e222a, 0x2a223e00, //
  0x003e222a, 0x2a223e00, //
  0x003e222a, 0x2a223e00, //
  0x003e222a, 0x2a223e00, //
  0x00000000, 0x00000000, // space
  0x08080808, 0x08000800, // !
  0x14141400, 0x00000000, // "
  0x14143600, 0x36141400, // #
  0x081e201c, 0x023c0800, // $
  0x32320408, 0x10262600, // %
  0x10282810, 0x2a241a00, // &
  0x18181800, 0x00000000, // '
  0x08102020, 0x20100800, // (
  0x08040202, 0x02040800, // )
  0x00081c3e, 0x1c080000, // *
  0x0008083e, 0x08080000, // +
  0x00000030, 0x30102000, // ,
  0x0000003e, 0x00000000, // -
  0x00000000, 0x00303000, // .
  0x02020408, 0x10202000, // /
  0x18242424, 0x24241800, // 0
  0x08180808, 0x08081c00, // 1
  0x1c22021c, 0x20203e00, // 2
  0x1c22020c, 0x02221c00, // 3
  0x040c143e, 0x04040400, // 4
  0x3e203c02, 0x02221c00, // 5
  0x1c20203c, 0x22221c00, // 6
  0x3e020408, 0x10202000, // 7
  0x1c22221c, 0x22221c00, // 8
  0x1c22221e, 0x02021c00, // 9
  0x00181800, 0x18180000, // :
  0x18180018, 0x18081000, // ;
  0x04081020, 0x10080400, // <
  0x00003e00, 0x3e000000, // =
  0x20100804, 0x08102000, // >
  0x18240408, 0x08000800, // ?
  0x3c22021a, 0x2a2a1c00, // @
  0x08142222, 0x3e222200, // A  
  0x3c12121c, 0x12123c00, // B
  0x1c222020, 0x20221c00, // C
  0x3c121212, 0x12123c00, // D
  0x3e20203c, 0x20203e00, // E
  0x3e20203c, 0x20202000, // F
  0x1e202026, 0x22221e00, // G
  0x2222223e, 0x22222200, // H
  0x1c080808, 0x08081c00, // I
  0x02020202, 0x22221c00, // J
  0x22242830, 0x28242200, // K
  0x20202020, 0x20203e00, // L
  0x22362a2a, 0x22222200, // M
  0x22322a26, 0x22222200, // N
  0x3e222222, 0x22223e00, // O
  0x3c22223c, 0x20202000, // P
  0x1c222222, 0x2a241a00, // Q
  0x3c22223c, 0x28242200, // R
  0x1c221008, 0x04221c00, // S
  0x3e080808, 0x08080800, // T
  0x22222222, 0x22221c00, // U
  0x22222214, 0x14080800, // V
  0x2222222a, 0x2a362200, // W
  0x22221408, 0x14222200, // X
  0x22221408, 0x08080800, // Y
  0x3e020408, 0x10203e00, // Z
  0x38202020, 0x20203800, // [
  0x20201008, 0x04020200, // 
  0x0e020202, 0x02020e00, // ]
  0x081c2a08, 0x08080800, // up
  0x0008103e, 0x10080000, // left
  0x30180c00, 0x00000000, // `
  0x00001c02, 0x1e221e00, // a
  0x20203c22, 0x22223c00, // b
  0x00001c22, 0x20221c00, // c
  0x02021e22, 0x22221e00, // d
  0x00001c22, 0x3c201e00, // e
  0x0c12103c, 0x10101000, // f
  0x00001c22, 0x221e023c, // g
  0x20202c32, 0x22222200, // h
  0x08001808, 0x08081c00, // i
  0x04000c04, 0x04042418, // j
  0x20202224, 0x28242200, // k
  0x18080808, 0x08081c00, // l
  0x0000342a, 0x2a2a2200, // m
  0x00002c32, 0x22222200, // n
  0x00001c22, 0x22221c00, // o
  0x00003c22, 0x223c2020, // p
  0x00001e22, 0x221e0202, // q
  0x00002c32, 0x20202000, // r
  0x00001e20, 0x1c023c00, // s
  0x10103c10, 0x10120c00, // t
  0x00002222, 0x22261a00, // u
  0x00002222, 0x14140800, // v
  0x0000222a, 0x2a2a1400, // w
  0x00002214, 0x08142200, // x
  0x00002222, 0x261a023c, // y
  0x00003e04, 0x08103e00, // z
  0x0c101020, 0x10100c00, // {
  0x08080800, 0x08080800, // |
  0x30080804, 0x08083000, // }
  0x122a2400, 0x00000000, // ~
  0x1c263a36, 0x3e361c00 // del
};

// take an array as input, and just write the results as a binary stream to standard output
// use this to help port the existing 8x8 into an 8x12, etc
int main(int argc, char **argv) {
  unsigned char *bmp;
  int size = sizeof(font88)/sizeof(unsigned int);
  int width = 8;
  int height = 8;
  int rowsize = 16;
  FILE *fp, *fp2;

  bmp = (unsigned char *)malloc(sizeof(font88));
  
  fp = fopen("foo.mif","w");
  printf("size = %u\n", size);
  for (int i=0; i < size; i += 2) {
    int row = i/(2*rowsize);
    int col = (i/2)%rowsize;
    fprintf(fp, "%02x : %08x%08x00000000;\n", i/2, font88[i], font88[i+1]);
    for (int y=0; y < sizeof(unsigned int); y++) {
      int pos = (row*height+(3-y))*rowsize + col;
      bmp[pos] = (font88[i] >> 8*y) & 0xff; 
      printf("%d[%d]: %08x -> bmp[%08x]: %02x\n", i, 3-y, font88[i], pos, bmp[pos]);
    }
    for (int y=0; y < sizeof(unsigned int); y++) {
      int pos = (row*height+(3-y)+4)*rowsize + col;
      bmp[pos] = (font88[i+1] >> 8*y) & 0xff; 
      printf("%d[%d]: %08x -> bmp[%08x]: %02x\n", i+1, 3-y, font88[i+1], pos, bmp[pos]);
    }
  }
  fclose(fp);
  
  // Now write out the bitstream in 8bpp
  fp2 = fopen("comp.bmp","w");
  fp = fopen("raw.bmp", "w");
  for (int i=0; i < sizeof(font88); i++) {
    fwrite(&bmp[i],1,1,fp2);
    printf("bmp[%d] = %02x\n", i, bmp[i]);
    for (int b=0; b < 8; b++) {
      unsigned char val = (bmp[i] & (1 << (7-b)) ? 0xff : 0x00);
      fwrite(&val,1,1,fp);
    }
  }
  fclose(fp);
  fclose(fp2);
}

