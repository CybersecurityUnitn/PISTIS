/* { dg-do run } */
/* { dg-additional-options "-fdata-sections -ffunction-sections -Tflash-and-ram.ld" } */
#include "metalib.h"

#ifdef __MSP430F5529__
#define ram_start 0x2400
#else
#define ram_start 0x500
#define MSP430_SIM 1
#endif

int __attribute__((location(ram_start + 0x010))) var_data1 = 0x1234;
int __attribute__((location(ram_start + 0x0a0))) var_data2 = 0x2345;
int __attribute__((location(ram_start + 0x110))) var_data3 = 0x3456;
int __attribute__((location(ram_start + 0x1a0))) var_data4 = 0x4567;
int __attribute__((location(ram_start + 0x2a0))) var_data5 = 0x5678;
int __attribute__((location(ram_start + 0x12a0))) var_data6 = 0x6789;

int __attribute__((location(ram_start + 0x014))) var_bss1;
int __attribute__((location(ram_start + 0x0a4))) var_bss2;
int __attribute__((location(ram_start + 0x114))) var_bss3;
int __attribute__((location(ram_start + 0x1a4))) var_bss4;
int __attribute__((location(ram_start + 0x2a4))) var_bss5;
int __attribute__((location(ram_start + 0x12a4))) var_bss6;

/* Try with each of these disabled to tweak bss size.  */
int __attribute__((retain)) normal_bss[20];
int __attribute__((retain)) normal_data[20] = { 1 };

int __attribute__((retain)) normal_bss2[40];
int __attribute__((retain)) normal_data2[40] = { 2 };

int __attribute__((retain)) normal_bss3[10];
int __attribute__((retain)) normal_data3[10] = { 3 };

int
main (void)
{
  int error = 0;
  CHECK_VAL (var_data1, 0x1234);
  CHECK_ADDR (var_data1, ram_start + 0x010);

  CHECK_VAL (var_data2, 0x2345);
  CHECK_ADDR (var_data2, ram_start + 0x0a0);

  CHECK_VAL (var_data3, 0x3456);
  CHECK_ADDR (var_data3, ram_start + 0x110);

  CHECK_VAL (var_data4, 0x4567);
  CHECK_ADDR (var_data4, ram_start + 0x1a0);

  CHECK_VAL (var_data5, 0x5678);
  CHECK_ADDR (var_data5, ram_start + 0x2a0);

  CHECK_VAL (var_data6, 0x6789);
  CHECK_ADDR (var_data6, ram_start + 0x12a0);

  CHECK_VAL (var_bss1, 0);
  CHECK_ADDR (var_bss1, ram_start + 0x014);

  CHECK_VAL (var_bss2, 0);
  CHECK_ADDR (var_bss2, ram_start + 0x0a4);

  CHECK_VAL (var_bss3, 0);
  CHECK_ADDR (var_bss3, ram_start + 0x114);

  CHECK_VAL (var_bss4, 0);
  CHECK_ADDR (var_bss4, ram_start + 0x1a4);

  CHECK_VAL (var_bss5, 0);
  CHECK_ADDR (var_bss5, ram_start + 0x2a4);

  CHECK_VAL (var_bss6, 0);
  CHECK_ADDR (var_bss6, ram_start + 0x12a4);

#ifndef MSP430_SIM
  if (error)
    printf ("FAIL\n");
  else
    printf ("PASS\n");
#endif

  return error;
}
