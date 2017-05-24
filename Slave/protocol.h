#ifndef __PROTOCOL_H__
#define __PROTOCOL_H__
#include "sys.h"

#define HEADER_LENGTH	4

#define GET_HEADER 		0xf0
#define GET_COMMAND 	0x0f
#define GET_COMMAND_T	0x0c
#define GET_COMMAND_D	0x03

#define COMMAND_HEADER	0xd0
#define COMMAND_RESPONSE_HEADER	0xb0

#define CLEAR_SPI		0x00

#define SET_LED 		0x00
#define SET_LED1 		0x01
#define SET_LED2 		0x02
#define SET_LED3 		0x03
#define CHECK_POS		0x04
#define CHECK_POS1		0x05
#define CHECK_POS2		0x06
#define CHECK_POS3		0x07
#define OPEN_POS		0x08
#define OPEN_POS1		0x09
#define OPEN_POS2		0x0a
#define OPEN_POS3		0x0b

#define SET_ID			0x0c
#define GET_VAL			0x0d

#define WITH_ID			0xde
#define CLR_ID			0xdf

#define SUCCESS			0xc0
#define FAILED			0x50

u8 ParseRequest(u8);

#endif
