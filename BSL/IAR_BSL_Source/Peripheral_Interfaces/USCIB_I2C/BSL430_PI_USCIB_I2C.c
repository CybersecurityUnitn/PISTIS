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
extern void interpretCommand();

#include "BSL_Device_File.h"
#include "BSL430_PI.h"
#include "BSL430_Command_Interpreter.h"
#include "BSL430_Command_Definitions.h"

//errors
#define HEADER_INCORRECT (PI_COMMAND_UPPER + 0x01)
#define CHECKSUM_INCORRECT (PI_COMMAND_UPPER + 0x02)
#define PACKET_SIZE_ZERO (PI_COMMAND_UPPER + 0x03)
#define PACKET_SIZE_TOO_BIG (PI_COMMAND_UPPER + 0x04)
#define UNKNOWN_ERROR (PI_COMMAND_UPPER + 0x05)

#define MAX_BUFFER_SIZE 260

#define SLAVE_ADDRESS 0x48

char verifyData(int checksum);

//I2C Interface specific functions
void receiveDataFromMaster(unsigned char);
void sendByte(char data);

char byStatusByte;
char RX_StatusFlags = RX_PACKET_ONGOING;
volatile int checksum = 0;

__no_init char *BSL430_ReceiveBuffer;
__no_init char *BSL430_SendBuffer;
__no_init unsigned int BSL430_BufferSize;
#pragma data_alignment=2
__no_init char RAM_TX_Buf[MAX_BUFFER_SIZE+6];   //+6 to accomidate send buffer of max size plus packet bytes (ack, 0x80, size, size, [packet], CRC, CRC) BUG0000076758
__no_init char RAM_RX_Buf[MAX_BUFFER_SIZE];

#define USCIB_I2C_VERSION 0x04
const unsigned char BSL430_PI_Version @ "BSL430_VERSION_PI" =
    (BSL430_USCIB_I2C_PI + USCIB_I2C_VERSION);
#pragma required=BSL430_PI_Version

unsigned char RxValue;
unsigned int rxdataPointer = 0;
unsigned int transmitBufferLength = 0;
unsigned int transmitPoint = 0;


/*******************************************************************************
* *Function:    PI_init  - I2C
* *Description: Initializes the I2C Slave
*  Returns:      None
*******************************************************************************/

void PI_init()
{
    BSL430_ReceiveBuffer = RAM_RX_Buf;
    BSL430_SendBuffer = &RAM_TX_Buf[4];
    rxdataPointer = 0;


    UCSCTL4 = SELA__REFOCLK + SELM__DCOCLK + SELS__DCOCLK;   // to do check SELA

    UCSCTL0 = 0x000;                                         // Set DCO to lowest Tap

    UCSCTL1 = DCORSEL_4;                                     // 8MHz nominal DCO
    UCSCTL5 = DIVM_0 + DIVS_0;
    UCSCTL2 = FLLD_2 | (((DCO_SPEED / ACLK_SPEED) / 4) - 1); // 8MHz


    TX_PORT_SEL |= RXD + TXD;                                // Assign I2C pins to USCI_B1
    UCZNCTL1 |= UCSWRST;                                     // Enable SW reset
    UCZNCTL0 = UCMODE_3 + UCSYNC;                            // I2C Slave, synchronous mode
    UCZNI2COA = SLAVE_ADDRESS;                               // Own Address is 048h
    UCZNCTL1 &= ~UCSWRST;                                    // Clear SW reset, resume operation

    UCZNIE |= UCTXIE + UCRXIE + UCSTPIE + UCSTTIE;

} //init

/*******************************************************************************
* *Function:    PI_receivePacket
* *Description: Handles the sequence of START, DATA, RESTART and then SENDS DATA
*             and then STOP
*  Returns:      None
*
*******************************************************************************/
#define I2C_START_CONDITION_RECEIVED 0x06
#define I2C_STOP_CONDITION_RECEIVED  0x08
#define I2C_DATA_RECEIVED            0x0A
#define I2C_TRANSMIT_BUFFER_EMPTY    0x0C
char PI_receivePacket()
{
    RX_StatusFlags = RX_PACKET_ONGOING;

    while (RX_StatusFlags == RX_PACKET_ONGOING)
    {
        switch (UCZIV)
        {
            case I2C_START_CONDITION_RECEIVED:
                transmitPoint = 0;               //Start Condition Received
                rxdataPointer = 0;
                break;

            case I2C_STOP_CONDITION_RECEIVED:    //Stop Condition Received
                break;

            case I2C_DATA_RECEIVED:
                RxValue = UCZRXBUF;              //Data Received
                receiveDataFromMaster(RxValue);
                break;

            case I2C_TRANSMIT_BUFFER_EMPTY:
                if (transmitPoint < transmitBufferLength)
                {
                    UCZTXBUF = RAM_TX_Buf[transmitPoint++];
                }
                else
                {
                  transmitBufferLength = 0;        // prevents buffer re-send (V4 addition)
                  UCZTXBUF = UNKNOWN_ERROR;
                }
                break;

            default:          break;

        } // swtich
    } // while
    return RX_StatusFlags;
}

