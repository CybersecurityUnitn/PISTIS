# See metasym-5-1.d for information about this test.
# In this part, we swap the order of the sources to ensure the meta-information
# has deliberately tracked the correct variable (that it's not a coincidence).
#name: Symbol meta-information: Local symbols with the same name (part 2)
#ld: -r -gc-sections -e main
#source: metasym-1.s
#source: metasym-5-local-dup-2.s
#source: metasym-5-local-dup-1.s
#objcopy_linked_file: -R .data
#objdump : --symtab-meta
.*:.*

SYMBOL META-INFORMATION TABLE:
Idx[ 	]+Kind[ 	]+Value[ 	]+Sym idx[ 	]+Name
0:[ 	]+SMK_RETAIN[ 	]+0x1[ 	]+[0-9]+[ 	]+var_global_retain_no_sec
1:[ 	]+SMK_RETAIN[ 	]+0x1[ 	]+[0-9]+[ 	]+var_static_retain_no_sec
2:[ 	]+SMK_RETAIN[ 	]+0x1[ 	]+[0-9]+[ 	]+var_global_retain
3:[ 	]+SMK_RETAIN[ 	]+0x1[ 	]+[0-9]+[ 	]+var_static_retain
4:[ 	]+SMK_RETAIN[ 	]+0x1[ 	]+[0-9]+[ 	]+fn_static_retain_no_sec
5:[ 	]+SMK_RETAIN[ 	]+0x1[ 	]+[0-9]+[ 	]+value_is_1_if_has_retain_attr
6:[ 	]+SMK_RETAIN[ 	]+0x1[ 	]+[0-9]+[ 	]+fn_global_retain_no_sec
7:[ 	]+SMK_RETAIN[ 	]+0x1[ 	]+[0-9]+[ 	]+fn_static_retain
8:[ 	]+SMK_RETAIN[ 	]+0x1[ 	]+[0-9]+[ 	]+fn_global_retain
