#include <msp430.h>

int main(void){
    __asm("MOV #0x3400, R9"); //Load the 0x3400 address into R9
    __asm("BR R9"); //Jump to the content of R9 (0x3400 points to RAM!)
    return 0;
}