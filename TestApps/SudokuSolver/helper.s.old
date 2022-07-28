


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
	jc	.L5     	;abs 0x46f2
	add	#-1,	r12	;r3 As==11

	cmp	#0,	r12	;r3 As==00
	jz	.L7     	;abs 0x46f8

	cmp	#0,	r13	;r3 As==00
	jge	.L9     	;abs 0x4700

.L5:
	clr.b	r12		;

.L6:
	cmp	#0,	r11	;r3 As==00
	jnz	.L11     	;abs 0x4708

.L7:
	cmp	#0,	r14	;r3 As==00
	jz	.L8      	;abs 0x46fe
	mov	r15,	r12	;

.L8:
	reta			;

.L9:
	rla	r13		;

	rla	r11		;
	jmp .L2	;mova	#18148,	r0	;0x046e4

.L11:
	cmp	r13,	r15	;
	jnc	.L14      	;abs 0x4710

	sub	r13,	r15	;

	bis	r11,	r12	;

.L14:
	rrum	#1,	r11	;

	rrum	#1,	r13	;
	jmp .L6	;mova	#18164,	r0	;0x046f4



	.global __mspabi_divi
	.type __mspabi_divi, @function
__mspabi_divi:
	nop
	nop
	pushm.a	#1,	r10	;20-bit words

	cmp	#0,	r12	;r3 As==00
	jge	.L27     	;abs 0x4746

	clr.b	r14		;
	sub	r12,	r14	;
	mov	r14,	r12	;

	mov.b	#1,	r10	;r3 As==01

.L19:
	cmp	#0,	r13	;r3 As==00
	jge	.L22     	;abs 0x4732

	clr.b	r14		;
	sub	r13,	r14	;
	mov	r14,	r13	;

	xor	#1,	r10	;r3 As==01

.L22:
	clr.b	r14		;
	calla	#udivmodhi4		;0x046dc

	cmp	#0,	r10	;r3 As==00
	jz	.L25      	;abs 0x4742

	clr.b	r13		;
	sub	r12,	r13	;
	mov	r13,	r12	;

.L25:
	popm.a	#1,	r10	;20-bit words

	reta			;

.L27:
	clr.b	r10		;
	jmp .L19	;mova	#18214,	r0	;0x04726



	.global __mspabi_remi
	.type __mspabi_remi, @function
__mspabi_remi:
	nop
	nop
	pushm.a	#1,	r10	;20-bit words

	cmp	#0,	r12	;r3 As==00
	jge	.L37     	;abs 0x4778

	clr.b	r14		;
	sub	r12,	r14	;
	mov	r14,	r12	;

	mov.b	#1,	r10	;r3 As==01

.L31:
	cmp	#0,	r13	;r3 As==00
	jge	.L32      	;abs 0x4764
	clr.b	r14		;
	sub	r13,	r14	;
	mov	r14,	r13	;

.L32:
	mov.b	#1,	r14	;r3 As==01
	calla	#udivmodhi4		;0x046dc

	cmp	#0,	r10	;r3 As==00
	jz	.L35      	;abs 0x4774

	clr.b	r13		;
	sub	r12,	r13	;
	mov	r13,	r12	;

.L35:
	popm.a	#1,	r10	;20-bit words

	reta			;

.L37:
	clr.b	r10		;
	jmp .L31	;mova	#18266,	r0	;0x0475a



	.global malloc
	.type malloc, @function
malloc:
	nop
	nop
	mova	r12,	r13	;
	mova	&11264,	r12	;0x02c00

	calla	#_malloc_r		;0x048d0

	reta			;



	.global free
	.type free, @function
free:
	nop
	nop
	mova	r12,	r13	;
	mova	&11264,	r12	;0x02c00

	calla	#_free_r		;0x04796

	reta			;



	.global _free_r
	.type _free_r, @function
_free_r:
	nop
	nop
	pushm.a	#4,	r10	;20-bit words

	suba	#4,	r1	;

	mova	r12,	r9	;

	cmpa	#0,	r13	;
	jz	.L62    	;abs 0x4808

	mova	r13,	r12	;

	adda	#1048572,r12	;0xffffc

	mov	-2(r13),r15	;
	mov	-4(r13),r14	;

	cmp	#0,	r15	;r3 As==00
	jge	.L51     	;abs 0x47be

	push	r15		;
	push	r14		;
	popm.a	#1,	r14	;20-bit words

	adda	r14,	r12	;

