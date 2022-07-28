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
#include "BSL430_API.h"
#include "BSL430_Command_Definitions.h"

/*******************************************************************************
*  Change Log:
*  2.2.09  LCW   removed RAM erase
*                Changed mass erase and info segments
*  2.2.09  LCW   worked on RAM Loader function
*                Changed Password to XOR
*                Changed Password addr to 0xFFE0
*  --------------------------------------------------------------------------------
*  Version 3 work begins
*  07.08.09 LCW  Removed info erase
*  11.08.09 LCW  bugfix in CRC algorithm
*  --------------------------------------------------------------------------------
*  Version 4 work begins
*  21.12.09 LCW  Removed VPE check
*  15.03.10 LCW  Misc comment cleanup for source release
*  --------------------------------------------------------------------------------
*  Version 4.1 (no output change, source/comment modified)
*  15.04.10 LCW  Changed Version defines to remove warning
*  --------------------------------------------------------------------------------
*  Version 5 work begins
*  18.02.11 LCW  Added USB BSL Buffering for block write
*                disabled GIE at startup
*                uncrustified
*                VPE check removed from word write
*  13.04.11 LCW  Made length varibles unsigned
*  --------------------------------------------------------------------------------
*  Version 6 work begins
*  30.10.12 LCW  Cleared Lock IO on startup
*  --------------------------------------------------------------------------------
*  Version 6.1 (update to align with previous releases)
*  11.03.13 EL  Added definition for LOCKIO
*  --------------------------------------------------------------------------------
*  Version 7
*  08.05.13 EL  reduced zArea Size to make room for USB Bugfix
*  --------------------------------------------------------------------------------
*  Version 8
*  Aug29.13 BEP  Moved __low_level_init to __program_start to free up code space.
*           BEP  Moved RAM clean up to BSL430_API_init since it does not fit in
*                __program_start.
*  Version 9
*  09.05.16 MG   Added exception handling in BSL430_writeMemory for return values
*                from flushBuffer
*******************************************************************************/
#ifdef RAM_BASED_BSL
#    ifdef RAM_WRITE_ONLY_BSL
#        error Can NOT have RAM write and RAM based BSL
#    endif
#    define DEFAULT_STATE (UNLOCKED)
#else
#    define DEFAULT_STATE (LOCKED)
#endif

#ifdef RAM_BASED_BSL
char flushBuffer(void);                   // buffer flush routine, internal for USB only

#pragma data_alignment=2
__no_init unsigned char BlockBuffer[128];
__no_init unsigned long int BlockBufferStart;
__no_init unsigned long int BlockBufferNext;
__no_init unsigned int BlockBufferPtr;
#endif

__no_init volatile unsigned int LockedStatus;
__no_init int FwRamKey;

#define API_VERSION (0x09)
#ifdef RAM_WRITE_ONLY_BSL
#    define API_V (API_VERSION + RAM_WRITE_ONLY_BSL)
#else
#    define API_V API_VERSION
#endif
const unsigned char BSL430_API_Version @ "BSL430_VERSION_API" = API_V;
#pragma required=BSL430_API_Version

/*******************************************************************************
* *Function:    __low_level_init
* *Description: function used to erase the RAM in device and stop WDT
*******************************************************************************/
#ifndef EXCLUDE_LOW_LEVEL_INIT
#if __VER__ <= 420
void
#else
int
#endif
__low_level_init(void)
{
    WDTCTL = WDTPW + WDTHOLD;             // Stop watchdog timer
    __disable_interrupt();                // disable interrupts
#if __VER__ > 420
    return 0;                             // do not initialize
#endif
}
#endif

/*******************************************************************************
* *Function:    BSL430_RAM_Clear
* *Description: Clears the contents of RAM
*******************************************************************************/

void BSL430_API_RAM_Clear()
{
#ifndef RAM_BASED_BSL
    unsigned int *size = (unsigned int *)(__get_SP_register() - SECURE_RAM_START);
    do {
        size[(SECURE_RAM_START >> 1) - 1] = 0;          // Clear RAM contents
        size--;
    } while ((unsigned int)size);
#endif
}

/*******************************************************************************
* *Function:    BSL430_API_init
* *Description: sets the key for writing to flash,  sets device state
*******************************************************************************/

void BSL430_API_init()
{
    LockedStatus = DEFAULT_STATE;
    FwRamKey = FWKEY;
#ifdef CLEAR_LOCKIO
    PMMCTL0_H = PMMPW_H;                  // open PMM registers
    PM5CTL0 &= ~LOCKLPM5;                 // clear lock IO
    PMMCTL0_H = 0x00;                     // close PMM registers
#endif

#ifdef RAM_BASED_BSL
    BlockBufferNext = 0;
    BlockBufferStart = 0;
    BlockBufferPtr = 0;
#endif
}

