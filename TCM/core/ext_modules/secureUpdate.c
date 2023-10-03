/* 
    Author: Michele Grisafi
    Email: michele.grisafi@unitn.it
    License: MIT 
*/
/*
    Secure Update TA that initiate an UART connection to receive an application image.
    The image will be received in chunks, each one acknowledged, and then deployed
    Following PISTIS memory map. Prior to the deployment, this TA will call the verifier
    module to attest the safety of the binary.    
*/
#include "msp430.h"
#include "stdlib.h"
#include "core.h"
#include "secureUpdate.h"

//Backup content of ISRs instead of using default ones
#define DYNAMIC_BACKUP 0 

//Perform verification of the received application
#define VERIFY 1 

#define BEGUG_ANALYSER 0

//The number of bytes used by the TCM after the 0xffee address. 
#define OVERFLOWTCM 70


//the lenght of the metadata encoding the image length
__attribute__((section(".tcm:rodata"))) const char dataLengthBytes = 2;

//Default values in the Interrupt Vector Table (IVT)
__attribute__((section(".tcm:rodata"))) const uint32_t oldISR[32] = {0xF808F800,0xF818F810,0xF828F820,0xF838F830,0xF848F840,0xF858F850,0xF868F860,0xF878F870,0xF888F880,0xF898F890,0xF8A8F8A0,0xF8B8F8B0,0xF8C8F8C0,0xF8D8F8D0,0xF8E8F8E0,0xF8F8F8F0,0xF908F900,0xF918F910,0xF928F920,0xF938F930,0xF948F940,0xF958F950,0xF968F960,0xF978F970,0xF988F980,0xF998F990,0xF9A8F9A0,0xF9B8F9B0,0xF9C8F9C0,0xF9D8F9D0,0xF9E8F9E0,0xC400F9F0};

//Buffer for incoming packets
volatile char rcvBuf[RCV_LIMIT];

//Counter of incoming packtes
volatile uint16_t rcvBufCount;


/**
 *  Initiate update of the application via serial communication
 */
