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
|                          USB HID for BSL                                    |
|                                                                             |
+-----------------------------------------------------------------------------+
|  Source: Usb.h, v1.3 2009/10/20                                             |
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
|  R.Stolyar    2009/10/20   Change version to 1.3	                          |
+----------------------------------------------------------------------------*/
/*
 \par 	      Documents and books:
 \n           - Universal Serial Bus Specification Vers. 1.1, www.Usb.org
 \n           - Device Class Definition for Human Interface Devices (HID) Vers. 1.1, www.Usb.org
 \n           - Universal Serial Bus Class Definitions for Communication Devices Vers. 1.1, www.Usb.org
 \n           - USB 2.0 Handbuch fuer Entwickler(German) or USB 2.0 complete(English), Jan Axelson, www.lvr.com
 \n           - Universal Serial Bus System Architecture, Don Anderson
 \n           - http://www.microsoft.com/whdc/device/input/HID_HWID.mspx, Hardware IDs for HID Devices
 \n           - http://msdn2.microsoft.com/en-us/library/aa475772.aspx, USB Interface Association Descriptor
 \n           - http://msdn2.microsoft.com/en-us/library/aa476422.aspx, Support for Interface Collections
 \n           - http://msdn2.microsoft.com/en-us/library/aa476412.aspx, Handling CDC and WMCDC Interface Collections

 \par 	      Development tools:
 \n           - Usb descriptor viewer, www.USB.org, UVCView.x86.exe
 \n           - Hid device viewer, WindowsDDK, HClient.exe
 \n           - Usb complience test, www.USB.org, USBCV13.exe
 \n           - TI USB EEPROM Burner, www.TI.com, sllc259a.zip,
 \n           - TI TUSB3410 USB I2C Header Generator, www.TI.com, sllc293.zip
 \n           - TI Apploader Driver, www.TI.com, sllc160.zip
*/

#ifndef _Proj_Settings_H_
#define _Proj_Settings_H_

#include "device.h"
#include "defUSB.h"

#ifdef __cplusplus
extern "C"
{
#endif

/*----------------------------------------------------------------------------+
| Firmware Version                                                            |
|How to detect version number of the FW running on MSP430?                    |
|Open ControlPanel->Systems->Hardware->DeviceManager->Ports->Msp430->         |
|         ->ApplicationUART->Details                                          |
+----------------------------------------------------------------------------*/

#define VER_FW_H 0x01
#define VER_FW_L 0x12

/*----------------------------------------------------------------------------+
| Switches for different versions                                             |
+----------------------------------------------------------------------------*/
#define _HID_           // Needed for HID interface
//#define _USE_PLL_       // If defined the PLL is used, otherwise a 48MHz clock needs to be provided at XT2IN
//#define _PLL_USES_XT_ 2 // defines which XT is used by PLL (1 or 2)

#define _NO_ISR         // Do not use USB interrupt, handles it by polling

#ifdef __cplusplus
}
#endif
#endif /* _Proj_Settings_H_ */