/*******************************************************************************
* *Function:    BSL430_lock_BSL
* *Description: Locks the BSL
* *Returns:
*             SUCCESSFUL_OPERATION  BSL Locked
*******************************************************************************/

char BSL430_lock_BSL()
{
    LockedStatus = LOCKED;
    return SUCCESSFUL_OPERATION;
}

/*******************************************************************************
* *Function:    BSL430_unlock_BSL
* *Description: Causes the BSL to compare the data buffer against the BSL password
*             BSL state will be UNLOCKED if successful
* *Parameters:
*             char* data            A pointer to an array containing the password
* *Returns:
*             SUCCESSFUL_OPERATION  All data placed into data array successfully
*             BSL_PASSWORD_ERROR    Correct Password was not given
*******************************************************************************/

char BSL430_unlock_BSL(char* data)
{
    int i;
    int retValue = 0;
    char *interrupts = (char*)INTERRUPT_VECTOR_START;

    for (i = 0; i <= (INTERRUPT_VECTOR_END - INTERRUPT_VECTOR_START); i++, interrupts++)
    {
        retValue |=  *interrupts ^ data[i];
    }
    if (retValue == 0)
    {
#ifndef RAM_WRITE_ONLY_BSL
        volatile int i;
        for (i = MASS_ERASE_DELAY - 1; i > 0; i--) ;
#endif
        LockedStatus = UNLOCKED;
        return SUCCESSFUL_OPERATION;
    }
    else
    {
        BSL430_massErase();
        return BSL_PASSWORD_ERROR;
    }
}

/*******************************************************************************
* *Function:    BSL430_toggleInfoLock
* *Description: Toggles the LOCKA bit for writing/erasing info A segment
* *Returns:
*             SUCCESSFUL_OPERATION  Info A is now open for writing or erasing.
*             BSL_LOCKED            Correct Password has not yet been given
*******************************************************************************/

char BSL430_toggleInfoLock()
{
    char exceptions;

    if (LockedStatus == UNLOCKED)
    {
        exceptions = SUCCESSFUL_OPERATION;
        FCTL3 = FwRamKey + LOCKA + (FCTL3 & LOCK); // toggle LOCKA bit
    }
    else
    {
        exceptions = BSL_LOCKED;
    }
    return exceptions;
}

/*******************************************************************************
* *Function:    BSL430_openMemory
* *Description: Unlocks the Flash for writing
* *Returns:
*             SUCCESSFUL_OPERATION  Flash is now open for writing.
*             BSL_LOCKED            Correct Password has not yet been given
*******************************************************************************/

char BSL430_openMemory()
{
    char exceptions = BSL_LOCKED;

    if (LockedStatus == UNLOCKED)
    {
        exceptions = SUCCESSFUL_OPERATION;
#ifndef RAM_BASED_BSL
        FCTL3 = FwRamKey;                 // Clear Lock bit
        FCTL1 = FwRamKey + WRT;           // Set write bit
#endif
    }
    return exceptions;
}

/*******************************************************************************
* *Function:    BSL430_closeMemory
* *Description: Locks the Flash against writing
* *Returns:
*             SUCCESSFUL_OPERATION  Flash is now locked.
*******************************************************************************/

char BSL430_closeMemory(void)
{
    FCTL1 = FwRamKey;                     // Clear WRT bit
    FCTL3 = FwRamKey + LOCK;              // Set LOCK bit

    return SUCCESSFUL_OPERATION;
}

/*******************************************************************************
* *Function:    BSL430_readMemory
* *Description: Reads an array of bytes from memory into a supplied array
* *Parameters:
*             unsigned long addr    The address from which the read should begin
*             char length           The amount of bytes to read
*             char* data            The array into which the data will be saved
* *Returns:
*             SUCCESSFUL_OPERATION  All Data placed into data array successfully
*             BSL_LOCKED            Correct Password has not yet been given
*******************************************************************************/

char BSL430_readMemory(unsigned long addr, unsigned int length, char* data)
{
    unsigned long i;

#ifdef RAM_BASED_BSL
    flushBuffer();
#endif
    char exceptions = SUCCESSFUL_OPERATION;

    for (i = addr + length - 1; i >= addr; i--)
    {
        if (LockedStatus == UNLOCKED)
        {
            data[i - addr] = __data20_read_char(i);
        }
        else
        {
            return BSL_LOCKED;
        }
    }
    return exceptions;
}

