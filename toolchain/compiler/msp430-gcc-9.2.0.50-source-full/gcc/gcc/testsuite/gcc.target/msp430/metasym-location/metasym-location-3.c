/* { dg-do run } */
/* { dg-options "-fdata-sections -ffunction-sections -g -Os -Wl,-u,_printf_float" } */

#include <math.h>
#include <string.h>
#include <stdio.h>
#include "metalib.h"

void __attribute__((used, naked, section(".crt_0042")))
write_bss (void)
{
  /* We can't just write 0xFFFF over the whole memory range as that will trash
     any loaded functions/data.  */
  memset ((void *)0x600, 0xffff, 0x6); /* var_bss */
  memset ((void *)0x606, 0xffff, 0x2); /* var_bss2 */
}

const int __attribute__((location(0x606))) var_rodata[2] = { 5, 4 };
int __attribute__((location(0x600))) var_bss[3] = {0};
int __attribute__((location(0x60a))) var_bss2 = 0;
int __attribute__((location(0x614))) var_data = 2;
float __attribute__((location(0x800))) var_float = 2.1;
long __attribute__((location(0x750))) var_long = 0xFFFFAABB;
long __attribute__((location(0x804))) var_long2 = 0xAABBFFFF;
int normal_bss[20] = { 0 };

int main (void)
{
  int error = 0;
  CHECK_ADDR (var_rodata, 0x606);
  CHECK_VAL (var_rodata[0], 5);

  CHECK_ADDR (var_bss, 0x600);
  CHECK_VAL (var_bss[0], 0);

  CHECK_ADDR (var_bss2, 0x60a);
  CHECK_VAL (var_bss2, 0);

  CHECK_ADDR (var_data, 0x614);
  CHECK_VAL (var_data, 2);

  CHECK_ADDR (var_float, 0x800);

  CHECK_ADDR (var_long, 0x750);
  CHECK_VAL (var_long, 0xFFFFAABB);

  CHECK_ADDR (var_long2, 0x804);
  CHECK_VAL (var_long2, 0xAABBFFFF);

  float res = powf (var_float, 4.0);
  if (!(res > 19.0 && res < 20.0))
  {
    printf ("FAIL: powf (var_float, 4.0) != 19.4 RESULT is %f\n", res);
    error = 1;
  }

  if (error)
    return 1;
  return 0;
}
