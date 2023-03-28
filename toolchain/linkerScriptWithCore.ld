/* ============================================================================ */
/* Copyright (c) 2019, Texas Instruments Incorporated                           */
/*  All rights reserved.                                                        */
/*                                                                              */
/*  Redistribution and use in source and binary forms, with or without          */
/*  modification, are permitted provided that the following conditions          */
/*  are met:                                                                    */
/*                                                                              */
/*  *  Redistributions of source code must retain the above copyright           */
/*     notice, this list of conditions and the following disclaimer.            */
/*                                                                              */
/*  *  Redistributions in binary form must reproduce the above copyright        */
/*     notice, this list of conditions and the following disclaimer in the      */
/*     documentation and/or other materials provided with the distribution.     */
/*                                                                              */
/*  *  Neither the name of Texas Instruments Incorporated nor the names of      */
/*     its contributors may be used to endorse or promote products derived      */
/*     from this software without specific prior written permission.            */
/*                                                                              */
/*  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" */
/*  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,       */
/*  THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR      */
/*  PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR            */
/*  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,       */
/*  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,         */
/*  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; */
/*  OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,    */
/*  WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR     */
/*  OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,              */
/*  EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.                          */
/* ============================================================================ */

/* This file supports MSP430F5529 devices. */
/* Version: 1.208 */
/* Default linker script, for normal executables */

OUTPUT_ARCH(msp430)
ENTRY(_start)

