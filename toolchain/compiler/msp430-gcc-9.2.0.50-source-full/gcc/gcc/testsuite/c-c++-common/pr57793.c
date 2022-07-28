/* PR c++/57793 */

struct A { unsigned a : 1; unsigned b : 1; };
struct B     /* { dg-error "type .B. is too large" "" { target { c++ && ilp32 } } } */
{
  unsigned char c[0x40000000];
  /* { dg-error "size of array .c. is too large" "" { target { c && { ! size32plus } } } .-1 } */
  /* { dg-warning "unsigned conversion from" "" { target { c++11_down && { ! size32plus } } } .-2 } */
  /* { dg-error "narrowing conversion of" "" { target { c++14 && { ! size32plus } } } .-3 } */
  /* { dg-error "size.*of array.*exceeds" "" { target { c++14 && { ! size32plus } } } .-4 } */
  unsigned char d[0x40000ff0];
  /* { dg-error "size of array .d. is too large" "" { target { c && { ! size32plus } } } .-1 } */
  /* { dg-warning "unsigned conversion from" "" { target { c++11_down && { ! size32plus } } } .-2 } */
  /* Should errors for c++14 be emitted here?? */
  struct A e;
}; /* { dg-error "type .struct B. is too large" "" { target { c && ilp32 } } } */

void *foo (struct B *p)
{
  if (p->e.a)
    return (void *) 0;
  p->e.b = 1;
  return p->c;
}

void
bar (struct B *p)
{
  foo (p);
}
