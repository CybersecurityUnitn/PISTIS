/* { dg-do link } */
/* { dg-skip-if "" { *-*-* } { -mcpu=msp430 } } */
/* { dg-options "-mlarge -mcode-region=upper" } */

#define NO_REGION_ATTRIBUTES
#include "cpux-insns.c"

char use_qi(char a)
{
  while(a);
  return a;
}

int use_hi(int a)
{
  while(a);
  return a;
}

long use_si(long a)
{
  while(a);
  return a;
}

int
main (void)
{
  while(1);
  return 0;
}
