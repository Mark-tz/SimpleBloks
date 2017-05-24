#include "delay.h"
#include "gpio.h"
#include "spioled.h"
#include "protocol.h"

u8 UID = 0;

int main(void){
	UID = 0;
	delay_init();
	NVIC_Configuration();
	Init();
	u8 req = 0;
	LED2_OFF();
	LED1_OFF();
	while(1){
		if(CS()){
			req = SPIReceiveByte();
			LED1_ON();
			ParseRequest(req);
		}
		LED1_OFF();
		delay_ms(1);
	}
}
