


	.global malloc
	.type malloc, @function
malloc:
	nop
	nop
	mova	r12,	r13	;
	mova	&11264,	r12	;0x02c00

	calla	#_malloc_r		;0x04a62

	reta			;



	.global free
	.type free, @function
free:
	nop
	nop
	mova	r12,	r13	;
	mova	&11264,	r12	;0x02c00

	calla	#_free_r		;0x04928

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
	jz	.L24    	;abs 0x499a

	mova	r13,	r12	;

	adda	#1048572,r12	;0xffffc

	mov	-2(r13),r15	;
	mov	-4(r13),r14	;

	cmp	#0,	r15	;r3 As==00
	jge	.L13     	;abs 0x4950

	push	r15		;
	push	r14		;
	popm.a	#1,	r14	;20-bit words

	adda	r14,	r12	;

.L13:
	mova	&11884,	r8	;0x02e6c

	cmpa	#0,	r8	;
	jnz	.L16     	;abs 0x4962

.L15:
	mova	r8,	4(r12)	;
	jmp .L23	;mova	#18838,	r0	;0x04996

.L16:
	cmpa	r8,	r12	;
	jc	.L27     	;abs 0x49a2

	mov	@r12,	r10	;
	mov	2(r12),	r11	;

	push	r11		;
	push	r10		;
	popm.a	#1,	r14	;20-bit words
	adda	r12,	r14	;

	cmpa	r14,	r8	;
	jnz	.L15     	;abs 0x495a

	mov	r10,	r13	;

	mov	r11,	r14	;
	addx.w	@r8,	r13	;
	addcx.w	2(r8),	r14	;
	mov	r13,	0(r12)	;
	mov	r14,	2(r12)	;

	movx.a	4(r8),	4(r12)	;

.L23:
	mova	r12,	&11884	; 0x02e6c

.L24:
	adda	#4,	r1	;

	popm.a	#4,	r10	;20-bit words

	reta			;

.L27:
	mova	r8,	r13	;

	mova	4(r8),	r8	;

	cmpa	#0,	r8	;
	jz	.L31      	;abs 0x49b2

	cmpa	r8,	r12	;
	jc	.L27     	;abs 0x49a2

.L31:
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
	jnz	.L40     	;abs 0x4a14

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
	jnz	.L24     	;abs 0x499a

	mov	r10,	r14	;
	mov	r11,	r15	;
	addx.w	@r8,	r14	;
	addcx.w	2(r8),	r15	;
	mov	r14,	0(r13)	;
	mov	r15,	2(r13)	;

	movx.a	4(r8),	4(r13)	;
	jmp .L24	;mova	#18842,	r0	;0x0499a

.L40:
	cmpa	r14,	r12	;
	jc	.L43     	;abs 0x4a22

	mov	#12,	0(r9)	;#0x000c

	jmp .L24	;mova	#18842,	r0	;0x0499a

.L43:
	mov	@r12,	r10	;
	mov	2(r12),	r11	;

	push	r11		;
	push	r10		;
	popm.a	#1,	r14	;20-bit words
	adda	r12,	r14	;

	cmpa	r14,	r8	;
	jnz	.L50     	;abs 0x4a5a

	mov	r10,	r14	;
	mov	r11,	r15	;
	addx.w	@r8,	r14	;
	addcx.w	2(r8),	r15	;
	mov	r14,	0(r12)	;
	mov	r15,	2(r12)	;

	movx.a	4(r8),	4(r12)	;

.L48:
	mova	r12,	4(r13)	;

	jmp .L24	;mova	#18842,	r0	;0x0499a

.L50:
	mova	r8,	4(r12)	;
	jmp .L48	;mova	#19026,	r0	;0x04a52



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
	jc	.L56      	;abs 0x4a82
	mov.b	#12,	r10	;#0x000c

.L56:
	cmpa	r12,	r10	;
	jc	.L61     	;abs 0x4a92

.L57:
	mov	#12,	0(r9)	;#0x000c

	clr.b	r12		;

.L59:
	popm.a	#4,	r10	;20-bit words

	reta			;

.L61:
	mova	&11884,	r12	;0x02e6c

	mova	r12,	r8	;

	movx.w	r10,	r14	;

.L64:
	cmpa	#0,	r8	;
	jnz	.L77     	;abs 0x4aea

	cmpx.a	#0,	&0x02e68;r3 As==00
	jnz	.L70     	;abs 0x4ab8

	mova	r8,	r13	;
	mova	r9,	r12	;

	calla	#_sbrk_r		;

	mova	r12,	&11880	; 0x02e68

