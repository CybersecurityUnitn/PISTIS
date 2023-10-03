/* 
    Author: Michele Grisafi
    Email: michele.grisafi@unitn.it
    License: MIT 
*/
/*
    Core TCM, containing the verification task that makes sure an image is compliant
    with the AC policy.
*/
// Basic MSP430 and driverLib #includes
#include "msp430.h"
#include "stdlib.h"
#include "core.h"

#define REJECT 1 /* IF SET to 1 THEN WE REJECT THE APPLICATION WHEN AN INSTRUCTION FAILS VERIFICATION*/
#define DEBUG 0 /* IF SET TO 1 WE TAKE NOTE OF WHAT WORD CAUSED THE VERIFICATION TO FAIL*/

/** These constants need to be synchronised with the linker script and the various toolchain scripts **/
__attribute__((section(".tcm:rodata"))) const uint16_t appTopRam            = 0x43FF;
__attribute__((section(".tcm:rodata"))) const uint16_t appBottomRam         = 0x2c00;
__attribute__((section(".tcm:rodata"))) const uint16_t appBottomText        = 0x4400;
__attribute__((section(".tcm:rodata"))) const uint16_t appTopText           = 0xc3ff;
__attribute__((section(".tcm:rodata"))) const uint32_t appBottomROdata      = 0x14400; //Used also for CFI verification
__attribute__((section(".tcm:rodata"))) const uint32_t appTopROdata         = 0x1c3ff;

/** This address is used to store the temporary unverified untrusted application during updates **/
__attribute__((section(".tcm:rodata"))) const uint32_t elfAddress          = 0x0001c400;



/** These addresses need to be synchronised with the memory layout of the target device **/
__attribute__((section(".tcm:rodata"))) const uint16_t bslTop               = 0x17ff;
__attribute__((section(".tcm:rodata"))) const uint16_t bslBottom            = 0x1000;
__attribute__((section(".tcm:rodata"))) const uint32_t flashTop             = 0x000243ff;
__attribute__((section(".tcm:rodata"))) const uint16_t flashBottom          = 0x4400;
__attribute__((section(".tcm:rodata"))) const uint16_t ramBottom            = 0x2400;
__attribute__((section(".tcm:rodata"))) const uint16_t ramTop               = 0x43ff;
__attribute__((section(".tcm:rodata"))) const uint32_t vectorTop            = 0x0001047c;
__attribute__((section(".tcm:rodata"))) const uint32_t vectorBottom         = 0x00010400;

/** Entry points for virtual functions, which need to be synchronised with the linker and python scripts **/
__attribute__((section(".tcm:rodata"))) const uint16_t safe_br      = 0xfc00;
__attribute__((section(".tcm:rodata"))) const uint16_t safe_bra     = 0xfc26;
__attribute__((section(".tcm:rodata"))) const uint16_t safe_call    = 0xfc4c;
__attribute__((section(".tcm:rodata"))) const uint16_t safe_calla   = 0xfc72;
__attribute__((section(".tcm:rodata"))) const uint16_t safe_ret     = 0xfc98;
__attribute__((section(".tcm:rodata"))) const uint16_t safe_reti    = 0xfcc0;
__attribute__((section(".tcm:rodata"))) const uint16_t safe_reta    = 0xfd08;

__attribute__((section(".tcm:rodata"))) const uint16_t safe_mov     = 0xfd30;
__attribute__((section(".tcm:rodata"))) const uint16_t safe_movx    = 0xfd42;
__attribute__((section(".tcm:rodata"))) const uint16_t safe_xor     = 0xfd56;
__attribute__((section(".tcm:rodata"))) const uint16_t safe_xorx    = 0xfd68;
__attribute__((section(".tcm:rodata"))) const uint16_t safe_add     = 0xfd7c;
__attribute__((section(".tcm:rodata"))) const uint16_t safe_addx    = 0xfd8e;
__attribute__((section(".tcm:rodata"))) const uint16_t safe_addc    = 0xfda2;
__attribute__((section(".tcm:rodata"))) const uint16_t safe_addcx   = 0xfdb4;
__attribute__((section(".tcm:rodata"))) const uint16_t safe_dadd    = 0xfdc8;
__attribute__((section(".tcm:rodata"))) const uint16_t safe_daddx   = 0xfdda;
__attribute__((section(".tcm:rodata"))) const uint16_t safe_sub     = 0xfdee;
__attribute__((section(".tcm:rodata"))) const uint16_t safe_subx    = 0xfe00;
__attribute__((section(".tcm:rodata"))) const uint16_t safe_subc    = 0xfe14;
__attribute__((section(".tcm:rodata"))) const uint16_t safe_subcx   = 0xfe26;

__attribute__((section(".tcm:rodata"))) const uint16_t receive_update_address = 0xfe3e;

__attribute__((section(".tcm:rodata"))) const uint16_t entryPointBSL = 0x1002;
/* TODO: modify BSL to check whether return address is valid. 
Might not be needed since we call the BSL only from the PISTIS secure code. */



/* Backup Flags */
//__attribute__((section(".tcm:rodata"))) const uint32_t interruptStoreSR   = 0xfe46;

/** Variables used for storing the necessary metadata during verification **/
volatile uint16_t alwDst[MAX_BUFFER];
volatile uint16_t counterAlwDst = 0;
volatile uint8_t counterBuffAlwDst = 0;

/** This address is used to store the CFI temporary data during verification**/
/** It must be different depending on whether an update has being received or not:
    If an update has been received then we need the elfData and thus we use the 
    AppROData. This will then be written after the verification.
    If no update is being received then we must use the elfDAta section  **/
volatile uint32_t cfiDataHolder;

/**
 *  Initiate the secure boot of the device. Use codeStart section to force address to 0xC400
 */ 
__attribute__((section(".tcm:codeStart"))) static void secureBoot(){

    WDTCTL = WDTPW | WDTHOLD;   // stop watchdog timer

    //TODO: disable interrupts inside the BSL.
    
    //Disable interrupts during verification.
    __dint();

    P1DIR |= BIT0; // Set 1.0 pin in output (red LED)

    //Turn on red led 10 times to indicate that the device is booting
    for(int i = 0; i < 10; i++){
        P1OUT ^= BIT0; // Toggle red LED
        for(int j = 0; j < 10000; j++){ // Delay{
            __asm("nop");
        }
    }
    P1OUT |= BIT0; // Set output to 1 (red LED)

    // check whether code has been instrumented correctly
    bool codeStatus = verify_app_inst(appBottomText,appTopText);
    
    // check whether control integrity is preserved
    bool cfiStatus = verify_app_cfi(appBottomText,appTopText);

    //TODO: verify if addresses in User IVT corresponds to valid addresses

    //If both verification succeed then launch the application
    if(codeStatus == VERIFIED && cfiStatus == VERIFIED){
        
        launchAppCode();
    }else{
        //If verification fails then reset the device
        WDTCTL = 6; //Reset
    }
}


