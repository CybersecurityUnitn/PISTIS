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
#include "BSL430_Command_Interpreter.h"
#include "BSL430_Command_Definitions.h"
#include "BSL430_API.h"
#include "BSL430_PI.h"
#include "BSL_Device_File.h"

/******************************************************************************
*  Change Log:
*  2.2.09  LCW   worked on RAM Loader function
*  ----------------------------------------------------------------------------
*  Version 3 work begins
*  07.08.09 LCW  Removed parameter from mass erase
*  ----------------------------------------------------------------------------
*  Version 4 work begins
*  23.11.09 LCW  Changed to more generic API function calls
*  ----------------------------------------------------------------------------
*  Version 5 work begins
*  10.03.10 LCW  'Off by one' error with sending Data fixed
*  15.03.10 LCW   Misc comment cleanup for source release
*  ----------------------------------------------------------------------------
*  Version 5.1 (no output change, source/comment modified)
*  15.04.10 LCW Changed receiveDataBlock to remove warning
*  ----------------------------------------------------------------------------
*  Version 6.0
*  15.04.10 LCW Made Buffer_Size an unsigned int
*  ----------------------------------------------------------------------------
*  Version 6.1 (no output change, source/comment modified)
*  28.02.11 LCW Ran Uncrustify
*  ----------------------------------------------------------------------------
*  Version 7.0
*  13.04.11 LCW Made read length variables an unsigned int,
*               several others as well
*  ----------------------------------------------------------------------------
*  Version 7.1
*  Aug29.13 BEP Added function to clear RAM contents at the start of main
*  ----------------------------------------------------------------------------
*  Version 8
*  09/23/13 MG  Version number incremented to track possible P1.0-goes-high bug
*               in BSL430_Low_Level_Init.s43. No other changes than that.
*  ----------------------------------------------------------------------------
*  Version 8.1
*  05/22/14 MG  BSL Version Vendor is 0xFF in debug
******************************************************************************/

void interpretCommand();
void receiveDataBlock(unsigned long addr, char* data, char fastWrite);
void receivePassword();
void eraseLocation(char block_erase, unsigned long addr);
void CRC_Check(unsigned long addr, unsigned int length);
void sendDataBlock(unsigned long addr, unsigned int length);
void sendMessage(char message);

extern __no_init char* BSL430_ReceiveBuffer;
extern __no_init char* BSL430_SendBuffer;
extern __no_init unsigned int BSL430_BufferSize;

#ifndef NDEBUG
#warning DEBUG BUILD!
const unsigned char BSL430_Vendor_Version @ "BSL430_VERSION_VENDOR" = 0xFF;
#else
const unsigned char BSL430_Vendor_Version @ "BSL430_VERSION_VENDOR" = 0x00;
#endif
const unsigned char BSL430_CI_Version @ "BSL430_VERSION_CI" = 0x08;


/******************************************************************************
* *Function:    main
* *Description: Initializes the BSL Command Interpreter and begins listening
*               for incoming packets
******************************************************************************/
#pragma required=BSL430_Vendor_Version
#pragma required=BSL430_CI_Version
void main(void)
{
    unsigned char eventFlags = 0;
    volatile int i, ii;

    BSL430_API_RAM_Clear(); // Moved from BSL430_API_init() into independent function
    BSL430_API_init();
/* COMMENT OUT EXTRA CODE TO MAKE SPACE
 
#ifdef BSL2_PASSIVE_TIMEOUT
    PI_init_passive();

    BSL430_timeoutInit();

    while(1)
    {
        // Detect UART 
        if(UART_RX_IFG)
        {
            // Configure UART
            PI_init_active(PI_STATE_UART);
            break;
        }

        // Detect I2C 
        if(I2C_START_IFG)
        {
            // Configure active I2C
            PI_init_active(PI_STATE_I2C);
            break;
        }

        // Check for timeout 
        if(BSL430_timeoutTimedOut() == SUCCESSFUL_OPERATION)
        {
            BSL430_sleep();
        }
    }

    BSL430_timeoutStop();
#else*/
    PI_init();  // Replaced by passive and active init in BSL2
//#endif

/* Commented out
    while(1)
    {
        eventFlags = PI_receivePacket();
        if (eventFlags & DATA_RECEIVED)
        {
            interpretCommand();
        }
    }*/
}

