/* 
    Author: Michele Grisafi
    Email: michele.grisafi@unitn.it
    License: MIT 
*/
#ifndef HEADER_FILE_SEC_UPDATE
#define HEADER_FILE_SEC_UPDATE
#include "core.h"
#define RCV_LIMIT 512
#define PAGE_SIZE 512
#define APP_INSTR_MEM_PAGES 64
#define UCA1_OS   1    // 1 = oversampling mode, 0 = low-freq mode
#define UCA1_BR0  17   // Value of UCA1BR0 register
#define UCA1_BR1  0    // Value of UCA1BR1 register
#define UCA1_BRS  0    // Value of UCBRS field in UCA1MCTL register
#define UCA1_BRF  6    // Value of UCBRF field in UCA1MCTL register

#define ONLY_CODE 1  //Whether or not to only deploy the code section
#define ONLY_DATA 0  //Whether or not to only deploy the data sections

#define NOBITS 0 //phead type
#define FLASH 1  //phead type
#define RAM 2    //phead type

/** Struct used for the parsing of the ELF file **/
typedef struct __attribute__((__packed__))
{
    uint16_t size;
    uint32_t address;
    uint8_t type; /* 0 = NOBITS, 1 = FLASH, 2 = RAM*/
    uint16_t offset;
} elf_phead;

uint8_t overWriteMemory(uint8_t* buf, uint16_t len, uint8_t* dstAddress);
bool deploy(uint16_t * lastAppAddress, bool whatToLoad);
void launchVerification(uint16_t lastAppAddress);
bool load_elf_segment(uint32_t elfAddress, elf_phead *phead, uint16_t * lastAppAddress);
void secureUpdate();
void INTERRUPT_ISR(void);
#endif
