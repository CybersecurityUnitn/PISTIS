#    Author: Michele Grisafi
#    Email: michele.grisafi@unitn.it
#    License: MIT 
import sys,re,logging
from string import Template

if len(sys.argv) < 4:
    print("The number of arguments is inappropriate.\nCorrect syntax is: python {} src.s dst.s virtualLabel[0|1]".format(sys.argv[0]))
    exit(1)
logging.basicConfig(stream=sys.stderr, level=logging.ERROR)
inputName = sys.argv[1]
outputName = sys.argv[2]
logging.debug("Parsing file {} and creating file {}".format(inputName, outputName))
reject = 0

virtualLabel = int(sys.argv[3])

input = open(inputName, 'r')
modifiedMain = open(outputName, 'w')

# boundary addresses for the flash memory. These value needs to be modified accordingly
flashTopAdd = 0x243ff
flashBotAdd = 0x4400

##### COMMON PATTERNS #####
label = "((-|\+)?\s*(?!(\s*R(1[0-5]|[0-9])|PC|SR|SP))(\.?\w(\w|\.)*))"
address = "((-|\+)?\s*(0x[\da-f]+|[\da-f]+h|\d+))"
mathOp = "(\s*((-|\+)\s*(0x[\da-f]+|[\da-f]+h|\d+)))*" #operands can be incremented and drecremented!

### Addressing modes ###
# We split the regex in modules so that we can later refer to the single modules more easily
# Any modification to the following regex might require further modification in the execReplace group counting
regMode = "(R(1[0-5]|[0-9])|PC|SR|SP)" 

offsetPart_IndexMode="(({}|{}){})".format(address,label,mathOp) 
registerPart_IndexMode="(R(1[0-5]|[13-9]))"
indexMode = "(\s?{}\s*\(\s*{}\s*\))".format(offsetPart_IndexMode,registerPart_IndexMode) 

registerPart_IndrectMode="(R\d\d?)"
indirectMode = "(@\s*{}?\+?)".format(registerPart_IndrectMode)

offsetPart_SymbolicMode="(({}|{}){})".format(address,label,mathOp) 
symbolicMode= "({}(\s*\((R0|PC)\))?)".format(offsetPart_SymbolicMode)

normalSyntax="(&\s*(({}|{}){}))".format(address,label,mathOp)
registerSyntax="((({}|{}){})\s*\((R2|SR)\))".format(address,label,mathOp)
absoluteMode= "({}|{})".format(normalSyntax,registerSyntax) 

immediateMode= "(#\s*(({}|{}){}))".format(label,address,mathOp)


# The following expressions group the different modes on the base of the number of words they require
# Such functionality is not required if the WordCounting is not used (which is not). However, removing
# it requires a time consuming recomputation of the regular expressions indexes used in the following 
# functions. For this reason, such expressions are used with only a minimal impact on the performance
# of this script (which is not important).
plusOneMode = "({}|{}|{}|{})".format(indexMode,absoluteMode,immediateMode,symbolicMode)
plusOneModeNoImm = "({}|{}|{})".format(indexMode,absoluteMode,symbolicMode)
plusZeroMode = "({}|{})".format(regMode,indirectMode)


#TODO: Symbolic mode should not be accepted in write-only memory sections! Absolute mode as well