.L51:
	mova	&11576,	r8	;0x02d38

	cmpa	#0,	r8	;
	jnz	.L54     	;abs 0x47d0

.L53:
	mova	r8,	4(r12)	;
	jmp .L61	;mova	#18436,	r0	;0x04804

.L54:
	cmpa	r8,	r12	;
	jc	.L65     	;abs 0x4810

	mov	@r12,	r10	;
	mov	2(r12),	r11	;

	push	r11		;
	push	r10		;
	popm.a	#1,	r14	;20-bit words
	adda	r12,	r14	;

	cmpa	r14,	r8	;
	jnz	.L53     	;abs 0x47c8

	mov	r10,	r13	;

	mov	r11,	r14	;
	addx.w	@r8,	r13	;
	addcx.w	2(r8),	r14	;
	mov	r13,	0(r12)	;
	mov	r14,	2(r12)	;

	movx.a	4(r8),	4(r12)	;

.L61:
	mova	r12,	&11576	; 0x02d38

.L62:
	adda	#4,	r1	;

	popm.a	#4,	r10	;20-bit words

	reta			;

.L65:
	mova	r8,	r13	;

	mova	4(r8),	r8	;

	cmpa	#0,	r8	;
	jz	.L69      	;abs 0x4820

	cmpa	r8,	r12	;
	jc	.L65     	;abs 0x4810

.L69:
	mov	@r13,	0(r1)	;
	mov	2(r13),	2(r1)	;

	mov	@r1,	r14	;
	mov	2(r1),	r15	;
	push	r15		;
	push	r14		;
	popm.a	#1,	r7	;20-bit words
	mova	r7,	r14	;
	adda	r13,	r14	;

	cmpa	r12,	r14	;
	jnz	.L78     	;abs 0x4882

	mov	@r1,	r10	;
	addx.w	@r12,	r10	;
	mov	r15,	r11	;
	addcx.w	2(r12),	r11	;
	mov	r10,	0(r13)	;
	mov	r11,	2(r13)	;

	push	r11		;
	push	r10		;
	popm.a	#1,	r12	;20-bit words

	adda	r13,	r12	;

	cmpa	r12,	r8	;
	jnz	.L62     	;abs 0x4808

	mov	r10,	r14	;
	mov	r11,	r15	;
	addx.w	@r8,	r14	;
	addcx.w	2(r8),	r15	;
	mov	r14,	0(r13)	;
	mov	r15,	2(r13)	;

	movx.a	4(r8),	4(r13)	;
	jmp .L62	;mova	#18440,	r0	;0x04808

.L78:
	cmpa	r14,	r12	;
	jc	.L81     	;abs 0x4890

	mov	#12,	0(r9)	;#0x000c

	jmp .L62	;mova	#18440,	r0	;0x04808

.L81:
	mov	@r12,	r10	;
	mov	2(r12),	r11	;

	push	r11		;
	push	r10		;
	popm.a	#1,	r14	;20-bit words
	adda	r12,	r14	;

	cmpa	r14,	r8	;
	jnz	.L88     	;abs 0x48c8

	mov	r10,	r14	;
	mov	r11,	r15	;
	addx.w	@r8,	r14	;
	addcx.w	2(r8),	r15	;
	mov	r14,	0(r12)	;
	mov	r15,	2(r12)	;

	movx.a	4(r8),	4(r12)	;

.L86:
	mova	r12,	4(r13)	;

	jmp .L62	;mova	#18440,	r0	;0x04808

.L88:
	mova	r8,	4(r12)	;
	jmp .L86	;mova	#18624,	r0	;0x048c0



	.global _malloc_r
	.type _malloc_r, @function
_malloc_r:
	nop
	nop
	pushm.a	#4,	r10	;20-bit words

	mova	r12,	r9	;
	mova	r13,	r12	;

	mova	r13,	r10	;
	adda	#3,	r10	;

	andx.a	#-4,	r10	;0xffffc

	adda	#8,	r10	;

	cmpa	#12,	r10	;0x0000c
	jc	.L94      	;abs 0x48f0
	mov.b	#12,	r10	;#0x000c

