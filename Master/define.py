#!/usr/bin/python
# -*- coding: utf-8 -*-

__author__ = 'Mark'

KEYCODE = {
	"START"	 : 0x10, 0x10 : "{"	 ,
	"END"	 : 0x20, 0x20 : "}"	 ,
	"INPUT"	 : 0x30, 0x30 : "INPUT"	 ,
	"OUTPUT" : 0x40, 0x40 : "OUTPUT" ,
	"NUMBER" : 0x50, 0x50 : "NUMBER" ,
	"IF"	 : 0x60, 0x60 : "IF"	 ,
	"ELSE"	 : 0x70, 0x70 : "ELSE"	 ,
	"WHILE"	 : 0x80, 0x80 : "WHILE"	 ,
	"FOR"	 : 0x90, 0x90 : "FOR"	 ,
	"SYMBOL" : 0xa0, 0xa0 : "SYMBOL" ,
	"HANDLE" : 0xb0, 0xb0 : "HANDLE"
}
SYMBOLCODE = {
	"==" : 0x01, 0x01 : "==",
	"!=" : 0x02, 0x02 : "!=",
	">"  : 0x03, 0x03 : ">" ,
	">=" : 0x04, 0x04 : ">=",
	"<"  : 0x05, 0x05 : "<" ,
	"<=" : 0x06, 0x06 : "<="
}

def input1():
	return true

def input(num):
	res = None
	if num == 1:
		res = input1()
		print "INPUT-1 : ",res
	else:
		print "INPUT : ",num
	return res
def output(num,param):
	print "OUTPUT : ",num
	return num
def handle(num):
	if num == 1:
		sleep(1)
		print "SLEEP 1"
	else:
		print "HANDLE : ",num
	return num

def test():
	pass

if __name__=='__main__':
	test()