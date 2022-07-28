/* { dg-do compile } */
/* { dg-skip-if "" { *-*-* } { "-mcpu=msp430" "-mcpu=430" "-mdata-region=*" } { "" } } */
/* { dg-options "-O1 -mlarge" } */
/* { dg-final { scan-assembler-not "MOV\[^X\]\[^\n\]*&e" } } */
/* { dg-final { scan-assembler-not "MOVX\[^\n\]*&l" } } */
/* { dg-final { scan-assembler-not "ADD\[^CX\]\[^\n\]*&e" } } */
/* { dg-final { scan-assembler-not "ADDC\[^X\]\[^\n\]*&e" } } */
/* { dg-final { scan-assembler-not "ADDCX\[^\n\]*&l" } } */
/* { dg-final { scan-assembler-not "ADDX\[^\n\]*\[^@(\]R\[^\n\]*&l" } } */
/* { dg-final { scan-assembler-not "SUB\[^CX\]\[^\n\]*&e" } } */
/* { dg-final { scan-assembler-not "SUBC\[^X\]\[^\n\]*&e" } } */
/* { dg-final { scan-assembler-not "SUBCX\[^\n\]*&l" } } */
/* { dg-final { scan-assembler-not "SUBX\[^\n\]*&l" } } */
/* { dg-final { scan-assembler-not "BIC\[^X\]\[^\n\]*&e" } } */
/* { dg-final { scan-assembler-not "BICX\[^\n\]*&l" } } */
/* { dg-final { scan-assembler-not "AND\[^X\]\[^\n\]*&e" } } */
/* { dg-final { scan-assembler-not "ANDX\[^\n\]*&l" } } */
/* { dg-final { scan-assembler-not "BIS\[^X\]\[^\n\]*&e" } } */
/* { dg-final { scan-assembler-not "BISX\[^\n\]*&l" } } */
/* { dg-final { scan-assembler-not "XOR\[^X\]\[^\n\]*&e" } } */
/* { dg-final { scan-assembler-not "XORX\[^\n\]*&l" } } */
/* { dg-final { scan-assembler-not "INV\[^X\]\[^\n\]*&e" } } */
/* { dg-final { scan-assembler-not "INVX\[^\n\]*&l" } } */
/* { dg-final { scan-assembler-not "CMP\[^X\]\[^\n\]*&e" } } */
/* { dg-final { scan-assembler-not "CMPX\[^\n\]*&l" } } */
/* { dg-final { scan-assembler-not "BIT\[^X\]\[^\n\]*&e" } } */
/* { dg-final { scan-assembler-not "BITX\[^\n\]*&l" } } */

/* scan treee dump time for all the insns we are trying to generate would be good */

/* This test exercises most (all?) MSP430 instructions, so it is useful to be
 * able to use it for purposes other than testing the region attributes.  */
#ifdef NO_REGION_ATTRIBUTES
#define ATTR_EITHER
#define ATTR_LOWER
#else
#define ATTR_EITHER __attribute__((either)) 
#define ATTR_LOWER __attribute__((lower)) 
#endif

/* Only use these to generate CPUX insns.  */
char ATTR_EITHER eqi1, eqi2, eqi3, eqi4, eqi5, eqi6;
int ATTR_EITHER ehi1, ehi2, ehi3, ehi4, ehi5, ehi6;
long ATTR_EITHER esi1, esi2, esi3, esi4, esi5, esi6;

/* Only use these to generate CPU insns.  */
char ATTR_LOWER lqi1, lqi2, lqi3, lqi4, lqi5, lqi6;
int ATTR_LOWER lhi1, lhi2, lhi3, lhi4, lhi5, lhi6;
long ATTR_LOWER lsi1, lsi2, lsi3, lsi4, lsi5, lsi6;

/* Use these freely, they are not scanned for in the assembler output.  */
char qi1, qi2, qi3, qi4, qi5, qi6;
int hi1, hi2, hi3, hi4, hi5, hi6;
long si1, si2, si3, si4, si5, si6;

/* FIXME: int20 tests.  */
__int20 ATTR_EITHER e20;

char use_qi(char a);
int use_hi(int a);
long use_si(long a);
#define DEFUN(F) void F (void)

DEFUN(movqi)
{
  eqi1 = eqi2;
  lqi1 = lqi2;
  qi1 = eqi3;
  eqi4 = qi2;
}

DEFUN(movhi)
{
  ehi1 = ehi2;
  lhi1 = lhi2;
  hi1 = ehi3;
  ehi4 = hi2;
}

