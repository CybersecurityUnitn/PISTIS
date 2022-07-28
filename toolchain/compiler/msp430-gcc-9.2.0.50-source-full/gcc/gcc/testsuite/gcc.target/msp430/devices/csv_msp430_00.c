/* { dg-do link } */
/* { dg-skip-if "MCU supports 430 ISA only" { *-*-* } { "-mlarge" "-mcpu=msp430x*" } { "" } } */
/* { dg-msp-options "-mmcu=msp430_00" } */
/* { dg-warning "does not have hardware multiply" "" { target msp430_hwmul_not_none } 0 } */

#include "../devices-main.c"
