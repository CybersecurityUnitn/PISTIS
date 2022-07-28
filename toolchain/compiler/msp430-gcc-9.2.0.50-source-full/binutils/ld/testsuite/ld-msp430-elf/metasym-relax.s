.text
	.global	var_global_retain
.data
	.balign 2
	.type	var_global_retain, @object
	.sym_meta_info	var_global_retain, SMK_RETAIN, 1
	.size	var_global_retain, 2
var_global_retain:
	.short	1
	.balign 2
	.type	var_static_retain, @object
	.sym_meta_info	var_static_retain, SMK_RETAIN, 1
	.size	var_static_retain, 2
var_static_retain:
	.short	1
.text
	.balign 2
main:
.L6:
	BR	#.L6
	.size	main, .-main
	.global	fn_global_retain
	.type	fn_global_retain, @function
	.sym_meta_info	fn_global_retain, SMK_RETAIN, 1
fn_global_retain:
.L2:
	BR	#.L2
	.size	fn_global_retain, .-fn_global_retain
	.balign 2
	.type	fn_static_retain, @function
	.sym_meta_info	fn_static_retain, SMK_RETAIN, 1
fn_static_retain:
.L4:
	BR	#.L4
	.size	fn_static_retain, .-fn_static_retain
	.balign 2
	.global	main
	.type	main, @function
