#!/usr/bin/python
# -*- coding: utf-8 -*-

__author__ = 'Mark'

import block as B
import protocol as P
import spi
import define as D
K = D.KEYCODE
S = D.SYMBOLCODE
count = 0

def getBlock():
	global count
	count += 1
	id = count
	P.ClearCID()
	P.SetID(id)
	P.ConfirmCID(id)
	value = P.GetValue()
	return B.Block(id,(value & 0xf0)>>4,value & 0x0f)
def getBlocks():
	block = getBlock()
	for POS in range(P.POS_START,P.POS_END):
		P.ConfirmCID(block.id)
		if P.CheckPos(P.POS_TOP):
			P.OpenPos(P.POS_TOP)
			block.top = getBlocks()
	return block
def main():
	spi.initSPI()
	d = 0x00
	while True:
		d += 1
		spi.write(d)
		spi.read()
	pass
if __name__=='__main__':
	main()
