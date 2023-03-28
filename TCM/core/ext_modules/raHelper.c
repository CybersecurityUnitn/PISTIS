/* 
    Author: Michele Grisafi
    Email: michele.grisafi@unitn.it
    License: MIT 
*/
/*
    This file contains helper function to handle the remote attestation.
    Specifically, it takes care of backing up and restoring the RAM content.
*/
#include "msp430.h"
#include "raHelper.h"
__attribute__((section(".tcm:rodata"))) const uint32_t backupAddress = 0x0001c400;

__attribute__((section(".tcm:codeUpper"))) bool backupRam(uint16_t from, uint16_t to){
    FCTL3 = FWPW; //Unlock memory controller
    FCTL1 = FWPW + ERASE; //Set erase mode
    
    //Bad memory range
    if(from >= to){
        return 0;
    }
    //Reset the backup area
    for(uint8_t i = 0; from+i*512<to;i++){
        *(uint32_t *)(backupAddress + i*512) = 0;
    }
    FCTL1 = FWPW + BLKWRT; //Set long word (32bits) writing mode
    //Store backup
    for(uint16_t i = 0; (from+i*4)<to;i++){
        *(uint32_t *)(backupAddress + i*4) = *(uint32_t *)(from+i*4);
    }
    FCTL3 = FWPW+LOCK; //Lock memory controller
    return 1;
}

__attribute__((section(".tcm:codeUpper"))) bool restoreRam(uint16_t from, uint16_t to){
    //Bad memory range
    if(from >= to){ //Other checks could be performed but we limit them to preserve speed
        return 0;
    }
    //Restore RAM
    for(uint16_t i = 0; (from+i*4)<to;i++){
        *(uint32_t *)(from+i*4) = *(uint32_t *)(backupAddress + i*4);
    }
    return 1;
}

