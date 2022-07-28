/* { dg-do compile } */
/* { dg-skip-if "" { *-*-* } { "-mcpu=msp430" "-mdata-region=upper" "-mdata-region=either" } } */
/* { dg-options "-mlarge -mdata-region=lower" } */
/* { dg-final { scan-assembler "MOV.W.*&aaa" } } */
/* { dg-final { scan-assembler "MOVX.W.*&bbb" } } */
/* { dg-final { scan-assembler "MOVX.W.*&ccc" } } */
/* { dg-final { scan-assembler "MOVX.W.*&ddd" } } */
/* { dg-final { scan-assembler "MOV.W.*&eee" } } */

/* Verify that data objects placed in a specific section, or in
   upper or either memory, are handled using MSP430X instructions when
   compiling with -mdata-region=lower.  */

int aaa = 1;
int __attribute__((upper)) bbb = 2;
int __attribute__((either)) ccc = 3;
int __attribute__((section(".upper.data"))) ddd = 4;
/* We allow users to override MSP430X instructions for data with the section
   attribute if they also use the lower attribute.
   Check an MSP430 instructions is generated to handle this data.  */
int __attribute__((section(".lower.data"),lower)) eee = 5;

int
main(void)
{
  if (aaa + bbb + ccc + ddd + eee)
    return 0;
  return 1;
}

