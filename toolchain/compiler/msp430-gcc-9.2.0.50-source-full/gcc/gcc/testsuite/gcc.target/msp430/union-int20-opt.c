/* Test that no 16-bit MOV.W instructions are used operate on a union where the
   widest type is int20.
   MOVX.A instructions should be used to put the union onto the stack.  */

/* { dg-do compile } */
/* { dg-skip-if "__int20 not supported with msp430 ISA" { msp430-*-* } { "-mcpu=msp430" } { "" } } */
/* { dg-options "-mlarge" } */
/* { dg-final { scan-assembler-not MOV.W } } */

typedef union {
  __int20 ptr;
  int i_val;
  char c_val;
} foo_u;

/* Despite foo_u only containing a 20-bit pointer, in memory this union uses 32
   bits, so two registers are needed to hold it.
   TODO: It would be good if the compiler realised the union can be stored in a
   single register.  */
foo_u accepts_union (foo_u foo)
{
  foo.ptr = foo.ptr + 42;
  return foo;
}
