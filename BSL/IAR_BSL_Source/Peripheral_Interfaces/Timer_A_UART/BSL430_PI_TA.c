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

// 4800 (unused)
#define BAUD_4800 0x01
#define BitTime_4800   (DCO_SPEED/4800)
#define BitTime_5_4800 (BitTime_4800/2)

// 9600
#define BAUD_9600 0x02
#define BitTime_9600   (DCO_SPEED/9600)
#define BitTime_5_9600 (BitTime_9600/2)

// 19200
#define BAUD_19200 0x03
#define BitTime_19200   (DCO_SPEED/19200)
#define BitTime_5_19200 (BitTime_19200/2)

// 38400
#define BAUD_38400 0x04
#define BitTime_38400   (DCO_SPEED/38400)
#define BitTime_5_38400 (BitTime_38400/2)
// 57600
#define BAUD_57600 0x05
#define BitTime_57600   (DCO_SPEED/57600)
#define BitTime_5_57600 (BitTime_57600/2)
// 115200
#define BAUD_115200 0x06
#define BitTime_115200   (DCO_SPEED/115200)
#define BitTime_5_115200 (BitTime_115200/2)

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

#define MAX_BUFFER_SIZE 260

char verifyData( int checksum );
char receiveByte();
void sendByte( char data );
void interpretPI_Command();

__no_init unsigned int BitTime;
__no_init unsigned int BitTime_5;

__no_init char *BSL430_ReceiveBuffer;
__no_init char *BSL430_SendBuffer;
__no_init unsigned int BSL430_BufferSize;
#pragma data_alignment=2
__no_init char RAM_Buf[MAX_BUFFER_SIZE];

#define TIMER_A_VERSION 0x04
const unsigned char BSL430_PI_Version @ "BSL430_VERSION_PI" = (BSL430_TIMER_A_PI+TIMER_A_VERSION);
#pragma required=BSL430_PI_Version
/*******************************************************************************
*Function:    PI_init
*Description: Initialize the timer and ports to begin TX/RX
*Parameters: 
*******************************************************************************/
void PI_init()
{
  BSL430_ReceiveBuffer = RAM_Buf;
  BSL430_SendBuffer = RAM_Buf;
  
  BitTime = BitTime_9600;
  BitTime_5 = BitTime_5_9600;

  UCSCTL4 = SELA__REFOCLK + SELM__DCOCLK + SELS__DCOCLK;  // to do check SELA
  
  UCSCTL0 = 0x000;                          // Set DCO to lowest Tap
  
  UCSCTL1 = DCORSEL_4;                      // 8MHz nominal DCO
  UCSCTL5 = DIVM_0 + DIVS_0;
  UCSCTL2 = FLLD_2 | (((DCO_SPEED/ACLK_SPEED)/4) - 1); // 8MHz
  
  
  TZNCCTL_TX = OUTMOD0;//OUT;                           // TXD Idle as Mark
  TZNCTL = TZ_CLK_SEL + MC_2;                 // SMCLK, continuous mode
  
  if (&TX_PORT_SEL != &RX_PORT_SEL)
  {
    TX_PORT_SEL = 0;
    RX_PORT_SEL = 0;
    TX_PORT_DIR = 0;
    RX_PORT_DIR = 0;
  
    TX_PORT_SEL |= TXD;
    RX_PORT_SEL |= RXD;
    TX_PORT_DIR = TXD;
  }
  else
  {
    TX_PORT_SEL = TXD + RXD;                        // Configure I/Os for UART
    TX_PORT_DIR = TXD;                              // Configure I/Os for UART
  }
}//init

/*******************************************************************************
*Function:    PI_receivePacket
*Description: Reads an entire packet, verifies it, and sends it to the core to be interpreted
*Returns:
*             DATA_RECEIVED         A packet has been received and can be processed
*             RX_ERROR_RECOVERABLE  An error has occured, the function can be called again to 
*                                   receive a new packet
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
*Function:    interpretPI_Command
*Description: processes a PI command
*******************************************************************************/
void interpretPI_Command()
{
  char command = RAM_Buf[0];
  if( command == CHANGE_BAUD_RATE )
  {
     char rate = RAM_Buf[1];
     switch ( rate )
     {
       /*
     case BAUD_4800:
       sendByte(ACK);
       BitTime = BitTime_4800;
       BitTime_5 = BitTime_5_4800;
       break;
       */
     case BAUD_9600:
       sendByte(ACK);
       BitTime = BitTime_9600;
       BitTime_5 = BitTime_5_9600;
       break;
     case BAUD_19200:
       sendByte(ACK);
       BitTime = BitTime_19200;
       BitTime_5 = BitTime_5_19200;
       break;
     case BAUD_38400:
       sendByte(ACK);
       BitTime = BitTime_38400;
       BitTime_5 = BitTime_5_38400;
       break;
     
     case BAUD_57600:
       sendByte(ACK);
       BitTime = BitTime_57600;
       BitTime_5 = BitTime_5_57600;
       break;       
     case BAUD_115200:
       sendByte(ACK);
       BitTime = BitTime_115200;
       BitTime_5 = BitTime_5_115200;
       break;
     default:
       sendByte(UNKNOWN_BAUD_RATE);
     }
  }
}

/*******************************************************************************
*Function:    receiveByte
*Description: polls the timer to receive one byte
*Returns:
*           The character received
*******************************************************************************/
char receiveByte()
{
  int bitCount = 9;                         // Load Bit counter
  int dataByte = 0;
  TZNCCTL_RX = SCS + OUTMOD0 + CM1 + CAP;     // Sync, Neg Edge, Cap      
  while( !(TZNCCTL_RX & CCIFG) );             // wait for first char
  TZNCCTL_RX &= ~ (CAP+CCIFG);                // Switch from capture to compare mode, turn off interrupt
  TZNCCR_RX += BitTime_5;
  while( bitCount > 0 )
  {
    TZNCCR_RX += BitTime; 
    TZNCCTL_RX &= ~CCIFG;
    while( !(TZNCCTL_RX & CCIFG) );           // time out one char
    dataByte = dataByte >> 1;
    if (TZNCCTL_RX & SCCI)                    // Get bit waiting in receive latch
    {
      dataByte |= 0x100;
    }
    bitCount --;  
  }
  return (dataByte&0xFF);
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
*Function:    sendByte
*Description: Sends one byte using the timer
*Parameters: 
*           char data    the byte to send
*******************************************************************************/
void sendByte(char data)
{
  int tempData; 
  int parity_mask = 0x200;
  char bitCount = 0xB;                      // Load Bit counter, 8data + ST/SP +parity
  TZNCCR_TX = TZNR;                           // Current state of TA counter 
  TZNCCR_TX += BitTime;
  tempData = 0x200 + (int)data;             // Add mark stop bit to Data
  tempData = tempData << 1;
  //TZNCCTL_TX = OUTMOD0;
  
  while( bitCount != 0 )
  {
    while( !(TZNCCTL_TX & CCIFG) );
    TZNCCTL_TX &= ~CCIFG;
    TZNCCR_TX += BitTime;
    TZNCCTL_TX |=  OUTMOD2;                   // TX '0'
    if (tempData & 0x01)
    {
      tempData ^= parity_mask; 
      TZNCCTL_TX &= ~ OUTMOD2;                // TX '1'
    }
    parity_mask = parity_mask >> 1;
    tempData = tempData >> 1;
    bitCount --;
  }
  while( !(TZNCCTL_TX & CCIFG) );             // wait for timer
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
*Function:    sendData
*Description: Sends the data in the data buffer
*Parameters: 
*           int size    the number of bytes in the buffer
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
