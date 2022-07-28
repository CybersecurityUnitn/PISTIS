# As an initial sanity check, ensure that unused functions in the test source
# we used for subsequent metasym really are gc'ed from the linked executable.
#name : symbol meta-information (test removal of unused sections)
#ld: -gc-sections -e main
#source: metasym-1.s
#objdump : -t
#failif

.*:.*

SYMBOL TABLE:
#...
.*no_retain.*
#...
