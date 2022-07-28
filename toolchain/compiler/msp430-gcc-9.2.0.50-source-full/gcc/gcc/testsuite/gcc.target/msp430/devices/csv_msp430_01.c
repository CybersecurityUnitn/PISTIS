/* { dg-do link } */
/* { dg-skip-if "MCU supports 430 ISA only" { *-*-* } { "-mlarge" "-mcpu=msp430x*" } { "" } } */
/* { dg-msp-options "-mmcu=msp430_01" } */
/* { dg-warning "supports 16bit hardware multiply" "" { target msp430_hwmul_not_16bit } 0 } */

#include "../devices-main.c"
