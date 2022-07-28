/*******************************************************************************
**
Name : Floating-point Math
* Purpose : Benchmark floating-point math functions.
*
*******************************************************************************/
#include <msp430.h> 

float add(float a, float b) {
    return (a + b);
}
float mul(float a, float b) {
    return (a * b);
}
float div(float a, float b) {
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
    volatile float result[4];
    result[0] = 54.567;
    result[1] = 14346.67;
    result[2] = add(result[0], result[1]);
    result[1] = mul(result[0], result[2]);
    result[3] = div(result[1], result[2]);
    P1OUT |= BIT0; // Red light
    return;
}