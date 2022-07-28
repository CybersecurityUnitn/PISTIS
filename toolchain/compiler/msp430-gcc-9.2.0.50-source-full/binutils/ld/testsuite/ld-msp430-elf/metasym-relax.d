# Ensure that symbol-meta-information is emitted correctly even if the values
# of symbols change during the link process, due to branch relaxation.
# The source for this test has BR instructions which will get relaxed to JMP,
# which will reduce symbol values. It's important that the functions are not
# in their own sections.
#name : symbol meta-information with relaxed branches
#ld: -e main
#source: metasym-relax.s
#objdump : -t --symtab-meta

.*:.*

SYMBOL TABLE:
#...
.*(var_global_retain|var_static_retain|fn_global_retain|fn_static_retain).*
#...
.*(var_global_retain|var_static_retain|fn_global_retain|fn_static_retain).*
#...
.*(var_global_retain|var_static_retain|fn_global_retain|fn_static_retain).*
#...
.*(var_global_retain|var_static_retain|fn_global_retain|fn_static_retain).*
#...
SYMBOL META-INFORMATION TABLE:
Idx[ 	]+Kind[ 	]+Value[ 	]+Sym idx[ 	]+Name
0:[ 	]+SMK_RETAIN[ 	]+0x1[ 	]+[0-9]+[ 	]+var_global_retain
1:[ 	]+SMK_RETAIN[ 	]+0x1[ 	]+[0-9]+[ 	]+var_static_retain
2:[ 	]+SMK_RETAIN[ 	]+0x1[ 	]+[0-9]+[ 	]+fn_static_retain
3:[ 	]+SMK_RETAIN[ 	]+0x1[ 	]+[0-9]+[ 	]+fn_global_retain
