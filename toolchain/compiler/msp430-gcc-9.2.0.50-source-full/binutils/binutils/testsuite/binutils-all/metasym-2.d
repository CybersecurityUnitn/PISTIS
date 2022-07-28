#PROG: objcopy
#name: Symbol meta-information: objcopy -j
#source: metasym-1.s
#objcopy: -j .data.var_static_retain
#objdump: --symtab-meta

.*:.*

SYMBOL META-INFORMATION TABLE:
Idx[ 	]+Kind[ 	]+Value[ 	]+Sym idx[ 	]+Name
0:[ 	]+SMK_RETAIN[ 	]+0x1[ 	]+[0-9]+[ 	]+var_static_retain
