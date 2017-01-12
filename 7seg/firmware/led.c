#ifndef F_CPU
#define F_CPU 8000000UL
#endif

#include <avr/io.h>
#include <util/delay.h>
#include <avr/interrupt.h>

unsigned char d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11, d12, d13, d14, d15;
unsigned char spistate;
unsigned char rw;
unsigned char digit;

// instructions are of the form RW DD VV
// RW = 0 is read, 1 is write
// DD = digit
// VV = value (received or sent)
ISR(SPI_STC_vect) {
  switch (spistate) {
  case 0: // direction byte
    rw = (SPDR != 0);
    spistate = 1;
    break;
  case 1: // digit byte;
    digit = SPDR;
    if (!rw) // read, need to set return value
      switch (digit) {
      case 0:
        SPDR = d0;
        break;
      case 1:
        SPDR = d1;
        break;
      case 2:
        SPDR = d2;
        break;
      case 3:
        SPDR = d3;
        break;
      default:
        SPDR = 0xff;
        break;
      }
    spistate = 2;
    break;
  case 2: // value
    if (rw)
      switch (digit) {
      case 0:
        d0 = SPDR;
        break;
      case 1:
        d1 = SPDR;
        break;
      case 2:
        d2 = SPDR;
        break;
      case 3:
        d3 = SPDR;
        break;
      }
    spistate = 0;
    break;
  }
}

ISR(TIMER0_COMPA_vect) {
  PORTD = (PORTD == 16 ? 1 : PORTD << 1);
  switch (PORTD) {
  case 1:
    PORTC = ~(0x3f & (d0 >> 1));
    PORTB = ~(0x01 & d0 ? PORTB | 0x1 : PORTB & 0xfe);
    break;
  case 2:
    PORTC = ~(0x3f & (d1 >> 1));
    PORTB = ~(0x01 & d1 ? PORTB | 0x1 : PORTB & 0xfe);
    break;
  case 4:
    PORTC = ~(0x3f & (d2 >> 1));
    PORTB = ~(0x01 & d2 ? PORTB | 0x1 : PORTB & 0xfe);
    break;
  case 8:
    PORTC = ~(0x3f & (d3 >> 1));
    PORTB = ~(0x01 & d3 ? PORTB | 0x1 : PORTB & 0xfe);
    break;
  }
}

// take a value 0-f and translate to a positive bit pattern for the register
// this will need to change when we need to clock the bits to an external
// sink chip, but this is sufficient for the PoC.
// ABCDEFG at the moment
unsigned char num2seg(unsigned char dig) {
  switch (dig) {
  case 0: return 0b1111110;
  case 1: return 0b0110000;
  case 2: return 0b1101101;
  case 3: return 0b1111001;
  case 4: return 0b0110011;
  case 5: return 0b1011011;
  case 6: return 0b1011111;
  case 7: return 0b1110000;
  case 8: return 0b1111111;
  case 9: return 0b1111011;
  case 10: return 0b1110111;
  case 11: return 0b0011111;
  case 12: return 0b0001101;
  case 13: return 0b0111101;
  case 14: return 0b1001111;
  case 15: return 0b1000111;
  }
  return 0b0;
}

int main(void) {
  d0 = num2seg(12);
  d1 = num2seg(13);
  d2 = num2seg(14);
  d3 = num2seg(15);
  DDRB = 0b00010001; // sink & SPI MISO
  DDRC = 0b00111111; // sink
  DDRD = 0xff; // source
  PORTB &= 0b11101111; // clear MISO
  SPCR = 0b11000000; // slave mode, enable SPI interrupt
  PORTC = ~(0x3f & (d0 >> 1));
  PORTB = ~(0x01 & d0 ? PORTB | 0x1 : PORTB & 0xfe);
  PORTD = 1;
  TCCR0A = 0b1101;
  OCR0A = 10;
  TIMSK0 = 0x2; // enable ICIE0A interrupt
  sei();
  while (1);
}
