/* { dg-do link } */
/* { dg-msp-options "-mmcu=msp430_28" } */
/* { dg-warning "supports 430X ISA but -mcpu option is set to 430" "" { target 430_selected } 0 } */
/* { dg-warning "supports f5series hardware multiply" "" { target msp430_hwmul_not_f5 } 0 } */

/* This tests that the devices.csv can be installed into the
   "$TOOLCHAIN_ROOT/msp430-elf/include/devices/" and used to read device data.
   msp430.exp will mark this test unsupported if the above directory does not
   exist.  */

#include "../devices-main.c"
