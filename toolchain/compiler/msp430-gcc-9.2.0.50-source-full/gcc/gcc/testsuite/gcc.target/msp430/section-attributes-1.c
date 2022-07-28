/* { dg-do compile } */
/* { dg-skip-if "lower/upper/either sections not supported for MSP430 ISA" { msp430-*-* } { "-mcpu=msp430" } { "" } } */
/* { dg-options "-mlarge" } */

/* { dg-final { scan-assembler-times "\.section.*\.lower\.text" 1 } } */
/* { dg-final { scan-assembler-times "\.section.*\.upper\.text" 1 } } */
/* { dg-final { scan-assembler-times "\.section.*\.either\.text" 1 } } */

/* { dg-final { scan-assembler-times "\.section.*\.lower\.data" 1 } } */
/* { dg-final { scan-assembler-times "\.section.*\.upper\.data" 1 } } */
/* { dg-final { scan-assembler-times "\.section.*\.either\.data" 1 } } */

/* { dg-final { scan-assembler-times "\.section.*\.lower\.bss" 1 } } */
/* { dg-final { scan-assembler-times "\.section.*\.upper\.bss" 1 } } */
/* { dg-final { scan-assembler-times "\.section.*\.either\.bss" 1 } } */

int __attribute__((lower)) lower_func(void) {}
int __attribute__((__upper__)) upper_func(void) {}
int __attribute__((either)) either_func(void) {}

int __attribute__((__lower__)) lower_var = 10;
int __attribute__((upper)) upper_var = 11;
int __attribute__((__either__)) either_var = 12;

int __attribute__((lower)) lower_zero = 0;
int __attribute__((__upper__)) upper_zero = 0;
int __attribute__((either)) either_zero = 0;
