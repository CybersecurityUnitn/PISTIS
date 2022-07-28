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
// (c)2012 by Texas Instruments Incorporated, All Rights Reserved.
/*----------------------------------------------------------------------------+
|                                                                             |
|                              Texas Instruments                              |
|                                                                             |
|                          USB HID for BSL                                    |
|                                                                             |
+-----------------------------------------------------------------------------+
|  Source: usb.h, v1.6 2012/10/11                                             |
|  Author: Rostyslav Stolyar                                                  |
|                                                                             |
|  Release Notes:                                                             |
|  Logs:                                                                      |
|                                                                             |
|  WHO          WHEN         WHAT                                             |
|  ---          ----------   ------------------------------------------------ |
|  R.Stolyar    2009/01/21   born                                             |
|  R.Stolyar    2009/03/12   Change from interrupt handling to polling        |
|  R.Stolyar    2009/04/20   Change version number to v1.0                    |
|  R.Stolyar    2009/06/24   Change to _tiny version                          |
|  R.Stolyar    2009/11/03   Disable Setup Interrupt                          |
|  R.Stolyar    2012/09/27   Changing handling of FRSTE according USB4        |
|                            Deleted UPCS0 from USB_Enable()                  |    
|  R.Stolyar    2012/10/11   Added workaround for USB9, remove enable INTs    |
|  B.Peterson   Aug29,2013   Changed USB_enable software delay to use lowest  |
|                            code size delay loop.                            |
|  N.Ramdas     Feb27,2013   Removed use of bHostAskMoreDataThanAvailable     |
|                            Optimized if/else.                               |
+----------------------------------------------------------------------------*/
/*----------------------------------------------------------------------------+
| Include files                                                               |
+----------------------------------------------------------------------------*/
#include "types.h"      // Basic Type declarations
#include "usb.h"        // USB-specific Data Structures
#include "UsbHidReq.h"
#include "descriptors.h"
#include "Proj_Settings.h"

/*----------------------------------------------------------------------------+
| Internal Constant Definition                                                |
+----------------------------------------------------------------------------*/
#define NO_MORE_DATA 0xFF

/*----------------------------------------------------------------------------+
| Internal Variables                                                          |
+----------------------------------------------------------------------------*/

#pragma location = 0x2400
__no_init BYTE bConfigurationNumber;      // Set to 1 when USB device has been
                                // configured, set to 0 when unconfigured
#pragma location = 0x2401
__no_init BYTE bInterfaceNumber;          // interface number

#pragma location = 0x2402
__no_init BYTE wBytesRemainingOnIEP0;     // For endpoint zero transmitter only
                                // Holds count of bytes remaining to be
                                // transmitted by endpoint 0.  A value
                                // of 0 means that a 0-length data packet
                                // A value of 0xFFFF means that transfer
                                // is complete.

#pragma location = 0x2404
__no_init BYTE wBytesRemainingOnOEP0;     // For endpoint zero transmitter only
                                // Holds count of bytes remaining to be
                                // received by endpoint 0.  A value
                                // of 0 means that a 0-length data packet
                                // A value of 0xFFFF means that transfer
                                // is complete.

#pragma location = 0x2406
__no_init PBYTE pbIEP0Buffer;             // A buffer pointer to input end point 0
                                // Data sent back to host is copied from
                                // this pointed memory location

//#pragma location = 0x240A
__no_init PBYTE pbOEP0Buffer;             // A buffer pointer to output end point 0
                                // Data sent from host is copied to
                                // this pointed memory location

#pragma location = 0x240E
__no_init BYTE bHostAskMoreDataThanAvailable;

__no_init BYTE abUsbRequestReturnData[USB_RETURN_DATA_LENGTH];
__no_init BYTE abUsbRequestIncomingData[USB_RETURN_DATA_LENGTH];

#pragma location = 0x2410
__no_init BYTE bStatusAction;

#pragma location = 0x2411
__no_init BYTE bFunctionSuspended;          // TRUE if function is suspended

#pragma location = 0x2412
__no_init BYTE bEnumerationStatus;          // will be set to '1' when the USB addr will be assigned