/**
 * Launch the application from its entry point
**/
__attribute__((section(".tcm:code"))) void launchAppCode(){
    
    // Turn off LEDs
    P4OUT &= 0x7f; // Turn off the green LED
    P1OUT &= 0xfe; // Turn off the red LED
    
    //Lock memory controller
    FCTL3 = FWPW+LOCK;

    //Enable interrupts
    __eint();

    //Jump to beginning of application
    __asm("\n\tBR #4400h");
}

#if DEBUG
//Word that caused the failure of the verificaiton
uint16_t interruptWord =0;

//Value of the PC when verification failed
uint32_t interruptPcOld = 0;
#endif
/**
 * Verify the given set of instructions for illegal operations, 
   thus causing either the acceptance of the rejection of the application
 * PARAMS:
 * - uint16_t address: the pointer to the first instruction to be checked
 * - uint16_t lastAddress: the pointer to the last instruction to be checked
 * - bool cfi: whether to run CFI check or not 
 * RETURN: 1 code is secure, 0 code is not safe
 */
__attribute__((section(".tcm:code"))) bool verify(uint16_t address, uint16_t lastAddress, bool cfi){
    //Check whether it is an update (we know the code size)
    /*TODO: find alternative checks. This one has a false positive when update 
    code is as big as app memory*/
    //If we know the lastAddress then we are updating --> we use the appBottomRoData since it hasn't yet been filled
    //OTherwise we don't touch it and use the eldAddress location
    cfiDataHolder = lastAddress == appTopText ?  elfAddress : appBottomROdata;

    if(!cfi){
        //Erase CFI data holder section
        FCTL3 = FWPW; //Unlock memory controller
        FCTL1 = FWPW + MERAS; //Set erase mode BANK
        *(uint16_t *)cfiDataHolder = 0;
        while ((FCTL3 & BUSY) == BUSY); //Wait for erasure
        //Erase cfiBuffer and some variables
        memset(alwDst,0,MAX_BUFFER);
        counterAlwDst = 0;
        counterBuffAlwDst = 0;
    }
    //Set default results
    bool outcome = VERIFIED;
    bool cfiResult = VERIFIED;

    //Variables to store the most significant bits of instruction operands
    uint8_t MSBsrc = 0;
    uint8_t MSBdst = 0;

    /**
     * ********************** WRITE PROTECTION *************
    */

    //Memory location to which the MMIO register 'FCTL3' is mapped
    uint16_t fctl3 = 0x0144; 

    /* Temporary variables */
    uint16_t word;
    uint16_t extWord;
    uint16_t opCode;
    uint16_t operand1;
    uint16_t operand2;

    uint32_t opCodePointer;
    uint32_t operand1Pointer;
    uint32_t operand2Pointer;
    uint32_t dstOperand;
    uint32_t dstOperandPointer;

    uint32_t srcOperand20Bit = 0;
    int32_t srcOperand20BitSigned = 0;
    uint32_t dstOperand20Bit = 0;
    int32_t dstOperand20BitSigned = 0;

    uint32_t immediateValue;

    uint8_t extendedWord = 0;
    uint8_t wordStep = 0;




    /*************   START VERIFICATION ***************/
    //Count number of instructions
    uint16_t count = 0;

    //Value of the PC
    uint32_t pc_old;

    //Cycle through all of the instructions in the given range
    while (address + (count*2) < lastAddress){

        //Retrieve the value of the PC and of the current word
        //Old value of the PC is used when the current word is not the base word
        pc_old = address+(count*2); 
        word = *(uint16_t *)pc_old;

        //First word of instruction
        wordStep=1;

        // Check if extension word is used
        if((word & 0xf800) == 0x1800){ 
            extWord = word;
            extendedWord=1;

            //Might have the MSB if the mode is non register. 
            //Save them anyway to be used in case it is non-register
            MSBsrc = (uint8_t)(word>>7) & 0x0f;
            MSBdst = (uint8_t)word & 0x0f; 

            /* Add extension word to the instruction lenght count */
            wordStep+=1;
        }else{
            extendedWord = 0;
        } 

        // Decompose instruction into its parts
        opCodePointer = pc_old + extendedWord*2;
        operand1Pointer = pc_old + 2 + extendedWord*2;
        operand2Pointer = pc_old + 4 + extendedWord*2;
        opCode      = *(uint16_t *)opCodePointer;
        operand1    = *(uint16_t *)operand1Pointer;
        operand2    = *(uint16_t *)operand2Pointer;
        
        //TODO: if 20 bit are stored in the previous or next address, is there a chance of unlocking?

        /************** Detect OP Codes ****************/
        /* In the following LOC we detect which instruction is being used
         * and move through the code accordingly, deciding whether any 
         * instruction is unsafe */
        
        // Single operand mode
        if( (opCode & 0xff80) == 0x1000 || /* RRC */   //TODO: check various length
            (opCode & 0xff80) == 0x1080 || /* SWPB */
            (opCode & 0xff80) == 0x1100 || /* RRA */
            (opCode & 0xff80) == 0x1180  /* SXT */
        ){
            if ((opCode & 0x003f) == 0x0000){ /* direct use of the PC */
                outcome = REJECTED; 
            }

            /* These operations cannot be used to store the memory controller password */
            else if((opCode & 0x0030) != 0x0000 /* Register */ 
                && (opCode & 0x0030) != 0x0020 /* Indirect */ 
                && !((opCode & 0x0030) == 0x0030 && (opCode & 0x000f) != 0x0000) /* Autoincrement */){
                /* It is either a Indexed, Symbolic, Absolute, immediate instruction*/
                wordStep +=1;
            }
        }
        /****** PUSH (not byte version nor 20-bit) *********/
        else if((opCode & 0xffC0) == 0x1200 ){
            /* Push instruction might unlock the memory controller */
            if(!cfi){
                if( 
                    !(  
                        (opCode & 0x0030) == 0x0030  /* Immediate mode*/ 
                        && (operand1 & 0xff00) != 0xa500  /* without memory controller password */
                    ) && 
                    !(
                        (opCode & 0x003f) == 0x0010 && /* Symbolic mode*/  
                        (*(uint16_t *)(operand1Pointer + operand1) & 0xff00) != 0xa500 /* without memory controller password */
                    ) &&
                    !(
                        (opCode & 0x003f) == 0x0012 && /* Symbolic mode */ 
                        (*(uint16_t *)(operand1) & 0xff00) != 0xa500 /* without memory controller password */
                    )
                ){
                    /* It should either have been rejected or virtualised */
                    outcome = REJECTED;
                }
            }
            #if REJECT
            if(outcome != REJECTED){
            #endif
                /* Step count */
                if(
                    (opCode & 0x0030) != 0x0000 /* Register */ && 
                    (opCode & 0x0030) != 0x0020 /* Indirect */ && 
                    !(
                        (opCode & 0x0030) == 0x0030 && 
                        (opCode & 0x000f) != 0x0000
                    ) /* Autoincrement */
                ){
                    /* Indexed, Symbolic, Absolute, immediate */
                    wordStep += 1;
                }
            #if REJECT
            }
            #endif
        } /***** PUSHM ****/
        else if(
            (opCode & 0xff00) == 0x1500 /* Word version */ || 
            (opCode & 0xff00) == 0x1400 /* Address version */
        ){
            outcome = REJECTED;
            //TODO: check if saving 20-bit registers is allowed!
        }
        /****** CALL  *********/
        else if((opCode & 0xffc0) == 0x1280){
            /* Immediate Mode */
            if(!cfi){
                if(
                    ((opCode & 0x0030) == 0x0000 /* Register mode */) ||
                    (   
                        (opCode & 0x003f) == 0x0030 /* immediate mode */ &&
                        (   /* Check immediate address */
                            (operand1 > appTopText || operand1 < appBottomText) && 
                            !isImmediateSafeValue(operand1)
                        )
                    ) ||
                    (
                        (opCode & 0x003f) == 0x0010 /* Symbolic mode*/ && 
                        (
                            /*Check if pointer is in read-only text */
                            ((int16_t)operand1 + operand1Pointer > appTopText || (int16_t)operand1 + operand1Pointer < appBottomText)  ||
                            
                            /*Check if pointer content is allowed */
                            (*(uint16_t*)((int16_t)operand1 + operand1Pointer) < appBottomText 
                            || *(uint16_t*)((int16_t)operand1 + operand1Pointer) > appTopText) 
                        )
                    ) ||
                    ((opCode & 0x003f) == 0x0012 /*Absolute mode */ &&(
                        /*Check if pointer is in read-only text */
                        (operand1 > appTopText || operand1 < appBottomText) ||
                        /*Check if pointer content is allowed */
                        (*(uint16_t*)operand1 > appTopText || *(uint16_t*)operand1 < appBottomText )
                    )) ||
                    ((opCode & 0x0030) == 0x0010 && (opCode & 0x003f) != 0x0010 && (opCode & 0x003f) != 0x0012 /*Indexed mode*/) ||
                    ((opCode & 0x0030) == 0x0020 /* Indirect mode (PC not allowed by compiler)*/) ||
                    ((opCode & 0x0030) == 0x0030 && (opCode & 0x003f) != 0x0030 /* Indirect autoincrement */)
                ){
                    outcome = REJECTED; 
                }
            }
            
            #if REJECT
            if(outcome != REJECTED){
            #endif
                /* Update step counter */
                if((opCode & 0x0030) != 0x0000 /* Register */ &&
                    (opCode & 0x0030) != 0x0020 /* Indirect */ &&
                    !((opCode & 0x0030) == 0x0030 && (opCode & 0x000f) != 0x0000) /* Autoincrement */){
                    /* Indexed, Symbolic, Absolute, immediate */
                    wordStep += 1;
                }
                if(cfi){
                    /* Check if the destination is in the set of allowed addresses*/
                    if((opCode & 0x003f) == 0x0030 /* immediate mode */){
                        cfiResult = cfiCheck(operand1);
                    }else if((opCode & 0x003f) == 0x0010 /* Symbolic mode */){
                        cfiResult = cfiCheck(*(uint16_t*)((int16_t)operand1 + operand1Pointer));
                    }else if((opCode & 0x003f) == 0x0012 /*Absolute mode */){
                        cfiResult = cfiCheck(*(uint16_t*)operand1);
                    }
                }
                
            #if REJECT
            }
            #endif
        }
        /*** RET + RETI + RETA instruction ***/
        else if(opCode == 0x4130 || opCode == 0x1300 || opCode == 0x0110){  
            //Should have been replaced
            outcome = REJECTED; 
        }
        /**** JMP instruction check OP: [0010|00__|_|_] to [0011|11__|_|_] ******/
        else if(opCode>=0x2000 && opCode <= 0x3fff){

            //TODO: check if JMPS offset are correct
            int32_t label = 0x000003ff & (uint32_t)opCode;
            
            // Check whether the jump is with a negative offset
            if((int8_t)(opCode>>2)<0){
                //Extend sign to 32 bit
                label |= 0xfffffc00;
            }
            label *=2;
            uint32_t pointer = operand1Pointer + label;
            /* Check jump boundaries */
            if(!cfi){
                if(pointer < appBottomText || pointer >= appTopText){ 
                    outcome = REJECTED; 
                }
            }else{
                cfiResult = cfiCheck(pointer);
            }
        } 


        /***** TWO OPERANDS INSTRUCTIONS ****/
        else if((opCode & 0xf000) >= 0x4000 && (opCode & 0xf000) <= 0xf000){
            
            //Set the default destination on operand 1
            dstOperand = operand1;
            dstOperandPointer = operand1Pointer;

            /* Constant Generator usage for 0, 1, 2, 4, 8, and -1 constants
             * opCode & 0x0f30 mask*/
            /* -1 : 0x_33_ : imm src with R3 */
            /* 0 : 0x_30_ : reg src with R3 */
            /* 1 : 0x_31_ : indexed src with R3 */
            /* 2 : 0x_32_ : Indirect Reg src with R3 */
            /* 4 : 0x_22_ : Indirect Reg src with R2 */
            /* 8 : 0x_23_ : Imm src with R2 */

            /* Check Source operand */
            if((opCode & 0x0030) == 0x0010 /* Indexed, Absolute, Symbolic */ || 
                (opCode & 0x0f30) == 0x0030 /* Immediate (src reg == 0) */
            ){
                if(! /* Constant generators */
                    ((opCode & 0x0f30) == 0x0330 ||
                    /* (opCode & 0x0f30) == 0x0300 || it cannot be SRC mode */
                    (opCode & 0x0f30) == 0x0310 ||
                    /* (opCode & 0x0f30) == 0x0320 || it cannot be indirect mode */
                    /* (opCode & 0x0f30) == 0x0220 || it cannot be indirect mode  */
                    (opCode & 0x0f30) == 0x0230)   
                ){
                    //Set destination on operand 2
                    dstOperand = operand2;
                    dstOperandPointer = operand2Pointer;
                    wordStep+=1;
                } //End constant generator check
            } //End source operand check

            /** Compute signed addresses with 20bit values **/
            if(extendedWord){
                srcOperand20Bit = 0x00000000 | ((uint32_t)MSBsrc)<<16 | operand1;
                srcOperand20BitSigned = srcOperand20Bit;
                if((int8_t)MSBsrc<<4 < 0){
                    srcOperand20BitSigned = 0xfff00000 | ((uint32_t)MSBsrc)<<16 | operand1;
                }

                dstOperand20Bit = 0x00000000 | ((uint32_t)MSBdst)<<16 | dstOperand;
                dstOperand20BitSigned = dstOperand20Bit;
                if((int8_t)MSBdst<<4 < 0){
                    dstOperand20BitSigned = 0xfff00000 | ((uint32_t)MSBdst)<<16 | dstOperand;
                }
            } // End extended word check
            
            
            /* is a MOV to PC? Which is like a BR function. 'AD' is register mode */
            if((opCode & 0xf08f) == 0x4000){
                /***** Check SRC mode ********/
                /* Immediate mode */
                if( (opCode & 0x0f30) == 0x0030 || 
                    
                    /* Constant generators */
                    (opCode & 0x0f30) == 0x0330 || 
                    (opCode & 0x0f30) == 0x0300 ||
                    (opCode & 0x0f30) == 0x0310 ||
                    (opCode & 0x0f30) == 0x0320 ||
                    (opCode & 0x0f30) == 0x0220 ||
                    (opCode & 0x0f30) == 0x0230
                ){
                    if((opCode & 0x0f30) == 0x0330){
                        immediateValue = -1;
                    }else if((opCode & 0x0f30) == 0x0300){
                        immediateValue = 0;
                    }else if((opCode & 0x0f30) == 0x0310){
                        immediateValue = 1;
                    }else if((opCode & 0x0f30) == 0x0320){
                        immediateValue = 2;
                    }else if((opCode & 0x0f30) == 0x0220){
                        immediateValue = 4;
                    }else if((opCode & 0x0f30) == 0x0230){
                        immediateValue = 8;
                    }else{
                        /* Not a constant generator usage */

                        //Immediate value is the first operand
                        immediateValue = operand1;

                        //If extended word then the immediate value is the 20bit version
                        if(extendedWord){
                            immediateValue = srcOperand20Bit;
                        }
                        // if it is Byte mode then we truncate the value
                        if((opCode & 0x0040) == 0x0040 && (!extendedWord || (extendedWord && (extWord & 0x0040) == 0x0040))){
                            immediateValue = (uint8_t)immediateValue;
                        }

                        /* 20bit Address word mode */
                        if(extendedWord && (extWord & 0x0040) == 0x0000){
                            immediateValue = srcOperand20Bit;
                        }
                    }

                    //Check address boundaries and safe values
                    if((immediateValue > appTopText || immediateValue < appBottomText) && !isImmediateSafeValue(immediateValue)){
                        outcome = REJECTED;
                    }
                } //End immediate mode (BR instruction)
                /* Register mode*/
                else if((opCode & 0x0030) == 0x0000){
                    //TODO: add symbolic mode with values below 16 --> register mode! Weird!!
                    outcome = REJECTED;
                }
                /*Symbolic mode */
                else if((opCode & 0x0f30) == 0x0010){
                    /* Normal mode */
                    if (!extendedWord){
                        if(
                            /*pointer in writable area */ 
                            ((int16_t)operand1 + operand1Pointer > appTopText || (int16_t)operand1 + operand1Pointer < appBottomText)  ||
                            /* destination out of boundaries */
                            (
                                /* Byte mode. */
                                ((opCode & 0x0040) == 0x0040  && 
                                    (((uint8_t)(*(uint16_t*)((int16_t)operand1 + operand1Pointer)) < appBottomText || (uint8_t)(*(uint16_t*)((int16_t)operand1 + operand1Pointer)) > appTopText)
                                ) ||
                                /* Word mode */
                                ((opCode & 0x0040) != 0x0040  && 
                                    (*(uint16_t*)((int16_t)operand1 + operand1Pointer) < appBottomText || *(uint16_t*)((int16_t)operand1 + operand1Pointer) > appTopText)
                                ))
                            )
                        ){
                            outcome = REJECTED;
                        }
                    } //End normal mode for Symbolic BR instruction
                    /* Extended version */
                    else{
                        if(
                            /*pointer in writable area */ 
                            (srcOperand20BitSigned + (uint32_t)operand1Pointer > appTopText || srcOperand20BitSigned + operand1Pointer < appBottomText)  ||
                            /* destination out of boundaries */
                            (
                                /*Byte */
                                ((opCode & 0x0040) == 0x0040 && (extWord & 0x0040) == 0x0040 && 
                                    ((uint8_t)(*(uint16_t*)(srcOperand20BitSigned + operand1Pointer)) < appBottomText || (uint8_t)(*(uint16_t*)(srcOperand20BitSigned + operand1Pointer)) > appTopText)
                                ) ||
                                /* Word mode */
                                ((opCode & 0x0040) == 0x0000 && (extWord & 0x0040) == 0x0040 &&
                                    (*(uint16_t*)(srcOperand20BitSigned + operand1Pointer) < appBottomText || *(uint16_t*)(srcOperand20BitSigned + operand1Pointer) > appTopText)
                                ) ||
                                /* Address mode */
                                ((opCode & 0x0040) == 0x0040 && (extWord & 0x0040) == 0x0000 &&
                                    (*(uint32_t*)(srcOperand20BitSigned + operand1Pointer) < appBottomText || *(uint32_t*)(srcOperand20BitSigned + operand1Pointer) > appTopText)
                                )
                            )
                        ){
                            outcome = REJECTED;
                        }
                    } //End extended version for Symbolic BR instruction
                } //End symbolic mode for BR instruction
                /*Absolute mode*/
                else if((opCode & 0x0f30) == 0x0210){
                    /* Normal mode */
                    if (!extendedWord){
                        if(
                            /*pointer in writable area */ 
                            (operand1  > appTopText || operand1 < appBottomText)  ||
                            /* destination out of boundaries */
                            (
                                /* Byte mode. We shift by 8 bits because byte operations use the upper 2 bytes of the src (apparently) */
                                ((opCode & 0x0040) == 0x0040  && 
                                    (((uint8_t)(*(uint16_t*)((int16_t)operand1) >> 8) < appBottomText || (uint8_t)(*(uint16_t*)((int16_t)operand1) >> 8) > appTopText)
                                ) ||
                                /* Word mode */
                                ((opCode & 0x0040) != 0x0040  && 
                                    (*(uint16_t*)((int16_t)operand1) < appBottomText || *(uint16_t*)((int16_t)operand1) > appTopText)
                                ))
                            )
                        ){
                            outcome = REJECTED;
                        }
                    } //End normal mode for Absolute BR instruction
                    /* Extented mode */
                    else{
                        if(
                            /*pointer in writable area */ 
                            (srcOperand20Bit > appTopText || srcOperand20Bit < appBottomText)  ||
                            /* destination out of boundaries */
                            (
                                /*Byte. We shift by 8 bits because byte operations use the upper 2 bytes of the src (apparently) */
                                ((opCode & 0x0040) == 0x0040 && (extWord & 0x0040) == 0x0040 && 
                                    ((uint8_t)(*(uint16_t*)(srcOperand20Bit) >> 8) < appBottomText || (uint8_t)(*(uint16_t*)(srcOperand20BitSigned)) > appTopText)
                                ) ||
                                /* Word mode */
                                ((opCode & 0x0040) == 0x0000 && (extWord & 0x0040) == 0x0040 &&
                                    (*(uint16_t*)(srcOperand20Bit) < appBottomText || *(uint16_t*)(srcOperand20Bit) > appTopText)
                                ) ||
                                ((opCode & 0x0040) == 0x0040 && (extWord & 0x0040) == 0x0000 &&
                                    (*(uint32_t*)(srcOperand20Bit) < appBottomText || *(uint32_t*)(srcOperand20Bit) > appTopText)
                                )/* Address mode */
                                
                            )
                        ){
                            outcome = REJECTED;
                        }
                    }//End extended mode for Absolute BR instruction
                }//End absolute mode for BR instruction
                /* Other modes which are rejected immediatly */
                else if(
                    ((opCode & 0x0030) == 0x0010 && (opCode & 0x0030) != 0x0010 && (opCode & 0x0030) == 0x0210/* Index mode */ ) ||
                    ((opCode & 0x0030) == 0x0020 /* Indirect mode */) ||
                    ((opCode & 0x0030) == 0x0030 && (opCode & 0x0f30) != 0x0030/* Indirect autoincrement mode */)
                ){
                    outcome = REJECTED;
                }
                
                
                #if REJECT
                if(outcome != REJECTED){
                #endif
                    // Perform some CFI checks
                    if(cfi){
                        /* Add destination to cfi*/
                        if( /* immediate mode */
                            (opCode & 0x0f30) == 0x0030  ||
                            /* Constant generators */
                            (opCode & 0x0f30) == 0x0330 || 
                            (opCode & 0x0f30) == 0x0300 ||
                            (opCode & 0x0f30) == 0x0310 ||
                            (opCode & 0x0f30) == 0x0320 ||
                            (opCode & 0x0f30) == 0x0220 ||
                            (opCode & 0x0f30) == 0x0230
                        ){
                            cfiResult = cfiCheck(immediateValue);
                        } //End immediate mode
                        /* Symbolic mode */
                        else if((opCode & 0x003f) == 0x0010 ){
                            if (!extendedWord){
                                /* Byte mode. */
                                if((opCode & 0x0040) == 0x0040){
                                    cfiResult = cfiCheck((uint8_t)(*(uint16_t*)((int16_t)operand1 + operand1Pointer)));
                                /* word mode */
                                }else{
                                    cfiResult = cfiCheck(*(uint16_t*)((int16_t)operand1 + operand1Pointer));
                                }
                            }   
                            /* Extended version */
                            else{
                                /* byte mode */
                                if((opCode & 0x0040) == 0x0040 && (extWord & 0x0040) == 0x0040){
                                    cfiResult = cfiCheck((uint8_t)(*(uint16_t*)(srcOperand20BitSigned + operand1Pointer)));
                                /* word mode */
                                }else if((opCode & 0x0040) == 0x0000){
                                    cfiResult = cfiCheck(*(uint16_t*)(srcOperand20BitSigned + operand1Pointer));
                                /* address mode */
                                }else{
                                    cfiResult = cfiCheck(*(uint32_t*)(srcOperand20BitSigned + operand1Pointer));
                                }
                            }
                            
                        } //End symbolic mode
                        /* Absolute mode */
                        else if((opCode & 0x003f) == 0x0012 ){
                             if (!extendedWord){
                                /* Byte mode. */
                                if((opCode & 0x0040) == 0x0040)
                                    cfiResult = cfiCheck((uint8_t)(*(uint16_t*)((int16_t)operand1) >> 8));
                                /* word mode */
                                else
                                    cfiResult = cfiCheck(*(uint16_t*)((int16_t)operand1));
                            }   
                            /* Extended version */
                            else{
                                /* byte mode */
                                if((opCode & 0x0040) == 0x0040 && (extWord & 0x0040) == 0x0040)
                                    cfiResult = cfiCheck((uint8_t)(*(uint16_t*)(srcOperand20Bit) >> 8));
                                /* word mode */
                                else if((opCode & 0x0040) == 0x0000)
                                    cfiResult = cfiCheck(*(uint16_t*)(srcOperand20Bit));
                                /* address mode */
                                else
                                    cfiResult = cfiCheck(*(uint32_t*)(srcOperand20Bit));
                            }
                        } //End absolute mode
                    }
                #if REJECT    
                }
                #endif
                
            } //End of MOV to PC check

            //Following operations only if not a CFI pass
            if(!cfi){
                /** Double operand on the PC **/
                if(
                    (opCode & 0xf08f) == 0x5000 ||    //ADD (INCD emulated)
                    (opCode & 0xf08f) == 0x6000 ||    //ADDC
                    (opCode & 0xf08f) == 0x7000 ||    //SUBC
                    (opCode & 0xf08f) == 0x8000 ||    //SUB
                    (opCode & 0xf08f) == 0xa000 ||    //DADD
                    (opCode & 0xf08f) == 0xc000 ||    //BIC
                    (opCode & 0xf08f) == 0xd000 ||    //BIS
                    (opCode & 0xf08f) == 0xe000 ||    //XOR (INV emulated)
                    (opCode & 0xf08f) == 0xf000       //AND
                ){
                    outcome = REJECTED;
                }

                /**** WRITE PROTECTION: prevents unlock of FCTL3 memory controller  ***/
                else if(
                    /* Not address (B/W is 1 for address mode) nor Byte mode */
                    (opCode & 0x0040) == 0x0000  &&

                    (/* Check for potentially dangerous writes which could unlock memory controller */
                        (opCode & 0xf0c0) == 0x4080 || //MOV[.W] or MOVX[.W] with Ad != Regmode (this includes also POP which is emulated)
                        (opCode & 0xf0c0) == 0xe080 || //XOR[.W] or XORX[.W] with Ad != Regmode
                        (opCode & 0xf0c0) == 0x5080 || //ADD[.W] or ADDX[.W] with Ad != Regmode
                        (opCode & 0xf0c0) == 0x6080 || //ADDC[.W] or ADDCX[.W] with Ad != Regmode
                        (opCode & 0xf0c0) == 0xA080 || //DADD[.W] or DADDX[.W] with Ad != Regmode
                        (opCode & 0xf0c0) == 0x8080 || //SUB[.W] or SUBX[.W] with Ad != Regmode
                        (opCode & 0xf0c0) == 0x7080    /*SUBC[.W] or SUBCX[.W] with Ad != Regmode*/
                    )
                ){
                    /**** check the src mode so that we can look up the correct operand *****/
                    /* Dst Symbolic mode */
                    if((opCode & 0x008f) == 0x0080){
                        if((!extendedWord && (
                                /** Pointer is in writable area **/
                                (dstOperandPointer + (int16_t)dstOperand > appTopText || dstOperandPointer + (int16_t)dstOperand < appBottomText) ||
                                /** Content points to memory controller **/
                                (*(uint16_t *)(dstOperandPointer + (int16_t)dstOperand) == fctl3) 
                            ))  ||
                            /* Extended mode */
                            ( extendedWord &&(
                                /** Pointer is in writable area **/
                                ((uint32_t)dstOperandPointer + dstOperand20BitSigned > appTopText || dstOperandPointer + dstOperand20BitSigned < appBottomText) ||
                                /** Content points to memory controller **/
                                (*(uint16_t *)((uint32_t)dstOperandPointer + dstOperand20BitSigned) == fctl3)
                            ))){
                            outcome = REJECTED;
                        }
                    }
                    /* Dst Absolute mode */
                    else if((opCode & 0x008f) == 0x0082){
                        if( /* NOrmal mode */
                            (!extendedWord && dstOperand == fctl3)  ||
                            /* Extended mode */
                            (extendedWord && dstOperand20Bit == fctl3)){
                            outcome = REJECTED;
                        }
                    }
                    /* Indexed, (Indirect emulated) */
                    else if((opCode & 0x0080) == 0x0080){
                        outcome = REJECTED;
                    }
                    /* Src Immediate mode might avoid a rejection! */
                    if(outcome == REJECTED && (
                        (opCode & 0x0f30) == 0x0030 || 
                        /* immediate with constant generator */
                        (opCode & 0x0f30) == 0x0330 ||
                        (opCode & 0x0f30) == 0x0300 ||
                        (opCode & 0x0f30) == 0x0310 ||
                        (opCode & 0x0f30) == 0x0320 ||
                        (opCode & 0x0f30) == 0x0220 ||
                        (opCode & 0x0f30) == 0x0230
                    )){
                        if((opCode & 0x0f30) == 0x0330){
                            immediateValue = -1;
                        }else if((opCode & 0x0f30) == 0x0300){
                            immediateValue = 0;
                        }else if((opCode & 0x0f30) == 0x0310){
                            immediateValue = 1;
                        }else if((opCode & 0x0f30) == 0x0320){
                            immediateValue = 2;
                        }else if((opCode & 0x0f30) == 0x0220){
                            immediateValue = 4;
                        }else if((opCode & 0x0f30) == 0x0230){
                            immediateValue = 8;
                        }else{
                            /* Non constant generator usage */
                            immediateValue = operand1;
                        }
                        //TODO: insert optimisations here
                        /* 20 bit values cannot be used  */
                        /* Mov instruction */
                        if((opCode & 0xf0c0) == 0x4080 && (immediateValue) != 0xa5){
                            outcome = VERIFIED;
                        }
                        /* ADD instruction */
                        if((opCode & 0xf0c0) == 0x5080 && (immediateValue > 4096 || immediateValue < 3585)){
                            outcome = VERIFIED;
                        }
                        /* ADDC instruction */
                        if((opCode & 0xf0c0) == 0x6080 && (immediateValue > 4096 || immediateValue < 3584)){ //TODO: verify these intervals
                            outcome = VERIFIED;
                        }
                    }


                }
            }
            

            #if REJECT
            if(outcome!=REJECTED){
            #endif
                if((opCode & 0x0080) == 0x0080){
                    /* Indexed, Symbolic, Absolute */
                    wordStep +=1;
                }
            #if REJECT    
            }
            #endif
        } //End two operands instructions
        
        /***** ADDRESS and EXTENDED INSTRUCTIONS ******/

        /*** CALLA ***/
        else if((opCode & 0xff00) == 0x1300){
            if( (opCode & 0x00f0) == 0x0040 || /*Register*/
                ((opCode & 0x00f0) == 0x0050 /*&& (opCode & 0x000f)  != 0 --> gets converted to symbolic *//*&& (opCode & 0x000f) != 2 --> does not compile if R2 used*/)|| /*Indexed*/
                ((opCode & 0x00f0) == 0x0060 /*&& (opCode & 0x000f) != 0x0000 --> does not compile*/) ||                  /*Indirect. No PC allowed*/
                ((opCode & 0x00f0) == 0x0070 /*&& (opCode & 0x000f) != 0x0000 --> does not compile */)                     /*Indirect+. No PC allowed*/
            ){
                outcome = REJECTED; 
            }
            /* Symbolic */
            else if((opCode & 0x00f0) == 0x0090){ 
                //Use same checks of MOVX.A
                MSBsrc = (uint8_t)opCode & 0x0f;
                srcOperand20Bit = 0x00000000 | ((uint32_t)MSBsrc)<<16 | operand1;
                srcOperand20BitSigned = srcOperand20Bit;
                if((int8_t)MSBsrc<<4 < 0){
                    srcOperand20BitSigned = 0xfff00000 | ((uint32_t)MSBsrc)<<16 | operand1;
                }
                if(
                    /* pointer in writable area */ 
                    (srcOperand20BitSigned + (uint32_t)operand1Pointer > appTopText || srcOperand20BitSigned + (uint32_t)operand1Pointer < appBottomText)  ||
                    /* destination out of boundaries */
                    (*(uint32_t*)(srcOperand20BitSigned + operand1Pointer) < appBottomText || *(uint32_t*)(srcOperand20BitSigned + operand1Pointer) > appTopText)
                ){
                    outcome = REJECTED;
                }
            } //End symbolic CALLA
            /* Absolute */
            else if((opCode & 0x00f0) == 0x0080){  
                //Use same checks of MOVX.A
                MSBsrc = (uint8_t)opCode & 0x0f;
                srcOperand20Bit = 0x00000000 | ((uint32_t)MSBsrc)<<16 | operand1;

                if(
                    /* pointer in writable area */ 
                    (srcOperand20Bit > appTopText || srcOperand20Bit < appBottomText)  ||
                    /* destination out of boundaries */
                    (*(uint32_t*)srcOperand20Bit < appBottomText || *(uint32_t*)srcOperand20Bit > appTopText)
                ){
                    outcome = REJECTED;
                }
            } //End absolute CALLA
            /* Immediate */
            else if((opCode & 0x00f0) == 0x00b0){
                // Get most important bits from word
                MSBsrc = (uint8_t)opCode & 0x0f;
                srcOperand20Bit = 0x00000000 | ((uint32_t)MSBsrc)<<16 | operand1;
                if((srcOperand20Bit  > appTopText || srcOperand20Bit < appBottomText) && !isImmediateSafeValue(srcOperand20Bit)){
                    outcome = REJECTED;
                }
            } //End immediate CALLA
            #if REJECT
            if (outcome != REJECTED){
            #endif
                if(
                    (opCode & 0x00f0) == 0x00b0 /* Immediate */ ||
                    (opCode & 0x00f0) == 0x00b0 /* Indexed */ || 
                    (opCode & 0x00f0) == 0x00b0 /* Symbolic */ ||  
                    (opCode & 0x00f0) == 0x00b0 /* Absolute */
                ){
                    wordStep+=1;
                }

                if(cfi){
                    if((opCode & 0x00f0) == 0x00b0 /* immediate mode */){
                        cfiResult = cfiCheck(srcOperand20Bit);
                    }else if((opCode & 0x00f0) == 0x0090 /* Symbolic mode */){
                        cfiResult = cfiCheck(*(uint16_t*)((int16_t)operand1 + operand1Pointer));
                    }else if((opCode & 0x00f0) == 0x0080 /*Absolute mode */){
                        cfiResult = cfiCheck(*(uint32_t*)(srcOperand20BitSigned + operand1Pointer));
                    }
                }
            #if REJECT    
            }
            #endif
        } //End CALLA
        /* MOVA, CMPA, ADDA, SUBA, RRCM, RRAM, RLAM, RRUM */
        else if((opCode & 0xf000) == 0x0000){
            /* MOVA */
            if((opCode & 0x00f0) >> 4 < 0x4 || ((opCode & 0x00f0) >> 4 > 0x5 && (opCode & 0x00f0) >> 4 < 0x9) || (opCode & 0x00f0) == 0x00c0){
                /* MOVA to PC = BRA */
                if((opCode & 0x000f) == 0 && (opCode & 0x00f0) != 0x0060 && (opCode & 0x00f0) != 0x0070){
                    /** Check src mode **/
                    if(
                        (opCode & 0x00f0) == 0x00c0 ||                                              /*Register  0x0_c0*/
                        ((opCode & 0x00f0) == 0x0030 && opCode != 0x0030 && opCode != 0x0230) ||    /*Indexed   0x0_30  Reg SR (R2) could not be checked apparently since the absolute mode has another syntax */
                        ((opCode & 0x00f0) == 0x0000) ||             /*Indirect  0x0_00. No PC allowed */
                        ((opCode & 0x00f0) == 0x0010)                /*Indirect+ 0x0_10. No PC allowed */
                    ){
                        outcome = REJECTED;
                    }
                    /* Symbolic. Only 16bit index allowed */
                    else if(opCode == 0x0030){
                        if(
                            /* is pointer writable */
                            ((int16_t)operand1 + operand1Pointer > appTopText || (int16_t)operand1 + operand1Pointer < appBottomText)  ||
                            /* is destination valid */
                            (*(uint32_t*)((int16_t)operand1 + operand1Pointer) < appBottomText || *(uint32_t*)((int16_t)operand1 + operand1Pointer) > appTopText)
                        ){
                            outcome = REJECTED;
                        }
                    }
                    /* Absolute mode */
                    else if((opCode & 0x00f0) == 0x0020){
                        MSBsrc = (opCode & 0x0f00) >> 8;
                        srcOperand20Bit = 0x00000000 | ((uint32_t)MSBsrc)<<16 | operand1;
                        if(
                            (srcOperand20Bit  > appTopText || srcOperand20Bit < appBottomText)  ||
                            (*(uint32_t*)srcOperand20Bit  < appBottomText || *(uint32_t*)srcOperand20Bit  > appTopText)
                        ){
                            outcome = REJECTED;
                        }
                    }
                    /* Immediate mode */
                    else if((opCode & 0x00f0) == 0x0080){
                        MSBsrc = (opCode & 0x0f00) >> 8;
                        srcOperand20Bit = 0x00000000 | ((uint32_t)MSBsrc)<<16 | operand1;
                        if((srcOperand20Bit  > appTopText || srcOperand20Bit < appBottomText) && !isImmediateSafeValue(srcOperand20Bit)){
                            outcome = REJECTED;
                        }
                    }
                    #if REJECT
                    if(outcome != REJECTED){
                    #endif
                        if(cfi){
                            /* Add destination to cfi*/
                            if((opCode & 0x00f0) == 0x0080 /* immediate mode (BUG: it was & 0x0030 == 0x0030*/){
                                cfiResult = cfiCheck(operand1);
                            }else if(opCode == 0x0030 /* Symbolic mode */){
                                cfiResult = cfiCheck(*(uint32_t*)((int16_t)operand1 + operand1Pointer));
                            }else if((opCode & 0x00f0) == 0x0020 /*Absolute mode */){
                                cfiResult = cfiCheck(*(uint32_t*)srcOperand20Bit);
                            }
                        }
                    #if REJECT
                    }
                    #endif
                }
                #if REJECT
                if(outcome != REJECTED){
                #endif
                    /* Update step counter */
                    if((opCode & 0x00f0) == 0x0020 /* src absolute */ ||
                        (opCode & 0x00f0) == 0x0030 /* src index */ ||
                        (opCode & 0x00f0) == 0x0060 /* dst absolute */ ||
                        (opCode & 0x00f0) == 0x0070 /* dst index */ ||
                        (opCode & 0x00f0) == 0x0080 /* src immediate */   
                    ){
                        wordStep += 1;
                    }
                #if REJECT
                }
                #endif
            } //End MOVA
            /* RRCM, RRAM, RLAM, RRUM */
            /*else if((opCode & 0x00f0) == 0x0040 || (opCode & 0x00f0) == 0x0050){
                DO NOTHING
            }*/
            /* CMPA, ADDA, SUBA with immediate mode */
            else if((opCode & 0x00f0) >> 4 > 0x8 && (opCode & 0x00f0) >> 4 < 0xc){
                wordStep +=1;
            }
        }
        /* POPM */
        else if( !cfi && ((opCode & 0xff00) == 0x1600 /* word mode */ || (opCode & 0xff00) == 0x1700 /* address mode */)){
            /* the destination contains the upper register while the counter contains info on how many registers to pop */
            if ((opCode & 0x00ff) == 0x0010 || (opCode & 0x00ff) == 0x0000){
                outcome = REJECT;
            }
            /* This is a simple check that avoid checking whether we target a different register with an offset capable of 
            targeting the PC. This is possible because the compiler won't allow the SR to be restored (thus protecting the PC which
            is below)*/
            /* Currently this operation is not virtualised and always rejected. Nothing forbids us from virtualising it */
        }
        /* anything else */


        if(outcome == REJECTED || cfiResult == REJECTED){
            #if DEBUG
            interruptWord=opCode;
            interruptPcOld=pc_old;
            #endif
            #if REJECT
            break;
            #endif
        }
        count+=wordStep;

        /* Save the instruction address for CFI check*/
        if(!cfi){
            alwDst[counterAlwDst++] = pc_old;
            //If the counter of destination is full 
            if(counterAlwDst>=MAX_BUFFER){
                //Write it to FLASH and reset it
                flushBufferToFlash();
                counterAlwDst = 0;
                counterBuffAlwDst++;
            }// If verification is complete then flush buffer to FLASH
            else if(address + (count*2) >= lastAddress){
                flushBufferToFlash();
            }
        }
    }

    if(cfi){
        return cfiResult;
    }
#if REJECT
    return outcome;
#else
    return VERIFIED;
#endif
}