.L94:
	cmpa	r12,	r10	;
	jc	.L99     	;abs 0x4900

.L95:
	mov	#12,	0(r9)	;#0x000c

	clr.b	r12		;

.L97:
	popm.a	#4,	r10	;20-bit words

	reta			;

.L99:
	mova	&11576,	r12	;0x02d38

	mova	r12,	r8	;

	movx.w	r10,	r14	;

.L102:
	cmpa	#0,	r8	;
	jnz	.L115     	;abs 0x4958

	mova	#_sbrk_r,	r7	;0x04a06

	cmpx.a	#0,	&0x02d34;r3 As==00
	jnz	.L108     	;abs 0x4926

	mova	r8,	r13	;
	mova	r9,	r12	;

	calla	#_sbrk_r		;

	mova	r12,	&11572	; 0x02d34

.L108:
	mova	r10,	r13	;
	mova	r9,	r12	;
	calla	#_sbrk_r		;

	cmpa	#1048575,r12	;0xfffff
	jz	.L95     	;abs 0x48f4

	mova	r12,	r8	;
	adda	#3,	r8	;
	andx.a	#-4,	r8	;0xffffc

	cmpa	r8,	r12	;
	jz	.L121     	;abs 0x4980

	movx.a	r8,	r13	;
	subx.a	r12,	r13	;
	mova	r9,	r12	;

	calla	#_sbrk_r		;

	cmpa	#1048575,r12	;0xfffff
	jnz	.L121     	;abs 0x4980
	jmp .L95	;mova	#18676,	r0	;0x048f4

.L115:
	mov	@r8,	r13	;
	sub	r14,	r13	;

	cmp	#0,	r13	;r3 As==00
	jl	.L135    	;abs 0x49ee

	mov.b	#11,	r14	;#0x000b
	cmp	r13,	r14	;
	jge	.L122     	;abs 0x4996

	mov	r13,	r14	;
	mov	r13,	r15	;
	rpt #15 { rrax.w	r15		;
	mov	r14,	0(r8)	;
	mov	r15,	2(r8)	;

	mov	r13,	r15	;
	rlam.a	#4,	r15	;
	rram.a	#4,	r15	;

	adda	r15,	r8	;

.L121:
	pushm.a	#1,	r10	;20-bit words
	popx.w	r12		;
	popx.w	r13		;
	mov	r12,	0(r8)	;
	mov	r13,	2(r8)	;
	jmp .L125	;mova	#18850,	r0	;0x049a2

.L122:
	mova	4(r8),	r14	;

	cmpa	r8,	r12	;
	jnz	.L134     	;abs 0x49e6

	mova	r14,	&11576	; 0x02d38

.L125:
	mova	r8,	r12	;
	adda	#11,	r12	;0x0000b
	andx.a	#-8,	r12	;0xffff8

	mova	r8,	r10	;

	adda	#4,	r10	;
	movx.a	r12,	r14	;
	subx.a	r10,	r14	;

	movx.w	r14,	r14	;

	cmp	#0,	r14	;r3 As==00
	jz	.L97    	;abs 0x48fc

	mov	r14,	r13	;
	rlam.a	#4,	r13	;
	rram.a	#4,	r13	;
	mova	r13,	r10	;

	adda	r13,	r8	;

	clr	r13		;
	sub	r14,	r13	;
	mov	r13,	r14	;
	mov	r13,	r15	;
	rpt #15 { rrax.w	r15		;

	mov	r14,	0(r8)	;
	mov	r15,	2(r8)	;
	jmp .L97	;mova	#18684,	r0	;0x048fc

.L134:
	mova	r14,	4(r12)	;
	jmp .L125	;mova	#18850,	r0	;0x049a2

.L135:
	mova	r8,	r12	;
	mova	4(r8),	r8	;

	jmp .L102	;mova	#18698,	r0	;0x0490a



	.global realloc
	.type realloc, @function
realloc:
	nop
	nop
	mova	r13,	r14	;

	mova	r12,	r13	;

	mova	&11264,	r12	;0x02c00

	calla	#_realloc_r		;0x04a2e

	reta			;



	.global _sbrk_r
	.type _sbrk_r, @function
