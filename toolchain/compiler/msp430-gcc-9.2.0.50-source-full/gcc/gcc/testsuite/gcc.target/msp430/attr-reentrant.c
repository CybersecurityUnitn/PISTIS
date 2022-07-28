/* { dg-do compile } */
/* { dg-final { scan-assembler-times "start of prologue.*DINT.*end of prologue" 1 } } */
/* { dg-final { scan-assembler-times "start of epilogue.*EINT.*RET" 1 } } */

extern int a;

void __attribute__((reentrant))
reentrant_fn(void)
{
  while(a);
}
