#!/usr/bin/python
# -*- coding: utf-8 -*-

__author__ = 'Mark'

import block as B
import protocol as P
import spi
import define as D
import time
K = D.KEYCODE
S = D.SYMBOLCODE
count = 0

def getBlock():
	global count
	count += 1
	id = count
	P.ClearCID()
	res = P.SetID(id)
	print "ID : ",id," -- ",res
	P.ConfirmCID(id)
	value = P.GetValue()
	return B.Block(id,(value & 0xf0)>>4,value & 0x0f)
def getBlocks():
	block = getBlock()
	for POS in range(P.POS_START,P.POS_END):
		print "POS : ",POS
		P.ConfirmCID(block.id)
		if P.CheckPos(POS):
			P.OpenPos(POS)
			time.sleep(0.5)
			block.child[POS] = getBlocks()
	return block
def main():
	spi.initSPI()
	blocks = getBlocks()
	for node in B.Blocks2Array(blocks):
		print node.id,node.command,node.value;
#	print P.CheckPos(1)
#	print P.CheckPos(2)
#	print P.CheckPos(3)
#	print "\n"
if __name__=='__main__':
	main()
