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
// (c)20099 by Texas Instruments Incorporated, All Rights Reserved.
/*----------------------------------------------------------------------------+
|                                                                             |
|                              Texas Instruments                              |
|                                                                             |
|                             USB HID for BSL                                 |
|                                                                             |
+-----------------------------------------------------------------------------+
|  Source: UsbIsr.h, v1.1 2009/06/29                                          |
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

#ifndef _USBISR_H_
#define _USBISR_H_

#ifdef __cplusplus
extern "C"
{
#endif

//values of USBVECINT when USB-interrupt occured
#define     VECINT_NO_INTERRUPT             0x00
#define     VECINT_PWR_DROP_INTERRUPT       0x02
#define     VECINT_PLL_LOCK_INTERRUPT       0x04
#define     VECINT_PLL_SIGNAL_INTERRUPT     0x06
#define     VECINT_PLL_RANGE_INTERRUPT      0x08
#define     VECINT_PWR_VBUSOn_INTERRUPT     0x0A
#define     VECINT_PWR_VBUSOff_INTERRUPT    0x0C
#define     VECINT_USB_TIMESTAMP_INTERRUPT  0x10
#define     VECINT_INPUT_ENDPOINT0          0x12
#define     VECINT_OUTPUT_ENDPOINT0         0x14
#define     VECINT_RSTR_INTERRUPT           0x16
#define     VECINT_SUSR_INTERRUPT           0x18
#define     VECINT_RESR_INTERRUPT           0x1A
#define     VECINT_SETUP_PACKET_RECEIVED    0x20
#define     VECINT_STPOW_PACKET_RECEIVED    0x22
#define     VECINT_INPUT_ENDPOINT1          0x24
#define     VECINT_INPUT_ENDPOINT2          0x26
#define     VECINT_INPUT_ENDPOINT3          0x28
#define     VECINT_INPUT_ENDPOINT4          0x2A
#define     VECINT_INPUT_ENDPOINT5          0x2C
#define     VECINT_INPUT_ENDPOINT6          0x2E
#define     VECINT_INPUT_ENDPOINT7          0x30
#define     VECINT_OUTPUT_ENDPOINT1         0x32
#define     VECINT_OUTPUT_ENDPOINT2         0x34
#define     VECINT_OUTPUT_ENDPOINT3         0x36
#define     VECINT_OUTPUT_ENDPOINT4         0x38
#define     VECINT_OUTPUT_ENDPOINT5         0x3A
#define     VECINT_OUTPUT_ENDPOINT6         0x3C
#define     VECINT_OUTPUT_ENDPOINT7         0x3E


/**
\fn      VOID SetupPacketInterruptHandler(VOID);

\brief   Handle incoming setup packet.

*/
VOID SetupPacketInterruptHandler(VOID);

/**
\fn      VOID PWRVBUSonHandler(VOID);

\brief   Handle VBuss on signal.

*/
VOID PWRVBUSonHandler(VOID);

/**
\fn      VOID PWRVBUSoffHandler(VOID);

\brief   Handle VBuss off signal.

*/
VOID PWRVBUSoffHandler(VOID);

/**
\fn      VOID IEP0InterruptHandler(VOID);

\brief   Handle In-requests from control pipe.

*/
VOID IEP0InterruptHandler(VOID);

/**
\fn      VOID OEP0InterruptHandler(VOID);

\brief   Handle Out-requests from control pipe.

*/
VOID OEP0InterruptHandler(VOID);


#ifdef __cplusplus
}
#endif
#endif /* _USBISR_H_ */
