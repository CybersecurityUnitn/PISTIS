# Test that a text locsym in a random section still gets placed.
# 
#name: SMK_LOCATION bad output section name
#ld: -e main
#objdump : -D

.*:.*

#...
00009100 <loc9100_text>:
#pass
