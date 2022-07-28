


	.global malloc
	.type malloc, @function
malloc:
	nop
	nop
	mova	r12,	r13	;
	mova	&11264,	r12	;0x02c00

	calla	#_malloc_r		;0x04a7a

	reta			;



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

.L5:
	cmpa	r12,	r15	;
	jnz	.L10     	;abs 0x492c

	mova	r8,	r12	;

	popm.a	#1,	r8	;20-bit words

	popm.a	#1,	r10	;20-bit words

	reta			;

.L10:
	mova	r8,	r14	;
	adda	r12,	r14	;

	mova	r13,	r10	;
	adda	r12,	r10	;

	mov.b	@r10,	0(r14)	;
	adda	#1,	r12	;

	jmp .L5	;mova	#18720,	r0	;0x04920



	.global _free_r
	.type _free_r, @function
_free_r:
	nop
	nop
	pushm.a	#4,	r10	;20-bit words

	suba	#4,	r1	;

	mova	r12,	r9	;

	cmpa	#0,	r13	;
	jz	.L34    	;abs 0x49b2

	mova	r13,	r12	;

	adda	#1048572,r12	;0xffffc

	mov	-2(r13),r15	;
	mov	-4(r13),r14	;

	cmp	#0,	r15	;r3 As==00
	jge	.L23     	;abs 0x4968

	push	r15		;
	push	r14		;
	popm.a	#1,	r14	;20-bit words

	adda	r14,	r12	;

.L23:
	mova	&11576,	r8	;0x02d38

	cmpa	#0,	r8	;
	jnz	.L26     	;abs 0x497a

.L25:
	mova	r8,	4(r12)	;
	jmp .L33	;mova	#18862,	r0	;0x049ae

.L26:
	cmpa	r8,	r12	;
	jc	.L37     	;abs 0x49ba

	mov	@r12,	r10	;
	mov	2(r12),	r11	;

	push	r11		;
	push	r10		;
	popm.a	#1,	r14	;20-bit words
	adda	r12,	r14	;

	cmpa	r14,	r8	;
	jnz	.L25     	;abs 0x4972

	mov	r10,	r13	;

	mov	r11,	r14	;
	addx.w	@r8,	r13	;
	addcx.w	2(r8),	r14	;
	mov	r13,	0(r12)	;
	mov	r14,	2(r12)	;

	movx.a	4(r8),	4(r12)	;

.L33:
	mova	r12,	&11576	; 0x02d38

.L34:
	adda	#4,	r1	;

	popm.a	#4,	r10	;20-bit words

	reta			;

.L37:
	mova	r8,	r13	;

	mova	4(r8),	r8	;

	cmpa	#0,	r8	;
	jz	.L41      	;abs 0x49ca

	cmpa	r8,	r12	;
	jc	.L37     	;abs 0x49ba

.L41:
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
	jnz	.L50     	;abs 0x4a2c

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
	jnz	.L34     	;abs 0x49b2

	mov	r10,	r14	;
	mov	r11,	r15	;
	addx.w	@r8,	r14	;
	addcx.w	2(r8),	r15	;
	mov	r14,	0(r13)	;
	mov	r15,	2(r13)	;

	movx.a	4(r8),	4(r13)	;
	jmp .L34	;mova	#18866,	r0	;0x049b2

.L50:
	cmpa	r14,	r12	;
	jc	.L53     	;abs 0x4a3a

	mov	#12,	0(r9)	;#0x000c

	jmp .L34	;mova	#18866,	r0	;0x049b2

.L53:
	mov	@r12,	r10	;
	mov	2(r12),	r11	;

	push	r11		;
	push	r10		;
	popm.a	#1,	r14	;20-bit words
	adda	r12,	r14	;

	cmpa	r14,	r8	;
	jnz	.L60     	;abs 0x4a72

	mov	r10,	r14	;
	mov	r11,	r15	;
	addx.w	@r8,	r14	;
	addcx.w	2(r8),	r15	;
	mov	r14,	0(r12)	;
	mov	r15,	2(r12)	;

	movx.a	4(r8),	4(r12)	;

