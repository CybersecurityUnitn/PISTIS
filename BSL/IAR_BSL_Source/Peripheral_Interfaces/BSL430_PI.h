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
 
#ifndef BSL_PI_H
#define BSL_PI_H

#define PI_STATE_UART  0x00
#define PI_STATE_I2C   0x01
#define BSL_TLV_TAG    0x1C

#define RX_PACKET_ONGOING     0x00
#define DATA_RECEIVED         BIT0
#define RX_ERROR_RECOVERABLE  BIT1
#define RX_ERROR_REINIT       BIT2
#define RX_ERROR_FATAL        BIT3
#define PI_DATA_RECEIVED      BIT4

#define PI_COMMAND_UPPER 0x50

//PI version Signifiers
#define BSL430_TIMER_A_PI   0x00
#define BSL430_USB_PI       0x30
#define BSL430_USCIA_PI     0x50
#define BSL430_eUSCIA_PI    0x70
#define BSL430_USCIB_I2C_PI 0x090
#define BSL430_eUSCIB_I2C_PI 0x0A0
#define BSL430_eUSCI_I2C_UART_PI 0xB0
/*******************************************************************************
* *Function:    init
* *Description: Initialize the peripheral and ports to begin TX/RX
*******************************************************************************/
void PI_init();

/*******************************************************************************
* *Function:    PI_init_passive
* *Description: Initializes UART and I2C for passive listening
* *Returns:     None
*******************************************************************************/
void PI_init_passive();

/*******************************************************************************
* *Function:    PI_init_active
* *Description: Initializes UART and I2C from passive to normal operation
* *Parameters:  The peripheral to be activated
* *Returns:     None
*******************************************************************************/
void PI_init_active(unsigned char PI_Mode);

/*******************************************************************************
* *Function:    PI_receivePacket
* *Description: Reads an entire packet, verifies it, and sends it to the core to be interpreted
* *Returns:
*             DATA_RECEIVED         A packet has been received and can be processed
*             RX_ERROR_RECOVERABLE  An error has occured, the function can be called again to
*                                   receive a new packet
*******************************************************************************/
char PI_receivePacket();

/*******************************************************************************
* *Function:    PI_sendData
* *Description: Sends the data in the data buffer
* *Parameters:
*             int bufSize - the number of bytes to send
*******************************************************************************/
void PI_sendData(int bufSize);

/*******************************************************************************
* *Function:    PI_getBufferSize
* *Description: Returns the max Data Buffer Size for this PI
* *Returns:     max buffer size
*******************************************************************************/
int PI_getBufferSize();

#endif