.L70:
	mova	r10,	r13	;
	mova	r9,	r12	;
	calla	#_sbrk_r		;

	cmpa	#1048575,r12	;0xfffff
	jz	.L57     	;abs 0x4a86

	mova	r12,	r8	;
	adda	#3,	r8	;
	andx.a	#-4,	r8	;0xffffc

	cmpa	r8,	r12	;
	jz	.L83     	;abs 0x4b12

	movx.a	r8,	r13	;
	subx.a	r12,	r13	;
	mova	r9,	r12	;

	calla	#_sbrk_r		;

	cmpa	#1048575,r12	;0xfffff
	jnz	.L83     	;abs 0x4b12
	jmp .L57	;mova	#19078,	r0	;0x04a86

.L77:
	mov	@r8,	r13	;
	sub	r14,	r13	;

	cmp	#0,	r13	;r3 As==00
	jl	.L97    	;abs 0x4b80

	mov.b	#11,	r14	;#0x000b
	cmp	r13,	r14	;
	jge	.L84     	;abs 0x4b28

	mov	r13,	r14	;
	mov	r13,	r15	;
	rpt #15 { rrax.w	r15		;
	mov	r14,	0(r8)	;
	mov	r15,	2(r8)	;

	mov	r13,	r15	;
	rlam.a	#4,	r15	;
	rram.a	#4,	r15	;

	adda	r15,	r8	;

.L83:
	pushm.a	#1,	r10	;20-bit words
	popx.w	r12		;
	popx.w	r13		;
	mov	r12,	0(r8)	;
	mov	r13,	2(r8)	;
	jmp .L87	;mova	#19252,	r0	;0x04b34

.L84:
	mova	4(r8),	r14	;

	cmpa	r8,	r12	;
	jnz	.L96     	;abs 0x4b78

	mova	r14,	&11884	; 0x02e6c

.L87:
	mova	r8,	r12	;
	adda	#11,	r12	;0x0000b
	andx.a	#-8,	r12	;0xffff8

	mova	r8,	r10	;

	adda	#4,	r10	;
	movx.a	r12,	r14	;
	subx.a	r10,	r14	;

	movx.w	r14,	r14	;

	cmp	#0,	r14	;r3 As==00
	jz	.L59    	;abs 0x4a8e

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
	jmp .L59	;mova	#19086,	r0	;0x04a8e

.L96:
	mova	r14,	4(r12)	;
	jmp .L87	;mova	#19252,	r0	;0x04b34

.L97:
	mova	r8,	r12	;
	mova	4(r8),	r8	;

	jmp .L64	;mova	#19100,	r0	;0x04a9c



	.global _sbrk_r
	.type _sbrk_r, @function
_sbrk_r:
	nop
	nop
	pushm.a	#1,	r10	;20-bit words

	mova	r12,	r10	;
	mova	r13,	r12	;

	movx.w	#0,	&0x02e70;r3 As==00

	calla	#_sbrk		;0x04bb6

	cmpa	#1048575,r12	;0xfffff
	jnz	.L106     	;abs 0x4bae

	movx.w	&0x02e70,r13	;

	cmp	#0,	r13	;r3 As==00
	jz	.L106      	;abs 0x4bae

	mov	r13,	0(r10)	;

.L106:
	popm.a	#1,	r10	;20-bit words

	reta			;



	.global _exit
	.type _exit, @function
_exit:
	nop
	nop
	jmp _exit	;mova	#19378,	r0	;0x04bb2



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
	jc	.L118     	;abs 0x4be8

	mov.b	#26,	r14	;#0x001a
	mova	#82946,	r13	;0x14402
	mov.b	#1,	r12	;r3 As==01

	calla	#write		;0x04bf4

	calla	#abort		;0x04c8a

.L118:
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

.L128:
	clr.b	r12		;
	cmp	r8,	r12	;
	jl	.L132     	;abs 0x4c20

	mov	r9,	r12	;
	adda	#10,	r1	;0x0000a

	popm.a	#4,	r10	;20-bit words

	reta			;

.L132:
	mov	r8,	r10	;
	mov.b	#64,	r13	;#0x0040
	cmp	r8,	r13	;
	jge	.L133      	;abs 0x4c2c
	mov	r13,	r10	;

.L133:
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
	calla	#memcpy		;0x04c98

	calla	#C$$IO$$		;0x04c86

	add	r10,	r9	;

	sub	r10,	r8	;

	mova	@r1,	r15	;
	jmp .L128	;mova	#19472,	r0	;0x04c10



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
	calla	#raise		;0x04dac

	mov.b	#1,	r12	;r3 As==01
	calla	#_exit		;0x04bb2



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

.L152:
	cmpa	r12,	r15	;
	jnz	.L157     	;abs 0x4cae

	mova	r8,	r12	;

	popm.a	#1,	r8	;20-bit words

	popm.a	#1,	r10	;20-bit words

	reta			;

