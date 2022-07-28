/* PR middle-end/90025 */

__attribute__((noipa)) void
bar (char *p)
{
  int i;
  for (i = 0; i < 6; i++)
    if (p[i] != "foobar"[i])
      __builtin_abort ();
  for (; i < 32; i++)
    if (p[i] != '\0')
      __builtin_abort ();
}

__attribute__((noipa)) void
foo (unsigned int x)
{
  char s[32] = { 'f', 'o', 'o', 'b', 'a', 'r', 0 };
#if __SIZEOF_INT__ == 2
  ((unsigned long *) s)[2] = __builtin_bswap32 (x);
#else
  ((unsigned int *) s)[2] = __builtin_bswap32 (x);
#endif
  bar (s);
}

int
main ()
{
  foo (0);
  return 0;
}
