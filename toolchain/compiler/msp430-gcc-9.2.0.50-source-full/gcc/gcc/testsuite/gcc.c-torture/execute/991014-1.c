typedef __SIZE_TYPE__ Size_t;

/* size_t is __int20, so 20 bits, for __MSP430X_LARGE__, but __SIZEOF_POINTER__
   returns the bytesize which is 4.  */
#ifdef __MSP430X_LARGE__
#define bufsize ((1L << (20 - 2))-256)
#else  /* !__MSP430X_LARGE__ */
#if __SIZEOF_LONG__ < __SIZEOF_POINTER__
#define bufsize ((1LL << (8 * sizeof(Size_t) - 2))-256)
#else
#define bufsize ((1L << (8 * sizeof(Size_t) - 2))-256)
#endif
#endif

struct huge_struct
{
  short buf[bufsize];
  int a;
  int b;
  int c;
  int d;
};

union huge_union
{
  int a;
  char buf[bufsize];
};

Size_t union_size()
{
  return sizeof(union huge_union);
}

Size_t struct_size()
{
  return sizeof(struct huge_struct);
}

Size_t struct_a_offset()
{
  return (Size_t)(&((struct huge_struct *) 0)->a);
}

int main()
{
  /* Check the exact sizeof value. bufsize is aligned on 256b. */
  if (union_size() != sizeof(char) * bufsize)
    abort();

  if (struct_size() != sizeof(short) * bufsize + 4*sizeof(int))
    abort();

  if (struct_a_offset() < sizeof(short) * bufsize)
    abort();  

  return 0;
}

