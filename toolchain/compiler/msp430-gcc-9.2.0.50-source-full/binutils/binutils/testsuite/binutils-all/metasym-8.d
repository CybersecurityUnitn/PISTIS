#PROG: objcopy
#name: Symbol meta-information: objcopy --weaken-symbol
#source: metasym-1.s
#objcopy: --weaken-symbol var_global_retain
#objdump: --symtab-meta

.*:.*

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