.L58:
	mova	r12,	4(r13)	;

	jmp .L34	;mova	#18866,	r0	;0x049b2

.L60:
	mova	r8,	4(r12)	;
	jmp .L58	;mova	#19050,	r0	;0x04a6a



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
	jc	.L66      	;abs 0x4a9a
	mov.b	#12,	r10	;#0x000c

.L66:
	cmpa	r12,	r10	;
	jc	.L71     	;abs 0x4aaa

.L67:
	mov	#12,	0(r9)	;#0x000c

	clr.b	r12		;

.L69:
	popm.a	#4,	r10	;20-bit words

	reta			;

.L71:
	mova	&11576,	r12	;0x02d38

	mova	r12,	r8	;

	movx.w	r10,	r14	;

.L74:
	cmpa	#0,	r8	;
	jnz	.L87     	;abs 0x4b02


	cmpx.a	#0,	&0x02d34;r3 As==00
	jnz	.L80     	;abs 0x4ad0

	mova	r8,	r13	;
	mova	r9,	r12	;

	calla	#_sbrk_r		;

	mova	r12,	&11572	; 0x02d34

.L80:
	mova	r10,	r13	;
	mova	r9,	r12	;
	calla	#_sbrk_r		;

	cmpa	#1048575,r12	;0xfffff
	jz	.L67     	;abs 0x4a9e

	mova	r12,	r8	;
	adda	#3,	r8	;
	andx.a	#-4,	r8	;0xffffc

	cmpa	r8,	r12	;
	jz	.L93     	;abs 0x4b2a

	movx.a	r8,	r13	;
	subx.a	r12,	r13	;
	mova	r9,	r12	;

	calla	#_sbrk_r		;

	cmpa	#1048575,r12	;0xfffff
	jnz	.L93     	;abs 0x4b2a
	jmp .L67	;mova	#19102,	r0	;0x04a9e

.L87:
	mov	@r8,	r13	;
	sub	r14,	r13	;

	cmp	#0,	r13	;r3 As==00
	jl	.L107    	;abs 0x4b98

	mov.b	#11,	r14	;#0x000b
	cmp	r13,	r14	;
	jge	.L94     	;abs 0x4b40

	mov	r13,	r14	;
	mov	r13,	r15	;
	rpt #15 { rrax.w	r15		;
	mov	r14,	0(r8)	;
	mov	r15,	2(r8)	;

	mov	r13,	r15	;
	rlam.a	#4,	r15	;
	rram.a	#4,	r15	;

	adda	r15,	r8	;

.L93:
	pushm.a	#1,	r10	;20-bit words
	popx.w	r12		;
	popx.w	r13		;
	mov	r12,	0(r8)	;
	mov	r13,	2(r8)	;
	jmp .L97	;mova	#19276,	r0	;0x04b4c

.L94:
	mova	4(r8),	r14	;

	cmpa	r8,	r12	;
	jnz	.L106     	;abs 0x4b90

	mova	r14,	&11576	; 0x02d38

.L97:
	mova	r8,	r12	;
	adda	#11,	r12	;0x0000b
	andx.a	#-8,	r12	;0xffff8

	mova	r8,	r10	;

	adda	#4,	r10	;
	movx.a	r12,	r14	;
	subx.a	r10,	r14	;

	movx.w	r14,	r14	;

	cmp	#0,	r14	;r3 As==00
	jz	.L69    	;abs 0x4aa6

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
	jmp .L69	;mova	#19110,	r0	;0x04aa6

.L106:
	mova	r14,	4(r12)	;
	jmp .L97	;mova	#19276,	r0	;0x04b4c

.L107:
	mova	r8,	r12	;
	mova	4(r8),	r8	;

	jmp .L74	;mova	#19124,	r0	;0x04ab4



	.global realloc
	.type realloc, @function
