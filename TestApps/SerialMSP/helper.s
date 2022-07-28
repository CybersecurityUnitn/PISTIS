	.global memset
	.type memset, @function
memset:
	nop
	nop
	pushm.a	#1,	r10	;20-bit words

	adda	r12,	r14	;

	mova	r12,	r10	;

.L2:
	cmpa	r14,	r10	;
	jnz	.L5      	;abs 0x4534

	popm.a	#1,	r10	;20-bit words

	reta			;

.L5:
	adda	#1,	r10	;

	mov.b	r13,	-1(r10)	; 0xffff
	jmp .L2	;mova	#17708,	r0	;0x0452c