#############################  EXECUTION CONTROL  #####################
# Replace unsafe instructions. False positive here will reject the application --> try to avoid as many as possible
unsafeBr    = re.compile('BR\s+({}|{}|{}|{}|{})\s+'.format(regMode,indexMode,indirectMode,symbolicMode,absoluteMode),re.I)
unsafeBra   = re.compile('BRA\s+({}|{}|{}|{}|{})\s+'.format(regMode,indexMode,indirectMode,symbolicMode,absoluteMode),re.I)
unsafeMov   = re.compile('MOV(.W)?\s+({}|{}|{}|{}|{})\s*,\s*(PC|R0)\s+'.format(regMode,indexMode,indirectMode,symbolicMode,absoluteMode),re.I)
unsafeMovB  = re.compile('MOV.B\s+({}|{}|{}|{}|{})\s*,\s*(PC|R0)\s+'.format(regMode,indexMode,indirectMode,symbolicMode,absoluteMode),re.I)###
unsafeMova  = re.compile('MOVA\s+({}|{}|{}|{}|{})\s*,\s*(PC|R0)\s+'.format(regMode,indexMode,indirectMode,symbolicMode,absoluteMode),re.I)
unsafeMovx  = re.compile('MOVX(.W)?\s+({}|{}|{}|{}|{})\s*,\s*(PC|R0)\s+'.format(regMode,indexMode,indirectMode,symbolicMode,absoluteMode),re.I)
unsafeMovxB = re.compile('MOVX.B\s+({}|{}|{}|{}|{})\s*,\s*(PC|R0)\s+'.format(regMode,indexMode,indirectMode,symbolicMode,absoluteMode),re.I)
unsafeMovxA = re.compile('MOVX.A\s+({}|{}|{}|{}|{})\s*,\s*(PC|R0)\s+'.format(regMode,indexMode,indirectMode,symbolicMode,absoluteMode),re.I)
unsafeCall  = re.compile('CALL\s+({}|{}|{}|{}|{})\s+'.format(regMode,indexMode,indirectMode,symbolicMode,absoluteMode),re.I)
unsafeCalla = re.compile('CALLA\s+({}|{}|{}|{}|{})\s+'.format(regMode,indexMode,indirectMode,symbolicMode,absoluteMode),re.I)
unsafeRet   = re.compile('RET\s+',re.I)
unsafeReti  = re.compile('RETI\s+',re.I)
unsafeReta  = re.compile('RETA\s+',re.I)

#print(unsafeBr.pattern)
#############################  WRITE CONTROL  ##################### 
# Replace unsafe instructions. False positive here will reject the application --> try to avoid as many as possible
writeMov    = re.compile("MOV(.W)?\s+({}|{})\s*,\s*({}|{})\s+".format(plusOneMode,plusZeroMode,plusOneModeNoImm,indirectMode),re.I)
writeMovx   = re.compile("MOVX(.W)?\s+({}|{})\s*,\s*({}|{})\s+".format(plusOneMode,plusZeroMode,plusOneModeNoImm,indirectMode),re.I)
writeXor    = re.compile("XOR(.W)?\s+({}|{})\s*,\s*({}|{})\s+".format(plusOneMode,plusZeroMode,plusOneModeNoImm,indirectMode),re.I)
writeXorx   = re.compile("XORX(.W)?\s+({}|{})\s*,\s*({}|{})\s+".format(plusOneMode,plusZeroMode,plusOneModeNoImm,indirectMode),re.I)
writeAdd    = re.compile("ADD(.W)?\s+({}|{})\s*,\s*({}|{})\s+".format(plusOneMode,plusZeroMode,plusOneModeNoImm,indirectMode),re.I)
writeAddx   = re.compile("ADDX(.W)?\s+({}|{})\s*,\s*({}|{})\s+".format(plusOneMode,plusZeroMode,plusOneModeNoImm,indirectMode),re.I)
writeAddc   = re.compile("ADDC(.W)?\s+({}|{})\s*,\s*({}|{})\s+".format(plusOneMode,plusZeroMode,plusOneModeNoImm,indirectMode),re.I)
writeAddcx  = re.compile("ADDCX(.W)?\s+({}|{})\s*,\s*({}|{})\s+".format(plusOneMode,plusZeroMode,plusOneModeNoImm,indirectMode),re.I)
writeDadd   = re.compile("DADD(.W)?\s+({}|{})\s*,\s*({}|{})\s+".format(plusOneMode,plusZeroMode,plusOneModeNoImm,indirectMode),re.I)
writeDaddx  = re.compile("DADDX(.W)?\s+({}|{})\s*,\s*({}|{})\s+".format(plusOneMode,plusZeroMode,plusOneModeNoImm,indirectMode),re.I)
writeSub    = re.compile("SUB(.W)?\s+({}|{})\s*,\s*({}|{})\s+".format(plusOneMode,plusZeroMode,plusOneModeNoImm,indirectMode),re.I)
writeSubx   = re.compile("SUBX(.W)?\s+({}|{})\s*,\s*({}|{})\s+".format(plusOneMode,plusZeroMode,plusOneModeNoImm,indirectMode),re.I)
writeSubc   = re.compile("SUBC(.W)?\s+({}|{})\s*,\s*({}|{})\s+".format(plusOneMode,plusZeroMode,plusOneModeNoImm,indirectMode),re.I)
writeSubcx  = re.compile("SUBCX(.W)?\s+({}|{})\s*,\s*({}|{})\s+".format(plusOneMode,plusZeroMode,plusOneModeNoImm,indirectMode),re.I)
writePop    = re.compile("POP(.W)?\s+({}|{})\s+".format(plusOneModeNoImm,indirectMode),re.I)
writePopx   = re.compile("POPX(.W)?\s+({}|{})\s+".format(plusOneModeNoImm,indirectMode),re.I)
writePush   = re.compile("PUSH(.W)?\s+({}|{})\s+".format(plusOneMode,plusZeroMode),re.I)
writePushx  = re.compile("PUSHX(.W)?\s+({}|{})\s+".format(plusOneMode,plusZeroMode),re.I)
# Emulated ones
writeRlax   = re.compile("RLAX(.W)?\s+({}|{})\s+".format(plusOneMode,plusZeroMode),re.I)
writeRlcx   = re.compile("RLCX(.W)?\s+({}|{})\s+".format(plusOneMode,plusZeroMode),re.I)
writeAdcx   = re.compile("ADCX(.W)?\s+({}|{})\s+".format(plusOneMode,plusZeroMode),re.I)
#print(writeMov.pattern)

