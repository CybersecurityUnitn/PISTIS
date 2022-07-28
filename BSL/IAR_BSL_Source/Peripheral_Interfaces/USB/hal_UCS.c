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
//*******************************************************************************
//
//  Provides Functions to Initialize the UCS/FLL and clock sources
//
//    Texas Instruments
//
//    Version 1.0
//    04/17/08
//
//*******************************************************************************

/* ***********************************************************
* THIS PROGRAM IS PROVIDED "AS IS". TI MAKES NO WARRANTIES OR
* REPRESENTATIONS, EITHER EXPRESS, IMPLIED OR STATUTORY,
* INCLUDING ANY IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS
* FOR A PARTICULAR PURPOSE, LACK OF VIRUSES, ACCURACY OR
* COMPLETENESS OF RESPONSES, RESULTS AND LACK OF NEGLIGENCE.
* TI DISCLAIMS ANY WARRANTY OF TITLE, QUIET ENJOYMENT, QUIET
* POSSESSION, AND NON-INFRINGEMENT OF ANY THIRD PARTY
* INTELLECTUAL PROPERTY RIGHTS WITH REGARD TO THE PROGRAM OR
* YOUR USE OF THE PROGRAM.
*
* IN NO EVENT SHALL TI BE LIABLE FOR ANY SPECIAL, INCIDENTAL,
* CONSEQUENTIAL OR INDIRECT DAMAGES, HOWEVER CAUSED, ON ANY
* THEORY OF LIABILITY AND WHETHER OR NOT TI HAS BEEN ADVISED
* OF THE POSSIBILITY OF SUCH DAMAGES, ARISING IN ANY WAY OUT
* OF THIS AGREEMENT, THE PROGRAM, OR YOUR USE OF THE PROGRAM.
* EXCLUDED DAMAGES INCLUDE, BUT ARE NOT LIMITED TO, COST OF
* REMOVAL OR REINSTALLATION, COMPUTER TIME, LABOR COSTS, LOSS
* OF GOODWILL, LOSS OF PROFITS, LOSS OF SAVINGS, OR LOSS OF
* USE OR INTERRUPTION OF BUSINESS. IN NO EVENT WILL TI'S
* AGGREGATE LIABILITY UNDER THIS AGREEMENT OR ARISING OUT OF
* YOUR USE OF THE PROGRAM EXCEED FIVE HUNDRED DOLLARS
* (U.S.$500).
*
* Unless otherwise stated, the Program written and copyrighted
* by Texas Instruments is distributed as "freeware".  You may,
* only under TI's copyright in the Program, use and modify the
* Program without any charge or restriction.  You may
* distribute to third parties, provided that you transfer a
* copy of this license to the third party and the third party
* agrees to these terms by its first use of the Program. You
* must reproduce the copyright notice and any other legend of
* ownership on each copy or partial copy, of the Program.
*
* You acknowledge and agree that the Program contains
* copyrighted material, trade secrets and other TI proprietary
* information and is protected by copyright laws,
* international copyright treaties, and trade secret laws, as
* well as other intellectual property laws.  To protect TI's
* rights in the Program, you agree not to decompile, reverse
* engineer, disassemble or otherwise translate any object code
* versions of the Program to a human-readable form.  You agree
* that in no event will you alter, remove or destroy any
* copyright notice included in the Program.  TI reserves all
* rights not specifically granted under this license. Except
* as specifically provided herein, nothing in this agreement
* shall be construed as conferring by implication, estoppel,
* or otherwise, upon you, any license or other right under any
* TI patents, copyrights or trade secrets.
*
* You may not use the Program in non-TI devices.
* ********************************************************* */


#include "device.h"
#include "hal_UCS.h"

//====================================================================
/**
 * Startup routine for 32kHz Cristal on LFXT1
 *
*/
/*
void LFXT_Start(void)
{
  P7SEL |= 0x03;              // enable XT1 for LFXTAL
  UCSCTL6_L |= XT1DRIVE1_L+XT1DRIVE0; // Highest drive setting for XT1 startup

  while (SFRIFG1 & OFIFG) {   // check OFIFG fault flag
    while (SFRIFG1 & OFIFG) {   // check OFIFG fault flag
      UCSCTL7 &= ~(DCOFFG+XT1LFOFFG+XT1HFOFFG+XT2OFFG); // Clear OSC flaut Flags fault flags
      SFRIFG1 &= ~OFIFG;        // Clear OFIFG fault flag
    }
    UCSCTL6_L &= ~(XT1DRIVE1_L+XT1DRIVE0); // lower drive setting to XT1 for low power
  }
}
*/

//====================================================================
/**
 * Startup routine for  XT1
 *
*/
/*
void XT1_Start(void)
{
  P7SEL |= 0x03;              // XT1IN/OUT = on
  UCSCTL6 &= ~XT1OFF;         // enalbe XT1 even if not used
  UCSCTL6 |= XTS;             // enalbe XT1 even if not used

  while (SFRIFG1 & OFIFG) {   // check OFIFG fault flag
    UCSCTL7 &= ~(DCOFFG+XT1LFOFFG+XT1HFOFFG+XT2OFFG); // Clear OSC flaut Flags fault flags
    SFRIFG1 &= ~OFIFG;        // Clear OFIFG fault flag
  }
}*/

