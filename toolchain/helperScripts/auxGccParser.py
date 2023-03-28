#    Author: Michele Grisafi
#    Email: michele.grisafi@unitn.it
#    License: MIT 
################################################
# This script iterates over the assembly code of
# an application and performs some operations 
# with its absolute addresses. For instance:
# - Format the files to assembly standard
# - Locates the relevant functions and labels, 
#   renaming them so that they can be compiled
# - Replaces all of the jumps offsets, branches 
#   arguments and calla destinations with the 
#   correct label so that they can be rilocated
# NB: use either a cleaned input file (only asm
# code) or having at most the objdump metadata
################################################
import sys,re,logging,os, subprocess

#The following must be syncrhonised with the rest of the PISTIS scripts
bottomCode = 0x4400
topCode = 0xc3fe

# convert any "mov #..., pc" to a jump for better efficiency
MOVA_TO_JUMP = True 

if len(sys.argv) != 3:
    print("The number of arguments is inappropriate.\nCorrect syntax is: python {} [dst] [counter]".format(sys.argv[0]))
    exit(1)

globalCounter = sys.argv[2]

logging.basicConfig(stream=sys.stderr, level=logging.WARNING)

#Set of labels in the assembly file
labels = []

#Set of functions in the assembly file
functions = []

# Retrieve the name of the label for a certain address
def getLabel(address):
    i = 0

    #Cycle through the labels
    for label in labels:

        #A registered label matches with the address
        if label["address"] == address:

            #Tag the label as used
            labels[i]["used"] = True

            #return the name of the label
            return label["name"]
        i+=1
    i = 0

    #Cycle through the functions
    for function in functions:

        #A function address matches the address
        if function["address"] == address:

            #Tag the function as used
            functions[i]["used"] = True

            #Return the function name
            return function["name"]
        i+=1

#Check whether the label name was used
def wasUsed(labelName):

    #Cycle the various program labels
    for label in labels:

        #The label was found
        if label["name"] == labelName:

            #Return whether it was used or not
            return label["used"]
    
    #The label was not found, so something went wrong
    logging.error("Label {} not found".format(labelName))
    exit(1)          



#emptyLine = re.compile("^\n")
#uselessLabel = re.compile("0000[0-9a-f]{4}\s<\.L(?!\d).*>:\n")
#usefulLabel = re.compile("0000([0-9a-f]{4})\s<(\.L\d+[\^\w]*)\>:\n")

#Define some label patterns
tempLabel = re.compile("0000([0-9a-f]{4})\s<(\.L.*|L0\^.*)\>:\n")
functionLabel = re.compile("0000([0-9a-f]{4})\s<((?!\.).*)>:\n")

#Instruction prefix pattern
instructionPrefix = re.compile("^(\t| {4})[0-9a-f]{4}:\t([0-9a-f]{2}\s)*\s*")

#Define pattern for new labels
newLabel = re.compile("(\.L\d*):\n")

#Patterns for some assembly instructions
jmpInstruction      = re.compile("j[a-z]*\s(\$[-+\w]*)\s*;abs\s0x0*([0-9a-f]{4})\n?")
movaInstruction     = re.compile("mova?\s*#(\d+),\s*(r0|pc|PC)\s*;0x0*([0-9a-f]{4})\n?")
callaInstruction    = re.compile("calla?\s+#(\d+)\s*;0x0*([0-9a-f]{4})\n?")
dynamicCall         = re.compile("calla?\s+r\d\d?")
dynamicCallPreface  = re.compile("\s(mova|movx|mov)(.w)?\s#(\d+),\sr\d{1,2}\s;\s*0x0*([0-9a-f]{4})\n")


#Patterns for cleaning.
intestation     = re.compile("file format elf32-msp430")
sectionHeader   = re.compile("Disassembly of section")
emptyLines      = re.compile("^\s*$")