## Function for retrieving the current paranthesis count
## Params:
## - pattern: the regex pattern used
## - mode: the regex pattern for the addressing mode used (one of the ones specified above)
## - src: whether we are interested in the src or dst operand
## - syntax: a first nested layer. Use this to specify an additional nested part of the regex you are interested in. 
##           This argument is a regular expression --> use the small reg used to build the addressing mode. 
##           Eg: offsetPart_SymbolicMode for the symbolic mode.
## - label: a second nested layer. Use this to specify an third nested part of the regex you are interested in.  
##          This argument is a regular expression --> use the small reg used to build the addressing mode. 
##          Eg: 'address' of the 'normalSyntax' (syntax argument) for the absolute mode 
def getOffsetMode(pattern,mode,src=False,syntax=None,label=None):
    initialParenthesis = 0
    if (label is not None and label[0] == "(") or (label is None and syntax is not None and syntax[0] == "(") or (label is None and syntax is None and mode[0] == "("):
        initialParenthesis = 1
    
    #Synax 
    syntaxParenthesis = 0

    #Label
    labelParanthesis = 0

    if syntax is not None:
        if label is not None:
            labelParanthesis = syntax[0:syntax.find(label)].replace("\(","").replace("(?!","").count("(")
        syntaxParenthesis = mode[0:mode.find(syntax)].replace("\(","").replace("(?!","").count("(") + labelParanthesis
        #logging.warning("Syntax parenthesis = {} with label {}.".format(syntaxParenthesis,labelParanthesis))


    if(src is True):
        substr = pattern[0:pattern.find(mode)]
        substr = substr.replace("\(","").replace("(?!","") #Remove real parenthesis and negative lookahead
        return substr.count("(") + syntaxParenthesis + initialParenthesis

    else:
        modeTmp = mode.replace("\(","").replace("(?!","").count("(")
        substr = pattern.replace(mode,"",1)
        substr = substr[0:substr.find(mode)]
        substr = substr.replace("\(","").replace("(?!","") #Remove real parenthesis
        return substr.count("(") + modeTmp + syntaxParenthesis + initialParenthesis

#### TCM ####
# In order to reduce the number of rejection we choose addresses that might be interpreted as AND instructions.
# AND, in fact, is always allowed on anything but the PC --> avoid [f|_|0___|0]
# Since we are linking the application files together with the TCM, we can use labels
safe_br     = "safe_br_fun"
safe_bra    = "safe_bra_fun"
safe_call   = "safe_call_fun"
safe_calla  = "safe_calla_fun"
safe_ret    = "safe_ret_fun"
safe_reti   = "safe_reti_fun"
safe_reta   = "safe_reta_fun"

write_mov   = "write_mov_fun"
write_movx  = "write_movx_fun"
write_xor   = "write_xor_fun"
write_xorx  = "write_xorx_fun"
write_add   = "write_add_fun"
write_addx  = "write_addx_fun"
write_addc  = "write_addc_fun"
write_addcx = "write_addcx_fun"
write_dadd  = "write_dadd_fun"
write_daddx = "write_daddx_fun"
write_sub   = "write_sub_fun"
write_subx  = "write_subx_fun"
write_subc  = "write_subc_fun"
write_subcx = "write_subcx_fun"