/*******************************************************************************
* *Function:    receiveDataFromMaster  - I2C routine
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

void receiveDataFromMaster(unsigned char dataByte)
{
    sendByte(UNKNOWN_ERROR);                     // V4 addition, put unknown error in the  
                                                 // buffer as safe-guard, will be overwritten
                                                 // by ACK or real error later
    if (rxdataPointer == 0)                      // first byte is the size of the Core packet
    {
        if (dataByte != 0x80)                    // first byte in packet should be 0x80
        {
            sendByte(HEADER_INCORRECT);
            RX_StatusFlags = RX_ERROR_RECOVERABLE;
        }
        else
        {
            rxdataPointer++;
        }
    }
    else if (rxdataPointer == 1)                 // first byte is the size of the Core packet
    {
        BSL430_BufferSize = dataByte;
        rxdataPointer++;
    }
    else if (rxdataPointer == 2)
    {
        BSL430_BufferSize |= (int)dataByte << 8;
        if (BSL430_BufferSize == 0)
        {
            sendByte(PACKET_SIZE_ZERO);
            RX_StatusFlags = RX_ERROR_RECOVERABLE;
        }
        if (BSL430_BufferSize > MAX_BUFFER_SIZE) // For future devices that might need smaller
                                                 // packets
        {
            sendByte(PACKET_SIZE_TOO_BIG);
            RX_StatusFlags = RX_ERROR_RECOVERABLE;
        }
        rxdataPointer++;
    }
    else if (rxdataPointer == (BSL430_BufferSize + 3))
    {
        // if the pointer is pointing to the Checksum low data byte which resides
        // after 0x80, rSize, Core Command.
        checksum = dataByte;
        rxdataPointer++;
    }
    else if (rxdataPointer == (BSL430_BufferSize + 4))
    {
        // if the pointer is pointing to the Checksum low data byte which resides
        // after 0x80, rSize, Core Command, CKL.
        checksum = checksum | dataByte << 8;
        if (verifyData(checksum))
        {
            sendByte(ACK);
            RX_StatusFlags = DATA_RECEIVED;
        }
        else
        {
            sendByte(CHECKSUM_INCORRECT);
            RX_StatusFlags = RX_ERROR_RECOVERABLE;
        }
    }
    else
    {
        RAM_RX_Buf[rxdataPointer - 3] = dataByte;
        rxdataPointer++;
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
        CRCDIRB_L = RAM_RX_Buf[i];
    }
    return (CRCINIRES == checksum);
}

/*******************************************************************************
* *Function:    sendByte
* *Description: Puts a single byte in the outgoing buffer, such as an error
*
* *Parameters:
*           char data    the byte to send
*******************************************************************************/

void sendByte(char data)
{

    byStatusByte = data;

    RAM_TX_Buf[0] = data; //Status Byte ACK/NACK
    transmitBufferLength = 1;
    transmitPoint = 0;    // V4 addition, just to be sure

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
    int i;

    RAM_TX_Buf[0] = byStatusByte; //ACK

    RAM_TX_Buf[1] = 0x80;
    RAM_TX_Buf[2] = size & 0xFF;
    RAM_TX_Buf[3] = size >> 8 & 0xFF;
    CRCINIRES = 0xFFFF;
    for (i = 0; i < size; i++){
        CRCDIRB_L = BSL430_SendBuffer[i];
    }
    i = CRCINIRES;

    RAM_TX_Buf[4 + size] = i & 0xFF;
    RAM_TX_Buf[5 + size] = i >> 8 & 0xFF;
    transmitBufferLength = size + 6;
    transmitPoint = 0;    // V4 addition, just to be sure
}

