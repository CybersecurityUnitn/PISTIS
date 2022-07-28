/* { dg-do run } */
/* { dg-options "-O3 -flto -fdata-sections -ffunction-sections" } */

/* { dg-warning "no valid memory region at address 0xf950 for SMK_LOCATION metasym 'var_bssf'" "" { target { ! msp430_large_memory_model } } 0 } */
/* { dg-warning "no valid memory region at address 0xf510 for SMK_LOCATION metasym 'var_rodataf'" "" { target { ! msp430_large_memory_model } } 0 } */
/* { dg-warning "no valid memory region at address 0xf822 for SMK_LOCATION metasym 'var_uninitf'" "" { target { ! msp430_large_memory_model } } 0 } */
/* { dg-warning "no valid memory region at address 0xf668 for SMK_LOCATION metasym 'var_dataf'" "" { target { ! msp430_large_memory_model } } 0 } */
/* { dg-warning "SMK_LOCATION metasym 'var_bssf' has VMA 0x\[0-9a-f\]+ and has not been placed at address 0xf950" "" { target { ! msp430_large_memory_model } } 0 } */
/* { dg-warning "SMK_LOCATION metasym 'var_rodataf' has VMA 0x\[0-9a-f\]+ and has not been placed at address 0xf510" "" { target { ! msp430_large_memory_model } } 0 } */
/* { dg-warning "SMK_LOCATION metasym 'var_uninitf' has VMA 0x\[0-9a-f\]+ and has not been placed at address 0xf822" "" { target { ! msp430_large_memory_model } } 0 } */
/* { dg-warning "SMK_LOCATION metasym 'var_dataf' has VMA 0x\[0-9a-f\]+ and has not been placed at address 0xf668" "" { target { ! msp430_large_memory_model } } 0 } */

/* Fill the whole memory range with small functions and data.
   430x:
   RAM (w) : ORIGIN = 0x00500, LENGTH = 0x0eb00
   -mlarge:
   RAM (rw)     : ORIGIN = 0x00500, LENGTH = 0x01b00
   ROM (rx)     : ORIGIN = 0x02000, LENGTH = 0x0df00
   Vectors from 0xFFC0 to 0x1000
   HIFRAM (rw)  : ORIGIN = 0x10000, LENGTH = 0x80000
   HIROM (rx)   : ORIGIN = 0x90000, LENGTH = 0x70000.
   Loop over all the address and check their values.  */

#include <string.h>
#include <stdio.h>
#include "metalib.h"

/* If we add 0x1000 to 0xFxxx we will wrap round to 0x0xxx and loop forever.  */
#define LOOP_OVER_BSS_ADDR \
  __UINTPTR_TYPE__ bss_addr; \
  for (bss_addr = 0x950; bss_addr < 0xf950; bss_addr += 0x1000)

#define LOOP_OVER_UNINIT_ADDR \
  __UINTPTR_TYPE__ uninit_addr; \
  for (uninit_addr = 0x822; uninit_addr < 0xf822; uninit_addr += 0x1000)

#define LOOP_OVER_DATA_ADDR \
  __UINTPTR_TYPE__ data_addr; \
  for (data_addr = 0x668; data_addr < 0xf668; data_addr += 0x1000)

#define LOOP_OVER_RODATA_ADDR \
  __UINTPTR_TYPE__ rodata_addr; \
  for (rodata_addr = 0x510; rodata_addr < 0xf510; rodata_addr += 0x1000)

void __attribute__((used, naked, section(".crt_0042")))
write_bss (void)
{
  /* We can't just write 0xFF over the whole memory range as that will trash
     any loaded functions/data.  */
  LOOP_OVER_BSS_ADDR
  {
    memset ((void *)bss_addr, 0xff, 0x2);
  }
  LOOP_OVER_UNINIT_ADDR
  {
    memset ((void *)uninit_addr, 0xff, 0x2);
  }
}

#define FN_TEMPLATE \
  volatile int i = 0; \
  while (i++);


/* Addr ending in 0x20 or 0x22 are bss variables.
 * Addr ending in 0x68 are data variables with a value of the high bits of their
 * 16-bit address, - 1 i.e. VAL = (ADDR & 0xFF00) - 1.  */

int normal_bss[22] = {0};

#define DECLARE_VAR(ADDR,NUM) \
  int __attribute__((retain, location(ADDR+0x668))) var_data ## NUM = ((((ADDR+0x668) & 0xFF00) - 0x100) >> 8); \
  int __attribute__((retain, location(ADDR+0x950))) var_bss ## NUM = 0; \
  int __attribute__((retain, location(ADDR+0x822))) var_uninit ## NUM; \
  const int __attribute__((retain, location(ADDR+0x510))) var_rodata ## NUM = ((((ADDR+0x510) & 0xFF00) - 0x200) >> 8); \


