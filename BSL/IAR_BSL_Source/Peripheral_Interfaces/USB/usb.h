
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
|  Source: Usb.h, v1.1 2009/06/29                                             |
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
+----------------------------------------------------------------------------*/


#ifndef _USB_H_
#define _USB_H_

#ifdef __cplusplus
extern "C"
{
#endif

#include "types.h"
#include "device.h"

/*----------------------------------------------------------------------------+
| Constant Definition                                                         |
+----------------------------------------------------------------------------*/
#define USB_RETURN_DATA_LENGTH 8
#define SIZEOF_DEVICE_REQUEST   0x08

//  Bit definitions for DEVICE_REQUEST.bmRequestType
//  Bit 7:   Data direction
#define USB_REQ_TYPE_OUTPUT     0x00    // 0 = Host sending data to device
#define USB_REQ_TYPE_INPUT      0x80    // 1 = Device sending data to host

//  Bit 6-5: Type
#define USB_REQ_TYPE_MASK       0x60    // Mask value for bits 6-5
#define USB_REQ_TYPE_STANDARD   0x00    // 00 = Standard USB request
#define USB_REQ_TYPE_CLASS      0x20    // 01 = Class specific
#define USB_REQ_TYPE_VENDOR     0x40    // 10 = Vendor specific

//  Bit 4-0: Recipient
#define USB_REQ_TYPE_RECIP_MASK 0x1F    // Mask value for bits 4-0
#define USB_REQ_TYPE_DEVICE     0x00    // 00000 = Device
#define USB_REQ_TYPE_INTERFACE  0x01    // 00001 = Interface
#define USB_REQ_TYPE_ENDPOINT   0x02    // 00010 = Endpoint
#define USB_REQ_TYPE_OTHER      0x03    // 00011 = Other

//  Values for DEVICE_REQUEST.bRequest
// Standard Device Requests
#define USB_REQ_GET_STATUS              0
#define USB_REQ_CLEAR_FEATURE           1
#define USB_REQ_SET_FEATURE             3
#define USB_REQ_SET_ADDRESS             5
#define USB_REQ_GET_DESCRIPTOR          6
#define USB_REQ_SET_DESCRIPTOR          7
#define USB_REQ_GET_CONFIGURATION       8
#define USB_REQ_SET_CONFIGURATION       9
#define USB_REQ_GET_INTERFACE           10
#define USB_REQ_SET_INTERFACE           11
#define USB_REQ_SYNCH_FRAME             12

// CDC CLASS Requests
#define USB_CDC_GET_LINE_CODING         0x21
#define USB_CDC_SET_LINE_CODING         0x20
#define USB_CDC_SET_CONTROL_LINE_STATE  0x22

// HID CLASS Requests
#define USB_HID_REQ                     0x81
#define USB_REQ_GET_REPORT		0x01
#define USB_REQ_GET_IDLE		0x02
#define USB_REQ_SET_REPORT		0x09
#define USB_REQ_SET_IDLE		0x0A
#define USB_REQ_SET_PROTOCOL            0x0B
#define USB_REQ_GET_PROTOCOL            0x03

//HID Values for HID Report Types (tSetup.bValueH)
#define USB_REQ_HID_INPUT               0x01
#define USB_REQ_HID_OUTPUT              0x02
#define USB_REQ_HID_FEATURE             0x03

//  Descriptor Type Values
#define DESC_TYPE_DEVICE                1       // Device Descriptor (Type 1)
#define DESC_TYPE_CONFIG                2       // Configuration Descriptor (Type 2)
#define DESC_TYPE_STRING                3       // String Descriptor (Type 3)
#define DESC_TYPE_INTERFACE             4       // Interface Descriptor (Type 4)
#define DESC_TYPE_ENDPOINT              5       // Endpoint Descriptor (Type 5)
#define DESC_TYPE_DEVICE_QUALIFIER      6       // Endpoint Descriptor (Type 6)
#define DESC_TYPE_HUB                   0x29    // Hub Descriptor (Type 6)
#define DESC_TYPE_HID			0x21    // HID Descriptor
#define DESC_TYPE_REPORT		0x22    // Report Descriptor
#define DESC_TYPE_PHYSICAL		0x23	// Physical Descriptor

//  Feature Selector Values
#define FEATURE_REMOTE_WAKEUP           1       // Remote wakeup (Type 1)
#define FEATURE_ENDPOINT_STALL          0       // Endpoint stall (Type 0)

// Device Status Values
#define DEVICE_STATUS_REMOTE_WAKEUP     0x02
#define DEVICE_STATUS_SELF_POWER        0x01

//  Maximum descriptor size
#define MAX_DESC_SIZE                   256

//  DEVICE_DESCRIPTOR structure
#define SIZEOF_DEVICE_DESCRIPTOR        0x12
#define OFFSET_DEVICE_DESCRIPTOR_VID_L  0x08
#define OFFSET_DEVICE_DESCRIPTOR_VID_H  0x09
#define OFFSET_DEVICE_DESCRIPTOR_PID_L  0x0A
#define OFFSET_DEVICE_DESCRIPTOR_PID_H  0x0B
#define OFFSET_CONFIG_DESCRIPTOR_POWER  0x07
#define OFFSET_CONFIG_DESCRIPTOR_CURT   0x08

//  CONFIG_DESCRIPTOR structure
#define SIZEOF_CONFIG_DESCRIPTOR 0x09

//  HID DESCRIPTOR structure
#define SIZEOF_HID_DESCRIPTOR 0x09

//  Bit definitions for CONFIG_DESCRIPTOR.bmAttributes
#define CFG_DESC_ATTR_SELF_POWERED  0x40    // Bit 6: If set, device is self powered
#define CFG_DESC_ATTR_BUS_POWERED   0x80    // Bit 7: If set, device is bus powered
#define CFG_DESC_ATTR_REMOTE_WAKE   0x20    // Bit 5: If set, device supports remote wakeup

//  INTERFACE_DESCRIPTOR structure
#define SIZEOF_INTERFACE_DESCRIPTOR 0x09

//  ENDPOINT_DESCRIPTOR structure
#define SIZEOF_ENDPOINT_DESCRIPTOR 0x07

//  Bit definitions for EndpointDescriptor.EndpointAddr
#define EP_DESC_ADDR_EP_NUM     0x0F    // Bit 3-0: Endpoint number
#define EP_DESC_ADDR_DIR_IN     0x80    // Bit 7: Direction of endpoint, 1/0 = In/Out

//  Bit definitions for EndpointDescriptor.EndpointFlags
#define EP_DESC_ATTR_TYPE_MASK  0x03    // Mask value for bits 1-0
#define EP_DESC_ATTR_TYPE_CONT  0x00    // Bit 1-0: 00 = Endpoint does control transfers
#define EP_DESC_ATTR_TYPE_ISOC  0x01    // Bit 1-0: 01 = Endpoint does isochronous transfers
#define EP_DESC_ATTR_TYPE_BULK  0x02    // Bit 1-0: 10 = Endpoint does bulk transfers
#define EP_DESC_ATTR_TYPE_INT   0x03    // Bit 1-0: 11 = Endpoint does interrupt transfers


extern __no_init tDEVICE_REQUEST tSetupPacket;
/*extern __no_init tEDB0 tEndPoint0DescriptorBlock;
extern __no_init tEDB* tInputEndPointDescriptorBlock;
extern __no_init tEDB* tOutputEndPointDescriptorBlock;*/
extern __no_init BYTE abIEP0Buffer[];
extern __no_init BYTE abOEP0Buffer[];
extern __no_init BYTE pbXBufferAddressEp1[];
extern __no_init BYTE pbYBufferAddressEp1[];
extern __no_init BYTE pbXBufferAddressEp81[];
extern __no_init BYTE pbYBufferAddressEp81[];
extern __no_init BYTE pbXBufferAddressEp2[];
extern __no_init BYTE pbYBufferAddressEp2[];
extern __no_init BYTE pbXBufferAddressEp82[];
extern __no_init BYTE pbYBufferAddressEp82[];

extern __no_init BYTE wBytesRemainingOnIEP0;

extern __no_init BYTE abUsbRequestReturnData[];
extern __no_init BYTE abUsbRequestIncomingData[];
extern __no_init BYTE bEnumerationStatus;


extern __no_init WORD wUSBPLL;          // clock settings for PLL

/**
\fn      VOID Init_USB(VOID);

\brief   Init the USB HW interface.

*/
VOID USB_init(VOID);

/**
\fn      VOID USB_Enable(WORD freq);

\brief   Init and start the USB PLL.

*/
VOID USB_enable();

/**
\fn      VOID Reset_USB(VOID);

\brief   Reset USB-SIE and global variables.

*/
VOID USB_reset(VOID);

/**
\fn      VOID Suspend_USB(VOID);

\brief   Suspend USB.

*/
VOID USB_suspend(VOID);

/**
\fn      VOID Resume_USB(VOID);

\brief   Resume USB.

*/
VOID USB_resume(VOID);

/**
\fn      VOID usbStallEndpoint0(VOID);

\brief   Send stall handshake for in- and out-endpoint0 (control pipe)

*/
VOID usbStallEndpoint0(VOID);

/**
\fn      VOID usbClearOEP0ByteCount(VOID);

\brief   Clear byte counter for endpoint0 (control pipe)

*/
VOID usbClearOEP0ByteCount(VOID);

/**
\fn      VOID usbStallOEP0(VOID);

\brief   Send stall handshake for out-endpoint0 (control pipe)

*/
VOID usbStallOEP0(VOID);

/**
\fn      VOID usbSendNextPacketOnIEP0(VOID);

\brief   Send further data over control pipe if needed.
\n       Function is called from control-in IRQ. Do not call from user application

*/
VOID usbSendNextPacketOnIEP0(VOID);

/**
\fn      VOID usbSendDataPacketOnEP0(PBYTE pbBuffer);

\brief   Send data over control pipe to host.
\n       Number of bytes to transmit should be set with
\n       global varible "wBytesRemainingOnIEP0" before function is called.

*/
VOID usbSendDataPacketOnEP0(PBYTE pbBuffer);

/**
\fn      VOID usbReceiveNextPacketOnOEP0(VOID);

\brief   Receive further data from control pipe if needed.
\n       Function is called from control-out IRQ. Do not call from user application

*/
VOID usbReceiveNextPacketOnOEP0(VOID);

/**
\fn      VOID usbReceiveDataPacketOnEP0(PBYTE pbBuffer);

\brief   Receive data from control pipe.
\n       Number of bytes to receive should be set with
\n       global varible "wBytesRemainingOnOEP0" before function is called.

*/
VOID usbReceiveDataPacketOnEP0(PBYTE pbBuffer);

/**
\fn      VOID usbSendZeroLengthPacketOnIEP0(VOID);

\brief   Send zero length packet on control pipe.

*/
VOID usbSendZeroLengthPacketOnIEP0(VOID);

/**
\fn      VOID usbDecodeAndProcessUsbRequest(VOID);

\brief   Decode incoming usb setup packet and call corresponding function
\n       usbDecodeAndProcessUsbRequest is called from IRQ. Do not call from user application

*/
VOID usbDecodeAndProcessUsbRequest(VOID);


#define ENUMERATION_COMPLETE 0x01

/*----------------------------------------------------------------------------+
| End of header file                                                          |
+----------------------------------------------------------------------------*/
#ifdef __cplusplus
}
#endif
#endif /* _USB_H */
/*------------------------ Nothing Below This Line --------------------------*/

