/* TI Text File License

Copyright (c) 2018 Texas Instruments Incorporated

All rights reserved not granted herein.

Limited License.

Texas Instruments Incorporated grants a world-wide, royalty-free, non-exclusive license under copyrights 
and patents it now or hereafter owns or controls to make, have made, use, import, offer to sell and sell 
("Utilize") this software subject to the terms herein. With respect to the foregoing patent license, 
such license is granted solely to the extent that any such patent is necessary to Utilize the software alone. 
The patent license shall not apply to any combinations which include this software, other than combinations 
with devices manufactured by or for TI ("TI Devices"). No hardware patent is licensed hereunder.

Redistributions must preserve existing copyright notices and reproduce this license (including the above 
copyright notice and the disclaimer and (if applicable) source code license limitations below) in the 
documentation and/or other materials provided with the distribution

Redistribution and use in binary form, without modification, are permitted provided that the following 
conditions are met:

* No reverse engineering, decompilation, or disassembly of this software is permitted with respect to 
any software provided in binary form.

* any redistribution and use are licensed by TI for use only with TI Devices.

* Nothing shall obligate TI to provide you with source code for the software licensed and provided to you 
in object code.

If software source code is provided to you, modification and redistribution of the source code are permitted 
provided that the following conditions are met:

* any redistribution and use of the source code, including any resulting derivative works, are licensed by 
TI for use only with TI Devices.

* any redistribution and use of any object code compiled from the source code and any resulting derivative works, 
are licensed by TI for use only with TI Devices.

Neither the name of Texas Instruments Incorporated nor the names of its suppliers may be used to endorse or 
promote products derived from this software without specific prior written permission.

DISCLAIMER.

THIS SOFTWARE IS PROVIDED BY TI AND TI'S LICENSORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, 
BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. 
IN NO EVENT SHALL TI AND TI'S LICENSORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, 
STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, 
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.*/

/*******************************************************************************
*  Change Log:
*  1.2.11  LCW   Initial release at 0x02 based on I2C from Apps team
*  -----------------------------------------------------------------------------
*  Version 3 work begins
*  08.03.11 LCW  Increased MCLK to 8MHz
*  -----------------------------------------------------------------------------
*  19.06.13 BEP  Fixed bug when sending multiple I2C packets. Fixed UART bug
*                where changing the baud rate caused the following command to
*                fail.  Added support for RX timeout (Thunderbolt)
*  -----------------------------------------------------------------------------
*  12.07.13 BEP  Fixed issues found during verification with I2C packets always
*                sending an acknowledgement byte.
*  -----------------------------------------------------------------------------
*  Version B3
*  05/22/14 MG   Adding initialization function for passive and active listening
*  03/27/15 MG   Adding defines to include/exclude passive listening
*******************************************************************************/
extern void interpretCommand();

#include "BSL_Device_File.h"
#include "BSL430_PI.h"
#include "BSL430_Command_Interpreter.h"
#include "BSL430_Command_Definitions.h"
#include <assert.h>

//errors
#define HEADER_INCORRECT (PI_COMMAND_UPPER + 0x01)
#define CHECKSUM_INCORRECT (PI_COMMAND_UPPER + 0x02)
#define PACKET_SIZE_ZERO (PI_COMMAND_UPPER + 0x03)
#define PACKET_SIZE_TOO_BIG (PI_COMMAND_UPPER + 0x04)
#define UNKNOWN_ERROR (PI_COMMAND_UPPER + 0x05)

//******************************************************************************
// I2C Definitions and variables
//******************************************************************************
#define MAX_BUFFER_SIZE 260
//#define SLAVE_ADDRESS 0x48
void receiveDataFromMaster_I2C(unsigned char);
void sendByte_I2C(char data);
char PI_receivePacket_I2C();
void PI_sendData_I2C(unsigned int size);
__no_init unsigned char byStatusByte_I2C;
__no_init unsigned int  transmitBufferLength_I2C;
__no_init unsigned int  rxdataPointer_I2C;
__no_init unsigned int  transmitPoint_I2C;