#pragma location = 0x2414
__no_init WORD wUSBPLL;                          // clock settings for PLL


/*----------------------------------------------------------------------------+
| Global Variables                                                            |
+----------------------------------------------------------------------------*/
/*----------------------------------------------------------------------------+
| Hardware Related Structure Definition                                       |
+----------------------------------------------------------------------------*/

#pragma location = 0x2380
__no_init tDEVICE_REQUEST tSetupPacket;

#pragma location = 0x0920
__no_init tEDB0 tEndPoint0DescriptorBlock;

#pragma location = 0x23C8
__no_init tEDB tInputEndPointDescriptorBlock[7];

#pragma location = 0x2388
__no_init tEDB tOutputEndPointDescriptorBlock[7];

#pragma location = 0x2378
__no_init BYTE abIEP0Buffer[EP0_MAX_PACKET_SIZE];

#pragma location = 0x2370
__no_init BYTE abOEP0Buffer[EP0_MAX_PACKET_SIZE];

#pragma location = OEP1_X_BUFFER_ADDRESS
 __no_init BYTE pbXBufferAddressEp1[EP_MAX_PACKET_SIZE];

#pragma location = OEP1_Y_BUFFER_ADDRESS
 __no_init BYTE pbYBufferAddressEp1[EP_MAX_PACKET_SIZE];

#pragma location = IEP1_X_BUFFER_ADDRESS
 __no_init BYTE pbXBufferAddressEp81[EP_MAX_PACKET_SIZE];

//----------------------------------------------------------------------------


VOID IntDelay(VOID);

VOID USB_init(VOID)
{
    //initialize RAM variables
    bFunctionSuspended = FALSE;

    // configuration of USB module
    USBKEYPID  = 0x9628;            // set KEY and PID to 0x9628 -> access to configuration registers enabled	  
#ifndef __MSP430FG6626__
    USBPWRCTL = 0;					// Workaround for USB9 
#endif
    __no_operation();               // for workaround USB9
    USBPWRCTL  = VUSBEN + SLDOEN + SLDOAON /*+ VBOFFIE + VBONIE*/; // keep primary and secondary LDO (3.3 and 1.8 V) enabled
    USBPHYCTL  = PUSEL;             // use DP and DM as USB terminals (not needed because an external PHY is connected to port 9)
    IntDelay();
    bEnumerationStatus = 0x00;      // Device not enumerated yet   
}

//----------------------------------------------------------------------------
VOID USB_enable()
{
    volatile unsigned int i;
    volatile unsigned int j = 0;

    USBKEYPID   =    0x9628;            // set KEY and PID to 0x9628 -> access to configuration registers enabled
    
    USBPLLDIVB = wUSBPLL;              	// Settings desired frequency
    USBPLLCTL  = UPFDEN + UPLLEN;       // Enable PLL, Phase Freq. Discriminator enable
    
    //Wait some time till PLL is settled
    do {
        USBPLLIR    =     0x0000;       // make sure no interrupts can occur on PLL-module
        
        __delay_cycles(1001);           // For lowest code size use a cycle count that is 3*n + 2
                                        // where n is any integer greater than 4 (IAR uses other
                                        // instructions when n is less than 5).
        if (j++ > 1000)
            return ;
    }while (USBPLLIR != 0);
	USBCNF |= USB_EN;                   // enable USB module    
}

//----------------------------------------------------------------------------

