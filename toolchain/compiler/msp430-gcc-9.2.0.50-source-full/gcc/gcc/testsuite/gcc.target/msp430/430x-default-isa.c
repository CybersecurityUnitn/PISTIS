/* { dg-do compile } */
/* { dg-skip-if "" { *-*-* } { "-mcpu=msp430" } } */
/* { dg-options "-mmcu=msp430foobar -mno-warn-mcu" } */

/* Verify that the default ISA is set to 430X when an MMCU is unrecognized.  */

#ifndef __MSP430X__
#error
#endif
