#include <msp430.h> 
#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>

#include "pinsUtil.h"
#include "pinsConfig.h"

#include "cc1101.h"

void __clock_init()
{
    // XT1 Setup
    PJSEL0 |= BIT4 | BIT5;
    CSCTL0_H = CSKEY >> 8;                    // Unlock CS registers
    CSCTL1 = DCOFSEL_0; // 1 MHz
    //CSCTL1 = DCOFSEL_3; // 4 MHz
    //CSCTL1 = DCOFSEL_3 | DCORSEL; // 8 MHz
    CSCTL2 = SELA__LFXTCLK | SELS__DCOCLK | SELM__DCOCLK; // Set MCLK = SMCLK = DCO
    // ACLK = XT1;
    CSCTL3 = DIVA__1 | DIVS__1 | DIVM__1;     // set all dividers

    /* TODO: test XTAL with new capacitor */
    CSCTL4 &= ~LFXTOFF;
    do
    {
        CSCTL5 &= ~LFXTOFFG;                    // Clear XT1 fault flag
        SFRIFG1 &= ~OFIFG;
    }
    while (SFRIFG1 & OFIFG);                   // Test oscillator fault flag
    CSCTL0_H = 0;  // Lock CS registers                     // Lock CS registers
}

void __set_timer_32KHz(uint16_t ticks)
{
    /* stop timer */
    TA2CCTL0 = 0x00;
    TA2CTL = 0;
    TA2CCR0 = ticks; // Take current count + desired count
    TA2CCTL0 = CCIE; // Enable Interrupts on Comparator register
    TA2CTL = TASSEL__ACLK | MC__UP | TACLR; // start timer
}

uint8_t tx_buf[] = { 'H','e','l','l','o',' ','w','o','r','l','d'};

void delay(uint8_t x){
    uint16_t __indx=0;

    for(__indx=0;__indx<(uint16_t)x*1000;__indx++);
}

void transmit()
{
    cc1101_start();
    cc1101_data_rate(5);
    cc1101_channel(1);
    cc1101_tx_power(0);

    while (1)
    {
        /* send the variable length packet */
        cc1101_send(tx_buf, sizeof(tx_buf));

        /* toggle leds */
        __led_toggle(LED1);
        __led_toggle(LED2);

        /* approximately 1 second */
        __set_timer_32KHz(31250);
        __bis_SR_register(LPM3_bits | GIE);
    }
}

uint8_t rx_buf[10];

void receive()
{
    uint8_t MARCstate;

    cc1101_start();
    cc1101_data_rate(5);
    cc1101_channel(1);

    while (1)
    {
        /* wait till a packet is received */
        uint8_t len = cc1101_receive(rx_buf);

        if(len>0){
            int i = 0;
            printf("Length: %d Payload:",len);
            for(i=0;i<len;i++){
                printf("%c",rx_buf[i]);
            }
            printf("\n");
            __led_toggle(LED1);
            __led_toggle(LED2);
        }
    }

}

void sample()
{
    adxl_start();
    while (1)
    {
        uint8_t x, y, z;
        adxl_sample(&x, &y, &z);
        printf("%d %d %d \n", x, y, z);
    }
}

/**
 * main.c
 */
int main(void)
{
    WDTCTL = WDTPW | WDTHOLD;	// stop watchdog timer
    PM5CTL0 &= ~LOCKLPM5; // Disable the GPIO power-on default high-impedance mode
    __clock_init();

    // Disable FRAM wait cycles to allow clock operation over 8MHz
    FRCTL0 = 0xA500 | ((1) << 4); // FRCTLPW | NWAITS_1;
    __delay_cycles(3);

    /* init FRAM */
    FRCTL0_H |= (FWPW) >> 8;

    __delay_cycles(3);

    __led_init(LED1);
    __led_init(LED2);

    __led_toggle(LED1);
    __led_toggle(LED2);

    /* turn on interrupts */
    __enable_interrupt();

  //sample();
  //transmit();
  receive();
    while(1){
        __set_timer_32KHz(31250);
        __bis_SR_register(LPM3_bits | GIE);
    }

    return 0;
}

#pragma vector=TIMER2_A0_VECTOR //TCCR0 Interrupt Vector for TIMER A1
__interrupt void INT_Timer2A0(void)
{
    TA2CCTL0 = 0x00;
    TA2CTL = 0;
    /* turn on CPU */
    __bic_SR_register_on_exit(LPM3_bits);
}
