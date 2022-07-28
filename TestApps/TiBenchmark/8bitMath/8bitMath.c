/*******************************************************************************
**
Name : 8-bit Math
* Purpose : Benchmark 8-bit math functions.
*
*******************************************************************************/
#include <msp430.h>

typedef unsigned char UInt8;
UInt8 add(UInt8 a, UInt8 b) {
    return (a + b);
}
UInt8 mul(UInt8 a, UInt8 b) {
    return (a * b);
}
UInt8 div(UInt8 a, UInt8 b) {
    return (a / b);
}
void main(void) {
    WDTCTL = WDTPW | WDTHOLD;   // stop watchdog timer
    // Setup leds
    P1DIR |= BIT0;
    P4DIR |= BIT7;
    P4OUT &= 0x7f;
    P1OUT &= 0xfe;

    P4OUT |= BIT7; //Green led is the first verification
    volatile UInt8 result[4];
    result[0] = 12;
    result[1] = 3;
    result[2] = add(result[0], result[1]);
    result[1] = mul(result[0], result[2]);
    result[3] = div(result[1], result[2]);
    P1OUT |= BIT0; // Red light

    return;
}