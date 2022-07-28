/* --COPYRIGHT--,BSD_EX
 * Copyright (c) 2012, Texas Instruments Incorporated
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * *  Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *
 * *  Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * *  Neither the name of Texas Instruments Incorporated nor the names of
 *    its contributors may be used to endorse or promote products derived
 *    from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
 * THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 * PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
 * OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 *******************************************************************************
 *
 *                       MSP430 CODE EXAMPLE DISCLAIMER
 *
 * MSP430 code examples are self-contained low-level programs that typically
 * demonstrate a single peripheral function or device feature in a highly
 * concise manner. For this the code may rely on the device's power-on default
 * register values and settings such as the clock configuration and care must
 * be taken when combining code from several examples to avoid potential side
 * effects. Also see www.ti.com/grace for a GUI- and www.ti.com/msp430ware
 * for an API functional library-approach to peripheral configuration.
 *
 * --/COPYRIGHT--*/
//******************************************************************************
//   MSP430F552x Demo - USCI_A1, 9600 UART Echo ISR, DCO SMCLK
//
//   Description: Echo a received character, RX ISR used. Normal mode is LPM0.
//   USCI_A1 RX interrupt triggers TX Echo.
//   See User Guide for baud rate divider table
//
//                 MSP430F552x
//             -----------------
//         /|\|                 |
//          | |                 |
//          --|RST              |
//            |                 |
//            |     P3.3/UCA0TXD|------------>
//            |                 | 115200 - 8N1
//            |     P3.4/UCA0RXD|<------------
//
// modified July 2016 Carl Michal
// default clock frequency is 1048576 Hz

//   Bhargavi Nisarga
//   Texas Instruments Inc.
//   April 2009
//   Built with CCSv4 and IAR Embedded Workbench Version: 4.21
//******************************************************************************

/** HOW TO evaluate:

This application requires a serial communication between the MCU and a sender.
Included in the app directory there is a sendBytes.py which can be used to send
over UART the bytes. In order to test the time properly, the script should be 
started with a big enough number of bytes, e.g. 2000. While it is sending bytes,
this app can be lunched and thus evaluated.
**/

#include <msp430.h>
#define MAX_RCV 255
long received = 0;
char rcvBuf;
int main(void)
{

  WDTCTL = WDTPW + WDTHOLD;                 // Stop WDT
  __dint();
  //Set up leds
  P1DIR |= BIT0;
  P4DIR |= BIT7;
  P4OUT &= 0x7f;
  P1OUT &= 0xfe;
  P4OUT |= BIT7; //Green led symbolises it started
  TA0CTL = TASSEL_2 + ID_3 + MC_2; // Start the timer with frequency of 32768 Hz

  P1DIR = 1;
  P4SEL |= BIT4+BIT5;                       // P3.3,4 = USCI_A0 TXD/RXD
  UCA1CTL1 |= UCSWRST;                      // **Put state machine in reset**
  UCA1CTL1 |= UCSSEL_2;                     // SMCLK
  UCA1BR0 = 109;                            // 1.048576 MHz 9600 (see User's Guide)
  UCA1BR1 = 0;                              // 1.04578 MHz 9600
  UCA1MCTL |= UCBRS_2 + UCBRF_0;
  UCA1CTL1 &= ~UCSWRST;                     // **Initialize USCI state machine**



  char keep = 1;

  while(keep){
      while(!(UCA1IFG & UCRXIFG));
      received++;
      rcvBuf = (char)UCA1RXBUF;
      UCA1IFG = 0;
      if (received >= MAX_RCV)
            keep = 0;
  }
  register unsigned int stop = TA0R;
  P1OUT |= BIT0; // Red light
  while(1);
}



