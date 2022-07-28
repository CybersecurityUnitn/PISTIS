/* { dg-do run } */
/* { dg-options "-O3 -fno-strict-aliasing" } */

typedef int int32_t __attribute__((mode (__SI__)));

struct s { int32_t x; } __attribute__((packed));
struct t { int32_t x; };

void __attribute__((noinline,noipa))
swap(struct s* p, struct t* q)
{
  p->x = q->x;
  q->x = p->x;
}

int main()
{    
  struct t a[2];
  a[0].x = 0x12345678;
  a[1].x = 0x98765432;
  swap ((struct s *)((char *)a + 1), a);
  if (a[0].x != 0x12345678)
    __builtin_abort ();
  return 0;
}
