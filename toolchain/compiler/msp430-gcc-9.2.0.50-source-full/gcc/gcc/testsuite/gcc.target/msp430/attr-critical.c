/* { dg-do compile } */
/* { dg-final { scan-assembler-times "start of prologue.*PUSH\\s+SR.*DINT.*end of prologue" 1 } } */
/* { dg-final { scan-assembler-times "start of epilogue.*POP\\s+SR.*RET" 1 } } */

extern int a;

void __attribute__((critical))
critical_fn(void)
{
  while(a);
}
