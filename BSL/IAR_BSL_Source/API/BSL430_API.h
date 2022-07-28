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
#ifndef BSL_430_API_H
#define BSL_430_API_H

#define LOCKED 0x00
#define UNLOCKED 0xA5A5

// flags for mass erase call
#define MAIN_ONLY    0x00  // normal
#define ERASE_RAM    0x01  // unused in default
#define ERASE_INFO   0x02  //

// Version definitions
#define FRAM_MEMORY 0x30

/*******************************************************************************
* *Function:    BSL430_API_RAM_Clear
* *Description: Clears the contents of RAM
*******************************************************************************/
void BSL430_API_RAM_Clear();

/*******************************************************************************
* *Function:    BSL430_API_init
* *Description: sets the key for writing to flash,  sets device state
*******************************************************************************/
void BSL430_API_init();

/*******************************************************************************
* *Function:    BSL430_lock_BSL
* *Description: Locks the BSL
* *Returns:
*             SUCCESSFUL_OPERATION  BSL Locked
*******************************************************************************/
char BSL430_lock_BSL();

/*******************************************************************************
* *Function:    BSL430_unlock_BSL
* *Description: Causes the BSL to compare the data buffer against the BSL password
*             BSL state will be UNLOCKED if successful
*******************************Parameters:
*             char* data            A pointer to an array containing the password
*******************************Returns:
*             SUCCESSFUL_OPERATION  All data placed into data array successfully
*             BSL_PASSWORD_ERROR    Correct Password was not given
*******************************************************************************/
char BSL430_unlock_BSL(char* data);

/*******************************************************************************
* *Function:    BSL430_toggleInfoLock
* *Description: Toggles the LOCKA bit for writing/erasing info A segment
* *Returns:
*             SUCCESSFUL_OPERATION  Info A is now open for writing or erasing.
*             BSL_LOCKED            Correct Password has not yet been given
*******************************************************************************/
char BSL430_toggleInfoLock(void);

/*******************************************************************************
* *Function:    BSL430_openMemory
* *Description: Unlocks the Flash for writing
* *Returns:
*             SUCCESSFUL_OPERATION  Flash is now open for writing.
*             BSL_LOCKED            Correct Password has not yet been given
*******************************************************************************/
char BSL430_openMemory(void);

/*******************************************************************************
* *Function:    BSL430_closeMemory
* *Description: Locks the Flash against writing
* *Returns:
*             SUCCESSFUL_OPERATION  Flash is now locked.
*******************************************************************************/
char BSL430_closeMemory(void);

/*******************************************************************************
* *Function:    BSL430_readMemory
* *Description: Reads an array of bytes from memory into a supplied array
* *Parameters:
*             unsigned long addr    The address from which the read should begin
*             char length           The amount of bytes to read
*             char* data            The array into which the data will be saved
*******************************Returns:
*             SUCCESSFUL_OPERATION  All Data placed into data array successfully
*             BSL_LOCKED            Correct Password has not yet been given
*******************************************************************************/
char BSL430_readMemory(unsigned long addr, unsigned int length, char* data);

/*******************************************************************************
* *Function:    BSL430_crcCheck
* *Description: return a CRC check on the memory specified
* *Parameters:
*           unsigned long addr    The address from which to start the check
*           int length            The length of the data area to check
*           int* return           variable in which to put the return value
*******************************Returns:
*           SUCCESSFUL_OPERATION  CRC check done correctly
*           BSL_LOCKED            Correct Password has not yet been given
*******************************************************************************/
int BSL430_crcCheck(unsigned long addr, unsigned int length, int* result);

/*******************************************************************************
* *Function:    BSL430_callAddress
* *Description: Loads the Program Counter with the supplied address
* *Parameters:
*           unsigned long addr    The address to which the function call should go
*******************************Returns:
*           SUCCESSFUL_OPERATION  Called location has returned
*           BSL_LOCKED            Correct Password has not yet been given
*******************************Note:
*           If successful, this function does not return.
*******************************************************************************/
char BSL430_callAddress(unsigned long addr);