//******************************************************************************
// UART Definitions and variables
//******************************************************************************
#define UNKNOWN_BAUD_RATE (PI_COMMAND_UPPER+0x06)
#define CHANGE_BAUD_RATE (PI_COMMAND_UPPER + 0x02)
// 4800 (unused)
#define BAUD_4800   0x01
#define BAUD_9600   0x02
#define BAUD_19200  0x03
#define BAUD_38400  0x04
#define BAUD_57600  0x05
#define BAUD_115200 0x06
void init_USCI_UART( char baud_rate );
char PI_receivePacket_UART();
void PI_sendData_UART(unsigned int size);
char receiveByte_UART();
void sendByte_UART(char data);

//******************************************************************************
// shared definitions and variables
//******************************************************************************
char verifyData(int checksum);
void interpretPI_Command();

__no_init unsigned char          RX_StatusFlags;  // = RX_PACKET_ONGOING;
__no_init unsigned char          PI_State;  // = PI_STATE_UART;
__no_init char         *BSL430_ReceiveBuffer;
__no_init char         *BSL430_SendBuffer;
__no_init unsigned int BSL430_BufferSize;
__no_init unsigned int BSL430_Timeout;
__no_init unsigned long BSL430_Timeout_count;

#define USCI_I2C_UART_VERSION 0x03

const unsigned char BSL430_PI_Version @ "BSL430_VERSION_PI" =
    (BSL430_eUSCI_I2C_UART_PI + USCI_I2C_UART_VERSION);
#pragma required=BSL430_PI_Version

#pragma data_alignment=2
__no_init char         RAM_TX_Buf[MAX_BUFFER_SIZE+6];
__no_init char         RAM_RX_Buf[MAX_BUFFER_SIZE+6];

//#define                RX_TX_Buffer BSL430_ReceiveBuffer

/*******************************************************************************
* *Function:    PI_init  - I2C
* *Description: Initializes the I2C Slave
*  Returns:      None
*******************************************************************************/
void PI_init()
{
#ifndef BSL2_PASSIVE_TIMEOUT
#ifdef DCOFSEL2
    #ifdef FR26xx
    #warning Use PI_init_passive and PI_init_active for FR26xx.
    #else
    // FR5969 Clock System
    CSCTL0 = CSKEY;
    CSCTL1 = DCORSEL + DCOFSEL0+DCOFSEL1;     // DCORSEL = 1 + DCOFSEL_3 = 8MHz
    CSCTL3 = 0;                               // Clear all dividers
    CSCTL2 |= SELM__DCOCLK + SELS__DCOCLK;    // MCLK = SMCLK = 8MHz
    CSCTL0_H = 0xFF;
    #endif
#else
    // FR5736 Clock System
    CSCTL0 = CSKEY;
    CSCTL1 = DCOFSEL0+DCOFSEL1;               // DCORSEL = 0 + DCOFSEL_3 = 8MHz
    CSCTL3 = 0;                               // Clear all dividers
    CSCTL2 |= SELM__DCOCLK + SELS__DCOCLK+SELA__DCOCLK;  // MCLK = SMCLK = 8MHz
    CSCTL0_H = 0xFF;
#endif
#endif

    // RX buffer for both modes.
    BSL430_ReceiveBuffer = RAM_RX_Buf;
    PI_State = *((unsigned char*)BSL_STATE_ADDR);  // get state
    /* For debug means you can set PI_State = PI_STATE_I2C or PI_STATE_UART */

    if( PI_State == PI_STATE_I2C )
    {
        transmitBufferLength_I2C = 0;           // init I2C variables here
        rxdataPointer_I2C = 0;
        transmitPoint_I2C = 0;

        I2C_PORT_SEL0 |= SDA + SCL;             // Assign I2C pins to USCI_B1
        I2C_PORT_SEL1 = 0;                      // Clear everything, including SDA/SCL for size
        I2C_UCZNCTL1 = UCSWRST;                 // Enable SW reset
        I2C_UCZNCTL0 = UCMODE_3 + UCSYNC;       // I2C Slave, synchronous mode
        I2C_UCZNI2COA = (*((unsigned char*)BSL_CONFIG_ADDR))| UCOAEN;
        /* For debug means you can set I2C_UCZNI2COA = 0x48 + UCOAEN; */
        I2C_UCZNCTL1 &= ~UCSWRST;               // Clear SW reset, resume operation

        I2C_UCZNIE |= UCTXIE0 + UCRXIE0 + UCSTPIE + UCSTTIE;

        BSL430_SendBuffer = &RAM_TX_Buf[4];
    }
    else if ( PI_State == PI_STATE_UART )
    {
        init_USCI_UART( BAUD_9600 );
        BSL430_SendBuffer = RAM_RX_Buf;
    }

} //init

