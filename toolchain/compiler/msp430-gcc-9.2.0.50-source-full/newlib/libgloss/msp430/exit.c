/* Implement exit in C code so we get debugging info such as function name
   and call frame information.  */
void  __attribute__((naked, weak))
exit (int status __attribute__((unused)))
{
  /* For some reason, the board fails to stop at a breakpoint
     placed on top of a software breakpoint instruction.  */
  /* __asm__("MOV.B	#0,R3")		; this is a software breakpoint instruction */
  while(1);
}

void _exit (int) __attribute__((weak, alias ("exit")));
