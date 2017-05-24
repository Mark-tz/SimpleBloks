#include "protocol.h"
#include "gpio.h"
#include "sys.h"
extern u8 UID;
static u8 CID = 0;
void ResponseCommand(u8);
void CatchCommand(u8);
void SetLED(u8);
void CheckPos(u8);
void OpenPos(u8);
void SetID();
void GetValue();
void SetMISO(){
	if(CID == UID){
		MISOInit_OUT();
	}else{
		MISOInit_IN();
	}
}
u8 ParseRequest(u8 req){
	static u8 header;
	static u8 command;
	u8 res = 0;
	switch(req){
		case WITH_ID:
		CID = SPIReceiveByte();
		SetMISO();
		return 0x00;
		case CLR_ID:
		CID = 0x00;
		SetMISO();
		return 0x00;
	}
	if (CID == UID) {
		header = req & GET_HEADER;
		command = req & GET_COMMAND;
		switch(header){
			case COMMAND_HEADER:
				CatchCommand(command);
				break;
			default:
				return 0x00;
		}
	}
	return 0x00;
}
void ResponseCommand(u8 command){
	SPISendByte(COMMAND_RESPONSE_HEADER | (command & GET_COMMAND));
}
void CatchCommand(u8 command){
	u8 t = command & GET_COMMAND_T;
	u8 d = command & GET_COMMAND_D;
	switch(t){
		case SET_LED:
		SetLED(d);
		break;

		case CHECK_POS:
		CheckPos(d);
		break;

		case OPEN_POS:
		OpenPos(d);
		break;

		default:
		switch(command){
			case SET_ID:
				SetID();
				break;
			case GET_VAL:
				GetValue();
				break;
			default:
				return;
		}
		break;
	}
	return;
}
void SetLED(u8 num){
	ChangeLED(num);
}
void CheckPos(u8 num){
	u8 res = CheckSPIPos(num);
	SPISendByte((CHECK_POS + num) | res);
}
void OpenPos(u8 num){
	u8 res = OpenSPIPos(num);
	SPISendByte((OPEN_POS + num) | res);
}
void SetID(){
	u8 id1 = SPIReceiveByte();	if (UID != 0) return;
	if (id1 != 0) {
		UID = id1;
		LED2_ON();
		SPISendByte(UID);
		return;
	}
}
void GetValue(){
	u8 res = ReadSwitch();
	SPISendByte(res);
}