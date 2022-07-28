/* { dg-do compile } */

int __attribute__((persistent,noinit)) a = 22; /* { dg-warning "variable 'a' cannot have both noinit and persistent attributes" } */
int __attribute__((noinit,persistent)) b; /* { dg-warning "variable 'b' cannot have both noinit and persistent attributes" } */
int __attribute__((noinit,section(".foo"))) c; /* { dg-error "section of 'c' conflicts with" } */
int __attribute__((persistent,section(".foo"))) d = 10; /* { dg-error "section of 'd' conflicts with" } */
int __attribute__((section(".foo"),noinit)) e; /* { dg-warning "section of 'e' conflicts with" } */
int __attribute__((section(".foo"),persistent)) f = 10; /* { dg-warning "section of 'f' conflicts with" } */
int __attribute__((section(".noinit"),noinit)) g;
int __attribute__((section(".persistent"),persistent)) h = 10;
int __attribute__((persistent)) z = 0;
int __attribute__((persistent)) zz; /* { dg-warning "variable 'zz' was declared persistent and should be explicitly initialized" } */


int main (void)
{
  int __attribute__((noinit)) la; /* { dg-warning "'noinit' attribute has no effect on automatic variables" } */
  int __attribute__((persistent)) lb; /* { dg-warning "'persistent' attribute has no effect on automatic variables" } */
  return la;
}
