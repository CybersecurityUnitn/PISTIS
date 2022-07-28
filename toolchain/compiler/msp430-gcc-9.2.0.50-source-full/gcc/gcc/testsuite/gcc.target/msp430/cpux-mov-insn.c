/* Test that data which could be in the upper memory region is not accessed
   using the MOV instruction.  */
/* { dg-do compile } */
/* { dg-skip-if "" { *-*-* } { "-mcpu=msp430" "-mcpu=430" "-mdata-region=*" } { "" } } */
/* { dg-options "-O1 -mlarge" } */
/* { dg-final { scan-assembler-not "MOV\\.\[^\n\]*&p" } } */
/* { dg-final { scan-assembler-not "MOVX\\.\[^\n\]*&n" } } */
/* { dg-final { scan-assembler-not "MOV\\.\[^\n\]*&u" } } */
/* { dg-final { scan-assembler-not "MOV\\.\[^\n\]*&e" } } */
/* { dg-final { scan-assembler-not "MOVX\[^\n\]*&g" } } */
/* { dg-final { scan-assembler-not "MOVX\[^\n\]*&l" } } */

int __attribute__((persistent)) p = 10;
int __attribute__((noinit)) n;
int __attribute__((lower)) l;
int __attribute__((upper)) u, u2, u3;
int __attribute__((either)) e;
int g1, g2, g3, g4;

int main(void)
{
  static int __attribute__((noinit)) nl;
  static int __attribute__((persistent)) pl = 2;

  p = (p & 0x001) | (0x6);
  n = (n & 0x002) | (0x5);
  u = (u & 0x003) | (0x4);
  e = (e & 0x004) | (0x3);
  l = (l & 0x005) | (0x2);
  g1 = (g1 & 0x006) | (0x1);
  nl = (nl & 0x005) | (0x2);
  pl = (pl & 0x005) | (0x2);
  g2 = pl | nl;
  /* We build this at -O1, so mem->mem moves happen in one instruction.  */
  g3 = g4;
  u2 = u3;

  return 0;
}