VOID USB_reset(VOID)
{
    bEnumerationStatus = 0x00;            // Device not enumerated yet
    bFunctionSuspended = FALSE;           // Device is not in suspend mode

    bConfigurationNumber    = 0x00;       // device unconfigured
    bInterfaceNumber        = 0x00;

    USBCTL = 0;                           // Function Reset Connection disable

    wBytesRemainingOnIEP0   = NO_MORE_DATA;
    wBytesRemainingOnOEP0   = NO_MORE_DATA;
    bStatusAction           = STATUS_ACTION_NOTHING;

    /* Set settings for EP0 */
    // NAK both 0 endpoints and enable endpoint 0 interrupt
    tEndPoint0DescriptorBlock.bIEPBCNT = EPBCNT_NAK;
    tEndPoint0DescriptorBlock.bOEPBCNT = EPBCNT_NAK;
    tEndPoint0DescriptorBlock.bIEPCNFG = EPCNF_USBIE | EPCNF_UBME | EPCNF_STALL;    // 8 byte data packet
    tEndPoint0DescriptorBlock.bOEPCNFG = EPCNF_USBIE | EPCNF_UBME | EPCNF_STALL;    // 8 byte data packet

    USBOEPIE = BIT0 | BIT1;                       // enable EP0 and EP1 output IRQ
    USBIEPIE = BIT0 | BIT1;                       // enable EP0 and EP1 input IRQ

    /* Set settings for IEP1 */
    // enable endpoint 1 interrupt, input
    tInputEndPointDescriptorBlock[0].bEPCNF   = EPCNF_UBME;               //single buffering
    tInputEndPointDescriptorBlock[0].bEPBBAX  = (BYTE)(((IEP1_X_BUFFER_ADDRESS - START_OF_USB_BUFFER) >> 3) & 0x00ff);
    tInputEndPointDescriptorBlock[0].bEPBCTX  = EPBCNT_NAK;
    tInputEndPointDescriptorBlock[0].bEPBCTY  = EPBCNT_NAK;
    tInputEndPointDescriptorBlock[0].bEPSIZXY = MAX_PACKET_SIZE;
         
    /* Set settings for OEP1 */
    // enable endpoint 1 interrupt, output
    tOutputEndPointDescriptorBlock[0].bEPCNF   = EPCNF_UBME ; //no double buffering
    tOutputEndPointDescriptorBlock[0].bEPBBAX  = (BYTE)(((OEP1_X_BUFFER_ADDRESS - START_OF_USB_BUFFER) >> 3) & 0x00ff);
    tOutputEndPointDescriptorBlock[0].bEPBCTX  = 0x00;
    tOutputEndPointDescriptorBlock[0].bEPSIZXY = MAX_PACKET_SIZE;

    USBCTL = FEN;                       // enable function
    USBIFG = 0;                         // make sure no interrupts are pending
    USBIFG &= ~RSTRIFG;                 //clear interrupt request flag
}

//----------------------------------------------------------------------------

VOID USB_suspend(VOID)
{
    bFunctionSuspended  = TRUE;
    USBCTL |= FRSTE;                    // Function Reset Connection Enable  
    USBIFG &= ~SUSRIFG;                 // clear interrupt flag
    USBPLLCTL = 0;                      // disable PLL
}

//----------------------------------------------------------------------------

VOID USB_resume(VOID)
{
    USB_enable();   					// enable PLL
    USBIFG &= ~(RESRIFG | SUSRIFG);     // clear interrupt flags
    bFunctionSuspended  = FALSE;
}

//----------------------------------------------------------------------------

VOID usbStallEndpoint0(VOID)
{
    tEndPoint0DescriptorBlock.bIEPCNFG |= EPCNF_STALL;
    tEndPoint0DescriptorBlock.bOEPCNFG |= EPCNF_STALL;
}

//----------------------------------------------------------------------------

VOID usbClearOEP0ByteCount(VOID)
{
    tEndPoint0DescriptorBlock.bOEPBCNT = 0x00;
}

//----------------------------------------------------------------------------

/*
VOID usbStallOEP0(VOID)
{
    // in standard USB request, there is not control write request with data stage
    // control write, stall output endpoint 0
    // wLength should be 0 in all cases
    tEndPoint0DescriptorBlock.bOEPCNFG |= EPCNF_STALL;
}
*/

//----------------------------------------------------------------------------