/*******************************************************************************
* *Function:    PI_init_passive
* *Description: Initializes UART and I2C for passive listening
* *Returns:     None
*******************************************************************************/
void PI_init_passive()
{
#ifdef BSL2_PASSIVE_TIMEOUT
    #if defined(FR26xx) || defined(FR23xx)
    // MCLK = SMCLK = 8MHz, ACLK = REFO = ~32kHz, default values in other regs
    __bis_SR_register(SCG0);  // Disable FLL
    CSCTL0 = 0x0;
    CSCTL1 = DCOFTRIM_3 + DCORSEL_3 + DISMOD;  // DCO = 8MHz
    CSCTL2 = FLLD_0 + FLLN7 + FLLN6 + FLLN5 + FLLN4 + FLLN1 + FLLN0;  // DCO/1, *(243+1)
    CSCTL3 = SELREF0;  // Select REFOCLK as FLL reference
    CSCTL4 = SELA;  // Selct REFO as ACLK source
    CSCTL5 = VLOAUTOOFF;
    CSCTL6 = XT1DRIVE0 + XT1DRIVE1;  // ACLK/1, XT1DRIVE to default
    CSCTL7 = 0;  // Configure default settings and clear all fault flags.
    CSCTL0 = 0x1FF & (*((unsigned int*)DCO_TAP_8MHZ));  // Set DCO tap to 16 MHz TLV value speeds up even 8 MHz DCO
    __no_operation();
    __no_operation();
    __no_operation();
    __bic_SR_register(SCG0);  // Re-enable FLL

    // Loop until FLL is locked
    do
    {
        CSCTL7 &= ~DCOFFG;  // Clear DCO fault flag
        SFRIFG1 &= ~OFIFG;  // Clear oscillator fault interrupt flag
    }
    while(CSCTL7 & (FLLUNLOCK0 | FLLUNLOCK1));

    #else
    #warning Clock system not supported!
    #endif

    // RX buffer for both modes.
    BSL430_ReceiveBuffer = RAM_RX_Buf;
    PI_State = PI_STATE_UART;     // set state for debug
    assert((PI_State == PI_STATE_UART) || (PI_State == PI_STATE_I2C));

    transmitBufferLength_I2C = 0;           // init I2C variables here
    rxdataPointer_I2C = 0;
    transmitPoint_I2C = 0;

    I2C_PORT_SEL0 |= SDA + SCL;             // Assign I2C pins to USCI_B1
    I2C_PORT_SEL1 = 0;                      // Clear everything, including SDA/SCL for size
    I2C_UCZNCTL1 = UCSWRST;                 // Enable SW reset
    I2C_UCZNCTL0 = UCMODE_3 + UCSYNC;       // I2C Slave, synchronous mode
    I2C_UCZNCTL2 = 0x0;                     // Reset to default settings
    I2C_UCZNI2COA = 0x48 + UCOAEN;          // Own Address is 048h
    /* Extract address from TLV: I2C_UCZNI2COA = (*((unsigned char*)BSL_CONFIG_ADDR))| UCOAEN; */
    I2C_UCZNCTL1 &= ~UCSWRST;               // Clear SW reset, resume operation

    I2C_UCZNIE |= UCTXIE0 + UCRXIE0 + UCSTPIE + UCSTTIE;

    UART_UCZNCTLW0 = UCSWRST;               // **Put state machine in reset**
    UART_UCZNCTLW0 |= UCPEN+UCPAR+UCSSEL__SMCLK;  // even parity
    UART_UCZNCTLW1 = UCGLIT_3;              // Reset to default settings

    //8Mhz 9600
    //   UCOS16 = 1
    //   UCBRx =  52
    //   UCFx =   1
    //   UCSx =   0x49
    UART_UCZNBRW = 52;                      // 8MHz 9600 (see User's Guide)
    UART_UCZNMCTLW = (0x49u<<8)+(1<<4)+UCOS16;  // Modulation

    UART_PORT_SEL0 |= UART_RX;              // Only RX pin to stay passive
    UART_PORT_SEL1 = 0x00;
    UART_UCZNCTLW0 &= ~UCSWRST;             // **Initialize USCI state machine**

#endif
} // PI_init_passive

