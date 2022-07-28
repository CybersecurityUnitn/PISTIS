/* { dg-do compile } */

int __attribute__((noinit)) a = 5; /* { dg-error "only zero initializers are allowed in section '.noinit'" } */
int __attribute__((persistent)) b; /* { dg-warning "variable 'b' was declared persistent and should be explicitly initialized" } */

int main (void)
{
  static int __attribute__((noinit)) c;
  return c;
}

