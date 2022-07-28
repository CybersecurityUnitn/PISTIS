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
#include "types.h"      // Basic Type declarations
#include "Proj_Settings.h"
#include "usb.h"        // USB-specific Data Structures
#include "hal_UCS.h"
#include "USBAPI.h"
#include "USBAPI.h"
#include "BSL430_Command_Interpreter.h"
#include "BSL430_PI.h"
#include "BSL430_API.h"

#define MAX_BUFFER_SIZE 62
extern __no_init BYTE bFunctionSuspended;
__no_init char *BSL430_ReceiveBuffer;
__no_init char *BSL430_SendBuffer;
__no_init unsigned int BSL430_BufferSize;
char RAM_Buf[MAX_BUFFER_SIZE+1];

#ifdef SMALL_ZAREA
#define SPEED_1_LOC 0x106C
#define SPEED_2_LOC 0x106E
#define SPEED_3_LOC 0x1070
#define SPEED_4_LOC 0x1072
#else
#define SPEED_1_LOC 0x1074
#define SPEED_2_LOC 0x1076
#define SPEED_3_LOC 0x1078
#define SPEED_4_LOC 0x107A
#endif

#ifndef RAM_BASED_BSL
const WORD cSPEED_1_PLL @ SPEED_1_LOC = SPEED_1_PLL;
const WORD cSPEED_2_PLL @ SPEED_2_LOC = SPEED_2_PLL;
const WORD cSPEED_3_PLL @ SPEED_3_LOC = SPEED_3_PLL;
const WORD cSPEED_4_PLL @ SPEED_4_LOC = SPEED_4_PLL;
#else
const WORD cSPEED_1_PLL = SPEED_1_PLL;
const WORD cSPEED_2_PLL = SPEED_2_PLL;
const WORD cSPEED_3_PLL = SPEED_3_PLL;
const WORD cSPEED_4_PLL = SPEED_4_PLL;
#endif

#ifndef USBKEYPID_STARTUP_BUGFIX
#error ERROR: Ensure that the USBKEYPID is closed correctly in the low level init file!
#endif

/*******************************************************************************
Change Log:
--------------------------------------------------------------------------------
Version 9
04/16/15 MG  Performing USB initialization before setting up SVS.
Version 8
Aug29.13 BEP Added proper VCORE initialization routine. This includes the fix
             for errate FLASH37 to cover all device revisions.
         BEP Saved global variables and registers to locals for repeated access.
--------------------------------------------------------------------------------
Version 7
08.05.13 EL USB Babbling Bugfix
--------------------------------------------------------------------------------
Version 6 work begins
11.10.12 LCW USB bugfixes
         Reintroduced USB conf lock bug to keep device behavior the same
--------------------------------------------------------------------------------
Version 5 work begins
02.03.12 LCW  Correctly lock USB conf registers in low level init
         LCW  Added bugfix check to C file to ensure other devices get fix
--------------------------------------------------------------------------------
Version 4 work begins
16.03.10 LCW  DCORSEL_3 -> DCORSEL_4
              Inlined XT2 startup code
              Source code cleanup
*******************************************************************************/

#define USB_PI 0x30
#define USB_PI_VERSION 0x09
#define PI_VERSION (USB_PI+USB_PI_VERSION) // 0x39

