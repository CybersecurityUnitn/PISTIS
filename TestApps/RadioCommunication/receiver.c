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
    TA2CTL = TASSEL__ACLK | MC__UP | TACLR | ID__2; // start timer
}


void delay(uint8_t x){
    uint16_t __indx=0;

    for(__indx=0;__indx<(uint16_t)x*1000;__indx++);
}
char timerSet = 0;
extern int canReceive;
void transmit_ack(uint8_t buf[], uint32_t size)
{
    cc1101_tx_power(0);

    cc1101_send(buf, size);

}

uint8_t rx_buf[255];

uint8_t ack_buf[1] = {'k'};
bool ackReceived = 0;
bool waitingForAck = 1;
int coin = 1;

void receive()
{
    uint8_t MARCstate;

    cc1101_start();
    cc1101_data_rate(5);
    cc1101_channel(1);
    bool waitingForMsg = 1;
    while (waitingForMsg){
        bool msgRight = 1;
        /* wait till a packet is received or until reset is set by interrupt*/
        uint8_t len = cc1101_receive(rx_buf);

        if(len>0){
            msgRight = 1;
            /*for(int i=0;i<len;i++){
                msgRight *= (rx_buf[i] == hash[i]);
            }*/
            __led_on(LED2);
        }
        if(msgRight)
            waitingForMsg=0;
    }

}




/**
 * main.c
 */
int main(void)
{
    WDTCTL = WDTPW | WDTHOLD;   // stop watchdog timer
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


    /* turn on interrupts */
    __enable_interrupt();


    receive();
    __led_on(LED1);
    transmit_ack(ack_buf,1);

    __bis_SR_register(LPM3_bits | GIE);

    return 0;
}

void __attribute__ ((interrupt(TIMER2_A0_VECTOR))) INT_Timer2A0(void)
{
    TA2CCTL0 = 0x00;
    TA2CTL = 0;
    canReceive = 0;
}