/*******************************************************************************
* *Function:    PI_init_active
* *Description: Initializes UART and I2C from passive to normal operation
* *Parameters:  The peripheral to be activated
* *Returns:     None
*******************************************************************************/
void PI_init_active(unsigned char PI_Mode)
{
    assert((PI_Mode == PI_STATE_UART) || (PI_Mode == PI_STATE_I2C));
    PI_State = PI_Mode;
    assert((PI_State == PI_STATE_UART) || (PI_State == PI_STATE_I2C));

    if(PI_State == PI_STATE_I2C)
    {
        BSL430_SendBuffer = &RAM_TX_Buf[4];

        // Disable UART
        UART_UCZNCTLW0 |= UCSWRST;          // Put state machine in reset
        UART_PORT_SEL0 &= ~UART_RX;
    }

    if(PI_State == PI_STATE_UART)
    {
        UART_PORT_SEL0 |= UART_TX+UART_RX;
        UART_PORT_SEL1 = 0x00;

        BSL430_SendBuffer = RAM_RX_Buf;

        // Disable I2C
        I2C_UCZNCTL1 |= UCSWRST;            // Enable SW reset
        I2C_PORT_SEL0 &= ~(SDA + SCL);
    }

} // PI_init_active

/******************************************************************************/
/*******************************************************************************
                                  GENERIC
                      GENERIC PI INTERFACE FUNCTIONS BELOW
*******************************************************************************/
/******************************************************************************/

/*******************************************************************************
*Function:    interpretPI_Command
*Description: processes a PI command
*******************************************************************************/
void interpretPI_Command()
{
    unsigned char command = BSL430_ReceiveBuffer[0];
    if( command == CHANGE_BAUD_RATE )
    {
        unsigned char rate = BSL430_ReceiveBuffer[1];
        if((rate < BAUD_9600 )||(rate > BAUD_115200))
        {
            sendByte_UART(UNKNOWN_BAUD_RATE);
        }
        else
        {
            sendByte_UART(ACK);
            while(UCA0STATW&UCBUSY);
            init_USCI_UART( rate );
        }
    }
}

/*******************************************************************************
* *Function:    PI_receivePacket
* *Description: simply directs to I2C or UART handlers based on device state
*  Returns:      None
*
*******************************************************************************/
char PI_receivePacket()
{
    char ret;
    if( PI_State == PI_STATE_I2C )
    {
        ret = PI_receivePacket_I2C();
    }
    else if ( PI_State == PI_STATE_UART )
    {
        ret = PI_receivePacket_UART();
    }

    return ret;
}

/*******************************************************************************
* *Function:    getBufferSize
* *Description: Returns the max Data Buffer Size for this PI
* *Returns:     max buffer size
*******************************************************************************/
int PI_getBufferSize()
{
  return MAX_BUFFER_SIZE;
}

/*******************************************************************************
* *Function:    PI_sendData
* *Description: Formats the Transmit Buffer to be used when the Transmit Flag gets set
* *Returns:     None
*******************************************************************************/
void PI_sendData(int size)
{
  if( PI_State == PI_STATE_I2C )
  {
    PI_sendData_I2C(size);
  }
  else if ( PI_State ==  PI_STATE_UART )
  {
    PI_sendData_UART(size);
  }
}

/*******************************************************************************
* *Function:    verifyData
* *Description: verifies the data in the data buffer against a checksum
* *Parameters:
*           int checksum    the checksum to check against
* *Returns:
*           1 checksum parameter is correct for data in the data buffer
*           0 checksum parameter is not correct for the data in the buffer
*******************************************************************************/
char verifyData(int checksum)
{
    int i;

    CRCINIRES = 0xFFFF;
    for (i = 0; i < BSL430_BufferSize; i++)
    {
        CRCDIRB_L = BSL430_ReceiveBuffer[i];
    }
    return (CRCINIRES == checksum);
}

/******************************************************************************/
/*******************************************************************************
                                    U A R T
                      UART PI INTERFACE FUNCTIONS BELOW
*******************************************************************************/
/******************************************************************************/

