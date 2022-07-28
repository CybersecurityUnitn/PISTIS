# Test that text, rodata, data and bss locsyms get placed at the correct
# addresses.
# The variable "either" should be placed in between the .data sections.
# 
#name: SMK_LOCATION data meta-information 
#ld: -e main
#source: metasym-loc-1.s
#objdump : -D

.*:.*

#...
00009000 <loc9000_text>:
#...
0000910a <loc910a_rodata>:
#...
00000510 <loc510_data>:
#...
00000520 <loc520_data>:
#...
000005f1 <loc5f1_data>:
#...
00000692 <either>:
#...
00000808 <loc808_data>:
#...
00000720 <loc720_data>:
#...
00000850 <loc850_bss>:
#pass