DEFUN(movqihi)
{
  int a;
  a = eqi1;
  use_hi(a);
}

typedef char qi;
typedef int hi;
typedef long si;

#define USE_MODE(MODE) use_ ## MODE
#define VAR(MODE,N) MODE ## N
#define E_VAR(MODE,N) e ## MODE ## N
#define L_VAR(MODE,N) l ## MODE ## N

#define ADD_INSNS(MODE) \
  E_VAR(MODE,1) += E_VAR(MODE,2); \
  E_VAR(MODE,4) += VAR(MODE,1); \
  VAR(MODE,3) += E_VAR(MODE,6); \
  L_VAR(MODE,3) += L_VAR(MODE,4); \
  L_VAR(MODE,5) += VAR(MODE,2); \
  VAR(MODE,4) += L_VAR(MODE,6); \
  VAR(MODE,5) += VAR(MODE,6);

DEFUN(addqi3)
{
  ADD_INSNS(qi)
}

DEFUN(addhi3)
{
  ADD_INSNS(hi)
}

DEFUN(addsi3)
{
  ADD_INSNS(si)
}

#define SUB_INSNS(MODE) \
  /* reg -= mem */ \
  MODE a; \
  a = USE_MODE(MODE) (a); \
  a -= E_VAR(MODE,1); \
  a = USE_MODE(MODE) (a); \
  a -= L_VAR(MODE,1); \
  a = USE_MODE(MODE) (a);  \
  /* mem -= reg */ \
  E_VAR(MODE,2) -= a; \
  a = USE_MODE(MODE) (a);  \
  L_VAR(MODE,2) -= a; \
  /* mem -= mem */ \
  E_VAR(MODE,3) -= VAR(MODE,1); \
  VAR(MODE,2) -= E_VAR(MODE,4); \
  L_VAR(MODE,3) -= VAR(MODE,1); \
  VAR(MODE,2) -= L_VAR(MODE,4); \
  /* mem -= imm */ \
  E_VAR(MODE,5) -= (MODE)101; \
  L_VAR(MODE,5) -= (MODE)77;

DEFUN(subqi3)
{
  SUB_INSNS(qi)
}

DEFUN(subhi3)
{
  SUB_INSNS(hi)
}

DEFUN(subsi3)
{
  SUB_INSNS(si)
}

#define BIC_INSN(MODE) \
  MODE a; \
  /* bic reg,mem */ \
  a = USE_MODE(MODE) (a); \
  a &= (E_VAR(MODE,1) ^ a); \
  a = USE_MODE(MODE) (a); \
  a &= (L_VAR(MODE,1) ^ a); \
  a = USE_MODE(MODE) (a); \
  /* bic mem,reg */ \
  E_VAR(MODE,2) &= (a ^ E_VAR(MODE,2)); \
  a = USE_MODE(MODE) (a); \
  L_VAR(MODE,2) &= (a ^ L_VAR(MODE,2)); \
  /* bic mem,mem */ \
  E_VAR(MODE,3) &= (VAR(MODE,1) ^ E_VAR(MODE,3)); \
  E_VAR(MODE,4) &= (E_VAR(MODE,4) ^ VAR(MODE,2)); \
  L_VAR(MODE,3) &= (VAR(MODE,3) ^ L_VAR(MODE,3)); \
  L_VAR(MODE,4) &= (L_VAR(MODE,4) ^ VAR(MODE,4)); \
  /* bic mem,imm */ \
  E_VAR(MODE,5) &= (E_VAR(MODE,5) ^ (MODE)4); \
  L_VAR(MODE,5) &= (L_VAR(MODE,5) ^ (MODE)4);

DEFUN(bicqi3)
{
  BIC_INSN(qi)
}

DEFUN(bichi3)
{
  BIC_INSN(hi)
}

/* There is no SImode version of bic, but generate this anyway.  */
DEFUN(bicsi3)
{
  BIC_INSN(si)
}

DEFUN(bicqi3_cg)
{
  /* TODO */
}

#define AND_INSN(MODE) \
  MODE a; \
  /* and reg,mem */ \
  a = USE_MODE(MODE) (a); \
  a &= E_VAR(MODE,1); \
  a = USE_MODE(MODE) (a); \
  a &= L_VAR(MODE,1); \
  a = USE_MODE(MODE) (a); \
  /* and mem,reg */ \
  E_VAR(MODE,2) &= a; \
  a = USE_MODE(MODE) (a); \
  L_VAR(MODE,2) &= a; \
  /* and mem,mem */ \
  E_VAR(MODE,3) &= VAR(MODE,1); \
  L_VAR(MODE,3) &= VAR(MODE,2); \
  /* and mem,imm */ \
  E_VAR(MODE,5) &= (MODE)4; \
  L_VAR(MODE,5) &= (MODE)4;

