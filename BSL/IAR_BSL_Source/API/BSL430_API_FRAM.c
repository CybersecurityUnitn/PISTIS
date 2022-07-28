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
#ifdef BSL2_PASSIVE_TIMEOUT
  #if defined(FR26xx)
    #include "timer_a.h"  // Driver Library: Timer
  #elif defined(FR23xx)
    #include "timer_b.h"
  #endif
#endif
#include <assert.h>

/*******************************************************************************
*  Change Log:
*
*  Version 5.2
*  03/26/15  MG    Added FR2311 support, Timer_B for BSL2TIMEOUT
*  Version 5.1
*  03/16/15  MG    Adding clear function for Tiny RAM
*  Version 5.0
*  05/22/14  MG    Adding timeout and sleep functions
*
*  Version 4.0
*  09.11.12  LCW   Clear Lock IO on startup
*
*  Version 3.0
*  10.05.12  LCW   Removed FRAM Word write: 2 byte writes are faster/smaller than the word/byte check
*                  Bytes buffers now written from the highest address 'down'
*  Version 2.0
*  22.08.11  LCW   Changed to FWPW from KEY
*                  incorporates API changes and IDE code updates
*******************************************************************************/

#ifdef RAM_BASED_BSL
#ifdef RAM_WRITE_ONLY_BSL
#error Can NOT have RAM write and RAM based BSL
#endif
  #define DEFAULT_STATE (UNLOCKED)
#else
  #define DEFAULT_STATE (LOCKED)
#endif

  __no_init volatile unsigned int LockedStatus;
  __no_init int FwRamKey;
  __no_init int RAM_MPUSAM;

  extern __no_init unsigned int BSL430_Timeout;
  extern __no_init unsigned long BSL430_Timeout_count;

#define API_VERSION FRAM_MEMORY+(0x05)
#define API_V API_VERSION
#ifdef RAM_WRITE_ONLY_BSL
  #define API_V (API_VERSION+RAM_WRITE_ONLY_BSL)
#endif
  const unsigned char BSL430_API_Version @ "BSL430_VERSION_API" = API_V;
#pragma required=BSL430_API_Version

/*******************************************************************************
*Function:    __low_level_init
*Description: function used to erase the RAM in device and stop WDT
*******************************************************************************/

#if __VER__ <= 420
void
#else
int
#endif
__low_level_init(void)
{
#ifndef RAM_BASED_BSL
  unsigned register int* addr;
#endif
  WDTCTL = WDTPW + WDTHOLD;                 // Stop watchdog timer
#ifndef RAM_BASED_BSL
  for(addr = (unsigned int*)SECURE_RAM_START; addr < (unsigned int*)__get_SP_register(); addr+=1)
  {
    *addr = 0x3FFF;
  }
#ifdef CLEAR_TINY_RAM
  for(addr = (unsigned int*)TINY_RAM_START; addr < (unsigned int*)TINY_RAM_END; addr+=1)
  {
    *addr = 0x3FFF;
  }
#endif
#endif

#ifdef SUPPORTS_RX_TIMEOUT
  asm("    mov  R12,BSL430_Timeout");                   // set timeout flag
  BSL430_Timeout_count = 0;                             // initialize counter
#endif

#if __VER__ > 420
    return 0;                             // do not initialize
#endif
}

/*******************************************************************************
*Function:    BSL430_API_init
*Description: sets the key for writing to FRAM,  sets device state
*******************************************************************************/
void BSL430_API_init()
{

  PMMCTL0_H = PMMPW_H;                  // open PMM registers
  PM5CTL0 &= ~LOCKLPM5;                 // clear lock IO
  PMMCTL0_H = 0x00;                     // close PMM registers

  LockedStatus = DEFAULT_STATE;
  FwRamKey = FWPW;
  FRCTL0 = FWPW;  // open access, NWAITS set to no wait states
  FRCTL0_H = 0xFF;  // close access
}

/*******************************************************************************
*Function:    BSL430_lock_BSL
*Description: Locks the BSL
*Returns:
*             SUCCESSFUL_OPERATION  BSL Locked
*******************************************************************************/
char BSL430_lock_BSL()
{
  LockedStatus = LOCKED;
  return SUCCESSFUL_OPERATION;
}