__attribute__((section(".tcm:code"))) void secureUpdate(){
    // stop watchdog timer
    WDTCTL = WDTPW | WDTHOLD; 
 
    //Disable interrupts during setup phase  
    __dint();

    /* setup variables */ 
    uint32_t written = 0;
    uint16_t dataLength = 0;
    rcvBufCount = 0;
    uint8_t canRead = 0;
    memset(rcvBuf,0,RCV_LIMIT);
    

    /* SET UP THE UART INTERFACE FOR RX and TX */
    
    //P4SEL = 0x20;
    P4SEL |= BIT4+BIT5; //Configure UART in both TX and RX
    UCA1CTL1 |= UCSWRST;  // Put the USCI state machine in reset
    UCA1CTL1 |= UCSSEL_1;

    // Set the baudrate
    UCA1BR0 = 3;
    UCA1MCTL = 0x06;
    UCA1CTL0 = 0x00;
    UCA1CTL1 &= ~UCSWRST;       // Take the USCI out of reset

    /* ENABLE INTERRUPTS FOR RX*/
    UCA1IE |= UCRXIE;

   

    
    //Erase code update storage segment
    uint16_t * dstErase = elfAddress;
    FCTL3 = FWPW; //Unlock memory controller
    FCTL1 = FWPW + MERAS; //Set erase mode BANK
    *dstErase = 0;
    while ((FCTL3 & BUSY) == BUSY); //Wait for erasure

    
    
    /* Replace app's vector table for UART with the one used by PISTIS */
    uint16_t vector_base = 0xfe00; //Address of first IVT segment (we cannot use 0xff80 because we must perform at least a segment erase)
    uint16_t vector_uart = 0xffdc; //Address of the UART IVT entry
    uint16_t reset_vector = 0xfffe; //Address of the reset IVT entry

    //Create an array of 70 bytes to store the TCM virtual functions after 0xfe00 (which gets deleted)
    uint16_t tcmFunctions[OVERFLOWTCM];
    //Copy the TCM virtual functions to the array
    for(uint16_t i=0;i<OVERFLOWTCM/2;i++){
        tcmFunctions[i] = *(uint16_t *)(vector_base+(i*2));
    }
    #if DYNAMIC_BACKUP
    //Save the old content of the IVT
    volatile uint32_t oldISR[32];
    for(uint8_t i=0;i<(128/4);i++){
        oldISR[i] = *(uint32_t *)(vector_base+(i*4));
    }
    //oldISR[22] = 0xFB70FB68;
    #endif

    

    /* ERASE IVT */
    FCTL3 = FWPW; //Unlock memory controller
    FCTL1 = FWPW + ERASE; //Set erase mode 512 Bytes
    *((uint16_t *)vector_base) = 0;
    while ((FCTL3 & BUSY) == BUSY); //Wait for erasure

    

    /* Replace IVT entries */
    FCTL3 = FWPW; //Unlock memory controller
    FCTL1 = FWPW + WRT;
    //Set the vector for UART to the new function INTERRUPT_ISR
    *((uint16_t *)vector_uart)=(INTERRUPT_ISR);
    //Set the reset vector the the verification function
    *((uint16_t *)reset_vector)=0xc400;

    //Copy back the TCM virtual functions
    for(uint16_t i=0;i<OVERFLOWTCM/2;i++){
        *((uint16_t *)(vector_base+(i*2))) = tcmFunctions[i];
    }
    

    __eint(); //enable global interrupts

    /* SET UP LEDS for feedback. */

    P4DIR |= BIT7; //Set 4.7 pin in output (green LED)
    P4OUT &= 0x7f; //Turn off the green LED
    P1OUT &= 0xfe; //Turn off the red LED
    
    //Turn on green led 10 times to indicate that the device is ready to receive an update
    for(int i = 0; i < 10; i++){
        P4OUT ^= BIT7; // Toggle green LED
        for(int j = 0; j < 10000; j++){ // Delay
            __asm("nop");
        }
    }
    //Green led: ready for incoming packets
    P4OUT |= BIT7; //Set output to 1

    
    //Cycle and wait for the update
    while(1){
        //Received length metadata
        if(!canRead && rcvBufCount==dataLengthBytes){ 
            //Store the first 2 bytes received over UART in the dataLength field
            dataLength = (uint16_t)rcvBuf[0]<<8 | (uint16_t)rcvBuf[1];
            
            //The reception can resume
            canRead =1;
            rcvBufCount=0;

            //Send ACK
            UCA1TXBUF = 0x54;
            // Wait until each bit has been clocked out...
            while(!(UCTXIFG==(UCTXIFG & UCA1IFG))&&((UCA1STAT & UCBUSY)==UCBUSY));
        }
        
        //The buffer is full or it has received the last data
        if(rcvBufCount == RCV_LIMIT || (rcvBufCount+written == dataLength && canRead)){
            
            //Dump the buffer, which is in ram, to the memory. 
            overWriteMemory(rcvBuf,rcvBufCount,(char *)(elfAddress+written));
            
            //Keep track of dumped bytes
            written += rcvBufCount;

            //Reset the buffer so that we can keep on receiving the image
            rcvBufCount=0;
            
            //Re enable interrupts
            UCA1IE |= UCRXIE; 
            
            //Send ACK
            UCA1TXBUF = 0x54;
            // Wait until each bit has been clocked out...
            while(!(UCTXIFG==(UCTXIFG & UCA1IFG))&&((UCA1STAT & UCBUSY)==UCBUSY));
        }

        //The data has been completely written
        if(canRead && written >= dataLength){

            //Application received
            P4OUT &= 0x7f; // Turn off the green LED
            
            //Initialise variable to hold the last address of the app code
            uint16_t lastAppAddress = 0;

            //Disable UART interrupts
            UCA1IE &= ~UCRXIE;
            //Disable global interrupts
            __dint();

            /****** IMAGE HAS BEEN CORRECTLY RECEIVED ******/
            /* Clear memory to start deployment */
            //Erase text segment
            dstErase = appBottomText;
            FCTL3 = FWPW; //Unlock memory controller
            FCTL1 = FWPW + MERAS; //Set erase mode BANK
            *dstErase = 0;
            while ((FCTL3 & BUSY) == BUSY); //Wait for erasure

            //Erase RO data segment
            dstErase = appBottomROdata;
            FCTL3 = FWPW; //Unlock memory controller
            FCTL1 = FWPW + MERAS; //Set erase mode BANK
            *dstErase = 0;
            while ((FCTL3 & BUSY) == BUSY); //Wait for erasure

            /* Restore the user ISR */

            //Erase TCM temporary ISRs
            FCTL3 = FWPW; //Unlock memory controller
            FCTL1 = FWPW + ERASE; //Set erase mode
            *(uint16_t *)(vector_base) = 0;
            while ((FCTL3 & BUSY) == BUSY); //Wait for erasure

            

            //Copy back the TCM virtual functions
            FCTL3 = FWPW;
            FCTL1 = FWPW + BLKWRT;
            for(uint16_t i=0;i<OVERFLOWTCM/2;i++){
                *((uint16_t *)(vector_base+(i*2))) = tcmFunctions[i];
            }
            
            // Restore default secure ISRs

            vector_base = 0xff80;
            
            for(int i=0;i<(128/4);i++){
                *(uint32_t *)(vector_base+(i*4)) = oldISR[i];
            }

            /****** START deployment ******/
            //Deploy only code section
            bool deployed = deploy(&lastAppAddress,ONLY_CODE);
            
            //Deploy failed
            if(deployed == 0){
                //WDTCTL = 6; //Software reset!
                //Restart update
                __asm("\n\tBR #secureUpdate");
            }


            

            //Verify received code
            launchVerification(lastAppAddress);
        }
    }
}