/*******************************************************************************
*Function:    PI_UARTreceivePacket
*Description: Reads an entire UART packet, verifies it, and sends it to the core to be interpreted
*******************************************************************************/
char PI_receivePacket_UART()
{
  RX_StatusFlags = RX_PACKET_ONGOING;
  unsigned char dataByte = 0;
  unsigned int dataPointer = 0;
  unsigned int checksum = 0;
  while( RX_StatusFlags == RX_PACKET_ONGOING )
  {
    dataByte = receiveByte_UART();            // get another byte from host
    if( dataPointer == 0 )                    // first byte is the size of the Core packet
    {
      if ( dataByte != 0x80 )                 // first byte in packet should be 0x80
      {
        sendByte_UART( HEADER_INCORRECT );
        RX_StatusFlags = RX_ERROR_RECOVERABLE;
      }
      else
      {
        dataPointer++;
      }
    }
    else if( dataPointer == 1 )               // first byte is the size of the Core packet
    {
      BSL430_BufferSize = dataByte;
      dataPointer++;
    }
    else if( dataPointer == 2 )
    {
      BSL430_BufferSize |= (int)dataByte<<8;
      if( BSL430_BufferSize == 0 )
      {
        sendByte_UART( PACKET_SIZE_ZERO );
        RX_StatusFlags = RX_ERROR_RECOVERABLE;
      }
      if( BSL430_BufferSize > MAX_BUFFER_SIZE ) // For future devices that might need smaller packets
      {
        sendByte_UART( PACKET_SIZE_TOO_BIG );
        RX_StatusFlags = RX_ERROR_RECOVERABLE;
      }
      dataPointer++;
    }
    else if( dataPointer == (BSL430_BufferSize + 3 ) )
    {
      // if the pointer is pointing to the Checksum low data byte which resides
      // after 0x80, rSize, Core Command.
      checksum = dataByte;
      dataPointer++;
    }
    else if( dataPointer == (BSL430_BufferSize+4) )
    {
      // if the pointer is pointing to the Checksum low data byte which resides
      // after 0x80, rSize, Core Command, CKL.
      checksum = checksum | dataByte<<8;
      if( verifyData(checksum) )
      {
#ifdef SUPPORTS_RX_TIMEOUT
        BSL430_Timeout = 0;                                    // clear timeout flag
#endif
        if( (BSL430_ReceiveBuffer[0] & 0xF0) == PI_COMMAND_UPPER)
        {
          interpretPI_Command();
          RX_StatusFlags = RX_PACKET_ONGOING;
          dataByte = 0;
          dataPointer = 0;
          checksum = 0;
        }
        else
        {
          sendByte_UART( ACK );
          RX_StatusFlags = DATA_RECEIVED;
        }
      }
      else
      {
        sendByte_UART( CHECKSUM_INCORRECT );
        RX_StatusFlags = RX_ERROR_RECOVERABLE;
      }
    }
    else
    {
      BSL430_ReceiveBuffer[dataPointer-3] = dataByte;
      dataPointer++;
    }

  }
  return RX_StatusFlags;
}

/*******************************************************************************
*Function:    sendByte_UART
*Description: Sends a byte
*******************************************************************************/
void sendByte_UART(char data)
{
    while (!(UCZNIFG&UCTXIFG));             // USCI_A0 TX buffer ready?
    UCZNTXBUF = data;
}

/*******************************************************************************
*Function:    receiveByte_UART
*Description: receives a byte
*******************************************************************************/
char receiveByte_UART()
{
#ifdef SUPPORTS_RX_TIMEOUT
    while(!(UCZNIFG & UCRXIFG)) {           // wait for RX flag
        if (BSL430_Timeout) {               // run SW timeout
            BSL430_Timeout_count++;
            // check if 10 seconds have past without a valid command
            if ((unsigned int)(BSL430_Timeout_count >> 16) > 0x0032) {
                ((void (*)(void))0x0)();    // branch to 0
            }
        }
    }
#else
    while( !(UCZNIFG & UCRXIFG));       // wait for RX flag
#endif

    UCZNIFG &= ~UCRXIFG;
    return UCZNRXBUF;
}

