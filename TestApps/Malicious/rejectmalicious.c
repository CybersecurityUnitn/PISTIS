#include <msp430.h>

int main(void){
    __asm("BR #0x3400"); //Jump to RAM (0x3400 points to RAM!)
    return 0;
}