_sbrk_r:
	nop
	nop
	pushm.a	#1,	r10	;20-bit words

	mova	r12,	r10	;
	mova	r13,	r12	;

	movx.w	#0,	&0x02d3c;r3 As==00

	calla	#_sbrk		;0x04ae8

	cmpa	#1048575,r12	;0xfffff
	jnz	.L148     	;abs 0x4a2a

	movx.w	&0x02d3c,r13	;

	cmp	#0,	r13	;r3 As==00
	jz	.L148      	;abs 0x4a2a

	mov	r13,	0(r10)	;

.L148:
	popm.a	#1,	r10	;20-bit words

	reta			;



	.global _realloc_r
	.type _realloc_r, @function
_realloc_r:
	nop
	nop
	pushm.a	#4,	r10	;20-bit words

	mova	r12,	r7	;
	mova	r13,	r10	;
	mova	r13,	r9	;
	mova	r14,	r8	;

	cmpa	#0,	r13	;
	jnz	.L157     	;abs 0x4a4c

	mova	r14,	r13	;

	calla	#_malloc_r		;0x048d0

	mova	r12,	r10	;

.L155:
	mova	r10,	r12	;
	popm.a	#4,	r10	;20-bit words

	reta			;

.L157:
	cmpa	#0,	r14	;
	jnz	.L160     	;abs 0x4a5c

	calla	#_free_r		;0x04796

	mova	r8,	r10	;
	jmp .L155	;mova	#19014,	r0	;0x04a46

.L160:
	calla	#_malloc_usable_size_r		;0x04ab2

	cmpa	r8,	r12	;
	jc	.L155     	;abs 0x4a46

	mova	r8,	r13	;
	mova	r7,	r12	;
	calla	#_malloc_r		;0x048d0

	mova	r12,	r10	;

	cmpa	#0,	r12	;
	jz	.L155     	;abs 0x4a46

	mova	r8,	r14	;
	mova	r9,	r13	;
	calla	#memcpy		;0x04a88

	mova	r9,	r13	;
	mova	r7,	r12	;
	calla	#_free_r		;0x04796

	jmp .L155	;mova	#19014,	r0	;0x04a46



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

.L171:
	cmpa	r12,	r15	;
	jnz	.L176     	;abs 0x4a9e

	mova	r8,	r12	;

	popm.a	#1,	r8	;20-bit words

	popm.a	#1,	r10	;20-bit words

	reta			;

.L176:
	mova	r8,	r14	;
	adda	r12,	r14	;

	mova	r13,	r10	;
	adda	r12,	r10	;

	mov.b	@r10,	0(r14)	;
	adda	#1,	r12	;

	jmp .L171	;mova	#19090,	r0	;0x04a92



	.global _malloc_usable_size_r
	.type _malloc_usable_size_r, @function
_malloc_usable_size_r:
	nop
	nop
	pushm.a	#1,	r10	;20-bit words

	mova	r13,	r10	;

	mov	-4(r13),r12	;

	mov	-2(r13),r13	;

	mov	r12,	r11	;

	push	r13		;
	push	r12		;
	popm.a	#1,	r12	;20-bit words

	adda	#1048572,r12	;0xffffc

	cmp	#0,	r11	;r3 As==00
	jge	.L190     	;abs 0x4ae0

	adda	r10,	r12	;

	mov	r11,	r13	;
	rlam.a	#4,	r13	;
	rram.a	#4,	r13	;
	mova	r13,	r14	;
	adda	#1048572,r14	;0xffffc
	mova	@r12,	r12	;

	adda	r14,	r12	;

.L190:
	popm.a	#1,	r10	;20-bit words

	reta			;



	.global _exit
	.type _exit, @function
_exit:
	nop
	nop
	jmp _exit	;mova	#19172,	r0	;0x04ae4



	.global _sbrk
	.type _sbrk, @function
_sbrk:
	nop
	nop
	pushm.a	#1,	r10	;20-bit words

	suba	#4,	r1	;

	mov	r12,	r14	;

	mova	&11492,	r12	;0x02ce4

	clr.b	r13		;
	adda	r1,	r13	;
	mova	r13,	0(r1)	;

	rlam.a	#4,	r14	;
	rram.a	#4,	r14	;

	adda	r12,	r14	;

	mova	r1,	r10	;
	cmpa	r14,	r10	;
	jc	.L202     	;abs 0x4b1a

	mov.b	#26,	r14	;#0x001a
	mova	#82946,	r13	;0x14402
	mov.b	#1,	r12	;r3 As==01

	calla	#write		;0x04b26

	calla	#abort		;0x04bbc