/*******************************************************************************
* *Function:    BSL430_crcCheck
* *Description: return a CRC check on the memory specified
* *Parameters:
*           unsigned long addr    The address from which to start the check
*           int length            The length of the data area to check
*           int* return           variable in which to put the return value
* *Returns:
*           SUCCESSFUL_OPERATION  CRC check done correctly
*           BSL_LOCKED            Correct Password has not yet been given
*******************************************************************************/

int BSL430_crcCheck(unsigned long addr, unsigned int length, int* result)
{
    unsigned long i;

#ifdef RAM_BASED_BSL
    flushBuffer();
#endif
    CRCINIRES = 0xFFFF;
    for (i = addr; i < addr + length; i++)
    {
        if (LockedStatus == UNLOCKED)
        {
            CRCDIRB_L = __data20_read_char(i);
        }
        else
        {
            return BSL_LOCKED;
        }
    }
    *result = CRCINIRES;
    return SUCCESSFUL_OPERATION;

}

/*******************************************************************************
* *Function:    BSL430_callAddress
* *Description: Loads the Program Counter with the supplied address
* *Parameters:
*           unsigned long addr    The address to which the function call should go
* *Returns:
*           SUCCESSFUL_OPERATION  Called location has returned
*           BSL_LOCKED            Correct Password has not yet been given
* *Note:
*           If successful, this function does not return.
*******************************************************************************/

char BSL430_callAddress(unsigned long addr)
{
    if (LockedStatus == UNLOCKED)
    {
#ifdef RAM_BASED_BSL
        flushBuffer();
#endif
        ((void (*)())addr)();                                            // type cast addr to
                                                                         // function ptr, call
        return SUCCESSFUL_OPERATION;
    }
    return BSL_LOCKED;                                                   // can only be reached if
                                                                         // BSL is locked

}

/*******************************************************************************
* *Function:    flushBuffer
* *Description: Flushes any remaining data in the buffer
* *Returns:
*             SUCCESSFUL_OPERATION  Flash is now locked.
*******************************************************************************/
#ifdef RAM_BASED_BSL
char flushBuffer(void)
{
    unsigned long i;
    char exceptions = SUCCESSFUL_OPERATION;
    unsigned char* data = &BlockBuffer[0];

    if (LockedStatus == UNLOCKED)
    {
        if (((BlockBufferStart & 0x7F) == 0) && (BlockBufferPtr == 128)) //Buffer is full and
                                                                         // aligned
        {
            while (FCTL3 & BUSY) ;
            FCTL3 = FWKEY;                                               // Clear Lock bit
            FCTL1 = FWKEY + BLKWRT + WRT;                                // Set write/block bit

            for (i = BlockBufferStart; i < BlockBufferStart + 128; i += 4)
            {
                __data20_write_long(i, *((long*)data));
                data += 4;
                while ((FCTL3 & WAIT) == 0) ;
            } // for
        } // if
        else
        {
            FCTL3 = FwRamKey;                                            // Clear Lock bit
            FCTL1 = FwRamKey + WRT;                                      // Set write bit
            for (i = BlockBufferStart; i < BlockBufferStart + BlockBufferPtr; i++)
            {
                if ((BlockBufferStart & 0x01) || i == BlockBufferStart + BlockBufferPtr - 1)
                {
                    exceptions = BSL430_writeByte(i, *data);
                    data += 1;
                }
                else
                {
                    exceptions = BSL430_writeWord(i, *(int *)data);
                    data += 2;
                    i++;
                }
                if (exceptions != SUCCESSFUL_OPERATION)
                {
                    return exceptions;
                } // if
            } // for
        } // else
		// Lock the flash after writing finished
		FCTL1 = FwRamKey;
		while (FCTL3 & BUSY) ;
		FCTL3 = FwRamKey + LOCK;
		
		BlockBufferStart = 0;
        BlockBufferNext = 0;
        BlockBufferPtr = 0;
    }
    else
    {
        exceptions = BSL_LOCKED;
    }
    return exceptions;
}

#endif

