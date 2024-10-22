#include <msp430.h>


int main(){
    int n, f, f1, f2;

    n = 10;
    f1 = 0;
    f2 = 1;


	for(int i=2; i<=n; i++){
        f = f1 + f2;
        f1 = f2;
        f2 = f;
        __asm("MOV #0xc500, R9"); //Load the 0x3400 address into R9
        __asm("BR R9"); //Jump to the content of R9 (0x3400 points to RAM!)
    }
    P1DIR |= BIT0; // Set 1.0 pin in output (red LED)
    P1OUT |= BIT0; // Set output to 1 (red LED)
    while(1);
	return f;
}