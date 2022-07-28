/* { dg-do compile } */
/* { dg-options "-ffunction-sections -fdata-sections -save-temps" } */

#include "metalib.h"

int __attribute__((location(0x10002))) high_mem; /* { dg-warning "'-mlarge' is required for placement in upper memory at address '0x10002' with the 'location' attribute" "" { target { ! msp430_large_memory_model } } } */
int __attribute__((location(0x110002))) too_high_mem; /* { dg-warning "'location' attribute argument value '0x110002' is not within the addressable memory range" } */
int __attribute__((location(-1))) negative; /* { dg-warning "'location' attribute argument value '-1' is negative" } */
int __attribute__((location("foo"))) str; /* { dg-warning "'location' attribute argument value '.foo.' is not an integer constant" } */
int __attribute__((location)) no_arg; /* { dg-error "wrong number of arguments specified for 'location' attribute" } */
int __attribute__((location(1,2))) too_many_arg; /* { dg-error "wrong number of arguments specified for 'location' attribute" } */

typedef int __attribute__((retain)) int16_retain_t;
typedef long __attribute__((location(0x200))) int32_location_t; /* { dg-warning "'location' attribute ignored" } */

int
foo (void)
{
  int __attribute__((retain)) a; /* { dg-warning "'retain' attribute ignored" } */
  while (a++);
  return a;
}

int __attribute__((location(foo))) fn; /* { dg-warning "location' attribute argument value 'foo' is not an integer constant" } */
