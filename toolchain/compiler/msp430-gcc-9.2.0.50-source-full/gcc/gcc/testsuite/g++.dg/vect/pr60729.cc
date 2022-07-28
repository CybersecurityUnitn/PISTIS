// { dg-do compile }
// { dg-require-effective-target trapping }
// { dg-additional-options "-ftrapv" }

void doSomething(int dim, double *Y, double *A) 
{
  for (int k=0; k<dim; k++) 
    Y[k] += __builtin_fabs (A[k]);
}

