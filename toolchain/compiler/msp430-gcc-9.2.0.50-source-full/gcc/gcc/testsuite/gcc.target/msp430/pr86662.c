/* PR/86662 */

/* { dg-do link } */
/* { dg-options "-mlarge -flto" } */
/* { dg-skip-if "" { *-*-* } { "-mcpu=msp430" } } */

int main(void)
{
  __int20 n = 5;
  return 0;
}