/**
** Function to check the integrity of the destination address. This function only works if called after a full verification cycle.
** PARAMS:
** - destination: address the program is jumping to.
** RETURN:
** - VERIFIED: the destination is a valid instruction
** - REJECTED: the destination is NOT a valid instruction
**/
__attribute__((section(".tcm:code"))) bool cfiCheck(uint32_t destination){
    if(
        //It is a safe value (e.g. virtual function)
        isImmediateSafeValue(destination) ||
        (
            //It is withing bundaries
            destination < (uint32_t)appTopText && 
            //THe destination is in the set of registered ones
            binarySearch(0,(counterBuffAlwDst*MAX_BUFFER*2) + ((counterAlwDst-1)*2),(uint16_t)destination) != -1
        )
    ){
        return VERIFIED;
    }else{
        return REJECTED;
    }
} 



//Binary search algorithm
__attribute__((section(".tcm:code"))) int8_t binarySearch(int16_t low, int16_t high, uint16_t key){
    while (low <= high) {
        uint16_t mid = (low + high);
        mid /= 2;
        mid -= mid%2;
        uint16_t toCompare = *((uint16_t *)(cfiDataHolder+mid));
        if (key == toCompare)
            return mid;
        if (key > toCompare)
            low = mid + 2;
        else
            high = mid - 2;
    }
    // if we reach here, then element was not present
    return -1;
}

