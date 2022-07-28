// PR c++/53371
// { dg-do compile { target c++11 } }
// { dg-require-effective-target exceptions_enabled }

struct Abs
{
  virtual void a() = 0;
};

void foo()
{
  try {
  } catch (Abs) { }   // { dg-error "abstract class type" }

  try {
  } catch (int&&) { } // { dg-error "rvalue reference type" }
}