DEFUN(andqi3)
{
  AND_INSN(qi)
}

DEFUN(andhi3)
{
  AND_INSN(hi)
}

/* There is no SImode version of and, but generate this anyway.  */
DEFUN(andsi3)
{
  AND_INSN(si)
}

#define IOR_INSN(MODE) \
  MODE a; \
  /* ior reg,mem */ \
  a = USE_MODE(MODE) (a); \
  a |= E_VAR(MODE,1); \
  a = USE_MODE(MODE) (a); \
  a |= L_VAR(MODE,1); \
  a = USE_MODE(MODE) (a); \
  /* ior mem,reg */ \
  E_VAR(MODE,2) |= a; \
  a = USE_MODE(MODE) (a); \
  L_VAR(MODE,2) |= a; \
  /* ior mem,mem */ \
  E_VAR(MODE,3) |= VAR(MODE,1); \
  L_VAR(MODE,3) |= VAR(MODE,2); \
  /* ior mem,imm */ \
  E_VAR(MODE,5) |= (MODE)4; \
  L_VAR(MODE,5) |= (MODE)4;

DEFUN(iorqi3)
{
  IOR_INSN(qi)
}

DEFUN(iorhi3)
{
  IOR_INSN(hi)
}

/* There is no SImode version of ior, but generate this anyway.  */
DEFUN(iorsi3)
{
  IOR_INSN(si)
}

#define XOR_INSN(MODE) \
  MODE a; \
  /* xor reg,mem */ \
  a = USE_MODE(MODE) (a); \
  a ^= E_VAR(MODE,1); \
  a = USE_MODE(MODE) (a); \
  a ^= L_VAR(MODE,1); \
  a = USE_MODE(MODE) (a); \
  /* xor mem,reg */ \
  E_VAR(MODE,2) ^= a; \
  a = USE_MODE(MODE) (a); \
  L_VAR(MODE,2) ^= a; \
  /* xor mem,mem */ \
  E_VAR(MODE,3) ^= VAR(MODE,1); \
  L_VAR(MODE,3) ^= VAR(MODE,2); \
  /* xor mem,imm */ \
  E_VAR(MODE,5) ^= (MODE)4; \
  L_VAR(MODE,5) ^= (MODE)4;

DEFUN(xorqi3)
{
  XOR_INSN(qi)
}

DEFUN(xorhi3)
{
  XOR_INSN(hi)
}

/* There is no SImode version of xor, but generate this anyway.  */
DEFUN(xorsi3)
{
  XOR_INSN(si)
}

#define INV_INSN(MODE) \
  /* inv mem,mem */ \
  E_VAR(MODE,1) = ~E_VAR(MODE,1); \
  L_VAR(MODE,1) = ~L_VAR(MODE,1);

DEFUN(one_cmplqi2)
{
  INV_INSN(qi)
}

DEFUN(one_cmplhi2)
{
  INV_INSN(hi)
}

/* There is no SImode version of one_cmpl, but generate this anyway.  */
DEFUN(one_cmplsi2)
{
  INV_INSN(si)
}

DEFUN(extendqihi2)
{
  /* TODO */
}

DEFUN(zero_extendqihi2)
{
  qi a;
  a = eqi1;
  a = use_qi(a);
  a = lqi1;
  a = use_qi(a);
  ehi2 = eqi2;
  lhi2 = lqi2;
}

#define DO1 \
{ \
  qi z; \
  z += use_qi(z); \
  use_qi(z); \
}

#define DO2 \
{ \
  hi z; \
  z += use_hi(z); \
  use_hi(z); \
}

#define DO3 \
{ \
  si z; \
  z += use_si(z); \
  use_si(z); \
}

#define CBRANCH_INSN(MODE) \
  MODE a; \
  a = USE_MODE(MODE)(a); \
  if (E_VAR(MODE,1) == VAR(MODE,1)) \
    DO1 \
  else if (VAR(MODE,2) == E_VAR(MODE,2)) \
  { \
      DO1 \
      DO2 \
  } \
  else if (a == E_VAR(MODE,3)) \
    DO2 \
  else if (E_VAR(MODE,4) == (MODE)101) \
    DO3 \
  else if (L_VAR(MODE,1) == VAR(MODE,3)) \
    DO1 \
  else if (VAR(MODE,4) == L_VAR(MODE,2)) \
  { \
      DO1 \
      DO2 \
  } \
  else if (a == L_VAR(MODE,3)) \
    DO2 \
  else if (L_VAR(MODE,4) == (MODE)99) \
    DO3

