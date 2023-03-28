#!/usr/bin/env python3

#    Author: Michele Grisafi
#    Email: michele.grisafi@unitn.it
#    License: MIT 
import serial, sys, time
if len(sys.argv) < 3:
    print("Wrong Syntax.\nCorrect syntax is: python {} file.out serialPort".format(sys.argv[0]))
    exit(1)

port=sys.argv[2]
file=sys.argv[1]

ser = serial.Serial(port, 9600, timeout=None)  # open serial port

print("Writing on {}".format(ser.name))         # check which port was really used

#Send image
def send():
    i = 1

    #Open file in byte mode
    with open(file, "rb") as fh:

        #Read length
        chunk = fh.read(2)
        print("Sending length")

        #Send length
        ser.write(chunk)
        while ser.out_waiting > 0:
            pass
        
        #Read the ACK
        inp = ser.read()
        if(inp == b'T'):
            print("ACK Received")
        else:
            print("Wrong ACK: {}".format(inp))
            return False
        
        #Keep on sending the data
        while True:
            print("Sending chunk {}".format(i))
            i +=1
            
            #Send chunk of 512 bytes
            chunk = fh.read(512)
            if not chunk: break
            ser.write(chunk)
            while ser.out_waiting > 0:
                pass
            
            #Wait for the ACK
            inp = ser.read()
            if(inp == b'T'):
                print("ACK Received")
            else:
                print("Wrong ACK: {}".format(inp))
                return False
        return True

if(send()):
    print("File sent")
else:
    print("File was not sent")
ser.close()             # close port