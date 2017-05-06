#ifndef F_CPU
#define F_CPU 8000000UL
#endif

#include <avr/io.h>
#include <util/delay.h>
#include <avr/interrupt.h>

unsigned short num2seg(unsigned char dig);

// digit we are displaying
volatile unsigned digit = 0;
// SPI I/O state machine
volatile unsigned char spistate = 0;
// address of digit for SPI
volatile unsigned char addr;
// direction of current SPI operation
volatile unsigned char rw;
// display values
unsigned short values[16];


// instructions are of the form RW DD VVVV
// RW = 0 is read, 1 is write
// DD = digit
// VVVV = value (received or sent)
ISR(SPI_STC_vect) {
  TCNT1 = 0; // reset the timer watchdog  
  switch (spistate) {
  case 0: // direction byte
    rw = (SPDR != 0);
    spistate = 1;
    break;
  case 1: // R: prep high byte, W: nothing;
    addr = SPDR;
    if (addr >= 16) {
      SPDR = 0xff;
      spistate = 0;
    } else {
      spistate = 2;
      if (!rw)
	SPDR = values[addr] >> 8;
    }
    break;
  case 2: // R: prep low byte, W: fetch high byte
    if (!rw) {
      SPDR = values[addr] && 0xff;
    } else
      values[addr] = SPDR << 8;
    spistate = 3;
    break;
  case 3: // R: prep junk, W: fetch low byte
    if (!rw)
      SPDR = 0xa4;
    else
      values[addr] |= SPDR;
    spistate = 0;
    break;
  }
}

void led_enable() {
  PORTB &= 0x3f;
}

void led_disable() {
  PORTB |= 0x80;
}

void led_latch() {
  PORTC |= 0x80;
  PORTC &= 0x3f;
}

void led_clock() {
  PORTC |= 0x20;
  PORTC &= 0xdf;
}

void led_data(unsigned char state) {
  PORTC = (state ? PORTC | 0x10 : PORTC & 0xef);
}

// take 8 bits as input, and push to the tlc6c5912 (12 bits)
void bitbang(unsigned short value) {
  int i;

  // uninteresting 4 low order bits due to byte alignment
  value >>= 4;
  
  for (i=0; i < 12; i++) {
    led_data(value & 0x1);
    value >>= 1;
    led_clock();
  }
  led_latch();
}

ISR(TIMER1_COMPA_vect) {
  spistate = 0;
}

ISR(TIMER0_COMPA_vect) {
  digit = (digit+1)%16;
  
  led_disable();
  bitbang(values[digit]);
  if (digit < 8) {
    PORTB &= 0xfc;
    PORTB |= 0x01;
    PORTC &= 0xf0;
    PORTD = (1 << digit);
  } else if (digit < 12) {
    PORTA = 1 << (digit - 8);
    PORTB &= 0xfc;
    PORTB |= 0x02;
    PORTD = 0x00;
  } else {
    PORTA = 0x00;
    PORTC &= 0xf0;
    PORTC |= 1 << (digit - 12);
  }
  led_enable();
}

// ABCDEFGd coded output for testing.
// The short int loaded from SPI will take the raw bit pattern to allow
// for multiple character sets.
unsigned short num2seg(unsigned char dig) {
  switch (dig) {
  case 0: return 0b1111110000000000;
  case 1: return 0b0110000000000000;
  case 2: return 0b1101101000000000;
  case 3: return 0b1111001000000000;
  case 4: return 0b0110011000000000;
  case 5: return 0b1011011000000000;
  case 6: return 0b1011111000000000;
  case 7: return 0b1110000000000000;
  case 8: return 0b1111111000000000;
  case 9: return 0b1111011000000000;
  case 10: return 0b1110111000000000;
  case 11: return 0b0011111000000000;
  case 12: return 0b0001101000000000;
  case 13: return 0b0111101000000000;
  case 14: return 0b1001111000000000;
  case 15: return 0b1000111000000000;
  }
  return 0b0;
}

int main(void) {
  int i;

  srand(403983);
  DDRA = 0b00001111; // digits 8-11
  DDRB = 0b11010011; // colons, tick, SPI, and enable
  DDRC = 0b10111111; // latch out, clock, digits 12-15
  DDRD = 0b11111111; // digits 0-7

  PORTA = 0x00;
  PORTB = 0x40; // enable tick support
  PORTC = 0x00;
  PORTD = 0x01;
  SPCR = 0b11000000; // slave mode, msb, enable SPI interrupt
  // timer 0 - display strobe
  TCCR0A = 0b1011;
  OCR0A = 0x80;
  TIMSK0 = 0x2; // enable ICIE0A interrupt
  // timer 1 - watchdog to reset SPI state
  TCCR1B = 0b00001101; // CTC, 1024 prescaler
  OCR1A = 0x300; // 0.2s timeout?
  TIMSK1 = 0x2; // enable OCIE1A interrupt
  sei();

  // HELLO
  for (i=0; i < 16; i++)
    values[i] = 0;
  values[0] = 0b0110111000000000;
  values[1] = 0b1001111000000000;
  values[2] = 0b0001110000000000;
  values[3] = 0b0001110000000000;
  values[4] = num2seg(0);
  // 1.0
  values[8] = num2seg(1) | 0x100;
  values[9] = num2seg(1);
	 
  _delay_ms(1500);
  
  for (i=0; i < 16; i++)
    values[i] = 0;

  while (1);
}
