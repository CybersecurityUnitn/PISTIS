.text
/* Global variable marked with "retain" attribute (global symbol).  */
	.global	var_global_retain_2
	.section	.data.var_global_retain_2,"aw"
	.balign 2
	.type	var_global_retain_2, "object"
	.sym_meta_info	var_global_retain_2, SMK_RETAIN, 1
	.size	var_global_retain_2, 2
var_global_retain_2:
	.short	1

/* Global variable (global symbol).  */
	.global	var_global_no_retain_2
	.section	.data.var_global_no_retain_2,"aw"
	.balign 2
	.type	var_global_no_retain_2, "object"
	.size	var_global_no_retain_2, 2
var_global_no_retain_2:
	.short	2

/* Static global variable marked with "retain" attribute (local symbol).  */
	.section	.data.var_static_retain_2,"aw"
	.balign 2
	.type	var_static_retain_2, "object"
	.sym_meta_info	var_static_retain_2, SMK_RETAIN, 1
	.size	var_static_retain_2, 2
var_static_retain_2:
	.short	1

/* Static global variable (local symbol).  */
	.section	.data.var_static_no_retain_2,"aw"
	.balign 2
	.type	var_static_no_retain_2, "object"
	.size	var_static_no_retain_2, 2
var_static_no_retain_2:
	.short	3

/* Function marked with "retain" attribute (global symbol).  */
	.section	.text.fn_global_retain_2,"ax","progbits"
	.balign 2
	.global	fn_global_retain_2
	.type	fn_global_retain_2, "function"
	.sym_meta_info	fn_global_retain_2, SMK_RETAIN, 1
fn_global_retain_2:
	.size	fn_global_retain_2, 24

/* Function (global symbol).  */
	.section	.text.fn_no_retain_2,"ax","progbits"
	.balign 2
	.global	fn_no_retain_2
	.type	fn_no_retain_2, "function"
fn_no_retain_2:
	.size	fn_no_retain_2, 24

/* Static function marked with "retain" attribute (local symbol).  */
	.section	.text.fn_static_retain_2,"ax","progbits"
	.balign 2
	.type	fn_static_retain_2, "function"
	.sym_meta_info	fn_static_retain_2, SMK_RETAIN, 1
fn_static_retain_2:
	.size	fn_static_retain_2, 16

/* Static function (local symbol).  */
	.section	.text.fn_static_no_retain_2,"ax","progbits"
	.balign 2
	.type	fn_static_no_retain_2, "function"
fn_static_no_retain_2:
	.size	fn_static_no_retain_2, 16
