.text
	.section	.faketext,"ax",@progbits
	.balign 2
	.global	loc9100_text
	.type	loc9100_text, @function
loc9100_text:
	NOP
	RET
	.size	loc9100_text, .-loc9100_text
	.sym_meta_info loc9100_text, SMK_LOCATION, 0x9100
	.section	.text.main,"ax",@progbits
	.balign 2
	.global	main
	.type	main, @function
main:
.L3:
	BR	#.L3
	.size	main, .-main