/** Perform a boot after an update
 * PARAMS:
 * -lastAppAddress: the last address to be verified. This value will be updated.
 * */
__attribute__((section(".tcm:code"))) void launchVerification(uint16_t lastAppAddress){


    #if VERIFY
    //Red led is the first verification
    P1OUT |= BIT0; //Set output to 1
    #if BEGUG_ANALYSER
        //Analyser on 4.2
        P4DIR |= BIT2; //Set output to 1
        P4OUT |= BIT2; //Set output to 1
    #endif

    //Perform both code and CFI verification. This will erase the RoData of the app!
    bool codeStatus = verify_app_inst(appBottomText,lastAppAddress);

    
    bool cfiStatus = verify_app_cfi(appBottomText,lastAppAddress);

    
    //IF failed verification then reject the update
    if(codeStatus == VERIFIED && cfiStatus == VERIFIED){
    #endif
        #if BEGUG_ANALYSER
        //Analyser on 4.0
        P4DIR |= BIT0; //Set output to 1
        P4OUT |= BIT0; //Set output to 1
        #endif
        
        /* Clear RoData section from CFI temporary data */
        FCTL3 = FWPW; //Unlock memory controller
        FCTL1 = FWPW + MERAS; //Set erase mode BANK
        *(uint16_t *)appBottomROdata = 0;
        while ((FCTL3 & BUSY) == BUSY); //Wait for erasure


        bool deployed = deploy(lastAppAddress,ONLY_DATA); 
        if(deployed == 0){
            WDTCTL = 6; //Software reset!
        }

        launchAppCode();
    #if VERIFY
    }else{
        #if BEGUG_ANALYSER
        //Analyser on 4.3
        P4DIR |= BIT3; //Set output to 1
        P4OUT |= BIT3; //Set output to 1
        #endif
        __asm("\n\tBR #secureUpdate");
    }
    #endif
}

/**
 * Manage interrupts from the UART interface, generated as soon as a new character is received.
 */
__attribute__((section(".tcm:code"))) void __attribute__ ((interrupt(01))) INTERRUPT_ISR(void){
    // A char has been received over UART. Store it in the buffer
    rcvBuf[rcvBufCount++] = (char)UCA1RXBUF;

    //Buffer full
    if(rcvBufCount==RCV_LIMIT){
        // Disable interrupts if the buffer is full
        UCA1IE &= ~UCRXIE;
    }
}

/**
 * Overwrite flash memory. Assumes already cleared memory!!
 * PARAMS:
 * -buf: the buffer containing the data to be copied into the Flash memory
 * -len: the number of character (8 bits symbols) to be copied
 * -dstAddress: the address where to copy the data
 * -eraseCycle: whether or not to erase the memory before writing, operation necessary if the memory is not empty
 * RETURN: (TODO) 1 if operation was successful, error code otherwise.
 */