/*******************************************************************************
*Function:    PI_sendData_UART
*Description: Sends the data in the data buffer
*******************************************************************************/
void PI_sendData_UART(unsigned int size)
{
    int i;
    sendByte_UART(0x80);
    sendByte_UART(size & 0xFF);
    sendByte_UART(size>>8 & 0xFF);
    CRCINIRES = 0xFFFF;
    for(i = 0; i < size; i++)
    {
        CRCDIRB_L = BSL430_SendBuffer[i];
        sendByte_UART(BSL430_SendBuffer[i]);
    }
    sendByte_UART(CRCINIRES_L);
    sendByte_UART(CRCINIRES_H);
}

/*******************************************************************************
*Function:    init_USCI_UART
*Description: internal code size saving function used by init and change baud rate
*******************************************************************************/
void init_USCI_UART( char baud_rate )
{
  UART_UCZNCTLW0 |= UCSWRST;                      // **Put state machine in reset**
  UART_UCZNCTLW0 |= UCPEN+UCPAR+UCSSEL__SMCLK;    // even parity

  switch ( baud_rate )
  {
    case BAUD_9600:
      //8Mhz 9600
      //   UCOS16 = 1
      //   UCBRx =  52
      //   UCFx =   1
      //   UCSx =   0x49
      UART_UCZNBRW = 52;                            // 8MHz 9600 (see User's Guide)
      UART_UCZNMCTLW = (0x49u<<8)+(1<<4)+UCOS16;     // Modulation
    break;
    case BAUD_19200:
      //8Mhz 19200
      //   UCOS16 = 1
      //   UCBRx =  26
      //   UCFx =   0
      //   UCSx =   0xB6
      UART_UCZNBRW = 26;                            // 8MHz 19200 (see User's Guide)
      UART_UCZNMCTLW = (0xB6u<<8)+(0<<4)+UCOS16;                       // Modulation
    break;
    case BAUD_38400:
      //8Mhz 38400
      //   UCOS16 = 1
      //   UCBRx =  13
      //   UCFx =   0
      //   UCSx =   0x84
      UART_UCZNBRW = 13;                            // 8MHz 38400 (see User's Guide)
      UART_UCZNMCTLW = (0x84u<<8)+(0<<4)+UCOS16;                       // Modulation
    break;
    case BAUD_57600:
      //8Mhz 57600
      //   UCOS16 = 1
      //   UCBRx =  8
      //   UCFx =   10
      //   UCSx =   0xF7
      UART_UCZNBRW = 8;                            // 8MHz 57600 (see User's Guide)
      UART_UCZNMCTLW = (0xF7u<<8)+(10<<4)+UCOS16;                       // Modulation
    break;
    case BAUD_115200:
      //8Mhz 115200
      //   UCOS16 = 1
      //   UCBRx =  4
      //   UCFx =   5
      //   UCSx =   0x55
      UART_UCZNBRW = 4;                             // 8MHz 9600 (see User's Guide)
      UART_UCZNMCTLW = (0x55u<<8)+(5<<4)+UCOS16;     // Modulation
    break;
     /*
    case BAUD_9600:
      //8Mhz 9600
      //   UCOS16 = 1
      //   UCBRx =  52
      //   UCFx =   1
      //   UCSx =   0x49
      UART_UCZNBRW = 52;
      UART_UCZNMCTLW_H = 0x49;
      UART_UCZNMCTLW_L = (1<<4)+ UCOS16;
    break;
    case BAUD_19200:
      //8Mhz 19200
      //   UCOS16 = 1
      //   UCBRx =  26
      //   UCFx =   0
      //   UCSx =   0xB6
      UART_UCZNBRW = 26;
      UART_UCZNMCTLW_H = 0xB6;
      UART_UCZNMCTLW_L = (0<<4)+ UCOS16;
    break;
    case BAUD_38400:
      //8Mhz 38400
      //   UCOS16 = 1
      //   UCBRx =  13
      //   UCFx =   0
      //   UCSx =   0x84
      UART_UCZNBRW = 13;
      UART_UCZNMCTLW_H = 0x84;
      UART_UCZNMCTLW_L = (0<<4)+ UCOS16;
    break;
    case BAUD_57600:
      //8Mhz 57600
      //   UCOS16 = 1
      //   UCBRx =  8
      //   UCFx =   10
      //   UCSx =   0xF7
      UART_UCZNBRW = 8;
      UART_UCZNMCTLW_H = 0xF7;
      UART_UCZNMCTLW_L = (10<<4)+ UCOS16;
    break;

    case BAUD_115200:
      //8Mhz 115200
      //   UCOS16 = 1
      //   UCBRx =  4
      //   UCFx =   5
      //   UCSx =   0x55
      UART_UCZNBRW = 4;
      UART_UCZNMCTLW_H = 0x55;
      UART_UCZNMCTLW_L = (5<<4)+ UCOS16;
    break;
      */
  }
  UART_PORT_SEL0 |= UART_TX+UART_RX;
  UART_PORT_SEL1 = 0x00;
  UART_UCZNCTLW0 &= ~UCSWRST;                        // **Initialize USCI state machine**
}

