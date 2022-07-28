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
|  Source: UsbHidReq.h, v1.1 2009/06/29                                       |
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

#ifndef _UsbHidReq_H_
#define _UsbHidReq_H_

#ifdef __cplusplus
extern "C"
{
#endif


/**
\fn      VOID usbGetHidDescriptor(VOID);

\brief   Return Hid descriptor to host over control endpoint
*/
VOID usbGetHidDescriptor(VOID);

/**
\fn      VOID usbGetReportDescriptor(VOID);

\brief   Return HID report descriptor to host over control endpoint
*/
VOID usbGetReportDescriptor(VOID);

/**
\fn      VOID usbSetReport(VOID);

\brief   Receive Out-report from host
*/
VOID usbSetReport(VOID);

/**
\fn      VOID usbGetReport(VOID);

\brief   Return In-report or In-feature-report to host over interrupt endpoint
*/
VOID usbGetReport(VOID);

#ifdef __cplusplus
}
#endif
#endif //_UsbHidReq_H_