//====================================================================
/**
 * USe  XT1 in Bypasss mode
 *
*/
/*
void XT1Bypass(void)
{
  P7SEL |= 0x01;              // XT1IN = on
  UCSCTL6 = XT1BYPASS;

  while (SFRIFG1 & OFIFG) {   // check OFIFG fault flag
      UCSCTL7 &= ~(DCOFFG+XT1LFOFFG+XT1HFOFFG+XT2OFFG); // Clear OSC flaut Flags fault flags
    SFRIFG1 &= ~OFIFG;        // Clear OFIFG fault flag
  }
} */

//====================================================================
/**
 * Startup routine for  XT2
 *
*/
void XT2_Start(void)
{
  P5SEL |= 0x0C;              // XT2IN/OUT = on
  UCSCTL6 &= ~XT2OFF;         // enalbe XT2 even if not used

  //while (SFRIFG1 & OFIFG) {   // check OFIFG fault flag
  while (UCSCTL7 & (DCOFFG /*+XT1LFOFFG+XT1HFOFFG*/ +XT2OFFG))
  {
      UCSCTL7 &= ~(DCOFFG+XT1LFOFFG /*+XT1HFOFFG*/ +XT2OFFG); // Clear OSC flaut Flags fault flags
      SFRIFG1 &= ~OFIFG;        // Clear OFIFG fault flag
  }

}

//====================================================================
/**
 * Use XT2 in Bypasss mode
 *
*/
/*
void XT2Bypass(void)
{
  P5SEL |= 0x04;              // XT2IN = on
  UCSCTL6 = XT2BYPASS;

  while (SFRIFG1 & OFIFG) {   // check OFIFG fault flag
      UCSCTL7 &= ~(DCOFFG+XT1LFOFFG+XT1HFOFFG+XT2OFFG); // Clear OSC flaut Flags fault flags
    SFRIFG1 &= ~OFIFG;        // Clear OFIFG fault flag
  }
}
*/

//====================================================================
/**
  * Initializes FLL of the UCS
  *
  * \param fsystem  required system frequency (MCLK) in kHz
  * \param ratio       ratio between fsystem and FLLREFCLK
  */
void Init_FLL(const unsigned int fsystem, const unsigned int ratio)
{
  unsigned int d, dco_div_bits;
//  int nplus1;
  //volatile int i, j;
  //  /\  Prevent variables from being "optimized".

  d = ratio;
  //if (fsystem > 16000)
  //{
//    dco_div_bits = FLLD__4;      // Have at least a divider of 4
   // dco_div_bits = FLLD__2;      // Have at least a divider of 2
  //  d >>= 1 ;
 // }
  //else
    dco_div_bits = FLLD__2;      // Have at least a divider of 2
    /*
  while (d > 512)
  {
    dco_div_bits++;
    d >>= 1;
  }
*/
  UCSCTL0 = 0x000;             // Set DCO to lowest Tap

  UCSCTL2 &= ~(0x3FF);         // Reset FN bits
  UCSCTL2= dco_div_bits | (d - 1);
/*
  if (fsystem <= 630)        //           fsystem < 0.63MHz
    UCSCTL1= DCORSEL_0 ;
  else if (fsystem <  1250)  // 0.63MHz < fsystem < 1.25MHz
    UCSCTL1= DCORSEL_1 ;
  else if (fsystem <  2500)  // 1.25MHz < fsystem <  2.5MHz
    UCSCTL1= DCORSEL_2 ;
  else if (fsystem <  5000)  // 2.5MHz  < fsystem <    5MHz
    UCSCTL1= DCORSEL_3 ;
  else if (fsystem <  10000) // 5MHz    < fsystem <   10MHz
    UCSCTL1= DCORSEL_4 ;
  else if (fsystem <  20000) // 10MHz   < fsystem <   20MHz
    */
    UCSCTL1= DCORSEL_5 ;
/*  else if (fsystem <  40000) // 20MHz   < fsystem <   40MHz
    UCSCTL1= DCORSEL_6 ;
  else
    UCSCTL1= DCORSEL_7 ;
*/

  // Wait till FLL+ is settled at the correct DCO tap
  //while ((UCSCTL7 & (FLLUNLOCK0 + FLLUNLOCK1)) != 0);
/*
  while (SFRIFG1 & OFIFG) {   // check OFIFG fault flag
      UCSCTL7 &= ~(DCOFFG+XT1LFOFFG+XT1HFOFFG+XT2OFFG); // Clear OSC flaut Flags fault flags
      SFRIFG1 &= ~OFIFG;        // Clear OFIFG fault flag
  }
*/

//  if (fsystem > 16000)
//    UCSCTL4 = (UCSCTL4 & ~(SELM_7 + SELS_7)) | (SELM__DCOCLK + SELS__DCOCLK); // select DCOCLK
//  else
    UCSCTL4 = (UCSCTL4 & ~(SELM_7 + SELS_7)) | (SELM__DCOCLKDIV + SELS__DCOCLKDIV); // selcet DCODIVCLK

} // End of fll_init()
