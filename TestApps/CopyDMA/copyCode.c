/* 
    Author: Michele Grisafi
    Email: michele.grisafi@unitn.it
    License: MIT 
*/
#include <msp430.h> 
#include <string.h>

typedef unsigned char uint8_t;
typedef unsigned int uint16_t;
typedef unsigned long uint32_t;
typedef signed long int32_t;
typedef signed int int16_t;
typedef signed char int8_t;
typedef unsigned char bool;
/**
 * main.c
 */
const char string[] = "This is a quite long string with the only purpose of being copied. This program's only purpose is to test the overhead of the uMSP in case memory extensive operations are performed. In this case, we want to see how much overhead it is imposed by copying the entire content of the program, constant data and code, into memory.This is a quite long string with the only purpose of being copied. This program's only purpose is to test the overhead of the uMSP in case memory extensive operations are performed. In this case, we want to see how much overhead it is imposed by copying the entire content of the program, constant data and code, into memory.This is a quite long string with the only purpose of being copied. This program's only purpose is to test the overhead of the uMSP in case memory extensive operations are performed. In this case, we want to see how much overhead it is imposed by copying the entire content of the program, constant data and code, into memory.This is a quite long string with the only purpose of being copied. This program's only purpose is to test the overhead of the uMSP in case memory extensive operations are performed. In this case, we want to see how much overhead it is imposed by copying the entire content of the program, constant data and code, into memory. This is a quite long string with the only purpose of being copied. This program's only purpose is to test the overhead of the uMSP in case memory extensive operations are performed. In this case, we want to see how much overhead it is imposed by copying the entire content of the program, constant data and code, into memory.";
int main(void)
{
    WDTCTL = WDTPW | WDTHOLD;   // stop watchdog timer
    // Setup leds
    P1DIR |= BIT0;
    P4DIR |= BIT7;
    P4OUT &= 0x7f;
    P1OUT &= 0xfe;
    //TA0CTL = TASSEL_2 + ID_3 + MC_2; // Start the timer with Frequency of 1Mhz

    uint16_t * src = 0x4400;
    uint16_t * dst = 0x3400;
    volatile uint16_t * strPos = &string;
    const uint16_t size = 512*3;

    memset(dst,0,size);

    memcpy(dst,src,size);
    bool check = 1;
    for (int i = 0; i < size/2; i++){
        check *= *dst++ == *src++;
    }
    src = 0x4400;
    dst = 0x3400;
    if(!check){
        return;
    }
    memset(dst,0,size);

    __data16_write_addr((unsigned short) &DMA0SA,(unsigned long) 0x4400);
                                                // Source block address
    __data16_write_addr((unsigned short) &DMA0DA,(unsigned long) 0x3400);

    DMA0CTL &= ~DMAIFG;

    DMA0SZ = size/2;
    DMA0CTL = DMADT_5+DMASRCINCR_3+DMADSTINCR_3+DMAIE; // Rpt, inc
    DMA0CTL |= DMAEN;                         // Enable DMA0
    DMA0CTL |= DMAREQ;
    __bis_SR_register(LPM0_bits + GIE);       // LPM0 w/ interrupts

    /*check = 1;
    dst = 0x3400;
    for(int i = 0; i< strlen(string); i++){
        check *= *(char *)dst++ == *strPos++;
    }



    P1OUT |= BIT0; // Red light*/
    while(1);

    return 0;
}
void __attribute__ ((interrupt(DMA_VECTOR))) DMA_ISR (void){
    uint16_t * src = 0x4400;
    uint16_t * dst = 0x3400;

    uint16_t size = 512*3;
    bool check = 1;
    //*dst=0xffff;
    for (int i = 0; i < size/2; i++){
        check *= *dst++ == *src++;
    }
    if(check){
        P4OUT |= BIT7; //Green led is the first verification
    }else{
        P1OUT |= BIT0; // Red light
    }
    //register unsigned int stop = TA0R; // Stop timer
    //while(1);
}

