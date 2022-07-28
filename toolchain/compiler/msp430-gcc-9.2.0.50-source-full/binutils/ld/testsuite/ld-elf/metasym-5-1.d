# Test that symbol meta-information entries always refer to the correct symbol,
# even when there are two symbols with the same name.
# In the sources for this test, there are two declaration of the local symbol
# "value_is_1_if_has_retain_attr", but only one has the "retain" attribute applied.
# After linking, we remove the .data section which contains the instance of the
# variable that is not marked as "retain", and then check that meta-information
# is still valid. This confirms that the meta-information entry for
# "value_is_1_if_has_retain_attr" always pointed to the correct symbol.
# We perform a relocatable link so we can remove the .data section without
# complaints from objcopy.
#name: Symbol meta-information: Local symbols with the same name (part 1)
#ld: -r -gc-sections -e main
#source: metasym-1.s
#source: metasym-5-local-dup-1.s
#source: metasym-5-local-dup-2.s
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
