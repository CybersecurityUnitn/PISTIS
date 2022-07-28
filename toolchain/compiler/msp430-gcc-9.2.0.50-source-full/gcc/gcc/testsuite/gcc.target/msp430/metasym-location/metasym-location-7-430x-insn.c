/* { dg-do run } */
/* { dg-final { scan-assembler "MOV.W\t&low_mem" } } */
/* { dg-final { scan-assembler "MOVX.W\t&high_mem" } } */
/* { dg-final { scan-assembler-not "MOVX.W\t&low_mem" } } */
/* { dg-final { scan-assembler-not "MOV.W\t&high_mem" } } */
/* { dg-skip-if "" { *-*-* } { "-mcpu=msp430" "-mdata-region=*" } } */
/* { dg-options "-ffunction-sections -fdata-sections -mlarge -save-temps" } */
/* { dg-warning ".foo. is not compatible with the memory region 'HIFRAM' containing address 0x15000" "" { target *-*-* } 0 } */
/* { dg-warning "'foo' has VMA 0x\[0-9a-f\]+ and has not been placed at address 0x15000" "" { target *-*-* } 0 } */

#include "metalib.h"

int __attribute__((location(0x500))) low_mem_data = 2;
int __attribute__((location(0x506))) low_mem_bss = 0;
int __attribute__((location(0x510))) low_mem_uninit[10];
const int __attribute__((location(0x550))) low_mem_rodata[10] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 } ;

int __attribute__((location(0x11000))) high_mem_data = 4;
int __attribute__((location(0x16000))) high_mem_arr[10] = { 2, 4, 6, 8, 10, 12, 14, 16, 18, 20 };
int __attribute__((location(0x17000))) high_mem_bss[10] = { 0 };
const int __attribute__((location(0x91000))) high_mem_results[10] = { 2, 8, 18, 32, 50, 72, 98, 128, 162, 200 };

void __attribute__((location(0x15000)))
foo (void)
{
  low_mem_data = 2 * low_mem_data;
  high_mem_data = 3 * high_mem_data;
}

int __attribute__((location(0x90000)))
bar (void)
{
  int i;
  int error = 0;
  for (int i = 0; i < 10; i++)
  {
    high_mem_bss[i] = low_mem_rodata[i] * high_mem_arr[i];
    CHECK_VAL (high_mem_bss[i], high_mem_results[i]);
  }
  return error;
}

int
main (void)
{
  int error = 0;

  foo ();
  CHECK_VAL (low_mem_data, 4);
  CHECK_ADDR (low_mem_data, 0x500);
  CHECK_VAL (high_mem_data, 12);
  CHECK_ADDR (high_mem_data, 0x11000);

  CHECK_ADDR (bar, 0x90000);
  error = bar ();
  return error;
}
