// PR c++/32251
// { dg-require-effective-target exceptions_enabled }

struct A {
  A();
  void operator delete(void *, ...);
};

void foo () {
  new A; // { dg-warning "deallocation" }
}
