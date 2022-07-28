// { dg-do compile }
// { dg-options "-fno-rerun-cse-after-loop -ftrapv -fno-tree-loop-optimize -fdelete-dead-exceptions -fno-forward-propagate -fnon-call-exceptions -O2" }
// { dg-require-effective-target exceptions_enabled }

void bar (int n, char *p)
{
  try
    {
      n++;
      for (int i = 0; i < n - 1; i++)
	p[i];
    }
  catch (...)
    {}
}

