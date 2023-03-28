#    Author: Michele Grisafi
#    Email: michele.grisafi@unitn.it
#    License: MIT 
import sys,logging, os, subprocess, re

objcopy = "msp430-elf-objcopy"
readelf = "msp430-elf-readelf"
debugFiles = False # set to True if we want to inspect the content of the various temporary files.
if len(sys.argv) < 3:
    print("The number of arguments is inappropriate.\nCorrect syntax is: {} inputFile.out outputFile.out [bssSize]".format(sys.argv[0]))
    exit(1)
logging.basicConfig(stream=sys.stderr, level=logging.ERROR)


inputFile = sys.argv[1]
outputFile = sys.argv[2]

#Set default bss size
bssSize = 0
if len(sys.argv) > 3:
    bssSize = int(sys.argv[3])
outputFile = open(outputFile,"ab")


# EXTRACT INFO FROM READELF UTILITY
result = subprocess.run([readelf,'-S','-W',inputFile],stdout=subprocess.PIPE)

#Set default sizes
codeSize = 0
roDataSize = 0

lineNr = 0
sections = []

#cycle through the readelf output
for line in result.stdout.decode('utf-8').splitlines():
    lineNr +=1

    #header line containing the info we want
    if lineNr == 4: 
        headers = {}
        headers["name"] = line.index("Name")
        headers["addr"] = line.index("Addr")
        headers["off"] = line.index("Off")
        headers["size"] = line.index("Size")
        headers["flg"] = line.index("Flg")
        headers["type"] = line.index("Type")
        #print(headers)

    #consider only the sections
    if lineNr > 5 and line[2] == '[': 
        parts = {}

        ############### Parse the output

        parts["name"]=  line[headers["name"]:  line[headers["name"]:].index(" ")+int(headers["name"])]
        
        
        extraChar = 0
        if len(parts["name"])>=headers["type"]-headers["name"]:
            extraChar = len(parts["name"]) - (headers["type"]-headers["name"]) + 1
        
        startPos =   headers["type"]+extraChar
        endPos =    startPos + line[startPos:].index(" ")
        sectionType = line[ startPos: endPos ]
        #print("Extra {}, {} -> {} > {} - {} ".format(extraChar,sectionType, len(sectionType),headers["addr"],headers["type"]))
        if len(sectionType)>=headers["addr"]-headers["type"]:
            extraChar += len(sectionType) - (headers["addr"]-headers["type"]) + 1
        
        startPos = headers["size"]+extraChar
        endPos = line[headers["size"]+extraChar:].index(" ")  + int(headers["size"]+extraChar) 
        parts["size"]= int(line[startPos:endPos],16)
        
        startPos =  headers["addr"]+extraChar
        endPos = line[headers["addr"]+extraChar:].index(" ")+int(headers["addr"]+extraChar) 
        parts["addr"] = int(line[startPos:endPos],16)


        startPos =  headers["flg"]+extraChar
        endPos = int(headers["flg"]+extraChar)+3 
        parts["flg"] = line[startPos : endPos ].strip()
        
        #Write the type of section to the metadata
        if (sectionType == "NOBITS"):
            parts["type"] = 0
        elif(parts["addr"]<17408): # 0x4400
            parts["type"] = 2 # load to ram
        else:
            parts["type"] = 1 # load to FLASH
        #print(line[headers["flg"]:].index(" ")+int(headers["flg"]))

        #Set the correct bss size
        if bssSize>0 and parts["name"]==".bss":
            parts["size"]=bssSize

        if(parts["flg"].find("A") != -1):
            sections.append(parts)
        
        # If it is flash and between the 0x4400 and 0xC400 then add it to codesize
        if(parts["type"] == 1 and parts["addr"] >= 17408 and parts["addr"] < 50176):
            codeSize+=parts["size"]
        
        # if it is in flash and above 0x14400 then add it to rodata size
        if(parts["type"] == 1 and parts["addr"] >= 82944): 
            roDataSize+=parts["size"]

# start calculating the offset for each data section. + 1 accounts for the section counter, while the file size is not counted
totalOffset=1 + len(sections)*9 

# Add padding if the total bytes up to now are odd so that the offsets are even
offsetPadding = False
if totalOffset%2 == 1:
    totalOffset+=1
    offsetPadding = True

# Calculate offsets so that they are always even
prvPadding = 0
for section in sections:
    totalOffset+= prvPadding
    section["off"] = totalOffset 
    if section["type"] != 0:
        totalOffset += section["size"]
    print("{}\n".format(section))
    if section["size"]%2 >0:
        prvPadding = 1
    else:
        prvPadding = 0

#Important output 
print("Code size: '{}'".format(codeSize))

print("Flash size: '{}'".format(roDataSize+codeSize))


try:
    os.remove("tmpElf.tmp")
except OSError:
    pass

#Patch the output file to embedd the various metadata

# Write the number of sections
f = open('tmpElf.tmp',"ab")
f.write(len(sections).to_bytes(1,byteorder="little",signed=False))


# Write the sections metadata
for section in sections:
    #print("{} - {} - {}".format(section["name"],hex(section["size"]),hex(section["addr"])))
    f.write((section["size"]).to_bytes(2,byteorder="little",signed=False))
    f.write((section["addr"]).to_bytes(4,byteorder="little",signed=False))
    f.write((section["type"]).to_bytes(1,byteorder="little",signed=False))
    f.write((section["off"]).to_bytes(2,byteorder="little",signed=False))

if offsetPadding:
    f.write((0).to_bytes(1,byteorder="little",signed=False))

# Write the section content
#Cycle through the sections
for section in sections:
    
    #Section has data
    if(section["type"]>0):

        #Output the hex content of the binary
        subprocess.run([objcopy,'-O', 'binary', '--only-section='+section["name"], 'appWithNoMetadata.out', "hex"+section["name"]+'.tmp'],stdout=subprocess.PIPE)
        with open("hex"+section["name"]+'.tmp', "rb") as data:
            f.write(data.read())
            if section["size"]%2>0:
                f.write((0).to_bytes(1,byteorder="little",signed=False))
        if not debugFiles:
            os.remove("hex"+section["name"]+'.tmp')
f.close()



#Compute bytes size of file
fileSizeBytes =int(os.stat("tmpElf.tmp").st_size) 
fileSize = hex(fileSizeBytes)

#check whether application is compatible, i.e. small enough
if fileSizeBytes > 32768:
    print("File too big: {} Bytes".format(fileSizeBytes))
    exit(1)
else:
    print("File is '{}' Bytes ({})".format(fileSizeBytes,fileSize))


# Write file size
outputFile.write((fileSizeBytes).to_bytes(2,byteorder="big",signed=False))
with open("tmpElf.tmp", "rb") as elfFile:
    outputFile.write(elfFile.read())

outputFile.close()

if not debugFiles:
    os.remove("tmpElf.tmp")
