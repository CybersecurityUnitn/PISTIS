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
|                          MSP430 USB-Example                                 |
|                                                                             |
+-----------------------------------------------------------------------------+
|  Source: descriptor.h, v1.1 2009/06/29                                      |
|  Author: Rostyslav Stolyar                                                  |
|                                                                             |
|  WHO          WHEN         WHAT                                             |
|  ---          ----------   ------------------------------------------------ |
|  R.Stolyar    2008/09/03   born                                             |
|  R.Stolyar    2009/06/24   Change to _tiny version                          |
+----------------------------------------------------------------------------*/

// device descriptor structure
typedef struct _tDEVICE_DESCRIPTOR
{
    BYTE    bLength;                // Length of this descriptor (12h bytes)
    BYTE    bDescriptorType;        // Type code of this descriptor (01h)
    WORD    bcdUsb;                 // Release of USB spec (0210h = rev 2.10)
    BYTE    bDeviceClass;           // Device's base class code
    BYTE    bDeviceSubClass;        // Device's sub class code
    BYTE    bDeviceProtocol;        // Device's protocol type code
    BYTE    bMaxPacketSize0;        // End point 0's max packet size (8/16/32/64)
    WORD    wIdVendor;              // Vendor ID for device
    WORD    wIdProduct;             // Product ID for device
    WORD    wBcdDevice;             // Revision level of device
    BYTE    wManufacturer;          // Index of manufacturer name string desc
    BYTE    wProduct;               // Index of product name string desc
    BYTE    wSerialNumber;          // Index of serial number string desc
    BYTE    bNumConfigurations;     // Number of configurations supported
} tDEVICE_DESCRIPTOR, *ptDEVICE_DESCRIPTOR;

// configuration descriptor structure
typedef struct _tCONFIG_DESCRIPTOR
{
    BYTE    bLength;                // Length of this descriptor (9h bytes)
    BYTE    bDescriptorType;        // Type code of this descriptor (02h)
    WORD    wTotalLength;           // Size of this config desc plus all interface,
                                    // endpoint, class, and vendor descriptors
    BYTE    bNumInterfaces;         // Number of interfaces in this config
    BYTE    bConfigurationValue;    // Value to use in SetConfiguration command
    BYTE    bConfiguration;         // Index of string desc describing this config
    BYTE    bAttributes;            // See CFG_DESC_ATTR_xxx values below
    BYTE    bMaxPower;              // Power used by this config in 2mA units
} tCONFIG_DESCRIPTOR, *ptCONFIG_DESCRIPTOR;

// interface descriptor structure
typedef struct _tINTERFACE_DESCRIPTOR
{
    BYTE    bLength;                // Length of this descriptor (9h bytes)
    BYTE    bDescriptorType;        // Type code of this descriptor (04h)
    BYTE    bInterfaceNumber;       // Zero based index of interface in the configuration
    BYTE    bAlternateSetting;      // Alternate setting number of this interface
    BYTE    bNumEndpoints;          // Number of endpoints in this interface
    BYTE    bInterfaceClass;        // Interface's base class code
    BYTE    bInterfaceSubClass;     // Interface's sub class code
    BYTE    bInterfaceProtocol;     // Interface's protocol type code
    BYTE    bInterface;             // Index of string desc describing this interface
} tINTERFACE_DESCRIPTOR, *ptINTERFACE_DESCRIPTOR;

// endpoint descriptor structure
typedef struct _tENDPOINT_DESCRIPTOR
{
    BYTE    bLength;                // Length of this descriptor (7h bytes)
    BYTE    bDescriptorType;        // Type code of this descriptor (05h)
    BYTE    bEndpointAddress;       // See EP_DESC_ADDR_xxx values below
    BYTE    bAttributes;            // See EP_DESC_ATTR_xxx value below
    WORD    wMaxPacketSize;         // Max packet size of endpoint
    BYTE    bInterval;              // Polling interval of endpoint in milliseconds
} tENDPOINT_DESCRIPTOR, *tpENDPOINT_DESCRIPTOR;
