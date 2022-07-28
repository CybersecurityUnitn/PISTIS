/* { dg-do run } */
/* { dg-additional-options "-fdata-sections -ffunction-sections -Tfram.ld" } */
#include <string.h>
#include <math.h>
#include "metalib.h"
/* This tests behaviour of regions/wilds when there is a single FRAM region,
   so there are no region incompatibilities.
   This is similar to 10-regions-bad.c except we've removed the variables which cause
   overlapping LMA warnings, so the test can be run.  */

/* FRAM (rwx)   : ORIGIN = 0x00500, LENGTH = 0x0ea00
   .data from 0x500 to 0x1000
   .bss from 0x1000 to 0x2000
   .rodata from 0x3000 to 0x4000
   .text from 0x4000 to 0x5000.  */

void __attribute__((used, naked, section(".crt_0042")))
write_bss (void)
{
  memset ((void *)0x504, 0xff, 0x4); /* var_bss_in_data */
  memset ((void *)0x1004, 0xff, 0x4); /* var_bss_in_bss */
  memset ((void *)0x3004, 0xff, 0x4); /* var_bss_in_rodata */
  memset ((void *)0x40e4, 0xff, 0x4); /* var_bss_in_text */
}

int __attribute__((location(0x502))) var_data_in_data = 10;

int __attribute__((location(0x3002))) var_data_in_rodata = 12;
int __attribute__((location(0x50a2))) var_data_in_text = 13;

long __attribute__((location(0x504))) var_bss_in_data = 0;
long __attribute__((location(0x1004))) var_bss_in_bss;
long __attribute__((location(0x3004))) var_bss_in_rodata = 0;
long __attribute__((location(0x40e4))) var_bss_in_text;

const char __attribute__((location(0x508))) var_rodata_in_data = 21;
const char __attribute__((location(0x1098))) var_rodata_in_bss = 22;
const char __attribute__((location(0x3008))) var_rodata_in_rodata = 23;
/* rodata can be placed in a .text wild statement however.  */
const char __attribute__((location(0x6000))) var_rodata2_in_text = 25;

float f = 2.4;

void __attribute__((location(0x510))) fn_text_in_data (void) { volatile int i = 10; while (i--); }
void __attribute__((location(0x1020))) fn_text_in_bss (void) { volatile int i = 10; while (i--); }
void __attribute__((location(0x3010))) fn_text_in_rodata (void) { volatile int i = 10; while (i--); }
void __attribute__((location(0x40f0))) fn_text_in_text (void) { volatile int i = 10; while (i--); }

int
main (void)
{
  int error = 0;
  f = sqrtf(f);

  /* data */
  CHECK_VAL (var_data_in_data, 10);
  CHECK_ADDR (var_data_in_data, 0x502);

  CHECK_VAL (var_data_in_rodata, 12);
  CHECK_ADDR (var_data_in_rodata, 0x3002);

  CHECK_VAL (var_data_in_text, 13);
  CHECK_ADDR (var_data_in_text, 0x50a2);

  /* bss */
  CHECK_VAL (var_bss_in_data, 0);
  CHECK_ADDR (var_bss_in_data, 0x504);

  CHECK_VAL (var_bss_in_bss, 0);
  CHECK_ADDR (var_bss_in_bss, 0x1004);

  CHECK_VAL (var_bss_in_rodata, 0);
  CHECK_ADDR (var_bss_in_rodata, 0x3004);

  CHECK_VAL (var_bss_in_text, 0);
  CHECK_ADDR (var_bss_in_text, 0x40e4);

  /* rodata */
  CHECK_VAL (var_rodata_in_data, 21);
  CHECK_ADDR (var_rodata_in_data, 0x508);

  CHECK_VAL (var_rodata_in_bss, 22);
  CHECK_ADDR (var_rodata_in_bss, 0x1098);

  CHECK_VAL (var_rodata_in_rodata, 23);
  CHECK_ADDR (var_rodata_in_rodata, 0x3008);

  CHECK_VAL (var_rodata2_in_text, 25);
  CHECK_ADDR (var_rodata2_in_text, 0x6000);

  /* text */
  CHECK_ADDR (fn_text_in_data, 0x510); 
  CHECK_ADDR (fn_text_in_bss, 0x1020); 
  CHECK_ADDR (fn_text_in_rodata, 0x3010); 
  CHECK_ADDR (fn_text_in_text, 0x40f0); 

  return error;
}
