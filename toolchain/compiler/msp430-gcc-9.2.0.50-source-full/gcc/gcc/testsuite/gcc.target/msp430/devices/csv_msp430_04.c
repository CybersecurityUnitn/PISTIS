/* { dg-do link } */
/* { dg-skip-if "MCU supports 430 ISA only" { *-*-* } { "-mlarge" "-mcpu=msp430x*" } { "" } } */
/* { dg-msp-options "-mmcu=msp430_04" } */
/* { dg-warning "supports 32bit hardware multiply" "" { target msp430_hwmul_not_32bit } 0 } */

#include "../devices-main.c"
