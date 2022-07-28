.text
	.global	var_global_retain
	.section	.data.var_global_retain,"aw"
	.balign 2
	.type	var_global_retain, "object"
	.sym_meta_info	bad_sym_name, SMK_RETAIN, 1
	.size	var_global_retain, 2
var_global_retain:
	.short	1
