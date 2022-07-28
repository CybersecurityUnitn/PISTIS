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
#include "BSL_Device_File.h"
#include "BSL430_PI.h"
#include "BSL430_Command_Interpreter.h"
#include "BSL430_Command_Definitions.h"
/*******************************************************************************
Change Log:
--------------------------------------------------------------------------------
Version 0x52 
3.15.10  LCW   changed to DCORSEL_4
--------------------------------------------------------------------------------
Version 0x53 
5.18.10  LCW   made buffer size unsized to align with Interface
--------------------------------------------------------------------------------
*******************************************************************************/
//errors
#define HEADER_INCORRECT (PI_COMMAND_UPPER+0x01)
#define CHECKSUM_INCORRECT (PI_COMMAND_UPPER+0x02) 
#define PACKET_SIZE_ZERO (PI_COMMAND_UPPER+0x03)
#define PACKET_SIZE_TOO_BIG (PI_COMMAND_UPPER+0x04)
#define UNKNOWN_ERROR (PI_COMMAND_UPPER+0x05)
// errors for PI commands
#define UNKNOWN_BAUD_RATE (PI_COMMAND_UPPER+0x06)

// TA PI Commands
#define CHANGE_BAUD_RATE (PI_COMMAND_UPPER + 0x02)

// 4800 (unused)
#define BAUD_4800   0x01
#define BAUD_9600   0x02
#define BAUD_19200  0x03
#define BAUD_38400  0x04
#define BAUD_57600  0x05
#define BAUD_115200 0x06

#define MAX_BUFFER_SIZE 260

char verifyData( int checksum );
char receiveByte();
void sendByte( char data );
void interpretPI_Command();
void init_USCI( char baud_rate );

__no_init char *BSL430_ReceiveBuffer;
__no_init char *BSL430_SendBuffer;
__no_init unsigned int BSL430_BufferSize;
#pragma data_alignment=2
__no_init char RAM_Buf[MAX_BUFFER_SIZE];

#define USCIA_VERSION 0x03
const unsigned char BSL430_PI_Version @ "BSL430_VERSION_PI" = (BSL430_USCIA_PI+USCIA_VERSION);
#pragma required=BSL430_PI_Version

/*******************************************************************************
*Function:    init
*Description: Initialize the USCI and Ports
*Parameters: 
*******************************************************************************/
void PI_init()
{
  volatile int i;
  BSL430_ReceiveBuffer = RAM_Buf;
  BSL430_SendBuffer = RAM_Buf;

  UCSCTL4 = SELA__REFOCLK + SELM__DCOCLK + SELS__DCOCLK;  // to do check SELA
  
  UCSCTL0 = 0x000;                          // Set DCO to lowest Tap
  
  UCSCTL1 = DCORSEL_4;                      // 8MHz nominal DCO
  UCSCTL5 = DIVM_0 + DIVS_0;
  UCSCTL2 = FLLD_2 | (((DCO_SPEED/ACLK_SPEED)/4) - 1); // 8MHz

  init_USCI( BAUD_9600 );
  
}//init


/*******************************************************************************
*Function:    receivePacket
*Description: Reads an entire packet, verifies it, and sends it to the core to be interpreted
*******************************************************************************/
char PI_receivePacket()
{
  char RX_StatusFlags = RX_PACKET_ONGOING;
  char dataByte = 0;
  int dataPointer = 0;
  volatile int checksum = 0;
  while( RX_StatusFlags == RX_PACKET_ONGOING )
  {
    dataByte = receiveByte();               // get another byte from host
    if( dataPointer == 0 )                  // first byte is the size of the Core packet
    {
      if ( dataByte != 0x80 )               // first byte in packet should be 0x80
      {
        sendByte( HEADER_INCORRECT );
        RX_StatusFlags = RX_ERROR_RECOVERABLE;
      }
      else
      {
        dataPointer++;
      }
    }
    else if( dataPointer == 1 )             // first byte is the size of the Core packet
    {
      BSL430_BufferSize = dataByte;
      dataPointer++;
    }
    else if( dataPointer == 2 )
    {
      BSL430_BufferSize |= (int)dataByte<<8;
      if( BSL430_BufferSize == 0 )
      {
        sendByte( PACKET_SIZE_ZERO );
        RX_StatusFlags = RX_ERROR_RECOVERABLE;
      }
      if( BSL430_BufferSize > MAX_BUFFER_SIZE )        // For future devices that might need smaller packets
      {
        sendByte( PACKET_SIZE_TOO_BIG );
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
        if( (RAM_Buf[0] & 0xF0) == PI_COMMAND_UPPER)
        {
          interpretPI_Command();
          RX_StatusFlags = RX_PACKET_ONGOING;
          dataByte = 0;
          dataPointer = 0;
          checksum = 0;
        }
        else
        {
          sendByte( ACK );
          RX_StatusFlags = DATA_RECEIVED;
        }
      }
      else
      {
        sendByte( CHECKSUM_INCORRECT );
        RX_StatusFlags = RX_ERROR_RECOVERABLE;
      }
    }
    else
    {
      RAM_Buf[dataPointer-3] = dataByte;
      dataPointer++;
    }
    
  }
  return RX_StatusFlags;
}
/*******************************************************************************
*Function:    sendData
*Description: Sends the data in the data buffer
*******************************************************************************/
void PI_sendData(int size)
{
  int i;
  sendByte( 0x80 );
  sendByte( size & 0xFF );
  sendByte( size>>8 & 0xFF );
  CRCINIRES = 0xFFFF;
  for( i = 0; i < size; i++){
    CRCDIRB_L = RAM_Buf[i];
    sendByte( RAM_Buf[i] );
  }
  i = CRCINIRES;
  sendByte( i & 0xFF );
  sendByte( i>>8 & 0xFF );
}

