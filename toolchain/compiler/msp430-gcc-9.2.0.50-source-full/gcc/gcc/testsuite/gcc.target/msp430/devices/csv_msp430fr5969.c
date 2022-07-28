/* { dg-do link } */
/* { dg-skip-if "MCU supports 430 ISA only" { *-*-* } { "-mlarge" "-mcpu=msp430x*" } { "" } } */
/* { dg-msp-options "-mmcu=msp430fr5969" } */
/* MSP430FR5969 has msp430x ISA and f5series hwmult in the hard-coded data,
   check that the different values for this device in devices.csv override it.
   */
/* { dg-warning "does not have hardware multiply" "" { target msp430_hwmul_not_none } 0 } */


#include "../devices-main.c"
