#include <stdio.h>

#define CHECK_VAL(SYM, VAL) \
  if (SYM != VAL) \
  { \
    printf ("FAIL: " #SYM " value should be " #VAL " not %d\n", SYM); \
    error = 1; \
  }

#define CHECK_ADDR_VAL(ADDR, VAL) \
  if (*ADDR != VAL) \
  { \
    printf ("FAIL: Value at 0x%x should be 0x%x not 0x%x\n", ADDR, VAL, *ADDR); \
    error = 1; \
  } \
  /*else \
    printf ("PASS: Value at 0x%x is 0x%x\n", ADDR, *ADDR); \ */

#define CHECK_ADDR(SYM, ADDR) \
  if (&SYM != (void *)ADDR) \
  { \
    printf ("FAIL: " #SYM " address should be " #ADDR " not 0x%x\n", &SYM); \
    error = 1; \
  }
