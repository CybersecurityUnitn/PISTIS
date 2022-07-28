


	.global udivmodsi4
	.type udivmodsi4, @function
udivmodsi4:
	nop
	nop
	pushm.a	#4,	r10	;20-bit words

	suba	#2,	r1	;

	mov	r12,	r10	;
	mov	r13,	r11	;

	mov	#33,	0(r1)	;#0x0021

	mov.b	#1,	r8	;r3 As==01
	clr.b	r9		;

	mov	r13,	r7	;

.L5:
	cmp	r11,	r15	;
	jnc	.L6     	;abs 0x4604
	cmp	r15,	r7	;
	jnz	.L9     	;abs 0x4612
	cmp	r10,	r14	;
	jc	.L9     	;abs 0x4612

.L6:
	add	#-1,	0(r1)	;r3 As==11

	cmp	#0,	0(r1)	;r3 As==00
	jz	.L26    	;abs 0x4670

	cmp	#0,	r15	;r3 As==00
	jge	.L15     	;abs 0x4630

.L9:
	clr.b	r12		;
	mov	r12,	r13	;

.L10:
	mov	r8,	r7	;
	bis	r9,	r7	;
	cmp	#0,	r7	;r3 As==00
	jnz	.L20     	;abs 0x464c

.L11:
	cmp	#0,	22(r1)	;r3 As==00, 0x0016
	jz	.L12      	;abs 0x4628
	mov	r10,	r12	;
	mov	r11,	r13	;

.L12:
	adda	#2,	r1	;

	popm.a	#4,	r10	;20-bit words

	reta			;

.L15:
	mov	r14,	r12	;
	mov	r15,	r13	;
	add	r14,	r12	;
	addc	r15,	r13	;
	mov	r12,	r14	;

	mov	r13,	r15	;

	mov	r8,	r12	;
	mov	r9,	r13	;
	add	r8,	r12	;
	addc	r9,	r13	;
	mov	r12,	r8	;

	mov	r13,	r9	;

	jmp .L5	;mova	#17912,	r0	;0x045f8

.L20:
	cmp	r15,	r11	;
	jnc	.L24     	;abs 0x4660
	cmp	r11,	r15	;
	jnz	.L21      	;abs 0x4658
	cmp	r14,	r10	;
	jnc	.L24     	;abs 0x4660

.L21:
	sub	r14,	r10	;
	subc	r15,	r11	;

	bis	r8,	r12	;

	bis	r9,	r13	;

.L24:
	clrc			
	rrc	r9		;
	rrc	r8		;

	clrc			
	rrc	r15		;
	rrc	r14		;
	jmp .L10	;mova	#17942,	r0	;0x04616

.L26:
	mov	@r1,	r12	;
	mov	r12,	r13	;
	jmp .L11	;mova	#17950,	r0	;0x0461e



	.global __mspabi_divlu
	.type __mspabi_divlu, @function
__mspabi_divlu:
	nop
	nop
	suba	#2,	r1	;

	mov	#0,	0(r1)	;r3 As==00
	calla	#udivmodsi4		;0x045e2

	adda	#2,	r1	;

	reta			;



	.global __mspabi_divul
	.type __mspabi_divul, @function
__mspabi_divul:
	nop
	nop
	suba	#2,	r1	;

	mov	#0,	0(r1)	;r3 As==00
	calla	#udivmodsi4		;0x045e2

	adda	#2,	r1	;

	reta			;