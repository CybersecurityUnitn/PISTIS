/* { dg-do compile } */
/* { dg-options "-O -fdump-tree-optimized" } */

#if __SIZEOF_INT__ == __SIZEOF_SHORT__
#define T long 
#else
#define T int
#endif

T foo (unsigned short a[], unsigned T x)
{
  unsigned T i;
  for (i = 0; i < 1000; i++)
    {
      x = a[i];
      a[i] = (x >= 255 ? 255 : x);
    }
  return x;
}

/* { dg-final { scan-tree-dump-not " = MIN_EXPR <x_\[0-9\]*" "optimized" } } */
