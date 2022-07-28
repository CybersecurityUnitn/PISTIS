/* { dg-do compile } */
/* { dg-final { scan-assembler-not "prologue" } } */
/* { dg-final { scan-assembler-not "epilogue" } } */

extern int a;

void __attribute__((naked))
naked_fn(void)
{
  while(a);
}
