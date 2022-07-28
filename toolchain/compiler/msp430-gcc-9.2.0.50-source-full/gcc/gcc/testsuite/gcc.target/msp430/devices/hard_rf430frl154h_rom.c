/* { dg-do link } */
/* { dg-skip-if "MCU supports 430 ISA only" { *-*-* } { "-mlarge" "-mcpu=msp430x*" } { "" } } */
/* { dg-msp-options "-mmcu=rf430frl154h_rom" } */
/* { dg-warning "does not have hardware multiply" "" { target msp430_hwmul_not_none } 0 } */

/* revision=0, hwmpy=0  */
#include "../devices-main.c"