const unsigned char BSL430_PI_Version @ "BSL430_VERSION_PI" = PI_VERSION;
/*******************************************************************************
*Function:    init
*Description: Initialize the peripheral and ports to begin TX/RX
*******************************************************************************/
#pragma required=BSL430_PI_Version
void PI_init()
{
  volatile unsigned int i;
  __disable_interrupt();
  BSL430_ReceiveBuffer = (char*)(ReceiveBuffer)+1;
  BSL430_SendBuffer = &RAM_Buf[1];
#ifdef RAM_BASED_BSL
  USBKEYPID = 0x9628;
  USBCNF = 0;
#else

    //init USB
    USB_init();

    //Set VCore for 1.8 Volt - required by USB module!

    // Open PMM registers for write access
    PMMCTL0_H = 0xA5;

    unsigned short level = PMMCTL0_L & (PMMCOREV1 | PMMCOREV0);
    while(level < 4) {
        // Set SVM highside to new level and check if a VCore increase is possible
        SVSMHCTL = SVMHE | SVSHE | (SVSMHRRL0 * level);
        // Wait until SVM highside is settled
        while ((PMMIFG & SVSMHDLYIFG) == 0);
        // Clear flag
        PMMIFG &= ~SVSMHDLYIFG;
        // Set also SVS highside to new level
        // Vcc is high enough for a Vcore increase
        SVSMHCTL |= (SVSHRVL0 * level);
        // Wait until SVM highside is settled
        while ((PMMIFG & SVSMHDLYIFG) == 0);
        // Clear flag
        PMMIFG &= ~SVSMHDLYIFG;
        //**************flow change for errata workaround ************
        // Set VCore to new level
        PMMCTL0_L = PMMCOREV0 * level;
        // Set SVM, SVS low side to new level
        SVSMLCTL = SVMLE | (SVSMLRRL0 * level)| SVSLE | (SVSLRVL0 * level);
        // Wait until SVM, SVS low side is settled
        while ((PMMIFG & SVSMLDLYIFG) == 0);
        // Clear flag
        PMMIFG &= ~SVSMLDLYIFG;
        //**************flow change for errata workaround ************

        // Increment next VCore level
        level++;
    }

    // Lock PMM registers for write access
    PMMCTL0_H = 0x00;

  //XT2 Startup
  XT2SEL_PORT |= XT2SEL_PINS;
  UCSCTL6 &= ~XT2OFF;         // enalbe XT2 even if not used

  while (UCSCTL7 & (DCOFFG + XT2OFFG))
  {
      UCSCTL7 &= ~(DCOFFG + XT1LFOFFG + XT2OFFG); // Clear OSC flaut Flags fault flags
      SFRIFG1 &= ~OFIFG;                  // Clear OFIFG fault flag
  }

  UCSCTL3 = SELREF__REFOCLK;              // REFO for FLL reference
  UCSCTL4 = SELA__REFOCLK + SELS__XT2CLK + SELM__DCOCLK;     // ACLK = REFOCLK, SMCLK = XT2, MCLK = DCO
  UCSCTL5 = DIVA_2;                       // ACLK/4
#define ACLK_DIV_SPEED  (ACLK_SPEED/4)

  TIMER_CTL = TIMER_CTL_SETTINGS;         // TB clock = SMCLK (DCO), cont. mode
  for( i = 300; i > 0; i --)              // this loop causes the "crystal detect"
  {                                       // to function as a crystal stabalization delay
                                          // delay = (1/32768)*4*300 = 36 ms
    TIMER_CCTL = TIMER_CCTL_SETTINGS;     // Rising edge, CCI6B = ACLK, Capture
    while(!(TIMER_CCTL & TIMER_CCTL_IFG) ){} // wait for first capture (unknown time)
    TIMER_CTL |= TIMER_CTL_CLR;
  }
  TIMER_CCTL &= ~TIMER_CCTL_CM;

  unsigned int timerCCR = TIMER_CCR; // Using local variable to compare register
  if( timerCCR > (((SPEED_1 + SPEED_2) / 2)/ ACLK_DIV_SPEED) )
  {
    wUSBPLL = *(&cSPEED_1_PLL);           // Referencing a constant is done in order to force
                                          // the compiler to place the constants in flash
                                          // and use them to initialize the PLL.  This way
                                          // the constants can be modified in the binary image
                                          // in order to change the desired crystal frequency.
                                          // for instance: all values to 20MHz
  }
  else if( timerCCR > (((SPEED_2 + SPEED_3) / 2)/ ACLK_DIV_SPEED) )
  {
    wUSBPLL = *(&cSPEED_2_PLL);
  }
  else if( timerCCR > (((SPEED_3 + SPEED_4) / 2)/ ACLK_DIV_SPEED) )
  {
    wUSBPLL = *(&cSPEED_3_PLL);
  }
  else
  {
    wUSBPLL = *(&cSPEED_4_PLL);
  }
#endif
  UCSCTL0 = 0x000;                        // Set DCO to lowest Tap
  UCSCTL2= FLLD__2 | ((DCO_SPEED/ACLK_SPEED) - 1);
  UCSCTL1= DCORSEL_4;
  UCSCTL4 = SELM__DCOCLKDIV + SELS__DCOCLKDIV + SELA__REFOCLK;

  //connect to USB if cable already was pluged in
  if (USBPWRCTL & USBBGVBV)
  {
    USB_enable();
    USB_reset();
    USBCNF |= PUR_EN; // generate rising edge on DP -> the host enumerates our device as full speed device
  }
}

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
  unsigned int localBufferSize = 0; // Using local variable for comparison

  UsbClearReceiveBuffer();
  while( localBufferSize == 0 )
  {
    UsbHandler();
    if (bEnumerationStatus == ENUMERATION_COMPLETE) // if enumeration completed
    {
      if (bFunctionSuspended == FALSE)    // and device not suspended
      {
      localBufferSize = UsbReceiveHID();
      }
    }
  }
  if( localBufferSize > 0 )
  {
    BSL430_BufferSize = *ReceiveBuffer;   // first byte is size
    return DATA_RECEIVED;
  }
  else
  {
    BSL430_BufferSize = localBufferSize;
    return 0x00;
  }
}

/*******************************************************************************
*Function:    PI_sendData
*Description: Sends the data in the data buffer
*Parameters:
              int bufSize - the number of bytes to send
*******************************************************************************/
void PI_sendData(int bufSize)
{
  RAM_Buf[0] = bufSize;
  while( UsbSendHID((BYTE const*)RAM_Buf) == 0 );
}
/*******************************************************************************
*Function:    PI_getBufferSize
*Description: Returns the max Data Buffer Size for this PI (size of BSL430_SendBuffer)
*Returns:     size in bytes of BSL430_SendBuffer
*******************************************************************************/
int PI_getBufferSize()
{
  return MAX_BUFFER_SIZE;
}