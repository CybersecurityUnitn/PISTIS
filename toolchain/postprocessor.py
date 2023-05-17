#    Author: Michele Grisafi
#    Email: michele.grisafi@unitn.it
#    License: MIT 
import sys,re,logging, os

# set to false to support external gcc libraries (which use reserved registries).
# Set it to true if we use patched libraries 
# NB: This does not compromise the security since we have the verifier!
RESERVED_REGISTER_CHECK = True 

# replaces CALLA and RETA with CALL and RET. CALL and RET are less expensive when instrumented
REPLACE_ADDR_INSTR = True 

if len(sys.argv) < 2:
    print("The number of arguments is inappropriate.\nCorrect syntax is: python {} debug=[1|0] asmFiles.s ....".format(sys.argv[0]))
    exit(1)


if sys.argv[1] == "1":
    print("Debug session")
    logging.basicConfig(stream=sys.stderr, level=logging.DEBUG)
else:
    logging.basicConfig(stream=sys.stderr, level=logging.ERROR)


reject = 0

### The following address must be synchronised with the linker script.
bottomInstructionMemory   = 0x4400
topInstructionMemory      = 0xc3ff

# Check wheter the given address is contained between the bottom and top addresses
#PARAMS:
#-add: address to be checked
#-bottom: bottom boundary address
#-top: top boundary address
#-bits: bits of the address (16 or 20)
#RETURN: 1 if the address respects the boundaries, 0 otherwise
def checkAddress(add,bottom,top,bits):
    res = 0

    #Trim spaces
    add=add.replace(' ','')
    add=add.replace('\t','')
    logging.debug("Add is "+add)
    
    #Check sign
    sign=""
    if(add[0] == "-" or add[0] == "+"):
        sign = add[0]
        add = add[1:]
    oldAdd = add

    #Number of hex character required for the current bits length
    bits = int(int(bits)/4) 

    #it's hex
    if(add[-1] == 'h'): 
        #Remove trailing h
        add = str(add[:-1])
    
    #it's hex
    elif(add[0:2] == '0x'):
        #Remove leading 0x
        add = str(add[2:])
    
    #it's decimal
    else: 
        #Convert to hex
        add = str(hex(int(add)))[2:]

    #If the length of add (number of HEX digits) is bigger than the bits to be removed
    if(len(add) > bits):
        #Remove the first exceding bytes (leading 0?)
        add = add[len(add)-bits:]
    
    #Convert to address
    add = int(sign+"0x"+add,16)

    #Check if within boundaries    
    if add >= bottom and add <= top:
        res = 1
    
    return res


#Convert number to decimal notation (if it's already in decimal notation then simply return it)
#param:
# - number: string containing the number
def hexToDec(number):
    if(number[:2] == "0x"):
        return int(number[2:],16)
    if(number[-1:] == "h"):
        return int(number[:-1],16)
    return int(number)



# Address regex used inside the rest of the functions
adRe = "((-|\+)?\s*(0x[\da-f]+|[\da-f]+h|\d+))"
#TODO: increase compatibility of the postprocessor by allowing also the use of the '+' and '-' operands to modify the address. 
# This is not strictly required since false positives here will for sure be rejected at verification time.

###  EXECUTION CONTROL ####
# Only take care of static addresses. Absolute version read protection not implemented.
# We do not take care of aliases of the PC. They will be rejected anyway
staticBr        = re.compile('BRA?\s+(#)\s*{}\s+'.format(adRe),re.I)
staticCall      = re.compile('CALLA?\s+(#)\s*{}\s+'.format(adRe),re.I)
staticMovPc     = re.compile('MOV(.W)?\s+(#)\s*{}\s*,\s*(R0|PC)\s+'.format(adRe),re.I)
staticMovBPc    = re.compile('MOV.B\s+(#)\s*{}\s*,\s*(R0|PC)\s+'.format(adRe),re.I)
staticMovaPc    = re.compile('MOVA\s+(#)\s*{}\s*,\s*(R0|PC)\s+'.format(adRe),re.I)
staticMovxPc    = re.compile('MOVX(.W)?\s+(#)\s*{}\s*,\s*(R0|PC)\s+'.format(adRe),re.I)
staticMovxBPc   = re.compile('MOVX.B\s+(#)\s*{}\s*,\s*(R0|PC)\s+'.format(adRe),re.I)
staticMovxAPc   = re.compile('MOVX.A?\s+(#)\s*{}\s*,\s*(R0|PC)\s+'.format(adRe),re.I)

