


	.global memcpy
	.type memcpy, @function
memcpy:
	nop
	nop
	pushm.a	#1,	r10	;20-bit words

	pushm.a	#1,	r8	;20-bit words

	mova	r12,	r8	;
	mova	r14,	r15	;

	clr.b	r12		;

.L3:
	cmpa	r12,	r15	;
	jnz	.L8     	;abs 0x460a

	mova	r8,	r12	;

	popm.a	#1,	r8	;20-bit words

	popm.a	#1,	r10	;20-bit words

	reta			;

.L8:
	mova	r8,	r14	;
	adda	r12,	r14	;

	mova	r13,	r10	;
	adda	r12,	r10	;

	mov.b	@r10,	0(r14)	;
	adda	#1,	r12	;

	jmp .L3	;mova	#17918,	r0	;0x045fe



	.global memset
	.type memset, @function
memset:
	nop
	nop
	pushm.a	#1,	r10	;20-bit words

	adda	r12,	r14	;

	mova	r12,	r10	;

.L14:
	cmpa	r14,	r10	;
	jnz	.L17      	;abs 0x462c

	popm.a	#1,	r10	;20-bit words

	reta			;

.L17:
	adda	#1,	r10	;

	mov.b	r13,	-1(r10)	; 0xffff
	jmp .L14	;mova	#17956,	r0	;0x04624



	.global _exit
	.type _exit, @function
_exit:
	nop
	nop
	mova	#17976,	r0	;0x04638