secure_update= "receiveUpdate"

#If the virtual labels should not be used, use absolute addresses (to be synched!)
if(virtualLabel == 0):
    safe_br     = 0xfc00
    safe_bra    = 0xfc26
    safe_call   = 0xfc4c
    safe_calla  = 0xfc72
    safe_ret    = 0xfc98
    safe_reti   = 0xfcc0
    safe_reta   = 0xfd08

    write_mov   = 0xfd30
    write_movx  = 0xfd42
    write_xor   = 0xfd56
    write_xorx  = 0xfd68
    write_add   = 0xfd7c
    write_addx  = 0xfd8e
    write_addc  = 0xfda2
    write_addcx = 0xfdb4
    write_dadd  = 0xfdc8
    write_daddx = 0xfdda
    write_sub   = 0xfdee
    write_subx  = 0xfe00
    write_subc  = 0xfe14
    write_subcx = 0xfe26

    secure_update= 0xfe3e



# The pointer, or registers, used to store the different temp data during the verification process
store_dst_pointer = "R6"
store_src_pointer = "R5"
store_sr_pointer = "R4"

# Evaluate final address, combination of index and math operations
def replaceAddressH(match):
    return "0x"+match.group(1)

hAddress = "([\da-f]+)h"
def evalAddress(string):
    return(eval(re.sub(hAddress,replaceAddressH,string,flags=re.IGNORECASE)))

#Constants
NONE=0
WORD = 1
ADDRESS = 2
EXTENDED=3
EXTENDED_ADDRESS=4
BYTE=5
EXTENDED_BYTE=6



# Function to replace an unsafe execution instruction (e.g. br or call)
# Params:
# - match: the matched regular expression containing the unsafe instruction
# - labelToCall: the label, or address, at which the safe function to be called can be found
# - mode: the type of operations, having word, address, extended, ....
# - offset: offset to be used in the regular expression. If (.w) is present then it should be 1
# RETURN: new lines with the safe operations
def execReplace(match,labelToCall,mode=0,offset=0):
    logging.debug("Dynamic execution caught! {}".format(match.group(0)))
    #Check if it's absolute mode with an addresss
    
    if labelToCall is not safe_reta and labelToCall is not safe_ret and labelToCall is not safe_reti and match.group(getOffsetMode(match.re.pattern,absoluteMode,True)) is not None: 
        #Check the address and replace the instruction with a safe version only if it points to a write memory area
        #Retrieve math operations
        finalAdd = None
        if match.group(getOffsetMode(match.re.pattern,absoluteMode,True,normalSyntax,address)) is not None: #& syntax with address
            finalAdd = evalAddress(match.group(getOffsetMode(match.re.pattern,absoluteMode,True,normalSyntax)+1)) #contains only the address and the operations
        elif match.group(getOffsetMode(match.re.pattern,absoluteMode,True,registerSyntax,address)) is not None: #x(SR) syntax
            finalAdd = evalAddress(match.group(getOffsetMode(match.re.pattern,absoluteMode,True,registerSyntax)+1)) # group 54 contains only the address and the operations
        if(finalAdd is not None): # It's an address
            if (finalAdd <= flashTopAdd and finalAdd >= flashBotAdd): #It's in a read only area. ALLOW IT
                return match.group(0)

    newInstructions = Template(
        "\n\n; Old Instruction: $old\n"
        "\tMOV SR, $srPointer\n"
        "\tDINT\n\tNOP\n"
        "$mov"
        "\t$jump #$safeBr\n"
        ";End safe sequence\n\n"
    )
    #Check the type of instruction to replace it with the correct set of new instructions
    if(mode == NONE):
        newInstructions = Template(newInstructions.safe_substitute(mov=""))
    elif(mode == WORD):
        newInstructions = Template(newInstructions.safe_substitute(mov="\tMOV $dst, $dstPointer\n"))
    elif(mode ==EXTENDED):
        #newInstructions = "\n; Old Instruction: {}\n{}:\n\tPUSH SR\n\tDINT\n\tNOP\n\tMOV #{}, R15\n\tMOVX {}, 0(R15)\n\tBR #{}\n"
        newInstructions = Template(newInstructions.safe_substitute(mov="\tMOVX $dst, $dstPointer\n"))
    elif(mode ==EXTENDED_ADDRESS or mode == ADDRESS):
        newInstructions = Template(newInstructions.safe_substitute(mov="\tMOVX.A $dst, $dstPointer\n"))
    elif(mode ==BYTE):
        newInstructions = Template(newInstructions.safe_substitute(mov="\tMOV.B $dst, $dstPointer\n"))
        # Does not need to clear destination
        #newInstructions = Template(newInstructions.safe_substitute(mov="\tCLR $dstPointer\n\tMOV.B $dst, $dstPointer\n"))
    elif(mode ==EXTENDED_BYTE):
        # Does not need to clear destination
        #newInstructions = Template(newInstructions.safe_substitute(mov="\tCLR $dstPointer\n\tMOVX.B $dst, $dstPointer\n"))
        newInstructions = Template(newInstructions.safe_substitute(mov="\tMOVX.B $dst, $dstPointer\n"))

    #check whether it's a CALL so that we can allowing saving the PC on the stack before branching
    if(labelToCall == safe_call):
        jumpType="CALL"
    elif(labelToCall == safe_calla):
        jumpType="CALLA"
    else:
        jumpType="BRA"

    # Insert the different pointers and labels in the new instructions    
    if(mode==NONE):
        newEntry = newInstructions.substitute(old=match.group(0),srPointer=store_sr_pointer,safeBr=labelToCall,jump=jumpType)
    else: 
        newEntry = newInstructions.substitute(old=match.group(0),srPointer=store_sr_pointer,dstPointer=store_dst_pointer,dst=match.group(1+offset),safeBr=labelToCall,jump=jumpType)
    
    #newEntry = newEntry.replace("$srcPointer",store_src_pointer)
            
    return newEntry

