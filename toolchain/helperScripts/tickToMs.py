#    Author: Michele Grisafi
#    Email: michele.grisafi@unitn.it
#    License: MIT 
import sys
if len(sys.argv) < 4:
    print("""Wrong Syntax.\nCorrect syntax is: python {} cycles clockName divider\n
First argument is the number of cycles detected (e.g. 'a4ff'). Second argument is the TASSEL_X counter [1,2], third argument is the divider [1,2,4,8]""".format(sys.argv[0]))
    exit(1)



if int(sys.argv[2]) != 1 and int(sys.argv[2]) != 2:
    print("Clock {} invalid. Clock must be either 1 or 2.".format(sys.argv[2]))
    exit(1)
elif int(sys.argv[3]) != 1 and int(sys.argv[3]) != 2 and int(sys.argv[3]) != 4 and int(sys.argv[3]) != 8:
    print("Divider must be either 1, 2, 4 or 8.")
    exit(1)

clock = [32768,1000000]
dividers = [1,2,4,8]

cycles = int(sys.argv[1], 16);
clockSelected = clock[int(sys.argv[2])-1]
divider=int(sys.argv[3])

msPerTick=(clockSelected/divider/1000)

result = cycles/msPerTick
print("Total ms: {}".format(result))