/*******************************************************************************
* *Function:    BSL430_writeMemory
* *Description: Writes a byte array starting at a given address.
*             Note: the function will write in word mode if possible
*             (when start address is even)
* *Parameters:
*           unsigned long startAddr        The address to which the write should begin
*           int size                       The number of bytes to write
*           char* data                     The array of bytes to write (must be even aligned)
* *Returns:
*           SUCCESSFUL_OPERATION           Bytes written successfully
*           MEMORY_WRITE_CHECK_FAILED      A byte in data location post-write does not match data
* *parameter
*                                          Note: write stops immediatly after a byte check fails
*           BSL_LOCKED                     Correct Password has not yet been given
*           VOLTAGE_CHANGE_DURING_PROGRAM  Voltage changed during write (of a single byte/word)
*******************************************************************************/

char BSL430_writeMemory(unsigned long startAddr, unsigned int size,  char* data)
{
    unsigned long i;
    char exceptions = SUCCESSFUL_OPERATION;

    // Note: this function compiles quite differently based on whether the
    // BSL is based out of RAM, or not.  RAM based BSLs can use buffering
    // and perform a block long word write.  This is primarily used for
    // USB BSLs for performance increase.
    // Flash based BSLs will use the second second of code, below

#ifdef RAM_BASED_BSL
    if (LockedStatus == UNLOCKED)
    {
        if ((BlockBufferStart == 0) || BlockBufferNext == startAddr)
        {
            // if we are starting, or continuing a block...
            if (BlockBufferStart == 0)
            {
                BlockBufferStart = startAddr;                 // if starting a new block, reset
                                                              // start addr
            }
            BlockBufferNext =  startAddr + size;              // always update the next addr for
                                                              // streaming
            for (i = 0; i < size;)
            {
                BlockBuffer[BlockBufferPtr++] = *data;        // add the incoming data to the buffer
                data++;
                startAddr++;
                i++;                                          // i incrimented here for check below
                if (((startAddr) & 0x7F) == 0x00)             // we've crossed a 128 byte block
                                                              // boundary
                {
                    exceptions = flushBuffer();               // flush out old buffer, writing...
                    if(exceptions != SUCCESSFUL_OPERATION) {
                        return exceptions;
                    }
                    // begin write on block boundary
                    return BSL430_writeMemory(startAddr, (size - i), data);
                } // if
            } // for
        } // if buffer start
        else
        {
            // for when data exists in the buffer, but we are jumping to a new place to write...
            exceptions = flushBuffer();                       // flush out old buffer, writing..
            if(exceptions != SUCCESSFUL_OPERATION) {
                return exceptions;
            }
            return BSL430_writeMemory(startAddr, size, data); // begin buffering new data
        }
    } // if unlocked
    else
    {
        exceptions = BSL_LOCKED;
    }
    // Below is the writeMemory function compiled with Flash based BSLs.
#else
    for (i = startAddr; i < startAddr + size; i++)
    {
#    ifndef RAM_WRITE_ONLY_BSL
        // if the start address is odd, or we're 1 byte from end...
        if ((startAddr & 0x01) || i == startAddr + size - 1)
#    endif
        {
            exceptions = BSL430_writeByte(i, *data);
            data += 1;
        }
#    ifndef RAM_WRITE_ONLY_BSL
        // else, we're on an even addr, and have at least 1 word left..
        else
        {
            exceptions = BSL430_writeWord(i, *(int *)data);
            data += 2;
            i++;
        }
        if (exceptions != SUCCESSFUL_OPERATION)
        {
            return exceptions;
        } // if
#    endif
    }     // for
#endif
    return exceptions;
}

/*******************************************************************************
* *Function:    BSL430_writeByte
* *Description: Writes a byte at a given address
* *Parameters:
*           unsigned long addr             The address to which the byte should be written
*           char data                      The byte to write
* *Returns:
*           SUCCESSFUL_OPERATION           Byte written successfully
*           MEMORY_WRITE_CHECK_FAILED      Byte in data location post-write does not match data
* *parameter
*           VOLTAGE_CHANGE_DURING_PROGRAM  Voltage changed during write
*           BSL_LOCKED                     Correct Password has not yet been given
*******************************************************************************/

char BSL430_writeByte(unsigned long addr, char data)
{
    char exceptions;

    if (LockedStatus == UNLOCKED)
    {
        exceptions = SUCCESSFUL_OPERATION;
#ifdef RAM_BASED_BSL
        while (FCTL3 & BUSY) ;
        SYSBSLC = SYSBSLSIZE0+SYSBSLSIZE1;
#endif
        __data20_write_char(addr, data);
#ifdef RAM_BASED_BSL
        while (FCTL3 & BUSY) ;
#endif
        if (data != __data20_read_char(addr))
        {
            exceptions = MEMORY_WRITE_CHECK_FAILED;
        }
#ifndef RAM_WRITE_ONLY_BSL
#    ifndef DO_NOT_CHECK_VPE
        if (FCTL4 & VPE)
        {
            exceptions = VOLTAGE_CHANGE_DURING_PROGRAM;
        }
#    endif
#endif

#ifdef RAM_BASED_BSL
        SYSBSLC = SYSBSLPE+SYSBSLSIZE0+SYSBSLSIZE1;
#endif    
        
    }
    else
    {
        exceptions = BSL_LOCKED;
    }
    return exceptions;
}

