#include "gpio.h"
#include "protocol.h"
#include "delay.h"
void SPIInit();
void LEDInit();
void SwitchInit();
void ClockInit();
void MISOInit();
void Init(){
	ClockInit();
	LEDInit();
	SwitchInit();
	SPIInit();
	MISOInit_IN();
}
//////////////////////////////////
// 5v GND  3    4    5    6    7
// MODE   AF   AF   AF   IF  OUTP  
// SPI0   A5   A6   A7   A1   A0
//
// MODE   AF   AF   AF  OUTP  IPU
// SPI1   A5   A6   A7   B7   B8
// SPI2   A5   A6   A7   B5   B6
// SPI3   A5   A6   A7   A2   A3
//////////////////////////////////

void MISOInit_OUT(){
	GPIO_InitTypeDef GPIO_InitStructure;
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_6;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP;
	GPIO_Init(GPIOA,&GPIO_InitStructure);
}
void MISOInit_IN(){
	GPIO_InitTypeDef GPIO_InitStructure;
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_6;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_IN_FLOATING;
	GPIO_Init(GPIOA,&GPIO_InitStructure);
}

void SPIInit(){
	GPIO_InitTypeDef GPIO_InitStructure;
	// SPI_InitTypeDef SPI_InitStructure;
	//SCK MISO MOSI SS
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_4;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_IN_FLOATING;
	GPIO_Init(GPIOA,&GPIO_InitStructure);

	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_5 | GPIO_Pin_7;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_IN_FLOATING;
	GPIO_Init(GPIOA,&GPIO_InitStructure);

	
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_1 | GPIO_Pin_2;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP;
	GPIO_Init(GPIOA,&GPIO_InitStructure);
	GPIO_SetBits(GPIOA, GPIO_Pin_2);
	GPIO_ResetBits(GPIOA, GPIO_Pin_1);
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_5 | GPIO_Pin_7;
	GPIO_Init(GPIOB,&GPIO_InitStructure);
	GPIO_SetBits(GPIOB, GPIO_Pin_5 | GPIO_Pin_7);

	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_0;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_IN_FLOATING;
	GPIO_Init(GPIOA,&GPIO_InitStructure);

	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_8 | GPIO_Pin_6;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_IPU;
	GPIO_Init(GPIOB,&GPIO_InitStructure);
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_3;
	GPIO_Init(GPIOA,&GPIO_InitStructure);

	// SPI_InitStructure.SPI_Direction = SPI_Direction_2Lines_FullDuplex;
	// SPI_InitStructure.SPI_Mode = SPI_Mode_Slave;
	// SPI_InitStructure.SPI_DataSize = SPI_DataSize_8b;
	// SPI_InitStructure.SPI_CPOL = SPI_CPOL_Low;
	// SPI_InitStructure.SPI_CPHA = SPI_CPHA_1Edge;
	// SPI_InitStructure.SPI_NSS = SPI_NSS_Hard;
	// SPI_InitStructure.SPI_BaudRatePrescaler = SPI_BaudRatePrescaler_2;
	// SPI_InitStructure.SPI_FirstBit = SPI_FirstBit_MSB;
	// SPI_InitStructure.SPI_CRCPolynomial = 7;
	// SPI_Init(SPI1,&SPI_InitStructure);
	// SPI_Cmd(SPI1,ENABLE);
}
void SPISendByte(u8 data){
	// while(SPI_I2S_GetFlagStatus(SPI1, SPI_I2S_FLAG_TXE) == RESET);
	// SPI_I2S_SendData(SPI1,data);
	u8 i;
	for(i=0;i<8;i++){
		while(CLK() == HIGH);
		if(data&0x80)
		   MISO_HIGH();
		else 
		   MISO_LOW();
		data<<=1;
		while(CLK() == LOW);
	}
	delay_ms(1);
}
u8 SPIReceiveByte(){
	// while(SPI_I2S_GetFlagStatus(SPI1, SPI_I2S_FLAG_RXNE) == RESET);
	// return SPI_I2S_ReceiveData(SPI1);
	u8 i;
	u8 res = 0;
	for(i=0;i<8;i++){
		res <<= 1;
		while(CLK() == LOW);
		res |= MOSI();
		while(CLK() == HIGH);
	}
	delay_ms(1);
	return res;
}
void ClockInit(){
	//RCC_APB2PeriphClockCmd(RCC_APB2Periph_SPI1,ENABLE);
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOA,ENABLE);
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOB,ENABLE);
}
void LEDInit(){
	GPIO_InitTypeDef GPIO_InitStructure;
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_11 | GPIO_Pin_12;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP;
	GPIO_Init(GPIOA,&GPIO_InitStructure);
	GPIO_SetBits(GPIOA,GPIO_Pin_11 | GPIO_Pin_12);
}
void SwitchInit(){
	GPIO_InitTypeDef GPIO_InitStructure;
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_9 | GPIO_Pin_10;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_IPU;
	GPIO_Init(GPIOA,&GPIO_InitStructure);
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_0 | GPIO_Pin_1 | GPIO_Pin_9 | GPIO_Pin_10 | GPIO_Pin_11 | GPIO_Pin_12;
	GPIO_Init(GPIOB,&GPIO_InitStructure);
}
u8 ReadSwitch(){
	u8 result = 0;
	result = GPIO_ReadInputDataBit(GPIOA, GPIO_Pin_9 );
	result <<= 1; result |=  GPIO_ReadInputDataBit(GPIOA, GPIO_Pin_10 );
	result <<= 1; result |=  GPIO_ReadInputDataBit(GPIOB, GPIO_Pin_0  );
	result <<= 1; result |=  GPIO_ReadInputDataBit(GPIOB, GPIO_Pin_1  );
	result <<= 1; result |=  GPIO_ReadInputDataBit(GPIOB, GPIO_Pin_9  );
	result <<= 1; result |=  GPIO_ReadInputDataBit(GPIOB, GPIO_Pin_10 );
	result <<= 1; result |=  GPIO_ReadInputDataBit(GPIOB, GPIO_Pin_11 );
	result <<= 1; result |=  GPIO_ReadInputDataBit(GPIOB, GPIO_Pin_12 );
	return result;
}
u8 ChangeLED(u8 num){
	static u8 sw[3] = {0,0,0};
	static const u16 LED[3] = {GPIO_Pin_12,GPIO_Pin_11,GPIO_Pin_4};
	u8 n = num - 1;
	if (n < 2) {
		if(sw[n] == 0){
			GPIO_SetBits(GPIOA,LED[n]);
			sw[n] = 1;
		}
		else{
			GPIO_ResetBits(GPIOA,LED[n]);
			sw[n] = 0;
		}
		return 0;
	}
	return 0xff;
}
u8 CheckSPIPos(u8 num){
	u8 res = 0;
	switch(num){
		case 1:
			res = GPIO_ReadInputDataBit(GPIOB, GPIO_Pin_8)?0:1;
			break;
		case 2:
			res = GPIO_ReadInputDataBit(GPIOB, GPIO_Pin_6)?0:1;
			break;
		case 3:
			res = GPIO_ReadInputDataBit(GPIOA, GPIO_Pin_3)?0:1;
			break;
		default:
			return FAILED;
	}
	return res ? SUCCESS : FAILED;
}
u8 OpenSPIPos(u8 num){
	if(CheckSPIPos(num) != SUCCESS) return FAILED;
	switch(num){
		case 1:
			GPIO_ResetBits(GPIOB,GPIO_Pin_7);
			break;
		case 2:
			GPIO_ResetBits(GPIOB,GPIO_Pin_5);
			break;
		case 3:
			GPIO_ResetBits(GPIOA,GPIO_Pin_2);
			break;
		default:
			return FAILED;
	}
	return SUCCESS;
}

