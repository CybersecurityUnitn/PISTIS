/* { dg-do compile } */
/* { dg-skip-if "" { *-*-* } { "-mcpu=*" "-mmcu=*" } { "" } } */
/* { dg-options "-mcpu=430xv2" } */

/* Verify that the alternate way of selecting the 430XV2 ISA (i.e. with the
   argument "430xv2" instead of "msp430xv2") successfully selects the correct
   ISA.  430xv2 has no meaningful effect on codegen, so just test for 430X.  */

#ifndef __MSP430X__
#error
#endif

