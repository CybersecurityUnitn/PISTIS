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
|                             USB-Example (CDC Driver)                        |
|                                                                             |
+-----------------------------------------------------------------------------+
|  Source: Descriptors.c, v1.1 2009/06/29                                     |
|  Author: Rostyslav Stolyar                                                  |
|                                                                             |
|  Release Notes:                                                             |
|  Logs:                                                                      |
|                                                                             |
|  WHO          WHEN         WHAT                                             |
|  ---          ----------   ------------------------------------------------ |
|  R.Stolyar    2008/09/03   born                                             |
|  R.Stolyar    2008/12/23   enhancements of CDC API                          |
|  R.Stolyar    2009/01/12   enhancements for USB serial number               |
|  R.Stolyar    2009/04/20   Change version number to v1.0                    |
|  R.Stolyar    2009/06/24   Change to _tiny version                          |
+----------------------------------------------------------------------------*/

/*----------------------------------------------------------------------------+
| Include files                                                               |
+----------------------------------------------------------------------------*/

#include "device.h"
#include "defUSB.h"
#include "types.h"      // Basic Type declarations
#include "usb.h"        // USB-specific Data Structures
#include "descriptors.h"
#include "Proj_Settings.h"

/*----------------------------------------------------------------------------+
| Internal Type Definition & Macro                                            |
+----------------------------------------------------------------------------*/

#ifndef RAM_BASED_BSL
#ifdef SMALL_ZAREA
BYTE const abromDeviceDescriptor[SIZEOF_DEVICE_DESCRIPTOR] @ 0x1074 = {
#else
BYTE const abromDeviceDescriptor[SIZEOF_DEVICE_DESCRIPTOR] @ 0x107C = {
#endif
#endif
#ifdef RAM_BASED_BSL
BYTE const abromDeviceDescriptor[SIZEOF_DEVICE_DESCRIPTOR] @ 0x2516 = {
#endif
    SIZEOF_DEVICE_DESCRIPTOR,       // Length of this descriptor (12h bytes)
    DESC_TYPE_DEVICE,               // Type code of this descriptor (01h)
    0x00,0x02,                      // Release of USB spec (Rev 2.0)
    0x00,                           // Device's base class code
    0,                              // Device's sub class code
    0,                              // Device's protocol type code
    EP0_PACKET_SIZE,                // End point 0's packet size = 8
    USB_VID&0xFF, USB_VID>>8,       // Vendor ID for device, TI=0x0451
                                    //      this is Texas Instruments VID
                                    //      you can use is only in this example.
                                    //      You can order your own VID at www.usb.org
    USB_PID&0xFF, USB_PID>>8,       // Product ID for device,
                                    //      this ID is to only with this example
    VER_FW_L, VER_FW_H,             // Revision level of device, Rev=1.00
    0,// 1,                              // Index of manufacturer name string desc
    0,// 2,                              // Index of product name string desc
    0,                              // No serial number for this device
    1                               // Number of configurations supported
};



BYTE const abromReportDescriptor[SIZEOF_REPORT_DESCRIPTOR]=
//BYTE const abromReportDescriptor[]=
{
    0x06, 0x00, 0xff,              // USAGE_PAGE (Vendor Defined Page 1)
    0x09, 0x01,                    // USAGE (Vendor Usage 1)
    0xa1, 0x01,                    // COLLECTION (Application)

    0x85, 0x3F,                    //   Report ID
    0x95, 0x3F,                    //   REPORT_COUNT ()
    0x75, 0x08,                    //   REPORT_SIZE (8)
    0x25, 0x01,
    0x15, 0x01,
    0x09, 0x01,                    //   USAGE (Vendor Usage 1)
    0x81, 0x02,                    //   INPUT (Data,Var,Abs)

  //---------------------------------------------------------------------------
    0x85, 0x3F,                    //   Report ID
    0x95, 0x3F,                    //   REPORT_COUNT ()
    0x75, 0x08,                    //   REPORT_SIZE (8)
    0x25, 0x01,
    0x15, 0x01,
    0x09, 0x01,                    //   USAGE (Vendor Usage 1)
    0x91, 0x02,                    //   OUTPUT (Data,Var,Abs)

    0xC0                           //   end Application Collection
};

//#define SIZEOF_REPORT_DESCRIPTOR1 sizeof(abromReportDescriptor)

BYTE const abromConfigurationDescriptorGroup[wTotalLength] =
{
    // CONFIGURATION DESCRIPTOR (9 bytes)
    SIZEOF_CONFIG_DESCRIPTOR,       // bLength
    DESC_TYPE_CONFIG,               // bDescriptorType: 2
    wTotalLength,0x00,              // wTotalLength
    USB_NUM_CONFIGURATIONS,         // bNumInterfaces
    0x01,                           // bConfigurationValue
    0x00,                           // iConfiguration Description offset
    USB_SUPPORT_BUS_POWERED | USB_SUPPORT_REM_WAKE,  // bmAttributes, bus power, remote wakeup
    0x32,                           // Max. Power Consumption at 2mA unit

    //-------- Descriptor for HID class device -------------------------------------
    // INTERFACE DESCRIPTOR (9 bytes)
    SIZEOF_INTERFACE_DESCRIPTOR,    // bLength
    DESC_TYPE_INTERFACE,            // bDescriptorType: 4
    bInterfaceNumberHid,            // bInterfaceNumber
    0x00,                           // bAlternateSetting
    2,//2,                              // bNumEndpoints
    0x03,                           // bInterfaceClass: 3 = HID Device
    0,                              // bInterfaceSubClass:
    0,                              // bInterfaceProtocol:
    0,//4,                              // iInterface:1


    // HID DESCRIPTOR (9 bytes)
    0x09,     			    // bLength of HID descriptor
    0x21,             		    // HID Descriptor Type: 0x21
    0x01,0x01,			    // HID Revision number 1.01
    0x00,			    // Target country, nothing specified (00h)
    0x01,//1			    // Number of HID classes to follow
    0x22,			    // bDescriptorType, Report descriptor type
    (SIZEOF_REPORT_DESCRIPTOR& 0x0ff),  // Total length of report descriptor
    (SIZEOF_REPORT_DESCRIPTOR >>8),


    // ENDPOINT #81 INPUT DESCRIPTOR, (7 bytes)
    SIZEOF_ENDPOINT_DESCRIPTOR,     // bLength
    DESC_TYPE_ENDPOINT,             // bDescriptorType
    0x81,  //0x81                         // bEndpointAddress; bit7=1 for IN, bits 3-0=1 for ep1
    EP_DESC_ATTR_TYPE_INT,          // bmAttributes, interrupt transfers
    0x40, 0x00, //0x40, 0x00,                     // wMaxPacketSize, 8 bytes
    0x1, //1                           // bInterval
    

    // ENDPOINT #1 OUTPUT DESCRIPTOR, (7 bytes)
    SIZEOF_ENDPOINT_DESCRIPTOR,     // bLength
    DESC_TYPE_ENDPOINT,             // bDescriptorType
    0x01,                           // bEndpointAddress; bit7=1 for IN, bits 3-0=1 for ep1
    EP_DESC_ATTR_TYPE_INT,          // bmAttributes, interrupt transfers
    0x40, 0x00, //0x40, 0x00,                     // wMaxPacketSize, 8 bytes
    0x1,   //1                        // bInterval
    
};


/*----------------------------------------------------------------------------+
| End of source file                                                          |
+----------------------------------------------------------------------------*/
/*------------------------ Nothing Below This Line --------------------------*/
