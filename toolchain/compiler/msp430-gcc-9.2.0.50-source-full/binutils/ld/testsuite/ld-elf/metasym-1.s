.text
/* Global variable marked with "retain" attribute (global symbol).  */
	.global	var_global_retain
	.section	.data.var_global_retain,"aw"
	.balign 2
	.type	var_global_retain, "object"
	.sym_meta_info	var_global_retain, SMK_RETAIN, 1
	.size	var_global_retain, 2
var_global_retain:
	.short	1

/* Global variable (global symbol).  */
	.global	var_global_no_retain
	.section	.data.var_global_no_retain,"aw"
	.balign 2
	.type	var_global_no_retain, "object"
	.size	var_global_no_retain, 2
var_global_no_retain:
	.short	2

/* Static global variable marked with "retain" attribute (local symbol).  */
	.section	.data.var_static_retain,"aw"
	.balign 2
	.type	var_static_retain, "object"
	.sym_meta_info	var_static_retain, SMK_RETAIN, 1
	.size	var_static_retain, 2
var_static_retain:
	.short	1

/* Static global variable (local symbol).  */
	.section	.data.var_static_no_retain,"aw"
	.balign 2
	.type	var_static_no_retain, "object"
	.size	var_static_no_retain, 2
var_static_no_retain:
	.short	3

/* Function marked with "retain" attribute (global symbol).  */
	.section	.text.fn_global_retain,"ax","progbits"
	.balign 2
	.global	fn_global_retain
	.type	fn_global_retain, "function"
	.sym_meta_info	fn_global_retain, SMK_RETAIN, 1
fn_global_retain:
	.size	fn_global_retain, 24

/* Function (global symbol).  */
	.section	.text.fn_no_retain,"ax","progbits"
	.balign 2
	.global	fn_no_retain
	.type	fn_no_retain, "function"
fn_no_retain:
	.size	fn_no_retain, 24

/* Static function marked with "retain" attribute (local symbol).  */
	.section	.text.fn_static_retain,"ax","progbits"
	.balign 2
	.type	fn_static_retain, "function"
	.sym_meta_info	fn_static_retain, SMK_RETAIN, 1
fn_static_retain:
	.size	fn_static_retain, 16

/* Static function (local symbol).  */
	.section	.text.fn_static_no_retain,"ax","progbits"
	.balign 2
	.type	fn_static_no_retain, "function"
fn_static_no_retain:
	.size	fn_static_no_retain, 16

/* Now we do the same as above but without the symbols having their own
   sections.  */

.text
/* Global variable marked with "retain" attribute (global symbol).  */
	.global	var_global_retain_no_sec
	.balign 2
	.type	var_global_retain_no_sec, "object"
	.sym_meta_info	var_global_retain_no_sec, SMK_RETAIN, 1
	.size	var_global_retain_no_sec, 2
var_global_retain_no_sec:
	.short	1

/* Static global variable marked with "retain" attribute (local symbol).  */
	.balign 2
	.type	var_static_retain_no_sec, "object"
	.sym_meta_info	var_static_retain_no_sec, SMK_RETAIN, 1
	.size	var_static_retain_no_sec, 2
var_static_retain_no_sec:
	.short	1

/* Function marked with "retain" attribute (global symbol).  */
	.balign 2
	.global	fn_global_retain_no_sec
	.type	fn_global_retain_no_sec, "function"
	.sym_meta_info	fn_global_retain_no_sec, SMK_RETAIN, 1
fn_global_retain_no_sec:
	.size	fn_global_retain_no_sec, 24

/* Static function marked with "retain" attribute (local symbol).  */
	.balign 2
	.type	fn_static_retain_no_sec, "function"
	.sym_meta_info	fn_static_retain_no_sec, SMK_RETAIN, 1
fn_static_retain_no_sec:
	.size	fn_static_retain_no_sec, 16

	.balign 2
	.global	main
	.type	main, "function"
main:
	.size	main, 8
