/* { dg-do link } */
/* { dg-msp-options "-mmcu=msp430_28" } */
/* { dg-warning "supports 430X ISA but -mcpu option is set to 430" "" { target 430_selected } 0 } */
/* { dg-warning "supports f5series hardware multiply" "" { target msp430_hwmul_not_f5 } 0 } */

/* This tests that the -mdevices-csv-loc option can be used to specify the path
   to devices.csv.
   The option is passed in msp430.exp, rather than in the dg-msp-options
   directive above, as the full path to devices.csv is not known at this
   point.  */

#include "../devices-main.c"
