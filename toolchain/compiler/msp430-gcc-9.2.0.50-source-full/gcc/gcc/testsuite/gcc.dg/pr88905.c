/* PR target/88905 */
/* { dg-do compile } */
/* { dg-options "-Og -fno-tree-ccp" } */
/* { dg-additional-options "-mabm" { target { i?86-*-* x86_64-*-* } } } */

#if __SIZEOF_INT__ < 4
#define _TYPE unsigned long
#else
#define _TYPE unsigned
#endif

int a, b, c;
extern void baz (int);

static inline int
bar (_TYPE u)
{
  int i = __builtin_popcountll (-(unsigned long long) u);
  baz (i & c);
  return a + b + c;
}

void
foo (void)
{
  bar (2376498292ULL);
}
