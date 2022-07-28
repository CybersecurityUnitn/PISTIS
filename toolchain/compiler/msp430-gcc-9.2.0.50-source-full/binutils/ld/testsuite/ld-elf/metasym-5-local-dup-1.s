/* To ensure this version of value_is_1_if_has_retain_attr is kept in the output
   file, put it in a section with another data object we're definitley
   keeping.  */
.section	.data,"aw"
	.balign 2
	.type	keeper, "object"
	.sym_meta_info	keeper, SMK_RETAIN, 1
	.size	keeper, 2
keeper:
	.short	22

	.balign 2
	.type	value_is_1_if_has_retain_attr, "object"
	.size	value_is_1_if_has_retain_attr, 2
value_is_1_if_has_retain_attr:
	.short	2
