/* { dg-do run } */
/* { dg-options "-fdata-sections -ffunction-sections" } */

#include <stdio.h>
#include <string.h>
#include <math.h>
#include "metalib.h"

void __attribute__((used, naked, section(".crt_0042")))
write_bss (void)
{
  memset ((void *)0x720, 0xffff, 0x2); /* var_bss */
}

int normal_bss[22] = {0};

int __attribute__((location(0x666))) var_data = 2;
int __attribute__((location(0x720))) var_bss = 0;
float __attribute__((location(0x900))) var_float = 5.5;
float __attribute__((location(0x1000))) var_float2 = 6.5; /* This will get silently gc'ed.  */

#ifdef __MSP430X_LARGE__
#define FN_GLOBAL_ADDR 0x2550
#else
#define FN_GLOBAL_ADDR 0x550
#endif

void __attribute__((location(FN_GLOBAL_ADDR)))
fn_global (void)
{
  while (var_data--);
}

#ifdef __MSP430X_LARGE__
#define FN_STATIC_ADDR 0x2740
#else
#define FN_STATIC_ADDR 0x740
#endif

static void __attribute__((location(FN_STATIC_ADDR)))
fn_static (void)
{
  while (var_data-- != -10);
}

int main (void)
{
  int error = 0;
  CHECK_VAL (var_data, 2);
  CHECK_ADDR (var_data, 0x666);

  CHECK_VAL (var_bss, 0);
  CHECK_ADDR (var_bss, 0x720);

  CHECK_ADDR (fn_global, FN_GLOBAL_ADDR);
  CHECK_ADDR (fn_static, FN_STATIC_ADDR);
  sqrtf (var_float);

  if (error)
    return 1;
  return 0;
}
