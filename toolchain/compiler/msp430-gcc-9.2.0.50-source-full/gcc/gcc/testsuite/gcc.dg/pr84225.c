/* PR tree-optimization/84225 */
/* { dg-do compile { target int32plus } } */
/* { dg-require-effective-target trapping } */
/* { dg-options "-Ofast -ftrapv" } */

#include "torture/pr69714.c"
