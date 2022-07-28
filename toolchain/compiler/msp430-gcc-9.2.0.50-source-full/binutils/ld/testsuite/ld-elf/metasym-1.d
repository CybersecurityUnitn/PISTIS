#name : symbol meta-information
#ld: -gc-sections -e main
#source: metasym-1.s
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
0:[ 	]+SMK_RETAIN[ 	]+0x1[ 	]+[0-9]+[ 	]+var_global_retain_no_sec
1:[ 	]+SMK_RETAIN[ 	]+0x1[ 	]+[0-9]+[ 	]+var_static_retain_no_sec
2:[ 	]+SMK_RETAIN[ 	]+0x1[ 	]+[0-9]+[ 	]+var_global_retain
3:[ 	]+SMK_RETAIN[ 	]+0x1[ 	]+[0-9]+[ 	]+var_static_retain
4:[ 	]+SMK_RETAIN[ 	]+0x1[ 	]+[0-9]+[ 	]+fn_static_retain_no_sec
5:[ 	]+SMK_RETAIN[ 	]+0x1[ 	]+[0-9]+[ 	]+fn_global_retain_no_sec
6:[ 	]+SMK_RETAIN[ 	]+0x1[ 	]+[0-9]+[ 	]+fn_static_retain
7:[ 	]+SMK_RETAIN[ 	]+0x1[ 	]+[0-9]+[ 	]+fn_global_retain