/******************************************************************************/
/*******************************************************************************
                                      I 2 C
                      I2C PI INTERFACE FUNCTIONS BELOW
*******************************************************************************/
/******************************************************************************/
/*******************************************************************************
* *Function:    PI_I2CreceivePacket
* *Description: Handles the sequence of START, DATA, RESTART and then SENDS DATA
*               and then STOP
*
*  Returns:     None
*******************************************************************************/
#define I2C_START_CONDITION_RECEIVED 0x06
#define I2C_STOP_CONDITION_RECEIVED  0x08
#define I2C_DATA_RECEIVED            0x16
#define I2C_TRANSMIT_BUFFER_EMPTY    0x18
char PI_receivePacket_I2C()
{
    unsigned char          RxValue;

    RX_StatusFlags = RX_PACKET_ONGOING;

    while (RX_StatusFlags == RX_PACKET_ONGOING)
    {
        switch (I2C_UCZIV)
        //switch (__even_in_range(I2C_UCZIV,I2C_TRANSMIT_BUFFER_EMPTY) )
        {
            case I2C_START_CONDITION_RECEIVED:
                transmitPoint_I2C = 0;               //Start Condition Received
                rxdataPointer_I2C = 0;
                break;

            case I2C_STOP_CONDITION_RECEIVED:    //Stop Condition Received
                break;

            case I2C_DATA_RECEIVED:
                RxValue = I2C_UCZRXBUF;              //Data Received
                receiveDataFromMaster_I2C(RxValue);
                break;

            case I2C_TRANSMIT_BUFFER_EMPTY:
                if (transmitPoint_I2C < transmitBufferLength_I2C)
                {
                    I2C_UCZTXBUF = RAM_TX_Buf[transmitPoint_I2C++];
                }
                break;

            default:          break;

        } // swtich

#ifdef SUPPORTS_RX_TIMEOUT
        if (BSL430_Timeout) {                                   // run SW timeout
            BSL430_Timeout_count++;
            // check if ~10 seconds have past without a valid command
            if ((unsigned int)(BSL430_Timeout_count >> 16) > 0x001F) {
                ((void (*)(void))0x0)();                          // branch to 0
            }
        }
#endif
    } // while

    return RX_StatusFlags;
}

