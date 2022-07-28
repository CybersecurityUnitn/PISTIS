/*******************************************************************************
**
Name : 16-bit 2-dim Matrix
* Purpose : Benchmark copying 16-bit values.
*
*******************************************************************************/
#include <msp430.h>

typedef unsigned short UInt16;
const UInt16 m1[16][4] = {
    { 0x1234, 0x5678, 0x9012, 0x3456 }, { 0x7890, 0x1234, 0x5678, 0x9012 }, { 0x3456, 0x7890, 0x1234, 0x5678 }, { 0x9012, 0x3456, 0x7890, 0x1234 }, { 0x1234, 0x5678, 0x9012, 0x3456 }, { 0x7890, 0x1234, 0x5678, 0x9012 }, { 0x3456, 0x7890, 0x1234, 0x5678 }, { 0x9012, 0x3456, 0x7890, 0x1234 }, { 0x1234, 0x5678, 0x9012, 0x3456 }, { 0x7890, 0x1234, 0x5678, 0x9012 }, { 0x3456, 0x7890, 0x1234, 0x5678 }, { 0x9012, 0x3456, 0x7890, 0x1234 }, { 0x1234, 0x5678, 0x9012, 0x3456 }, { 0x7890, 0x1234, 0x5678, 0x9012 }, { 0x3456, 0x7890, 0x1234, 0x5678 }, { 0x9012, 0x3456, 0x7890, 0x1234 }
};
void main(void) {
    WDTCTL = WDTPW | WDTHOLD;   // stop watchdog timer
    // Setup leds
    P1DIR |= BIT0;
    P4DIR |= BIT7;
    P4OUT &= 0x7f;
    P1OUT &= 0xfe;

    P4OUT |= BIT7; //Green led is the first verification
    //TA0CTL = TASSEL_2 + ID_0 + MC_2; // Start the timer with frequency of 32768 Hz
    int i, j;
    volatile UInt16 m2[16][4], m3[16][4];
    for (i = 0; i < 16; i++) {
        for (j = 0; j < 4; j++) {
            m2[i][j] = m1[i][j];
            m3[i][j] = m2[i][j];
        }
    }
    //register unsigned int stop = TA0R; // Stop timer
    P1OUT |= BIT0; // Red light
    //while(1);
    return;
}