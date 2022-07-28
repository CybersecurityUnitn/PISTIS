/* { dg-do compile } */
/* { dg-final { scan-assembler-times "BIC.W\\s+#240, \\S+SP" 1 } } */

extern int a;

/* The SR is TOS on entry to an interrupt function. Clear bits 0xF0 (240) in
   the SR to exit out of low power mode.  */
void __attribute__((wakeup,interrupt))
wake_interrupt_fn(void)
{
  while(a);
}

/* wakeup attribute is silently ignored for non-interrupt functions.  */
void __attribute__((wakeup))
wake_fn(void)
{
  while(a);
}
