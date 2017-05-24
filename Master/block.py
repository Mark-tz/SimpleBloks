#!/usr/bin/python
# -*- coding: utf-8 -*-

__author__ = 'Mark'

import define as D
import protocol as P
K = D.KEYCODE
S = D.SYMBOLCODE

class Block(object):
	def __init__(self,id,command,value):
		self.child = {};
		self.command = command;
		self.value = value;
		self.id = id;

def Blocks2Array(block):
	res = [block];
	if block.child.has_key(P.POS_TOP) and block.child[P.POS_TOP] != None:
		res.extend(Blocks2Array(block.child[P.POS_TOP]));
	if block.child.has_key(P.POS_BOTTOM) and block.child[P.POS_BOTTOM] != None:
		res.append(Block(0,K["START"],0));
		res.extend(Blocks2Array(block.child[P.POS_BOTTOM]));
		res.append(Block(0,K["END"],0));
	if block.child.has_key(P.POS_RIGHT) and block.child[P.POS_RIGHT] != None:
		res.extend(Blocks2Array(block.child[P.POS_RIGHT]));
	return res;

def test():
	# start = Block(1,K["FOR"],4)
	# start.bottom = Block(2,K["OUTPUT"],1)
	# start.bottom.right = Block(3,K["NUMBER"],1)
	# start.bottom.right.right = Block(4,K["OUTPUT"],2)
	# start.bottom.right.right.right = Block(5,K["NUMBER"],1)

	#start = Block(2,K["WHILE"],0)
	#start.top = Block(4,K["NUMBER"],1)
	#start.bottom = Block(5,K["IF"],0)
	#start.bottom.top = Block(6,K["INPUT"],1)
	#start.bottom.bottom = Block(7,K["OUTPUT"],1)
	#start.bottom.bottom.right = Block(8,K["NUMBER"],1)
	#start.bottom.right = Block(9,K["ELSE"],0)
	#start.bottom.right.bottom = Block(10,K["OUTPUT"],1)
	#start.bottom.right.bottom.right = Block(11,K["NUMBER"],0)
	#for node in Blocks2Array(start):
	#	print node.id,K[node.command],node.value;
	pass
if __name__=='__main__':
	test()