/**
** Function to check whether the immediate address we are calling is one of the safe PISTIS entry points
** PARAMS:
** - destination: address the program is jumping to.
** RETURN:
** - 1: the destination is a valid instruction
** - 0: the destination is NOT a valid instruction
**/
__attribute__((section(".tcm:code"))) bool isImmediateSafeValue(uint32_t destination){
    return (destination == safe_br          
        || destination == safe_bra
        || destination == safe_call
        || destination == safe_calla
        || destination == safe_ret
        || destination == safe_reti
        || destination == safe_reta
        || destination == safe_mov
        || destination == safe_movx
        || destination == safe_xor
        || destination == safe_xorx
        || destination == safe_add
        || destination == safe_addx
        || destination == safe_addc
        || destination == safe_addcx
        || destination == safe_dadd
        || destination == safe_daddx
        || destination == safe_sub
        || destination == safe_subx
        || destination == safe_subc
        || destination == safe_subcx
        || destination == receive_update_address);
}

/**
** Function that writes the buffer for CFI into flash to preserve RAM. 
**/
__attribute__((section(".tcm:code"))) void flushBufferToFlash(){
    uint32_t destFlush = cfiDataHolder+(counterBuffAlwDst*512);
    // Destination already empty
    FCTL3 = FWPW;
    uint32_t * tmpArray = &alwDst;
    FCTL1 = FWPW + BLKWRT; //32bits write mode
    uint8_t i = 0;
    do{
        *((uint32_t *)destFlush+i) = tmpArray[i];
        i++;
    }while(i < counterAlwDst/2);
    if(counterAlwDst%2>0){
        FCTL1 = FWPW + WRT; //16bits write mode
        *((uint16_t *)destFlush+(i*2)) = *((uint16_t *)tmpArray+(i*2));
    }
    return;
}
#ifdef KEY_APIS
/**
** Function that reads the secret key from the key storage area
** PARAMS:
** - key: pointer to the array where the key will be stored
*/
__attribute__((section(".tcm:code"))) void getSecureKey(uint8_t * key){
    /* Unlock the BSL by jumping to its entry points after the proper configuration */
    /* The current implementation works but testing it incurs in buggy behaviour on the CCS IDE */
    __asm("MOV #0xDEAD, R13");
    __asm("MOV #0xBEEF, R14");
    __asm("MOV #0x01, R12"); // 1 = unlock
    __asm("CALLA #0x1002");
    
    /* Copy the key from the now-readable BSL. The key was loaded at pos 0x1400 */
    memcpy(key,(uint8_t * ) KEY_LOCATION,KEY_SIZE); //Load the key from the BSL
    
    /* Lock the BSL by jumping to its entry points after the proper configuration */
    __asm("MOV #0xDEAD, R13");
    __asm("MOV #0xBEEF, R14");
    __asm("MOV #0x02, R12"); // 2 = lock
    __asm("CALLA #0x1002");
}