/*******************************************************************************
* *Function:    BSL430_writeWord
* *Description: Writes a word at a given address
* *Parameters:
*           unsigned long addr             The address to which the word should be written
*           int data                       The byte to write
* *Returns:
*           SUCCESSFUL_OPERATION           Word written successfully
*           MEMORY_WRITE_CHECK_FAILED      Word in data location post-write does not match data
* *parameter
*           VOLTAGE_CHANGE_DURING_PROGRAM  Voltage changed during write
*           BSL_LOCKED                     Correct Password has not yet been given
*******************************************************************************/

char BSL430_writeWord(unsigned long addr, int data)
{
    char exceptions;

    if (LockedStatus == UNLOCKED)
    {
        exceptions = SUCCESSFUL_OPERATION;
#ifdef RAM_BASED_BSL
        while (FCTL3 & BUSY) ;
        SYSBSLC = SYSBSLSIZE0+SYSBSLSIZE1;          
#endif
        __data20_write_short(addr, data);
#ifdef RAM_BASED_BSL
        while (FCTL3 & BUSY) ;
#endif
        if (data != __data20_read_short(addr))
        {
            exceptions = MEMORY_WRITE_CHECK_FAILED;
        }
#ifndef DO_NOT_CHECK_VPE
        if (FCTL4 & VPE)
        {
            exceptions = VOLTAGE_CHANGE_DURING_PROGRAM;
        }
#endif

#ifdef RAM_BASED_BSL
        SYSBSLC = SYSBSLPE+SYSBSLSIZE0+SYSBSLSIZE1;
#endif   
    }
    else
    {
        exceptions = BSL_LOCKED;
    }
    return exceptions;
}

/*******************************************************************************
* *Function:    BSL430_eraseLocation
* *Description: Erases a memory segment which contains a given address
* *Parameters:
*           char block_erase               currently unused 1: erase block 0: erase segment
*           unsigned long addr             An address which is within the segment to be erased
* *Returns:
*           SUCCESSFUL_OPERATION           Segment erased
*           BSL_LOCKED                     Correct Password has not yet been given
*******************************************************************************/

char BSL430_eraseLocation(char block_erase, unsigned long addr)
{
    char exceptions;

    if (LockedStatus == UNLOCKED)
    {
        exceptions = SUCCESSFUL_OPERATION;
#ifdef RAM_BASED_BSL
        while (FCTL3 & BUSY) ;
#endif
        FCTL3 = FwRamKey;                       // Clear Lock bit
        FCTL1 = FwRamKey + ERASE;               // Set Erase bit
        __data20_write_char(addr, 0);           // Dummy write to erase Flash seg
#ifdef RAM_BASED_BSL
        while (FCTL3 & BUSY) ;
#endif
        FCTL3 = FwRamKey + LOCK;                // Set LOCK bit
    }
    else
    {
        exceptions = BSL_LOCKED;
    }
    return exceptions;
}

/*******************************************************************************
* *Function:    BSL430_massErase
* *Description: Mass erases the entire MSP430 device
* *Returns:
*           SUCCESSFUL_OPERATION           Flash erased
*           BSL_LOCKED                     Correct Password has not yet been given
*******************************************************************************/

char BSL430_massErase()
{
    char exceptions = SUCCESSFUL_OPERATION;
    volatile char *Flash_ptr;                   // Flash pointer

#ifdef RAM_BASED_BSL
    while (FCTL3 & BUSY) ;
#endif
    FCTL3 = FwRamKey;
#ifdef RAM_BASED_BSL
    while (FCTL3 & BUSY) ;
#endif
    Flash_ptr = (char *)INTERRUPT_VECTOR_START; // Initialize Flash pointer
    FCTL1 = FwRamKey + MERAS + ERASE;           // Set Mass Erase bit
    *Flash_ptr = 0;                             // Dummy write to erase main flash
#ifdef RAM_BASED_BSL
    while (FCTL3 & BUSY) ;
#endif
    FCTL3 = FwRamKey + LOCK;                    // Set LOCK bit

    return exceptions;
}