DECLARE_VAR (0x0, 0)
DECLARE_VAR (0x1000, 1)
DECLARE_VAR (0x2000, 2)
DECLARE_VAR (0x3000, 3)
DECLARE_VAR (0x4000, 4)
DECLARE_VAR (0x5000, 5)
DECLARE_VAR (0x6000, 6)
DECLARE_VAR (0x7000, 7)
DECLARE_VAR (0x8000, 8)
DECLARE_VAR (0x9000, 9)
DECLARE_VAR (0xa000, a)
DECLARE_VAR (0xb000, b)
DECLARE_VAR (0xc000, c)
DECLARE_VAR (0xd000, d)
DECLARE_VAR (0xe000, e)
DECLARE_VAR (0xf000, f)
/*DECLARE_VAR (0x10000, 10)*/

#define DECLARE_FN(ADDR,NUM) \
  void __attribute__((retain, location(ADDR+0x28a))) fn_global ## NUM (void) { FN_TEMPLATE }

/* FIXME algorithm is not sophisticated enough to handle this yet.  */
#if 0
DECLARE_FN (0x0400, 0)
DECLARE_FN (0x1000, 1)
DECLARE_FN (0x2000, 2)
DECLARE_FN (0x3000, 3)
DECLARE_FN (0x4000, 4)
DECLARE_FN (0x5000, 5)
DECLARE_FN (0x6000, 6)
DECLARE_FN (0x7000, 7)
DECLARE_FN (0x8000, 8)
DECLARE_FN (0x9000, 9)
DECLARE_FN (0xa000, a)
DECLARE_FN (0xb000, b)
DECLARE_FN (0xc000, c)
DECLARE_FN (0xd000, d)
/*DECLARE_FN (0xe000, e)*/
#endif

/* Place stuff at the end of the memory region.  */
#ifdef __MSP430X_LARGE__
#define FN_GLOBAL_ADDR 0xFE00
#else
#define FN_GLOBAL_ADDR 0x550
#endif

void __attribute__((location(FN_GLOBAL_ADDR)))
fn_global (void)
{
  while (--var_data0);
}

#ifdef __MSP430X_LARGE__
#define FN_STATIC_ADDR 0x2740
#else
#define FN_STATIC_ADDR 0x740
#endif

static void __attribute__((retain, location(FN_STATIC_ADDR)))
fn_static (void)
{
  while (--var_uninit0 != -10);
}

int main (void)
{
  int error = 0;

  LOOP_OVER_BSS_ADDR
  {
#ifndef __MSP430X_LARGE__
    if (bss_addr > 0xFFFF)
      continue;
#endif
    CHECK_ADDR_VAL ((int *)bss_addr, 0);
  }

  LOOP_OVER_UNINIT_ADDR
  {
#ifndef __MSP430X_LARGE__
    if (uninit_addr > 0xFFFF)
      continue;
#endif
    CHECK_ADDR_VAL ((int *)uninit_addr, 0);
  }

  LOOP_OVER_DATA_ADDR
  {
#ifndef __MSP430X_LARGE__
    if (data_addr > 0xFFFF)
      continue;
#endif
    int val = (((data_addr & 0xFF00) - 0x100) >> 8);
    CHECK_ADDR_VAL ((int *)data_addr, val);
  }

  LOOP_OVER_RODATA_ADDR
  {
#ifndef __MSP430X_LARGE__
    if (rodata_addr > 0xFFFF)
      continue;
#endif
    int val = (((rodata_addr & 0xFF00) - 0x200) >> 8);
    CHECK_ADDR_VAL ((int *)rodata_addr, val);
  }

  CHECK_VAL (var_data0, 0x5);
  CHECK_ADDR (var_data0, 0x668);

  CHECK_VAL (var_uninit0, 0);
  CHECK_ADDR (var_uninit0, 0x822);

  CHECK_VAL (var_bss0, 0);
  CHECK_ADDR (var_bss0, 0x950);

  CHECK_ADDR (fn_global, FN_GLOBAL_ADDR);

  fn_global ();
  CHECK_VAL (var_data0, 0);

  __asm__ ("CALL%Q0 %0" : : "i" (FN_STATIC_ADDR));
  CHECK_VAL (var_uninit0, -10);

  if (error)
    return 1;
  return 0;
}
