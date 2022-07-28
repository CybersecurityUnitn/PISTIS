/* { dg-do run } */

#if __SIZEOF_INT__ < 4
#define CONST_1 0x7FFF
#define CONST_2 0x83F8
#else
#define CONST_1 0x7FFFFFFF
#define CONST_2 0x800003F8
#endif

struct foo
{
  unsigned x;
};
typedef struct foo foo;

static inline int zot(foo *f)
{
  int ret;

  if (f->x > CONST_1)
    ret = (int)(f->x - CONST_1);
  else
    ret = (int)f->x - CONST_1;
  return ret;
}

void __attribute__((noinline,noclone)) bar(foo *f)
{
  int ret = zot(f);
  volatile int x = ret;
  if (ret < 1)
    __builtin_abort ();
}

int main()
{
  foo f;
  f.x = CONST_2;

  bar(&f);
  return 0;
}
