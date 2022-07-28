// PR c++/33492
// { dg-options "" }
// { dg-require-effective-target exceptions_enabled }

void foo()
{
  if (throw 0) // { dg-error "could not convert .\\<throw-expression\\>. from .void. to .bool." }
    ;
}
