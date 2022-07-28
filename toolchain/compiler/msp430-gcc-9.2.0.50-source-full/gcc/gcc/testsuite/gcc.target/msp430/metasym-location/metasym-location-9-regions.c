#include <math.h>
#include "metalib.h"
/* RAM (rw)     : ORIGIN = 0x00500, LENGTH = 0x01b00
   ROM (rx)     : ORIGIN = 0x02000, LENGTH = 0x0df00
   .data from 0x500 to 0x1000
   .bss from 0x1000 to 0x2000
   .rodata from 0x3000 to 0x4000
   .text from 0x4000 to 0x5000.  */

int __attribute__((location(0x502))) var_data_in_data = 10;
int __attribute__((location(0x1002))) var_data_in_bss = 11;
int __attribute__((location(0x3002))) var_data_in_rodata = 12;
int __attribute__((location(0x4002))) var_data_in_text = 13;



/*const int __attribute__((location(0x3002))) var_rodata = 56;*/
/*int __attribute__((location(0x502))) var_data = 42;*/
/*int __attribute__((location(0x1002))) var_bss = 0;*/
const int var_rodata = 56;
int var_data = 42;
int var_bss = 0;
float f = 2.4;

/*void __attribute__((location(0x4002)))*/
void
foo (void)
{
  while(var_bss || var_data++ != var_rodata);
}

int
main (void)
{
  int error = 0;
  f = sqrtf(f);

  CHECK_VAL (var_data_in_data, 10);
  CHECK_ADDR (var_data_in_data, 0x502);

  CHECK_VAL (var_data_in_bss, 11);
  CHECK_ADDR (var_data_in_bss, 0x1002);

  /*CHECK_VAL (var_data_in_rodata, 12);*/
  /*CHECK_ADDR (var_data_in_rodata, 0x3002);*/

  /*CHECK_VAL (var_data_in_text, 14);*/
  /*CHECK_ADDR (var_data_in_text, 0x4002);*/
  return error;
}