/*******************************************************************************
*Function:    sendByte
*Description: Sends a byte
*******************************************************************************/
void sendByte(char data)
{
  while (!(UCA0IFG&UCTXIFG));             // USCI_A0 TX buffer ready?
  UCA0TXBUF = data;
}
/*******************************************************************************
*Function:    receiveByte
*Description: receives a byte
*******************************************************************************/
char receiveByte()
{
  while( !(UCA0IFG & UCRXIFG));       // wait for RX flag
  return UCA0RXBUF;
}
/*******************************************************************************
*Function:    verifyData
*Description: verifies the data in the data buffer against a checksum
*Parameters: 
*           int checksum    the checksum to check against
*Returns:
*           1 checksum parameter is correct for data in the data buffer
*           0 checksum parameter is not correct for the data in the buffer
*******************************************************************************/
char verifyData( int checksum )
{
  int i;
  CRCINIRES = 0xFFFF;
  for( i = 0; i < BSL430_BufferSize; i++)
  {
    CRCDIRB_L = RAM_Buf[i];
  }
  return (CRCINIRES == checksum );
}

/*******************************************************************************
*Function:    getBufferSize
*Description: Returns the max Data Buffer Size for this PI
*Returns:     max buffer size
*******************************************************************************/
int PI_getBufferSize()
{
  return MAX_BUFFER_SIZE;
}


/*******************************************************************************
*Function:    interpretPI_Command
*Description: processes a PI command
*******************************************************************************/
void interpretPI_Command()
{
  char command = RAM_Buf[0];
  if( command == CHANGE_BAUD_RATE )
  {
    volatile int i;
    char rate = RAM_Buf[1];
    if( (rate < BAUD_9600 )||(rate > BAUD_115200) )
    {
        sendByte(UNKNOWN_BAUD_RATE);
    }
    else
    {
      sendByte(ACK);
      while(UCA0STAT&UCBUSY);
      init_USCI( rate );
    }
  }
}

/*******************************************************************************
*Function:    init_USCI
*Description: internal code size saving function used by init and change baud rate
*******************************************************************************/
void init_USCI( char baud_rate )
{
  UCA0CTL1 |= UCSWRST;                      // **Put state machine in reset**
  UCA0CTL0 |= UCPEN+UCPAR;                  // even parity
  UCA0CTL1 |= UCSSEL__SMCLK;                // SMCLK
  switch ( baud_rate )
  {
    case BAUD_9600:
      UCA0BRW = 833 ;                           // 8MHz 9600 (see User's Guide)
      UCA0MCTL = UCBRS_2 + UCBRF_0;             // Modulation   
    break;
    case BAUD_19200:
      UCA0BRW = 416;                            // 8MHz 19200 (see User's Guide)
      UCA0MCTL = UCBRS_6 + UCBRF_0;             // Modulation   
    break;
    case BAUD_38400:
      UCA0BRW = 208;                            // 8MHz 38400 (see User's Guide)
      UCA0MCTL = UCBRS_3 + UCBRF_0;             // Modulation   
    break;
    case BAUD_57600:
      UCA0BRW = 138;                            // 8MHz 57600 (see User's Guide)
      UCA0MCTL = UCBRS_7 + UCBRF_0;             // Modulation   
    break;
    case BAUD_115200:
      UCA0BRW = 69;                            // 8MHz 115200 (see User's Guide)
      UCA0MCTL = UCBRS_4 + UCBRF_0;            // Modulation   
    break; 
  }
  USCI_PORT_SEL = RXD + TXD;                // P1.5.6 = USCI_A0 TXD/RXD
  UCA0CTL1 &= ~UCSWRST;                     // **Initialize USCI state machine**
}
