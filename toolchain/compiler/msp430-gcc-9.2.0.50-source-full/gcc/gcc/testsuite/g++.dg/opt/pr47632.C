// { dg-do compile }
// { dg-options "-O -fnon-call-exceptions -ftrapv" }
// { dg-require-effective-target trapping }

template < typename > struct S
{
  int n;
  void bar ()
    {
      int *i = new int[n];
    }
};

void
foo (S < char >*s)
{
  s->bar ();
}