############### START ##################
def startParsing(outputFile,counter):
    inputFile = "code.tmp"
    ## Extract the code from the application
    os.system("../toolchain/compiler/msp430-gcc-9.2.0.50_linux64/bin/msp430-elf-objdump -D -z -j .text -j .lower.text appWithNoMetadata.out > code.tmp")

    #result = subprocess.run(['../toolchain/compiler/msp430-gcc-9.2.0.50_linux64/bin/msp430-elf-objdump','-D','-z','-j','.text','-j','.lower.text','appWithNoMetadata.out','>','code.tmp'],shell=True,executable='/bin/bash',capture_output=True)
    os.system("../toolchain/compiler/msp430-gcc-9.2.0.50_linux64/bin/msp430-elf-objdump -D -z -j .appText appWithNoMetadata.out > code2.tmp")
    
    #NEW added parsing of the .appText section to fetch the labels and functions
    input = open("code2.tmp", 'r')
    line = input.readline()
    counter = 0
    lineCount = 1
    newFile = ""
    while line:
        #Temporary label was found
        if (match := tempLabel.search(line)):
            # Add entry to dictionary of labels
            labels.append({"name":match.group(2),"address":match.group(1),"used":False})

        #Label for function found
        elif (match:=functionLabel.search(line)):
            #Register function name in our list
            functions.append({"name":match.group(2),"address":match.group(1)})
        line = input.readline()

    print("appText Labels: {}".format(labels))

    input.close()

    # Replace Labels to make them incremental, and replace functions 
    # Clean the file, removing extra strings generated by objdump
    input = open(inputFile, 'r')
    output = open(outputFile, 'w')
    line = input.readline()

    counter = 0
    lineCount = 1
    newFile = ""
    while line:
        newEntry = line
        
        #Metadata found
        if (intestation.search(newEntry) or sectionHeader.search(newEntry)):
            
            #Remove the line
            newEntry = ""


        #Temporary label was found
        elif (match := tempLabel.search(newEntry)):

            #Create new incremental label
            newEntry = ".LPISTIS"+str(globalCounter)+str(counter) + ":\n"

            # Add entry to dictionary of labels
            labels.append({"name":".LPISTIS"+str(globalCounter)+str(counter),"address":match.group(1),"used":False})
            counter+=1

        #Label for function found
        elif (match:=functionLabel.search(newEntry)):
            
            #Insert declaration of function. NOP slides added with new compilation
            newEntry = "\n\n\t.global {}\n\t.type {}, @function\n".format(match.group(2),match.group(2))
            newEntry += match.group(2) + ":\n"#":\n\tnop\n\tnop\n"

            #Register function name in our list
            functions.append({"name":match.group(2),"address":match.group(1)})
        
        #Instruction prefix found
        elif(match:= instructionPrefix.search(newEntry)):

            #Remove the prefix
            newEntry = newEntry.replace(match.group(0),"")
            if (len(newEntry)>1):
                newEntry = "\t"+newEntry
        
        #Dynamic call found
        if(match := dynamicCall.search(newEntry)):
            print("Possible optimisation with {} found".format(match.group(0)))

        #Print line in the new file
        newFile +=newEntry
        lineCount += 1
        line = input.readline()
    input.close()
    if not ( match := emptyLines.search(newFile)):
        output.write(newFile)
    output.close()

    #Created first temporary file with intermediary data
    os.rename(outputFile,"output2.tmp")


    ############################################### Replace jumps, mova and calla location with labels
    
    input = open("output2.tmp", 'r')
    output = open(outputFile, 'w')
    line = input.readline()
    newFile = ""



    #Cycle through the lines of the previous file
    #Replace each target address with labels
    while line:
        label = None
        newEntry = line

        #It's a jump 
        if (match := jmpInstruction.search(newEntry)):

            #Look for the target address among the saved labels
            addressToSearch = match.group(2)
            label=getLabel(addressToSearch)

            #No label corresponding to the jump --> program to be rejected
            if(label is None):
                logging.error("Label/Functon Address {} not found for line {}".format(addressToSearch,newEntry))
                exit(1)
            
            #Replace address with label
            newEntry = newEntry.replace(match.group(1),label)

        #It's a mova to PC
        elif (match := movaInstruction.search(newEntry)):

            #Repeat the search for the address in the set of labels
            addressToSearch = match.group(3)
            label = getLabel(addressToSearch)
            if(label is None):
                logging.error("Label/Functon Address {} not found".format(addressToSearch))            
                exit(1)
            
            #Optimisation to convert in jump (could fail sometime due to big offsets!)
            if MOVA_TO_JUMP:
                newEntry = "\tjmp {}\t;{}".format(label,match.group(0))
            else:
                newEntry = newEntry.replace(match.group(1),label)

        #Calla instruction
        elif (match := callaInstruction.search(newEntry)):

            #Repeat the search for the target in the saved labels
            addressToSearch = match.group(2)
            label = getLabel(addressToSearch)
            if(label is None):
                logging.error("Label/Functon Address {} not found".format(addressToSearch))
                exit(1)
            newEntry = newEntry.replace(match.group(1),label)

        newFile +=newEntry
        line = input.readline()

    input.close()
    if not ( match := emptyLines.search(newFile)):
        output.write(newFile)
    output.close()
    os.rename(outputFile,"output2.tmp")



    ################## FIX Dynamic calls with registers
    # Dynamic calls store the address of a function in a register. 
    # This address must be translated from absolute to the function name
    input = open("output2.tmp", 'r')
    output = open(outputFile, 'w')
    line = input.readline()
    newFile = ""

    #Cycle through the new temporary file
    while line:
        label = None
        newEntry = line

        #It's a dynamic call preface to fill a register with an address
        if (match := dynamicCallPreface.search(newEntry)):
            
            #Get absolute value (the target)
            absValue = match.group(4)

            #Check whether it can be replaced with a label
            label = getLabel(absValue)
            if(label is not None):
                newEntry = newEntry.replace(match.group(3),label)
        newFile +=newEntry
        line = input.readline()

    input.close()
    if not ( match := emptyLines.search(newFile)):
        output.write(newFile)
    output.close()
    os.rename(outputFile,"output2.tmp")


    ################## Remove useless labels that where not jumped to
    input = open("output2.tmp", 'r')
    output = open(outputFile, 'w')
    line = input.readline()
    counter = 0
    newFile = ""

    #Cycle through the new temporary file
    while line:
        newEntry = line

        #Label found
        if (match := newLabel.search(newEntry)):
            
            #It was not used
            if (not wasUsed(match.group(1))):
                newEntry = ""
        newFile +=newEntry
        line = input.readline()
    input.close()
    if not (match := emptyLines.search(newFile)):
        output.write(newFile)
    output.close()


    os.remove("output2.tmp")



startParsing(sys.argv[1],globalCounter)