VOID usbSendNextPacketOnIEP0(VOID)
{
    BYTE bPacketSize,bIndex;

    // First check if there are bytes remaining to be transferred
    if(wBytesRemainingOnIEP0 != NO_MORE_DATA){
        if(wBytesRemainingOnIEP0 > EP0_PACKET_SIZE){
            // More bytes are remaining than will fit in one packet
            // there will be More IN Stage
            bPacketSize = EP0_PACKET_SIZE;
            wBytesRemainingOnIEP0 -= EP0_PACKET_SIZE;
            bStatusAction = STATUS_ACTION_DATA_IN;

        }else if (wBytesRemainingOnIEP0 < EP0_PACKET_SIZE){
            // The remaining data will fit in one packet.
            // This case will properly handle wBytesRemainingOnIEP0 == 0
            bPacketSize = (BYTE)wBytesRemainingOnIEP0;
            wBytesRemainingOnIEP0 = NO_MORE_DATA;        // No more data need to be Txed
            bStatusAction = STATUS_ACTION_NOTHING;

        }else{
            bPacketSize = EP0_PACKET_SIZE;
            wBytesRemainingOnIEP0 = NO_MORE_DATA;
            bStatusAction = STATUS_ACTION_NOTHING;
        }

        for(bIndex=0; bIndex<bPacketSize; bIndex++)
        {
            abIEP0Buffer[bIndex] = *pbIEP0Buffer;
            pbIEP0Buffer++;
        }
        tEndPoint0DescriptorBlock.bIEPBCNT = bPacketSize;
    }else bStatusAction = STATUS_ACTION_NOTHING;
}

//----------------------------------------------------------------------------

VOID usbSendDataPacketOnEP0(PBYTE pbBuffer)
{
    WORD bTemp;
    pbIEP0Buffer = pbBuffer;
    bTemp = tSetupPacket.wLength;

    // Limit transfer size to wLength if needed
    // this prevent USB device sending 'more than require' data back to host
    if(wBytesRemainingOnIEP0 >= bTemp)
    {
        wBytesRemainingOnIEP0 = bTemp;
    }
    usbSendNextPacketOnIEP0();
}

//----------------------------------------------------------------------------

VOID usbSendZeroLengthPacketOnIEP0(VOID)
{
    wBytesRemainingOnIEP0 = NO_MORE_DATA;
    bStatusAction = STATUS_ACTION_NOTHING;
    tEndPoint0DescriptorBlock.bIEPBCNT = 0x00;
}

//----------------------------------------------------------------------------

VOID usbClearEndpointFeature(VOID)
{
    BYTE bEndpointNumber;

    // EP is from EP1 to EP7 while C language start from 0
    bEndpointNumber = (tSetupPacket.wIndex & EP_DESC_ADDR_EP_NUM);
    if(bEndpointNumber == 0x00) usbSendZeroLengthPacketOnIEP0();
    else{
        if(bEndpointNumber == 1){
            if((tSetupPacket.wIndex & EP_DESC_ADDR_DIR_IN) == EP_DESC_ADDR_DIR_IN)
            {
                // input endpoint
                tInputEndPointDescriptorBlock[0].bEPCNF &= ~(EPCNF_STALL | EPCNF_TOGGLE);
            }
            else
            {
                // output endpoint
                tOutputEndPointDescriptorBlock[0].bEPCNF &= ~(EPCNF_STALL | EPCNF_TOGGLE);
            }
            usbSendZeroLengthPacketOnIEP0();
        }
    }
}

//----------------------------------------------------------------------------

VOID usbGetConfiguration(VOID)
{
    usbClearOEP0ByteCount();                    // for status stage
    wBytesRemainingOnIEP0 = 1;
    usbSendDataPacketOnEP0((PBYTE)&bConfigurationNumber);
}

//----------------------------------------------------------------------------

VOID usbGetDeviceDescriptor(VOID)
{
    usbClearOEP0ByteCount();
    wBytesRemainingOnIEP0 = SIZEOF_DEVICE_DESCRIPTOR;
    usbSendDataPacketOnEP0((PBYTE) &abromDeviceDescriptor);
}

//----------------------------------------------------------------------------

VOID usbGetConfigurationDescriptor(VOID)
{
    usbClearOEP0ByteCount();
    wBytesRemainingOnIEP0 = sizeof(abromConfigurationDescriptorGroup);
    usbSendDataPacketOnEP0((PBYTE)&abromConfigurationDescriptorGroup);
}

//----------------------------------------------------------------------------