### WRITE CONTROL ###
#Math operations (+ and -) are not included because if they are used to elude the rejection the Verifier will reject the image.
fctl3Re = "((&\s*(FCTL3|0x0*144|0*144h|324))|FCTL3)" 
unlockMemory = re.compile("(((XOR|ADD|ADDC|DADD|SUB|SUBC|MOV)X?(.W)?\s+\S+\s*,)|POP)\s*{}\s+".format(fctl3Re),re.I)
indirectPcAccess = re.compile("(((INCDA?|INV|SWPB|SXT)X?(.W|.B)?)|((ADDA?|ADDC|AND|BIC|BIS|DADD|SUBA?|SUBC|XOR)X?(.W)?\s+\S+\s*,))\s*(PC|R0)\s+",re.I)
popToPc = re.compile("POPM(\.(W|A))?\s+((#(0x)?2h?\s*,\s*(SP|R1))|(#(0x)?1h?\s*,\s*(R0|PC)))\s+",re.I) 


### RESERVED REGISTER CONTROL ###
reservedReg = re.compile("^(?!(\s*;)).*R(4|5|6)",re.I) #use of reserved register outside of comments


curlyBracket = re.compile("{\s?",re.I)
commentRemover = re.compile(";.*",re.I)

### REMOVE ALL COMMENTS FROM THE FILE SO THAT WE CAN PERFORM THE RIGHT MODIFICATIONS

#Cycle through the source files
for f in sys.argv[2:]:
    inputName = f
    input = open(inputName, 'r')
    logging.debug("Parsing file {} removing all comments".format(inputName))
    modifiedMain = open(inputName+".tmp", 'w')

    line = input.readline()

    #Cycle through the lines
    while line:    
        newEntry = line

        #Replace the comments with empty strings
        newEntry = re.sub(commentRemover,"",line)

        modifiedMain.write(newEntry)
        line = input.readline()
    
    #Overwrite file
    os.rename(inputName+".tmp",inputName)

### Replace all curly brackets with new lines, necessary for the correct functioning of the program. 
#   Only by removing the comments we ensure that the exclusively the real curly brackets get replaced

#Cycle through the source files
for f in sys.argv[2:]:
    inputName = f
    input = open(inputName, 'r')
    logging.debug("Parsing file {} replacing curly bracket symbols with tab and new line".format(inputName))
    modifiedMain = open(inputName+".tmp", 'w')

    line = input.readline()

    #Cycle through the lines
    while line:    
        newEntry = line
        
        #Move assembly after curly brackets in new lines
        newEntry = re.sub(curlyBracket,"\n\t",line)

        modifiedMain.write(newEntry)
        line = input.readline()
    
    #Overwrite file
    os.rename(inputName+".tmp",inputName)

######################## REPLACE INSTRUCTIONS #################
### Replace all of the PUSHM.W/A with the normal mode. 
# This is required because we cannot emulate the original instruction. 
# In fact, we would need to save the name of the register rather than some content.
regPushm = re.compile("PUSHM(.W)?\s+#((0*([1-9]|1[0-6]))|(0x0*([1-9]|[abcdef]|10))|(0*([1-9]|[abcdef]|10))h)\s*,\s*(R(\d{1,2})|PC|SP|SR)",re.I)
regPushma = re.compile("PUSHM.A\s+#((0*([1-9]|1[0-6]))|(0x0*([1-9]|[abcdef]|10))|(0*([1-9]|[abcdef]|10))h)\s*,\s*(R(\d{1,2})|PC|SP|SR)",re.I)

# CALLA and RETA regex
callaInstr = re.compile("^\s*(CALLA)\s+",re.I)
retaInstr = re.compile("^\s*(RETA)\s+",re.I)


