''' 
    Author: Michele Grisafi
    Email: michele.grisafi@unitn.it
    License: MIT 
'''
import serial, sys, time
if len(sys.argv) < 3:
    print("Wrong Syntax.\nCorrect syntax is: python {} bytes serialPort".format(sys.argv[0]))
    exit(1)

port=sys.argv[2]
byts=int(sys.argv[1])

ser = serial.Serial(port, 9600, timeout=None)  # open serial port

print("Writing {} bytes on {}".format(byts,ser.name))         # check which port was really used


def send():
    i = 0
    while i < byts:
        if i%100 == 0:
            print("Sent {}".format(i))
        if i%5 == 0:
            ser.write(b'a')
        if i%5 == 1:
            ser.write(b'b')
        if i%5 == 2:
            ser.write(b'c')
        if i%5 == 3:
            ser.write(b'd')
        if i%5 == 4:
            ser.write(b'e')
        while ser.out_waiting > 0:
            pass
        i+=1
    

send()
print("Bytes were sent")
ser.close()             # close port