VOID usbGetInterface(VOID)
{
    // not fully supported, return one byte, zero
    usbClearOEP0ByteCount();                    // for status stage
    wBytesRemainingOnIEP0 = 0x02;
    abUsbRequestReturnData[0] = 0x00;           // changed to report alternative setting byte
    abUsbRequestReturnData[1] = bInterfaceNumber;
    usbSendDataPacketOnEP0((PBYTE)&abUsbRequestReturnData[0]);
}

//----------------------------------------------------------------------------

VOID usbGetDeviceStatus(VOID)
{
    /* for Self Powerd USB device
    if((abromConfigurationDescriptorGroup[OFFSET_CONFIG_DESCRIPTOR_POWER] &
        CFG_DESC_ATTR_SELF_POWERED) == CFG_DESC_ATTR_SELF_POWERED)
        abUsbRequestReturnData[0] = DEVICE_STATUS_SELF_POWER;
    */

    usbClearOEP0ByteCount();                    // for status stage

    // Return self power status and remote wakeup status
    wBytesRemainingOnIEP0 = 2;
    usbSendDataPacketOnEP0((PBYTE)&abUsbRequestReturnData[0]);
}

//----------------------------------------------------------------------------

VOID usbGetEndpointStatus(VOID)
{
    BYTE bEndpointNumber;
    BYTE bDir;
    bDir = tSetupPacket.wIndex & EP_DESC_ADDR_DIR_IN;

    // Endpoint number is bIndexL
    bEndpointNumber = tSetupPacket.wIndex & EP_DESC_ADDR_EP_NUM;

    if(bEndpointNumber == 0x00){
        if( bDir){
            // input endpoint 0
            abUsbRequestReturnData[0] = (BYTE)(tEndPoint0DescriptorBlock.bIEPCNFG & EPCNF_STALL);
        }else{
            // output endpoint 0
            abUsbRequestReturnData[0] = (BYTE)(tEndPoint0DescriptorBlock.bOEPCNFG & EPCNF_STALL);
        }
    }else{
        // EP is from EP1 to EP7 while C language start from 0
        // Firmware should NOT response if specified endpoint is not supported. (charpter 8)
        if(bDir){
            // input endpoint
            abUsbRequestReturnData[0] = (BYTE)(tInputEndPointDescriptorBlock[0].bEPCNF & EPCNF_STALL);
        }else{
            // output endpoint
            abUsbRequestReturnData[0] = (BYTE)(tOutputEndPointDescriptorBlock[0].bEPCNF & EPCNF_STALL);
        }
    }
    abUsbRequestReturnData[0] = abUsbRequestReturnData[0] >> 3; // STALL is on bit 3
    usbClearOEP0ByteCount();                                    // for status stage
    wBytesRemainingOnIEP0 = 0x02;
    usbSendDataPacketOnEP0((PBYTE)&abUsbRequestReturnData[0]);
}

//----------------------------------------------------------------------------
VOID usbSetAddress(VOID)
{
    //usbStallOEP0();                             // control write without data stage

    // bValueL contains device address
    // waving verification (Rosty) if(tSetupPacket.wValue < 128){
    // hardware will update the address after status stage
    // therefore, firmware can set the address now.

    USBFUNADR = tSetupPacket.wValue;
    usbSendZeroLengthPacketOnIEP0();

    // waving verification (Rosty) }else usbStallEndpoint0();
}

//----------------------------------------------------------------------------

VOID usbSetConfiguration(VOID)
{
    //usbStallOEP0();                             // control write without data stage

    // configuration number is in bValueL
    // change the code if more than one configuration is supported
    bConfigurationNumber = tSetupPacket.wValue;
    usbSendZeroLengthPacketOnIEP0();

    bEnumerationStatus = ENUMERATION_COMPLETE;  // set device as enumerated
}

//----------------------------------------------------------------------------

