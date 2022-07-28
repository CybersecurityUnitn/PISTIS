/* { dg-do link } */
/* { dg-msp-options "-mmcu=msp430f5529" } */
/* { dg-warning "supports 430X ISA but -mcpu option is set to 430" "" { target 430_selected } 0 } */
/* { dg-warning "supports f5series hardware multiply" "" { target msp430_hwmul_not_f5 } 0 } */
/* { dg-warning "Device msp430f5529 not found in devices.csv" "" { target msp430-*-* } 0 } */
/* { dg-message "hard-coded device data" "" { target msp430-*-* } 0 } */

#include "../devices-main.c"