/******************************************************************************
* *Function:    interpretCommand
* *Description: Interprets the command contained in the data buffer and
*               calls the appropriate BSL api function
******************************************************************************/

void interpretCommand()
{
    unsigned char command = BSL430_ReceiveBuffer[0];
    unsigned long addr = BSL430_ReceiveBuffer[1];

    addr |= ((unsigned long)BSL430_ReceiveBuffer[2]) << 8;
    addr |= ((unsigned long)BSL430_ReceiveBuffer[3]) << 16;
    switch (command)
    {
#ifdef SUPPORTS_RX_DATA_BLOCK_FAST
        case RX_DATA_BLOCK_FAST:
            receiveDataBlock(addr, &BSL430_ReceiveBuffer[4], 1);
            break;
#endif
        /*-------------------------------------------------------------------*/
#ifdef SUPPORTS_RX_PASSWORD
        case RX_PASSWORD:                 // Receive password
            receivePassword();
            break;
#endif
        /*-------------------------------------------------------------------*/
#ifdef SUPPORTS_LOAD_PC
        case LOAD_PC:                     // Load PC
            sendMessage(BSL430_callAddress(addr));
            break;
#endif
        /*-------------------------------------------------------------------*/
#ifdef SUPPORTS_RX_DATA_BLOCK
        case RX_DATA_BLOCK:               // Receive data block
            receiveDataBlock(addr, &BSL430_ReceiveBuffer[4], 0);
            break;
#endif
        /*-------------------------------------------------------------------*/
#ifdef SUPPORTS_MASS_ERASE
        case MASS_ERASE:                  // Mass Erase
            sendMessage(BSL430_massErase());
            break;
#endif
        /*-------------------------------------------------------------------*/
#ifdef SUPPORTS_ERASE_SEGMENT
        case ERASE_SEGMENT:               // Erase segment
            eraseLocation(0, addr);
            break;
#endif
        /*-------------------------------------------------------------------*/
#ifdef SUPPORTS_TOGGLE_INFO
        case TOGGLE_INFO:                 // Toggle Info lock
            sendMessage(BSL430_toggleInfoLock());
            break;
#endif
        /*-------------------------------------------------------------------*/
#ifdef SUPPORTS_ERASE_BLOCK
        case ERASE_BLOCK:                 // Erase Block
            eraseLocation(1, addr);
            break;
#endif
        /*-------------------------------------------------------------------*/
#ifdef SUPPORTS_CRC_CHECK
        case CRC_CHECK:                   // CRC Check
        {
            unsigned int length;
            length = BSL430_ReceiveBuffer[4];
            length |= ((unsigned long)BSL430_ReceiveBuffer[5]) << 8;
            CRC_Check(addr, length);
        }
        break;
#endif
        /*-------------------------------------------------------------------*/
#ifdef SUPPORTS_TX_DATA_BLOCK
        case TX_DATA_BLOCK:               // Transmit Data Block
        {
            unsigned int length;
            length = BSL430_ReceiveBuffer[4];
            length |= BSL430_ReceiveBuffer[5] << 8;
            sendDataBlock(addr, length);
        }
        break;
#endif
        /*-------------------------------------------------------------------*/
#ifdef SUPPORTS_TX_BSL_VERSION
        case TX_BSL_VERSION:              // Transmit BSL Version array
            sendDataBlock((unsigned long)(&BSL430_Vendor_Version), 4);
            break;
#endif
        /*-------------------------------------------------------------------*/
        default:                          // unknown command
            sendMessage(UNKNOWN_COMMAND);
    }
}

/******************************************************************************
* *Function:    receiveDataBlock
* *Description: Calls the API to write a data block to a given memory location
* *Parameters:
*           unsigned long addr  Address to which the data should be written
*           char* data          Pointer to an array of data to write
*           char  FastWrite     If 1, do not send a reply message
******************************************************************************/