/*******************************************************************************
*Function:    BSL430_unlock_BSL
*Description: Causes the BSL to compare the data buffer against the BSL password
*             BSL state will be UNLOCKED if successful
*Parameters:
*             char* data            A pointer to an array containing the password
*Returns:
*             SUCCESSFUL_OPERATION  All data placed into data array successfully
*             BSL_PASSWORD_ERROR    Correct Password was not given
*******************************************************************************/
char BSL430_unlock_BSL(char* data)
{
  int i;
  int retValue =0;
  char *interrupts = (char*)INTERRUPT_VECTOR_START;
  for( i = 0; i <= (INTERRUPT_VECTOR_END-INTERRUPT_VECTOR_START); i++, interrupts++)
  {
    retValue |=  *interrupts ^ data[i];
  }

  if( retValue == 0)
  {
#ifndef RAM_WRITE_ONLY_BSL
    volatile int i;
    for( i = MASS_ERASE_DELAY-1; i > 0; i-- );
#endif
    LockedStatus = UNLOCKED;
    return SUCCESSFUL_OPERATION;
  }
  else
  {
    volatile unsigned int* sig1 = (unsigned int*)0xFF84;
    volatile unsigned int* sig2 = (unsigned int*)0xFF86;
    if( (*sig1 != 0xAAAA)||(*sig2 != 0xAAAA))
    {
      BSL430_massErase();
    }
    return BSL_PASSWORD_ERROR;
  }
}

/*******************************************************************************
*Function:    BSL430_openMemoryForWrite
*Description: Unlocks the FRAM for writing
*Returns:
*             SUCCESSFUL_OPERATION  FRAM is now open for writing.
*             BSL_LOCKED            Correct Password has not yet been given
*******************************************************************************/
char BSL430_openMemory()
{
    if( LockedStatus == UNLOCKED )
    {
#if defined(FR26xx) || defined(FR23xx)
        RAM_MPUSAM = (SYSCFG0 & (DFWP + PFWP));  // Save previous state
        SYSCFG0 = FRWPPW;     // Data and Program FRAM write access
#else
        MPUCTL0 = FwRamKey;
        RAM_MPUSAM = MPUSAM;
        MPUSAM = 0xFFFF;      // read/write/execute everywhere
        MPUCTL0_H = 0xFF;     // close access
#endif
        return SUCCESSFUL_OPERATION;
    }
    return BSL_LOCKED;
}

/*******************************************************************************
*Function:    BSL430_closeMemory
*Description: set FRAM back to previous state
*Returns:
*             SUCCESSFUL_OPERATION  FRAM is now returned to previous state.
*******************************************************************************/
char BSL430_closeMemory(void)
{
#if defined(FR26xx) || defined (FR23xx)
    SYSCFG0 = FRWPPW + RAM_MPUSAM;          // Restore previous state
#else
    MPUCTL0 = FwRamKey;
    MPUSAM = RAM_MPUSAM;
    MPUCTL0_H = 0xFF;     // close access
#endif
  return SUCCESSFUL_OPERATION;
}

/*******************************************************************************
*Function:    BSL430_readMemory
*Description: Reads an array of bytes from memory into a supplied array
*Parameters:
*             unsigned long addr    The address from which the read should begin
*             char length           The amount of bytes to read
*             char* data            The array into which the data will be saved
*Returns:
*             SUCCESSFUL_OPERATION  All Data placed into data array successfully
*             BSL_LOCKED            Correct Password has not yet been given
*******************************************************************************/
char BSL430_readMemory(unsigned long addr, unsigned int length, char* data)
{
  unsigned long i;
  char exceptions = SUCCESSFUL_OPERATION;
  for( i = addr+length-1; i >= addr; i-- )  // Need to fix for addr = 0
  {
    if( LockedStatus == UNLOCKED )
    {
      data[i-addr] = __data20_read_char(i);
    }
    else
    {
      return BSL_LOCKED;
    }
  }
  return exceptions;
}