realloc:
	nop
	nop
	mova	r13,	r14	;

	mova	r12,	r13	;

	mova	&11264,	r12	;0x02c00

	calla	#_realloc_r		;0x04bd8

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

	calla	#_sbrk		;0x04c68

	cmpa	#1048575,r12	;0xfffff
	jnz	.L120     	;abs 0x4bd4

	movx.w	&0x02d3c,r13	;

	cmp	#0,	r13	;r3 As==00
	jz	.L120      	;abs 0x4bd4

	mov	r13,	0(r10)	;

.L120:
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
	jnz	.L129     	;abs 0x4bf6

	mova	r14,	r13	;

	calla	#_malloc_r		;0x04a7a

	mova	r12,	r10	;

.L127:
	mova	r10,	r12	;
	popm.a	#4,	r10	;20-bit words

	reta			;

.L129:
	cmpa	#0,	r14	;
	jnz	.L132     	;abs 0x4c06

	calla	#_free_r		;0x04940

	mova	r8,	r10	;
	jmp .L127	;mova	#19440,	r0	;0x04bf0

.L132:
	calla	#_malloc_usable_size_r		;0x04c32

	cmpa	r8,	r12	;
	jc	.L127     	;abs 0x4bf0

	mova	r8,	r13	;
	mova	r7,	r12	;
	calla	#_malloc_r		;0x04a7a

	mova	r12,	r10	;

	cmpa	#0,	r12	;
	jz	.L127     	;abs 0x4bf0

	mova	r8,	r14	;
	mova	r9,	r13	;
	calla	#memcpy		;0x04916

	mova	r9,	r13	;
	mova	r7,	r12	;
	calla	#_free_r		;0x04940

	jmp .L127	;mova	#19440,	r0	;0x04bf0



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
	jge	.L150     	;abs 0x4c60

	adda	r10,	r12	;

	mov	r11,	r13	;
	rlam.a	#4,	r13	;
	rram.a	#4,	r13	;
	mova	r13,	r14	;
	adda	#1048572,r14	;0xffffc
	mova	@r12,	r12	;

	adda	r14,	r12	;

.L150:
	popm.a	#1,	r10	;20-bit words

	reta			;



	.global _exit
	.type _exit, @function
_exit:
	nop
	nop
	jmp _exit	;mova	#19556,	r0	;0x04c64



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
	jc	.L162     	;abs 0x4c9a

	mov.b	#26,	r14	;#0x001a
	mova	#83006,	r13	;0x1443e
	mov.b	#1,	r12	;r3 As==01

	calla	#write		;0x04ca6

	calla	#abort		;0x04d3c

.L162:
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

.L172:
	clr.b	r12		;
	cmp	r8,	r12	;
	jl	.L176     	;abs 0x4cd2

	mov	r9,	r12	;
	adda	#10,	r1	;0x0000a

	popm.a	#4,	r10	;20-bit words

	reta			;

.L176:
	mov	r8,	r10	;
	mov.b	#64,	r13	;#0x0040
	cmp	r8,	r13	;
	jge	.L177      	;abs 0x4cde
	mov	r13,	r10	;

.L177:
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
	calla	#memcpy		;0x04916

	calla	#C$$IO$$		;0x04d38

	add	r10,	r9	;

	sub	r10,	r8	;

	mova	@r1,	r15	;
	jmp .L172	;mova	#19650,	r0	;0x04cc2



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
	calla	#raise		;0x04e34

	mov.b	#1,	r12	;r3 As==01
	calla	#_exit		;0x04c64



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
	jc	.L211     	;abs 0x4da2

	mova	r8,	r11	;
	adda	r14,	r11	;

	cmpa	r11,	r12	;
	jc	.L211     	;abs 0x4da2

	mova	r14,	r8	;

	xorx.a	#-1,	r8	;r3 As==11

	clr.b	r10		;

.L201:
	adda	#1048575,r10	;0xfffff

	cmpa	r10,	r8	;
	jnz	.L206     	;abs 0x4d78

