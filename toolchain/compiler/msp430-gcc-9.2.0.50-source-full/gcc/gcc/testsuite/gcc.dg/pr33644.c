/* PR rtl-optimization/33644 */
/* { dg-do compile } */
/* { dg-options "-O2 -ftrapv" } */
/* { dg-require-effective-target trapping } */

extern char *bar (const char *);

int *m, *b;

void foo (void)
{
  int *mv;
  int p;
  char a[17];

  p = bar (a) - a;
  for (mv = m; mv < b; mv++)
    if (p && ((*mv  & 7) != p))
      *mv=0;
}