.L202:
	mova	r14,	&11492	; 0x02ce4

	adda	#4,	r1	;

	popm.a	#1,	r10	;20-bit words

	reta			;



	.global write
	.type write, @function
write:
	nop
	nop
	pushm.a	#4,	r10	;20-bit words

	suba	#10,	r1	;0x0000a

	mov	r12,	r7	;
	mova	r13,	6(r1)	;
	mov	r14,	r8	;

	rpt #8 { rrux.w	r12		;

	mov	r12,	4(r1)	;

	clr.b	r9		;

	mova	#11496,	r15	;0x02ce8

.L212:
	clr.b	r12		;
	cmp	r8,	r12	;
	jl	.L216     	;abs 0x4b52

	mov	r9,	r12	;
	adda	#10,	r1	;0x0000a

	popm.a	#4,	r10	;20-bit words

	reta			;

.L216:
	mov	r8,	r10	;
	mov.b	#64,	r13	;#0x0040
	cmp	r8,	r13	;
	jge	.L217      	;abs 0x4b5e
	mov	r13,	r10	;

.L217:
	mov.b	r10,	r12	;
	mov.b	r12,	0(r15)	;

	movx.b	#0,	&0x02ce9;r3 As==00

	movx.b	#-13,	&0x02cea;0xffff3

	mov.b	r7,	3(r15)	;

	mov	4(r1),	r13	;
	mov.b	r13,	4(r15)	;

	mov.b	r12,	5(r15)	;

	movx.b	#0,	&0x02cee;r3 As==00

	mov	r10,	r12	;
	rlam.a	#4,	r12	;
	rram.a	#4,	r12	;
	mova	r12,	r14	;

	mov	r9,	r13	;
	rlam.a	#4,	r13	;
	rram.a	#4,	r13	;
	mova	r13,	r12	;

	mova	6(r1),	r13	;
	adda	r12,	r13	;
	mova	#11507,	r12	;0x02cf3
	mova	r15,	0(r1)	;
	calla	#memcpy		;0x04a88

	calla	#C$$IO$$		;0x04bb8

	add	r10,	r9	;

	sub	r10,	r8	;

	mova	@r1,	r15	;
	jmp .L212	;mova	#19266,	r0	;0x04b42



	.global C$$IO$$
	.type C$$IO$$, @function
C$$IO$$:
	nop
	nop
	nop			

	reta			;



	.global abort
	.type abort, @function
abort:
	nop
	nop
	mov.b	#6,	r12	;
	calla	#raise		;0x04cb4

	mov.b	#1,	r12	;r3 As==01
	calla	#_exit		;0x04ae4



	.global memmove
	.type memmove, @function
memmove:
	nop
	nop
	pushm.a	#1,	r10	;20-bit words

	pushm.a	#1,	r8	;20-bit words

	mova	r12,	r15	;
	mova	r13,	r8	;
	mova	r14,	r13	;

	cmpa	r12,	r8	;
	jc	.L251     	;abs 0x4c22

	mova	r8,	r11	;
	adda	r14,	r11	;

	cmpa	r11,	r12	;
	jc	.L251     	;abs 0x4c22

	mova	r14,	r8	;

	xorx.a	#-1,	r8	;r3 As==11

	clr.b	r10		;

.L241:
	adda	#1048575,r10	;0xfffff

	cmpa	r10,	r8	;
	jnz	.L246     	;abs 0x4bf8

.L243:
	mova	r15,	r12	;
	popm.a	#1,	r8	;20-bit words

	popm.a	#1,	r10	;20-bit words

	reta			;

.L246:
	mova	r13,	r12	;
	adda	r10,	r12	;
	adda	r15,	r12	;
	mova	r11,	r14	;
	adda	r10,	r14	;

	mov.b	@r14,	0(r12)	;
	jmp .L241	;mova	#19432,	r0	;0x04be8

.L248:
	mova	r8,	r10	;
	adda	r12,	r10	;

	mova	r15,	r14	;
	adda	r12,	r14	;
	mov.b	@r10,	0(r14)	;
	adda	#1,	r12	;

