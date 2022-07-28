/* --COPYRIGHT--,BSD
 * Copyright (c) 2014, Texas Instruments Incorporated
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
 * --/COPYRIGHT--*/
// (c)2009 by Texas Instruments Incorporated, All Rights Reserved.
/*----------------------------------------------------------------------------+
|                                                                             |
|                              Texas Instruments                              |
|                                                                             |
|                             USB HID for BSL                                 |
|                                                                             |
+-----------------------------------------------------------------------------+
|  Source: UsbApi.h, v1.1 2009/06/29                                          |
|  Author: Rostyslav Stolyar                                                  |
|                                                                             |
|  Release Notes:                                                             |
|  Logs:                                                                      |
|                                                                             |
|  WHO          WHEN         WHAT                                             |
|  ---          ----------   ------------------------------------------------ |
|  R.Stolyar    2009/01/21   born                                             |
|  R.Stolyar    2009/04/20   Change version number to v1.0                    |
|  R.Stolyar    2009/06/24   Change to _tiny version                          |
+----------------------------------------------------------------------------*/
/*----------------------------------------------------------------------------+
| Include files                                                               |
+----------------------------------------------------------------------------*/
#include "types.h"      // Basic Type declarations
#include "usb.h"        // USB-specific Data Structures
#include "descriptors.h"
#include "Proj_Settings.h"
#include "USBAPI.h"

/*----------------------------------------------------------------------------+
| Global Variables                                                            |
+----------------------------------------------------------------------------*/

#define ReceiveBuffer (const unsigned char*)(OEP1_X_BUFFER_ADDRESS + 1)

extern __no_init tEDB0 tEndPoint0DescriptorBlock;
extern __no_init tEDB tInputEndPointDescriptorBlock[];
extern __no_init tEDB tOutputEndPointDescriptorBlock[];



//This function always sends 64 bytes: 1 byte is 0x3f, 2..64byte are data
//returns how many bytes were sent
//
BYTE UsbSendHID(const BYTE* data)
{
    BYTE byte_count;
    byte_count = EP_MAX_PACKET_SIZE - 1;

    if(tInputEndPointDescriptorBlock[0].bEPBCTX & EPBCNT_NAK)
    {
        BYTE i;
        BYTE *p;
        p = (unsigned char*)IEP1_X_BUFFER_ADDRESS;
        *p = EP_MAX_PACKET_SIZE - 1;
        p++;
        for (i=0; i<byte_count; i++)
        {
            *p++ = *(data+i);
        }

        tInputEndPointDescriptorBlock[0].bEPBCTX = EP_MAX_PACKET_SIZE;    // Set Byte counter for USB SIE and send data from X-Buffer
    }
    else
    {
        byte_count = 0;
    }
    return byte_count;
}

// Returns:
//  ReceiveBuffer -> pointer to buffer with received data
//  returned value: how many bytes received (should be always 64)
//BYTE UsbReceiveHID(BYTE **data)
BYTE UsbReceiveHID(VOID)
{
    BYTE byte_count = 0;
    if (tOutputEndPointDescriptorBlock[0].bEPBCTX & EPBCNT_NAK)
    {
        //*data = (unsigned char*)(OEP1_X_BUFFER_ADDRESS + 1);
        byte_count = tOutputEndPointDescriptorBlock[0].bEPBCTX & 0x7f;
    }

    return byte_count;
}

//should be called after successed UsbReceiveHID() to make receive buffer ready to receive next data packet
VOID UsbClearReceiveBuffer(VOID)
{
    tOutputEndPointDescriptorBlock[0].bEPBCTX = 0x00;   // Clear EP1 X buffer counter, and reset NACK-bit to receive new data
}

/*----------------------------------------------------------------------------+
| End of source file                                                          |
+----------------------------------------------------------------------------*/
/*------------------------ Nothing Below This Line --------------------------*/