def replacePushm(toBeReplaced):
    logging.debug(toBeReplaced.group(0) + "-" + toBeReplaced.re.pattern)
    
    # Fetch the top register of the pushm
    topReg = toBeReplaced.group(10)

    # Check whether the top reg is a special register
    if (topReg is None):
        if(toBeReplaced.group(9).lower() == "pc"):
            topReg = 0
        elif(toBeReplaced.group(9).lower() == "sp"):
            topReg = 1
        elif(toBeReplaced.group(9).lower() == "sr"):
            topReg = 2
    else:
        topReg = int(topReg)
    
    #Check the number of register to be pushed
    numOfRegs = hexToDec(toBeReplaced.group(2))
    string = ""

    #Compute the registers that are pushed and insert the individual PUSH instructions
    while(topReg>=0 and numOfRegs > 0):
        string+="PUSH R{}\n\t".format(topReg)
        topReg -= 1
        numOfRegs -= 1
    logging.debug("Old PUSHM:\n {}, new PUSHM: \n {}".format(toBeReplaced.group(0),string))
    return string


#Same as above instruction
def replacePushma(toBeReplaced):
    logging.debug(toBeReplaced.group(0) + "-" + toBeReplaced.re.pattern)
    if (toBeReplaced.group(9) is None):
        if(toBeReplaced.group(8).lower() == "pc"):
            topReg = 0
        elif(toBeReplaced.group(8).lower() == "sp"):
            topReg = 1
        elif(toBeReplaced.group(8).lower() == "sr"):
            topReg = 2
    else:
        topReg = int(toBeReplaced.group(9))
    
    numOfRegs = hexToDec(toBeReplaced.group(1))
    string = ""
    while(topReg>=0 and numOfRegs > 0):
        string+="\tPUSHX.A R{}\n".format(topReg)
        topReg -= 1
        numOfRegs -= 1
    logging.debug("Old PUSHMA: \n {}, new PUSHMA:\n {}".format(toBeReplaced.group(0),string))
    return string


#Cycle through the source files
for f in sys.argv[2:]:
    inputName = f
    input = open(inputName, 'r')
    logging.debug("Parsing file {} replacing PUSHM instructions".format(inputName))
    modifiedMain = open(inputName+".tmp", 'w')

    line = input.readline()
    while line:    
        newEntry = line

        #Replace the pushm, pushma,  instructions
        # TODO:CALLA and RETA are not replaced because tehy mess up the stack: we need to replace them when we are still using labels, not addresses --> use -msmall in the makefile to use them, but then we need to fix the libraries. 
        if(regPushm.search(line)):
            newEntry = re.sub(regPushm,replacePushm,line)
        elif(regPushma.search(line)):
            newEntry = re.sub(regPushma,replacePushma,line)
        """ elif(match := callaInstr.search(line)):
            if (REPLACE_ADDR_INSTR):
                logging.debug("Found CALLA")
                newEntry = re.sub(match.group(1),"CALL",line)
        elif(match := retaInstr.search(line)):
            if (REPLACE_ADDR_INSTR):
                logging.debug("Found RETA")
                newEntry = re.sub(match.group(1),"RET",line) """
        modifiedMain.write(newEntry)
        line = input.readline()
    
    #Overwrite file
    os.rename(inputName+".tmp",inputName)

#####################################
# Insert the NOP slides
#####################################
callInstruction = re.compile("CALLA?\s+\S*\s*",re.I)
functionInstruction = re.compile("@function\n(\_|\w|\d)*:\n",re.I|re.M)

for f in sys.argv[2:]:
    inputName = f
    input = open(inputName, 'r')
    logging.debug("Parsing file {} adding NOP slides after CALL instructions".format(inputName))
    modifiedMain = open(inputName+".tmp", 'w')

    file_contents = input.read()
    modified_content = re.sub(callInstruction,lambda x: x.group(0) + "\t; NOP slide!\n\tNOP\n\tNOP\n\t; End NOP slide\n\t",file_contents)
    
    #TODO: Only insert the NOP slide if there are dynamic calls. Otherwise, it is useless because the function will always be called with a static call (that does not check for the NOP slide)
    modified_content = re.sub(functionInstruction,lambda x: x.group(0) + "\t; NOP slide!\n\tNOP\n\tNOP\n\t; End NOP slide\n\t",modified_content)
    
    modifiedMain.write(modified_content)
    
    input.close()
    modifiedMain.close()
    #Overwrite file
    os.rename(inputName+".tmp",inputName)





# Verify the file for some forbidden operation