# Function to replace an double operand unsafe instruction
# Params:
# - match: the matched regular expression containing the unsafe instruction
# - labelToCall: the label, or address, at which the safe function to be called can be found
# - mode: the type of operations, having word, address, extended, ....
# - offset: (not used) offset to be used in the regular expression. If (.w) is present then it should be 1
# RETURN: new lines with the safe operations
def writeReplaceTwoOp(extended,match,labelToCall,offset=1):

    #Check if it's absolute mode with an address
    if match.group(getOffsetMode(match.re.pattern,absoluteMode,False)) is not None: 
        #Check the address and replace the instruction with a safe version only if it points to a write memory area
        #Retrieve math operations
        finalAdd = None
        logging.warning("Write with aboslute value {}".format(match.group(0)))
        if match.group(getOffsetMode(match.re.pattern,absoluteMode,False,normalSyntax,address)) is not None: #& syntax WITH address
            finalAdd = evalAddress(match.group(getOffsetMode(match.re.pattern,absoluteMode,False,normalSyntax,address))) #contains only the address and the operations
            
        elif match.group(getOffsetMode(match.re.pattern,absoluteMode,False,registerSyntax,address)) is not None: #x(SR) syntax with address
            finalAdd = evalAddress(match.group(getOffsetMode(match.re.pattern,absoluteMode,False,registerSyntax,address))) # group contains only the address and the operations
            
        if(finalAdd is not None): # It's an address
            if (finalAdd <= flashTopAdd and finalAdd >= flashBotAdd): #It's in a read only area. It can be checked by the verifier
                return match.group(0)


    logging.debug("Write danger for: {}\nSrc {} and Dst {}".format(match.group(0),match.group(1+offset),match.group(85+offset)))


    #Write Mov optimisation --> allow safe values to be stored anywhere in memory (no risk of unlocking memory controller)
    if(labelToCall is write_mov or labelToCall is write_movx):
        if(match.group(getOffsetMode(match.re.pattern,immediateMode,True)) is not None): #Immediate MOV instruction
            patternUnlock = re.compile("(0xa5[[:alnum:]]{2}|a5[[:alnum:]]{2}h|42(2[4-8][0-9]|29[0-9]|3[0-9]{2}|4[0-8][0-9]|49[0-5]))",re.I)
            if(not patternUnlock.search(match.group(getOffsetMode(match.re.pattern,immediateMode,True)+1))):
                return "\t"+match.group(0)
    if(labelToCall is write_add or labelToCall is write_addx):
        if(match.group(getOffsetMode(match.re.pattern,immediateMode,True)) is not None): #Immediate ADD instruction
            finalAdd = evalAddress(match.group(getOffsetMode(match.re.pattern,immediateMode,True)+1))
            if finalAdd > 4096 or finalAdd < 3585: #Cannot bring 96[00-ff] to A5[00-ff] with greater or lower values!
                return "\t"+match.group(0)




    # Destination could be indexed, symbolic, absolute or indirect (no increment)
        
    logging.warning("group total {}".format(match.group(0)))

    #indexed Mode 
    if match.group(getOffsetMode(match.re.pattern,indexMode,False)): 
        dstRegister = match.group(getOffsetMode(match.re.pattern,indexMode,False,registerPart_IndexMode))
        dstOffset = match.group(getOffsetMode(match.re.pattern,indexMode,False,offsetPart_IndexMode))
        logging.warning("offset {} and reg {}. Computed: {}  {}".format(dstOffset,dstRegister,getOffsetMode(match.re.pattern,indexMode,False,registerPart_IndexMode),getOffsetMode(match.re.pattern,indexMode,False,offsetPart_IndexMode)))
        
        newEntry = Template(
        "\n\n; Old Instruction: $old\n"
        "\tMOV SR, $srPointer\n"
        "\tDINT\n\tNOP\n"
        "\t$mov $src, $srcPointer\n"
        "\t$mov $dstRegister, $dstPointer\n" 
        "\tADDA #$offset, $dstPointer\n"
        "\tCALL #$safeCall\n"
        ";End safe sequence\n\n").safe_substitute(old=match.group(0),srPointer=store_sr_pointer,src=match.group(1+offset),srcPointer=store_src_pointer,dstRegister=dstRegister,offset=dstOffset, dstPointer=store_dst_pointer,safeCall=labelToCall)
    
    #symbolic mode
    elif match.group(getOffsetMode(match.re.pattern,symbolicMode)): 
        dstOffset = match.group(getOffsetMode(match.re.pattern,symbolicMode,False,offsetPart_SymbolicMode))
        newEntry = Template(
        "\n\n; Old Instruction: $old\n"
        "\tMOV SR, $srPointer\n"
        "\tDINT\n\tNOP\n"
        "\t$mov $src, $srcPointer\n"
        "\t$mov PC, $dstPointer\n" 
        "\tADDA #$offset, $dstPointer\n"
        "\tCALL #$safeCall\n"
        ";End safe sequence\n\n").safe_substitute(old=match.group(0),srPointer=store_sr_pointer,src=match.group(1+offset),srcPointer=store_src_pointer,offset=dstOffset, dstPointer=store_dst_pointer,safeCall=labelToCall)

    #indirect Mode
    elif match.group(getOffsetMode(match.re.pattern,indirectMode)): 
        dstRegister = match.group(getOffsetMode(match.re.pattern,indirectMode,False,registerPart_IndrectMode))
        logging.warning("Indirect mode. Register: {}".format(dstRegister))

        newEntry = Template(
        "\n\n; Old Instruction: $old\n"
        "\tMOV SR, $srPointer\n"
        "\tDINT\n\tNOP\n"
        "\t$mov $src, $srcPointer\n"
        "\t$mov $dstRegister, $dstPointer\n" 
        "\tCALL #$safeCall\n"
        ";End safe sequence\n\n").safe_substitute(old=match.group(0),srPointer=store_sr_pointer,src=match.group(1+offset),srcPointer=store_src_pointer,dstRegister=dstRegister, dstPointer=store_dst_pointer,safeCall=labelToCall)
    
    #absolute Mode
    elif match.group(getOffsetMode(match.re.pattern,absoluteMode)): 
        if match.group(getOffsetMode(match.re.pattern,absoluteMode,False,normalSyntax)) is not None:  # &syntax
            dst = match.group(getOffsetMode(match.re.pattern,absoluteMode,False,normalSyntax)+1) #Remove &
        else:  #  add/label(R2) syntax
            dst = match.group(getOffsetMode(match.re.pattern,absoluteMode,False,registerSyntax)+1) #Remove (R2)
        newEntry = Template(
            "\n\n; Old Instruction: $old\n"
            "\tMOV SR, $srPointer\n"
            "\tDINT\n\tNOP\n"
            "\t$mov $src, $srcPointer\n"
            "\t$mov #$dst, $dstPointer\n" #dst without &
            "\tCALL #$safeCall\n"
            ";End safe sequence\n\n").safe_substitute(old=match.group(0),srPointer=store_sr_pointer,src=match.group(1+offset),srcPointer=store_src_pointer,dst=dst,dstPointer=store_dst_pointer,safeCall=labelToCall)
    if extended:
        newEntry = Template(newEntry).substitute(mov="MOVX")
    else:
        newEntry = Template(newEntry).substitute(mov="MOV")
    return newEntry

