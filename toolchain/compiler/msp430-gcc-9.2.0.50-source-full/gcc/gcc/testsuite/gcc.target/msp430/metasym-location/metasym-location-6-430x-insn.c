/* { dg-do run } */
/* { dg-final { scan-assembler "MOV.W\t&low_mem" } } */
/* { dg-final { scan-assembler "MOVX.W\t&high_mem" } } */
/* { dg-skip-if "" { *-*-* } { "-mcpu=msp430" "-mdata-region=*" } } */
/* { dg-options "-fdata-sections -mlarge -save-temps" } */

#include "metalib.h"

int __attribute__((location(0x500))) low_mem = 2;
int __attribute__((location(0x11000))) high_mem = 4;

void
foo (void)
{
  low_mem = 2 * low_mem;
  high_mem = 3 * high_mem;
}

int
main (void)
{
  int error = 0;
  foo ();
  CHECK_VAL (low_mem, 4);
  CHECK_ADDR (low_mem, 0x500);
  CHECK_VAL (high_mem, 12);
  CHECK_ADDR (high_mem, 0x11000);
  return error;
}
