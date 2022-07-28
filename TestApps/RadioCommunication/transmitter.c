#include <msp430.h>
#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>

#include "pinsUtil.h"
#include "pinsConfig.h"

#include "cc1101.h"

#define MAX_TX_BYTES 60


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
    TA2CTL = TASSEL__ACLK | MC__UP | TACLR | ID__4; // start timer
}


void delay(uint8_t x){
    uint16_t __indx=0;

    for(__indx=0;__indx<(uint16_t)x*1000;__indx++);
}
char timerSet = 0;
extern int canReceive;
void transmit(uint8_t buf[], uint32_t size)
{
    cc1101_start();
    cc1101_data_rate(5);
    cc1101_channel(1);
    cc1101_tx_power(0);

    cc1101_send(buf, size);


}

uint8_t tx_buf[MAX_TX_BYTES];
uint8_t rx_buf[255];
uint8_t ack_buf[] = {'k'};
bool ackReceived = 0;
bool waitingForAck = 1;
void receive_ack()
{
    do{
        /* wait till a packet is received or until reset is set by interrupt*/
        uint8_t len = cc1101_receive(rx_buf);

        if(len>0){
            bool ackRight = 1;
            for(int i=0;i<len;i++){
                ackRight *= rx_buf[i] == ack_buf[i];
            }
            ackReceived = ackRight;
        }
        if(ackReceived || !canReceive)
            waitingForAck=0;
    }while (waitingForAck);


}

const char key[] = "fioeosijiefi435jf394f93c9m3m9230cm293e48";
void encrypt(char* str, int length);

#define KEY_LENGTH 40


uint8_t measurements[MAX_TX_BYTES];

void sample(uint8_t * x ,uint8_t * y, uint8_t * z)
{
    adxl_start();

    adxl_sample(x, y, z);
    return;
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
    uint16_t sensTimer,compTimer,ackTimer,txTimer;
    /* Start timer*/
    TA1CCTL0 = 0x00;
    TA1CTL = 0;
    TA1CTL = TASSEL__ACLK | MC__CONTINUOUS | TACLR | ID__4; // start timer

    /******************* start sensing ***********************/

    for (int i =0; i<MAX_TX_BYTES/3; i++){
        sample(&measurements[i*3],&measurements[i*3+1],&measurements[i*3+2]);
    }
    sensTimer = TA1R; // Stop timer

    /******* START COMPUTATION **********/
    encrypt(str1,len1);

    memcpy(tx_buf,measurements,MAX_TX_BYTES);
    compTimer = TA1R; // Stop timer
    /********* END COMPUTATION **********/


    /* turn on interrupts */
    __enable_interrupt();
    while(!ackReceived){
        TA1R = 0;
        canReceive=1;
        waitingForAck=1;
        transmit(tx_buf, 60);
        txTimer = TA1R; // Stop timer
        /* set timeout for ack */
        __led_toggle(LED1);
        __set_timer_32KHz(31250);
        receive_ack();
    }
    ackTimer = TA1R; // Stop timer
    __led_on(LED2);
    printf("%d %d %d",compTimer,ackTimer,txTimer);
    __bis_SR_register(LPM3_bits | GIE);


    return 0;
}

void encrypt(char* str, int length){
    for(int j = 0; j < length; j++){
        str[j] ^= key[j%KEY_LENGTH];
    }
    return;
}

void __attribute__ ((interrupt(TIMER2_A0_VECTOR))) INT_Timer2A0(void)
{
    TA2CCTL0 = 0x00;
    TA2CTL = 0;
    canReceive = 0;
}
