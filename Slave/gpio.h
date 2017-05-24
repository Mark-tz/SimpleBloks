#ifndef __SPI_H__
#define __SPI_H__
#include "config.h"
#include "sys.h"
void Init();
void SPISendByte(u8);
u8 SPIReceiveByte();
u8 ReadSwitch();
u8 ChangeLED(u8);
u8 CheckSPIPos(u8);
u8 OpenSPIPos(u8);
void MISOInit_OUT();
void MISOInit_IN();
#define LED1_ON() GPIO_SetBits(GPIOA,GPIO_Pin_12)
#define LED2_ON() GPIO_SetBits(GPIOA,GPIO_Pin_11)
#define LED1_OFF() GPIO_ResetBits(GPIOA,GPIO_Pin_12)
#define LED2_OFF() GPIO_ResetBits(GPIOA,GPIO_Pin_11)

#define CS() (GPIO_ReadInputDataBit(GPIOA,GPIO_Pin_0) ? 0 : 1)
#define CLK() (GPIO_ReadInputDataBit(GPIOA,GPIO_Pin_5))
#define MOSI() (GPIO_ReadInputDataBit(GPIOA,GPIO_Pin_7))
#define HIGH 1
#define LOW 0
#define MISO_HIGH() GPIO_SetBits(GPIOA,GPIO_Pin_6)
#define MISO_LOW() GPIO_ResetBits(GPIOA,GPIO_Pin_6)
#endif
