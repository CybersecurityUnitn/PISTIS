/* Generated automatically by the program `genconstants'
   from the machine description file `md'.  */

#ifndef GCC_INSN_CONSTANTS_H
#define GCC_INSN_CONSTANTS_H

#define SP_REGNO 1
#define PC_REGNO 0
#define CARRY 2

enum unspec {
  UNS_PROLOGUE_START_MARKER = 0,
  UNS_PROLOGUE_END_MARKER = 1,
  UNS_EPILOGUE_START_MARKER = 2,
  UNS_EPILOGUE_HELPER = 3,
  UNS_PUSHM = 4,
  UNS_POPM = 5,
  UNS_GROW_AND_SWAP = 6,
  UNS_SWAP_AND_SHRINK = 7,
  UNS_DINT = 8,
  UNS_EINT = 9,
  UNS_PUSH_INTR = 10,
  UNS_POP_INTR = 11,
  UNS_BIC_SR = 12,
  UNS_BIS_SR = 13,
  UNS_REFSYM_NEED_EXIT = 14,
  UNS_DELAY_32 = 15,
  UNS_DELAY_32X = 16,
  UNS_DELAY_16 = 17,
  UNS_DELAY_16X = 18,
  UNS_DELAY_2 = 19,
  UNS_DELAY_1 = 20,
  UNS_DELAY_START = 21,
  UNS_DELAY_END = 22
};
#define NUM_UNSPEC_VALUES 23
extern const char *const unspec_strings[];

#endif /* GCC_INSN_CONSTANTS_H */
