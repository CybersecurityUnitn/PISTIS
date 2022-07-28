#name : symbol meta-information with two object files
#ld: -gc-sections -e main
#source: metasym-1.s
#source: metasym-2.s
#objdump : -t --symtab-meta

.*:.*

SYMBOL TABLE:
#...
.*(var_global_retain|var_static_retain|fn_global_retain|fn_static_retain)(_2)*
#...
.*(var_global_retain|var_static_retain|fn_global_retain|fn_static_retain)(_2)*
#...
.*(var_global_retain|var_static_retain|fn_global_retain|fn_static_retain)(_2)*
#...
.*(var_global_retain|var_static_retain|fn_global_retain|fn_static_retain)(_2)*
#...
.*(var_global_retain|var_static_retain|fn_global_retain|fn_static_retain)(_2)*
#...
.*(var_global_retain|var_static_retain|fn_global_retain|fn_static_retain)(_2)*
#...
.*(var_global_retain|var_static_retain|fn_global_retain|fn_static_retain)(_2)*
#...
.*(var_global_retain|var_static_retain|fn_global_retain|fn_static_retain)(_2)*
#...
SYMBOL META-INFORMATION TABLE:
Idx[ 	]+Kind[ 	]+Value[ 	]+Sym idx[ 	]+Name
0:[ 	]+SMK_RETAIN[ 	]+0x1[ 	]+[0-9]+[ 	]+var_static_retain_2
1:[ 	]+SMK_RETAIN[ 	]+0x1[ 	]+[0-9]+[ 	]+fn_static_retain_2
2:[ 	]+SMK_RETAIN[ 	]+0x1[ 	]+[0-9]+[ 	]+var_global_retain_no_sec
3:[ 	]+SMK_RETAIN[ 	]+0x1[ 	]+[0-9]+[ 	]+var_static_retain_no_sec
4:[ 	]+SMK_RETAIN[ 	]+0x1[ 	]+[0-9]+[ 	]+var_global_retain
5:[ 	]+SMK_RETAIN[ 	]+0x1[ 	]+[0-9]+[ 	]+var_static_retain
6:[ 	]+SMK_RETAIN[ 	]+0x1[ 	]+[0-9]+[ 	]+fn_global_retain_2
7:[ 	]+SMK_RETAIN[ 	]+0x1[ 	]+[0-9]+[ 	]+fn_static_retain_no_sec
8:[ 	]+SMK_RETAIN[ 	]+0x1[ 	]+[0-9]+[ 	]+fn_global_retain_no_sec
9:[ 	]+SMK_RETAIN[ 	]+0x1[ 	]+[0-9]+[ 	]+var_global_retain_2
10:[ 	]+SMK_RETAIN[ 	]+0x1[ 	]+[0-9]+[ 	]+fn_static_retain
11:[ 	]+SMK_RETAIN[ 	]+0x1[ 	]+[0-9]+[ 	]+fn_global_retain
