#!/usr/bin/env python3

#    Author: Michele Grisafi
#    Email: michele.grisafi@unitn.it
#    License: MIT 
import serial, sys, time
if len(sys.argv) < 2:
    print("Wrong Syntax.\nCorrect syntax is: python {} serialPort".format(sys.argv[0]))
    exit(1)

port=sys.argv[1]

ser = serial.Serial(port, 9600, timeout=None)  # open serial port

print("Reading from {}".format(ser.name))         # check which port was really used



   
#Read the ACK
while 1:
    inp = ser.read()
    if(inp == b'T'):
        print("Received {}".format(inp))
    else:
        print("Wrong ACK: {}".format(inp))





ser.close()             # close port