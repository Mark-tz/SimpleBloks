#!/usr/bin/python
# -*- coding: utf-8 -*-

__author__ = 'Mark'

import spidev
import protocol as P
import time

def wait():
	time.sleep(0.1)
def initSPI():
	global SPI0
	SPI0 = spidev.SpiDev()
	SPI0.open(0,0)
	SPI0.max_speed_hz = 500
	wait()
#def clear():
#	global SPI0
#	SPI0.xfer2([0x00])
#	wait()
def write(data):
	global SPI0
	SPI0.writebytes([data])
	print "WRITE : ",hex(data),"{0:=10b}".format(data)
	wait()
def read():
	global SPI0
	data = SPI0.readbytes(1)
	print "READ  : ",hex(data[0]),"{0:=10b}".format(data[0])
	wait()
	return data[0]
def test():
	pass
if __name__=='__main__':
	test()
