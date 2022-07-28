/* PR c/71512 */
/* { dg-do compile } */
/* { dg-options "-O2 -fnon-call-exceptions -ftrapv -fexceptions -fsanitize=undefined" } */
/* { dg-require-effective-target exceptions } */
/* { dg-require-effective-target trapping } */

#include "../../gcc.dg/pr44545.c"
