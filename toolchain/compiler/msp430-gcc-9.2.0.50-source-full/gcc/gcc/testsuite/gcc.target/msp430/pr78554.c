/* { dg-do compile } */
/* { dg-skip-if "" { "*-*-*" } { "-mcpu=msp430" "-msmall" } { "" } } */
/* { dg-options "-O1 -mlarge -mcpu=msp430x" } */

unsigned char test_val = 0;

typedef __int20 unsigned reg_t;

struct holds_reg
{
  reg_t r0;
};

struct holds_reg ex = { 0 };

int main (void)
{
  ex.r0 = (reg_t)(&test_val);
  return 0;
}
