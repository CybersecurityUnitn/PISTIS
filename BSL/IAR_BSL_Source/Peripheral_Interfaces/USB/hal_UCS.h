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
//====================================================================
//    File: hal_UCS.h
//
//    Texas Instruments
//
//    Provides Functions to Initialize the UCS/FLL and clock sources
//    04/17/08
//
//====================================================================


#ifndef __hal_UCS
#define __hal_UCS

#define XT1_TO_MCLK   UCSCTL4 = (UCSCTL4 & ~(SELM_7)) | (SELM__XT1CLK)  /*Select XT1 for MCLK */
#define XT2_TO_MCLK   UCSCTL4 = (UCSCTL4 & ~(SELM_7)) | (SELM__XT2CLK)  /* Select XT2 for MCLK */
#define XT1_TO_SMCLK  UCSCTL4 = (UCSCTL4 & ~(SELS_7)) | (SELS__XT1CLK)  /* Select XT1 for SMCLK */
#define XT2_TO_SMCLK  UCSCTL4 = (UCSCTL4 & ~(SELS_7)) | (SELS__XT2CLK)  /* Select XT2 for SMCLK */

//#define MCLK_DIV_1    UCSCTL5 = (UCSCTL5 & ~(DIVM_7)) | (DIVM_0)        /* set MCLK/1 */
//#define MCLK_DIV_2    UCSCTL5 = (UCSCTL5 & ~(DIVM_7)) | (DIVM_1)        /* set MCLK/2 */
//#define SMCLK_DIV_1   UCSCTL5 = (UCSCTL5 & ~(DIVS_7)) | (DIVS_0)        /* set SMCLK/1 */
//#define SMCLK_DIV_2   UCSCTL5 = (UCSCTL5 & ~(DIVS_7)) | (DIVS_1)        /* set SMCLK/2 */

#define MCLK_DIV(x)   UCSCTL5 = (UCSCTL5 & ~(DIVM_7)) | (DIVM__##x)     /* set MCLK/x */
#define SMCLK_DIV(x)  UCSCTL5 = (UCSCTL5 & ~(DIVS_7)) | (DIVS__##x)     /* set SMCLK/x */


//====================================================================
/**
 * Startup routine for 32kHz Cristal on LFXT1
 *
*/
void LFXT_Start(void);

//====================================================================
/**
 * Startup routine for XT1
 *
*/
void XT1_Start(void);

//====================================================================
/**
 * Use XT1 in Bypasss mode
 *
*/
void XT1Bypass(void);

//====================================================================
/**
 * Startup routine for XT2
 *
*/
void XT2_Start(void);

//====================================================================
/**
 * Use XT2 in Bypasss mode for MCLK
 *
*/
void XT2Bypass(void);


//====================================================================
/**
  * Initializes FLL of the UCS
  *
  * \param fsystem  required system frequency (MCLK) in kHz
  * \param ratio       ratio between fsystem and FLLREFCLK
  */
void Init_FLL(const unsigned int fsystem, const unsigned int ratio);


#endif /* __hal_UCS */