DEFUN(cbranchqi4_real)
{
  CBRANCH_INSN(qi)
}

DEFUN(cbranchhi4_real)
{
  CBRANCH_INSN(hi)
}

/* There is no SImode version of cbranch, but generate this anyway.  */
DEFUN(cbranchsi4_real)
{
  CBRANCH_INSN(si)
}

#define CBRANCH_REVERSE_INSN(MODE) \
  MODE a; \
  a = USE_MODE(MODE)(a); \
  if (E_VAR(MODE,1) > VAR(MODE,1)) \
    DO1 \
  else if (VAR(MODE,2) > E_VAR(MODE,2)) \
  { \
      DO1 \
      DO2 \
  } \
  else if (E_VAR(MODE,3) > a) \
    DO2 \
  else if (E_VAR(MODE,4) > (MODE)101) \
    DO3 \
  else if (L_VAR(MODE,1) > VAR(MODE,3)) \
    DO1 \
  else if (VAR(MODE,4) > L_VAR(MODE,2)) \
  { \
      DO1 \
      DO2 \
  } \
  else if (L_VAR(MODE,3) > a) \
    DO2 \
  else if ((MODE)99 > L_VAR(MODE,4)) \
    DO3


DEFUN(cbranchqi4_reversed)
{
  CBRANCH_REVERSE_INSN(qi)
}

DEFUN(cbranchhi4_reversed)
{
  CBRANCH_REVERSE_INSN(hi)
}

/* There is no SImode version of cbranch_reversed, but generate this anyway.  */
DEFUN(cbranchsi4_reversed)
{
  CBRANCH_REVERSE_INSN(si)
}

#define BITBRANCH_NE_INSN(MODE) \
  MODE a; \
  a = USE_MODE(MODE)(a); \
  if (E_VAR(MODE,1) & VAR(MODE,1)) \
    DO1 \
  else if (VAR(MODE,2) & E_VAR(MODE,2)) \
  { \
      DO1 \
      DO2 \
  } \
  else if (E_VAR(MODE,3) & a) \
    DO2 \
  else if (E_VAR(MODE,4) & (MODE)78) \
    DO3 \
  else if (L_VAR(MODE,1) & VAR(MODE,3)) \
    DO1 \
  else if (VAR(MODE,4) & L_VAR(MODE,2)) \
  { \
      DO1 \
      DO2 \
  } \
  else if (L_VAR(MODE,3) & a) \
    DO2 \
  else if (L_VAR(MODE,4) & (MODE)88) \
    DO3 \
  else if (L_VAR(MODE,5)) \
   DO1

DEFUN(bitbranchqi4)
{
  BITBRANCH_NE_INSN(qi)
}

DEFUN(bitbranchhi4)
{
  BITBRANCH_NE_INSN(hi)
}

/* There is no SImode version of bitbranch, but generate this anyway.  */
DEFUN(bitbranchsi4)
{
  BITBRANCH_NE_INSN(si)
}

#define BITBRANCH_EQ_INSN(MODE) \
  MODE a; \
  a = USE_MODE(MODE)(a); \
  if (!(E_VAR(MODE,1) & VAR(MODE,1))) \
    DO1 \
  else if (!(VAR(MODE,2) & E_VAR(MODE,2))) \
  { \
      DO1 \
      DO2 \
  } \
  else if (!(E_VAR(MODE,3) & a)) \
    DO2 \
  else if (!(E_VAR(MODE,4) & (MODE)78)) \
    DO3 \
  else if (!(L_VAR(MODE,1) & VAR(MODE,3))) \
    DO1 \
  else if (!(VAR(MODE,4) & L_VAR(MODE,2))) \
  { \
      DO1 \
      DO2 \
  } \
  else if (!(L_VAR(MODE,3) & a)) \
    DO2 \
  else if (!(L_VAR(MODE,4) & (MODE)68)) \
    DO3 \
  else if (L_VAR(MODE,5)) \
    DO1

DEFUN(bitbranchqi4_eq)
{
  BITBRANCH_EQ_INSN(qi)
}

DEFUN(bitbranchhi4_eq)
{
  BITBRANCH_EQ_INSN(hi)
}

DEFUN(bitbranchsi4_eq)
{
  BITBRANCH_EQ_INSN(si)
}

