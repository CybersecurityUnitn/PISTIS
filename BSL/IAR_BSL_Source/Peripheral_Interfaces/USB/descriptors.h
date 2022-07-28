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
|  Source: descripotrs.h, v1.1 2009/06/29                                     |
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
|  L.Westlund   2010/03/15   Removed VID/PID                                  |
+----------------------------------------------------------------------------*/

/*----------------------------------------------------------------------------+
| Include files                                                               |
+----------------------------------------------------------------------------*/
#include "Proj_Settings.h"

#define startHidDescriptor 18

#define MAX_PACKET_SIZE   0x40

//#define USB_STR_INDEX_SERNUM 1 // set to 0 if not SerialNumber String descriptor will be used
                               // or set to 1 if the serial number from TLV structure should be used

//Controls whether the remote wakeup feature is supported by this device.
//    A value of 0x20 indicates that is it supported (this value is the mask for
//    the bmAttributes field in the configuration descriptor).
//    A value of zero indicates remote wakeup is not supported.
//    Other values are undefined, as they will interfere with bmAttributes.
#define USB_SUPPORT_REM_WAKE    0 //CFG_DESC_ATTR_REMOTE_WAKE

//Controls whether the application is BUS powered
//    (gets the current for its functionality from USB bus) or SELF powered.
//    Set 0x80 for BUS powered device
//    or set to 0x40 for self powered device
#define USB_SUPPORT_BUS_POWERED CFG_DESC_ATTR_BUS_POWERED

//#define wTotalLength 53     // wTotalLength, CDC
#define wTotalLength 41     // wTotalLength, HID
#define USB_NUM_CONFIGURATIONS  1    // Number of implemented interfaces
//#define bInterfaceNumberCdc     0
#define bInterfaceNumberHid 0


#define SIZEOF_REPORT_DESCRIPTOR 64-28

extern BYTE const abromDeviceDescriptor[SIZEOF_DEVICE_DESCRIPTOR];

extern BYTE const abromConfigurationDescriptorGroup[wTotalLength];

extern BYTE const abromReportDescriptor[];


/*------------------------ Nothing Below This Line --------------------------*/
