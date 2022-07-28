import sys,re,logging,os,binascii


if len(sys.argv) < 2:
    print("The number of arguments is inappropriate.\nCorrect syntax is: python {} src".format(sys.argv[0]))
    exit(1)

logging.basicConfig(stream=sys.stderr, level=logging.WARNING)


with open(sys.argv[1], 'rb') as f:
    # Slurp the whole file and efficiently convert it to hex all at once
    while (byte := f.read(1)):
        hexdata = str(binascii.hexlify(byte),'ascii')
        print("0x"+hexdata+",",end='')
        
    


