#ifndef _CODEC_H_
#define _CODEC_H_

#include <sys/types.h>

// Commands
#define CODEC_SCI_WRITE       0x02
#define CODEC_SCI_READ        0x03

// Register definitions
#define CODEC_REG_MODE        0x00
#define CODEC_REG_STATUS      0x01
#define CODEC_REG_BASS        0x02
#define CODEC_REG_CLOCKF      0x03
#define CODEC_REG_DECODE_TIME 0x04
#define CODEC_REG_AUDATA      0x05
#define CODEC_REG_WRAM        0x06
#define CODEC_REG_WRAMADDR    0x07
#define CODEC_REG_HDAT0       0x08
#define CODEC_REG_HDAT1       0x09
#define CODEC_REG_AIADDR      0x0a
#define CODEC_REG_VOL         0x0b
#define CODEC_REG_AICTRL0     0x0c
#define CODEC_REG_AICTRL1     0x0d
#define CODEC_REG_AICTRL2     0x0e
#define CODEC_REG_AICTRL3     0x0f

// CODEC_REG_MODE bit definitions
#define CODEC_SM_DIFF          0x0001
#define CODEC_SM_LAYER12       0x0002
#define CODEC_SM_RESET         0x0004
#define CODEC_SM_CANCEL        0x0008
#define CODEC_SM_EARSPEAKER_LO 0x0010
#define CODEC_SM_TESTS         0x0020
#define CODEC_SM_STREAM        0x0040
#define CODEC_SM_EARSPEAKER_HI 0x0080
#define CODEC_SM_DACT          0x0100
#define CODEC_SM_SDIORD        0x0200
#define CODEC_SM_SDISHARE      0x0400
#define CODEC_SM_SDINEW        0x0800
#define CODEC_SM_ADPCM         0x1000
#define CODEC_SM_DUMMY         0x2000
#define CODEC_SM_LINE1         0x4000
#define CODEC_SM_CLK_RANGE     0x8000

extern void codec_sci_write(uint8_t addr, uint16_t value);
extern uint16_t codec_sci_read(uint8_t addr);
extern void codec_reset(void);
#endif