.L157:
	mova	r8,	r14	;
	adda	r12,	r14	;

	mova	r13,	r10	;
	adda	r12,	r10	;

	mov.b	@r10,	0(r14)	;
	adda	#1,	r12	;

	jmp .L152	;mova	#19618,	r0	;0x04ca2



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
	jc	.L179     	;abs 0x4d1a

	mova	r8,	r11	;
	adda	r14,	r11	;

	cmpa	r11,	r12	;
	jc	.L179     	;abs 0x4d1a

	mova	r14,	r8	;

	xorx.a	#-1,	r8	;r3 As==11

	clr.b	r10		;

.L169:
	adda	#1048575,r10	;0xfffff

	cmpa	r10,	r8	;
	jnz	.L174     	;abs 0x4cf0

.L171:
	mova	r15,	r12	;
	popm.a	#1,	r8	;20-bit words

	popm.a	#1,	r10	;20-bit words

	reta			;

.L174:
	mova	r13,	r12	;
	adda	r10,	r12	;
	adda	r15,	r12	;
	mova	r11,	r14	;
	adda	r10,	r14	;

	mov.b	@r14,	0(r12)	;
	jmp .L169	;mova	#19680,	r0	;0x04ce0

.L176:
	mova	r8,	r10	;
	adda	r12,	r10	;

	mova	r15,	r14	;
	adda	r12,	r14	;
	mov.b	@r10,	0(r14)	;
	adda	#1,	r12	;

.L178:
	cmpa	r12,	r13	;
	jnz	.L176     	;abs 0x4d02
	jmp .L171	;mova	#19688,	r0	;0x04ce8

.L179:
	clr.b	r12		;

	jmp .L178	;mova	#19730,	r0	;0x04d12



	.global memset
	.type memset, @function
memset:
	nop
	nop
	pushm.a	#1,	r10	;20-bit words

	adda	r12,	r14	;

	mova	r12,	r10	;

.L183:
	cmpa	r14,	r10	;
	jnz	.L186      	;abs 0x4d2e

	popm.a	#1,	r10	;20-bit words

	reta			;

.L186:
	adda	#1,	r10	;

	mov.b	r13,	-1(r10)	; 0xffff
	jmp .L183	;mova	#19750,	r0	;0x04d26



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
	jc	.L195     	;abs 0x4d54

	mov	#22,	0(r10)	;#0x0016

	mov	#-1,	r12	;r3 As==11

.L193:
	popm.a	#2,	r10	;20-bit words

	reta			;

.L195:
	mova	56(r10),r12	;0x00038

	cmpa	#0,	r12	;
	jz	.L200     	;abs 0x4d70

	rlam.a	#4,	r13	;
	rram.a	#4,	r13	;
	mova	r13,	r14	;
	rlam.a	#2,	r14	;
	adda	r14,	r12	;

	mova	@r12,	r14	;

	cmpa	#0,	r14	;
	jnz	.L203     	;abs 0x4d84

.L200:
	mova	r10,	r12	;
	calla	#_getpid_r		;0x04de0

	mov	r9,	r14	;
	mov	r12,	r13	;
	mova	r10,	r12	;
	calla	#_kill_r		;0x04db8

	jmp .L193	;mova	#19792,	r0	;0x04d50

.L203:
	cmpa	#1,	r14	;
	jz	.L209     	;abs 0x4da6

	cmpa	#1048575,r14	;0xfffff
	jnz	.L207     	;abs 0x4d9c

	mov	#22,	0(r10)	;#0x0016

	mov.b	#1,	r12	;r3 As==01
	jmp .L193	;mova	#19792,	r0	;0x04d50

.L207:
	movx.a	#0,	0(r12)	;r3 As==00

	mov	r9,	r12	;
	calla	r14		;

.L209:
	clr.b	r12		;
	jmp .L193	;mova	#19792,	r0	;0x04d50



	.global raise
	.type raise, @function
raise:
	nop
	nop
	mov	r12,	r13	;
	mova	&11264,	r12	;0x02c00

	calla	#_raise_r		;0x04d3a

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

	movx.w	#0,	&0x02e70;r3 As==00

	calla	#kill		;0x04dec

	cmp	#-1,	r12	;r3 As==11
	jnz	.L220     	;abs 0x4ddc

	movx.w	&0x02e70,r13	;

	cmp	#0,	r13	;r3 As==00
	jz	.L220      	;abs 0x4ddc

	mov	r13,	0(r10)	;

.L220:
	popm.a	#1,	r10	;20-bit words

	reta			;



	.global _getpid_r
	.type _getpid_r, @function
_getpid_r:
	nop
	nop
	calla	#getpid		;0x04de6

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
	calla	#__errno		;0x04dfc
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
