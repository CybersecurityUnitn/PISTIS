/* { dg-do compile } */
/* { dg-final { scan-assembler ".mspabi_attribute 4, 1" { target 430_selected } } } */
/* { dg-final { scan-assembler ".mspabi_attribute 4, 2" { target { ! 430_selected } } } } */
/* { dg-final { scan-assembler ".mspabi_attribute 6, 1" { target { ! msp430_large_memory_model } } } } */
/* { dg-final { scan-assembler ".mspabi_attribute 8, 1" { target { ! msp430_large_memory_model } } } } */
/* { dg-final { scan-assembler ".mspabi_attribute 6, 2" { target msp430_large_memory_model } } } */
/* { dg-final { scan-assembler ".mspabi_attribute 8, 2" { target msp430_large_memory_model } } } */
/* { dg-final { scan-assembler ".gnu_attribute 4, 1" { target { ! msp430_region_not_lower } } } } */
/* { dg-final { scan-assembler ".gnu_attribute 4, 2" { target msp430_region_not_lower } } } */

int
main (void)
{
  while (1);
  return 0;
}