__attribute__((section(".tcm:code"))) uint8_t overWriteMemory(uint8_t* buf, uint16_t len, uint8_t * dstAddress){
    
    uint16_t i = 0;
    //Unlock memory
    FCTL3 = FWPW;

    //It's not aligned to 4 bytes
    if((uint32_t)dstAddress%4>0){

        //Set write mode
        FCTL1 = FWPW + WRT;

        //Copy first two bytes content of buffer to destination address
        *((uint16_t *)dstAddress) = (uint16_t)*((uint16_t*)buf);

        //Increase the counters
        dstAddress+=2;
        buf+=2;
        len-=2;
    }else{
        //Set block write mode for better performance
        FCTL1 = FWPW + BLKWRT;
    }

    uint16_t length = len/4;// + (len%4>0?1:0); //Partial long words might be copied, not a problem

    //Begin writing
    do{
        *((uint32_t *)dstAddress+i) = (uint32_t)*((uint32_t*)buf+i);
        i++;
    }while(i<length);

    //If number of bytes are not multiple of 4 bytes
    if(len%4>0){
        //Set write mode
        FCTL1 = FWPW + WRT;
        //Copy last two bytes
        *((uint16_t *)dstAddress+(i*2)) = (uint16_t)*((uint16_t*)buf+(i*2));
    }

    return 1;
}


/**
 * Parse elf file to deploy the program received via UART. This method is courtesy of http://www.thomasloven.com/blog/2013/08/Loading-Elf/
 * PARAMS:
 * -lastAppAddress: the last address to be verified. This value will be updated.
 * -whatToLoad: whether we are loading only code in flash, or only the RO-DATA and RAM segments
 * RETURN: 0 if there was some error in the deployment, 1 otherwise. 
 */
__attribute__((section(".tcm:codeUpper"))) bool deploy(uint16_t *lastAppAddress, bool whatToLoad){
    //Start reading the elf
    uint8_t sections = *((uint8_t *)elfAddress);
    elf_phead * currentSection;

    //Cycle through ELF sections
    for (uint8_t i = 0; i < sections; i++){

        //Read current section
        currentSection = (elf_phead *) (elfAddress  + 1 +(sizeof(elf_phead)*i));
        if( 
            /* App code */
            (whatToLoad == ONLY_CODE 
                && currentSection->type == FLASH  
                && currentSection->address < appTopText) || 
            /* RO-data and RAM */
            (whatToLoad == ONLY_DATA 
                && currentSection->type >= FLASH  //RAM or FLASH
                && (currentSection->address < appBottomText //RAM
                    || currentSection->address > appTopText) //RODATA
            )
        ){
            //Try to load elf segment in memory 
            if (!load_elf_segment(elfAddress, currentSection, lastAppAddress)){
                //Loading failed
                return 0;
            }
        }
    }
    return 1;
}

/**
 * Load an elf segment in the right section of the memory
 * PARAMS:
 * -elfAddress: the pointer to the beginning of the elf file
 * -phead: pointer to the struct containing the information about the segment
 * -lastAppAddress: the last Address to be verified (app code)
 * RETURN: 1 if loaded, 0 otherwise
 */
__attribute__((section(".tcm:codeUpper"))) bool load_elf_segment(uint32_t elfAddress, elf_phead *phead, uint16_t *lastAppAddress){
    uint16_t memsize = phead->size;     // Size in memory
    uint32_t mempos = phead->address;   // destination address
    uint16_t offset = phead->offset;    // Offset in file
    uint16_t type = phead->type;        // Type of section

    //Empty section -> no need to load
    if(memsize == 0) return 1;

    /* Check in which memory the segment should be loaded to: RAM or FLASH */

    //Segment in RAM
    if(mempos >= appBottomRam && mempos + memsize <= appTopRam){
        //Copy the data (memcpy since it's in RAM)
        memcpy(mempos,elfAddress+offset,memsize);
        return 1;
    }

    //Load segment in the flash. We don't care in which part of the Application memory.
    else if(mempos >= appBottomText && mempos+memsize <= appTopText){

        //Copy the content to FLASH
        if(overWriteMemory(elfAddress+offset, memsize, mempos) == 1){
            //Overwrite the last app address if bigger than current one
            if (*lastAppAddress < mempos+memsize){
                *lastAppAddress=mempos+memsize;
            }
            return 1;
        }
    }
    
    // Load ROdata in FLASH
    else if(mempos >= appBottomROdata && mempos+memsize <= appTopROdata){
        
        //Copy content to FLASH
        if(overWriteMemory(elfAddress+offset, memsize, mempos) == 1){
            return 1;
        }
    }
    //Load segment into the user IVT --> new ISRs 
    else if(mempos >= vectorBottom && mempos+memsize <= vectorTop){
        //Load IVT entries in FLASH (not on the IVT but on the userIVT)
        if(overWriteMemory(elfAddress+offset, memsize, mempos) == 1){
            return 1;
        }
    }
    return 0;
}
