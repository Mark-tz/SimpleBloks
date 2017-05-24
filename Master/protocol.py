#!/usr/bin/python
# -*- coding: utf-8 -*-

__author__ = 'Mark'

import spi
GET_HEADER 	= 0xf0
GET_COMMAND 	= 0x0f
GET_COMMAND_T	= 0x0c
GET_COMMAND_D	= 0x03

COMMAND_HEADER	= 0xd0
RESPONSE_HEADER	= 0xb0

SET_LED 		= 0x00
SET_LED1 		= 0x01
SET_LED2 		= 0x02
SET_LED3 		= 0x03
CHECK_POS		= 0x04
CHECK_POS1		= 0x05
CHECK_POS2		= 0x06
CHECK_POS3		= 0x07
OPEN_POS		= 0x08
OPEN_POS1		= 0x09
OPEN_POS2		= 0x0a
OPEN_POS3		= 0x0b

POS_TOP			= 0x01
POS_RIGHT		= 0x02
POS_BOTTOM		= 0x03

POS_START		= 0x01
POS_END			= 0x04

SET_ID			= 0x0c
GET_VAL			= 0x0d

WITH_ID			= 0xde
CLR_ID			= 0xdf

SUCCESS			= 0xc0
FAILED			= 0x50

def ConfirmCID(id):
	spi.write(COMMAND_HEADER | WITH_ID)
	spi.write(id)
def ClearCID():
	spi.write(COMMAND_HEADER | CLR_ID)
	pass
def SetLED(num):
	COMMAND = SET_LED + num
	spi.write(COMMAND_HEADER | COMMAND)
	return True
def CheckPos(num):
	COMMAND = CHECK_POS + num
	spi.write(COMMAND_HEADER | COMMAND)
	#res1 = True#spi.read() == (RESPONSE_HEADER | COMMAND)
	res2 = spi.read() == (SUCCESS | COMMAND)
	return res2
def OpenPos(num):
	COMMAND = OPEN_POS + num
	spi.write(COMMAND_HEADER | COMMAND)
	#res1 = True#spi.read() == (RESPONSE_HEADER | COMMAND)
	res2 = spi.read() == (SUCCESS | COMMAND)
	return res2
def SetID(id):
	spi.write(COMMAND_HEADER | SET_ID)
	spi.write(id)
	pack2 = spi.read()
	return  pack2 == id
def GetValue():
	spi.write(COMMAND_HEADER | GET_VAL)
	res = True#res1 == (RESPONSE_HEADER | GET_VAL)
	val = spi.read()
	if res:
		return val
	return 0x00
