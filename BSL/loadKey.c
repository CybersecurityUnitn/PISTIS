/**
* This code should be called exclusively with a custom-BSL board
*/
#include "msp430.h"

#define KEY_LENGTH 64

typedef unsigned char uint8_t;
typedef unsigned int uint16_t;


/**
* Load a static key into the TCM Safe Storage 
**/
int loadKey(){
     // Unlock the BSL by jumping to its entry points after the proper configuration
    __asm("MOV #0xDEAD, R13");
    __asm("MOV #0xBEEF, R14");
    __asm("MOV #0x01, R12"); //unlock
    __asm("CALLA #0x1002");
    uint16_t * dstKey = 0x1400;
    uint8_t key[KEY_LENGTH] = "bZPJKnrLkKgG57WJuyywSUYNVOpRQvyavcaZdeaI4J9MbY63NWOxBEn3tuFIs1xv"; 
    
    //Erase key area
    FCTL3 = FWPW; //Unlock memory controller
    FCTL1 = FWPW + MERAS; //Set erase mode BANK
    *dstKey = 0;
    while ((FCTL3 & BUSY) == BUSY); //Wait for erasure

   

    //Write the key
    FCTL3 = FWPW;
    FCTL1 = FWPW + BLKWRT; //32bits write mode
    uint8_t i = 0;
    do{
        *(dstKey+i) = key[i];
        i+=4; //Wrote 4 bytes
    }while(i < KEY_LENGTH);
    // Unlock the BSL by jumping to its entry points after the proper configuration
    __asm("MOV #0xDEAD, R13");
    __asm("MOV #0xBEEF, R14");
    __asm("MOV #0x02, R12"); //lock
    __asm("CALLA #0x1002");
    return 1;
}