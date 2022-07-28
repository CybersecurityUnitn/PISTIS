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
|                             USB HID for BSL                                 |
|                                                                             |
+-----------------------------------------------------------------------------+
|  Source: UsbIsr.h, v1.7 2013/06/26                                          |
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
|  R.Stolyar    2009/07/03   Added: USB_power_off event initiates BOR         |
|  R.Stolyar    2009/10/13   Added delay in PWRVBUSoffHandler()	              |
|  R.Stolyar    2009/10/14   Increased delay in IntDelay()	                  |
|  R.Stolyar    2009/11/02   Increased priority of Setup packet handling      |
|  R.Stolyar    2012/09/27   Changing handling of FRSTE according USB4        |
|  R.Stolyar    2012/10/11   Remove interrupt capability, cosmetic changes.   |
|  E.Loeffler   2013/06/26   Added USB Babbleing Bugfix with inline asm       |
|  B.Peterson   Aug29,2013   Local variable for UsbHandler().                 |
|                            Changing loop count to 'magic number'            | 
+----------------------------------------------------------------------------*/
/*----------------------------------------------------------------------------+
| Include files                                                               |
+----------------------------------------------------------------------------*/

#include "device.h"
#include "defUSB.h"
#include "types.h"      // Basic Type declarations
#include "usb.h"
#include "UsbIsr.h"
#include "Proj_Settings.h"
#include "USBAPI.h"
#include <intrinsics.h>

/*----------------------------------------------------------------------------+
| External Variables                                                          |
+----------------------------------------------------------------------------*/
extern __no_init BYTE  bFunctionSuspended;

extern volatile BYTE *pbBytesRemainingOnOEP1;

extern __no_init tEDB0 tEndPoint0DescriptorBlock;
extern __no_init tEDB tInputEndPointDescriptorBlock[];
extern __no_init tEDB tOutputEndPointDescriptorBlock[];

extern __no_init BYTE bStatusAction;

/*----------------------------------------------------------------------------+
| General Subroutines                                                         |
+----------------------------------------------------------------------------*/

VOID UsbHandler(VOID)
{  
    unsigned int localUSBIFG = USBIFG;
    
    //Check if the setup interrupt is pending. 
    //We need to check it before other interrupt requests, 
    //to work around that the Setup Int has lower prio then Input Endp0
    if (localUSBIFG & SETUPIFG)
        SetupPacketInterruptHandler();  
    else if (USBPWRCTL & VBONIFG)
        PWRVBUSonHandler();
    else if (USBPWRCTL & VBOFFIFG)
        PWRVBUSoffHandler();
    else if (USBIEPIFG & BIT0) // IEPIFG0 flag = BIT0 
        IEP0InterruptHandler();
    else if (localUSBIFG & RSTRIFG) 
        USB_reset();
    else if (localUSBIFG & SUSRIFG) 
        USB_suspend();
    else if (localUSBIFG & RESRIFG) 
        USB_resume();    
}

/*----------------------------------------------------------------------------+
| Interrupt Sub-routines                                                      |
+----------------------------------------------------------------------------*/

VOID SetupPacketInterruptHandler(VOID)
{
    USBCTL |= FRSTE;                            // Function Reset Connection Enable
  
    // NAK both input and output endpoints
    tEndPoint0DescriptorBlock.bOEPBCNT = EPBCNT_NAK;

    usbProcessNewSetupPacket:

    bStatusAction = STATUS_ACTION_NOTHING;

    // clear out return data buffer
    *((unsigned int*)abUsbRequestReturnData) = 0x0000;

    // decode and process the request
    usbDecodeAndProcessUsbRequest();
	// Workaround for BUG2145
    asm("mov.w   #0x80,R4");
    asm("bic.w   R4,&0920h");
    asm("bic.w   R4,&0922h");
    
    USBIFG &= ~SETUPIFG; // clear the interrupt bit
	// Workaround for BUG2145
    asm("bis.w   R4,&0920h");
    asm("bis.w   R4,&0922h");

    // check if there is another setup packet pending
    // if it is, abandon current one by NAKing both data endpoint 0
    if((USBIFG & STPOWIFG) != 0x00)
    {
        USBIFG &= ~(STPOWIFG | SETUPIFG);
        goto usbProcessNewSetupPacket;
    }
}

//----------------------------------------------------------------------------
VOID IntDelay(VOID)
{
    __delay_cycles(36002);   // delay for 8000 cycles ~1 ms at 8 MHz
}

//----------------------------------------------------------------------------
VOID PWRVBUSoffHandler(VOID)
{
    IntDelay();	//delay before reset. Needed to avoid the device started again 
				// after it loosing power

	//reset device if USB cable plagged off
    PMMCTL0 = PMMPW | PMMSWBOR; // generate BOR for reseting device
}

//----------------------------------------------------------------------------

VOID PWRVBUSonHandler(VOID)
{
    IntDelay();
    USB_enable();
    USB_reset();

    USBPWRCTL &= ~(VBONIFG|VBOFFIFG);       // clean pending VBUS ON and OFF interrupts, if any
    USBCNF |= PUR_EN;                       // generate rising edge on DP -> the host enumerates our device as full speed device
}

//----------------------------------------------------------------------------
VOID IEP0InterruptHandler(VOID)
{
    USBCTL |= FRSTE;                        // Function Reset Connection Enable 
    tEndPoint0DescriptorBlock.bOEPBCNT = 0x00;

    if(bStatusAction == STATUS_ACTION_DATA_IN)
    {
        usbSendNextPacketOnIEP0();
    }
    else
    {
        tEndPoint0DescriptorBlock.bIEPCNFG |= EPCNF_STALL; // no more data
    }
    USBIEPIFG &= ~BIT0;                     //clear interrupt request flag
}

/*----------------------------------------------------------------------------+
| Interrupt Service Routines                                                  |
+----------------------------------------------------------------------------*/
/*----------------------------------------------------------------------------+
| Main Routine                                                                |
+----------------------------------------------------------------------------*/
/*----------------------------------------------------------------------------+
| End of source file                                                          |
+----------------------------------------------------------------------------*/
/*------------------------ Nothing Below This Line --------------------------*/


