# Test that relaxation of branch instructions to jumps does not interfere
# with accurrate placement of sections.
# Before location placement, the BR instructions are all close enough to their
# destination such that they can be relaxed to JMP.  However, after placement
# of the sections, some of the JMP will now be out of range, so check that they
# get relaxed back to a BR (tested by the fact there are no relocation
# overflows), and that the functions still get placed at the
# correct address.
#name: SMK_LOCATION meta-information placement after relaxation
#ld: -e main
#objdump : -D

.*:.*

#...
00008000 <fn_8000>:
#...
00008700 <fn_8700>:
#...
00008a00 <fn_8a00>:
#...
00008600 <fn_8600>:
#...
00008200 <fn_8200>:
#...
00009000 <fn_9000>:
#...
00008500 <fn_dst>:
#...
0000910a <loc910a_rodata>:
#pass