MEMORY {
  SFR              : ORIGIN = 0x0000, LENGTH = 0x0010 /* END=0x0010, size 16 */
  BSL              : ORIGIN = 0x1000, LENGTH = 0x0800
  RAM              : ORIGIN = 0x2400, LENGTH = 0x2000 /* END=0x43FF, size 8192 */
  USBRAM           : ORIGIN = 0x1C00, LENGTH = 0x0800
  INFOMEM          : ORIGIN = 0x1800, LENGTH = 0x0200 /* END=0x19FF, size 512 as 4 128-byte segments */
  INFOA            : ORIGIN = 0x1980, LENGTH = 0x0080 /* END=0x19FF, size 128 */
  INFOB            : ORIGIN = 0x1900, LENGTH = 0x0080 /* END=0x197F, size 128 */
  INFOC            : ORIGIN = 0x1880, LENGTH = 0x0080 /* END=0x18FF, size 128 */
  INFOD            : ORIGIN = 0x1800, LENGTH = 0x0080 /* END=0x187F, size 128 */

  /* This sections are not used!
  ROM (rx)         : ORIGIN = 0x4400, LENGTH = 0xAC01  END=0xF001, size 48000 
  HIROM (rx)       : ORIGIN = 0x00010000, LENGTH = 0x000043FF END=0x143ff 
  */
  
  BANKA            : ORIGIN = 0x4400, LENGTH = 0x8000
  BANKB            : ORIGIN = 0xC400, LENGTH = 0x8000
  BANKC            : ORIGIN = 0x14400, LENGTH = 0x8000
  BANKD            : ORIGIN = 0x1C400, LENGTH = 0x8000

  
  /*************************************************/
  /***************  NEW PISTIS PART ****************/
  /*************************************************/

  /** New segments for the RAM of the TCM*/
  RAM_TCM (rw)     : ORIGIN = 0x2400, LENGTH = 0x0800 /* END=0x2C00 */

  /** This RAM section must end with an address at which the stack will be loaded.
      Such address must be compatible with the toolchain to avoid rejection **/
  RAM_APP          : ORIGIN = 0x2c00, LENGTH = 0x17fc /* End=0x43Fc */
  
  /** New segments for the code and read-only data of the untrusted application */
  APP_CODE (rx)    : ORIGIN = 0x4400, LENGTH = 0x8000 /*  END=0xC3ff */
  APP_RO (r)       : ORIGIN = 0x14400, LENGTH = 0x8000 /*  END=0x1C3FF */


  /** New segments for the code and persistent data of PISTIS TCM */
  TCM              : ORIGIN = 0xC400, LENGTH = 0x3400 /*  END=0xF800 */
  TCM_UPPER        : ORIGIN = 0x10600, LENGTH = 0x3E00 /* END=0x143FF */
  ELF_CONTAINER     : ORIGIN = 0x1C400, LENGTH = 0x8000 /* END=0x243FF */

  
  /* New segments for the allocation of the protected ISR */

  TCM_ISR         : ORIGIN = 0xF800, LENGTH = 0x0236       
  TCM_ISR1        : ORIGIN = 0xF800, LENGTH = 0x0008
  TCM_ISR2        : ORIGIN = 0xF808, LENGTH = 0x0008
  TCM_ISR3        : ORIGIN = 0xF810, LENGTH = 0x0008
  TCM_ISR4        : ORIGIN = 0xF818, LENGTH = 0x0008
  TCM_ISR5        : ORIGIN = 0xF820, LENGTH = 0x0008
  TCM_ISR6        : ORIGIN = 0xF828, LENGTH = 0x0008
  TCM_ISR7        : ORIGIN = 0xF830, LENGTH = 0x0008
  TCM_ISR8        : ORIGIN = 0xF838, LENGTH = 0x0008
  TCM_ISR9        : ORIGIN = 0xF840, LENGTH = 0x0008
  TCM_ISR10       : ORIGIN = 0xF848, LENGTH = 0x0008
  TCM_ISR11       : ORIGIN = 0xF850, LENGTH = 0x0008
  TCM_ISR12       : ORIGIN = 0xF858, LENGTH = 0x0008
  TCM_ISR13       : ORIGIN = 0xF860, LENGTH = 0x0008
  TCM_ISR14       : ORIGIN = 0xF868, LENGTH = 0x0008
  TCM_ISR15       : ORIGIN = 0xF870, LENGTH = 0x0008
  TCM_ISR16       : ORIGIN = 0xF878, LENGTH = 0x0008
  TCM_ISR17       : ORIGIN = 0xF880, LENGTH = 0x0008
  TCM_ISR18       : ORIGIN = 0xF888, LENGTH = 0x0008
  TCM_ISR19       : ORIGIN = 0xF890, LENGTH = 0x0008
  TCM_ISR20       : ORIGIN = 0xF898, LENGTH = 0x0008
  TCM_ISR21       : ORIGIN = 0xF8a0, LENGTH = 0x0008
  TCM_ISR22       : ORIGIN = 0xF8a8, LENGTH = 0x0008
  TCM_ISR23       : ORIGIN = 0xF8b0, LENGTH = 0x0008
  TCM_ISR24       : ORIGIN = 0xF8b8, LENGTH = 0x0008
  TCM_ISR25       : ORIGIN = 0xF8c0, LENGTH = 0x0008
  TCM_ISR26       : ORIGIN = 0xF8c8, LENGTH = 0x0008
  TCM_ISR27       : ORIGIN = 0xF8d0, LENGTH = 0x0008
  TCM_ISR28       : ORIGIN = 0xF8d8, LENGTH = 0x0008
  TCM_ISR29       : ORIGIN = 0xF8e0, LENGTH = 0x0008
  TCM_ISR30       : ORIGIN = 0xF8e8, LENGTH = 0x0008
  TCM_ISR31       : ORIGIN = 0xF8f0, LENGTH = 0x0008
  TCM_ISR32       : ORIGIN = 0xF8f8, LENGTH = 0x0008
  TCM_ISR33       : ORIGIN = 0xF900, LENGTH = 0x0008
  TCM_ISR34       : ORIGIN = 0xF908, LENGTH = 0x0008
  TCM_ISR35       : ORIGIN = 0xF910, LENGTH = 0x0008
  TCM_ISR36       : ORIGIN = 0xF918, LENGTH = 0x0008
  TCM_ISR37       : ORIGIN = 0xF920, LENGTH = 0x0008
  TCM_ISR38       : ORIGIN = 0xF928, LENGTH = 0x0008
  TCM_ISR39       : ORIGIN = 0xF930, LENGTH = 0x0008
  TCM_ISR40       : ORIGIN = 0xF938, LENGTH = 0x0008
  TCM_ISR41       : ORIGIN = 0xF940, LENGTH = 0x0008
  TCM_ISR42       : ORIGIN = 0xF948, LENGTH = 0x0008
  TCM_ISR43       : ORIGIN = 0xF950, LENGTH = 0x0008
  TCM_ISR44       : ORIGIN = 0xF958, LENGTH = 0x0008
  TCM_ISR45       : ORIGIN = 0xF960, LENGTH = 0x0008
  TCM_ISR46       : ORIGIN = 0xF968, LENGTH = 0x0008
  TCM_ISR47       : ORIGIN = 0xF970, LENGTH = 0x0008
  TCM_ISR48       : ORIGIN = 0xF978, LENGTH = 0x0008
  TCM_ISR49       : ORIGIN = 0xF980, LENGTH = 0x0008
  TCM_ISR50       : ORIGIN = 0xF988, LENGTH = 0x0008
  TCM_ISR51       : ORIGIN = 0xF990, LENGTH = 0x0008
  TCM_ISR52       : ORIGIN = 0xF998, LENGTH = 0x0008
  TCM_ISR53       : ORIGIN = 0xF9A0, LENGTH = 0x0008
  TCM_ISR54       : ORIGIN = 0xF9A8, LENGTH = 0x0008
  TCM_ISR55       : ORIGIN = 0xF9B0, LENGTH = 0x0008
  TCM_ISR56       : ORIGIN = 0xF9B8, LENGTH = 0x0008
  TCM_ISR57       : ORIGIN = 0xF9C0, LENGTH = 0x0008
  TCM_ISR58       : ORIGIN = 0xF9C8, LENGTH = 0x0008
  TCM_ISR59       : ORIGIN = 0xF9D0, LENGTH = 0x0008
  TCM_ISR60       : ORIGIN = 0xF9D8, LENGTH = 0x0008
  TCM_ISR61       : ORIGIN = 0xF9E0, LENGTH = 0x0008
  TCM_ISR62       : ORIGIN = 0xF9E8, LENGTH = 0x0008
  TCM_ISR63       : ORIGIN = 0xF9F0, LENGTH = 0x0008

  /* Handler for the various ISRs */
  TCM_HANDLER     : ORIGIN = 0xF9F8, LENGTH = 0x003e
  
  
  /** New segments for the allocation of the virtual functions */

  VIRT_FUN         : ORIGIN = 0xFC00, LENGTH = 0x0242 
  SAFE_BR          : ORIGIN = 0xFC00, LENGTH = 0x0026
  SAFE_BRA         : ORIGIN = 0xFC26, LENGTH = 0x0026
  SAFE_CALL        : ORIGIN = 0xFC4C, LENGTH = 0x0026
  SAFE_CALLA       : ORIGIN = 0xFC72, LENGTH = 0x0026
  SAFE_RET         : ORIGIN = 0xFC98, LENGTH = 0x002a
  SAFE_RETI        : ORIGIN = 0xFCC0, LENGTH = 0x004a
  SAFE_RETA        : ORIGIN = 0xFD08, LENGTH = 0x0028
  
  WRITE_MOV        : ORIGIN = 0xFD30, LENGTH = 0x0012
  WRITE_MOVX       : ORIGIN = 0xFD42, LENGTH = 0x0014
  
  WRITE_XOR        : ORIGIN = 0xFD56, LENGTH = 0x0012
  WRITE_XORX       : ORIGIN = 0xFD68, LENGTH = 0x0014
  
  WRITE_ADD        : ORIGIN = 0xFD7c, LENGTH = 0x0012
  WRITE_ADDX       : ORIGIN = 0xFD8e, LENGTH = 0x0014
  
  WRITE_ADDC       : ORIGIN = 0xFDa2, LENGTH = 0x0012
  WRITE_ADDCX      : ORIGIN = 0xFDb4, LENGTH = 0x0014
  
  WRITE_DADD       : ORIGIN = 0xFDc8, LENGTH = 0x0012
  WRITE_DADDX      : ORIGIN = 0xFDda, LENGTH = 0x0014
  
  WRITE_SUB        : ORIGIN = 0xFDee, LENGTH = 0x0012
  WRITE_SUBX       : ORIGIN = 0xFE00, LENGTH = 0x0014
  
  WRITE_SUBC       : ORIGIN = 0xFE14, LENGTH = 0x0012
  WRITE_SUBCX      : ORIGIN = 0xFE26, LENGTH = 0x0014
  
  STOP_MCU         : ORIGIN = 0xFE3A, LENGTH = 0x0004
  
  /** Auxiliary functions which can be called by the untrusted application **/
  RECEIVE_UPDATE   : ORIGIN = 0xFE3E, LENGTH = 0x0004 /* Sync it with the TCMhook*/
  

  /** New safe IVT integrity protected **/
  
  TCM_VECT		    : ORIGIN = 0xFF80, LENGTH = 0x007e
  TCM_VECT1       : ORIGIN = 0xFF80, LENGTH = 0x0002
  TCM_VECT3       : ORIGIN = 0xFF84, LENGTH = 0x0002
  TCM_VECT2       : ORIGIN = 0xFF82, LENGTH = 0x0002
  TCM_VECT4       : ORIGIN = 0xFF86, LENGTH = 0x0002
  TCM_VECT5       : ORIGIN = 0xFF88, LENGTH = 0x0002
  TCM_VECT6       : ORIGIN = 0xFF8A, LENGTH = 0x0002
  TCM_VECT7       : ORIGIN = 0xFF8C, LENGTH = 0x0002
  TCM_VECT8       : ORIGIN = 0xFF8E, LENGTH = 0x0002
  TCM_VECT9       : ORIGIN = 0xFF90, LENGTH = 0x0002
  TCM_VECT10      : ORIGIN = 0xFF92, LENGTH = 0x0002
  TCM_VECT11      : ORIGIN = 0xFF94, LENGTH = 0x0002
  TCM_VECT12      : ORIGIN = 0xFF96, LENGTH = 0x0002
  TCM_VECT13      : ORIGIN = 0xFF98, LENGTH = 0x0002
  TCM_VECT14      : ORIGIN = 0xFF9A, LENGTH = 0x0002
  TCM_VECT15      : ORIGIN = 0xFF9C, LENGTH = 0x0002
  TCM_VECT16      : ORIGIN = 0xFF9E, LENGTH = 0x0002
  TCM_VECT17      : ORIGIN = 0xFFA0, LENGTH = 0x0002
  TCM_VECT18      : ORIGIN = 0xFFA2, LENGTH = 0x0002
  TCM_VECT19      : ORIGIN = 0xFFA4, LENGTH = 0x0002
  TCM_VECT20      : ORIGIN = 0xFFA6, LENGTH = 0x0002
  TCM_VECT21      : ORIGIN = 0xFFA8, LENGTH = 0x0002
  TCM_VECT22      : ORIGIN = 0xFFAA, LENGTH = 0x0002
  TCM_VECT23      : ORIGIN = 0xFFAC, LENGTH = 0x0002
  TCM_VECT24      : ORIGIN = 0xFFAE, LENGTH = 0x0002
  TCM_VECT25      : ORIGIN = 0xFFB0, LENGTH = 0x0002
  TCM_VECT26      : ORIGIN = 0xFFB2, LENGTH = 0x0002
  TCM_VECT27      : ORIGIN = 0xFFB4, LENGTH = 0x0002
  TCM_VECT28      : ORIGIN = 0xFFB6, LENGTH = 0x0002
  TCM_VECT29      : ORIGIN = 0xFFB8, LENGTH = 0x0002
  TCM_VECT30      : ORIGIN = 0xFFBA, LENGTH = 0x0002
  TCM_VECT31      : ORIGIN = 0xFFBC, LENGTH = 0x0002
  TCM_VECT32      : ORIGIN = 0xFFBE, LENGTH = 0x0002
  TCM_VECT33      : ORIGIN = 0xFFC0, LENGTH = 0x0002
  TCM_VECT34      : ORIGIN = 0xFFC2, LENGTH = 0x0002
  TCM_VECT35      : ORIGIN = 0xFFC4, LENGTH = 0x0002
  TCM_VECT36      : ORIGIN = 0xFFC6, LENGTH = 0x0002
  TCM_VECT37      : ORIGIN = 0xFFC8, LENGTH = 0x0002
  TCM_VECT38      : ORIGIN = 0xFFCA, LENGTH = 0x0002
  TCM_VECT39      : ORIGIN = 0xFFCC, LENGTH = 0x0002
  TCM_VECT40      : ORIGIN = 0xFFCE, LENGTH = 0x0002
  TCM_VECT41      : ORIGIN = 0xFFD0, LENGTH = 0x0002
  TCM_VECT42      : ORIGIN = 0xFFD2, LENGTH = 0x0002
  TCM_VECT43      : ORIGIN = 0xFFD4, LENGTH = 0x0002
  TCM_VECT44      : ORIGIN = 0xFFD6, LENGTH = 0x0002
  TCM_VECT45      : ORIGIN = 0xFFD8, LENGTH = 0x0002
  TCM_VECT46      : ORIGIN = 0xFFDA, LENGTH = 0x0002
  TCM_VECT47      : ORIGIN = 0xFFDC, LENGTH = 0x0002
  TCM_VECT48      : ORIGIN = 0xFFDE, LENGTH = 0x0002
  TCM_VECT49      : ORIGIN = 0xFFE0, LENGTH = 0x0002
  TCM_VECT50      : ORIGIN = 0xFFE2, LENGTH = 0x0002
  TCM_VECT51      : ORIGIN = 0xFFE4, LENGTH = 0x0002
  TCM_VECT52      : ORIGIN = 0xFFE6, LENGTH = 0x0002
  TCM_VECT53      : ORIGIN = 0xFFE8, LENGTH = 0x0002
  TCM_VECT54      : ORIGIN = 0xFFEA, LENGTH = 0x0002
  TCM_VECT55      : ORIGIN = 0xFFEC, LENGTH = 0x0002
  TCM_VECT56      : ORIGIN = 0xFFEE, LENGTH = 0x0002
  TCM_VECT57      : ORIGIN = 0xFFF0, LENGTH = 0x0002
  TCM_VECT58      : ORIGIN = 0xFFF2, LENGTH = 0x0002
  TCM_VECT59      : ORIGIN = 0xFFF4, LENGTH = 0x0002
  TCM_VECT60      : ORIGIN = 0xFFF6, LENGTH = 0x0002
  TCM_VECT61      : ORIGIN = 0xFFF8, LENGTH = 0x0002
  TCM_VECT62      : ORIGIN = 0xFFFA, LENGTH = 0x0002
  TCM_VECT63      : ORIGIN = 0xFFFC, LENGTH = 0x0002

  
  /*************************************************/
  /***************  end NEW PISTIS PART **************/
  /*************************************************/

  RESETVEC         : ORIGIN = 0xFFFE, LENGTH = 0x0002


  /** ISR for the application code **/
  VECT1            : ORIGIN = 0x10400, LENGTH = 0x0002
  VECT2            : ORIGIN = 0x10402, LENGTH = 0x0002
  VECT3            : ORIGIN = 0x10404, LENGTH = 0x0002
  VECT4            : ORIGIN = 0x10406, LENGTH = 0x0002
  VECT5            : ORIGIN = 0x10408, LENGTH = 0x0002
  VECT6            : ORIGIN = 0x1040A, LENGTH = 0x0002
  VECT7            : ORIGIN = 0x1040C, LENGTH = 0x0002
  VECT8            : ORIGIN = 0x1040E, LENGTH = 0x0002
  VECT9            : ORIGIN = 0x10410, LENGTH = 0x0002
  VECT10           : ORIGIN = 0x10412, LENGTH = 0x0002
  VECT11           : ORIGIN = 0x10414, LENGTH = 0x0002
  VECT12           : ORIGIN = 0x10416, LENGTH = 0x0002
  VECT13           : ORIGIN = 0x10418, LENGTH = 0x0002
  VECT14           : ORIGIN = 0x1041A, LENGTH = 0x0002
  VECT15           : ORIGIN = 0x1041C, LENGTH = 0x0002
  VECT16           : ORIGIN = 0x1041E, LENGTH = 0x0002
  VECT17           : ORIGIN = 0x10420, LENGTH = 0x0002
  VECT18           : ORIGIN = 0x10422, LENGTH = 0x0002
  VECT19           : ORIGIN = 0x10424, LENGTH = 0x0002
  VECT20           : ORIGIN = 0x10426, LENGTH = 0x0002
  VECT21           : ORIGIN = 0x10428, LENGTH = 0x0002
  VECT22           : ORIGIN = 0x1042A, LENGTH = 0x0002
  VECT23           : ORIGIN = 0x1042C, LENGTH = 0x0002
  VECT24           : ORIGIN = 0x1042E, LENGTH = 0x0002
  VECT25           : ORIGIN = 0x10430, LENGTH = 0x0002
  VECT26           : ORIGIN = 0x10432, LENGTH = 0x0002
  VECT27           : ORIGIN = 0x10434, LENGTH = 0x0002
  VECT28           : ORIGIN = 0x10436, LENGTH = 0x0002
  VECT29           : ORIGIN = 0x10438, LENGTH = 0x0002
  VECT30           : ORIGIN = 0x1043A, LENGTH = 0x0002
  VECT31           : ORIGIN = 0x1043C, LENGTH = 0x0002
  VECT32           : ORIGIN = 0x1043E, LENGTH = 0x0002
  VECT33           : ORIGIN = 0x10440, LENGTH = 0x0002
  VECT34           : ORIGIN = 0x10442, LENGTH = 0x0002
  VECT35           : ORIGIN = 0x10444, LENGTH = 0x0002
  VECT36           : ORIGIN = 0x10446, LENGTH = 0x0002
  VECT37           : ORIGIN = 0x10448, LENGTH = 0x0002
  VECT38           : ORIGIN = 0x1044A, LENGTH = 0x0002
  VECT39           : ORIGIN = 0x1044C, LENGTH = 0x0002
  VECT40           : ORIGIN = 0x1044E, LENGTH = 0x0002
  VECT41           : ORIGIN = 0x10450, LENGTH = 0x0002
  VECT42           : ORIGIN = 0x10452, LENGTH = 0x0002
  VECT43           : ORIGIN = 0x10454, LENGTH = 0x0002
  VECT44           : ORIGIN = 0x10456, LENGTH = 0x0002
  VECT45           : ORIGIN = 0x10458, LENGTH = 0x0002
  VECT46           : ORIGIN = 0x1045A, LENGTH = 0x0002
  VECT47           : ORIGIN = 0x1045C, LENGTH = 0x0002
  VECT48           : ORIGIN = 0x1045E, LENGTH = 0x0002
  VECT49           : ORIGIN = 0x10460, LENGTH = 0x0002
  VECT50           : ORIGIN = 0x10462, LENGTH = 0x0002
  VECT51           : ORIGIN = 0x10464, LENGTH = 0x0002
  VECT52           : ORIGIN = 0x10466, LENGTH = 0x0002
  VECT53           : ORIGIN = 0x10468, LENGTH = 0x0002
  VECT54           : ORIGIN = 0x1046A, LENGTH = 0x0002
  VECT55           : ORIGIN = 0x1046C, LENGTH = 0x0002
  VECT56           : ORIGIN = 0x1046E, LENGTH = 0x0002
  VECT57           : ORIGIN = 0x10470, LENGTH = 0x0002
  VECT58           : ORIGIN = 0x10472, LENGTH = 0x0002
  VECT59           : ORIGIN = 0x10474, LENGTH = 0x0002
  VECT60           : ORIGIN = 0x10476, LENGTH = 0x0002
  VECT61           : ORIGIN = 0x10478, LENGTH = 0x0002
  VECT62           : ORIGIN = 0x1047A, LENGTH = 0x0002
  VECT63           : ORIGIN = 0x1047C, LENGTH = 0x0002
  

}

