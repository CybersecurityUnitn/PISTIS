.text
	.global	var_global_no_retain
	.section	.data.var_global_no_retain,"aw"
	.balign 2
	.type	var_global_no_retain,"object"
	.size	var_global_no_retain, 2
var_global_no_retain:
	.short	2

	.section	.data.var_static_no_retain,"aw"
	.balign 2
	.type	var_static_no_retain,"object"
	.size	var_static_no_retain, 2
var_static_no_retain:
	.short	3

	.section	.text.fn_no_retain,"ax",%progbits
	.balign 2
	.global	fn_no_retain
	.type	fn_no_retain,"function"
fn_no_retain:
	.size	fn_no_retain, 24

	.section	.text.fn_static_no_retain,"ax",%progbits
	.balign 2
	.type	fn_static_no_retain,"function"
fn_static_no_retain:
	.size	fn_static_no_retain, 16

	.section	.text.main,"ax",%progbits
	.balign 2
	.global	main
	.type	main,"function"
main:
	.size	main, 8