/*******************************************************************************
* *Function:    BSL430_writeMemory
* *Description: Writes a byte array starting at a given address.
*             Note: the function will write in word mode if possible
*             (when start address is even)
*******************************Parameters:
*           unsigned long startAddr        The address to which the write should begin
*           int size                       The number of bytes to write
*           char* data                     The array of bytes to write (must be even aligned)
*******************************Returns:
*           SUCCESSFUL_OPERATION           Bytes written successfully
*           MEMORY_WRITE_CHECK_FAILED      A byte in data location post-write does not match data
*******************************parameter
*                                          Note: write stops immediatly after a byte check fails
*           BSL_LOCKED                     Correct Password has not yet been given
*           VOLTAGE_CHANGE_DURING_PROGRAM  Voltage changed during write (of a single byte/word)
*******************************************************************************/
char BSL430_writeMemory(unsigned long startAddr, unsigned int size,  char* data);

/*******************************************************************************
* *Function:    BSL430_writeByte
* *Description: Writes a byte at a given address
* *Parameters:
*           unsigned long addr             The address to which the byte should be written
*           char data                      The byte to write
*******************************Returns:
*           SUCCESSFUL_OPERATION           Byte written successfully
*           MEMORY_WRITE_CHECK_FAILED      Byte in data location post-write does not match data
*******************************parameter
*           VOLTAGE_CHANGE_DURING_PROGRAM  Voltage changed during write
*           BSL_LOCKED                     Correct Password has not yet been given
*******************************************************************************/
char BSL430_writeByte(unsigned long addr, char data);

/*******************************************************************************
* *Function:    BSL430_writeWord
* *Description: Writes a word at a given address
* *Parameters:
*           unsigned long addr             The address to which the word should be written
*           int data                       The byte to write
*******************************Returns:
*           SUCCESSFUL_OPERATION           Word written successfully
*           MEMORY_WRITE_CHECK_FAILED      Word in data location post-write does not match data
*******************************parameter
*           VOLTAGE_CHANGE_DURING_PROGRAM  Voltage changed during write
*           BSL_LOCKED                     Correct Password has not yet been given
*******************************************************************************/
char BSL430_writeWord(unsigned long addr, int data);

/*******************************************************************************
* *Function:    BSL430_eraseLocation
* *Description: Erases a memory segment which contains a given address
* *Parameters:
*           char block_erase               currently unused 1: erase block 0: erase segment
*           unsigned long addr             An address which is within the segment to be erased
*******************************Returns:
*           SUCCESSFUL_OPERATION           Segment erased
*           BSL_LOCKED                     Correct Password has not yet been given
*******************************************************************************/
char BSL430_eraseLocation(char block_erase, unsigned long addr);

/*******************************************************************************
* *Function:    BSL430_massErase
* *Description: Mass erases the entire MSP430 device
* *Returns:
*           SUCCESSFUL_OPERATION           Flash erased
*           BSL_LOCKED                     Correct Password has not yet been given
*******************************************************************************/
char BSL430_massErase();

/*******************************************************************************
*Function:    BSL430_timeoutInit
*Description: Initializes the timer for timeout
*Parameters:
*Returns:
*             SUCCESSFUL_OPERATION      Timer initialized
*******************************************************************************/
char BSL430_timeoutInit();

/*******************************************************************************
*Function:    BSL430_timeoutStop
*Description: Halts the timer used for timeout
*Parameters:
*Returns:
*             SUCCESSFUL_OPERATION      Timer halted
*******************************************************************************/
char BSL430_timeoutStop();

/*******************************************************************************
*Function:    BSL430_timeoutGetCount
*Description: Stores the timer counter value at given address.
*Parameters:
*             unsigned int* result      Variable that stores the timer count
*Returns:
*             SUCCESSFUL_OPERATION      Timer count returned
*******************************************************************************/
char BSL430_timeoutGetCount(unsigned int* result);

/*******************************************************************************
*Function:    BSL430_timeoutTimedOut
*Description: Checks if the timer period expired
*Parameters:
*Returns:
*             SUCCESSFUL_OPERATION      Timed out
*             !SUCCESSFUL_OPERATION     Not timed out
*******************************************************************************/
char BSL430_timeoutTimedOut();

/*******************************************************************************
*Function:    BSL430_sleep
*Description: Stops BSL execution by going to sleep mode
*Parameters:
*Returns:
*             Function should not return.
*******************************************************************************/
char BSL430_sleep();

#endif