SECTIONS
{
  __interrupt_vector_1   : { KEEP (*(__interrupt_vector_1 )) } > VECT1
  __interrupt_vector_2   : { KEEP (*(__interrupt_vector_2 )) } > VECT2
  __interrupt_vector_3   : { KEEP (*(__interrupt_vector_3 )) } > VECT3
  __interrupt_vector_4   : { KEEP (*(__interrupt_vector_4 )) } > VECT4
  __interrupt_vector_5   : { KEEP (*(__interrupt_vector_5 )) } > VECT5
  __interrupt_vector_6   : { KEEP (*(__interrupt_vector_6 )) } > VECT6
  __interrupt_vector_7   : { KEEP (*(__interrupt_vector_7 )) } > VECT7
  __interrupt_vector_8   : { KEEP (*(__interrupt_vector_8 )) } > VECT8
  __interrupt_vector_9   : { KEEP (*(__interrupt_vector_9 )) } > VECT9
  __interrupt_vector_10  : { KEEP (*(__interrupt_vector_10)) } > VECT10
  __interrupt_vector_11  : { KEEP (*(__interrupt_vector_11)) } > VECT11
  __interrupt_vector_12  : { KEEP (*(__interrupt_vector_12)) } > VECT12
  __interrupt_vector_13  : { KEEP (*(__interrupt_vector_13)) } > VECT13
  __interrupt_vector_14  : { KEEP (*(__interrupt_vector_14)) } > VECT14
  __interrupt_vector_15  : { KEEP (*(__interrupt_vector_15)) } > VECT15
  __interrupt_vector_16  : { KEEP (*(__interrupt_vector_16)) } > VECT16
  __interrupt_vector_17  : { KEEP (*(__interrupt_vector_17)) } > VECT17
  __interrupt_vector_18  : { KEEP (*(__interrupt_vector_18)) } > VECT18
  __interrupt_vector_19  : { KEEP (*(__interrupt_vector_19)) } > VECT19
  __interrupt_vector_20  : { KEEP (*(__interrupt_vector_20)) } > VECT20
  __interrupt_vector_21  : { KEEP (*(__interrupt_vector_21)) } > VECT21
  __interrupt_vector_22  : { KEEP (*(__interrupt_vector_22)) } > VECT22
  __interrupt_vector_23  : { KEEP (*(__interrupt_vector_23)) } > VECT23
  __interrupt_vector_24  : { KEEP (*(__interrupt_vector_24)) } > VECT24
  __interrupt_vector_25  : { KEEP (*(__interrupt_vector_25)) } > VECT25
  __interrupt_vector_26  : { KEEP (*(__interrupt_vector_26)) } > VECT26
  __interrupt_vector_27  : { KEEP (*(__interrupt_vector_27)) } > VECT27
  __interrupt_vector_28  : { KEEP (*(__interrupt_vector_28)) } > VECT28
  __interrupt_vector_29  : { KEEP (*(__interrupt_vector_29)) } > VECT29
  __interrupt_vector_30  : { KEEP (*(__interrupt_vector_30)) } > VECT30
  __interrupt_vector_31  : { KEEP (*(__interrupt_vector_31)) } > VECT31
  __interrupt_vector_32  : { KEEP (*(__interrupt_vector_32)) } > VECT32
  __interrupt_vector_33  : { KEEP (*(__interrupt_vector_33)) } > VECT33
  __interrupt_vector_34  : { KEEP (*(__interrupt_vector_34)) } > VECT34
  __interrupt_vector_35  : { KEEP (*(__interrupt_vector_35)) } > VECT35
  __interrupt_vector_36  : { KEEP (*(__interrupt_vector_36)) } > VECT36
  __interrupt_vector_37  : { KEEP (*(__interrupt_vector_37)) } > VECT37
  __interrupt_vector_38  : { KEEP (*(__interrupt_vector_38)) } > VECT38
  __interrupt_vector_39  : { KEEP (*(__interrupt_vector_39)) } > VECT39
  __interrupt_vector_40  : { KEEP (*(__interrupt_vector_40)) } > VECT40
  __interrupt_vector_41  : { KEEP (*(__interrupt_vector_41)) } > VECT41
  __interrupt_vector_42  : { KEEP (*(__interrupt_vector_42)) KEEP (*(__interrupt_vector_rtc)) } > VECT42
  __interrupt_vector_43  : { KEEP (*(__interrupt_vector_43)) KEEP (*(__interrupt_vector_port2)) } > VECT43
  __interrupt_vector_44  : { KEEP (*(__interrupt_vector_44)) KEEP (*(__interrupt_vector_timer2_a1)) } > VECT44
  __interrupt_vector_45  : { KEEP (*(__interrupt_vector_45)) KEEP (*(__interrupt_vector_timer2_a0)) } > VECT45
  __interrupt_vector_46  : { KEEP (*(__interrupt_vector_46)) KEEP (*(__interrupt_vector_usci_b1)) } > VECT46
  __interrupt_vector_47  : { KEEP (*(__interrupt_vector_47)) KEEP (*(__interrupt_vector_usci_a1)) } > VECT47
  __interrupt_vector_48  : { KEEP (*(__interrupt_vector_48)) KEEP (*(__interrupt_vector_port1)) } > VECT48
  __interrupt_vector_49  : { KEEP (*(__interrupt_vector_49)) KEEP (*(__interrupt_vector_timer1_a1)) } > VECT49
  __interrupt_vector_50  : { KEEP (*(__interrupt_vector_50)) KEEP (*(__interrupt_vector_timer1_a0)) } > VECT50
  __interrupt_vector_51  : { KEEP (*(__interrupt_vector_51)) KEEP (*(__interrupt_vector_dma)) } > VECT51
  __interrupt_vector_52  : { KEEP (*(__interrupt_vector_52)) KEEP (*(__interrupt_vector_usb_ubm)) } > VECT52
  __interrupt_vector_53  : { KEEP (*(__interrupt_vector_53)) KEEP (*(__interrupt_vector_timer0_a1)) } > VECT53
  __interrupt_vector_54  : { KEEP (*(__interrupt_vector_54)) KEEP (*(__interrupt_vector_timer0_a0)) } > VECT54
  __interrupt_vector_55  : { KEEP (*(__interrupt_vector_55)) KEEP (*(__interrupt_vector_adc12)) } > VECT55
  __interrupt_vector_56  : { KEEP (*(__interrupt_vector_56)) KEEP (*(__interrupt_vector_usci_b0)) } > VECT56
  __interrupt_vector_57  : { KEEP (*(__interrupt_vector_57)) KEEP (*(__interrupt_vector_usci_a0)) } > VECT57
  __interrupt_vector_58  : { KEEP (*(__interrupt_vector_58)) KEEP (*(__interrupt_vector_wdt)) } > VECT58
  __interrupt_vector_59  : { KEEP (*(__interrupt_vector_59)) KEEP (*(__interrupt_vector_timer0_b1)) } > VECT59
  __interrupt_vector_60  : { KEEP (*(__interrupt_vector_60)) KEEP (*(__interrupt_vector_timer0_b0)) } > VECT60
  __interrupt_vector_61  : { KEEP (*(__interrupt_vector_61)) KEEP (*(__interrupt_vector_comp_b)) } > VECT61
  __interrupt_vector_62  : { KEEP (*(__interrupt_vector_62)) KEEP (*(__interrupt_vector_unmi)) } > VECT62
  __interrupt_vector_63  : { KEEP (*(__interrupt_vector_63)) KEEP (*(__interrupt_vector_sysnmi)) } > VECT63
  
  /*************************************************/
  /***************  NEW PISTIS PART ******************/
  /*************************************************/

  /** This section must be commented out to prevent the application from deciding the starting point */
  /*
  __reset_vector :
  {
    KEEP (*(__interrupt_vector_64))
    KEEP (*(__interrupt_vector_reset))
    KEEP (*(.resetvec))
  } > RESETVEC 
  */

  /** This section collects all of the code sections from the various core files **/
  
  /* Gather all of the TCM code and ROdata */
  .tcm:code :
  {
    PROVIDE (_start = .);
    KEEP (*(.tcm:codeStart)) /* Force secureBoot to be the first function at 0xC400*/
    KEEP (*(.tcm:code))
    KEEP (*(.tcm:rodata))

    /****** lower text ******/
    KEEP (./core/obj/*(.lowtext))
    KEEP (./core/obj/*(.lower.text.* .lower.text))

    /* Store the libraries functions in the TCM code so that they don't get replaced during the secureUpdate. */
    /* We might want to keep them in the untrusted section although we must store the memset, memcpy and other */
    /* functions used by the secure code in the secure code section */
    KEEP (*lib_a-memcpy*) 
    KEEP (*lib_a-memset*) 
    KEEP (*sll*)
    KEEP (*srl*)
    KEEP (*_muldi3*)
    
    KEEP (*lib2divHI*) 
    KEEP (*lib2hw_mul_f5*) 


    /* The following commands are required in absence of the C directive "__attribute__((section()))*/
    /*KEEP(./core/obj/core.o(.*text))*/
    /*KEEP(./core/obj/core.o(.rodata))*/
    /*KEEP(./core/obj/secureUpdate.o(.*text))*/ /* This code might go somewhere else */
    /*KEEP(./core/obj/secureUpdate.o(.rodata))*/ /* This code might go somewhere else */
  } > TCM
  
  .tcm:codeUpper :
  {
    KEEP (*(.tcm:codeUpper))
  } > TCM_UPPER

  /** This section collects the volatile data of PISTIS TCM **/
  .tcm:data : 
  {
    KEEP (*(.tcm:data))
    
    KEEP(./core/obj/*(*.bss))/* This code might go somewhere else */

    KEEP(./core/obj/*(.data))/* This code might go somewhere else */

    KEEP(./core/obj/*(.stack)) /* This code might go somewhere else */
  } > RAM_TCM
  
  /** This section collects all of the sections from the virt_fun core file **/
  .tcm:virt_fun :
  {
    KEEP (*(.virt_fun))
    KEEP (*(*virt_fun))
  } > VIRT_FUN

  /** This section injects the initial TCM entry points in the reset vector **/
  .secure_reset_vector : 
  {
    /* THIS NEEDS TO BE THE FIRST ADDRESS OF THE TCM CODE */
    SHORT(0xc400)
  } > RESETVEC



  /* Store new ISR */

  .TCM_VECTORS :
  {
    SHORT(0xF800) /* Must be synchronised */
    SHORT(0xF808)
    SHORT(0xF810)
    SHORT(0xF818)
    SHORT(0xF820)
    SHORT(0xF828)
    SHORT(0xF830)
    SHORT(0xF838)
    SHORT(0xF840)
    SHORT(0xF848)
    SHORT(0xF850)
    SHORT(0xF858)
    SHORT(0xF860)
    SHORT(0xF868)
    SHORT(0xF870)
    SHORT(0xF878)
    SHORT(0xF880)
    SHORT(0xF888)
    SHORT(0xF890)
    SHORT(0xF898)
    SHORT(0xF8a0)
    SHORT(0xF8a8)
    SHORT(0xF8b0)
    SHORT(0xF8b8)
    SHORT(0xF8c0)
    SHORT(0xF8c8)
    SHORT(0xF8d0)
    SHORT(0xF8d8)
    SHORT(0xF8e0)
    SHORT(0xF8e8)
    SHORT(0xF8f0)
    SHORT(0xF8f8)
    SHORT(0xF900)
    SHORT(0xF908)
    SHORT(0xF910)
    SHORT(0xF918)
    SHORT(0xF920)
    SHORT(0xF928)
    SHORT(0xF930)
    SHORT(0xF938)
    SHORT(0xF940)
    SHORT(0xF948)
    SHORT(0xF950)
    SHORT(0xF958)
    SHORT(0xF960)
    SHORT(0xF968)
    SHORT(0xF970)
    SHORT(0xF978)
    SHORT(0xF980)
    SHORT(0xF988)
    SHORT(0xF990)
    SHORT(0xF998)
    SHORT(0xF9a0)
    SHORT(0xF9a8)
    SHORT(0xF9b0)
    SHORT(0xF9b8)
    SHORT(0xF9c0)
    SHORT(0xF9c8)
    SHORT(0xF9d0)
    SHORT(0xF9d8)
    SHORT(0xF9e0)
    SHORT(0xF9e8)
    SHORT(0xF9f0)

  } > TCM_VECT



  /** Take care of new ISR **/
  .tcm:prt_isr :
  {
    KEEP (*(.prt_isr))
  } > TCM_ISR






  /*** Application Code ****/
  /* This is just for crt0.S and interrupt handlers.  */
  .lowtextApp           :
  {
    . = ALIGN(2);
    /* The following section removes the memset and call start from the file
      if we need them back we need to instrument them! */
    /* KEEP (*(SORT(.crt_*))) */
    KEEP (./app/obj/*(.lowtext))
  } > APP_CODE

  .lower.textApp :
  {
    . = ALIGN(2);
    KEEP (./app/obj/*(.lower.text.* .lower.text))
  } > APP_CODE

  .textApp :
  {
    . = ALIGN(2);
    KEEP (./app/obj/*(.text .stub .text.* .gnu.linkonce.t.*))

    KEEP (./app/obj/*(.text.*personality*))
    /* .gnu.warning sections are handled specially by elf32.em.  */
    *(.gnu.warning)
    *(.interp .hash .dynsym .dynstr .gnu.version*)
    PROVIDE (__etext = .);
    PROVIDE (_etext = .);
    PROVIDE (etext = .);
    . = ALIGN(2);
    KEEP (./app/obj/*(.init))
    KEEP (./app/obj/*(.fini))
    KEEP (./app/obj/*(.tm_clone_table))
  } > APP_CODE

  .upper.textApp :
  {
    . = ALIGN(2);
    KEEP (./app/obj/*(.upper.text.* .upper.text))
  } > APP_CODE

  /** The following sections need to be redirected to the application segments **/

  /*************************************************/
  /***************  end NEW PISTIS PART **************/
  /*************************************************/

  .lower.rodata :
  {
    . = ALIGN(2);
    *(.lower.rodata.* .lower.rodata)
  } > APP_RO

  .rodata :
  {
    . = ALIGN(2);
    *(.plt)
    . = ALIGN(2);
    *(.rodata .rodata.* .gnu.linkonce.r.* .const .const:*)
    *(.rodata1)
    KEEP (*(.gcc_except_table)) *(.gcc_except_table.*)
  } > APP_RO

  /* Note: This is a separate .rodata section for sections which are
     read only but which older linkers treat as read-write.
     This prevents older linkers from marking the entire .rodata
     section as read-write.  */
  .rodata2 : 
  {
    . = ALIGN(2);
    PROVIDE (__preinit_array_start = .);
    KEEP (*(.preinit_array))
    PROVIDE (__preinit_array_end = .);
    . = ALIGN(2);
    PROVIDE (__init_array_start = .);
    KEEP (*(SORT(.init_array.*)))
    KEEP (*(.init_array))
    PROVIDE (__init_array_end = .);
    . = ALIGN(2);
    PROVIDE (__fini_array_start = .);
    KEEP (*(.fini_array))
    KEEP (*(SORT(.fini_array.*)))
    PROVIDE (__fini_array_end = .);
    . = ALIGN(2);
    *(.eh_frame_hdr)
    KEEP (*(.eh_frame))

    /* gcc uses crtbegin.o to find the start of the constructors, so
       we make sure it is first.  Because this is a wildcard, it
       doesn't matter if the user does not actually link against
       crtbegin.o; the linker won't look for a file to match a
       wildcard.  The wildcard also means that it doesn't matter which
       directory crtbegin.o is in.  */
    KEEP (*crtbegin*.o(.ctors))

    /* We don't want to include the .ctor section from from the
       crtend.o file until after the sorted ctors.  The .ctor section
       from the crtend file contains the end of ctors marker and it
       must be last */
    KEEP (*(EXCLUDE_FILE (*crtend*.o ) .ctors))
    KEEP (*(SORT(.ctors.*)))
    KEEP (*(.ctors))

    KEEP (*crtbegin*.o(.dtors))
    KEEP (*(EXCLUDE_FILE (*crtend*.o ) .dtors))
    KEEP (*(SORT(.dtors.*)))
    KEEP (*(.dtors))
  } > APP_RO

  .upper.rodata :
  {
    *(.upper.rodata.* .upper.rodata)
  } > APP_RO

  .data :
  {
    . = ALIGN(2);
    PROVIDE (__datastart = .);
    *(.lower.data.* .lower.data)

    . = ALIGN(2);
    *(.either.data.* .either.data)

    . = ALIGN(2);
    KEEP (*(.jcr))
    *(.data.rel.ro.local) *(.data.rel.ro*)
    *(.dynamic)

    . = ALIGN(2);
    *(.data .data.* .gnu.linkonce.d.*)
    KEEP (*(.gnu.linkonce.d.*personality*))
    SORT(CONSTRUCTORS)
    *(.data1)
    *(.got.plt) *(.got)

    /* We want the small data sections together, so single-instruction offsets
       can access them all, and initialized data all before uninitialized, so
       we can shorten the on-disk segment size.  */
    . = ALIGN(2);
    *(.sdata .sdata.* .gnu.linkonce.s.* D_2 D_1)

    . = ALIGN(2);
    _edata = .;
    PROVIDE (edata = .);
    PROVIDE (__dataend = .);
  } > RAM_APP AT> RAM_APP

  /* Note that crt0 assumes this is a multiple of two; all the
     start/stop symbols are also assumed word-aligned.  */
  PROVIDE(__romdatastart = LOADADDR(.data));
  PROVIDE (__romdatacopysize = SIZEOF(.data));

  .bss :
  {
    . = ALIGN(2);
    PROVIDE (__bssstart = .);
    /**(.lower.bss.* .lower.bss)
    . = ALIGN(2);
    *(.either.bss.* .either.bss)*/
    *(.dynbss)
    *(.sbss .sbss.*)
    *(.bss .bss.* .gnu.linkonce.b.*)
    . = ALIGN(2);
    *(COMMON)
    PROVIDE (__bssend = .);
  } > RAM_APP
  PROVIDE (__bsssize = SIZEOF(.bss));

  /* This section contains data that is not initialised during load
     or application reset.  */
  .noinit (NOLOAD) :
  {
    . = ALIGN(2);
    PROVIDE (__noinit_start = .);
    *(.noinit)
    . = ALIGN(2);
    PROVIDE (__noinit_end = .);
  } > RAM_APP

  /* We create this section so that "end" will always be in the
     RAM region (matching .stack below), even if the .bss
     section is empty.  */
  .heap (NOLOAD) :
  {
    . = ALIGN(2);
    __heap_start__ = .;
    _end = __heap_start__;
    PROVIDE (end = .); 
    KEEP (*(.heap))
    _end = .;
    PROVIDE (end = .);
    /* This word is here so that the section is not empty, and thus
       not discarded by the linker.  The actual value does not matter
       and is ignored.  */
    LONG(0);
    __heap_end__ = .;
    __HeapLimit = __heap_end__;
  } > RAM_APP
  /* WARNING: Do not place anything in RAM here.
     The heap section must be the last section in RAM and the stack
     section must be placed at the very end of the RAM region.  */

  .stack (ORIGIN (RAM_APP) + LENGTH(RAM_APP)) :
  {
    PROVIDE (__stack = .);
    *(.stack)
  }

  

  .infoA     : {} > INFOA              /* MSP430 INFO FLASH MEMORY SEGMENTS */
  .infoB     : {} > INFOB
  .infoC     : {} > INFOC
  .infoD     : {} > INFOD

  /* Make sure that upper data sections are not used.  */
  .upper :
  {
    *(.upper.bss.* .upper.bss)
    *(.upper.data.* .upper.data)
    ASSERT (SIZEOF(.upper) == 0, "This MCU does not support placing read/write data into high memory");
  } > APP_CODE

  /* The rest are all not normally part of the runtime image.  */

  .MSP430.attributes 0 :
  {
    KEEP (*(.MSP430.attributes))
    KEEP (*(.gnu.attributes))
    KEEP (*(__TI_build_attributes))
  }

  /* Stabs debugging sections.  */
  .stab          0 : { *(.stab) }
  .stabstr       0 : { *(.stabstr) }
  .stab.excl     0 : { *(.stab.excl) }
  .stab.exclstr  0 : { *(.stab.exclstr) }
  .stab.index    0 : { *(.stab.index) }
  .stab.indexstr 0 : { *(.stab.indexstr) }
  .comment       0 : { *(.comment) }
  /* DWARF debug sections.
     Symbols in the DWARF debugging sections are relative to the beginning
     of the section so we begin them at 0.  */
  /* DWARF 1.  */
  .debug          0 : { *(.debug) }
  .line           0 : { *(.line) }
  /* GNU DWARF 1 extensions.  */
  .debug_srcinfo  0 : { *(.debug_srcinfo) }
  .debug_sfnames  0 : { *(.debug_sfnames) }
  /* DWARF 1.1 and DWARF 2.  */
  .debug_aranges  0 : { *(.debug_aranges) }
  .debug_pubnames 0 : { *(.debug_pubnames) }
  /* DWARF 2.  */
  .debug_info     0 : { *(.debug_info .gnu.linkonce.wi.*) }
  .debug_abbrev   0 : { *(.debug_abbrev) }
  .debug_line     0 : { *(.debug_line .debug_line.* .debug_line_end ) }
  .debug_frame    0 : { *(.debug_frame) }
  .debug_str      0 : { *(.debug_str) }
  .debug_loc      0 : { *(.debug_loc) }
  .debug_macinfo  0 : { *(.debug_macinfo) }
  /* SGI/MIPS DWARF 2 extensions.  */
  .debug_weaknames 0 : { *(.debug_weaknames) }
  .debug_funcnames 0 : { *(.debug_funcnames) }
  .debug_typenames 0 : { *(.debug_typenames) }
  .debug_varnames  0 : { *(.debug_varnames) }
  /* DWARF 3 */
  .debug_pubtypes 0 : { *(.debug_pubtypes) }
  .debug_ranges   0 : { *(.debug_ranges) }
  /* DWARF Extension.  */
  .debug_macro    0 : { *(.debug_macro) }

  /DISCARD/ : { *(.note.GNU-stack) }

  
}


/****************************************************************************/
/* Include peripherals memory map                                           */
/****************************************************************************/

INCLUDE msp430f5529_symbols.ld