/**
** Function that reads the secret key from the key storage area
** PARAMS:
** - key: pointer to the array where the key will be stored
*/
__attribute__((section(".tcm:code"))) void setSecureKey(uint8_t * key){
    /* Unlock the BSL by jumping to its entry points after the proper configuration */
    /* The current implementation works but testing it incurs in buggy behaviour on the CCS IDE */
    __asm("MOV #0xDEAD, R13");
    __asm("MOV #0xBEEF, R14");
    __asm("MOV #0x01, R12"); // 1 = unlock
    __asm("CALLA #0x1002");
    
    //Erase key area
    FCTL3 = FWPW; //Unlock memory controller
    FCTL1 = FWPW + MERAS; //Set erase mode BANK
    *(uint8_t * )KEY_LOCATION = 0;
    while ((FCTL3 & BUSY) == BUSY); //Wait for erasure

    /* Copy the key from the now-readable BSL. */
    memcpy((uint8_t * ) KEY_LOCATION,key,KEY_SIZE); //Load the key from the BSL
    
    /* Lock the BSL by jumping to its entry points after the proper configuration */
    __asm("MOV #0xDEAD, R13");
    __asm("MOV #0xBEEF, R14");
    __asm("MOV #0x02, R12"); // 2 = lock
    __asm("CALLA #0x1002");
}
#endif 