# Function to replace an unsafe pop instruction (e.g. br or call)
# Params:
# - match: the matched regular expression containing the unsafe instruction
# - labelToCall: the label, or address, at which the safe function to be called can be found
# - mode: the type of operations, having word, address, extended, ....
# - offset: (not used) offset to be used in the regular expression. If (.w) is present then it should be 1
# RETURN: new lines with the safe operations
def writeReplacePop(extended,match,labelToCall,offset=1):
    logging.debug("Write danger for: {}".format(match.group(0)))
    
    newEntry = Template(
        "\n; Old Instruction: $old\n"
        "\tMOV SR, $srPointer\n"
        "\tDINT\n\tNOP\n"
        "\t$mov @SP+, $srcPointer\n"
        "\t$mov $dst, $dstPointer\n"
        "\tCALL #$safeCall\n"
        ";End safe sequence\n\n").safe_substitute(old=match.group(0),srPointer=store_sr_pointer,srcPointer=store_src_pointer,dst=match.group(1+offset),dstPointer=store_dst_pointer,safeCall=labelToCall)
    if extended:
        newEntry = Template(newEntry).substitute(mov="MOVX")
    else:
        newEntry = Template(newEntry).substitute(mov="MOV")
    return newEntry

# Function to replace an unsafe push instruction (e.g. br or call)
# Params:
# - match: the matched regular expression containing the unsafe instruction
# - labelToCall: the label, or address, at which the safe function to be called can be found
# - mode: the type of operations, having word, address, extended, ....
# - offset: (not used) offset to be used in the regular expression. If (.w) is present then it should be 1
# RETURN: new lines with the safe operations
def writeReplacePush(extended,match,labelToCall,offset=1):
    logging.debug("Write danger for: {}".format(match.group(0)))
    
    newEntry = Template(
        "\n\n; Old Instruction: $old\n"
        "\tMOV SR, $srPointer\n"
        "\tDINT\n\tNOP\n"
        "\tDECD SP\n"
        "\t$mov $src, $srcPointer\n"
        "\t$mov SP, $dstPointer\n"
        "\tCALL #$safeCall\n"
        ";End safe sequence\n\n").safe_substitute(old=match.group(0),srPointer=store_sr_pointer,srcPointer=store_src_pointer,src=match.group(1+offset),dstPointer=store_dst_pointer,safeCall=labelToCall)
    if extended:
        newEntry = Template(newEntry).substitute(mov="MOVX")
    else:
        newEntry = Template(newEntry).substitute(mov="MOV")
    return newEntry