/*******************************************************************************
* *Function:    receiveDataFromMaster_I2C  - I2C routine
* *Description: Retrieves the format info, data etc from the received data and
*             sets error flags if format is wrong - wrong checksum, wrong header etc
*             and stripes the data bytes from the format characters and headers
*
*             eg: 0x80 0x01 0x00 0x19 0xE8 0x62 gets converted to
*                 Header - 0x80
*                 Length - 0x01
*                 Command - 0x19
*                 Checksum - CKL-0xE8
*                            CKH-0x62
* *Returns: None
*
*******************************************************************************/
void receiveDataFromMaster_I2C(unsigned char dataByte)
{
    volatile unsigned int checksum;
    if (rxdataPointer_I2C == 0)                      // first byte is the size of the Core packet
    {
        if (dataByte != 0x80)                    // first byte in packet should be 0x80
        {
            sendByte_I2C(HEADER_INCORRECT);
            RX_StatusFlags = RX_ERROR_RECOVERABLE;
        }
        else
        {
            rxdataPointer_I2C++;
        }
    }
    else if (rxdataPointer_I2C == 1)                 // first byte is the size of the Core packet
    {
        BSL430_BufferSize = dataByte;
        rxdataPointer_I2C++;
    }
    else if (rxdataPointer_I2C == 2)
    {
        BSL430_BufferSize |= (int)dataByte << 8;
        if (BSL430_BufferSize == 0)
        {
            sendByte_I2C(PACKET_SIZE_ZERO);
            RX_StatusFlags = RX_ERROR_RECOVERABLE;
        }
        if (BSL430_BufferSize > MAX_BUFFER_SIZE) // For future devices that might need smaller
                                                 // packets
        {
            sendByte_I2C(PACKET_SIZE_TOO_BIG);
            RX_StatusFlags = RX_ERROR_RECOVERABLE;
        }
        rxdataPointer_I2C++;
    }
    else if (rxdataPointer_I2C == (BSL430_BufferSize + 3))
    {
        // if the pointer is pointing to the Checksum low data byte which resides
        // after 0x80, rSize, Core Command.
        checksum = dataByte;
        rxdataPointer_I2C++;
    }
    else if (rxdataPointer_I2C == (BSL430_BufferSize + 4))
    {
        // if the pointer is pointing to the Checksum low data byte which resides
        // after 0x80, rSize, Core Command, CKL.
        checksum = checksum | dataByte << 8;
        if (verifyData(checksum))
        {
            sendByte_I2C(ACK);
            RX_StatusFlags = DATA_RECEIVED;
#ifdef SUPPORTS_RX_TIMEOUT
            BSL430_Timeout = 0;                                    // clear timeout flag
#endif
        }
        else
        {
            sendByte_I2C(CHECKSUM_INCORRECT);
            RX_StatusFlags = RX_ERROR_RECOVERABLE;
        }
    }
    else
    {
        RAM_RX_Buf[rxdataPointer_I2C - 3] = dataByte;
        rxdataPointer_I2C++;
    }

}

/*******************************************************************************
* *Function:    PI_I2CsendData
* *Description: Formats the Transmit Buffer to be used when the Transmit Flag gets set
* *Returns:     None
*******************************************************************************/
void PI_sendData_I2C(unsigned int size)
{
    int i;
    int rxStart;        // flag to check for start condition before transmiting
    int txPoint;        // Use local variables to reduce code size, change to
    int txLen;          // transmitPoint_I2C and transmitBufferLength_I2C if
                        // there is space

    /*
     * Use transmitBufferLength_I2C when sending data to allow for either an
     * acknowledgement for the first packet or a follow up packet (as used when
     * requesting more than 259 bytes).
     */
    txLen = transmitBufferLength_I2C;

    RAM_TX_Buf[txLen++] = 0x80;
    RAM_TX_Buf[txLen++] = size & 0xFF;
    RAM_TX_Buf[txLen++] = size >> 8 & 0xFF;
    CRCINIRES = 0xFFFF;
    for (i = 0; i < size; i++){
        /*
         * If transmitting multiple packets such as transmit data we must
         * shift buffer down.
         */
        CRCDIRB_L = BSL430_SendBuffer[i];
        RAM_TX_Buf[txLen++] = BSL430_SendBuffer[i];
    }
    RAM_TX_Buf[txLen++] = CRCINIRES_L;
    RAM_TX_Buf[txLen++] = CRCINIRES_H;

    /* Set start cond. flag to zero and TX pointer to start of buffer */
    rxStart = 0;
    txPoint = 0;

    while (txPoint < txLen) {
        switch (I2C_UCZIV) {
            case I2C_START_CONDITION_RECEIVED:
                rxStart = 1;
                break;

            case I2C_STOP_CONDITION_RECEIVED:
                break;

            case I2C_DATA_RECEIVED:
                break;

            case I2C_TRANSMIT_BUFFER_EMPTY:
                if (rxStart) {
                    I2C_UCZTXBUF = RAM_TX_Buf[txPoint++];
                }
                break;

            default:
                break;
        }
    }

    transmitBufferLength_I2C = 0;
}


/*******************************************************************************
* *Function:    sendByte
* *Description: Puts a single byte in the outgoing buffer, such as an error
*
* *Parameters:
*           char data    the byte to send
*******************************************************************************/
void sendByte_I2C(char data)
{
    RAM_TX_Buf[0] = data; // Status Byte ACK/NACK
    transmitBufferLength_I2C = 1;
}
