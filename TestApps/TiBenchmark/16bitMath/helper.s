


	.global udivmodhi4
	.type udivmodhi4, @function
udivmodhi4:
	nop
	nop
	mov	r12,	r15	;

	mov.b	#17,	r12	;#0x0011

	mov.b	#1,	r11	;r3 As==01

.L2:
	cmp	r15,	r13	;
	jc	.L5     	;abs 0x4550
	add	#-1,	r12	;r3 As==11

	cmp	#0,	r12	;r3 As==00
	jz	.L7     	;abs 0x4556

	cmp	#0,	r13	;r3 As==00
	jge	.L9     	;abs 0x455e

.L5:
	clr.b	r12		;

.L6:
	cmp	#0,	r11	;r3 As==00
	jnz	.L11     	;abs 0x4566

.L7:
	cmp	#0,	r14	;r3 As==00
	jz	.L8      	;abs 0x455c
	mov	r15,	r12	;

.L8:
	reta			;

.L9:
	rla	r13		;

	rla	r11		;
	jmp .L2	;mova	#17730,	r0	;0x04542

.L11:
	cmp	r13,	r15	;
	jnc	.L14      	;abs 0x456e

	sub	r13,	r15	;

	bis	r11,	r12	;

.L14:
	rrum	#1,	r11	;

	rrum	#1,	r13	;
	jmp .L6	;mova	#17746,	r0	;0x04552



	.global __mspabi_divu
	.type __mspabi_divu, @function
__mspabi_divu:
	nop
	nop
	clr.b	r14		;
	calla	#udivmodhi4		;0x0453a

	reta			;



	.global _exit
	.type _exit, @function
_exit:
	nop
	nop
	jmp _exit	;mova	#17790,	r0	;0x0457e