.L250:
	cmpa	r12,	r13	;
	jnz	.L248     	;abs 0x4c0a
	jmp .L243	;mova	#19440,	r0	;0x04bf0

.L251:
	clr.b	r12		;

	jmp .L250	;mova	#19482,	r0	;0x04c1a



	.global memset
	.type memset, @function
memset:
	nop
	nop
	pushm.a	#1,	r10	;20-bit words

	adda	r12,	r14	;

	mova	r12,	r10	;

.L255:
	cmpa	r14,	r10	;
	jnz	.L258      	;abs 0x4c36

	popm.a	#1,	r10	;20-bit words

	reta			;

.L258:
	adda	#1,	r10	;

	mov.b	r13,	-1(r10)	; 0xffff
	jmp .L255	;mova	#19502,	r0	;0x04c2e



	.global _raise_r
	.type _raise_r, @function
_raise_r:
	nop
	nop
	pushm.a	#2,	r10	;20-bit words

	mova	r12,	r10	;
	mov	r13,	r9	;

	mov.b	#31,	r12	;#0x001f

	cmp	r13,	r12	;
	jc	.L267     	;abs 0x4c5c

	mov	#22,	0(r10)	;#0x0016

	mov	#-1,	r12	;r3 As==11

.L265:
	popm.a	#2,	r10	;20-bit words

	reta			;

.L267:
	mova	56(r10),r12	;0x00038

	cmpa	#0,	r12	;
	jz	.L272     	;abs 0x4c78

	rlam.a	#4,	r13	;
	rram.a	#4,	r13	;
	mova	r13,	r14	;
	rlam.a	#2,	r14	;
	adda	r14,	r12	;

	mova	@r12,	r14	;

	cmpa	#0,	r14	;
	jnz	.L275     	;abs 0x4c8c

.L272:
	mova	r10,	r12	;
	calla	#_getpid_r		;0x04ce8

	mov	r9,	r14	;
	mov	r12,	r13	;
	mova	r10,	r12	;
	calla	#_kill_r		;0x04cc0

	jmp .L265	;mova	#19544,	r0	;0x04c58

.L275:
	cmpa	#1,	r14	;
	jz	.L281     	;abs 0x4cae

	cmpa	#1048575,r14	;0xfffff
	jnz	.L279     	;abs 0x4ca4

	mov	#22,	0(r10)	;#0x0016

	mov.b	#1,	r12	;r3 As==01
	jmp .L265	;mova	#19544,	r0	;0x04c58

.L279:
	movx.a	#0,	0(r12)	;r3 As==00

	mov	r9,	r12	;
	calla	r14		;

.L281:
	clr.b	r12		;
	jmp .L265	;mova	#19544,	r0	;0x04c58



	.global raise
	.type raise, @function
raise:
	nop
	nop
	mov	r12,	r13	;
	mova	&11264,	r12	;0x02c00

	calla	#_raise_r		;0x04c42

	reta			;



	.global _kill_r
	.type _kill_r, @function
_kill_r:
	nop
	nop
	pushm.a	#1,	r10	;20-bit words

	mova	r12,	r10	;
	mov	r13,	r12	;

	mov	r14,	r13	;

	movx.w	#0,	&0x02d3c;r3 As==00

	calla	#kill		;0x04cf4

	cmp	#-1,	r12	;r3 As==11
	jnz	.L292     	;abs 0x4ce4

	movx.w	&0x02d3c,r13	;

	cmp	#0,	r13	;r3 As==00
	jz	.L292      	;abs 0x4ce4

	mov	r13,	0(r10)	;

.L292:
	popm.a	#1,	r10	;20-bit words

	reta			;



	.global _getpid_r
	.type _getpid_r, @function
_getpid_r:
	nop
	nop
	calla	#getpid		;0x04cee

	reta			;



	.global getpid
	.type getpid, @function
getpid:
	nop
	nop
	mov	#42,	r12	;#0x002a

	reta			;



	.global kill
	.type kill, @function
kill:
	nop
	nop
	calla	#__errno		;0x04d04
	movx.w	#88,	0(r12)	;0x00058
	mov	#-1,	r12	;r3 As==11
	reta			;



	.global __errno
	.type __errno, @function
__errno:
	nop
	nop
	mova	&11264,	r12	;0x02c00
	reta			;