cnt = 1
line = input.readline()

dynamicJumps = 0
returnInstructions = 0
while line:    
    newEntry = line
    
    #EXECUTION CONTROL
    match = unsafeBr.search(line)
    if(match):
        newEntry = execReplace(match,safe_br,mode=WORD,offset=0)
        dynamicJumps+=1
    elif(match := unsafeBra.search(line)):
        newEntry = execReplace(match,safe_bra,mode=ADDRESS,offset=0)
        dynamicJumps+=1
    elif(match := unsafeMov.search(line)):
        newEntry = execReplace(match,safe_br,mode=WORD,offset=1)
        dynamicJumps+=1
    elif(match := unsafeMovx.search(line)):
        newEntry = execReplace(match,safe_br,mode=EXTENDED,offset=1)
        dynamicJumps+=1
    elif(match := unsafeMova.search(line)):
        newEntry = execReplace(match,safe_bra,mode=ADDRESS,offset=0)
        dynamicJumps+=1
    elif(match := unsafeMovxA.search(line)):
        newEntry = execReplace(match,safe_bra,mode=EXTENDED_ADDRESS,offset=0)
        dynamicJumps+=1
    elif(match := unsafeMovB.search(line)):
        newEntry = execReplace(match,safe_br,mode=BYTE,offset=0)
        dynamicJumps+=1
    elif(match := unsafeMovxB.search(line)):
        newEntry = execReplace(match,safe_br,mode=BYTE_EXTENDED,offset=0)
        dynamicJumps+=1
    elif(match := unsafeCall.search(line)):
        newEntry = execReplace(match,safe_call,mode=WORD,offset=0)
        dynamicJumps+=1
    elif(match := unsafeCalla.search(line)):
        newEntry = execReplace(match,safe_calla,mode=ADDRESS,offset=0)
        dynamicJumps+=1
    elif(match := unsafeRet.search(line)):
        newEntry = execReplace(match,safe_ret,mode=NONE,offset=0)
        returnInstructions+=1
    elif(match := unsafeReti.search(line)):
        newEntry = execReplace(match,safe_reti,mode=NONE,offset=0)
        returnInstructions+=1
    elif(match := unsafeReta.search(line)):
        newEntry = execReplace(match,safe_reta,mode=NONE,offset=0)
        returnInstructions+=1

    ## WRITE CONTROL
    elif(match := writeMov.search(line)):
        newEntry = writeReplaceTwoOp(0,match,write_mov)
    
    elif(match := writeMovx.search(line)):
        newEntry = writeReplaceTwoOp(1,match,write_movx)

    elif(match := writeXor.search(line)):
        newEntry = writeReplaceTwoOp(0,match,write_xor)
    
    elif(match := writeXorx.search(line)):
        newEntry = writeReplaceTwoOp(1,match,write_xorx)

    elif(match := writeAdd.search(line)):
        newEntry = writeReplaceTwoOp(0,match,write_add)
    
    elif(match := writeAddx.search(line)):
        newEntry = writeReplaceTwoOp(1,match,write_addx)
    
    elif(match := writeAddc.search(line)):
        newEntry = writeReplaceTwoOp(0,match,write_addc)
    
    elif(match := writeAddcx.search(line)):
        newEntry = writeReplaceTwoOp(1,match,write_addcx)
    
    elif(match := writeDadd.search(line)):
        newEntry = writeReplaceTwoOp(0,match,write_daddc)
    
    elif(match := writeDaddx.search(line)):
        newEntry = writeReplaceTwoOp(1,match,write_daddx)

    elif(match := writeSub.search(line)):
        newEntry = writeReplaceTwoOp(0,match,write_sub)
    
    elif(match := writeSubx.search(line)):
        newEntry = writeReplaceTwoOp(1,match,write_subx)

    elif(match := writeSubc.search(line)):
        newEntry = writeReplaceTwoOp(0,match,write_subc)
    
    elif(match := writeSubcx.search(line)):
        newEntry = writeReplaceTwoOp(1,match,write_subcx)
    
    # POP and PUSH
    elif(match := writePop.search(line)):
        newEntry = writeReplacePop(0,match,write_mov)
    
    elif(match := writePopx.search(line)):
        newEntry = writeReplacePop(1,match,write_movx)

    elif(match := writePush.search(line)):
        newEntry = writeReplacePush(0,match,write_mov)
    
    elif(match := writePushx.search(line)):
        newEntry = writeReplacePush(1,match,write_movx)

    # Emulated instructions #TODO: add all of the emulated ones
    elif(match := writeRlax.search(line)):
        string = "\tADDX {},{}\n".format(match.group(2),match.group(2))
        if(match := writeAddx.search(string)):
            newEntry = writeReplaceTwoOp(1,match,write_addx)

    elif(match := writeRlcx.search(line)):
        string = "\tADDCX {},{}\n".format(match.group(2),match.group(2))
        if(match := writeAddcx.search(string)):
            newEntry = writeReplaceTwoOp(1,match,write_addcx)
    
    #ADCX is always safe
    #elif(match := writeAdcx.search(line)):
    #    string = "\tADDCX #0,{}\n".format(match.group(2))
    #    print("Old instr: {}. New One: {}".format(match.group(0),string))
    #    if(match := writeAddcx.search(string)):
    #        newEntry = writeReplaceTwoOp(1,match,write_addcx)

    modifiedMain.write(newEntry)
    cnt += 1
    line = input.readline()

modifiedMain.close()
logging.warning("\nTotal dynamic jumps: {}.\nTotal return: {}".format(dynamicJumps,returnInstructions))
input.close()



