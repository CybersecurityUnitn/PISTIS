/* { dg-do run } */
/* { dg-options "-O2 -Wno-overflow" } */
/* { dg-skip-if "narrowing conversion compilation error" { c++14 && { ! int32plus } } } */

#define ROTATE_N "rotate-7.c"

#include "rotate-1a.c"