/*******************************************************************************
*Function:    BSL430_crcCheck
*Description: return a CRC check on the memory specified
*Parameters:
*           unsigned long addr    The address from which to start the check
*           int length            The length of the data area to check
*           int* return           variable in which to put the return value
*Returns:
*           SUCCESSFUL_OPERATION  CRC check done correctly
*           BSL_LOCKED            Correct Password has not yet been given
*******************************************************************************/
int BSL430_crcCheck( unsigned long addr, unsigned int length, int* result )
{
  long i;
  CRCINIRES = 0xFFFF;
  for( i = addr; i < addr+length; i++ )
  {
    if( LockedStatus == UNLOCKED )
    {
      CRCDIRB_L = __data20_read_char( i );
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
*Function:    BSL430_callAddress
*Description: Loads the Program Counter with the supplied address
*Parameters:
*           unsigned long addr    The address which the PC should be set to
*Returns:
*           SUCCESSFUL_OPERATION  Called location has returned
*           BSL_LOCKED            Correct Password has not yet been given
*Note:
*           If successful, this function does not return.
*******************************************************************************/
char BSL430_callAddress(unsigned long addr)
{
  if( LockedStatus == UNLOCKED )
  {
    ((void (*)())addr)();                   // type cast addr to function ptr, call
    return SUCCESSFUL_OPERATION;
  }
  return BSL_LOCKED;                        // can only be reached if BSL is locked
}

/*******************************************************************************
*Function:    BSL430_writeMemory
*Description: Writes a byte array starting at a given address.
*             Note: the function will write in word mode if possible
*             (when start address is even)
*Parameters:
*           unsigned long startAddr        The address to which the write should begin
*           char size                      The number of bytes to write
*           char data                      The array of bytes to write (must be even aligned)
*Returns:
*           SUCCESSFUL_OPERATION           Bytes written successfully
*           FLASH_WRITE_CHECK_FAILED       A byte in data location post-write does not match data parameter
*                                          Note: write stops immediatly after a byte check fails
*           BSL_LOCKED                     Correct Password has not yet been given
*******************************************************************************/
char BSL430_writeMemory(unsigned long startAddr, unsigned int size,  char* data )
{
  long i;
  char exceptions = SUCCESSFUL_OPERATION;
  data+=(size-1);
  for( i = size - 1; i >= 0; i-- )
  {
    exceptions =  BSL430_writeByte( i+startAddr, *data );
    data-=1;
    if( exceptions != SUCCESSFUL_OPERATION )
    {
      break;
    } // if
  }
  return exceptions;
}

/*******************************************************************************
*Function:    BSL430_writeByte
*Description: Writes a byte at a given address
*Parameters:
*           int addr                       The address to which the byte should be written
*           char data                      The byte to write
*Returns:
*           SUCCESSFUL_OPERATION           Byte written successfully
*           MEMORY_WRITE_CHECK_FAILED       Byte in data location post-write does not match data parameter
*           BSL_LOCKED                     Correct Password has not yet been given
*******************************************************************************/
char BSL430_writeByte(unsigned long addr, char data )
{
  char exceptions;
  if( LockedStatus == UNLOCKED )
  {
    exceptions = SUCCESSFUL_OPERATION;
    __data20_write_char( addr, data );
    if( data != __data20_read_char( addr ))
    {
      exceptions = MEMORY_WRITE_CHECK_FAILED;
    }
  }
  else
  {
    exceptions = BSL_LOCKED;
  }
  return exceptions;
}

/*******************************************************************************
*Function:    BSL430_writeWord
*Description: Writes a word at a given address
*Parameters:
*           int addr                       The address to which the word should be written
*           int data                       The byte to write
*Returns:
*           SUCCESSFUL_OPERATION           Word written successfully
*           MEMORY_WRITE_CHECK_FAILED       Word in data location post-write does not match data parameter
*           BSL_LOCKED                     Correct Password has not yet been given
*******************************************************************************/
/*
char BSL430_writeWord(unsigned long addr, int data )
{
  char exceptions;
  if( LockedStatus == UNLOCKED )
  {
    exceptions = SUCCESSFUL_OPERATION;

    __data20_write_short( addr, data );

    if( data != __data20_read_short( addr ))
    {
      exceptions = MEMORY_WRITE_CHECK_FAILED;
    }
  }
  else
  {
    exceptions = BSL_LOCKED;
  }
  return exceptions;
}
*/
/*******************************************************************************
*Function:    BSL430_massErase
*Description: Mass erases the entire MSP430 device
*Parameters:
*           char eraseFlags                Flags describing whether to erase RAM and Info
*Returns:
*           SUCCESSFUL_OPERATION           device erased
*           MEMORY_WRITE_CHECK_FAILED      Error occured during mass erase
*           BSL_LOCKED                     Correct Password has not yet been given
*******************************************************************************/
char BSL430_massErase()
{
#if defined(FR26xx) || defined(FR23xx)
    asm("    mov  #0x0008,R12");            // FR26xx mass erase password
    ((void (*)())0x1C00)();                 // Call Bootcode's mass erase
    return SUCCESSFUL_OPERATION;
#else
    unsigned int (*mErase)(unsigned int, unsigned int, unsigned int);
    mErase = (unsigned int (*)(unsigned int, unsigned int, unsigned int))0x1B02;
    return mErase((unsigned int)0x00, 0xDEAD, 0xBEEF);
#endif
}

/*******************************************************************************
*Function:    BSL430_timeoutInit
*Description: Initializes the timer for timeout
*Parameters:
*Returns:
*             SUCCESSFUL_OPERATION      Timer initialized
*******************************************************************************/
#ifdef BSL2TIMEOUT
char BSL430_timeoutInit()
{
  #if BSL_TIMEOUT > 65535u
  #error BSL_TIMEOUT does not fit 16-bit value
  #endif
  #if defined(FR26xx)
  TIMER_A_configureUpMode(TIMER_A0_BASE,
                          TIMER_A_CLOCKSOURCE_ACLK,
                          TIMER_A_CLOCKSOURCE_DIVIDER_32,
                          BSL_TIMEOUT,
                          TIMER_A_TAIE_INTERRUPT_DISABLE,
                          TIMER_A_CCIE_CCR0_INTERRUPT_DISABLE,
                          TIMER_A_DO_CLEAR);
  TA0CTL &= ~TAIFG;                         // Make sure Timer A IFG is cleared
  TIMER_A_startCounter(TIMER_A0_BASE, TIMER_A_UP_MODE);
  #elif defined(FR23xx)
  Timer_B_initUpModeParam initUpParam = {0};
  initUpParam.clockSource = TIMER_B_CLOCKSOURCE_ACLK;
  initUpParam.clockSourceDivider = TIMER_B_CLOCKSOURCE_DIVIDER_32;
  initUpParam.timerPeriod = BSL_TIMEOUT;
  initUpParam.timerInterruptEnable_TBIE = TIMER_B_TBIE_INTERRUPT_DISABLE;
  initUpParam.captureCompareInterruptEnable_CCR0_CCIE = TIMER_B_CCIE_CCR0_INTERRUPT_DISABLE;
  initUpParam.timerClear = TIMER_B_DO_CLEAR;
  initUpParam.startTimer = false;
  Timer_B_initUpMode(TIMER_B0_BASE, &initUpParam);
  TB0CTL &= ~TBIFG;
  Timer_B_startCounter(TIMER_B0_BASE, TIMER_B_UP_MODE);
  #else
  #warning BSL2TIMEOUT not supported on this device
  #endif
  return SUCCESSFUL_OPERATION;
}
#endif

/*******************************************************************************
*Function:    BSL430_timeoutStop
*Description: Halts the timer used for timeout
*Parameters:
*Returns:
*             SUCCESSFUL_OPERATION      Timer halted
*******************************************************************************/
#ifdef BSL2TIMEOUT
char BSL430_timeoutStop()
{
  #if defined(FR26xx)
  TIMER_A_stop(TIMER_A0_BASE);
  #elif defined(FR23xx)
  Timer_B_stop(TIMER_B0_BASE);
  #else
  #warning BSL2TIMEOUT not supported on this device
  #endif
  return SUCCESSFUL_OPERATION;
}
#endif

/*******************************************************************************
*Function:    BSL430_timeoutGetCount
*Description: Stores the timer counter value at given address.
*Parameters:
*             unsigned int* result      Variable that stores the timer count
*Returns:
*             SUCCESSFUL_OPERATION      Timer count returned
*******************************************************************************/
#ifdef BSL2TIMEOUT
char BSL430_timeoutGetCount(unsigned int* result)
{
  #if defined(FR26xx)
  *result = TIMER_A_getCounterValue(TIMER_A0_BASE);
  #elif defined(FR23xx)
  *result = Timer_B_getCounterValue(TIMER_B0_BASE);
  #else
  #warning BSL2TIMEOUT not supported on this device
  #endif
  return SUCCESSFUL_OPERATION;
}
#endif

/*******************************************************************************
*Function:    BSL430_timeoutTimedOut
*Description: Checks if the timer period expired
*Parameters:
*Returns:
*             SUCCESSFUL_OPERATION      Timed out
*             !SUCCESSFUL_OPERATION     Not timed out
*******************************************************************************/
#ifdef BSL2TIMEOUT

char BSL430_timeoutTimedOut()
{
  char exceptions = !SUCCESSFUL_OPERATION;

  #if defined(FR26xx)
  if(TA0CTL & TAIFG)
  #elif defined(FR23xx)
  if(TB0CTL & TBIFG)
  #else
  #warning BSL2TIMEOUT not supported on this device
  #endif
  {
      exceptions = SUCCESSFUL_OPERATION;
  }
  return exceptions;
}
#endif

/*******************************************************************************
*Function:    BSL430_sleep
*Description: Stops BSL execution by going to sleep mode
*Parameters:
*Returns:
*             Function should not return.
*******************************************************************************/
#ifdef BSL2TIMEOUT
char BSL430_sleep()
{
#ifndef NDEBUG
#warning "P1.0 set at timeout for debug"
  P1DIR |= BIT0;                            // Set P1.0 (only in debug!)
  P1OUT |= BIT0;                            //
#endif
  LPM4;
  return SUCCESSFUL_OPERATION;
}
#endif

/*******************************************************************************
* UNUSED Header functions
*******************************************************************************/
char BSL430_toggleInfoLock(){return 0;}
char BSL430_eraseLocation( char block_erase, unsigned long addr ){return 0;}