VOID usbSetEndpointFeature(VOID)
{
    BYTE bEndpointNumber;

    // wValue contains feature selector
    // bIndexL contains endpoint number
    // Endpoint number is in low byte of wIndex
    if((tSetupPacket.wValue&0xff) == FEATURE_ENDPOINT_STALL)
    {
        bEndpointNumber = (BYTE)(tSetupPacket.wIndex) & EP_DESC_ADDR_EP_NUM;
        if(bEndpointNumber == 0x00) usbSendZeroLengthPacketOnIEP0();  // do nothing for endpoint 0
        else
        {
            // Firmware should NOT response if specified endpoint is not supported. (charpter 8)
            if(bEndpointNumber == 1 )
            {
                if ((BYTE)(tSetupPacket.wIndex) & EP_DESC_ADDR_DIR_IN){
                    // input endpoint
                    tInputEndPointDescriptorBlock[0].bEPCNF |= EPCNF_STALL;
                }else{
                    // output endpoint
                    tOutputEndPointDescriptorBlock[0].bEPCNF |= EPCNF_STALL;
                }
                usbSendZeroLengthPacketOnIEP0();
            } // no response if endpoint is not supported.
        }
    }
    else 
    {
        usbStallEndpoint0();
    }
}

//----------------------------------------------------------------------------

VOID usbSetInterface(VOID)
{
    // bValueL contains alternative setting
    // bIndexL contains interface number
    // change code if more than one interface is supported
    //usbStallOEP0();                             // control write without data stage
    bInterfaceNumber = tSetupPacket.wIndex;
    usbSendZeroLengthPacketOnIEP0();
}

//----------------------------------------------------------------------------
VOID usbDecodeAndProcessUsbRequest(VOID)
{
    BOOL InTransaction;

    // copy the MSB of bmRequestType to DIR bit of USBCTL
    if((tSetupPacket.bmRequestType & USB_REQ_TYPE_INPUT) != 0x00)
    {
        InTransaction = TRUE;
        USBCTL |= DIR;
    }
    else
    {
        InTransaction = FALSE;
        USBCTL &= ~DIR;
    }

    //decode request
    if ((tSetupPacket.bmRequestType & USB_REQ_TYPE_MASK) == USB_REQ_TYPE_STANDARD)
    {
        switch (tSetupPacket.bRequest)
        {
        case USB_REQ_GET_DESCRIPTOR:
            if (InTransaction == FALSE) break; //exit and stall
            switch (tSetupPacket.wValue>>8)
            {
            case DESC_TYPE_DEVICE:
                usbGetDeviceDescriptor();
                return;
            case DESC_TYPE_CONFIG:
                usbGetConfigurationDescriptor();
                return;

            case DESC_TYPE_REPORT:
                usbGetReportDescriptor();
                return;
            case DESC_TYPE_HID:
                usbGetHidDescriptor();
                return;
            } //switch (tSetupPacket.wValue>>8
            break; //USB_REQ_GET_DESCRIPTOR

        case USB_REQ_GET_INTERFACE:
            if (InTransaction == FALSE) break; //exit and stall
            usbGetInterface();
            return;
        case USB_REQ_SET_ADDRESS:
            usbSetAddress();
            return;
        case USB_REQ_SET_CONFIGURATION:
            usbSetConfiguration();
            return;
        case USB_REQ_GET_CONFIGURATION:
            usbGetConfiguration();
            return;
        case USB_REQ_SET_INTERFACE:
            usbSetInterface();
            return;
        case USB_REQ_SET_FEATURE:
            usbSetEndpointFeature();
            return;
        case USB_REQ_CLEAR_FEATURE:
            usbClearEndpointFeature();
            return;
        case USB_REQ_GET_STATUS:
            if  (tSetupPacket.bmRequestType == (USB_REQ_TYPE_INPUT | USB_REQ_TYPE_STANDARD | USB_REQ_TYPE_DEVICE))
            {
                usbGetDeviceStatus();
                return;
            }

            //USB_REQ_TYPE_INPUT | USB_REQ_TYPE_STANDARD | USB_REQ_TYPE_INTERFACE,
            //usbGetInterfaceStatus();

            if (tSetupPacket.bmRequestType == (USB_REQ_TYPE_INPUT | USB_REQ_TYPE_STANDARD | USB_REQ_TYPE_ENDPOINT))
            {
                usbGetEndpointStatus();
                return;
            }
        }//switch (tSetupPacket.bRequest)
    }
    usbStallEndpoint0();
}


/*----------------------------------------------------------------------------+
| End of source file                                                          |
+----------------------------------------------------------------------------*/
/*------------------------ Nothing Below This Line --------------------------*/
