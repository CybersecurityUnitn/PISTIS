/* { dg-do compile } */
/* { dg-options "-O2 -fipa-icf-functions" } */
/* { dg-final { scan-assembler-not "CALL\t#isr" } } */
/* { dg-final { scan-assembler-not "CALLA\t#isr" } } */

/* Test that identical functions marked with the interrupt attribute do not get
   folded by ipa-icf.  Interrupt functions have different calling conventions
   to regular functions and must not be folded.  */

int a;

void __attribute__((interrupt))
isr1 (void)
{
  a = 10;
}

void __attribute__((interrupt))
isr2 (void)
{
  a = 10;
}
