/* { dg-do run } */
/* { dg-options "-fdata-sections -ffunction-sections" } */

#include <string.h>
#include <stdio.h>
#include "metalib.h"

void __attribute__((used, naked, section(".crt_0042")))
write_bss (void)
{
  /* We can't just write 0xFFFF over the whole memory range as that will trash
     any loaded functions/data.  */
  memset ((void *)0x520, 0xffff, 0x4); /* var_bss and var_uninit */
  memset ((void *)0x730, 0xffff, 0x2); /* var_bss2 */
}

int normal_bss[22] = {0};

int __attribute__((location(0x666))) var_data = 2;
int __attribute__((location(0x522))) var_uninit;
int __attribute__((location(0x520))) var_bss = 0;
int __attribute__((location(0x730))) var_bss2 = 0;

#ifdef __MSP430X_LARGE__
#define FN_GLOBAL_ADDR 0x2550
#else
#define FN_GLOBAL_ADDR 0x550
#endif

void __attribute__((location(FN_GLOBAL_ADDR)))
fn_global (void)
{
  while (--var_data);
}

#ifdef __MSP430X_LARGE__
#define FN_STATIC_ADDR 0x2740
#else
#define FN_STATIC_ADDR 0x740
#endif

static void __attribute__((location(FN_STATIC_ADDR)))
fn_static (void)
{
  while (--var_uninit != -10);
}

int main (void)
{
  int error = 0;
  CHECK_VAL (var_data, 2);
  CHECK_ADDR (var_data, 0x666);

  CHECK_VAL (var_uninit, 0);
  CHECK_ADDR (var_uninit, 0x522);

  CHECK_VAL (var_bss, 0);
  CHECK_ADDR (var_bss, 0x520);

  CHECK_VAL (var_bss2, 0);
  CHECK_ADDR (var_bss2, 0x730);

  CHECK_ADDR (fn_global, FN_GLOBAL_ADDR);
  CHECK_ADDR (fn_static, FN_STATIC_ADDR);

  fn_global ();
  CHECK_VAL (var_data, 0);

  fn_static ();
  CHECK_VAL (var_uninit, -10);

  if (error)
    return 1;
  return 0;
}
