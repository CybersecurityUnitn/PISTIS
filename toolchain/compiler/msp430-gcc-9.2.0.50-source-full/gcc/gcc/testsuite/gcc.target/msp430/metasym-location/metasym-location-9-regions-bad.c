/* { dg-do link } */
/* { dg-additional-options "-fdata-sections -ffunction-sections -Tflash-and-ram.ld" } */
#include <math.h>
#include "metalib.h"
/* This tests behaviour of regions/wilds when there are distinct ROM/RAM regions.  */

/* RAM (rw)     : ORIGIN = 0x00500, LENGTH = 0x01b00
   ROM (rx)     : ORIGIN = 0x02000, LENGTH = 0x0df00
   .data from 0x500 to 0x1000
   .bss from 0x1000 to 0x2000
   .rodata from 0x3000 to 0x4000
   .text from 0x4000 to 0x5000.  */

int __attribute__((location(0x502))) var_data_in_data = 10;

/* This can't be placed because data is incompatible with the .bss section
   explicitly placed at 0x1000.  */
int __attribute__((location(0x1002))) var_data_in_bss = 11;
/* { dg-message "var_data_in_bss.*overlaps" "" { target { ! msp430_region_upper } } 0 } */
int __attribute__((location(0x3002))) var_data_in_rodata = 12;
/* { dg-warning "'var_data_in_rodata' is not compatible with the memory region 'ROM'" "" { target { *-*-* } } 0 } */
/* { dg-warning "'var_data_in_rodata' has VMA 0x\[0-9a-f\]+ and has not been placed" "" { target { *-*-* } } 0 } */
int __attribute__((location(0x4002))) var_data_in_text = 13;
/* { dg-warning "'var_data_in_text' is not compatible with the memory region 'ROM'" "" { target { *-*-* } } 0 } */
/* { dg-warning "'var_data_in_text' has VMA 0x\[0-9a-f\]+ and has not been placed" "" { target { *-*-* } } 0 } */

long __attribute__((location(0x504))) var_bss_in_data = 0;
long __attribute__((location(0x1004))) var_bss_in_bss;
long __attribute__((location(0x3004))) var_bss_in_rodata = 0;
/* { dg-warning "'var_bss_in_rodata' is not compatible with the memory region 'ROM'" "" { target { *-*-* } } 0 } */
/* { dg-warning "'var_bss_in_rodata' has VMA 0x\[0-9a-f\]+ and has not been placed" "" { target { *-*-* } } 0 } */
long __attribute__((location(0x4004))) var_bss_in_text;
/* { dg-warning "'var_bss_in_text' is not compatible with the memory region 'ROM'" "" { target { *-*-* } } 0 } */
/* { dg-warning "'var_bss_in_text' has VMA 0x\[0-9a-f\]+ and has not been placed" "" { target { *-*-* } } 0 } */

const char __attribute__((location(0x508))) var_rodata_in_data = 21;
const char __attribute__((location(0x1008))) var_rodata_in_bss = 22;
const char __attribute__((location(0x3008))) var_rodata_in_rodata = 23;
/* This can't be placed because rodata is incompatible with the .crt* section
   at the beginning of .text placed at 0x4000.  */
const char __attribute__((location(0x4008))) var_rodata_in_text = 24;
/* { dg-message "var_rodata_in_text.*overlaps" "" { target { *-*-* } } 0 } */
/* rodata can be placed in a .text wild statement however.  */
const char __attribute__((location(0x6000))) var_rodata2_in_text = 25;

float f = 2.4;

void __attribute__((location(0x510))) fn_text_in_data (void) { volatile int i = 10; while (i--); }
/* { dg-warning "'fn_text_in_data' is not compatible with the memory region 'RAM'" "" { target { *-*-* } } 0 } */
/* { dg-warning "'fn_text_in_data' has VMA 0x\[0-9a-f\]+ and has not been placed" "" { target { *-*-* } } 0 } */
void __attribute__((location(0x1010))) fn_text_in_bss (void) { volatile int i = 10; while (i--); }
/* { dg-warning "'fn_text_in_bss' is not compatible with the memory region 'RAM'" "" { target { *-*-* } } 0 } */
/* { dg-warning "'fn_text_in_bss' has VMA 0x\[0-9a-f\]+ and has not been placed" "" { target { *-*-* } } 0 } */
void __attribute__((location(0x3010))) fn_text_in_rodata (void) { volatile int i = 10; while (i--); }
void __attribute__((location(0x4010))) fn_text_in_text (void) { volatile int i = 10; while (i--); }

int
main (void)
{
  int error = 0;
  f = sqrtf(f);

  /* data */
  CHECK_VAL (var_data_in_data, 10);
  CHECK_ADDR (var_data_in_data, 0x502);

  CHECK_VAL (var_data_in_bss, 11);
  CHECK_ADDR (var_data_in_bss, 0x1002);

  CHECK_VAL (var_data_in_rodata, 12);
  CHECK_ADDR (var_data_in_rodata, 0x3002);

  CHECK_VAL (var_data_in_text, 14);
  CHECK_ADDR (var_data_in_text, 0x4002);

  /* bss */
  CHECK_VAL (var_bss_in_data, 0);
  CHECK_ADDR (var_bss_in_data, 0x504);

  CHECK_VAL (var_bss_in_bss, 0);
  CHECK_ADDR (var_bss_in_bss, 0x1004);

  CHECK_VAL (var_bss_in_rodata, 0);
  CHECK_ADDR (var_bss_in_rodata, 0x3004);

  CHECK_VAL (var_bss_in_text, 0);
  CHECK_ADDR (var_bss_in_text, 0x4004);

  /* rodata */
  CHECK_VAL (var_rodata_in_data, 21);
  CHECK_ADDR (var_rodata_in_data, 0x508);

  CHECK_VAL (var_rodata_in_bss, 22);
  CHECK_ADDR (var_rodata_in_bss, 0x1008);

  CHECK_VAL (var_rodata_in_rodata, 23);
  CHECK_ADDR (var_rodata_in_rodata, 0x3008);

  CHECK_VAL (var_rodata_in_text, 24);
  CHECK_ADDR (var_rodata_in_text, 0x4008);

  CHECK_VAL (var_rodata2_in_text, 25);
  CHECK_ADDR (var_rodata2_in_text, 0x6000);

  /* text */
  CHECK_ADDR (fn_text_in_data, 0x510); 
  CHECK_ADDR (fn_text_in_bss, 0x1010); 
  CHECK_ADDR (fn_text_in_rodata, 0x3010); 
  CHECK_ADDR (fn_text_in_text, 0x4010); 

  return error;
}
