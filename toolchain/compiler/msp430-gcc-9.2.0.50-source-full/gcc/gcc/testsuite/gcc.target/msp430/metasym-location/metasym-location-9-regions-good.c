/* { dg-do run } */
/* { dg-additional-options "-fdata-sections -ffunction-sections -Tflash-and-ram.ld" } */

#include <math.h>
#include <string.h>
#include "metalib.h"
/* This tests behaviour of regions/wilds when there are distinct ROM/RAM regions.
   This is the similar to 9-regions-bad.c except we removed the symbols which
   cause link errors so we can run the test.  */

/* RAM (rw)     : ORIGIN = 0x00500, LENGTH = 0x01b00
   ROM (rx)     : ORIGIN = 0x02000, LENGTH = 0x0df00
   .data from 0x500 to 0x1000
   .bss from 0x1000 to 0x2000
   .rodata from 0x3000 to 0x4000
   .text from 0x4000 to 0x5000.  */

void __attribute__((used, naked, section(".crt_0042")))
write_bss (void)
{
  memset ((void *)0x504, 0xff, 0x2); /* var_bss_in_data */
  memset ((void *)0x1004, 0xff, 0x2); /* var_bss_in_bss*/
}

int __attribute__((location(0x502))) var_data_in_data = 10;

long __attribute__((location(0x504))) var_bss_in_data = 0;
long __attribute__((location(0x1004))) var_bss_in_bss;

const char __attribute__((location(0x508))) var_rodata_in_data = 21;
const char __attribute__((location(0x3008))) var_rodata_in_rodata = 23;
const char __attribute__((location(0x6000))) var_rodata2_in_text = 25;

float f = 2.4;

void __attribute__((location(0x3010))) fn_text_in_rodata (void) { volatile int i = 10; while (i--); }
void __attribute__((location(0x4110))) fn_text_in_text (void) { volatile int i = 10; while (i--); }

int
main (void)
{
  int error = 0;
  f = sqrtf(f);

  /* data */
  CHECK_VAL (var_data_in_data, 10);
  CHECK_ADDR (var_data_in_data, 0x502);

  /* bss */
  CHECK_VAL (var_bss_in_data, 0);
  CHECK_ADDR (var_bss_in_data, 0x504);

  CHECK_VAL (var_bss_in_bss, 0);
  CHECK_ADDR (var_bss_in_bss, 0x1004);

  /* rodata */
  CHECK_VAL (var_rodata_in_data, 21);
  CHECK_ADDR (var_rodata_in_data, 0x508);

  CHECK_VAL (var_rodata_in_rodata, 23);
  CHECK_ADDR (var_rodata_in_rodata, 0x3008);

  CHECK_VAL (var_rodata2_in_text, 25);
  CHECK_ADDR (var_rodata2_in_text, 0x6000);

  /* text */
  CHECK_ADDR (fn_text_in_rodata, 0x3010); 
  CHECK_ADDR (fn_text_in_text, 0x4110); 

  return error;
}