for f in sys.argv[2:]:
    inputName = f
    input = open(inputName, 'r')
    logging.debug("Parsing file {} for illegal instructions".format(inputName))

    cnt = 1
    line = input.readline()
    #Cycle through the code and set reject to 1 if anything wrong is detected!
    while line:
        if (RESERVED_REGISTER_CHECK):
            match = reservedReg.search(line)
            ### RESERVED REGISTER CONTROL ###
            if(match):
                logging.debug("Reserved register used #{}: '{}'".format(cnt,match.group(0)))
                reject=1
                break
        
        ### INDIRECT ACCESS TO PC ###
        if(match := indirectPcAccess.search(line)):
            logging.debug("Indirect access to PC #{}: '{}'".format(cnt,match.group(0)))
            reject=1
            break
        
        ### POPM to PC ####
        elif(match := popToPc.search(line)):
            logging.debug("POPM to PC #{}: '{}'".format(cnt,match.group(0)))
            reject=1
            break
        ######  BR + BRA checks #######
        
        elif(match := staticBr.search(line)):
            if(match.group(2) != "0xfe3e" and not checkAddress(match.group(2),bottomInstructionMemory,topInstructionMemory,20)): #BR won't allow more than 16 bits
                #Either jump to forbidden area or read from bootloader
                logging.debug("Violating memory isolation with a BR/BRA #{}: '{}'".format(cnt,match.group(0)))
                reject = 1
                break
        
        ######  CALL + CALLA checks #######
        
        elif(match := staticCall.search(line)):
            if( not checkAddress(match.group(2),bottomInstructionMemory,topInstructionMemory,20)): #BR won't allow more than 16 bits
                #Either jump to forbidden area or read from bootloader
                logging.debug("Violating memory isolation with a CALL/CALLA #{}: '{}'".format(cnt,match.group(0)))
                reject = 1
                break

        
        elif(match := staticMovPc.search(line)):
            if(not checkAddress(match.group(3),bottomInstructionMemory,topInstructionMemory,16)):
                #Either jump to forbidden area or read from bootloader
                logging.debug("Violating memory isolation with a MOV #{}: '{}'".format(cnt,match.group(0)))
                reject = 1
                break
        
        
        elif(match := staticMovBPc.search(line)):
            if(not checkAddress(match.group(2),bottomInstructionMemory,topInstructionMemory,8)):
                #Either jump to forbidden area or read from bootloader
                logging.debug("Violating memory isolation with a MOV.B #{}: '{}'".format(cnt,match.group(0)))
                reject = 1
                break
        
        
        elif(match := staticMovaPc.search(line)):
            if(not checkAddress(match.group(2),bottomInstructionMemory,topInstructionMemory,20)):
                #Either jump to forbidden area or read from bootloader
                logging.debug("Violating memory isolation with a MOVA #{}: '{}'".format(cnt,match.group(0)))
                reject = 1
                break
        
        
        elif(match := staticMovxPc.search(line)):
            if(not checkAddress(match.group(3),bottomInstructionMemory,topInstructionMemory,16)):
                #Either jump to forbidden area or read from bootloader
                logging.debug("Violating memory isolation with a MOVX #{}: '{}'".format(cnt,match.group(0)))
                reject = 1
                break

        
        elif(match := staticMovxBPc.search(line)):
            if(not checkAddress(match.group(2),bottomInstructionMemory,topInstructionMemory,8)):
                #Either jump to forbidden area or read from bootloader
                logging.debug("Violating memory isolation with a MOVX.B #{}: '{}'".format(cnt,match.group(0)))
                reject = 1
                break
        
        
        elif(match := staticMovxAPc.search(line)):
            if(not checkAddress(match.group(2),bottomInstructionMemory,topInstructionMemory,20)):
                #Either jump to forbidden area or read from bootloader
                logging.debug("Violating memory isolation with a MOVX.A #{}: '{}'".format(cnt,match.group(0)))
                reject = 1
                break

        
        elif(match := unlockMemory.search(line)):
            logging.debug("Unlocking the FLASH controller  #{}: '{}'".format(cnt,match.group(0)))
            reject = 1
            break


        cnt += 1
        line = input.readline()
    
    input.close()
    if reject:
        break
print(reject)