void receiveDataBlock(unsigned long addr, char* data, char fastWrite)
{
#ifndef RAM_WRITE_ONLY_BSL
    char returnValue;
    returnValue = BSL430_openMemory();
    if ((returnValue == SUCCESSFUL_OPERATION) & (BSL430_BufferSize > 4))
#endif
    {
#ifndef RAM_WRITE_ONLY_BSL
        returnValue = BSL430_writeMemory(addr, BSL430_BufferSize - 4, data);
#else
        BSL430_writeMemory(addr, BSL430_BufferSize - 4, data);
#endif
    }
#ifndef RAM_WRITE_ONLY_BSL
    if (!fastWrite)
    {
        sendMessage(returnValue);
    }
    BSL430_closeMemory();
#endif
}

/******************************************************************************
* *Function:    receivePassword
* *Description: Calls the API to unlock the BSL
******************************************************************************/

void receivePassword()
{
    if (BSL430_unlock_BSL(&BSL430_ReceiveBuffer[1]) == SUCCESSFUL_OPERATION)
    {
        sendMessage(ACK);
    }
    else
    {
        sendMessage(BSL_PASSWORD_ERROR);
    }
}

/******************************************************************************
* *Function:    eraseSegment
* *Description: Calls the API to erase a segment containing the given address
* *Parameters:
*           char block_erase      If 1, the entire block should be erased
*           unsigned long addr    Address in the segment to be erased.
******************************************************************************/

void eraseLocation(char block_erase, unsigned long addr)
{
    sendMessage(BSL430_eraseLocation(block_erase, addr));
}

/******************************************************************************
* *Function:    CRC_Check
* *Description: Calls the API to perform a CRC check over a given addr+length
*               of data
* *Parameters:
*           unsigned long addr   Start Addr of CRC
*           unsigned int length  number of bytes in the CRC
******************************************************************************/

void CRC_Check(unsigned long addr, unsigned int length)
{
    int crcResult;
    int crcStatus;

    crcStatus = BSL430_crcCheck(addr, length, &crcResult);
    if (crcStatus == BSL_LOCKED)
    {
        sendMessage(BSL_LOCKED);
    }
    else
    {
        BSL430_SendBuffer[0] = BSL_DATA_REPLY;
        BSL430_SendBuffer[1] = (char)(crcResult & 0xFF);
        BSL430_SendBuffer[2] = (char)((crcResult >> 8) & 0xFF);
        PI_sendData(3);
    }
}

/******************************************************************************
* *Function:    sendDataBlock
* *Description: Fills the SendBuffer array with bytes from the given parameters
*             Sends the data by calling the PI, or sends an error
* *Parameters:
*           unsigned long addr    Address from which to begin reading the block
*           int length            The number of bytes to read
******************************************************************************/

void sendDataBlock(unsigned long addr, unsigned int length)
{
    unsigned long endAddr = addr + length;
    unsigned int bytes;
    char returnValue = SUCCESSFUL_OPERATION;

    while ((addr < endAddr) & (returnValue == SUCCESSFUL_OPERATION))
    {
        if ((endAddr - addr) > PI_getBufferSize() - 1)
        {
            bytes = PI_getBufferSize() - 1;
        }
        else
        {
            bytes = (endAddr - addr);
        }
        returnValue = BSL430_readMemory(addr, bytes, &BSL430_SendBuffer[1]);
        if (returnValue == SUCCESSFUL_OPERATION)
        {
            BSL430_SendBuffer[0] = BSL_DATA_REPLY;
            PI_sendData(bytes + 1);
        }
        else
        {
            sendMessage(returnValue);
        }
        addr += bytes;
    }
}

/******************************************************************************
* *Function:    sendMessage
* *Description: Sends a Reply message with attached information
* *Parameters:
*           char message    the message to send
******************************************************************************/

void sendMessage(char message)
{
    BSL430_SendBuffer[0] = BSL_MESSAGE_REPLY;
    BSL430_SendBuffer[1] = message;
    PI_sendData(2);
}

