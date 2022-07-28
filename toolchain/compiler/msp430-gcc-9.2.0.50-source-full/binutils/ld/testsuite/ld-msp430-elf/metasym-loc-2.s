	.file	"loc-relax.c"
.text
	.global	loc910a_rodata
	.section	.rodata.loc910a_rodata,"a"
	.type	loc910a_rodata, @object
	.size	loc910a_rodata, 1
loc910a_rodata:
	.byte	2
	.sym_meta_info loc910a_rodata, SMK_LOCATION, 0x910a

	.section	.text.fn_8700,"ax",@progbits
	.balign 2
	.global	fn_8700
	.type	fn_8700, @function
fn_8700:
	br #fn_dst
	br #fn_9000
	NOP
	RET
	.size	fn_8700, .-fn_8700
	.section	.text.fn_8a00,"ax",@progbits
	.balign 2
	.global	fn_8a00
	.type	fn_8a00, @function
fn_8a00:
	br #fn_dst
	br #fn_9000
	NOP
	RET
	.size	fn_8a00, .-fn_8a00
	.section	.text.fn_8600,"ax",@progbits
	.balign 2
	.global	fn_8600
	.type	fn_8600, @function
fn_8600:
	br #fn_dst
	br #fn_9000
	NOP
	RET
	.size	fn_8600, .-fn_8600
	.section	.text.fn_8000,"ax",@progbits
	.balign 2
	.global	fn_8000
	.type	fn_8000, @function
fn_8000:
	br #fn_dst
	br #fn_9000
	NOP
	RET
	.size	fn_8000, .-fn_8000
	.section	.text.fn_8200,"ax",@progbits
	.balign 2
	.global	fn_8200
	.type	fn_8200, @function
fn_8200:
	br #fn_dst
	br #fn_9000
	NOP
	RET
	.size	fn_8200, .-fn_8200
  .section	.text.fn_9000,"ax",@progbits
	.global	fn_9000
	.type	fn_9000, @function
fn_9000:
	br #fn_dst
	NOP
	RET
	.size	fn_9000, .-fn_9000
	.section	.text.fn_dst,"ax",@progbits
	.balign 2
	.global	fn_dst
	.type	fn_dst, @function
fn_dst:
	add r12, r12
	NOP
	RET
	.size	fn_dst, .-fn_dst
	.sym_meta_info fn_8000, SMK_LOCATION, 0x8000
	.sym_meta_info fn_dst, SMK_LOCATION, 0x8500
	.sym_meta_info fn_8200, SMK_LOCATION, 0x8200
	.sym_meta_info fn_9000, SMK_LOCATION, 0x9000
	.sym_meta_info fn_8600, SMK_LOCATION, 0x8600
	.sym_meta_info fn_8700, SMK_LOCATION, 0x8700
	.sym_meta_info fn_8a00, SMK_LOCATION, 0x8a00
	.section	.text.main,"ax",@progbits
	.balign 2
	.global	main
	.type	main, @function
main:
	CALL	#fn_8000
	MOV.B	#0, R12
	.refsym	__crt0_call_exit
	RET
	.size	main, .-main