.L203:
	mova	r15,	r12	;
	popm.a	#1,	r8	;20-bit words

	popm.a	#1,	r10	;20-bit words

	reta			;

.L206:
	mova	r13,	r12	;
	adda	r10,	r12	;
	adda	r15,	r12	;
	mova	r11,	r14	;
	adda	r10,	r14	;

	mov.b	@r14,	0(r12)	;
	jmp .L201	;mova	#19816,	r0	;0x04d68

.L208:
	mova	r8,	r10	;
	adda	r12,	r10	;

	mova	r15,	r14	;
	adda	r12,	r14	;
	mov.b	@r10,	0(r14)	;
	adda	#1,	r12	;

.L210:
	cmpa	r12,	r13	;
	jnz	.L208     	;abs 0x4d8a
	jmp .L203	;mova	#19824,	r0	;0x04d70

.L211:
	clr.b	r12		;

	jmp .L210	;mova	#19866,	r0	;0x04d9a



	.global memset
	.type memset, @function
memset:
	nop
	nop
	pushm.a	#1,	r10	;20-bit words

	adda	r12,	r14	;

	mova	r12,	r10	;

.L215:
	cmpa	r14,	r10	;
	jnz	.L218      	;abs 0x4db6

	popm.a	#1,	r10	;20-bit words

	reta			;

.L218:
	adda	#1,	r10	;

	mov.b	r13,	-1(r10)	; 0xffff
	jmp .L215	;mova	#19886,	r0	;0x04dae



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
	jc	.L227     	;abs 0x4ddc

	mov	#22,	0(r10)	;#0x0016

	mov	#-1,	r12	;r3 As==11

.L225:
	popm.a	#2,	r10	;20-bit words

	reta			;

.L227:
	mova	56(r10),r12	;0x00038

	cmpa	#0,	r12	;
	jz	.L232     	;abs 0x4df8

	rlam.a	#4,	r13	;
	rram.a	#4,	r13	;
	mova	r13,	r14	;
	rlam.a	#2,	r14	;
	adda	r14,	r12	;

	mova	@r12,	r14	;

	cmpa	#0,	r14	;
	jnz	.L235     	;abs 0x4e0c

.L232:
	mova	r10,	r12	;
	calla	#_getpid_r		;0x04e68

	mov	r9,	r14	;
	mov	r12,	r13	;
	mova	r10,	r12	;
	calla	#_kill_r		;0x04e40

	jmp .L225	;mova	#19928,	r0	;0x04dd8

.L235:
	cmpa	#1,	r14	;
	jz	.L241     	;abs 0x4e2e

	cmpa	#1048575,r14	;0xfffff
	jnz	.L239     	;abs 0x4e24

	mov	#22,	0(r10)	;#0x0016

	mov.b	#1,	r12	;r3 As==01
	jmp .L225	;mova	#19928,	r0	;0x04dd8

.L239:
	movx.a	#0,	0(r12)	;r3 As==00

	mov	r9,	r12	;
	calla	r14		;

.L241:
	clr.b	r12		;
	jmp .L225	;mova	#19928,	r0	;0x04dd8



	.global raise
	.type raise, @function
raise:
	nop
	nop
	mov	r12,	r13	;
	mova	&11264,	r12	;0x02c00

	calla	#_raise_r		;0x04dc2

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

	calla	#kill		;0x04e74

	cmp	#-1,	r12	;r3 As==11
	jnz	.L252     	;abs 0x4e64

	movx.w	&0x02d3c,r13	;

	cmp	#0,	r13	;r3 As==00
	jz	.L252      	;abs 0x4e64

	mov	r13,	0(r10)	;

.L252:
	popm.a	#1,	r10	;20-bit words

	reta			;



	.global _getpid_r
	.type _getpid_r, @function
_getpid_r:
	nop
	nop
	calla	#getpid		;0x04e6e

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
	calla	#__errno		;0x04e84
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