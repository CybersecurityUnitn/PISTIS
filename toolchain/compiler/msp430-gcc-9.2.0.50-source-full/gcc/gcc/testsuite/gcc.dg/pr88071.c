/* PR tree-optimization/88071 */
/* { dg-do compile } */
/* { dg-require-effective-target trapping } */
/* { dg-options "-O2 -fexceptions -fnon-call-exceptions -fopenmp-simd -ftrapv -ftree-loop-vectorize" } */

#include "gomp/openmp-simd-2.c"
