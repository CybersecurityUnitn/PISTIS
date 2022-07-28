


	.global _fpadd_parts1
	.type _fpadd_parts1, @function
_fpadd_parts1:
	nop
	nop
	pushm.a	#4,	r10	;20-bit words

	suba	#20,	r1	;0x00014

	mova	r12,	r10	;
	mova	r13,	r7	;
	mova	r14,	r8	;

	mov	@r12,	r12	;

	mov.b	#1,	r13	;r3 As==01

	cmp	r12,	r13	;
	jc	.L12     	;abs 0x51c2

	mov	@r7,	r13	;

	mov.b	#1,	r14	;r3 As==01

	cmp	r13,	r14	;
	jc	.L76    	;abs 0x5406

	cmp	#4,	r12	;r2 As==10
	jnz	.L15     	;abs 0x51cc

	cmp	#4,	r13	;r2 As==10
	jnz	.L12     	;abs 0x51c2

	cmp	2(r7),	2(r10)	;
	jz	.L12      	;abs 0x51c2

	mova	#82944,	r10	;0x14400

.L12:
	mova	r10,	r12	;
	adda	#20,	r1	;0x00014

	popm.a	#4,	r10	;20-bit words

	reta			;

.L15:
	cmp	#4,	r13	;r2 As==10
	jz	.L76    	;abs 0x5406

	cmp	#2,	r13	;r3 As==10
	jnz	.L22     	;abs 0x51f6

	cmp	#2,	r12	;r3 As==10
	jnz	.L12     	;abs 0x51c2

	mov.b	#10,	r14	;#0x000a
	mova	r10,	r13	;
	mova	r8,	r12	;
	calla	#memcpy		;0x065a2

	mov	2(r10),	r10	;

	and	2(r7),	r10	;
	mov	r10,	2(r8)	;

.L21:
	mova	r8,	r10	;
	jmp .L12	;mova	#20930,	r0	;0x051c2

.L22:
	cmp	#2,	r12	;r3 As==10
	jz	.L76    	;abs 0x5406

	mov	4(r10),	r11	;

	mov	4(r7),	r9	;

	mov	6(r10),	4(r1)	;
	mov	8(r10),	6(r1)	;

	mov	6(r7),	8(r1)	;
	mov	8(r7),	10(r1)	; 0x000a

	mov	r11,	r12	;
	sub	r9,	r12	;

	cmp	#0,	r12	;r3 As==00
	jge	.L37    	;abs 0x528c

	mov	r9,	r12	;
	sub	r11,	r12	;

	mov.b	#31,	r15	;#0x001f
	cmp	r12,	r15	;
	jl	.L60    	;abs 0x5378

	mov	r12,	r13	;
	clr	r14		;
	mov	r13,	12(r1)	; 0x000c
	mov	r14,	14(r1)	; 0x000e
	mov	4(r1),	r12	;

	mov	6(r1),	r13	;

	mov	12(r1),	r14	;0x0000c
	calla	#__mspabi_srll		;0x05dda

	mov	r12,	16(r1)	; 0x0010
	mov	r13,	18(r1)	; 0x0012
	mov	#-1,	r12	;r3 As==11
	mov	#-1,	r13	;r3 As==11
	mov	12(r1),	r14	;0x0000c
	calla	#__mspabi_slll		;0x05dae
	mov	4(r1),	r14	;
	bic	r12,	r14	;
	mov	6(r1),	r15	;
	bic	r13,	r15	;
	mov	r15,	r13	;
	bis	r14,	r13	;
	clr	r12		;
	sub	r13,	r12	;
	bis	r13,	r12	;
	rpt #15 { rrux.w	r12		;
	bis	16(r1),	r12	;0x00010
	mov	r12,	4(r1)	;

	mov	18(r1),	6(r1)	;0x00012

	mov	r9,	r11	;
	jmp .L44	;mova	#21230,	r0	;0x052ee

.L37:
	mov.b	#31,	r13	;#0x001f
	cmp	r12,	r13	;
	jl	.L60    	;abs 0x5378

	cmp	#0,	r12	;r3 As==00
	jz	.L44     	;abs 0x52ee

	mov	r12,	r14	;
	clr	r15		;
	mov	r14,	12(r1)	; 0x000c
	mov	r15,	14(r1)	; 0x000e
	mov	8(r1),	r12	;

	mov	10(r1),	r13	;0x0000a
	mova	r11,	0(r1)	;
	calla	#__mspabi_srll		;0x05dda

	mov	r12,	16(r1)	; 0x0010
	mov	r13,	r9	;
	mov	#-1,	r12	;r3 As==11
	mov	#-1,	r13	;r3 As==11
	mov	12(r1),	r14	;0x0000c
	calla	#__mspabi_slll		;0x05dae
	mov	8(r1),	r15	;
	bic	r12,	r15	;
	mov	10(r1),	r14	;0x0000a
	bic	r13,	r14	;
	mov	r14,	r13	;
	bis	r15,	r13	;
	clr	r12		;
	sub	r13,	r12	;
	bis	r13,	r12	;
	rpt #15 { rrux.w	r12		;
	bis	16(r1),	r12	;0x00010
	mov	r12,	8(r1)	;

	mov	r9,	10(r1)	; 0x000a

	mova	@r1,	r11	;

.L44:
	mov	2(r10),	r12	;

	cmp	2(r7),	r12	;
	jz	.L72    	;abs 0x53de

	cmp	#0,	r12	;r3 As==00
	jz	.L65    	;abs 0x5396

	mov	8(r1),	r12	;
	mov	10(r1),	r13	;0x0000a
	subx.w	4(r1),	r12	;
	subcx.w	6(r1),	r13	;

.L48:
	cmp	#0,	r13	;r3 As==00
	jl	.L67    	;abs 0x53ae

	mov	#0,	2(r8)	;r3 As==00

	mov	r11,	4(r8)	;

	mov	r12,	6(r8)	;
	mov	r13,	8(r8)	;

.L52:
	mov	6(r8),	r12	;
	mov	8(r8),	r13	;

	mov	r12,	r15	;
	add	#-1,	r15	;r3 As==11
	mov	r13,	r14	;
	addc	#-1,	r14	;r3 As==11

	mov	#16383,	r10	;#0x3fff
	cmp	r14,	r10	;
	jnc	.L55     	;abs 0x5348
	cmp	r10,	r14	;
	jnz	.L70    	;abs 0x53ca
	mov	#-2,	r14	;#0xfffe
	cmp	r15,	r14	;
	jc	.L70    	;abs 0x53ca

.L55:
	mov	#3,	0(r8)	;

	mov	6(r8),	r12	;
	mov	8(r8),	r13	;

	cmp	#0,	r13	;r3 As==00
	jge	.L21    	;abs 0x51f0

	mov	r12,	r14	;
	mov	r13,	r15	;
	clrc			
	rrc	r15		;
	rrc	r14		;
	and.b	#1,	r12	;r3 As==01
	bis	r14,	r12	;
	mov	r12,	6(r8)	;
	mov	r15,	8(r8)	;

	inc	4(r8)		;
	jmp .L21	;mova	#20976,	r0	;0x051f0

.L60:
	cmp	r11,	r9	;
	jl	.L63     	;abs 0x538a
	mov	r9,	r11	;

	mov	#0,	4(r1)	;r3 As==00

	mov	#0,	6(r1)	;r3 As==00
	jmp .L44	;mova	#21230,	r0	;0x052ee

.L63:
	mov	#0,	8(r1)	;r3 As==00

	mov	#0,	10(r1)	;r3 As==00, 0x000a
	jmp .L44	;mova	#21230,	r0	;0x052ee

.L65:
	mov	4(r1),	r12	;
	mov	6(r1),	r13	;
	subx.w	8(r1),	r12	;
	subcx.w	10(r1),	r13	;0x0000a

	jmp .L48	;mova	#21264,	r0	;0x05310

.L67:
	mov	#1,	2(r8)	;r3 As==01

	mov	r11,	4(r8)	;

	clr.b	r14		;
	clr.b	r15		;
	sub	r12,	r14	;
	subc	r13,	r15	;
	mov	r14,	6(r8)	;
	mov	r15,	8(r8)	;
	jmp .L52	;mova	#21284,	r0	;0x05324

.L70:
	rla	r12		;
	rlc	r13		;
	mov	r12,	6(r8)	;
	mov	r13,	8(r8)	;

	add	#-1,	4(r8)	;r3 As==11
	jmp .L52	;mova	#21284,	r0	;0x05324

.L72:
	mov	r12,	2(r8)	;

	mov	r11,	4(r8)	;

	mov	4(r1),	r15	;
	addx.w	8(r1),	r15	;
	mov	r15,	6(r8)	;
	mov	6(r1),	r10	;

	addcx.w	10(r1),	r10	;0x0000a
	mov	r10,	8(r8)	;
	jmp .L55	;mova	#21320,	r0	;0x05348

.L76:
	mova	r7,	r10	;

	jmp .L12	;mova	#20930,	r0	;0x051c2



	.global __mspabi_addf
	.type __mspabi_addf, @function
__mspabi_addf:
	nop
	nop
	pushm.a	#1,	r10	;20-bit words

	suba	#38,	r1	;0x00026

	mov	r12,	0(r1)	;
	mov	r13,	2(r1)	;

	mov	r14,	4(r1)	;
	mov	r15,	6(r1)	;

	mova	r1,	r13	;
	adda	#8,	r13	;
	mova	r1,	r12	;

	calla	#__unpack_f		;

	mova	r1,	r13	;
	adda	#18,	r13	;0x00012
	mova	r1,	r12	;
	adda	#4,	r12	;
	calla	#__unpack_f		;

	mova	r1,	r14	;
	adda	#28,	r14	;0x0001c
	mova	r1,	r13	;
	adda	#18,	r13	;0x00012
	mova	r1,	r12	;
	adda	#8,	r12	;
	calla	#_fpadd_parts2		;0x05192

	calla	#__pack_f		;0x05e00

	adda	#38,	r1	;0x00026

	popm.a	#1,	r10	;20-bit words

	reta			;



	.global __mspabi_subf
	.type __mspabi_subf, @function
__mspabi_subf:
	nop
	nop
	pushm.a	#1,	r10	;20-bit words

	suba	#38,	r1	;0x00026

	mov	r12,	0(r1)	;
	mov	r13,	2(r1)	;

	mov	r14,	4(r1)	;
	mov	r15,	6(r1)	;

	mova	r1,	r13	;
	adda	#8,	r13	;
	mova	r1,	r12	;

	calla	#__unpack_f		;

	mova	r1,	r13	;
	adda	#18,	r13	;0x00012
	mova	r1,	r12	;
	adda	#4,	r12	;
	calla	#__unpack_f		;

	xor	#1,	20(r1)	;r3 As==01, 0x0014

	mova	r1,	r14	;
	adda	#28,	r14	;0x0001c
	mova	r1,	r13	;
	adda	#18,	r13	;0x00012
	mova	r1,	r12	;
	adda	#8,	r12	;
	calla	#_fpadd_parts2		;0x05192

	calla	#__pack_f		;0x05e00

	adda	#38,	r1	;0x00026

	popm.a	#1,	r10	;20-bit words

	reta			;



	.global __mspabi_mpyf
	.type __mspabi_mpyf, @function
__mspabi_mpyf:
	nop
	nop
	pushm.a	#4,	r10	;20-bit words

	suba	#54,	r1	;0x00036

	mov	r12,	16(r1)	; 0x0010
	mov	r13,	18(r1)	; 0x0012

	mov	r14,	20(r1)	; 0x0014
	mov	r15,	22(r1)	; 0x0016

	mova	r1,	r13	;
	adda	#24,	r13	;0x00018
	mova	r1,	r12	;

	adda	#16,	r12	;0x00010
	calla	#__unpack_f		;

	mova	r1,	r13	;
	adda	#34,	r13	;0x00022
	mova	r1,	r12	;
	adda	#20,	r12	;0x00014
	calla	#__unpack_f		;

	mov	24(r1),	r13	;0x00018

	mov.b	#1,	r10	;r3 As==01
	cmp	r13,	r10	;
	jnc	.L116     	;abs 0x5520

.L109:
	mov	26(r1),	r13	;0x0001a
	xor	36(r1),	r13	;0x00024
	clr	r12		;
	sub	r13,	r12	;
	bis	r13,	r12	;

	rpt #15 { rrux.w	r12		;
	mov	r12,	26(r1)	; 0x001a

.L111:
	mova	r1,	r12	;
	adda	#24,	r12	;0x00018

.L112:
	calla	#__pack_f		;0x05e00

	adda	#54,	r1	;0x00036

	popm.a	#4,	r10	;20-bit words

	reta			;

.L116:
	mov	34(r1),	r12	;0x00022

	mov.b	#1,	r11	;r3 As==01
	cmp	r12,	r11	;
	jnc	.L121     	;abs 0x554a

.L118:
	mov	26(r1),	r13	;0x0001a
	xor	36(r1),	r13	;0x00024
	clr	r12		;
	sub	r13,	r12	;
	bis	r13,	r12	;

	rpt #15 { rrux.w	r12		;
	mov	r12,	36(r1)	; 0x0024

.L120:
	mova	r1,	r12	;
	adda	#34,	r12	;0x00022
	jmp .L112	;mova	#21780,	r0	;0x05514

.L121:
	cmp	#4,	r13	;r2 As==10
	jnz	.L124     	;abs 0x555a

	cmp	#2,	r12	;r3 As==10
	jnz	.L109     	;abs 0x54f8

.L123:
	mova	#82944,	r12	;0x14400
	jmp .L112	;mova	#21780,	r0	;0x05514

.L124:
	cmp	#4,	r12	;r2 As==10
	jnz	.L126     	;abs 0x5566

	cmp	#2,	r13	;r3 As==10
	jz	.L123     	;abs 0x5552
	jmp .L118	;mova	#21802,	r0	;0x0552a

.L126:
	mov	36(r1),	r14	;0x00024
	xor	26(r1),	r14	;0x0001a
	clr	r15		;
	sub	r14,	r15	;
	bis	r14,	r15	;
	rpt #15 { rrux.w	r15		;
	mov	r15,	10(r1)	; 0x000a

	cmp	#2,	r13	;r3 As==10
	jnz	.L129     	;abs 0x5588

	mov	r15,	26(r1)	; 0x001a
	jmp .L111	;mova	#21774,	r0	;0x0550e

.L129:
	cmp	#2,	r12	;r3 As==10
	jnz	.L131     	;abs 0x5596

	mov	10(r1),	36(r1)	;0x0000a, 0x0024
	jmp .L120	;mova	#21824,	r0	;0x05540

.L131:
	mov	30(r1),	6(r1)	;0x0001e
	mov	32(r1),	8(r1)	;0x00020

	mov	40(r1),	0(r1)	;0x00028
	mov	42(r1),	2(r1)	;0x0002a

	mov	#32,	4(r1)	;#0x0020

	clr.b	r12		;
	clr.b	r13		;

	mov	r12,	r14	;
	mov	r13,	r15	;

	mov	r12,	r8	;
	mov	r13,	r9	;

.L137:
	mov	6(r1),	r10	;
	and.b	#1,	r10	;r3 As==01

	cmp	#0,	r10	;r3 As==00
	jz	.L146     	;abs 0x560a

	addx.w	@r1,	r8	;

	addcx.w	2(r1),	r9	;

	mov	r14,	r10	;
	add	r12,	r10	;
	mov	r10,	12(r1)	; 0x000c
	mov	r15,	r11	;
	addc	r13,	r11	;
	mov	r11,	14(r1)	; 0x000e

	mov.b	#1,	r11	;r3 As==01
	clr.b	r10		;
	cmp	2(r1),	r9	;
	jnc	.L144     	;abs 0x55fe
	mov	2(r1),	r7	;
	cmp	r9,	r7	;
	jnz	.L143      	;abs 0x55fa
	cmp	@r1,	r8	;
	jnc	.L144      	;abs 0x55fe

.L143:
	clr.b	r11		;
	mov	r11,	r10	;

.L144:
	mov	12(r1),	r12	;0x0000c

	add	r11,	r12	;
	mov	14(r1),	r13	;0x0000e
	addc	r10,	r13	;

.L146:
	mov	r14,	r10	;
	mov	r15,	r11	;
	add	r14,	r10	;
	addc	r15,	r11	;
	mov	r10,	r14	;

	mov	r11,	r15	;

	mov	2(r1),	r10	;
	cmp	#0,	r10	;r3 As==00
	jge	.L150      	;abs 0x5624

	mov	r14,	r7	;
	bis	#1,	r7	;r3 As==01
	mov	r7,	r14	;

.L150:
	addx.w	@r1,	0(r1)	;
	rlcx.w	2(r1)		;

	clrc			
	rrcx.w	8(r1)		;
	rrcx.w	6(r1)		;

	add	#-1,	4(r1)	;r3 As==11

	cmp	#0,	4(r1)	;r3 As==00
	jnz	.L137    	;abs 0x55c0

	mov	28(r1),	r10	;0x0001c
	add	38(r1),	r10	;0x00026

	incd	r10		;

	mov	r10,	48(r1)	; 0x0030

	mov	10(r1),	46(r1)	;0x0000a, 0x002e

	mov	4(r1),	r14	;

	mov.b	#1,	r7	;r3 As==01

.L160:
	cmp	#0,	r13	;r3 As==00
	jl	.L171     	;abs 0x56a8
	cmp	#0,	r14	;r3 As==00
	jz	.L161      	;abs 0x5670
	mov	r10,	48(r1)	; 0x0030

.L161:
	mov	48(r1),	r14	;0x00030

	clr.b	r15		;

.L163:
	mov	#16383,	r11	;#0x3fff
	cmp	r13,	r11	;
	jnc	.L176     	;abs 0x56d0

	mov	r12,	r10	;
	mov	r13,	r11	;
	add	r12,	r10	;
	addc	r13,	r11	;
	mov	r10,	r12	;

	mov	r11,	r13	;

	cmp	#0,	r9	;r3 As==00
	jge	.L168      	;abs 0x5694

	mov	r12,	r7	;
	bis	#1,	r7	;r3 As==01
	mov	r7,	r12	;

.L168:
	mov	r8,	r10	;
	mov	r9,	r11	;
	add	r8,	r10	;
	addc	r9,	r11	;
	mov	r10,	r8	;

	mov	r11,	r9	;

	add	#-1,	r14	;r3 As==11
	mov.b	#1,	r15	;r3 As==01
	jmp .L163	;mova	#22134,	r0	;0x05676

.L171:
	mov	r12,	r14	;
	and.b	#1,	r14	;r3 As==01

	cmp	#0,	r14	;r3 As==00
	jz	.L175     	;abs 0x56c2

	mov	r8,	r14	;
	mov	r9,	r15	;
	clrc			
	rrc	r15		;
	rrc	r14		;

	mov	r14,	r8	;
	mov	r15,	r9	;
	bis	#-32768,r9	;#0x8000

.L175:
	clrc			
	rrc	r13		;
	rrc	r12		;
	inc	r10		;
	mov	r7,	r14	;
	jmp .L160	;mova	#22116,	r0	;0x05664

.L176:
	cmp	#0,	r15	;r3 As==00
	jz	.L177      	;abs 0x56d8
	mov	r14,	48(r1)	; 0x0030

.L177:
	mov	r12,	r14	;
	and.b	#127,	r14	;#0x007f

	cmp	#64,	r14	;#0x0040
	jnz	.L184     	;abs 0x5708

	mov	r12,	r14	;
	and.b	#128,	r14	;#0x0080

	cmp	#0,	r14	;r3 As==00
	jnz	.L184     	;abs 0x5708

	mov	r8,	r14	;
	bis	r9,	r14	;
	cmp	#0,	r14	;r3 As==00
	jz	.L184     	;abs 0x5708

	mov	r12,	r15	;
	add	#64,	r15	;#0x0040
	mov	r13,	r14	;
	adc	r14		;

	mov	r15,	r12	;
	and	#-128,	r12	;#0xff80
	mov	r14,	r13	;

.L184:
	mov	r12,	50(r1)	; 0x0032
	mov	r13,	52(r1)	; 0x0034

	mov	#3,	44(r1)	; 0x002c

	mova	r1,	r12	;

	adda	#44,	r12	;0x0002c
	jmp .L112	;mova	#21780,	r0	;0x05514



	.global __mspabi_divf
	.type __mspabi_divf, @function
__mspabi_divf:
	nop
	nop
	pushm.a	#4,	r10	;20-bit words

	suba	#34,	r1	;0x00022

	mov	r12,	6(r1)	;
	mov	r13,	8(r1)	;

	mov	r14,	10(r1)	; 0x000a
	mov	r15,	12(r1)	; 0x000c

	mova	r1,	r13	;
	adda	#14,	r13	;0x0000e
	mova	r1,	r12	;

	adda	#6,	r12	;
	calla	#__unpack_f		;

	mova	r1,	r13	;
	adda	#24,	r13	;0x00018
	mova	r1,	r12	;
	adda	#10,	r12	;0x0000a
	calla	#__unpack_f		;

	mov	14(r1),	r13	;0x0000e

	mov.b	#1,	r7	;r3 As==01
	cmp	r13,	r7	;
	jnc	.L201     	;abs 0x5772

.L196:
	mova	r1,	r12	;
	adda	#14,	r12	;0x0000e

.L197:
	calla	#__pack_f		;0x05e00

	adda	#34,	r1	;0x00022

	popm.a	#4,	r10	;20-bit words

	reta			;

.L201:
	mov	24(r1),	r12	;0x00018

	mov.b	#1,	r8	;r3 As==01
	cmp	r12,	r8	;
	jc	.L246    	;abs 0x5876

	xor	26(r1),	16(r1)	;0x0001a, 0x0010

	cmp	#4,	r13	;r2 As==10
	jz	.L206      	;abs 0x578a

	cmp	#2,	r13	;r3 As==10
	jnz	.L208     	;abs 0x5796

.L206:
	cmp	r12,	r13	;
	jnz	.L196     	;abs 0x5760

	mova	#82944,	r12	;0x14400
	jmp .L197	;mova	#22374,	r0	;0x05766

.L208:
	cmp	#4,	r12	;r2 As==10
	jnz	.L212     	;abs 0x57aa

	mov	#0,	20(r1)	;r3 As==00, 0x0014
	mov	#0,	22(r1)	;r3 As==00, 0x0016

	mov	#0,	18(r1)	;r3 As==00, 0x0012

	jmp .L196	;mova	#22368,	r0	;0x05760

.L212:
	cmp	#2,	r12	;r3 As==10
	jnz	.L215     	;abs 0x57b6

	mov	#4,	14(r1)	;r2 As==10, 0x000e

	jmp .L196	;mova	#22368,	r0	;0x05760

.L215:
	mov	18(r1),	r14	;0x00012
	sub	28(r1),	r14	;0x0001c

	mov	r14,	18(r1)	; 0x0012

	mov	20(r1),	r12	;0x00014
	mov	22(r1),	r13	;0x00016

	mov	30(r1),	r10	;0x0001e
	mov	32(r1),	r11	;0x00020

	cmp	r11,	r13	;
	jnc	.L220     	;abs 0x57de
	cmp	r13,	r11	;
	jnz	.L223     	;abs 0x57f0
	cmp	r10,	r12	;
	jc	.L223     	;abs 0x57f0

.L220:
	mov	r12,	r7	;
	mov	r13,	r8	;
	add	r12,	r7	;
	addc	r13,	r8	;
	mov	r7,	r12	;

	mov	r8,	r13	;

	add	#-1,	r14	;r3 As==11
	mov	r14,	18(r1)	; 0x0012

.L223:
	mov.b	#31,	r9	;#0x001f

	clr.b	r14		;
	mov	r14,	r15	;

	mov	#0,	0(r1)	;r3 As==00
	mov	#16384,	2(r1)	;#0x4000

	mov	r11,	4(r1)	;

.L227:
	cmp	r11,	r13	;
	jnc	.L231     	;abs 0x5826
	cmp	r13,	4(r1)	;
	jnz	.L228      	;abs 0x5814
	cmp	r10,	r12	;
	jnc	.L231     	;abs 0x5826

.L228:
	mov	r14,	r7	;
	bis	@r1,	r7	;
	mov	r15,	r8	;
	bis	2(r1),	r8	;
	mov	r7,	r14	;

	mov	r8,	r15	;

	sub	r10,	r12	;
	subc	r11,	r13	;

.L231:
	clrc			
	rrcx.w	2(r1)		;
	rrcx.w	@r1		;

	mov	r12,	r7	;
	mov	r13,	r8	;
	add	r12,	r7	;
	addc	r13,	r8	;
	mov	r7,	r12	;

	mov	r8,	r13	;

	add	#-1,	r9	;r3 As==11
	cmp	#0,	r9	;r3 As==00
	jnz	.L227     	;abs 0x5806

	mov	r14,	r10	;

	and.b	#127,	r10	;#0x007f

	cmp	#64,	r10	;#0x0040
	jnz	.L245     	;abs 0x586a

	mov	r14,	r10	;
	and.b	#128,	r10	;#0x0080

	cmp	#0,	r10	;r3 As==00
	jnz	.L245     	;abs 0x586a

	bis	r8,	r12	;

	cmp	#0,	r12	;r3 As==00
	jz	.L245     	;abs 0x586a

	add	#64,	r14	;#0x0040

	adc	r15		;

	and	#-128,	r14	;#0xff80

.L245:
	mov	r14,	20(r1)	; 0x0014
	mov	r15,	22(r1)	; 0x0016
	jmp .L196	;mova	#22368,	r0	;0x05760

.L246:
	mova	r1,	r12	;
	adda	#24,	r12	;0x00018
	jmp .L197	;mova	#22374,	r0	;0x05766



	.global __mspabi_cvtfd
	.type __mspabi_cvtfd, @function
__mspabi_cvtfd:
	nop
	nop
	pushm.a	#3,	r10	;20-bit words

	suba	#22,	r1	;0x00016

	mov	r12,	8(r1)	;
	mov	r13,	10(r1)	; 0x000a

	mova	r1,	r13	;
	adda	#12,	r13	;0x0000c
	mova	r1,	r12	;

	adda	#8,	r12	;
	calla	#__unpack_f		;0x05f68

	mov	20(r1),	r9	;0x00014

	mov	18(r1),	r8	;0x00012
	clr.b	r10		;
	mov	r10,	r11	;
	mov.b	#30,	r12	;#0x001e
	calla	#__mspabi_sllll		;0x05db4
	mov	r12,	0(r1)	;
	mov	r13,	2(r1)	;
	mov	r14,	4(r1)	;
	mov	r15,	6(r1)	;
	mov	16(r1),	r14	;0x00010
	mov	14(r1),	r13	;0x0000e
	mov	12(r1),	r12	;0x0000c
	calla	#__make_dp		;0x05d0c

	adda	#22,	r1	;0x00016

	popm.a	#3,	r10	;20-bit words

	reta			;



	.global __mspabi_divd
	.type __mspabi_divd, @function
__mspabi_divd:
	nop
	nop
	pushm.a	#4,	r10	;20-bit words

	suba	#72,	r1	;0x00048

	mov	r8,	28(r1)	; 0x001c
	mov	r9,	30(r1)	; 0x001e
	mov	r10,	32(r1)	; 0x0020
	mov	r11,	34(r1)	; 0x0022

	mov	r12,	36(r1)	; 0x0024
	mov	r13,	38(r1)	; 0x0026
	mov	r14,	40(r1)	; 0x0028
	mov	r15,	42(r1)	; 0x002a

	mova	r1,	r13	;
	adda	#44,	r13	;0x0002c
	mova	r1,	r12	;

	adda	#28,	r12	;0x0001c
	calla	#__unpack_f		;

	mova	r1,	r13	;
	adda	#58,	r13	;0x0003a
	mova	r1,	r12	;
	adda	#36,	r12	;0x00024
	calla	#__unpack_f		;

	mov	44(r1),	r13	;0x0002c

	mov.b	#1,	r12	;r3 As==01
	cmp	r13,	r12	;
	jnc	.L269     	;abs 0x593c

.L264:
	mova	r1,	r12	;
	adda	#44,	r12	;0x0002c

.L265:
	calla	#__pack_d		;0x06088

	adda	#72,	r1	;0x00048

	popm.a	#4,	r10	;20-bit words

	reta			;

.L269:
	mov	58(r1),	r12	;0x0003a

	mov.b	#1,	r14	;r3 As==01
	cmp	r12,	r14	;
	jc	.L333    	;abs 0x5c24

	xor	60(r1),	46(r1)	;0x0003c, 0x002e

	cmp	#4,	r13	;r2 As==10
	jz	.L274      	;abs 0x5954

	cmp	#2,	r13	;r3 As==10
	jnz	.L276     	;abs 0x5960

.L274:
	cmp	r12,	r13	;
	jnz	.L264     	;abs 0x592a

	mova	#82954,	r12	;0x1440a
	jmp .L265	;mova	#22832,	r0	;0x05930

.L276:
	cmp	#4,	r12	;r2 As==10
	jnz	.L280     	;abs 0x597c

	mov	#0,	50(r1)	;r3 As==00, 0x0032
	mov	#0,	52(r1)	;r3 As==00, 0x0034
	mov	#0,	54(r1)	;r3 As==00, 0x0036
	mov	#0,	56(r1)	;r3 As==00, 0x0038

	mov	#0,	48(r1)	;r3 As==00, 0x0030

	jmp .L264	;mova	#22826,	r0	;0x0592a

.L280:
	cmp	#2,	r12	;r3 As==10
	jnz	.L283     	;abs 0x5988

	mov	#4,	44(r1)	;r2 As==10, 0x002c

	jmp .L264	;mova	#22826,	r0	;0x0592a

.L283:
	mov	48(r1),	r10	;0x00030
	sub	62(r1),	r10	;0x0003e

	mov	r10,	48(r1)	; 0x0030

	mov	50(r1),	4(r1)	;0x00032
	mov	52(r1),	2(r1)	;0x00034
	mov	54(r1),	r7	;0x00036
	mov	56(r1),	6(r1)	;0x00038

	mov	64(r1),	22(r1)	;0x00040, 0x0016
	mov	66(r1),	12(r1)	;0x00042, 0x000c
	mov	68(r1),	14(r1)	;0x00044, 0x000e
	mov	70(r1),	16(r1)	;0x00046, 0x0010

	cmp	16(r1),	6(r1)	;0x00010
	jnc	.L288     	;abs 0x59f6
	cmp	6(r1),	16(r1)	; 0x0010
	jnz	.L297    	;abs 0x5a56
	cmp	14(r1),	r7	;0x0000e
	jnc	.L288     	;abs 0x59f6
	cmp	r7,	14(r1)	; 0x000e
	jnz	.L297    	;abs 0x5a56
	cmp	12(r1),	2(r1)	;0x0000c
	jnc	.L288     	;abs 0x59f6
	cmp	2(r1),	12(r1)	; 0x000c
	jnz	.L297    	;abs 0x5a56
	cmp	22(r1),	4(r1)	;0x00016
	jc	.L297     	;abs 0x5a56

.L288:
	mov	4(r1),	r9	;
	rla	r9		;
	mov.b	#1,	r13	;r3 As==01
	cmp	4(r1),	r9	;
	jnc	.L289      	;abs 0x5a06
	clr.b	r13		;

.L289:
	mov	2(r1),	r14	;
	rla	r14		;
	mov.b	#1,	r12	;r3 As==01
	cmp	2(r1),	r14	;
	jnc	.L290      	;abs 0x5a16
	clr.b	r12		;

.L290:
	add	r14,	r13	;
	mov.b	#1,	r15	;r3 As==01
	cmp	r14,	r13	;
	jnc	.L291      	;abs 0x5a20
	clr.b	r15		;

.L291:
	bis	r15,	r12	;
	mov	r7,	r15	;
	add	r7,	r15	;
	mov.b	#1,	r14	;r3 As==01
	cmp	r7,	r15	;
	jnc	.L292      	;abs 0x5a2e
	clr.b	r14		;

.L292:
	add	r15,	r12	;
	mov.b	#1,	r8	;r3 As==01

	cmp	r15,	r12	;
	jnc	.L294      	;abs 0x5a38
	clr.b	r8		;

.L294:
	bis	r8,	r14	;
	mov	6(r1),	r15	;
	rla	r15		;
	mov	r9,	4(r1)	;
	mov	r13,	2(r1)	;
	mov	r12,	r7	;

	add	r15,	r14	;
	mov	r14,	6(r1)	;

	add	#-1,	r10	;r3 As==11
	mov	r10,	48(r1)	; 0x0030

.L297:
	mov	#61,	20(r1)	;#0x003d, 0x0014

	mov	#0,	0(r1)	;r3 As==00
	mov	@r1,	8(r1)	;
	mov	@r1,	10(r1)	; 0x000a
	mov	@r1,	18(r1)	; 0x0012

	mov	@r1,	r8	;
	mov	r8,	24(r1)	; 0x0018
	mov	r8,	r10	;
	mov	#4096,	r11	;#0x1000

.L300:
	cmp	16(r1),	6(r1)	;0x00010
	jnc	.L310    	;abs 0x5b2e
	cmp	6(r1),	16(r1)	; 0x0010
	jnz	.L301     	;abs 0x5aac
	cmp	14(r1),	r7	;0x0000e
	jnc	.L310    	;abs 0x5b2e
	cmp	r7,	14(r1)	; 0x000e
	jnz	.L301     	;abs 0x5aac
	cmp	12(r1),	2(r1)	;0x0000c
	jnc	.L310    	;abs 0x5b2e
	cmp	2(r1),	12(r1)	; 0x000c
	jnz	.L301     	;abs 0x5aac
	cmp	22(r1),	4(r1)	;0x00016
	jnc	.L310    	;abs 0x5b2e

.L301:
	bis	r8,	0(r1)	;

	bis	24(r1),	8(r1)	;0x00018
	bis	r10,	10(r1)	; 0x000a
	bis	r11,	18(r1)	; 0x0012

	mov	4(r1),	r12	;
	sub	22(r1),	r12	;0x00016
	mov	r12,	26(r1)	; 0x001a
	mov.b	#1,	r14	;r3 As==01
	cmp	r12,	4(r1)	;
	jnc	.L304      	;abs 0x5ad4
	clr.b	r14		;

.L304:
	mov	2(r1),	r12	;
	sub	12(r1),	r12	;0x0000c
	mov.b	#1,	r13	;r3 As==01
	cmp	r12,	2(r1)	;
	jnc	.L305      	;abs 0x5ae6
	clr.b	r13		;

.L305:
	mov	r12,	r9	;
	sub	r14,	r9	;
	mov.b	#1,	r14	;r3 As==01
	cmp	r9,	r12	;
	jnc	.L306      	;abs 0x5af2
	clr.b	r14		;

.L306:
	bis	r14,	r13	;
	movx.w	r7,	r14	;
	subx.w	14(r1),	r14	;0x0000e
	mov.b	#1,	r12	;r3 As==01
	cmp	r14,	r7	;
	jnc	.L307      	;abs 0x5b06
	clr.b	r12		;

.L307:
	mov	r14,	r15	;
	sub	r13,	r15	;
	mov.b	#1,	r13	;r3 As==01
	cmp	r15,	r14	;
	jnc	.L308      	;abs 0x5b12
	clr.b	r13		;

.L308:
	bis	r13,	r12	;
	mov	6(r1),	r13	;
	sub	16(r1),	r13	;0x00010
	mov	26(r1),	4(r1)	;0x0001a

	mov	r9,	2(r1)	;
	mov	r15,	r7	;
	sub	r12,	r13	;
	mov	r13,	6(r1)	;

.L310:
	mov	24(r1),	r9	;0x00018
	mov.b	#1,	r12	;r3 As==01
	calla	#__mspabi_srlll		;0x05de0
	mov	r12,	r8	;
	mov	r13,	24(r1)	; 0x0018
	mov	r14,	r10	;
	mov	r15,	r11	;

	mov	4(r1),	r12	;
	rla	r12		;
	mov.b	#1,	r9	;r3 As==01
	cmp	4(r1),	r12	;
	jnc	.L312      	;abs 0x5b52
	clr.b	r9		;

.L312:
	mov	2(r1),	r14	;
	rla	r14		;
	mov.b	#1,	r13	;r3 As==01

	cmp	2(r1),	r14	;
	jnc	.L314      	;abs 0x5b62
	clr.b	r13		;

.L314:
	add	r14,	r9	;
	mov.b	#1,	r15	;r3 As==01
	cmp	r14,	r9	;
	jnc	.L315      	;abs 0x5b6c
	clr.b	r15		;

.L315:
	bis	r15,	r13	;
	mov	r7,	r15	;
	add	r7,	r15	;
	mov.b	#1,	r14	;r3 As==01
	cmp	r7,	r15	;
	jnc	.L316      	;abs 0x5b7a
	clr.b	r14		;

.L316:
	add	r15,	r13	;
	mov.b	#1,	r7	;r3 As==01

	cmp	r15,	r13	;
	jnc	.L318      	;abs 0x5b84
	clr.b	r7		;

.L318:
	bis	r7,	r14	;
	mov	6(r1),	r15	;
	rla	r15		;
	mov	r12,	4(r1)	;
	mov	r9,	2(r1)	;
	mov	r13,	r7	;
	add	r15,	r14	;
	mov	r14,	6(r1)	;

	add	#-1,	20(r1)	;r3 As==11, 0x0014
	cmp	#0,	20(r1)	;r3 As==00, 0x0014
	jnz	.L300    	;abs 0x5a78

	mov	@r1,	r15	;
	and.b	#255,	r15	;#0x00ff

	mov	@r1,	r14	;

	cmp.b	#-128,	r14	;#0xff80
	jnz	.L332     	;abs 0x5c0a

	bit	#256,	r14	;#0x0100
	jnz	.L332     	;abs 0x5c0a

	bis	r9,	r12	;

	bis	r13,	r12	;
	bis	6(r1),	r12	;
	cmp	#0,	r12	;r3 As==00
	jz	.L332     	;abs 0x5c0a

	add	r14,	r15	;
	mov.b	#1,	r13	;r3 As==01
	cmp	r14,	r15	;
	jnc	.L327      	;abs 0x5bd2
	mov	20(r1),	r13	;0x00014

.L327:
	clr.b	r12		;
	add	8(r1),	r13	;
	mov.b	#1,	r14	;r3 As==01
	cmp	8(r1),	r13	;
	jnc	.L328      	;abs 0x5be2
	mov	r12,	r14	;

.L328:
	bis	r14,	r12	;
	clr.b	r14		;
	add	10(r1),	r12	;0x0000a
	mov.b	#1,	r10	;r3 As==01

	cmp	10(r1),	r12	;0x0000a
	jnc	.L330      	;abs 0x5bf4
	mov	r14,	r10	;

.L330:
	bis	r10,	r14	;

	and	#-256,	r15	;#0xff00
	mov	r15,	0(r1)	;
	mov	r13,	8(r1)	;
	mov	r12,	10(r1)	; 0x000a
	add	r14,	18(r1)	; 0x0012

.L332:
	mov	@r1,	50(r1)	; 0x0032
	mov	8(r1),	52(r1)	; 0x0034
	mov	10(r1),	54(r1)	;0x0000a, 0x0036
	mov	18(r1),	56(r1)	;0x00012, 0x0038
	jmp .L264	;mova	#22826,	r0	;0x0592a

.L333:
	mova	r1,	r12	;
	adda	#58,	r12	;0x0003a
	jmp .L265	;mova	#22832,	r0	;0x05930



	.global __gedf2
	.type __gedf2, @function
__gedf2:
	nop
	nop
	pushm.a	#1,	r10	;20-bit words

	suba	#44,	r1	;0x0002c

	mov	r12,	0(r1)	;
	mov	r13,	2(r1)	;
	mov	r14,	4(r1)	;
	mov	r15,	6(r1)	;

	mov	52(r1),	8(r1)	;0x00034
	mov	54(r1),	10(r1)	;0x00036, 0x000a
	mov	56(r1),	12(r1)	;0x00038, 0x000c
	mov	58(r1),	14(r1)	;0x0003a, 0x000e

	mova	r1,	r13	;
	adda	#16,	r13	;0x00010
	mova	r1,	r12	;

	calla	#__unpack_f		;

	mova	r1,	r13	;
	adda	#30,	r13	;0x0001e
	mova	r1,	r12	;
	adda	#8,	r12	;
	calla	#__unpack_f		;

	mov.b	#1,	r12	;r3 As==01
	cmp	16(r1),	r12	;0x00010
	jc	.L346     	;abs 0x5c9e

	cmp	30(r1),	r12	;0x0001e
	jc	.L346     	;abs 0x5c9e

	mova	r1,	r13	;
	adda	#30,	r13	;0x0001e
	mova	r1,	r12	;
	adda	#16,	r12	;0x00010
	calla	#__fpcmp_parts_d		;0x064d0

.L343:
	adda	#44,	r1	;0x0002c

	popm.a	#1,	r10	;20-bit words

	reta			;

.L346:
	mov	#-1,	r12	;r3 As==11
	jmp .L343	;mova	#23702,	r0	;0x05c96



	.global __unorddf2
	.type __unorddf2, @function
__unorddf2:
	nop
	nop
	pushm.a	#1,	r10	;20-bit words

	suba	#44,	r1	;0x0002c

	mov	r12,	0(r1)	;
	mov	r13,	2(r1)	;
	mov	r14,	4(r1)	;
	mov	r15,	6(r1)	;

	mov	52(r1),	8(r1)	;0x00034
	mov	54(r1),	10(r1)	;0x00036, 0x000a
	mov	56(r1),	12(r1)	;0x00038, 0x000c
	mov	58(r1),	14(r1)	;0x0003a, 0x000e

	mova	r1,	r13	;
	adda	#16,	r13	;0x00010
	mova	r1,	r12	;

	calla	#__unpack_f		;

	mova	r1,	r13	;
	adda	#30,	r13	;0x0001e
	mova	r1,	r12	;
	adda	#8,	r12	;
	calla	#__unpack_f		;

	mov.b	#1,	r12	;r3 As==01
	cmp	16(r1),	r12	;0x00010
	jc	.L358     	;abs 0x5d06

	cmp	30(r1),	r12	;0x0001e
	jc	.L355      	;abs 0x5cfe
	clr.b	r12		;

.L355:
	adda	#44,	r1	;0x0002c

	popm.a	#1,	r10	;20-bit words

	reta			;

.L358:
	mov.b	#1,	r12	;r3 As==01
	jmp .L355	;mova	#23806,	r0	;0x05cfe



	.global __make_dp
	.type __make_dp, @function
__make_dp:
	nop
	nop
	suba	#14,	r1	;0x0000e

	mov	r12,	0(r1)	;

	mov	r13,	2(r1)	;

	mov	r14,	4(r1)	;

	mov	18(r1),	6(r1)	;0x00012
	mov	20(r1),	8(r1)	;0x00014
	mov	22(r1),	10(r1)	;0x00016, 0x000a
	mov	24(r1),	12(r1)	;0x00018, 0x000c

	mova	r1,	r12	;

	calla	#__pack_d		;0x06088

	adda	#14,	r1	;0x0000e

	reta			;



	.global __mspabi_cvtdf
	.type __mspabi_cvtdf, @function
__mspabi_cvtdf:
	nop
	nop
	pushm.a	#3,	r10	;20-bit words

	suba	#24,	r1	;0x00018

	mov	r12,	2(r1)	;
	mov	r13,	4(r1)	;
	mov	r14,	6(r1)	;
	mov	r15,	8(r1)	;

	mova	r1,	r13	;
	adda	#10,	r13	;0x0000a
	mova	r1,	r12	;

	adda	#2,	r12	;
	calla	#__unpack_d		;0x06378

	mov	16(r1),	r8	;0x00010
	mov	18(r1),	r9	;0x00012
	mov	20(r1),	r10	;0x00014
	mov	22(r1),	r11	;0x00016
	mov.b	#30,	r12	;#0x001e
	calla	#__mspabi_srlll		;0x05de0

	mov	r12,	r15	;

	and	#16383,	r9	;#0x3fff

	bis	r8,	r9	;
	cmp	#0,	r9	;r3 As==00
	jz	.L376      	;abs 0x5d8c

	bis	#1,	r15	;r3 As==01

.L376:
	mov	r13,	0(r1)	;
	mov	14(r1),	r14	;0x0000e
	mov	12(r1),	r13	;0x0000c

	mov	10(r1),	r12	;0x0000a
	calla	#__make_fp		;0x06046

	adda	#24,	r1	;0x00018

	popm.a	#3,	r10	;20-bit words

	reta			;

.L381:
	add	#-1,	r14	;r3 As==11
	rla	r12		;
	rlc	r13		;



	.global __mspabi_slll
	.type __mspabi_slll, @function
__mspabi_slll:
	nop
	nop
	cmp	#0,	r14	;r3 As==00
	jnz	.L381      	;abs 0x5da8
	reta			;



	.global __mspabi_sllll
	.type __mspabi_sllll, @function
__mspabi_sllll:
	nop
	nop
	mov	r11,	r15	;
	mov	r12,	r11	;
	mov	r10,	r14	;
	mov	r9,	r13	;
	mov	r8,	r12	;
	cmp	#0,	r11	;r3 As==00
	jnz	.L382      	;abs 0x5dc4
	reta			;

.L382:
	rla	r12		;
	rlc	r13		;
	rlc	r14		;
	rlc	r15		;
	add	#-1,	r11	;r3 As==11
	jnz	.L382     	;abs 0x5dc4
	reta			;

.L383:
	add	#-1,	r14	;r3 As==11
	clrc			
	rrc	r13		;
	rrc	r12		;



	.global __mspabi_srll
	.type __mspabi_srll, @function
__mspabi_srll:
	nop
	nop
	cmp	#0,	r14	;r3 As==00
	jnz	.L383     	;abs 0x5dd2
	reta			;



	.global __mspabi_srlll
	.type __mspabi_srlll, @function
__mspabi_srlll:
	nop
	nop
	mov	r11,	r15	;
	mov	r12,	r11	;
	mov	r10,	r14	;
	mov	r9,	r13	;
	mov	r8,	r12	;
	cmp	#0,	r11	;r3 As==00
	jnz	.L384      	;abs 0x5df0
	reta			;

.L384:
	clrc			
	rrc	r15		;
	rrc	r14		;
	rrc	r13		;
	rrc	r12		;
	add	#-1,	r11	;r3 As==11
	jnz	.L384     	;abs 0x5df0
	reta			;



	.global __pack_f
	.type __pack_f, @function
__pack_f:
	nop
	nop
	pushm.a	#4,	r10	;20-bit words

	suba	#8,	r1	;

	mov	6(r12),	r8	;
	mov	8(r12),	r9	;

	mov	2(r12),	r7	;

	mov	@r12,	r13	;

	mov.b	#1,	r14	;r3 As==01
	cmp	r13,	r14	;
	jnc	.L400     	;abs 0x5e5e

	mov	r8,	r12	;

	mov	r9,	r13	;
	mov.b	#7,	r14	;
	calla	#__mspabi_srll		;0x05dda

	and.b	#63,	r13	;#0x003f

	mov	r12,	r8	;
	mov	r13,	r9	;
	bis	#64,	r9	;#0x0040

	mov.b	#255,	r10	;#0x00ff

.L395:
	mov	r8,	r12	;
	mov	r9,	r13	;
	mov.b	#16,	r14	;#0x0010
	calla	#__mspabi_srll		;0x05dda
	and.b	#127,	r12	;#0x007f
	rpt #7 { rlax.w	r10		;

	bis	r12,	r10	;
	mov	r7,	r13	;
	rpt #15 { rlax.w	r13		;

	mov	r8,	r12	;
	bis	r10,	r13	;
	adda	#8,	r1	;

	popm.a	#4,	r10	;20-bit words

	reta			;

.L400:
	cmp	#4,	r13	;r2 As==10
	jz	.L444    	;abs 0x5f60

	cmp	#2,	r13	;r3 As==10
	jz	.L441    	;abs 0x5f56

	mov	r8,	r10	;
	bis	r9,	r10	;
	cmp	#0,	r10	;r3 As==00
	jz	.L395     	;abs 0x5e36

	mov	4(r12),	r10	;

	cmp	#-126,	r10	;#0xff82
	jge	.L425    	;abs 0x5f0c

	mov	#-126,	r12	;#0xff82
	sub	r10,	r12	;

	mov.b	#25,	r13	;#0x0019
	cmp	r12,	r13	;
	jl	.L421    	;abs 0x5f00

	mov	r12,	r10	;
	clr	r11		;
	mov	r8,	r12	;

	mov	r9,	r13	;
	mov	r10,	r14	;
	mova	r11,	0(r1)	;
	calla	#__mspabi_srll		;0x05dda
	mov	r12,	4(r1)	;
	mov	r13,	6(r1)	;

	mov	#-1,	r12	;r3 As==11
	mov	#-1,	r13	;r3 As==11
	mov	r10,	r14	;
	calla	#__mspabi_slll		;0x05dae
	mov	r8,	r14	;
	bic	r12,	r14	;
	mov	r9,	r12	;
	bic	r13,	r12	;

	bis	r14,	r12	;
	clr	r14		;
	sub	r12,	r14	;
	bis	r12,	r14	;
	rpt #15 { rrux.w	r14		;

	mov	4(r1),	r12	;
	bis	r14,	r12	;
	mov	6(r1),	r13	;

	mov	r12,	r14	;
	and.b	#127,	r14	;#0x007f

	cmp	#64,	r14	;#0x0040
	jnz	.L423     	;abs 0x5f04

	mov	r12,	r14	;
	and.b	#128,	r14	;#0x0080

	cmp	#0,	r14	;r3 As==00
	jz	.L418      	;abs 0x5ee4

	add	#64,	r12	;#0x0040

.L417:
	adc	r13		;

.L418:
	mov.b	#1,	r10	;r3 As==01
	mov	#16383,	r14	;#0x3fff
	cmp	r13,	r14	;
	jnc	.L419      	;abs 0x5ef0
	clr.b	r10		;

.L419:
	mov.b	#7,	r14	;
	calla	#__mspabi_srll		;0x05dda
	mov	r12,	r8	;
	mov	r13,	r9	;

	jmp .L395	;mova	#24118,	r0	;0x05e36

.L421:
	clr.b	r12		;

	clr.b	r13		;

.L423:
	add	#63,	r12	;#0x003f

	jmp .L417	;mova	#24290,	r0	;0x05ee2

.L425:
	mov.b	#127,	r12	;#0x007f

	cmp	r10,	r12	;
	jl	.L444     	;abs 0x5f60

	mov	r8,	r12	;
	and.b	#127,	r12	;#0x007f

	cmp	#64,	r12	;#0x0040
	jnz	.L436     	;abs 0x5f40

	mov	r8,	r12	;
	and.b	#128,	r12	;#0x0080

	cmp	#0,	r12	;r3 As==00
	jz	.L433      	;abs 0x5f30

	add	#64,	r8	;#0x0040

.L432:
	adc	r9		;

.L433:
	cmp	#0,	r9	;r3 As==00
	jl	.L438     	;abs 0x5f48

	add	#127,	r10	;#0x007f

.L435:
	mov	r8,	r12	;
	mov	r9,	r13	;
	jmp .L419	;mova	#24304,	r0	;0x05ef0

.L436:
	add	#63,	r8	;#0x003f

	jmp .L432	;mova	#24366,	r0	;0x05f2e

.L438:
	clrc			
	rrc	r9		;
	rrc	r8		;

	add	#128,	r10	;#0x0080

	jmp .L435	;mova	#24376,	r0	;0x05f38

.L441:
	clr.b	r10		;

.L442:
	clr.b	r8		;

	clr.b	r9		;
	jmp .L395	;mova	#24118,	r0	;0x05e36

.L444:
	mov.b	#255,	r10	;#0x00ff
	jmp .L442	;mova	#24408,	r0	;0x05f58



	.global __unpack_f
	.type __unpack_f, @function
__unpack_f:
	nop
	nop
	pushm.a	#3,	r10	;20-bit words

	mova	r12,	r14	;
	mova	r13,	r10	;

	mov	@r12,	r12	;

	mov.b	2(r14),	r15	;
	mov	r15,	r13	;

	and.b	#127,	r13	;#0x007f

	mov	2(r14),	r9	;
	rpt #7 { rrux.w	r9		;

	mov.b	r9,	r11	;

	mov.b	3(r14),	r14	;

	rpt #7 { rrux.w	r14		;

	mov	r14,	2(r10)	;

	cmp.b	#0,	r9	;r3 As==00
	jnz	.L469     	;abs 0x5fde

	mov	r12,	r14	;
	bis	r13,	r14	;
	cmp	#0,	r14	;r3 As==00
	jnz	.L459     	;abs 0x5fa4

	mov	#2,	0(r10)	;r3 As==10

.L457:
	popm.a	#3,	r10	;20-bit words

	reta			;

.L459:
	mov.b	#7,	r14	;
	calla	#__mspabi_slll		;0x05dae

	mov	#3,	0(r10)	;

	mov	#-127,	r14	;#0xff81

.L462:
	mov	r12,	r8	;
	mov	r13,	r9	;
	add	r12,	r8	;
	addc	r13,	r9	;
	mov	r8,	r12	;

	mov	r9,	r13	;

	mov	r14,	r15	;

	add	#-1,	r14	;r3 As==11
	mov	#16383,	r9	;#0x3fff
	cmp	r13,	r9	;
	jc	.L462     	;abs 0x5fb6
	mov	r15,	4(r10)	;

	mov	r8,	6(r10)	;

.L467:
	mov	r13,	8(r10)	;

	jmp .L457	;mova	#24480,	r0	;0x05fa0

.L469:
	cmp	#255,	r11	;#0x00ff
	jnz	.L477     	;abs 0x6024

	mov	r12,	r14	;
	bis	r13,	r14	;
	cmp	#0,	r14	;r3 As==00
	jnz	.L472     	;abs 0x5ff4

	mov	#4,	0(r10)	;r2 As==10
	jmp .L457	;mova	#24480,	r0	;0x05fa0

.L472:
	mov	r15,	r14	;
	and.b	#64,	r14	;#0x0040
	bit	#64,	r15	;#0x0040
	jz	.L476     	;abs 0x601c

	mov	#1,	0(r10)	;r3 As==01

.L474:
	mov.b	#7,	r14	;
	calla	#__mspabi_slll		;0x05dae

	and	#-128,	r12	;#0xff80
	mov	r12,	6(r10)	;
	and	#-8193,	r13	;#0xdfff
	jmp .L467	;mova	#24534,	r0	;0x05fd6

.L476:
	mov	r14,	0(r10)	;
	jmp .L474	;mova	#24580,	r0	;0x06004

.L477:
	add	#-127,	r11	;#0xff81

	mov	r11,	4(r10)	;

	mov	#3,	0(r10)	;

	mov.b	#7,	r14	;
	calla	#__mspabi_slll		;0x05dae

	mov	r12,	6(r10)	;
	bis	#16384,	r13	;#0x4000
	jmp .L467	;mova	#24534,	r0	;0x05fd6



	.global __make_fp
	.type __make_fp, @function
__make_fp:
	nop
	nop
	suba	#2,	r1	;
	movx.a	2(r1),	0(r1)	;

	suba	#10,	r1	;0x0000a

	mov	r15,	14(r1)	; 0x000e

	mov	r12,	0(r1)	;

	mov	r13,	2(r1)	;

	mov	r14,	4(r1)	;

	mov	14(r1),	6(r1)	;0x0000e
	mov	16(r1),	8(r1)	;0x00010

	mova	r1,	r12	;

	calla	#__pack_f		;0x05e00

	adda	#10,	r1	;0x0000a

	movx.a	@r1,	2(r1)	;
	adda	#2,	r1	;
	reta			;



	.global __pack_d
	.type __pack_d, @function
__pack_d:
	nop
	nop
	pushm.a	#4,	r10	;20-bit words

	suba	#20,	r1	;0x00014

	mov	6(r12),	0(r1)	;
	mov	8(r12),	4(r1)	;
	mov	10(r12),6(r1)	;0x0000a
	mov	12(r12),2(r1)	;0x0000c

	mov	2(r12),	10(r1)	; 0x000a

	mov	@r12,	r13	;

	mov.b	#1,	r10	;r3 As==01
	cmp	r13,	r10	;
	jnc	.L509     	;abs 0x6110

	mov	@r1,	r8	;
	mov	4(r1),	r9	;
	mov	6(r1),	r10	;
	mov	2(r1),	r11	;
	mov.b	#8,	r12	;r2 As==11

	calla	#__mspabi_srlll		;0x05de0

	and.b	#7,	r15	;

	mov	r12,	0(r1)	;
	mov	r13,	4(r1)	;
	mov	r14,	6(r1)	;
	bis	#8,	r15	;r2 As==11

	mov	r15,	2(r1)	;

	mov	#2047,	r7	;#0x07ff

.L503:
	and	#2047,	r7	;#0x07ff

	mov	r7,	r11	;
	rlam	#4,	r11	;
	mov	2(r1),	r7	;
	and.b	#15,	r7	;#0x000f

	mov	10(r1),	r15	;0x0000a
	rpt #15 { rlax.w	r15		;
	bis	r11,	r7	;

	mov	@r1,	r12	;
	mov	4(r1),	r13	;
	mov	6(r1),	r14	;
	bis	r7,	r15	;
	adda	#20,	r1	;0x00014

	popm.a	#4,	r10	;20-bit words

	reta			;

.L509:
	cmp	#4,	r13	;r2 As==10
	jz	.L561    	;abs 0x6360

	cmp	#2,	r13	;r3 As==10
	jz	.L558    	;abs 0x634a

	mov	@r1,	r7	;
	bis	4(r1),	r7	;
	bis	6(r1),	r7	;
	bis	2(r1),	r7	;
	cmp	#0,	r7	;r3 As==00
	jz	.L503     	;abs 0x60e2

	mov	4(r12),	r7	;

	cmp	#-1022,	r7	;#0xfc02
	jge	.L540    	;abs 0x6290

	mov	#-1022,	r12	;#0xfc02

	sub	r7,	r12	;
	mov	r12,	8(r1)	;

	mov.b	#56,	r14	;#0x0038
	cmp	r12,	r14	;
	jl	.L532    	;abs 0x6230

	mov	@r1,	r8	;
	mov	4(r1),	r9	;
	mov	6(r1),	r10	;
	mov	2(r1),	r11	;
	calla	#__mspabi_srlll		;0x05de0

	mov	r12,	12(r1)	; 0x000c
	mov	r13,	14(r1)	; 0x000e
	mov	r14,	16(r1)	; 0x0010
	mov	r15,	18(r1)	; 0x0012

	mov	#-1,	r8	;r3 As==11
	mov	r8,	r9	;
	mov	r8,	r10	;
	mov	r8,	r11	;
	mov	8(r1),	r12	;
	calla	#__mspabi_sllll		;0x05db4
	mov	@r1,	r10	;
	bic	r12,	r10	;
	mov	r10,	r12	;
	mov	4(r1),	r10	;
	bic	r13,	r10	;
	mov	r10,	r13	;
	mov	6(r1),	r10	;
	bic	r14,	r10	;
	mov	r10,	r14	;
	mov	2(r1),	r10	;
	bic	r15,	r10	;
	mov	r10,	2(r1)	;

	clr.b	r11		;
	mov	r11,	r15	;
	sub	r12,	r15	;
	mov	r15,	0(r1)	;
	mov.b	#1,	r10	;r3 As==01
	cmp	r12,	r11	;
	jnz	.L521      	;abs 0x61aa
	mov	r15,	r10	;

.L521:
	mov	r11,	r15	;
	sub	r13,	r15	;
	mov.b	#1,	r7	;r3 As==01
	cmp	r13,	r11	;
	jnz	.L522      	;abs 0x61b6
	mov	r15,	r7	;

.L522:
	mov	r15,	r9	;
	sub	r10,	r9	;
	mov.b	#1,	r10	;r3 As==01
	cmp	r9,	r15	;
	jnc	.L523      	;abs 0x61c2
	clr.b	r10		;

.L523:
	bis	r10,	r7	;
	mov	r11,	r8	;
	sub	r14,	r8	;
	mov.b	#1,	r15	;r3 As==01
	cmp	r14,	r11	;
	jnz	.L524      	;abs 0x61d0
	mov	r8,	r15	;

.L524:
	mov	r8,	r10	;
	sub	r7,	r10	;
	mov.b	#1,	r7	;r3 As==01
	cmp	r10,	r8	;
	jnc	.L525      	;abs 0x61dc
	clr.b	r7		;

.L525:
	bis	r7,	r15	;
	sub	2(r1),	r11	;
	sub	r15,	r11	;
	mov	@r1,	r8	;
	bis	r12,	r8	;
	bis	r13,	r9	;
	bis	r14,	r10	;
	bis	2(r1),	r11	;
	mov.b	#63,	r12	;#0x003f
	calla	#__mspabi_srlll		;0x05de0

	mov	12(r1),	r8	;0x0000c
	bis	r12,	r8	;
	mov	14(r1),	r9	;0x0000e
	bis	r13,	r9	;
	mov	16(r1),	r10	;0x00010
	bis	r14,	r10	;
	mov	18(r1),	r11	;0x00012
	bis	r15,	r11	;

	mov	r8,	r15	;
	and.b	#255,	r15	;#0x00ff

	cmp.b	#-128,	r8	;#0xff80
	jnz	.L533     	;abs 0x6238

	bit	#256,	r8	;#0x0100
	jz	.L537     	;abs 0x626a

	add	r8,	r15	;
	mov.b	#1,	r13	;r3 As==01
	cmp	r8,	r15	;
	jnc	.L534     	;abs 0x6246

.L531:
	clr.b	r13		;
	jmp .L534	;mova	#25158,	r0	;0x06246

.L532:
	clr.b	r8		;
	mov	r8,	r9	;
	mov	r8,	r10	;
	mov	r8,	r11	;

.L533:
	mov	r8,	r15	;
	add	#127,	r15	;#0x007f
	mov.b	#1,	r13	;r3 As==01
	cmp	#-127,	r8	;#0xff81
	jnc	.L531     	;abs 0x622a

.L534:
	clr.b	r12		;
	add	r9,	r13	;
	mov.b	#1,	r14	;r3 As==01
	cmp	r9,	r13	;
	jnc	.L535      	;abs 0x6252
	mov	r12,	r14	;

.L535:
	bis	r14,	r12	;
	clr.b	r14		;
	add	r10,	r12	;
	mov.b	#1,	r9	;r3 As==01
	cmp	r10,	r12	;
	jnc	.L536      	;abs 0x6260
	mov	r14,	r9	;

.L536:
	bis	r9,	r14	;
	mov	r15,	r8	;
	mov	r13,	r9	;
	mov	r12,	r10	;
	add	r14,	r11	;

.L537:
	mov.b	#1,	r7	;r3 As==01
	mov	#4095,	r12	;#0x0fff
	cmp	r11,	r12	;
	jnc	.L538      	;abs 0x6276
	clr.b	r7		;

.L538:
	mov.b	#8,	r12	;r2 As==11
	calla	#__mspabi_srlll		;0x05de0
	mov	r12,	0(r1)	;
	mov	r13,	4(r1)	;
	mov	r14,	6(r1)	;
	mov	r15,	2(r1)	;

	jmp .L503	;mova	#24802,	r0	;0x060e2

.L540:
	mov	#1023,	r14	;#0x03ff
	cmp	r7,	r14	;
	jl	.L561    	;abs 0x6360

	mov	@r1,	r12	;

	cmp.b	#-128,	r12	;#0xff80
	jnz	.L546     	;abs 0x62ba

	bit	#256,	r12	;#0x0100
	jz	.L551     	;abs 0x62fe

	mov	r12,	r10	;
	add	#128,	r10	;#0x0080
	mov.b	#1,	r13	;r3 As==01
	cmp	#-128,	r12	;#0xff80
	jc	.L547     	;abs 0x62ca

.L545:
	clr.b	r13		;
	jmp .L547	;mova	#25290,	r0	;0x062ca

.L546:
	mov	@r1,	r10	;
	add	#127,	r10	;#0x007f
	mov.b	#1,	r13	;r3 As==01
	cmp	#-127,	0(r1)	;#0xff81
	jnc	.L545     	;abs 0x62b4

.L547:
	clr.b	r12		;
	add	4(r1),	r13	;
	mov.b	#1,	r14	;r3 As==01
	cmp	4(r1),	r13	;
	jnc	.L548      	;abs 0x62da
	mov	r12,	r14	;

.L548:
	bis	r14,	r12	;
	clr.b	r14		;
	add	6(r1),	r12	;
	mov.b	#1,	r15	;r3 As==01
	cmp	6(r1),	r12	;
	jnc	.L549      	;abs 0x62ec
	mov	r14,	r15	;

.L549:
	bis	r15,	r14	;
	mov	r10,	0(r1)	;

	mov	r13,	4(r1)	;
	mov	r12,	6(r1)	;
	add	r14,	2(r1)	;

.L551:
	mov	#8191,	r14	;#0x1fff
	cmp	2(r1),	r14	;
	jnc	.L554     	;abs 0x631e

	add	#1023,	r7	;#0x03ff

.L553:
	mov	@r1,	r8	;
	mov	4(r1),	r9	;
	mov	6(r1),	r10	;
	mov	2(r1),	r11	;
	jmp .L538	;mova	#25206,	r0	;0x06276

.L554:
	mov	@r1,	r8	;
	mov	4(r1),	r9	;
	mov	6(r1),	r10	;
	mov	2(r1),	r11	;
	mov.b	#1,	r12	;r3 As==01
	calla	#__mspabi_srlll		;0x05de0
	mov	r12,	0(r1)	;

	mov	r13,	4(r1)	;
	mov	r14,	6(r1)	;
	mov	r15,	2(r1)	;

	add	#1024,	r7	;#0x0400

	jmp .L553	;mova	#25356,	r0	;0x0630c

.L558:
	clr.b	r7		;

	mov	r7,	0(r1)	;

	mov	r7,	4(r1)	;
	mov	r7,	6(r1)	;
	mov	r7,	2(r1)	;
	jmp .L503	;mova	#24802,	r0	;0x060e2

.L561:
	mov	#2047,	r7	;#0x07ff

	mov	#0,	0(r1)	;r3 As==00

	mov	@r1,	4(r1)	;
	mov	@r1,	6(r1)	;
	mov	@r1,	2(r1)	;
	jmp .L503	;mova	#24802,	r0	;0x060e2



	.global __unpack_d
	.type __unpack_d, @function
__unpack_d:
	nop
	nop
	pushm.a	#4,	r10	;20-bit words

	suba	#6,	r1	;

	mova	r13,	r7	;

	mov	@r12,	r8	;
	mov	2(r12),	r9	;
	mov	4(r12),	r10	;
	mov.b	6(r12),	r13	;

	mov	r13,	r11	;
	and.b	#15,	r11	;#0x000f

	mov	6(r12),	r14	;
	rrum	#4,	r14	;
	and	#2047,	r14	;#0x07ff
	mov	r14,	2(r1)	;

	mov.b	7(r12),	r12	;

	rpt #7 { rrux.w	r12		;

	mov	r12,	2(r7)	;

	cmp	#0,	r14	;r3 As==00
	jnz	.L596    	;abs 0x6456

	mov	r8,	r12	;
	bis	r9,	r12	;
	bis	r10,	r12	;
	bis	r11,	r12	;
	cmp	#0,	r12	;r3 As==00
	jnz	.L578     	;abs 0x63ca

	mov	#2,	0(r7)	;r3 As==10

.L575:
	adda	#6,	r1	;

	popm.a	#4,	r10	;20-bit words

	reta			;

.L578:
	mov.b	#8,	r12	;r2 As==11
	calla	#__mspabi_sllll		;0x05db4

	mov	r12,	r10	;

	mov	#3,	0(r7)	;

	mov	#-1023,	4(r1)	;#0xfc01

	mov.b	#1,	r8	;r3 As==01

.L583:
	mov	r10,	r9	;
	add	r10,	r9	;
	mov	r9,	2(r1)	;
	mov	r8,	r11	;
	cmp	r10,	r9	;
	jnc	.L584      	;abs 0x63f0
	clr.b	r11		;

.L584:
	mov	r13,	r10	;

	add	r13,	r10	;
	mov.b	#1,	r12	;r3 As==01
	cmp	r13,	r10	;
	jnc	.L586      	;abs 0x63fc
	clr.b	r12		;

.L586:
	add	r10,	r11	;
	mov	r8,	r13	;
	cmp	r10,	r11	;
	jnc	.L587      	;abs 0x6406
	clr.b	r13		;

.L587:
	bis	r13,	r12	;
	mov	r14,	r13	;
	add	r14,	r13	;
	mov.b	#1,	r9	;r3 As==01
	cmp	r14,	r13	;
	jnc	.L588      	;abs 0x6414
	clr.b	r9		;

.L588:
	add	r13,	r12	;
	mov	r8,	r14	;
	cmp	r13,	r12	;
	jnc	.L589      	;abs 0x641e
	clr.b	r14		;

.L589:
	bis	r14,	r9	;
	rla	r15		;
	mov	2(r1),	r10	;
	mov	r11,	r13	;
	mov	r12,	r14	;
	add	r9,	r15	;

	mov	4(r1),	0(r1)	;

	add	#-1,	4(r1)	;r3 As==11
	mov	#4095,	r9	;#0x0fff
	cmp	r15,	r9	;
	jc	.L583     	;abs 0x63e0

	mov	@r1,	4(r7)	;

	mov	r10,	6(r7)	;
	mov	r11,	8(r7)	;
	mov	r12,	10(r7)	; 0x000a

.L594:
	mov	r15,	12(r7)	; 0x000c

	jmp .L575	;mova	#25538,	r0	;0x063c2

.L596:
	cmp	#2047,	2(r1)	;#0x07ff
	jnz	.L604     	;abs 0x64a4

	mov	r8,	r12	;
	bis	r9,	r12	;
	bis	r10,	r12	;
	bis	r11,	r12	;
	cmp	#0,	r12	;r3 As==00
	jnz	.L599     	;abs 0x6472

	mov	#4,	0(r7)	;r2 As==10
	jmp .L575	;mova	#25538,	r0	;0x063c2

.L599:
	mov	r13,	r12	;
	and.b	#8,	r12	;r2 As==11
	bit	#8,	r13	;r2 As==11
	jz	.L603     	;abs 0x649c

	mov	#1,	0(r7)	;r3 As==01

.L601:
	mov.b	#8,	r12	;r2 As==11
	calla	#__mspabi_sllll		;0x05db4

	and	#-256,	r12	;#0xff00
	mov	r12,	6(r7)	;
	mov	r13,	8(r7)	;
	mov	r14,	10(r7)	; 0x000a
	and	#-2049,	r15	;#0xf7ff
	jmp .L594	;mova	#25678,	r0	;0x0644e

.L603:
	mov	r12,	0(r7)	;
	jmp .L601	;mova	#25726,	r0	;0x0647e

.L604:
	mov	2(r1),	r12	;
	add	#-1023,	r12	;#0xfc01
	mov	r12,	4(r7)	;

	mov	#3,	0(r7)	;

	mov.b	#8,	r12	;r2 As==11
	calla	#__mspabi_sllll		;0x05db4

	mov	r12,	6(r7)	;
	mov	r13,	8(r7)	;
	mov	r14,	10(r7)	; 0x000a
	bis	#4096,	r15	;#0x1000
	jmp .L594	;mova	#25678,	r0	;0x0644e



	.global __fpcmp_parts_d
	.type __fpcmp_parts_d, @function
__fpcmp_parts_d:
	nop
	nop
	pushm.a	#4,	r10	;20-bit words

	mova	r13,	r14	;

	mov	@r12,	r13	;

	mov.b	#1,	r10	;r3 As==01
	cmp	r13,	r10	;
	jc	.L622     	;abs 0x6502

	mov	@r14,	r15	;

	cmp	r15,	r10	;
	jc	.L622     	;abs 0x6502

	cmp	#4,	r13	;r2 As==10
	jnz	.L620     	;abs 0x64f8

	mov	2(r12),	r13	;

	cmp	#4,	r15	;r2 As==10
	jnz	.L628     	;abs 0x651e

	mov	2(r14),	r12	;

	sub	r13,	r12	;

.L618:
	popm.a	#4,	r10	;20-bit words

	reta			;

.L620:
	cmp	#4,	r15	;r2 As==10
	jnz	.L623     	;abs 0x6508

.L621:
	cmp	#0,	2(r14)	;r3 As==00
	jz	.L629     	;abs 0x6522

.L622:
	mov.b	#1,	r12	;r3 As==01
	jmp .L618	;mova	#25844,	r0	;0x064f4

.L623:
	cmp	#2,	r13	;r3 As==10
	jnz	.L626     	;abs 0x6516

	cmp	#2,	r15	;r3 As==10
	jnz	.L621     	;abs 0x64fc

.L625:
	clr.b	r12		;
	jmp .L618	;mova	#25844,	r0	;0x064f4

.L626:
	mov	2(r12),	r13	;

	cmp	#2,	r15	;r3 As==10
	jnz	.L630     	;abs 0x6528

.L628:
	cmp	#0,	r13	;r3 As==00
	jz	.L622     	;abs 0x6502

.L629:
	mov	#-1,	r12	;r3 As==11
	jmp .L618	;mova	#25844,	r0	;0x064f4

.L630:
	cmp	r13,	2(r14)	;
	jnz	.L628     	;abs 0x651e

	mov	4(r12),	r10	;

	mov	4(r14),	r15	;

	cmp	r10,	r15	;
	jl	.L628     	;abs 0x651e

	cmp	r15,	r10	;
	jge	.L636     	;abs 0x6546

.L635:
	cmp	#0,	r13	;r3 As==00
	jz	.L629     	;abs 0x6522
	jmp .L622	;mova	#25858,	r0	;0x06502

.L636:
	mov	6(r12),	r7	;
	mov	8(r12),	r15	;
	mov	10(r12),r11	;0x0000a
	mov	12(r12),r9	;0x0000c

	mov	6(r14),	r8	;
	mov	8(r14),	r12	;

	mov	10(r14),r10	;0x0000a
	mov	12(r14),r14	;0x0000c

	cmp	r9,	r14	;
	jnc	.L628     	;abs 0x651e
	cmp	r14,	r9	;
	jnz	.L640     	;abs 0x6582
	cmp	r11,	r10	;
	jnc	.L628     	;abs 0x651e
	cmp	r10,	r11	;
	jnz	.L640     	;abs 0x6582
	cmp	r15,	r12	;
	jnc	.L628     	;abs 0x651e
	cmp	r12,	r15	;
	jnz	.L640      	;abs 0x6582
	cmp	r7,	r8	;
	jnc	.L628     	;abs 0x651e

.L640:
	cmp	r14,	r9	;
	jnc	.L635     	;abs 0x653e
	cmp	r9,	r14	;
	jnz	.L625    	;abs 0x6510
	cmp	r10,	r11	;
	jnc	.L635     	;abs 0x653e
	cmp	r11,	r10	;
	jnz	.L625    	;abs 0x6510
	cmp	r12,	r15	;
	jnc	.L635     	;abs 0x653e
	cmp	r15,	r12	;
	jnz	.L625    	;abs 0x6510
	cmp	r8,	r7	;
	jc	.L625    	;abs 0x6510
	jmp .L635	;mova	#25918,	r0	;0x0653e



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

.L644:
	cmpa	r12,	r15	;
	jnz	.L649     	;abs 0x65b8

	mova	r8,	r12	;

	popm.a	#1,	r8	;20-bit words

	popm.a	#1,	r10	;20-bit words

	reta			;

.L649:
	mova	r8,	r14	;
	adda	r12,	r14	;

	mova	r13,	r10	;
	adda	r12,	r10	;

	mov.b	@r10,	0(r14)	;
	adda	#1,	r12	;

	jmp .L644	;mova	#26028,	r0	;0x065ac



	.global exp
	.type exp, @function
exp:
	nop
	nop
	pushm.a	#4,	r10	;20-bit words

	suba	#16,	r1	;0x00010

	mov	r12,	r7	;
	mov	r13,	r8	;
	mov	r14,	r9	;
	mov	r15,	14(r1)	; 0x000e

	calla	#__ieee754_exp		;0x0685e

	mov	r12,	r10	;
	mov	r13,	8(r1)	;
	mov	r14,	10(r1)	; 0x000a
	mov	r15,	12(r1)	; 0x000c

	cmpx.w	#-1,	&0x02c00;r3 As==11
	jz	.L668     	;abs 0x664e

	mov	r7,	r12	;
	mov	r8,	r13	;

	mov	r9,	r14	;

	mov	14(r1),	r15	;0x0000e

	calla	#finite		;0x07ba6

	cmp	#0,	r12	;r3 As==00
	jz	.L668     	;abs 0x664e

	mov	#14831,	0(r1)	;#0x39ef
	mov	#-262,	2(r1)	;#0xfefa
	mov	#11842,	4(r1)	;#0x2e42
	mov	#16518,	6(r1)	;#0x4086
	mov	r7,	r12	;
	mov	r8,	r13	;
	mov	r9,	r14	;
	mov	14(r1),	r15	;0x0000e
	calla	#__gtdf2		;0x08894
	clr.b	r13		;
	cmp	r12,	r13	;
	jge	.L671     	;abs 0x6664

	calla	#__errno		;0x08b0e

	mov	#34,	0(r12)	;#0x0022

	clr.b	r10		;

	mov	r10,	8(r1)	;
	mov	r10,	10(r1)	; 0x000a
	mov	#32752,	12(r1)	;#0x7ff0, 0x000c

.L668:
	mov	r10,	r12	;
	mov	8(r1),	r13	;
	mov	10(r1),	r14	;0x0000a
	mov	12(r1),	r15	;0x0000c
	adda	#16,	r1	;0x00010

	popm.a	#4,	r10	;20-bit words

	reta			;

.L671:
	mov	#12369,	0(r1)	;#0x3051
	mov	#-10963,2(r1)	;#0xd52d
	mov	#18704,	4(r1)	;#0x4910
	mov	#-16249,6(r1)	;#0xc087
	mov	r7,	r12	;
	mov	r8,	r13	;
	mov	r9,	r14	;
	mov	14(r1),	r15	;0x0000e
	calla	#__ltdf2		;0x0890a
	cmp	#0,	r12	;r3 As==00
	jge	.L668     	;abs 0x664e

	calla	#__errno		;0x08b0e

	mov	#34,	0(r12)	;#0x0022

	clr.b	r10		;

	mov	r10,	8(r1)	;
	mov	r10,	10(r1)	; 0x000a
	mov	r10,	12(r1)	; 0x000c
	jmp .L668	;mova	#26190,	r0	;0x0664e



	.global log
	.type log, @function
log:
	nop
	nop
	pushm.a	#4,	r10	;20-bit words

	suba	#20,	r1	;0x00014

	mov	r12,	12(r1)	; 0x000c
	mov	r13,	r7	;
	mov	r14,	r8	;
	mov	r15,	r9	;

	calla	#__ieee754_log		;0x06ebc

	mov	r12,	r11	;
	mov	r13,	14(r1)	; 0x000e
	mov	r14,	16(r1)	; 0x0010
	mov	r15,	18(r1)	; 0x0012

	cmpx.w	#-1,	&0x02c00;r3 As==11
	jz	.L691    	;abs 0x676a

	mov	12(r1),	0(r1)	;0x0000c
	mov	r7,	2(r1)	;
	mov	r8,	4(r1)	;
	mov	r9,	6(r1)	;
	mov	12(r1),	r12	;0x0000c
	mov	r7,	r13	;

	mov	r8,	r14	;

	mov	r9,	r15	;

	mova	r11,	8(r1)	;
	calla	#__unorddf2		;0x05ca4

	mov	r12,	r10	;
	mova	8(r1),	r11	;
	cmp	#0,	r12	;r3 As==00
	jnz	.L691    	;abs 0x676a

	mov	r12,	0(r1)	;
	mov	r12,	2(r1)	;
	mov	r12,	4(r1)	;
	mov	r12,	6(r1)	;
	mov	12(r1),	r12	;0x0000c
	mov	r7,	r13	;
	mov	r8,	r14	;
	mov	r9,	r15	;
	calla	#__gtdf2		;0x08894
	mova	8(r1),	r11	;
	clr.b	r13		;
	cmp	r12,	r13	;
	jl	.L691     	;abs 0x676a

	mov	r10,	0(r1)	;
	mov	r10,	2(r1)	;
	mov	r10,	4(r1)	;
	mov	r10,	6(r1)	;
	mov	12(r1),	r12	;0x0000c
	mov	r7,	r13	;
	mov	r8,	r14	;
	mov	r9,	r15	;
	calla	#__eqdf2		;0x0881e
	mov	r12,	r10	;
	cmp	#0,	r10	;r3 As==00
	jnz	.L694     	;abs 0x6780

	calla	#__errno		;

	mov	#34,	0(r12)	;#0x0022

	mov	r10,	r11	;
	mov	r10,	14(r1)	; 0x000e
	mov	r10,	16(r1)	; 0x0010
	mov	#-16,	18(r1)	;#0xfff0, 0x0012

.L691:
	mov	r11,	r12	;
	mov	14(r1),	r13	;0x0000e
	mov	16(r1),	r14	;0x00010
	mov	18(r1),	r15	;0x00012
	adda	#20,	r1	;0x00014

	popm.a	#4,	r10	;20-bit words

	reta			;

.L694:
	calla	#__errno		;

	mov	#33,	0(r12)	;#0x0021

	mova	#83273,	r12	;0x14549
	calla	#nan		;0x07bbe

	mov	r12,	r11	;
	mov	r13,	14(r1)	; 0x000e
	mov	r14,	16(r1)	; 0x0010
	mov	r15,	18(r1)	; 0x0012
	jmp .L691	;mova	#26474,	r0	;0x0676a



	.global sqrt
	.type sqrt, @function
sqrt:
	nop
	nop
	pushm.a	#4,	r10	;20-bit words

	suba	#20,	r1	;0x00014

	mov	r12,	r11	;
	mov	r13,	r7	;
	mov	r14,	r8	;
	mov	r15,	r9	;

	mova	r11,	8(r1)	;
	calla	#__ieee754_sqrt		;0x076c4

	mov	r12,	12(r1)	; 0x000c
	mov	r13,	14(r1)	; 0x000e
	mov	r14,	16(r1)	; 0x0010
	mov	r15,	18(r1)	; 0x0012

	mova	8(r1),	r11	;
	cmpx.w	#-1,	&0x02c00;r3 As==11
	jz	.L713    	;abs 0x6846

	mov	r11,	0(r1)	;
	mov	r7,	2(r1)	;
	mov	r8,	4(r1)	;
	mov	r9,	6(r1)	;
	mov	r11,	r12	;

	mov	r7,	r13	;

	mov	r8,	r14	;

	mov	r9,	r15	;

	calla	#__unorddf2		;0x05ca4
	mov	r12,	r10	;
	mova	8(r1),	r11	;
	cmp	#0,	r12	;r3 As==00
	jnz	.L713     	;abs 0x6846

	mov	r12,	0(r1)	;
	mov	r12,	2(r1)	;
	mov	r12,	4(r1)	;
	mov	r12,	6(r1)	;
	mov	r11,	r12	;
	mov	r7,	r13	;
	mov	r8,	r14	;
	mov	r9,	r15	;
	calla	#__ltdf2		;0x0890a
	cmp	#0,	r12	;r3 As==00
	jge	.L713     	;abs 0x6846

	calla	#__errno		;0x08b0e

	mov	#33,	0(r12)	;#0x0021

	mov	r10,	r12	;
	mov	r10,	r13	;
	mov	r10,	r14	;
	mov	r10,	r15	;
	mov	r10,	r8	;
	mov	r10,	r9	;
	mov	r10,	r11	;
	calla	#__mspabi_divd		;0x058da
	mov	r12,	12(r1)	; 0x000c

	mov	r13,	14(r1)	; 0x000e
	mov	r14,	16(r1)	; 0x0010
	mov	r15,	18(r1)	; 0x0012

.L713:
	mov	12(r1),	r12	;0x0000c
	mov	14(r1),	r13	;0x0000e
	mov	16(r1),	r14	;0x00010
	mov	18(r1),	r15	;0x00012
	adda	#20,	r1	;0x00014

	popm.a	#4,	r10	;20-bit words

	reta			;



	.global __ieee754_exp
	.type __ieee754_exp, @function
__ieee754_exp:
	nop
	nop
	pushm.a	#4,	r10	;20-bit words

	suba	#58,	r1	;0x0003a

	mov	r12,	12(r1)	; 0x000c
	mov	r13,	16(r1)	; 0x0010
	mov	r14,	18(r1)	; 0x0012
	mov	r15,	14(r1)	; 0x000e

	mov	r14,	r12	;

	mov	r14,	r10	;

	mov	r15,	r13	;
	mov.b	#31,	r14	;#0x001f
	calla	#__mspabi_srll		;0x05dda

	mov	r12,	20(r1)	; 0x0014
	mov	r13,	22(r1)	; 0x0016

	mov	14(r1),	r14	;0x0000e
	and	#32767,	r14	;#0x7fff

	mov	#16518,	r15	;#0x4086
	cmp	r14,	r15	;
	jnc	.L741    	;abs 0x6992
	cmp	r15,	r14	;
	jnz	.L759    	;abs 0x6a9a
	mov	#11841,	r12	;#0x2e41
	cmp	r10,	r12	;
	jnc	.L742    	;abs 0x699a

.L724:
	mov	#-32002,r12	;#0x82fe
	mov	#25899,	r13	;#0x652b
	mov	#5447,	r14	;#0x1547
	mov	#16375,	r15	;#0x3ff7
	mov	12(r1),	r8	;0x0000c
	mov	16(r1),	r9	;0x00010
	mov	18(r1),	r10	;0x00012
	mov	14(r1),	r11	;0x0000e
	calla	#__mspabi_mpyd		;0x082a8
	mov	r12,	r8	;
	mov	r13,	r9	;
	mov	r14,	r7	;
	mov	r15,	r11	;

	mov	20(r1),	r12	;0x00014
	mov	22(r1),	r13	;0x00016
	push	r13		;
	push	r12		;
	popm.a	#1,	r10	;20-bit words
	rlam.a	#3,	r10	;
	adda	#83000,	r10	;0x14438

	mov	@r10,	r12	;
	mov	2(r10),	r13	;
	mov	4(r10),	r14	;
	mov	6(r10),	r15	;
	mov	r7,	r10	;
	calla	#__mspabi_addd		;0x081dc

	calla	#__mspabi_fixdli		;0x08a14
	mov	r12,	24(r1)	; 0x0018
	mov	r13,	26(r1)	; 0x001a

	calla	#__mspabi_fltlid		;0x08980
	mov	r12,	20(r1)	; 0x0014

	mov	r13,	28(r1)	; 0x001c
	mov	r14,	30(r1)	; 0x001e
	mov	r15,	r7	;

	clr.b	r12		;

	mov	#-288,	r13	;#0xfee0

	mov	#11842,	r14	;#0x2e42

	mov	#16358,	r15	;#0x3fe6
	mov	20(r1),	r8	;0x00014
	mov	28(r1),	r9	;0x0001c
	mov	30(r1),	r10	;0x0001e
	mov	r7,	r11	;
	calla	#__mspabi_mpyd		;0x082a8

	mov	12(r1),	r8	;0x0000c
	mov	16(r1),	r9	;0x00010
	mov	18(r1),	r10	;0x00012
	mov	14(r1),	r11	;0x0000e
	calla	#__mspabi_subd		;0x08240
	mov	r12,	32(r1)	; 0x0020
	mov	r13,	34(r1)	; 0x0022
	mov	r14,	36(r1)	; 0x0024
	mov	r15,	38(r1)	; 0x0026

	mov	#15478,	r12	;#0x3c76

	mov	#13689,	r13	;#0x3579

	mov	#14831,	r14	;#0x39ef

	mov	#15850,	r15	;#0x3dea

	mov	20(r1),	r8	;0x00014
	mov	28(r1),	r9	;0x0001c
	mov	30(r1),	r10	;0x0001e
	mov	r7,	r11	;
	calla	#__mspabi_mpyd		;0x082a8
	mov	r12,	40(r1)	; 0x0028
	mov	r13,	42(r1)	; 0x002a
	mov	r14,	44(r1)	; 0x002c
	mov	r15,	46(r1)	; 0x002e

	jmp .L769	;mova	#27452,	r0	;0x06b3c

.L741:
	mov	#32751,	r15	;#0x7fef
	cmp	r14,	r15	;
	jnc	.L746     	;abs 0x69ec

.L742:
	mov	#14831,	0(r1)	;#0x39ef
	mov	#-262,	2(r1)	;#0xfefa
	mov	#11842,	4(r1)	;#0x2e42
	mov	#16518,	6(r1)	;#0x4086
	mov	12(r1),	r12	;0x0000c
	mov	16(r1),	r13	;0x00010
	mov	18(r1),	r14	;0x00012

	mov	14(r1),	r15	;0x0000e
	calla	#__gtdf2		;0x08894
	clr.b	r13		;
	cmp	r12,	r13	;
	jge	.L757    	;abs 0x6a50

	mov	#30108,	r12	;#0x759c
	mov	#-30720,r13	;#0x8800
	mov	#-7108,	r14	;#0xe43c
	mov	#32311,	r15	;#0x7e37
	mov	r12,	r8	;
	mov	r13,	r9	;
	mov	r14,	r10	;
	mov	r15,	r11	;

.L745:
	calla	#__mspabi_mpyd		;0x082a8
	jmp .L752	;mova	#27166,	r0	;0x06a1e

.L746:
	bis	12(r1),	r10	;0x0000c

	mov	14(r1),	r14	;0x0000e

	and.b	#15,	r14	;#0x000f
	bis	16(r1),	r14	;0x00010

	bis	r10,	r14	;
	cmp	#0,	r14	;r3 As==00
	jz	.L753     	;abs 0x6a2e

	mov	12(r1),	r12	;0x0000c
	mov	16(r1),	r13	;0x00010
	mov	18(r1),	r14	;0x00012
	mov	14(r1),	r15	;0x0000e
	mov	r12,	r8	;
	mov	r13,	r9	;
	mov	r14,	r10	;
	mov	r15,	r11	;

.L751:
	calla	#__mspabi_addd		;0x081dc

.L752:
	mov	r12,	12(r1)	; 0x000c
	mov	r13,	16(r1)	; 0x0010
	mov	r14,	18(r1)	; 0x0012
	jmp .L817	;mova	#28278,	r0	;0x06e76

.L753:
	bis	r13,	r12	;
	cmp	#0,	r12	;r3 As==00
	jz	.L754      	;abs 0x6a38
	jmp .L821	;mova	#28328,	r0	;0x06ea8

.L754:
	mov	12(r1),	r12	;0x0000c
	mov	16(r1),	r13	;0x00010
	mov	18(r1),	r14	;0x00012
	mov	14(r1),	r15	;0x0000e
	adda	#58,	r1	;0x0003a

	popm.a	#4,	r10	;20-bit words

	reta			;

.L757:
	mov	#12369,	0(r1)	;#0x3051
	mov	#-10963,2(r1)	;#0xd52d
	mov	#18704,	4(r1)	;#0x4910
	mov	#-16249,6(r1)	;#0xc087
	mov	12(r1),	r12	;0x0000c
	mov	16(r1),	r13	;0x00010
	mov	18(r1),	r14	;0x00012
	mov	14(r1),	r15	;0x0000e
	calla	#__ltdf2		;0x0890a
	cmp	#0,	r12	;r3 As==00
	jge	.L724    	;abs 0x68a6

	mov	#0,	12(r1)	;r3 As==00, 0x000c
	mov	12(r1),	16(r1)	;0x0000c, 0x0010
	mov	12(r1),	18(r1)	;0x0000c, 0x0012
	mov	12(r1),	14(r1)	;0x0000c, 0x000e
	jmp .L754	;mova	#27192,	r0	;0x06a38

.L759:
	mov	#16342,	r15	;#0x3fd6
	cmp	r14,	r15	;
	jnc	.L792    	;abs 0x6d3a
	cmp	r15,	r14	;
	jnz	.L795    	;abs 0x6d56
	mov	#11842,	r12	;#0x2e42
	cmp	r10,	r12	;
	jc	.L800    	;abs 0x6dba

.L760:
	mov	20(r1),	r13	;0x00014
	mov	22(r1),	r14	;0x00016
	push	r14		;
	push	r13		;
	popm.a	#1,	r12	;20-bit words
	mova	r12,	r7	;
	rlam.a	#3,	r7	;
	mova	r7,	r10	;
	adda	#82984,	r10	;0x14428

	mov	@r10,	r12	;
	mov	2(r10),	r13	;
	mov	4(r10),	r14	;
	mov	6(r10),	r15	;
	mov	12(r1),	r8	;0x0000c
	mov	16(r1),	r9	;0x00010
	mov	18(r1),	r10	;0x00012
	mov	14(r1),	r11	;0x0000e
	calla	#__mspabi_subd		;0x08240
	mov	r12,	32(r1)	; 0x0020
	mov	r13,	34(r1)	; 0x0022
	mov	r14,	36(r1)	; 0x0024
	mov	r15,	38(r1)	; 0x0026

	mova	r7,	r12	;

	adda	#82968,	r12	;0x14418
	mov	@r12,	40(r1)	; 0x0028
	mov	2(r12),	42(r1)	; 0x002a
	mov	4(r12),	44(r1)	; 0x002c
	mov	6(r12),	46(r1)	; 0x002e

	mov.b	#1,	r12	;r3 As==01
	clr.b	r13		;

	subx.w	20(r1),	r12	;0x00014
	subcx.w	22(r1),	r13	;0x00016

	mov	r12,	r14	;

	mov	r13,	r15	;

	subx.w	20(r1),	r14	;0x00014
	subcx.w	22(r1),	r15	;0x00016
	mov	r14,	24(r1)	; 0x0018
	mov	r15,	26(r1)	; 0x001a

.L769:
	mov	40(r1),	r12	;0x00028
	mov	42(r1),	r13	;0x0002a
	mov	44(r1),	r14	;0x0002c
	mov	46(r1),	r15	;0x0002e
	mov	32(r1),	r8	;0x00020
	mov	34(r1),	r9	;0x00022
	mov	36(r1),	r10	;0x00024
	mov	38(r1),	r11	;0x00026
	calla	#__mspabi_subd		;0x08240
	mov	r12,	12(r1)	; 0x000c
	mov	r13,	16(r1)	; 0x0010
	mov	r14,	18(r1)	; 0x0012
	mov	r15,	14(r1)	; 0x000e

.L770:
	mov	12(r1),	r12	;0x0000c
	mov	16(r1),	r13	;0x00010
	mov	18(r1),	r14	;0x00012
	mov	14(r1),	r15	;0x0000e
	mov	r12,	r8	;
	mov	r13,	r9	;
	mov	r14,	r10	;
	mov	r15,	r11	;
	calla	#__mspabi_mpyd		;0x082a8
	mov	r12,	20(r1)	; 0x0014
	mov	r13,	r7	;
	mov	r14,	28(r1)	; 0x001c
	mov	r15,	30(r1)	; 0x001e

	mov	#-23344,r12	;#0xa4d0

	mov	#29374,	r13	;#0x72be
	mov	#14185,	r14	;#0x3769

	mov	#15974,	r15	;#0x3e66

	mov	20(r1),	r8	;0x00014
	mov	r7,	r9	;
	mov	28(r1),	r10	;0x0001c
	mov	30(r1),	r11	;0x0001e
	calla	#__mspabi_mpyd		;0x082a8
	mov	r12,	r8	;
	mov	r13,	r9	;
	mov	r14,	r10	;
	mov	r15,	r11	;

	mov	#27633,	r12	;#0x6bf1
	mov	#-14894,r13	;#0xc5d2
	mov	#-17087,r14	;#0xbd41
	mov	#16059,	r15	;#0x3ebb
	calla	#__mspabi_subd		;0x08240
	mov	r12,	r8	;
	mov	r13,	r9	;
	mov	r14,	r10	;
	mov	r15,	r11	;

	mov	20(r1),	r12	;0x00014
	mov	r7,	r13	;
	mov	28(r1),	r14	;0x0001c
	mov	30(r1),	r15	;0x0001e
	calla	#__mspabi_mpyd		;0x082a8
	mov	r12,	r8	;
	mov	r13,	r9	;
	mov	r14,	r10	;
	mov	r15,	r11	;

	mov	#-8660,	r12	;#0xde2c
	mov	#-20699,r13	;#0xaf25
	mov	#22122,	r14	;#0x566a
	mov	#16145,	r15	;#0x3f11
	calla	#__mspabi_addd		;0x081dc
	mov	r12,	r8	;
	mov	r13,	r9	;
	mov	r14,	r10	;
	mov	r15,	r11	;

	mov	20(r1),	r12	;0x00014
	mov	r7,	r13	;
	mov	28(r1),	r14	;0x0001c
	mov	30(r1),	r15	;0x0001e
	calla	#__mspabi_mpyd		;0x082a8
	mov	r12,	r8	;
	mov	r13,	r9	;
	mov	r14,	r10	;
	mov	r15,	r11	;

	mov	#-17005,r12	;#0xbd93
	mov	#5822,	r13	;#0x16be
	mov	#-16020,r14	;#0xc16c
	mov	#16230,	r15	;#0x3f66
	calla	#__mspabi_subd		;0x08240
	mov	r12,	r8	;
	mov	r13,	r9	;
	mov	r14,	r10	;
	mov	r15,	r11	;

	mov	20(r1),	r12	;0x00014
	mov	r7,	r13	;
	mov	28(r1),	r14	;0x0001c
	mov	30(r1),	r15	;0x0001e
	calla	#__mspabi_mpyd		;0x082a8
	mov	r12,	r8	;
	mov	r13,	r9	;
	mov	r14,	r10	;
	mov	r15,	r11	;

	mov	#21822,	r12	;#0x553e
	mov	#21845,	r13	;#0x5555
	mov	r13,	r14	;
	mov	#16325,	r15	;#0x3fc5
	calla	#__mspabi_addd		;0x081dc
	mov	r12,	r8	;
	mov	r13,	r9	;
	mov	r14,	r10	;
	mov	r15,	r11	;

	mov	20(r1),	r12	;0x00014
	mov	r7,	r13	;
	mov	28(r1),	r14	;0x0001c
	mov	30(r1),	r15	;0x0001e
	calla	#__mspabi_mpyd		;0x082a8

	mov	12(r1),	r8	;0x0000c
	mov	16(r1),	r9	;0x00010
	mov	18(r1),	r10	;0x00012
	mov	14(r1),	r11	;0x0000e
	calla	#__mspabi_subd		;0x08240
	mov	r12,	20(r1)	; 0x0014

	mov	r13,	28(r1)	; 0x001c
	mov	r14,	30(r1)	; 0x001e
	mov	r15,	48(r1)	; 0x0030

	mov	14(r1),	r11	;0x0000e
	calla	#__mspabi_mpyd		;0x082a8

	mov	r12,	50(r1)	; 0x0032
	mov	r13,	52(r1)	; 0x0034
	mov	r14,	54(r1)	; 0x0036
	mov	r15,	56(r1)	; 0x0038

	mov	24(r1),	r7	;0x00018
	bis	26(r1),	r7	;0x0001a
	cmp	#0,	r7	;r3 As==00
	jnz	.L801    	;abs 0x6dc6

	mov	r7,	r12	;
	mov	r7,	r13	;
	mov	r7,	r14	;
	mov	#16384,	r15	;#0x4000
	mov	20(r1),	r8	;0x00014
	mov	28(r1),	r9	;0x0001c
	mov	30(r1),	r10	;0x0001e
	mov	48(r1),	r11	;0x00030
	calla	#__mspabi_subd		;0x08240

	mov	50(r1),	r8	;0x00032
	mov	52(r1),	r9	;0x00034
	mov	54(r1),	r10	;0x00036
	mov	56(r1),	r11	;0x00038
	calla	#__mspabi_divd		;0x058da
	mov	r12,	r8	;
	mov	r13,	r9	;
	mov	r14,	r10	;
	mov	r15,	r11	;

	mov	12(r1),	r12	;0x0000c
	mov	16(r1),	r13	;0x00010
	mov	18(r1),	r14	;0x00012
	mov	14(r1),	r15	;0x0000e
	calla	#__mspabi_subd		;0x08240

	mov	r7,	r8	;
	mov	r7,	r9	;
	mov	r7,	r10	;
	mov	#16368,	r11	;#0x3ff0
	calla	#__mspabi_subd		;0x08240
	jmp .L752	;mova	#27166,	r0	;0x06a1e

.L792:
	mov	#16368,	r13	;#0x3ff0
	cmp	r14,	r13	;
	jc	.L793      	;abs 0x6d46
	jmp .L724	;mova	#26790,	r0	;0x068a6

.L793:
	cmp	r13,	r14	;
	jnz	.L760    	;abs 0x6aae
	mov	#-23887,r14	;#0xa2b1

	cmp	r10,	r14	;
	jc	.L760    	;abs 0x6aae
	jmp .L724	;mova	#26790,	r0	;0x068a6

.L795:
	mov	#15919,	r13	;#0x3e2f
	cmp	r14,	r13	;
	jnc	.L800     	;abs 0x6dba

	mov	#30108,	r12	;#0x759c
	mov	#-30720,r13	;#0x8800
	mov	#-7108,	r14	;#0xe43c

	mov	#32311,	r15	;#0x7e37
	mov	12(r1),	r8	;0x0000c
	mov	16(r1),	r9	;0x00010
	mov	18(r1),	r10	;0x00012
	mov	14(r1),	r11	;0x0000e
	calla	#__mspabi_addd		;0x081dc

	clr.b	r11		;
	mov	#16368,	r7	;#0x3ff0
	mov	r11,	0(r1)	;
	mov	r11,	2(r1)	;
	mov	r11,	4(r1)	;
	mov	r7,	6(r1)	;
	mova	r11,	8(r1)	;
	calla	#__gtdf2		;0x08894
	mova	8(r1),	r11	;
	clr.b	r14		;
	cmp	r12,	r14	;
	jge	.L800     	;abs 0x6dba

	mov	r11,	r12	;
	mov	r11,	r13	;
	mov	r11,	r14	;
	mov	r7,	r15	;
	mov	14(r1),	r11	;0x0000e
	jmp .L751	;mova	#27162,	r0	;0x06a1a

.L800:
	mov	#0,	24(r1)	;r3 As==00, 0x0018
	mov	#0,	26(r1)	;r3 As==00, 0x001a
	jmp .L770	;mova	#27504,	r0	;0x06b70

.L801:
	mov	20(r1),	r12	;0x00014
	mov	28(r1),	r13	;0x0001c
	mov	30(r1),	r14	;0x0001e
	mov	48(r1),	r15	;0x00030
	clr.b	r8		;

	mov	r8,	r9	;

	mov	r8,	r10	;

	mov	#16384,	r11	;#0x4000
	calla	#__mspabi_subd		;0x08240

	mov	50(r1),	r8	;0x00032
	mov	52(r1),	r9	;0x00034
	mov	54(r1),	r10	;0x00036
	mov	56(r1),	r11	;0x00038
	calla	#__mspabi_divd		;0x058da

	mov	40(r1),	r8	;0x00028
	mov	42(r1),	r9	;0x0002a
	mov	44(r1),	r10	;0x0002c
	mov	46(r1),	r11	;0x0002e
	calla	#__mspabi_subd		;0x08240
	mov	r12,	r8	;
	mov	r13,	r9	;
	mov	r14,	r10	;
	mov	r15,	r11	;

	mov	32(r1),	r12	;0x00020
	mov	34(r1),	r13	;0x00022
	mov	36(r1),	r14	;0x00024
	mov	38(r1),	r15	;0x00026
	calla	#__mspabi_subd		;0x08240

	clr.b	r8		;
	mov	r8,	r9	;
	mov	r8,	r10	;
	mov	#16368,	r11	;#0x3ff0
	calla	#__mspabi_subd		;0x08240
	mov	r12,	r8	;
	mov	r13,	r9	;

	mov	r14,	r10	;
	mov	r15,	r7	;

	mov	26(r1),	r12	;0x0001a
	cmp	#-1,	r12	;r3 As==11
	jl	.L818     	;abs 0x6e7e
	cmp	#-1,	r12	;r3 As==11
	jnz	.L811     	;abs 0x6e54
	mov	24(r1),	r12	;0x00018
	cmp	#-1021,	r12	;#0xfc03
	jnc	.L818     	;abs 0x6e7e

.L811:
	mov	24(r1),	r12	;0x00018
	mov	26(r1),	r13	;0x0001a
	mov.b	#20,	r14	;#0x0014

	calla	#__mspabi_slll		;0x05dae

	add	r12,	r10	;

	addc	r7,	r13	;
	mov	r13,	r15	;

	mov	r8,	12(r1)	; 0x000c

	mov	r9,	16(r1)	; 0x0010
	mov	r10,	18(r1)	; 0x0012

.L817:
	mov	r15,	14(r1)	; 0x000e
	jmp .L754	;mova	#27192,	r0	;0x06a38

.L818:
	mov	24(r1),	r12	;0x00018
	add	#1000,	r12	;#0x03e8
	mov	26(r1),	r13	;0x0001a
	adc	r13		;
	mov.b	#20,	r14	;#0x0014
	calla	#__mspabi_slll		;0x05dae
	add	r12,	r10	;

	mov	r13,	r11	;
	addc	r7,	r11	;

	clr.b	r12		;
	mov	r12,	r13	;
	mov	r12,	r14	;
	mov	#368,	r15	;#0x0170
	jmp .L745	;mova	#27108,	r0	;0x069e4

.L821:
	mov	r14,	12(r1)	; 0x000c
	mov	r14,	16(r1)	; 0x0010
	mov	r14,	18(r1)	; 0x0012
	mov	r14,	14(r1)	; 0x000e

	jmp .L754	;mova	#27192,	r0	;0x06a38



	.global __ieee754_log
	.type __ieee754_log, @function
__ieee754_log:
	nop
	nop
	pushm.a	#4,	r10	;20-bit words

	suba	#62,	r1	;0x0003e

	mov	r12,	r8	;
	mov	r13,	16(r1)	; 0x0010
	mov	r14,	r10	;
	mov	r15,	r11	;

	mov	r14,	12(r1)	; 0x000c
	mov	r14,	18(r1)	; 0x0012
	mov	r15,	r7	;

	mov.b	#15,	r9	;#0x000f
	cmp	r15,	r9	;
	jl	.L880    	;abs 0x70b0

	mov	r14,	r7	;

	bis	r12,	r7	;
	mov	r15,	r9	;
	and	#32767,	r9	;#0x7fff
	bis	r13,	r9	;

	bis	r7,	r9	;
	cmp	#0,	r9	;r3 As==00
	jnz	.L837     	;abs 0x6f0c

	mov	r9,	r12	;

	mov	r9,	r13	;
	mov	r9,	r14	;
	mov	r9,	r15	;
	mov	r9,	r8	;
	mov	r9,	r10	;

	mov	#-15536,r11	;#0xc350

.L833:
	calla	#__mspabi_divd		;0x058da

.L834:
	adda	#62,	r1	;0x0003e

	popm.a	#4,	r10	;20-bit words

	reta			;

.L837:
	cmp	#0,	r15	;r3 As==00
	jge	.L841     	;abs 0x6f2c

	mov	16(r1),	r9	;0x00010
	calla	#__mspabi_subd		;0x08240

	mov	r12,	r8	;
	mov	r13,	r9	;
	mov	r14,	r10	;
	mov	r15,	r11	;

	clr.b	r12		;
	mov	r12,	r13	;
	mov	r12,	r14	;
	mov	r12,	r15	;
	jmp .L833	;mova	#28416,	r0	;0x06f00

.L841:
	clr.b	r12		;

	mov	r12,	r13	;
	mov	r12,	r14	;
	mov	#17232,	r15	;#0x4350
	mov	16(r1),	r9	;0x00010
	calla	#__mspabi_mpyd		;0x082a8

	mov	r12,	r8	;
	mov	r13,	16(r1)	; 0x0010
	mov	r14,	r10	;
	mov	r15,	r11	;

	mov	r14,	18(r1)	; 0x0012
	mov	r15,	r7	;

	mov	#-54,	r9	;#0xffca
	mov	#-1,	20(r1)	;r3 As==11, 0x0014

.L846:
	mov	#32751,	r12	;#0x7fef
	cmp	r7,	r12	;
	jl	.L881    	;abs 0x70ba

	mov	18(r1),	r12	;0x00012
	mov	r7,	r13	;
	mov.b	#20,	r14	;#0x0014
	calla	#__mspabi_sral		;0x08ab8

	add	#-1023,	r12	;#0xfc01
	addc	#-1,	r13	;r3 As==11

	add	r12,	r9	;

	addcx.w	20(r1),	r13	;0x00014
	mov	r13,	20(r1)	; 0x0014

	mov	18(r1),	12(r1)	;0x00012, 0x000c
	and.b	#15,	r7	;#0x000f

	mov	r7,	14(r1)	; 0x000e

	mov	12(r1),	r12	;0x0000c
	add	#24420,	r12	;#0x5f64
	mov	r7,	r13	;

	addc	#9,	r13	;

	and.b	#16,	r13	;#0x0010

	mov	r13,	r7	;
	xor	#16368,	r7	;#0x3ff0
	bis	14(r1),	r7	;0x0000e
	mov	12(r1),	r10	;0x0000c

	clr.b	r12		;
	mov.b	#20,	r14	;#0x0014
	calla	#__mspabi_sral		;0x08ab8

	add	r9,	r12	;
	mov	r12,	32(r1)	; 0x0020
	addcx.w	20(r1),	r13	;0x00014
	mov	r13,	20(r1)	; 0x0014

	clr.b	r12		;

	mov	r12,	r13	;

	mov	r12,	r14	;
	mov	#16368,	r15	;#0x3ff0
	mov	16(r1),	r9	;0x00010
	mov	r7,	r11	;
	calla	#__mspabi_subd		;0x08240
	mov	r12,	18(r1)	; 0x0012

	mov	r13,	28(r1)	; 0x001c
	mov	r14,	30(r1)	; 0x001e
	mov	r15,	16(r1)	; 0x0010

	mov	r10,	r12	;

	incd	r12		;
	mov	14(r1),	r13	;0x0000e

	adc	r13		;

	mov	r13,	r14	;

	and.b	#15,	r14	;#0x000f

	bit	#15,	r13	;#0x000f
	jnz	.L903    	;abs 0x7208
	cmp	#0,	r14	;r3 As==00
	jnz	.L869      	;abs 0x700a
	mov.b	#2,	r13	;r3 As==10
	cmp	r12,	r13	;
	jnc	.L903    	;abs 0x7208

.L869:
	clr.b	r7		;

	mov	r7,	0(r1)	;
	mov	r7,	2(r1)	;
	mov	r7,	4(r1)	;
	mov	r7,	6(r1)	;
	mov	18(r1),	r12	;0x00012
	mov	28(r1),	r13	;0x0001c
	mov	30(r1),	r14	;0x0001e
	mov	16(r1),	r15	;0x00010

	calla	#__eqdf2		;0x0881e
	mov	r12,	r11	;
	cmp	r7,	r12	;
	jnz	.L883    	;abs 0x70ce

	mov	32(r1),	r12	;0x00020
	bis	20(r1),	r12	;0x00014
	cmp	r7,	r12	;
	jnz	.L873      	;abs 0x7046
	jmp .L980	;mova	#30394,	r0	;0x076ba

.L873:
	mov	32(r1),	r12	;0x00020
	mov	20(r1),	r13	;0x00014
	mova	r11,	8(r1)	;
	calla	#__mspabi_fltlid		;0x08980
	mov	r12,	r8	;
	mov	r13,	r9	;
	mov	r14,	r10	;
	mov	r15,	r7	;

	mova	8(r1),	r11	;
	mov	r11,	r12	;
	mov	#-288,	r13	;#0xfee0
	mov	#11842,	r14	;#0x2e42
	mov	#16358,	r15	;#0x3fe6
	mov	r7,	r11	;
	calla	#__mspabi_mpyd		;0x082a8
	mov	r12,	16(r1)	; 0x0010

	mov	r13,	12(r1)	; 0x000c

	mov	r14,	18(r1)	; 0x0012
	mov	r15,	28(r1)	; 0x001c

	mov	#15478,	r12	;#0x3c76
	mov	#13689,	r13	;#0x3579
	mov	#14831,	r14	;#0x39ef
	mov	#15850,	r15	;#0x3dea
	mov	r7,	r11	;
	calla	#__mspabi_mpyd		;0x082a8

	mov	16(r1),	r8	;0x00010

	mov	12(r1),	r9	;0x0000c
	mov	18(r1),	r10	;0x00012
	mov	28(r1),	r11	;0x0001c
	jmp .L882	;mova	#28870,	r0	;0x070c6

.L880:
	clr.b	r9		;
	mov	r9,	20(r1)	; 0x0014
	jmp .L846	;mova	#28502,	r0	;0x06f56

.L881:
	mov	r8,	r12	;
	mov	16(r1),	r13	;0x00010
	mov	r10,	r14	;
	mov	r11,	r15	;
	mov	r13,	r9	;

.L882:
	calla	#__mspabi_addd		;0x081dc
	jmp .L834	;mova	#28420,	r0	;0x06f04

.L883:
	mov	#21845,	r12	;#0x5555
	mov	r12,	r13	;
	mov	r12,	r14	;
	mov	#16341,	r15	;#0x3fd5
	mov	18(r1),	r8	;0x00012
	mov	28(r1),	r9	;0x0001c
	mov	30(r1),	r10	;0x0001e
	mov	16(r1),	r11	;0x00010
	calla	#__mspabi_mpyd		;0x082a8

	mov	r7,	r8	;
	mov	r7,	r9	;
	mov	r7,	r10	;
	mov	#16352,	r11	;#0x3fe0
	calla	#__mspabi_subd		;0x08240
	mov	r12,	12(r1)	; 0x000c

	mov	r13,	22(r1)	; 0x0016
	mov	r14,	24(r1)	; 0x0018
	mov	r15,	26(r1)	; 0x001a

	mov	18(r1),	r12	;0x00012
	mov	28(r1),	r13	;0x0001c
	mov	30(r1),	r14	;0x0001e
	mov	16(r1),	r15	;0x00010
	mov	r12,	r8	;
	mov	r13,	r9	;
	mov	r14,	r10	;
	mov	r15,	r11	;
	calla	#__mspabi_mpyd		;0x082a8

	mov	12(r1),	r8	;0x0000c
	mov	22(r1),	r9	;0x00016
	mov	24(r1),	r10	;0x00018
	mov	26(r1),	r11	;0x0001a
	calla	#__mspabi_mpyd		;0x082a8
	mov	r12,	22(r1)	; 0x0016
	mov	r13,	24(r1)	; 0x0018
	mov	r14,	26(r1)	; 0x001a
	mov	r15,	34(r1)	; 0x0022

	mov	32(r1),	r10	;0x00020
	bis	20(r1),	r10	;0x00014
	cmp	#0,	r10	;r3 As==00
	jnz	.L890     	;abs 0x716c

.L889:
	mov	18(r1),	r8	;0x00012
	mov	28(r1),	r9	;0x0001c
	mov	30(r1),	r10	;0x0001e
	mov	16(r1),	r11	;0x00010
	jmp .L902	;mova	#29184,	r0	;0x07200

.L890:
	mov	32(r1),	r12	;0x00020

	mov	20(r1),	r13	;0x00014

	calla	#__mspabi_fltlid		;0x08980

	mov	r12,	r8	;
	mov	r13,	r9	;
	mov	r14,	r10	;
	mov	r15,	12(r1)	; 0x000c

	mov	r7,	r12	;
	mov	#-288,	r13	;#0xfee0
	mov	#11842,	r14	;#0x2e42
	mov	#16358,	r15	;#0x3fe6

	mov	12(r1),	r11	;0x0000c
	calla	#__mspabi_mpyd		;0x082a8
	mov	r12,	20(r1)	; 0x0014

	mov	r13,	32(r1)	; 0x0020
	mov	r14,	36(r1)	; 0x0024
	mov	r15,	44(r1)	; 0x002c

	mov	#15478,	r12	;#0x3c76
	mov	#13689,	r13	;#0x3579
	mov	#14831,	r14	;#0x39ef
	mov	#15850,	r15	;#0x3dea
	mov	12(r1),	r11	;0x0000c
	calla	#__mspabi_mpyd		;0x082a8

	mov	22(r1),	r8	;0x00016

	mov	24(r1),	r9	;0x00018
	mov	26(r1),	r10	;0x0001a
	mov	34(r1),	r11	;0x00022
	calla	#__mspabi_subd		;0x08240
	mov	r12,	r8	;
	mov	r13,	r9	;
	mov	r14,	r10	;
	mov	r15,	r11	;

	mov	18(r1),	r12	;0x00012
	mov	28(r1),	r13	;0x0001c
	mov	30(r1),	r14	;0x0001e
	mov	16(r1),	r15	;0x00010
	calla	#__mspabi_subd		;0x08240

	mov	20(r1),	r8	;0x00014
	mov	32(r1),	r9	;0x00020
	mov	36(r1),	r10	;0x00024
	mov	44(r1),	r11	;0x0002c

.L902:
	calla	#__mspabi_subd		;0x08240
	jmp .L834	;mova	#28420,	r0	;0x06f04

.L903:
	clr.b	r12		;
	mov	r12,	r13	;
	mov	r12,	r14	;
	mov	#16384,	r15	;#0x4000

	mov	18(r1),	r8	;0x00012

	mov	28(r1),	r9	;0x0001c
	mov	30(r1),	r10	;0x0001e
	mov	16(r1),	r11	;0x00010
	calla	#__mspabi_addd		;0x081dc

	mov	16(r1),	r11	;0x00010
	calla	#__mspabi_divd		;0x058da
	mov	r12,	34(r1)	; 0x0022
	mov	r13,	36(r1)	; 0x0024
	mov	r14,	44(r1)	; 0x002c
	mov	r15,	46(r1)	; 0x002e

	mov	32(r1),	r12	;0x00020

	mov	20(r1),	r13	;0x00014

	calla	#__mspabi_fltlid		;0x08980

	mov	r12,	52(r1)	; 0x0034
	mov	r13,	54(r1)	; 0x0036
	mov	r14,	56(r1)	; 0x0038
	mov	r15,	48(r1)	; 0x0030

	mov	34(r1),	r12	;0x00022

	mov	36(r1),	r13	;0x00024

	mov	44(r1),	r14	;0x0002c

	mov	46(r1),	r15	;0x0002e

	mov	r12,	r8	;
	mov	r13,	r9	;
	mov	r14,	r10	;
	mov	r15,	r11	;
	calla	#__mspabi_mpyd		;0x082a8
	mov	r12,	38(r1)	; 0x0026
	mov	r13,	40(r1)	; 0x0028
	mov	r14,	42(r1)	; 0x002a
	mov	r15,	50(r1)	; 0x0032

	mov	12(r1),	r9	;0x0000c
	add	#-5242,	r9	;#0xeb86
	mov	r9,	58(r1)	; 0x003a
	mov	14(r1),	r10	;0x0000e
	addc	#-7,	r10	;#0xfff9
	mov	r10,	60(r1)	; 0x003c

	mov	r12,	r8	;
	mov	r13,	r9	;

	mov	r14,	r10	;

	mov	r15,	r11	;
	calla	#__mspabi_mpyd		;0x082a8

	mov	r12,	22(r1)	; 0x0016
	mov	r13,	r7	;
	mov	r14,	24(r1)	; 0x0018
	mov	r15,	26(r1)	; 0x001a

	mov	#21060,	r12	;#0x5244

	mov	#-8386,	r13	;#0xdf3e
	mov	#-3822,	r14	;#0xf112

	mov	#16322,	r15	;#0x3fc2

	mov	22(r1),	r8	;0x00016

	mov	r7,	r9	;

	mov	24(r1),	r10	;0x00018

	mov	26(r1),	r11	;0x0001a
	calla	#__mspabi_mpyd		;0x082a8
	mov	r12,	r8	;
	mov	r13,	r9	;
	mov	r14,	r10	;
	mov	r15,	r11	;

	mov	#990,	r12	;#0x03de
	mov	#-26933,r13	;#0x96cb
	mov	#18020,	r14	;#0x4664
	mov	#16327,	r15	;#0x3fc7
	calla	#__mspabi_addd		;0x081dc
	mov	r12,	r8	;
	mov	r13,	r9	;
	mov	r14,	r10	;
	mov	r15,	r11	;

	mov	22(r1),	r12	;0x00016
	mov	r7,	r13	;
	mov	24(r1),	r14	;0x00018
	mov	26(r1),	r15	;0x0001a
	calla	#__mspabi_mpyd		;0x082a8
	mov	r12,	r8	;
	mov	r13,	r9	;
	mov	r14,	r10	;
	mov	r15,	r11	;

	mov	#-27815,r12	;#0x9359
	mov	#-27614,r13	;#0x9422
	mov	#18724,	r14	;#0x4924
	mov	#16338,	r15	;#0x3fd2
	calla	#__mspabi_addd		;0x081dc
	mov	r12,	r8	;
	mov	r13,	r9	;
	mov	r14,	r10	;
	mov	r15,	r11	;

	mov	22(r1),	r12	;0x00016
	mov	r7,	r13	;
	mov	24(r1),	r14	;0x00018
	mov	26(r1),	r15	;0x0001a
	calla	#__mspabi_mpyd		;0x082a8
	mov	r12,	r8	;
	mov	r13,	r9	;
	mov	r14,	r10	;
	mov	r15,	r11	;

	mov	#21907,	r12	;#0x5593
	mov	#21845,	r13	;#0x5555
	mov	r13,	r14	;
	mov	#16357,	r15	;#0x3fe5
	calla	#__mspabi_addd		;0x081dc
	mov	r12,	r8	;
	mov	r13,	r9	;
	mov	r14,	r10	;
	mov	r15,	r11	;

	mov	38(r1),	r12	;0x00026
	mov	40(r1),	r13	;0x00028
	mov	42(r1),	r14	;0x0002a
	mov	50(r1),	r15	;0x00032
	calla	#__mspabi_mpyd		;0x082a8
	mov	r12,	38(r1)	; 0x0026

	mov	r13,	40(r1)	; 0x0028
	mov	r14,	42(r1)	; 0x002a
	mov	r15,	50(r1)	; 0x0032

	mov	#-14689,r12	;#0xc69f
	mov	#-12168,r13	;#0xd078
	mov	#-26103,r14	;#0x9a09
	mov	#16323,	r15	;#0x3fc3
	mov	22(r1),	r8	;0x00016
	mov	r7,	r9	;
	mov	24(r1),	r10	;0x00018
	mov	26(r1),	r11	;0x0001a
	calla	#__mspabi_mpyd		;0x082a8
	mov	r12,	r8	;
	mov	r13,	r9	;
	mov	r14,	r10	;
	mov	r15,	r11	;

	mov	#30895,	r12	;#0x78af
	mov	#7566,	r13	;#0x1d8e
	mov	#29125,	r14	;#0x71c5
	mov	#16332,	r15	;#0x3fcc
	calla	#__mspabi_addd		;0x081dc
	mov	r12,	r8	;
	mov	r13,	r9	;
	mov	r14,	r10	;
	mov	r15,	r11	;

	mov	22(r1),	r12	;0x00016
	mov	r7,	r13	;
	mov	24(r1),	r14	;0x00018
	mov	26(r1),	r15	;0x0001a
	calla	#__mspabi_mpyd		;0x082a8
	mov	r12,	r8	;
	mov	r13,	r9	;
	mov	r14,	r10	;
	mov	r15,	r11	;

	mov	#-1532,	r12	;#0xfa04
	mov	#-26217,r13	;#0x9997
	mov	#-26215,r14	;#0x9999
	mov	#16345,	r15	;#0x3fd9
	calla	#__mspabi_addd		;0x081dc
	mov	r12,	r8	;
	mov	r13,	r9	;
	mov	r14,	r10	;
	mov	r15,	r11	;

	mov	22(r1),	r12	;0x00016
	mov	r7,	r13	;
	mov	24(r1),	r14	;0x00018
	mov	26(r1),	r15	;0x0001a
	calla	#__mspabi_mpyd		;0x082a8

	mov	38(r1),	r8	;0x00026
	mov	40(r1),	r9	;0x00028
	mov	42(r1),	r10	;0x0002a
	mov	50(r1),	r11	;0x00032
	calla	#__mspabi_addd		;0x081dc
	mov	r12,	r7	;

	mov	r13,	22(r1)	; 0x0016
	mov	r14,	24(r1)	; 0x0018
	mov	r15,	26(r1)	; 0x001a

	mov	#-18351,r14	;#0xb851

	mov.b	#6,	r15	;

	subx.w	12(r1),	r14	;0x0000c
	subcx.w	14(r1),	r15	;0x0000e

	mov	58(r1),	r13	;0x0003a

	bis	r14,	r13	;
	mov	60(r1),	r12	;0x0003c
	bis	r15,	r12	;

	clr.b	r14		;
	cmp	r12,	r14	;
	jl	.L948     	;abs 0x746a
	cmp	r14,	r12	;
	jnz	.L967    	;abs 0x75d0
	cmp	r14,	r13	;
	jz	.L967    	;abs 0x75d0

.L948:
	clr.b	r12		;
	mov	r12,	r13	;
	mov	r12,	r14	;
	mov	#16352,	r15	;#0x3fe0
	mov	18(r1),	r8	;0x00012
	mov	28(r1),	r9	;0x0001c
	mov	30(r1),	r10	;0x0001e
	mov	16(r1),	r11	;0x00010
	calla	#__mspabi_mpyd		;0x082a8
	mov	r12,	r8	;
	mov	r13,	r9	;
	mov	r14,	r10	;
	mov	r15,	r11	;

	mov	18(r1),	r12	;0x00012
	mov	28(r1),	r13	;0x0001c
	mov	30(r1),	r14	;0x0001e
	mov	16(r1),	r15	;0x00010
	calla	#__mspabi_mpyd		;0x082a8
	mov	r12,	12(r1)	; 0x000c

	mov	r13,	38(r1)	; 0x0026
	mov	r14,	40(r1)	; 0x0028
	mov	r15,	42(r1)	; 0x002a

	mov	r7,	r8	;
	mov	22(r1),	r9	;0x00016
	mov	24(r1),	r10	;0x00018
	mov	26(r1),	r11	;0x0001a
	calla	#__mspabi_addd		;0x081dc

	mov	r12,	r8	;
	mov	r13,	r9	;
	mov	r14,	r10	;
	mov	r15,	r11	;
	mov	34(r1),	r12	;0x00022
	mov	36(r1),	r13	;0x00024
	mov	44(r1),	r14	;0x0002c
	mov	46(r1),	r15	;0x0002e
	calla	#__mspabi_mpyd		;0x082a8
	mov	r12,	22(r1)	; 0x0016

	mov	r13,	r7	;
	mov	r14,	24(r1)	; 0x0018
	mov	r15,	26(r1)	; 0x001a

	mov	32(r1),	r9	;0x00020
	bis	20(r1),	r9	;0x00014
	cmp	#0,	r9	;r3 As==00
	jnz	.L958     	;abs 0x7528

	mov	12(r1),	r8	;0x0000c
	mov	38(r1),	r9	;0x00026
	mov	40(r1),	r10	;0x00028
	mov	42(r1),	r11	;0x0002a
	calla	#__mspabi_subd		;

	mov	18(r1),	r8	;0x00012
	mov	28(r1),	r9	;0x0001c
	mov	30(r1),	r10	;0x0001e
	mov	16(r1),	r11	;0x00010

.L957:
	calla	#__mspabi_subd		;
	jmp .L834	;mova	#28420,	r0	;0x06f04

.L958:
	clr.b	r12		;
	mov	#-288,	r13	;#0xfee0
	mov	#11842,	r14	;#0x2e42
	mov	#16358,	r15	;#0x3fe6
	mov	52(r1),	r8	;0x00034
	mov	54(r1),	r9	;0x00036
	mov	56(r1),	r10	;0x00038
	mov	48(r1),	r11	;0x00030
	calla	#__mspabi_mpyd		;0x082a8
	mov	r12,	20(r1)	; 0x0014

	mov	r13,	32(r1)	; 0x0020
	mov	r14,	34(r1)	; 0x0022

	mov	r15,	36(r1)	; 0x0024

	mov	#15478,	r12	;#0x3c76
	mov	#13689,	r13	;#0x3579
	mov	#14831,	r14	;#0x39ef
	mov	#15850,	r15	;#0x3dea
	mov	48(r1),	r11	;0x00030
	calla	#__mspabi_mpyd		;0x082a8
	mov	r12,	r8	;
	mov	r13,	r9	;
	mov	r14,	r10	;
	mov	r15,	r11	;

	mov	22(r1),	r12	;0x00016
	mov	r7,	r13	;
	mov	24(r1),	r14	;0x00018
	mov	26(r1),	r15	;0x0001a
	calla	#__mspabi_addd		;0x081dc

	mov	12(r1),	r8	;0x0000c
	mov	38(r1),	r9	;0x00026
	mov	40(r1),	r10	;0x00028
	mov	42(r1),	r11	;0x0002a
	calla	#__mspabi_subd		;

	mov	r12,	r8	;
	mov	r13,	r9	;
	mov	r14,	r10	;
	mov	r15,	r11	;

	mov	18(r1),	r12	;0x00012
	mov	28(r1),	r13	;0x0001c
	mov	30(r1),	r14	;0x0001e
	mov	16(r1),	r15	;0x00010
	calla	#__mspabi_subd		;

	mov	20(r1),	r8	;0x00014
	mov	32(r1),	r9	;0x00020
	mov	34(r1),	r10	;0x00022
	mov	36(r1),	r11	;0x00024
	jmp .L957	;mova	#29986,	r0	;0x07522

.L967:
	mov	r7,	r12	;
	mov	22(r1),	r13	;0x00016
	mov	24(r1),	r14	;0x00018
	mov	26(r1),	r15	;0x0001a
	mov	18(r1),	r8	;0x00012
	mov	28(r1),	r9	;0x0001c
	mov	30(r1),	r10	;0x0001e
	mov	16(r1),	r11	;0x00010
	calla	#__mspabi_subd		;0x08240
	mov	r12,	r8	;
	mov	r13,	r9	;
	mov	r14,	r10	;
	mov	r15,	r11	;

	mov	34(r1),	r12	;0x00022
	mov	36(r1),	r13	;0x00024
	mov	44(r1),	r14	;0x0002c
	mov	46(r1),	r15	;0x0002e
	calla	#__mspabi_mpyd		;

	mov	r12,	12(r1)	; 0x000c

	mov	r13,	22(r1)	; 0x0016
	mov	r14,	24(r1)	; 0x0018
	mov	r15,	26(r1)	; 0x001a

	mov	32(r1),	r9	;0x00020
	bis	20(r1),	r9	;0x00014
	cmp	#0,	r9	;r3 As==00
	jnz	.L972      	;abs 0x7630
	jmp .L889	;mova	#29016,	r0	;0x07158

.L972:
	clr.b	r12		;
	mov	#-288,	r13	;#0xfee0
	mov	#11842,	r14	;#0x2e42
	mov	#16358,	r15	;#0x3fe6
	mov	52(r1),	r8	;0x00034
	mov	54(r1),	r9	;0x00036
	mov	56(r1),	r10	;0x00038
	mov	48(r1),	r11	;0x00030
	calla	#__mspabi_mpyd		;

	mov	r12,	20(r1)	; 0x0014

	mov	r13,	32(r1)	; 0x0020
	mov	r14,	34(r1)	; 0x0022

	mov	r15,	36(r1)	; 0x0024

	mov	#15478,	r12	;#0x3c76
	mov	#13689,	r13	;#0x3579
	mov	#14831,	r14	;#0x39ef
	mov	#15850,	r15	;#0x3dea
	mov	48(r1),	r11	;0x00030
	calla	#__mspabi_mpyd		;

	mov	12(r1),	r8	;0x0000c
	mov	22(r1),	r9	;0x00016
	mov	24(r1),	r10	;0x00018
	mov	26(r1),	r11	;0x0001a
	calla	#__mspabi_subd		;0x08240
	mov	r12,	r8	;
	mov	r13,	r9	;
	mov	r14,	r10	;
	mov	r15,	r11	;

	mov	18(r1),	r12	;0x00012
	mov	28(r1),	r13	;0x0001c
	mov	30(r1),	r14	;0x0001e
	mov	16(r1),	r15	;0x00010
	calla	#__mspabi_subd		;0x08240

	mov	20(r1),	r8	;0x00014
	mov	32(r1),	r9	;0x00020
	mov	34(r1),	r10	;0x00022
	mov	36(r1),	r11	;0x00024
	jmp .L902	;mova	#29184,	r0	;0x07200

.L980:
	mov	r12,	r13	;
	mov	r12,	r14	;
	mov	r12,	r15	;

	jmp .L834	;mova	#28420,	r0	;0x06f04



	.global __ieee754_sqrt
	.type __ieee754_sqrt, @function
__ieee754_sqrt:
	nop
	nop
	pushm.a	#4,	r10	;20-bit words

	suba	#46,	r1	;0x0002e

	mov	r12,	r8	;
	mov	r13,	r9	;
	mov	r14,	r10	;
	mov	r15,	r7	;

	mov	r14,	30(r1)	; 0x001e
	mov	r15,	0(r1)	;
	mov	r14,	14(r1)	; 0x000e
	mov	r15,	16(r1)	; 0x0010

	mov	r12,	36(r1)	; 0x0024
	mov	r13,	38(r1)	; 0x0026
	mov	r12,	10(r1)	; 0x000a
	mov	r13,	12(r1)	; 0x000c

	mov	r15,	r11	;
	and	#32752,	r11	;#0x7ff0

	cmp	#32752,	r11	;#0x7ff0
	jnz	.L994     	;abs 0x7722

	mov	r15,	r11	;
	calla	#__mspabi_mpyd		;0x082a8

	mov	r7,	r11	;
	calla	#__mspabi_addd		;0x081dc

.L990:
	mov	r12,	r8	;
	mov	r13,	r9	;
	mov	r14,	r10	;
	mov	r15,	r7	;

.L991:
	mov	r8,	r12	;
	mov	r9,	r13	;
	mov	r10,	r14	;
	mov	r7,	r15	;
	adda	#46,	r1	;0x0002e

	popm.a	#4,	r10	;20-bit words

	reta			;

.L994:
	clr.b	r12		;

	cmp	@r1,	r12	;
	jl	.L1005     	;abs 0x7772
	cmp	r12,	r15	;
	jnz	.L996     	;abs 0x7734
	mov	30(r1),	r12	;0x0001e
	cmp	#0,	r12	;r3 As==00
	jnz	.L1005     	;abs 0x7772

.L996:
	mov	30(r1),	r14	;0x0001e

	mov	36(r1),	r12	;0x00024
	bis	r14,	r12	;
	mov	@r1,	r13	;
	and	#32767,	r13	;#0x7fff
	bis	38(r1),	r13	;0x00026

	bis	r13,	r12	;
	cmp	#0,	r12	;r3 As==00
	jz	.L991     	;abs 0x7712

	bis	@r1,	r14	;
	cmp	#0,	r14	;r3 As==00
	jz	.L1005     	;abs 0x7772

	mov	r8,	r12	;
	mov	r9,	r13	;
	mov	r10,	r14	;
	mov	r7,	r15	;
	mov	r7,	r11	;
	calla	#__mspabi_subd		;0x08240
	mov	r12,	r8	;

	mov	r13,	r9	;

	mov	r14,	r10	;

	mov	r15,	r11	;

	calla	#__mspabi_divd		;0x058da
	jmp .L990	;mova	#30474,	r0	;0x0770a

.L1005:
	mov	30(r1),	r12	;0x0001e
	mov	@r1,	r13	;
	mov.b	#20,	r14	;#0x0014
	calla	#__mspabi_sral		;0x08ab8
	mov	r12,	r8	;

	mov	r13,	r9	;

	bis	r13,	r12	;
	cmp	#0,	r12	;r3 As==00
	jz	.L1099    	;abs 0x7b6c

.L1008:
	mov	r8,	r11	;
	add	#-1023,	r11	;#0xfc01
	mov	r11,	32(r1)	; 0x0020
	mov	r9,	r12	;
	addc	#-1,	r12	;r3 As==11
	mov	r12,	34(r1)	; 0x0022

	mov	16(r1),	r12	;0x00010
	and.b	#15,	r12	;#0x000f

	mov	14(r1),	r10	;0x0000e
	mov	r12,	r9	;
	bis	#16,	r9	;#0x0010

	mov	r11,	r12	;
	and.b	#1,	r12	;r3 As==01

	cmp	#0,	r12	;r3 As==00
	jz	.L1015     	;abs 0x77de
	rla	r10		;

	rlc	r9		;

	mov	10(r1),	r12	;0x0000a
	mov	12(r1),	r13	;0x0000c
	mov.b	#31,	r14	;#0x001f
	calla	#__mspabi_srll		;0x05dda
	add	r12,	r10	;
	addc	r13,	r9	;
	rlax.w	10(r1)		;#0x0000a
	rlcx.w	12(r1)		;#0x0000c

.L1015:
	mov	32(r1),	r11	;0x00020
	mov	34(r1),	r12	;0x00022
	rra	r12		;
	rrc	r11		;
	mov	r11,	32(r1)	; 0x0020

	mov	r12,	34(r1)	; 0x0022

	rla	r10		;

	rlc	r9		;
	mov	10(r1),	r12	;0x0000a
	mov	12(r1),	r13	;0x0000c
	mov.b	#31,	r14	;#0x001f
	calla	#__mspabi_srll		;0x05dda
	add	r12,	r10	;
	mov	r10,	6(r1)	;
	addc	r13,	r9	;
	mov	r9,	8(r1)	;

	mov	10(r1),	r12	;0x0000a
	rla	r12		;
	mov	r12,	18(r1)	; 0x0012
	mov	12(r1),	r13	;0x0000c
	rlc	r13		;
	mov	r13,	20(r1)	; 0x0014

	mov.b	#22,	r7	;#0x0016

	mov	#0,	14(r1)	;r3 As==00, 0x000e
	mov	#0,	16(r1)	;r3 As==00, 0x0010

	mov	14(r1),	r8	;0x0000e
	mov	16(r1),	r9	;0x00010

	clr.b	r10		;
	mov.b	#32,	r11	;#0x0020

.L1024:
	mov	r8,	r14	;
	add	r10,	r14	;
	mov	r14,	26(r1)	; 0x001a
	mov	r9,	r12	;
	addc	r11,	r12	;
	mov	r12,	28(r1)	; 0x001c

	mov	8(r1),	r12	;
	cmp	28(r1),	r12	;0x0001c
	jl	.L1030     	;abs 0x789c
	mov	28(r1),	r12	;0x0001c
	cmp	8(r1),	r12	;
	jnz	.L1026     	;abs 0x786c
	mov	6(r1),	r12	;
	cmp	r14,	r12	;
	jnc	.L1030     	;abs 0x789c

.L1026:
	mov	26(r1),	r8	;0x0001a
	add	r10,	r8	;
	mov	28(r1),	r9	;0x0001c
	addc	r11,	r9	;

	subx.w	26(r1),	6(r1)	;0x0001a
	subcx.w	28(r1),	8(r1)	;0x0001c

	mov	14(r1),	r13	;0x0000e
	mov	16(r1),	r14	;0x00010
	add	r10,	r13	;
	addc	r11,	r14	;
	mov	r13,	14(r1)	; 0x000e

	mov	r14,	16(r1)	; 0x0010

.L1030:
	mov	18(r1),	r12	;0x00012
	mov	20(r1),	r13	;0x00014
	mov.b	#31,	r14	;#0x001f
	mova	r11,	2(r1)	;
	calla	#__mspabi_srll		;0x05dda
	mov	6(r1),	r14	;
	rla	r14		;
	mov	8(r1),	r15	;
	rlc	r15		;
	add	r14,	r12	;
	mov	r12,	6(r1)	;

	addc	r15,	r13	;
	mov	r13,	8(r1)	;

	rlax.w	18(r1)		;#0x00012
	rlcx.w	20(r1)		;#0x00014

	mova	2(r1),	r11	;
	clrc			
	rrc	r11		;
	rrc	r10		;

	add	#-1,	r7	;r3 As==11
	cmp	#0,	r7	;r3 As==00
	jnz	.L1024    	;abs 0x7840
	mov	#32,	26(r1)	;#0x0020, 0x001a

	clr.b	r10		;

	clr.b	r11		;

	mov	r10,	r7	;
	mov	r11,	30(r1)	; 0x001e

	mov	#0,	10(r1)	;r3 As==00, 0x000a
	mov	#-32768,12(r1)	;#0x8000, 0x000c

.L1039:
	mov	10(r1),	r14	;0x0000a
	add	r7,	r14	;
	mov	r14,	22(r1)	; 0x0016
	mov	30(r1),	r12	;0x0001e
	addcx.w	12(r1),	r12	;0x0000c
	mov	r12,	24(r1)	; 0x0018

	cmp	8(r1),	r9	;
	jl	.L1043     	;abs 0x795c
	mov	8(r1),	r12	;
	cmp	r9,	r12	;
	jnz	.L1041      	;abs 0x792e
	cmp	6(r1),	r8	;
	jnc	.L1043     	;abs 0x795c

.L1041:
	mov	6(r1),	r12	;
	cmp	r8,	r12	;
	jnz	.L1057    	;abs 0x79e4
	mov	8(r1),	r12	;
	cmp	r9,	r12	;
	jnz	.L1057    	;abs 0x79e4

	mov	20(r1),	r12	;0x00014
	cmp	24(r1),	r12	;0x00018
	jnc	.L1057    	;abs 0x79e4
	mov	24(r1),	r12	;0x00018
	cmp	20(r1),	r12	;0x00014
	jnz	.L1043     	;abs 0x795c
	mov	18(r1),	r12	;0x00012
	cmp	22(r1),	r12	;0x00016
	jnc	.L1057    	;abs 0x79e4

.L1043:
	mov	22(r1),	r7	;0x00016

	addx.w	10(r1),	r7	;0x0000a
	mov	24(r1),	r13	;0x00018
	addcx.w	12(r1),	r13	;0x0000c
	mov	r13,	30(r1)	; 0x001e

	mov	24(r1),	r12	;0x00018
	cmp	#0,	r12	;r3 As==00
	jge	.L1105    	;abs 0x7b8c

	mov	r13,	r12	;
	mov	r8,	r13	;

	cmp	#0,	r12	;r3 As==00
	jl	.L1106    	;abs 0x7b8e

	inc	r13		;
	mov	r9,	r12	;

	adc	r12		;

.L1050:
	subx.w	r8,	6(r1)	;
	subcx.w	r9,	8(r1)	;

	mov	20(r1),	r14	;0x00014
	cmp	24(r1),	r14	;0x00018
	jnc	.L1052     	;abs 0x79b4
	mov	24(r1),	r14	;0x00018
	cmp	20(r1),	r14	;0x00014
	jnz	.L1053     	;abs 0x79c4
	mov	18(r1),	r14	;0x00012
	cmp	22(r1),	r14	;0x00016
	jc	.L1053     	;abs 0x79c4

.L1052:
	addx.w	#65535,	6(r1)	;0x0ffff
	addcx.w	#65535,	8(r1)	;0x0ffff

.L1053:
	subx.w	22(r1),	18(r1)	;0x00016, 0x00012
	subcx.w	24(r1),	20(r1)	;0x00018, 0x00014

	addx.w	10(r1),	r10	;0x0000a

	addcx.w	12(r1),	r11	;0x0000c

	mov	r13,	r8	;
	mov	r12,	r9	;

.L1057:
	mov	18(r1),	r12	;0x00012
	mov	20(r1),	r13	;0x00014
	mov.b	#31,	r14	;#0x001f
	mova	r11,	2(r1)	;
	calla	#__mspabi_srll		;0x05dda
	mov	6(r1),	r14	;
	rla	r14		;
	mov	8(r1),	r15	;
	rlc	r15		;
	add	r14,	r12	;
	mov	r12,	6(r1)	;

	addc	r15,	r13	;
	mov	r13,	8(r1)	;

	rlax.w	18(r1)		;#0x00012
	rlcx.w	20(r1)		;#0x00014

	clrc			
	rrcx.w	12(r1)		;0000c
	rrcx.w	10(r1)		;0000a

	add	#-1,	26(r1)	;r3 As==11, 0x001a
	mova	2(r1),	r11	;
	cmp	#0,	26(r1)	;r3 As==00, 0x001a
	jnz	.L1039    	;abs 0x7902

	bis	18(r1),	r12	;0x00012
	bis	20(r1),	r13	;0x00014

	bis	r13,	r12	;
	cmp	#0,	r12	;r3 As==00
	jz	.L1067     	;abs 0x7a62

	cmp	#-1,	r10	;r3 As==11
	jnz	.L1107    	;abs 0x7b94
	cmp	#-1,	r11	;r3 As==11
	jnz	.L1107    	;abs 0x7b94

	incx.w	14(r1)		;
	adcx.w	16(r1)		;

	clr.b	r10		;
	clr.b	r11		;

.L1067:
	mov	14(r1),	r12	;0x0000e
	mov	16(r1),	r13	;0x00010
	rra	r13		;
	rrc	r12		;

	mov	r12,	r14	;
	add	#0,	r14	;r3 As==00
	mov	r14,	6(r1)	;

	mov	r13,	r7	;

	addc	#16352,	r7	;#0x3fe0

	mov	r10,	r8	;
	mov	r11,	r9	;
	clrc			
	rrc	r9		;
	rrc	r8		;

	mov	14(r1),	r12	;0x0000e

	and.b	#1,	r12	;r3 As==01

	cmp	#0,	r12	;r3 As==00
	jz	.L1076     	;abs 0x7a98

	mov	r9,	r12	;
	bis	#-32768,r12	;#0x8000
	mov	r12,	r9	;

.L1076:
	mov	32(r1),	r12	;0x00020
	mov	34(r1),	r13	;0x00022
	mov.b	#20,	r14	;#0x0014
	calla	#__mspabi_slll		;0x05dae

	mov	6(r1),	r10	;

	add	r12,	r10	;
	addc	r13,	r7	;

	jmp .L991	;mova	#30482,	r0	;0x07712

.L1080:
	add	#-21,	r10	;#0xffeb

	addc	#-1,	r11	;r3 As==11

	mov	10(r1),	r12	;0x0000a
	mov	12(r1),	r13	;0x0000c
	mov.b	#11,	r14	;#0x000b
	mova	r11,	2(r1)	;
	calla	#__mspabi_srll		;0x05dda
	mov	r12,	14(r1)	; 0x000e

	mov	r13,	16(r1)	; 0x0010

	mov	10(r1),	r12	;0x0000a
	mov	12(r1),	r13	;0x0000c
	mov.b	#21,	r14	;#0x0015
	calla	#__mspabi_slll		;0x05dae
	mov	r12,	10(r1)	; 0x000a

	mov	r13,	12(r1)	; 0x000c

	mova	2(r1),	r11	;

.L1087:
	mov	14(r1),	r12	;0x0000e
	bis	16(r1),	r12	;0x00010
	cmp	#0,	r12	;r3 As==00
	jz	.L1080     	;abs 0x7ab4

.L1088:
	bitx.w	#16,	16(r1)	;0x00010, 0x00010
	jz	.L1101    	;abs 0x7b74

	mov	r8,	r13	;
	add	#-1,	r13	;r3 As==11
	mov	r13,	42(r1)	; 0x002a
	mov	r9,	r14	;
	addc	#-1,	r14	;r3 As==11
	mov	r14,	44(r1)	; 0x002c

	mov	r10,	r9	;
	mov	r11,	r10	;
	subx.w	42(r1),	r9	;0x0002a
	subcx.w	44(r1),	r10	;0x0002c

	mov	#32,	r14	;#0x0020
	sub	r8,	r14	;

	mov	10(r1),	r12	;0x0000a
	mov	12(r1),	r13	;0x0000c
	clr	r15		;
	calla	#__mspabi_srll		;0x05dda

	bis	14(r1),	r12	;0x0000e
	bis	16(r1),	r13	;0x00010
	mov	r12,	14(r1)	; 0x000e

	mov	r13,	16(r1)	; 0x0010

	mov	10(r1),	r12	;0x0000a
	mov	12(r1),	r13	;0x0000c
	mov	r8,	r14	;
	clr	r15		;
	calla	#__mspabi_slll		;0x05dae
	mov	r12,	10(r1)	; 0x000a
	mov	r13,	12(r1)	; 0x000c

	mov	r9,	r8	;

	mov	r10,	r9	;

	jmp .L1008	;mova	#30602,	r0	;0x0778a

.L1099:
	mov	r8,	r10	;

	mov	r13,	r11	;
	jmp .L1087	;mova	#31474,	r0	;0x07af2

.L1101:
	rlax.w	14(r1)		;#0x0000e
	rlcx.w	16(r1)		;#0x00010

	inc	r8		;

	adc	r9		;

	jmp .L1088	;mova	#31486,	r0	;0x07afe

.L1105:
	mov	r8,	r13	;

.L1106:
	mov	r9,	r12	;
	jmp .L1050	;mova	#31114,	r0	;0x0798a

.L1107:
	mov	r10,	r13	;
	inc	r13		;
	mov	r11,	r12	;
	adc	r12		;
	mov	r13,	r10	;

	bic	#1,	r10	;r3 As==01
	mov	r12,	r11	;

	jmp .L1067	;mova	#31330,	r0	;0x07a62



	.global finite
	.type finite, @function
finite:
	nop
	nop
	mov	r14,	r12	;

	mov	r15,	r13	;
	and	#32767,	r13	;#0x7fff

	add	#0,	r12	;r3 As==00
	addc	#-32752,r13	;#0x8010
	mov.b	#31,	r14	;#0x001f
	calla	#__mspabi_srll		;0x05dda

	reta			;



	.global nan
	.type nan, @function
nan:
	nop
	nop
	clr.b	r12		;

	mov	r12,	r13	;
	mov	r12,	r14	;
	mov	#32760,	r15	;#0x7ff8
	reta			;



	.global _fpadd_parts2
	.type _fpadd_parts2, @function
_fpadd_parts2:
	nop
	nop
	pushm.a	#4,	r10	;20-bit words

	suba	#36,	r1	;0x00024

	mova	r12,	0(r1)	;
	mova	r13,	6(r1)	;
	mova	r14,	r7	;

	mova	r12,	r8	;
	mov	@r12,	r12	;

	mov.b	#1,	r9	;r3 As==01
	cmp	r12,	r9	;
	jc	.L1125     	;abs 0x7c0a

	mova	r13,	r8	;

	mov	@r13,	r13	;

	cmp	r13,	r9	;
	jnc	.L1121      	;abs 0x7bf0
	jmp .L1234	;mova	#33232,	r0	;0x081d0

.L1121:
	cmp	#4,	r12	;r2 As==10
	jnz	.L1128     	;abs 0x7c14

	cmp	#4,	r13	;r2 As==10
	jnz	.L1125     	;abs 0x7c0a

	mova	@r1,	r12	;
	cmp	2(r8),	2(r12)	;
	jz	.L1125     	;abs 0x7c0a

	movx.a	#82954,	0(r1)	;0x1440a

.L1125:
	mova	@r1,	r12	;
	adda	#36,	r1	;0x00024

	popm.a	#4,	r10	;20-bit words

	reta			;

.L1128:
	cmp	#4,	r13	;r2 As==10
	jnz	.L1129      	;abs 0x7c1c
	jmp .L1234	;mova	#33232,	r0	;0x081d0

.L1129:
	cmp	#2,	r13	;r3 As==10
	jnz	.L1134     	;abs 0x7c4a

	cmp	#2,	r12	;r3 As==10
	jnz	.L1125     	;abs 0x7c0a

	mov.b	#14,	r14	;#0x000e
	mova	@r1,	r13	;
	mova	r7,	r12	;
	calla	#memcpy		;0x065a2

	mova	@r1,	r13	;
	mov	2(r13),	r14	;
	mova	6(r1),	r13	;
	and	2(r13),	r14	;
	mov	r14,	2(r7)	;

.L1133:
	mova	r7,	0(r1)	;
	jmp .L1125	;mova	#31754,	r0	;0x07c0a

.L1134:
	cmp	#2,	r12	;r3 As==10
	jnz	.L1135      	;abs 0x7c52
	jmp .L1234	;mova	#33232,	r0	;0x081d0

.L1135:
	mova	@r1,	r8	;

	mov	4(r8),	18(r1)	; 0x0012

	mova	6(r1),	r12	;
	mov	4(r12),	28(r1)	; 0x001c

	mov	6(r8),	4(r1)	;
	mov	8(r8),	12(r1)	; 0x000c
	mov	10(r8),	22(r1)	;0x0000a, 0x0016
	mov	12(r8),	14(r1)	;0x0000c, 0x000e

	mov	6(r12),	10(r1)	; 0x000a
	mov	8(r12),	20(r1)	; 0x0014
	mov	10(r12),26(r1)	;0x0000a, 0x001a
	mov	12(r12),16(r1)	;0x0000c, 0x0010

	mov	18(r1),	r13	;0x00012
	sub	28(r1),	r13	;0x0001c
	mov	r13,	24(r1)	; 0x0018

	cmp	#0,	r13	;r3 As==00
	jge	.L1155    	;abs 0x7daa

	mov	28(r1),	r14	;0x0001c
	sub	18(r1),	r14	;0x00012
	mov	r14,	24(r1)	; 0x0018

	mov.b	#63,	r8	;#0x003f
	cmp	r14,	r8	;
	jl	.L1197    	;abs 0x7ff8

	mov	4(r1),	r8	;
	mov	12(r1),	r9	;0x0000c
	mov	22(r1),	r10	;0x00016
	mov	14(r1),	r11	;0x0000e
	mov	24(r1),	r12	;0x00018

	calla	#__mspabi_srlll		;0x05de0

	mov	r12,	18(r1)	; 0x0012

	mov	r13,	30(r1)	; 0x001e
	mov	r14,	32(r1)	; 0x0020
	mov	r15,	34(r1)	; 0x0022
	mov	#-1,	r8	;r3 As==11
	mov	r8,	r9	;
	mov	r8,	r10	;
	mov	r8,	r11	;
	mov	24(r1),	r12	;0x00018
	calla	#__mspabi_sllll		;0x05db4
	mov	4(r1),	r8	;
	bic	r12,	r8	;
	mov	12(r1),	r12	;0x0000c
	bic	r13,	r12	;
	mov	r12,	r13	;
	mov	22(r1),	r9	;0x00016
	bic	r14,	r9	;
	mov	r9,	r14	;
	mov	14(r1),	r12	;0x0000e
	bic	r15,	r12	;
	mov	r12,	14(r1)	; 0x000e

	clr.b	r11		;
	mov	r11,	r9	;
	sub	r8,	r9	;
	mov	r9,	12(r1)	; 0x000c
	mov.b	#1,	r15	;r3 As==01
	cmp	r8,	r11	;
	jnz	.L1149      	;abs 0x7d22
	mov	r9,	r15	;

.L1149:
	mov	r11,	r12	;
	sub	r13,	r12	;
	mov.b	#1,	r10	;r3 As==01
	cmp	r13,	r11	;
	jnz	.L1150      	;abs 0x7d2e
	mov	r12,	r10	;

.L1150:
	mov	r12,	r9	;
	sub	r15,	r9	;
	mov	r9,	22(r1)	; 0x0016
	mov.b	#1,	r15	;r3 As==01
	cmp	r9,	r12	;
	jnc	.L1151      	;abs 0x7d3e
	clr.b	r15		;

.L1151:
	bis	r15,	r10	;
	mov	r11,	r12	;
	sub	r14,	r12	;
	mov.b	#1,	r15	;r3 As==01
	cmp	r14,	r11	;
	jnz	.L1152      	;abs 0x7d4c
	mov	r12,	r15	;

.L1152:
	mov	r12,	r9	;
	sub	r10,	r9	;
	mov	r9,	4(r1)	;
	mov.b	#1,	r10	;r3 As==01
	cmp	r9,	r12	;
	jnc	.L1153      	;abs 0x7d5c
	clr.b	r10		;

.L1153:
	bis	r10,	r15	;
	sub	14(r1),	r11	;0x0000e
	sub	r15,	r11	;
	bis	12(r1),	r8	;0x0000c
	mov	22(r1),	r9	;0x00016
	bis	r13,	r9	;
	mov	4(r1),	r10	;
	bis	r14,	r10	;
	bis	14(r1),	r11	;0x0000e
	mov.b	#63,	r12	;#0x003f
	calla	#__mspabi_srlll		;0x05de0
	bis	18(r1),	r12	;0x00012
	mov	r12,	4(r1)	;
	bis	30(r1),	r13	;0x0001e
	mov	r13,	12(r1)	; 0x000c
	bis	32(r1),	r14	;0x00020
	mov	r14,	22(r1)	; 0x0016
	bis	34(r1),	r15	;0x00022
	mov	r15,	14(r1)	; 0x000e

	mov	28(r1),	18(r1)	;0x0001c, 0x0012
	jmp .L1169	;mova	#32418,	r0	;0x07ea2

.L1155:
	mov.b	#63,	r9	;#0x003f
	cmp	24(r1),	r9	;0x00018
	jl	.L1197    	;abs 0x7ff8

	cmp	#0,	24(r1)	;r3 As==00, 0x0018
	jz	.L1169    	;abs 0x7ea2

	mov	10(r1),	r8	;0x0000a

	mov	20(r1),	r9	;0x00014
	mov	26(r1),	r10	;0x0001a
	mov	16(r1),	r11	;0x00010
	mov	24(r1),	r12	;0x00018

	calla	#__mspabi_srlll		;0x05de0

	mov	r12,	28(r1)	; 0x001c

	mov	r13,	30(r1)	; 0x001e
	mov	r14,	32(r1)	; 0x0020
	mov	r15,	34(r1)	; 0x0022
	mov	#-1,	r8	;r3 As==11
	mov	r8,	r9	;
	mov	r8,	r10	;
	mov	r8,	r11	;
	mov	24(r1),	r12	;0x00018
	calla	#__mspabi_sllll		;0x05db4
	mov	10(r1),	r8	;0x0000a
	bic	r12,	r8	;
	mov	20(r1),	r12	;0x00014
	bic	r13,	r12	;
	mov	r12,	r13	;
	mov	26(r1),	r9	;0x0001a
	bic	r14,	r9	;
	mov	r9,	r14	;
	mov	16(r1),	r12	;0x00010
	bic	r15,	r12	;
	mov	r12,	16(r1)	; 0x0010

	clr.b	r11		;
	mov	r11,	r9	;
	sub	r8,	r9	;
	mov	r9,	20(r1)	; 0x0014
	mov.b	#1,	r15	;r3 As==01
	cmp	r8,	r11	;
	jnz	.L1163      	;abs 0x7e24
	mov	r11,	r15	;

.L1163:
	mov	r11,	r12	;
	sub	r13,	r12	;
	mov.b	#1,	r10	;r3 As==01
	cmp	r13,	r11	;
	jnz	.L1164      	;abs 0x7e30
	mov	r12,	r10	;

.L1164:
	mov	r12,	r9	;
	sub	r15,	r9	;
	mov	r9,	24(r1)	; 0x0018

	mov.b	#1,	r15	;r3 As==01
	cmp	r9,	r12	;
	jnc	.L1166      	;abs 0x7e40
	clr.b	r15		;

.L1166:
	bis	r15,	r10	;
	mov	r11,	r12	;
	sub	r14,	r12	;
	mov.b	#1,	r15	;r3 As==01
	cmp	r14,	r11	;
	jnz	.L1167      	;abs 0x7e4e
	mov	r12,	r15	;

.L1167:
	mov	r12,	r9	;
	sub	r10,	r9	;
	mov	r9,	10(r1)	; 0x000a
	mov.b	#1,	r10	;r3 As==01
	cmp	r9,	r12	;
	jnc	.L1168      	;abs 0x7e5e
	clr.b	r10		;

.L1168:
	bis	r10,	r15	;
	sub	16(r1),	r11	;0x00010
	sub	r15,	r11	;
	bis	20(r1),	r8	;0x00014
	mov	24(r1),	r9	;0x00018
	bis	r13,	r9	;
	mov	10(r1),	r10	;0x0000a
	bis	r14,	r10	;
	bis	16(r1),	r11	;0x00010
	mov.b	#63,	r12	;#0x003f
	calla	#__mspabi_srlll		;0x05de0
	bis	28(r1),	r12	;0x0001c
	mov	r12,	10(r1)	; 0x000a
	bis	30(r1),	r13	;0x0001e
	mov	r13,	20(r1)	; 0x0014
	bis	32(r1),	r14	;0x00020
	mov	r14,	26(r1)	; 0x001a
	bis	34(r1),	r15	;0x00022
	mov	r15,	16(r1)	; 0x0010

.L1169:
	mova	@r1,	r13	;
	mov	2(r13),	r12	;

	mova	6(r1),	r8	;
	cmp	2(r8),	r12	;
	jz	.L1225    	;abs 0x8158

	cmp	#0,	r12	;r3 As==00
	jz	.L1202    	;abs 0x803a

	mov	10(r1),	r14	;0x0000a
	sub	4(r1),	r14	;
	mov.b	#1,	r10	;r3 As==01
	cmp	r14,	10(r1)	; 0x000a
	jnc	.L1173      	;abs 0x7ec8
	clr.b	r10		;

.L1173:
	mov	20(r1),	r12	;0x00014
	sub	12(r1),	r12	;0x0000c
	mov.b	#1,	r15	;r3 As==01
	cmp	r12,	20(r1)	; 0x0014
	jnc	.L1174      	;abs 0x7eda
	clr.b	r15		;

.L1174:
	mov	r12,	r13	;
	sub	r10,	r13	;
	mov.b	#1,	r10	;r3 As==01
	cmp	r13,	r12	;
	jnc	.L1175      	;abs 0x7ee6
	clr.b	r10		;

.L1175:
	bis	r10,	r15	;
	mov	26(r1),	r9	;0x0001a
	sub	22(r1),	r9	;0x00016
	mov.b	#1,	r10	;r3 As==01
	cmp	r9,	26(r1)	; 0x001a
	jnc	.L1176      	;abs 0x7efa
	clr.b	r10		;

.L1176:
	mov	r9,	r12	;
	sub	r15,	r12	;
	mov.b	#1,	r15	;r3 As==01
	cmp	r12,	r9	;
	jnc	.L1177      	;abs 0x7f06
	clr.b	r15		;

.L1177:
	bis	r15,	r10	;
	mov	16(r1),	r11	;0x00010
	sub	14(r1),	r11	;0x0000e

.L1178:
	sub	r10,	r11	;

	cmp	#0,	r11	;r3 As==00
	jl	.L1208    	;abs 0x8098

	mov	#0,	2(r7)	;r3 As==00

	mov	18(r1),	4(r7)	;0x00012

	mov	r14,	6(r7)	;
	mov	r13,	8(r7)	;
	mov	r12,	10(r7)	; 0x000a
	mov	r11,	12(r7)	; 0x000c

.L1183:
	mov.b	#1,	r11	;r3 As==01
	clr.b	r14		;

.L1184:
	mov	6(r7),	r15	;
	mov	8(r7),	0(r1)	;
	mov	10(r7),	r10	;0x0000a
	mov	12(r7),	6(r1)	;0x0000c

	mov	r15,	r9	;
	add	#-1,	r9	;r3 As==11
	mov	r9,	10(r1)	; 0x000a
	mov	r11,	r9	;
	cmp	#0,	r15	;r3 As==00
	jnz	.L1186      	;abs 0x7f58
	mov	r14,	r9	;

.L1186:
	mov	@r1,	r8	;
	add	#-1,	r8	;r3 As==11
	mov.b	#1,	r12	;r3 As==01
	cmp	#0,	0(r1)	;r3 As==00
	jnz	.L1187      	;abs 0x7f66
	clr.b	r12		;

.L1187:
	add	r8,	r9	;
	mov	r11,	r13	;
	cmp	r8,	r9	;
	jnc	.L1188      	;abs 0x7f70
	mov	r14,	r13	;

.L1188:
	bis	r13,	r12	;
	mov	r10,	r13	;
	add	#-1,	r13	;r3 As==11
	mov	r13,	4(r1)	;
	mov.b	#1,	r13	;r3 As==01
	cmp	#0,	r10	;r3 As==00
	jnz	.L1189      	;abs 0x7f82
	clr.b	r13		;

.L1189:
	add	4(r1),	r12	;
	mov	r11,	r8	;
	cmp	4(r1),	r12	;
	jnc	.L1190      	;abs 0x7f90
	mov	r14,	r8	;

.L1190:
	bis	r8,	r13	;
	mov	6(r1),	r8	;
	add	#-1,	r8	;r3 As==11
	add	r8,	r13	;

	mov	#4095,	r8	;#0x0fff
	cmp	r13,	r8	;
	jnc	.L1192     	;abs 0x7fb8
	cmp	r8,	r13	;
	jnz	.L1218    	;abs 0x80fc
	cmp	#-1,	r12	;r3 As==11
	jnz	.L1218    	;abs 0x80fc
	cmp	#-1,	r9	;r3 As==11
	jnz	.L1218    	;abs 0x80fc
	mov	#-2,	r9	;#0xfffe
	cmp	10(r1),	r9	;0x0000a
	jc	.L1218    	;abs 0x80fc

.L1192:
	mov	#3,	0(r7)	;

	mov	6(r7),	r8	;
	mov	8(r7),	r9	;
	mov	10(r7),	r10	;0x0000a
	mov	12(r7),	r11	;0x0000c

	mov	#8191,	r12	;#0x1fff
	cmp	r11,	r12	;
	jc	.L1133    	;abs 0x7c42

	mov.b	#1,	r12	;r3 As==01
	calla	#__mspabi_srlll		;0x05de0
	and.b	#1,	r8	;r3 As==01
	bis	r8,	r12	;
	mov	r12,	6(r7)	;
	mov	r13,	8(r7)	;
	mov	r14,	10(r7)	; 0x000a
	mov	r15,	12(r7)	; 0x000c

	inc	4(r7)		;
	jmp .L1133	;mova	#31810,	r0	;0x07c42

.L1197:
	cmp	18(r1),	28(r1)	;0x00012, 0x001c
	jl	.L1200     	;abs 0x8020
	mov	28(r1),	18(r1)	;0x0001c, 0x0012

	mov	#0,	4(r1)	;r3 As==00

	mov	4(r1),	12(r1)	; 0x000c
	mov	4(r1),	22(r1)	; 0x0016
	mov	4(r1),	14(r1)	; 0x000e
	jmp .L1169	;mova	#32418,	r0	;0x07ea2

.L1200:
	mov	#0,	10(r1)	;r3 As==00, 0x000a

	mov	10(r1),	20(r1)	;0x0000a, 0x0014
	mov	10(r1),	26(r1)	;0x0000a, 0x001a
	mov	10(r1),	16(r1)	;0x0000a, 0x0010
	jmp .L1169	;mova	#32418,	r0	;0x07ea2

.L1202:
	mov	4(r1),	r14	;
	sub	10(r1),	r14	;0x0000a
	mov.b	#1,	r10	;r3 As==01
	cmp	r14,	4(r1)	;
	jnc	.L1203      	;abs 0x804c
	mov	r12,	r10	;

.L1203:
	mov	12(r1),	r12	;0x0000c
	sub	20(r1),	r12	;0x00014
	mov.b	#1,	r15	;r3 As==01
	cmp	r12,	12(r1)	; 0x000c
	jnc	.L1204      	;abs 0x805e
	clr.b	r15		;

.L1204:
	mov	r12,	r13	;
	sub	r10,	r13	;
	mov.b	#1,	r10	;r3 As==01
	cmp	r13,	r12	;
	jnc	.L1205      	;abs 0x806a
	clr.b	r10		;

.L1205:
	bis	r10,	r15	;
	mov	22(r1),	r9	;0x00016
	sub	26(r1),	r9	;0x0001a
	mov.b	#1,	r10	;r3 As==01
	cmp	r9,	22(r1)	; 0x0016
	jnc	.L1206      	;abs 0x807e
	clr.b	r10		;

.L1206:
	mov	r9,	r12	;
	sub	r15,	r12	;
	mov.b	#1,	r15	;r3 As==01
	cmp	r12,	r9	;
	jnc	.L1207      	;abs 0x808a
	clr.b	r15		;

.L1207:
	bis	r15,	r10	;
	mov	14(r1),	r11	;0x0000e
	sub	16(r1),	r11	;0x00010
	jmp .L1178	;mova	#32528,	r0	;0x07f10

.L1208:
	mov	#1,	2(r7)	;r3 As==01

	mov	18(r1),	4(r7)	;0x00012

	clr.b	r15		;
	mov	r15,	r10	;
	sub	r14,	r10	;
	mov.b	#1,	r9	;r3 As==01
	cmp	r14,	r15	;
	jnz	.L1211      	;abs 0x80b0
	mov	r10,	r9	;

.L1211:
	mov	r15,	r8	;
	sub	r13,	r8	;
	mov.b	#1,	r14	;r3 As==01

	cmp	r13,	r15	;
	jnz	.L1213      	;abs 0x80bc
	mov	r8,	r14	;

.L1213:
	mov	r8,	r13	;
	sub	r9,	r13	;
	mov.b	#1,	r9	;r3 As==01
	cmp	r13,	r8	;
	jnc	.L1214      	;abs 0x80c8
	clr.b	r9		;

.L1214:
	bis	r9,	r14	;
	mov	r15,	r8	;
	sub	r12,	r8	;
	mov.b	#1,	r9	;r3 As==01
	cmp	r12,	r15	;
	jnz	.L1215      	;abs 0x80d6
	mov	r8,	r9	;

.L1215:
	mov	r8,	r12	;
	sub	r14,	r12	;
	mov.b	#1,	r14	;r3 As==01
	cmp	r12,	r8	;
	jnc	.L1216      	;abs 0x80e2
	clr.b	r14		;

.L1216:
	bis	r14,	r9	;
	sub	r11,	r15	;

	mov	r10,	6(r7)	;
	mov	r13,	8(r7)	;
	mov	r12,	10(r7)	; 0x000a
	sub	r9,	r15	;
	mov	r15,	12(r7)	; 0x000c
	jmp .L1183	;mova	#32560,	r0	;0x07f30

.L1218:
	mov	r15,	r9	;
	add	r15,	r9	;
	mov	r11,	r13	;
	cmp	r15,	r9	;
	jnc	.L1219      	;abs 0x8108
	mov	r14,	r13	;

.L1219:
	mov	@r1,	r15	;
	rla	r15		;
	mov.b	#1,	r12	;r3 As==01
	cmp	@r1,	r15	;
	jnc	.L1220      	;abs 0x8114
	clr.b	r12		;

.L1220:
	add	r15,	r13	;
	mov	r11,	r8	;
	cmp	r15,	r13	;
	jnc	.L1221      	;abs 0x811e
	mov	r14,	r8	;

.L1221:
	bis	r8,	r12	;
	mov	r10,	r8	;
	add	r10,	r8	;
	mov.b	#1,	r15	;r3 As==01
	cmp	r10,	r8	;
	jnc	.L1222      	;abs 0x812c
	clr.b	r15		;

.L1222:
	add	r8,	r12	;
	mov	r11,	r10	;
	cmp	r8,	r12	;
	jnc	.L1223      	;abs 0x8136
	mov	r14,	r10	;

.L1223:
	bis	r10,	r15	;
	mov	6(r1),	r10	;
	rla	r10		;
	mov	r9,	6(r7)	;
	mov	r13,	8(r7)	;
	mov	r12,	10(r7)	; 0x000a
	add	r10,	r15	;
	mov	r15,	12(r7)	; 0x000c

	add	#-1,	4(r7)	;r3 As==11
	jmp .L1184	;mova	#32564,	r0	;0x07f34

.L1225:
	mov	r12,	2(r7)	;

	mov	18(r1),	4(r7)	;0x00012

	mov	4(r1),	r8	;
	add	10(r1),	r8	;0x0000a
	mov.b	#1,	r10	;r3 As==01
	cmp	4(r1),	r8	;
	jnc	.L1228      	;abs 0x8174
	clr.b	r10		;

.L1228:
	mov	12(r1),	r13	;0x0000c
	add	20(r1),	r13	;0x00014
	mov.b	#1,	r15	;r3 As==01
	cmp	12(r1),	r13	;0x0000c
	jnc	.L1229      	;abs 0x8186
	clr.b	r15		;

.L1229:
	add	r13,	r10	;
	mov.b	#1,	r12	;r3 As==01
	cmp	r13,	r10	;
	jnc	.L1230      	;abs 0x8190
	clr.b	r12		;

.L1230:
	bis	r12,	r15	;
	mov	22(r1),	r14	;0x00016
	add	26(r1),	r14	;0x0001a
	mov.b	#1,	r9	;r3 As==01
	cmp	22(r1),	r14	;0x00016
	jnc	.L1231      	;abs 0x81a4
	clr.b	r9		;

.L1231:
	mov	r15,	r13	;
	add	r14,	r13	;
	mov.b	#1,	r12	;r3 As==01
	cmp	r14,	r13	;
	jnc	.L1232      	;abs 0x81b0
	clr.b	r12		;

.L1232:
	bis	r12,	r9	;
	mov	14(r1),	r15	;0x0000e
	add	16(r1),	r15	;0x00010

	mov	r8,	6(r7)	;
	mov	r10,	8(r7)	;
	mov	r13,	10(r7)	; 0x000a
	add	r15,	r9	;
	mov	r9,	12(r7)	; 0x000c
	jmp .L1192	;mova	#32696,	r0	;0x07fb8

.L1234:
	movx.a	6(r1),	0(r1)	;

	jmp .L1125	;mova	#31754,	r0	;0x07c0a



	.global __mspabi_addd
	.type __mspabi_addd, @function
__mspabi_addd:
	nop
	nop
	pushm.a	#3,	r10	;20-bit words

	suba	#58,	r1	;0x0003a

	mov	r8,	0(r1)	;
	mov	r9,	2(r1)	;
	mov	r10,	4(r1)	;
	mov	r11,	6(r1)	;

	mov	r12,	8(r1)	;
	mov	r13,	10(r1)	; 0x000a
	mov	r14,	12(r1)	; 0x000c
	mov	r15,	14(r1)	; 0x000e

	mova	r1,	r13	;
	adda	#16,	r13	;0x00010
	mova	r1,	r12	;

	calla	#__unpack_f		;

	mova	r1,	r13	;
	adda	#30,	r13	;0x0001e
	mova	r1,	r12	;
	adda	#8,	r12	;
	calla	#__unpack_f		;

	mova	r1,	r14	;
	adda	#44,	r14	;0x0002c
	mova	r1,	r13	;
	adda	#30,	r13	;0x0001e
	mova	r1,	r12	;
	adda	#16,	r12	;0x00010
	calla	#_fpadd_parts2		;0x07bca

	calla	#__pack_d		;0x06088

	adda	#58,	r1	;0x0003a

	popm.a	#3,	r10	;20-bit words

	reta			;



	.global __mspabi_subd
	.type __mspabi_subd, @function
__mspabi_subd:
	nop
	nop
	pushm.a	#3,	r10	;20-bit words

	suba	#58,	r1	;0x0003a

	mov	r8,	0(r1)	;
	mov	r9,	2(r1)	;
	mov	r10,	4(r1)	;
	mov	r11,	6(r1)	;

	mov	r12,	8(r1)	;
	mov	r13,	10(r1)	; 0x000a
	mov	r14,	12(r1)	; 0x000c
	mov	r15,	14(r1)	; 0x000e

	mova	r1,	r13	;
	adda	#16,	r13	;0x00010
	mova	r1,	r12	;

	calla	#__unpack_d		;

	mova	r1,	r13	;
	adda	#30,	r13	;0x0001e
	mova	r1,	r12	;
	adda	#8,	r12	;
	calla	#__unpack_d		;

	xor	#1,	32(r1)	;r3 As==01, 0x0020

	mova	r1,	r14	;
	adda	#44,	r14	;0x0002c
	mova	r1,	r13	;
	adda	#30,	r13	;0x0001e
	mova	r1,	r12	;
	adda	#16,	r12	;0x00010
	calla	#_fpadd_parts2		;0x07bca

	calla	#__pack_d		;0x06088

	adda	#58,	r1	;0x0003a

	popm.a	#3,	r10	;20-bit words

	reta			;



	.global __mspabi_mpyd
	.type __mspabi_mpyd, @function
__mspabi_mpyd:
	nop
	nop
	pushm.a	#4,	r10	;20-bit words

	suba	#102,	r1	;0x00066

	mov	r8,	44(r1)	; 0x002c
	mov	r9,	46(r1)	; 0x002e
	mov	r10,	48(r1)	; 0x0030
	mov	r11,	50(r1)	; 0x0032

	mov	r12,	52(r1)	; 0x0034
	mov	r13,	54(r1)	; 0x0036
	mov	r14,	56(r1)	; 0x0038
	mov	r15,	58(r1)	; 0x003a

	mova	r1,	r13	;
	adda	#60,	r13	;0x0003c
	mova	r1,	r12	;

	adda	#44,	r12	;0x0002c
	calla	#__unpack_d		;

	mova	r1,	r13	;
	adda	#74,	r13	;0x0004a
	mova	r1,	r12	;
	adda	#52,	r12	;0x00034
	calla	#__unpack_d		;

	mov	60(r1),	r13	;0x0003c

	mov.b	#1,	r12	;r3 As==01
	cmp	r13,	r12	;
	jnc	.L1274     	;abs 0x8320

.L1267:
	mov	62(r1),	r13	;0x0003e
	xor	76(r1),	r13	;0x0004c
	clr	r12		;
	sub	r13,	r12	;
	bis	r13,	r12	;

	rpt #15 { rrux.w	r12		;
	mov	r12,	62(r1)	; 0x003e

.L1269:
	mova	r1,	r12	;
	adda	#60,	r12	;0x0003c

.L1270:
	calla	#__pack_d		;0x06088

	adda	#102,	r1	;0x00066

	popm.a	#4,	r10	;20-bit words

	reta			;

.L1274:
	mov	74(r1),	r12	;0x0004a

	mov.b	#1,	r14	;r3 As==01
	cmp	r12,	r14	;
	jnc	.L1279     	;abs 0x834a

.L1276:
	mov	62(r1),	r13	;0x0003e
	xor	76(r1),	r13	;0x0004c
	clr	r12		;
	sub	r13,	r12	;
	bis	r13,	r12	;

	rpt #15 { rrux.w	r12		;
	mov	r12,	76(r1)	; 0x004c

.L1278:
	mova	r1,	r12	;
	adda	#74,	r12	;0x0004a
	jmp .L1270	;mova	#33556,	r0	;0x08314

.L1279:
	cmp	#4,	r13	;r2 As==10
	jnz	.L1282     	;abs 0x835a

	cmp	#2,	r12	;r3 As==10
	jnz	.L1267     	;abs 0x82f8

.L1281:
	mova	#82954,	r12	;0x1440a
	jmp .L1270	;mova	#33556,	r0	;0x08314

.L1282:
	cmp	#4,	r12	;r2 As==10
	jnz	.L1284     	;abs 0x8366

	cmp	#2,	r13	;r3 As==10
	jz	.L1281     	;abs 0x8352
	jmp .L1276	;mova	#33578,	r0	;0x0832a

.L1284:
	mov	76(r1),	r15	;0x0004c
	xor	62(r1),	r15	;0x0003e
	clr	r14		;
	sub	r15,	r14	;
	bis	r15,	r14	;
	rpt #15 { rrux.w	r14		;
	mov	r14,	32(r1)	; 0x0020

	cmp	#2,	r13	;r3 As==10
	jnz	.L1287     	;abs 0x8388

	mov	r14,	62(r1)	; 0x003e
	jmp .L1269	;mova	#33550,	r0	;0x0830e

.L1287:
	cmp	#2,	r12	;r3 As==10
	jnz	.L1289     	;abs 0x8396

	mov	32(r1),	76(r1)	;0x00020, 0x004c
	jmp .L1278	;mova	#33600,	r0	;0x08340

.L1289:
	mov	66(r1),	34(r1)	;0x00042, 0x0022
	mov	68(r1),	38(r1)	;0x00044, 0x0026
	mov	70(r1),	40(r1)	;0x00046, 0x0028
	mov	72(r1),	42(r1)	;0x00048, 0x002a

	mov	80(r1),	22(r1)	;0x00050, 0x0016
	mov	82(r1),	16(r1)	;0x00052, 0x0010
	mov	84(r1),	18(r1)	;0x00054, 0x0012
	mov	86(r1),	20(r1)	;0x00056, 0x0014

	mov	#64,	28(r1)	;#0x0040, 0x001c

	clr.b	r7		;
	mov	r7,	2(r1)	;
	mov	r7,	4(r1)	;
	mov	r7,	6(r1)	;

	mov	r7,	0(r1)	;
	mov	r7,	24(r1)	; 0x0018
	mov	r7,	26(r1)	; 0x001a
	mov	r7,	30(r1)	; 0x001e

	mov	r7,	8(r1)	;
	mov	r7,	10(r1)	; 0x000a
	mov	r7,	12(r1)	; 0x000c
	mov	r7,	14(r1)	; 0x000e

.L1295:
	bitx.w	#1,	34(r1)	;r3 As==01, 0x00022
	jz	.L1319    	;abs 0x8524

	mov	8(r1),	r12	;
	add	22(r1),	r12	;0x00016
	mov	r12,	36(r1)	; 0x0024
	mov.b	#1,	r9	;r3 As==01
	cmp	8(r1),	r12	;
	jnc	.L1297      	;abs 0x8418
	clr.b	r9		;

.L1297:
	mov	10(r1),	r13	;0x0000a
	add	16(r1),	r13	;0x00010
	mov.b	#1,	r12	;r3 As==01
	cmp	10(r1),	r13	;0x0000a
	jnc	.L1298      	;abs 0x842a
	clr.b	r12		;

.L1298:
	add	r13,	r9	;
	mov.b	#1,	r14	;r3 As==01
	cmp	r13,	r9	;
	jnc	.L1299      	;abs 0x8434
	clr.b	r14		;

.L1299:
	bis	r14,	r12	;
	mov	12(r1),	r13	;0x0000c
	add	18(r1),	r13	;0x00012
	mov.b	#1,	r10	;r3 As==01
	cmp	12(r1),	r13	;0x0000c
	jnc	.L1300      	;abs 0x8448
	clr.b	r10		;

.L1300:
	add	r13,	r12	;
	mov.b	#1,	r14	;r3 As==01
	cmp	r13,	r12	;
	jnc	.L1301      	;abs 0x8452
	clr.b	r14		;

.L1301:
	bis	r14,	r10	;
	mov	14(r1),	r15	;0x0000e
	add	20(r1),	r15	;0x00014
	add	r15,	r10	;
	mov	36(r1),	8(r1)	;0x00024

	mov	r9,	10(r1)	; 0x000a
	mov	r12,	12(r1)	; 0x000c
	mov	r10,	14(r1)	; 0x000e

	add	@r1,	r7	;

	mov.b	#1,	r8	;r3 As==01
	cmp	@r1,	r7	;
	jnc	.L1305      	;abs 0x847a
	clr.b	r8		;

.L1305:
	mov	24(r1),	r13	;0x00018
	add	2(r1),	r13	;
	mov.b	#1,	r11	;r3 As==01
	cmp	24(r1),	r13	;0x00018
	jnc	.L1306      	;abs 0x848c
	clr.b	r11		;

.L1306:
	add	r13,	r8	;
	mov.b	#1,	r14	;r3 As==01
	cmp	r13,	r8	;
	jnc	.L1307      	;abs 0x8496
	clr.b	r14		;

.L1307:
	bis	r14,	r11	;
	mov	26(r1),	r14	;0x0001a
	add	4(r1),	r14	;
	mov.b	#1,	r13	;r3 As==01
	cmp	26(r1),	r14	;0x0001a
	jnc	.L1308      	;abs 0x84aa
	clr.b	r13		;

.L1308:
	add	r14,	r11	;
	mov.b	#1,	r15	;r3 As==01
	cmp	r14,	r11	;
	jnc	.L1309      	;abs 0x84b4
	clr.b	r15		;

.L1309:
	bis	r15,	r13	;
	mov	30(r1),	r15	;0x0001e
	add	6(r1),	r15	;
	add	r15,	r13	;

	mov.b	#1,	r14	;r3 As==01
	cmp	20(r1),	r10	;0x00014
	jnc	.L1312     	;abs 0x84f0
	cmp	r10,	20(r1)	; 0x0014
	jnz	.L1311     	;abs 0x84ee
	cmp	18(r1),	r12	;0x00012
	jnc	.L1312     	;abs 0x84f0
	cmp	r12,	18(r1)	; 0x0012
	jnz	.L1311     	;abs 0x84ee
	cmp	16(r1),	r9	;0x00010
	jnc	.L1312     	;abs 0x84f0
	cmp	r9,	16(r1)	; 0x0010
	jnz	.L1311     	;abs 0x84ee
	cmp	22(r1),	36(r1)	;0x00016, 0x0024
	jnc	.L1312      	;abs 0x84f0

.L1311:
	clr.b	r14		;

.L1312:
	mov	r14,	r12	;

	add	r7,	r12	;
	mov.b	#1,	r10	;r3 As==01

	cmp	r14,	r12	;
	jnc	.L1315      	;abs 0x84fc
	clr.b	r10		;

.L1315:
	add	r8,	r10	;
	mov.b	#1,	r14	;r3 As==01
	cmp	r8,	r10	;
	jnc	.L1316      	;abs 0x8506
	clr.b	r14		;

.L1316:
	clr.b	r15		;
	add	r11,	r14	;
	mov.b	#1,	r9	;r3 As==01

	cmp	r11,	r14	;
	jnc	.L1318      	;abs 0x8512
	mov	r15,	r9	;

.L1318:
	bis	r9,	r15	;
	mov	r12,	r7	;
	mov	r10,	2(r1)	;
	mov	r14,	4(r1)	;
	add	r13,	r15	;
	mov	r15,	6(r1)	;

.L1319:
	mov	@r1,	r10	;
	rla	r10		;
	mov.b	#1,	r13	;r3 As==01
	cmp	@r1,	r10	;
	jnc	.L1320      	;abs 0x8530
	clr.b	r13		;

.L1320:
	mov	24(r1),	r14	;0x00018
	rla	r14		;
	mov.b	#1,	r12	;r3 As==01
	cmp	24(r1),	r14	;0x00018
	jnc	.L1321      	;abs 0x8540
	clr.b	r12		;

.L1321:
	add	r14,	r13	;
	mov.b	#1,	r15	;r3 As==01
	cmp	r14,	r13	;
	jnc	.L1322      	;abs 0x854a
	clr.b	r15		;

.L1322:
	bis	r15,	r12	;
	mov	26(r1),	r15	;0x0001a
	rla	r15		;
	mov.b	#1,	r14	;r3 As==01
	cmp	26(r1),	r15	;0x0001a
	jnc	.L1323      	;abs 0x855c
	clr.b	r14		;

.L1323:
	add	r15,	r12	;
	mov.b	#1,	r9	;r3 As==01
	cmp	r15,	r12	;
	jnc	.L1324      	;abs 0x8566
	clr.b	r9		;

.L1324:
	bis	r9,	r14	;
	mov	30(r1),	r15	;0x0001e
	rla	r15		;
	mov	r10,	0(r1)	;

	mov	r13,	24(r1)	; 0x0018
	mov	r12,	26(r1)	; 0x001a
	add	r15,	r14	;
	mov	r14,	30(r1)	; 0x001e

	cmp	#0,	20(r1)	;r3 As==00, 0x0014
	jge	.L1328      	;abs 0x858a

	bis	#1,	0(r1)	;r3 As==01

.L1328:
	mov	22(r1),	r10	;0x00016
	rla	r10		;
	mov.b	#1,	r13	;r3 As==01

	cmp	22(r1),	r10	;0x00016
	jnc	.L1330      	;abs 0x859a
	clr.b	r13		;

.L1330:
	mov	16(r1),	r14	;0x00010

	rla	r14		;
	mov.b	#1,	r12	;r3 As==01

	cmp	16(r1),	r14	;0x00010
	jnc	.L1333      	;abs 0x85aa
	clr.b	r12		;

.L1333:
	add	r14,	r13	;
	mov.b	#1,	r15	;r3 As==01
	cmp	r14,	r13	;
	jnc	.L1334      	;abs 0x85b4
	clr.b	r15		;

.L1334:
	bis	r15,	r12	;
	mov	18(r1),	r15	;0x00012
	rla	r15		;
	mov.b	#1,	r14	;r3 As==01
	cmp	18(r1),	r15	;0x00012
	jnc	.L1335      	;abs 0x85c6
	clr.b	r14		;

.L1335:
	add	r15,	r12	;
	mov.b	#1,	r9	;r3 As==01
	cmp	r15,	r12	;
	jnc	.L1336      	;abs 0x85d0
	clr.b	r9		;

.L1336:
	bis	r9,	r14	;
	mov	20(r1),	r15	;0x00014
	rla	r15		;
	mov	r10,	22(r1)	; 0x0016

	mov	r13,	16(r1)	; 0x0010
	mov	r12,	18(r1)	; 0x0012
	add	r15,	r14	;
	mov	r14,	20(r1)	; 0x0014

	mov	34(r1),	r8	;0x00022
	mov	38(r1),	r9	;0x00026
	mov	40(r1),	r10	;0x00028
	mov	42(r1),	r11	;0x0002a
	mov.b	#1,	r12	;r3 As==01
	calla	#__mspabi_srlll		;0x05de0

	mov	r12,	34(r1)	; 0x0022

	mov	r13,	38(r1)	; 0x0026
	mov	r14,	40(r1)	; 0x0028
	mov	r15,	42(r1)	; 0x002a

	add	#-1,	28(r1)	;r3 As==11, 0x001c

	cmp	#0,	28(r1)	;r3 As==00, 0x001c
	jnz	.L1295    	;abs 0x83fa

	mov	64(r1),	r12	;0x00040

	add	78(r1),	r12	;0x0004e

	add	#4,	r12	;r2 As==10
	mov	r12,	0(r1)	;

	mov	r12,	92(r1)	; 0x005c

	mov	32(r1),	90(r1)	;0x00020, 0x005a

	mov	28(r1),	r12	;0x0001c

.L1349:
	mov	#8191,	r13	;#0x1fff
	cmp	6(r1),	r13	;
	jnc	.L1373    	;abs 0x872a
	cmp	#0,	r12	;r3 As==00
	jz	.L1350      	;abs 0x8648
	mov	@r1,	92(r1)	; 0x005c

.L1350:
	mov	92(r1),	r11	;0x0005c

	clr.b	r12		;

	mov.b	#1,	r9	;r3 As==01
	mov	r12,	r8	;

.L1353:
	mov	#4095,	r13	;#0x0fff
	cmp	6(r1),	r13	;
	jnc	.L1381    	;abs 0x8784

	mov	r7,	r10	;
	add	r7,	r10	;
	mov	r9,	r13	;
	cmp	r7,	r10	;
	jnc	.L1355      	;abs 0x8668
	mov	r8,	r13	;

.L1355:
	mov	2(r1),	r12	;
	rla	r12		;
	mov.b	#1,	r14	;r3 As==01
	cmp	2(r1),	r12	;
	jnc	.L1356      	;abs 0x8678
	clr.b	r14		;

.L1356:
	add	r12,	r13	;
	mov	r9,	r15	;
	cmp	r12,	r13	;
	jnc	.L1357      	;abs 0x8682
	mov	r8,	r15	;

.L1357:
	bis	r15,	r14	;
	mov	4(r1),	r15	;
	rla	r15		;
	mov.b	#1,	r12	;r3 As==01
	cmp	4(r1),	r15	;
	jnc	.L1358      	;abs 0x8694
	clr.b	r12		;

.L1358:
	add	r15,	r14	;
	mov	r9,	r7	;

	cmp	r15,	r14	;
	jnc	.L1360      	;abs 0x869e
	mov	r8,	r7	;

.L1360:
	bis	r7,	r12	;
	mov	6(r1),	r15	;
	rla	r15		;
	mov	r10,	r7	;
	mov	r13,	2(r1)	;
	mov	r14,	4(r1)	;
	add	r15,	r12	;
	mov	r12,	6(r1)	;

	cmp	#0,	14(r1)	;r3 As==00, 0x000e
	jge	.L1363      	;abs 0x86be

	bis	#1,	r7	;r3 As==01

.L1363:
	mov	8(r1),	r14	;

	rla	r14		;
	mov	r14,	0(r1)	;
	mov	r9,	r13	;

	cmp	8(r1),	r14	;
	jnc	.L1366      	;abs 0x86d2
	mov	r8,	r13	;

.L1366:
	mov	10(r1),	r15	;0x0000a
	rla	r15		;
	mov.b	#1,	r14	;r3 As==01
	cmp	10(r1),	r15	;0x0000a
	jnc	.L1367      	;abs 0x86e2
	clr.b	r14		;

.L1367:
	add	r15,	r13	;
	mov	r9,	r12	;

	cmp	r15,	r13	;
	jnc	.L1369      	;abs 0x86ec
	mov	r8,	r12	;

.L1369:
	bis	r12,	r14	;
	mov	12(r1),	r15	;0x0000c
	rla	r15		;
	mov.b	#1,	r12	;r3 As==01
	cmp	12(r1),	r15	;0x0000c
	jnc	.L1370      	;abs 0x86fe
	clr.b	r12		;

.L1370:
	add	r15,	r14	;
	mov	r9,	r10	;
	cmp	r15,	r14	;
	jnc	.L1371      	;abs 0x8708
	mov	r8,	r10	;

.L1371:
	bis	r10,	r12	;
	mov	14(r1),	r15	;0x0000e
	rla	r15		;
	mov	@r1,	8(r1)	;

	mov	r13,	10(r1)	; 0x000a
	mov	r14,	12(r1)	; 0x000c
	add	r15,	r12	;
	mov	r12,	14(r1)	; 0x000e
	add	#-1,	r11	;r3 As==11
	mov	r9,	r12	;
	jmp .L1353	;mova	#34386,	r0	;0x08652

.L1373:
	bit	#1,	r7	;r3 As==01
	jz	.L1377     	;abs 0x8758

	mov	8(r1),	r8	;
	mov	10(r1),	r9	;0x0000a
	mov	12(r1),	r10	;0x0000c
	mov	14(r1),	r11	;0x0000e
	mov.b	#1,	r12	;r3 As==01
	calla	#__mspabi_srlll		;0x05de0

	mov	r12,	8(r1)	;
	mov	r13,	10(r1)	; 0x000a
	mov	r14,	12(r1)	; 0x000c
	bis	#-32768,r15	;#0x8000

	mov	r15,	14(r1)	; 0x000e

.L1377:
	mov	r7,	r8	;
	mov	2(r1),	r9	;
	mov	4(r1),	r10	;
	mov	6(r1),	r11	;
	mov.b	#1,	r12	;r3 As==01
	calla	#__mspabi_srlll		;0x05de0
	mov	r12,	r7	;

	mov	r13,	2(r1)	;

	mov	r14,	4(r1)	;
	mov	r15,	6(r1)	;

	inc	0(r1)		;
	mov.b	#1,	r12	;r3 As==01
	jmp .L1349	;mova	#34358,	r0	;0x08636

.L1381:
	cmp	#0,	r12	;r3 As==00
	jz	.L1382      	;abs 0x878c
	mov	r11,	92(r1)	; 0x005c

.L1382:
	mov	r7,	r15	;
	and.b	#255,	r15	;#0x00ff

	cmp.b	#-128,	r7	;#0xff80
	jnz	.L1392     	;abs 0x87f8

	mov	r7,	r14	;
	and	#256,	r14	;#0x0100

	bit	#256,	r7	;#0x0100
	jnz	.L1392     	;abs 0x87f8

	mov	8(r1),	r12	;
	bis	10(r1),	r12	;0x0000a
	bis	12(r1),	r12	;0x0000c
	bis	14(r1),	r12	;0x0000e
	cmp	#0,	r12	;r3 As==00
	jz	.L1392     	;abs 0x87f8

	add	r7,	r15	;
	mov.b	#1,	r13	;r3 As==01
	cmp	r7,	r15	;
	jnc	.L1388      	;abs 0x87c2
	mov	r14,	r13	;

.L1388:
	clr.b	r12		;
	add	2(r1),	r13	;
	mov.b	#1,	r14	;r3 As==01
	cmp	2(r1),	r13	;
	jnc	.L1389      	;abs 0x87d2
	mov	r12,	r14	;

.L1389:
	bis	r14,	r12	;
	clr.b	r14		;
	add	4(r1),	r12	;
	mov.b	#1,	r10	;r3 As==01
	cmp	4(r1),	r12	;
	jnc	.L1390      	;abs 0x87e4
	mov	r14,	r10	;

.L1390:
	bis	r10,	r14	;

	mov	r15,	r7	;
	and	#-256,	r7	;#0xff00
	mov	r13,	2(r1)	;
	mov	r12,	4(r1)	;
	add	r14,	6(r1)	;

.L1392:
	mov	r7,	94(r1)	; 0x005e
	mov	2(r1),	96(r1)	; 0x0060
	mov	4(r1),	98(r1)	; 0x0062
	mov	6(r1),	100(r1)	; 0x0064

	mov	#3,	88(r1)	; 0x0058

	mova	r1,	r12	;
	adda	#88,	r12	;0x00058
	jmp .L1270	;mova	#33556,	r0	;0x08314



	.global __eqdf2
	.type __eqdf2, @function
__eqdf2:
	nop
	nop
	pushm.a	#1,	r10	;20-bit words

	suba	#44,	r1	;0x0002c

	mov	r12,	0(r1)	;
	mov	r13,	2(r1)	;
	mov	r14,	4(r1)	;
	mov	r15,	6(r1)	;

	mov	52(r1),	8(r1)	;0x00034
	mov	54(r1),	10(r1)	;0x00036, 0x000a
	mov	56(r1),	12(r1)	;0x00038, 0x000c
	mov	58(r1),	14(r1)	;0x0003a, 0x000e

	mova	r1,	r13	;
	adda	#16,	r13	;0x00010
	mova	r1,	r12	;

	calla	#__unpack_d		;

	mova	r1,	r13	;
	adda	#30,	r13	;0x0001e
	mova	r1,	r12	;
	adda	#8,	r12	;
	calla	#__unpack_d		;

	mov.b	#1,	r12	;r3 As==01
	cmp	16(r1),	r12	;0x00010
	jc	.L1407     	;abs 0x888e

	cmp	30(r1),	r12	;0x0001e
	jc	.L1407     	;abs 0x888e

	mova	r1,	r13	;
	adda	#30,	r13	;0x0001e
	mova	r1,	r12	;
	adda	#16,	r12	;0x00010
	calla	#__fpcmp_parts_d		;0x064d0

.L1404:
	adda	#44,	r1	;0x0002c

	popm.a	#1,	r10	;20-bit words

	reta			;

.L1407:
	mov.b	#1,	r12	;r3 As==01
	jmp .L1404	;mova	#34950,	r0	;0x08886



	.global __gtdf2
	.type __gtdf2, @function
__gtdf2:
	nop
	nop
	pushm.a	#1,	r10	;20-bit words

	suba	#44,	r1	;0x0002c

	mov	r12,	0(r1)	;
	mov	r13,	2(r1)	;
	mov	r14,	4(r1)	;
	mov	r15,	6(r1)	;

	mov	52(r1),	8(r1)	;0x00034
	mov	54(r1),	10(r1)	;0x00036, 0x000a
	mov	56(r1),	12(r1)	;0x00038, 0x000c
	mov	58(r1),	14(r1)	;0x0003a, 0x000e

	mova	r1,	r13	;
	adda	#16,	r13	;0x00010
	mova	r1,	r12	;

	calla	#__unpack_d		;

	mova	r1,	r13	;
	adda	#30,	r13	;0x0001e
	mova	r1,	r12	;
	adda	#8,	r12	;
	calla	#__unpack_d		;

	mov.b	#1,	r12	;r3 As==01
	cmp	16(r1),	r12	;0x00010
	jc	.L1420     	;abs 0x8904

	cmp	30(r1),	r12	;0x0001e
	jc	.L1420     	;abs 0x8904

	mova	r1,	r13	;
	adda	#30,	r13	;0x0001e
	mova	r1,	r12	;
	adda	#16,	r12	;0x00010
	calla	#__fpcmp_parts_d		;0x064d0

.L1417:
	adda	#44,	r1	;0x0002c

	popm.a	#1,	r10	;20-bit words

	reta			;

.L1420:
	mov	#-1,	r12	;r3 As==11
	jmp .L1417	;mova	#35068,	r0	;0x088fc



	.global __ltdf2
	.type __ltdf2, @function
__ltdf2:
	nop
	nop
	pushm.a	#1,	r10	;20-bit words

	suba	#44,	r1	;0x0002c

	mov	r12,	0(r1)	;
	mov	r13,	2(r1)	;
	mov	r14,	4(r1)	;
	mov	r15,	6(r1)	;

	mov	52(r1),	8(r1)	;0x00034
	mov	54(r1),	10(r1)	;0x00036, 0x000a
	mov	56(r1),	12(r1)	;0x00038, 0x000c
	mov	58(r1),	14(r1)	;0x0003a, 0x000e

	mova	#__unpack_d,	r10	;0x06378
	mova	r1,	r13	;
	adda	#16,	r13	;0x00010
	mova	r1,	r12	;

	calla	#__unpack_f		;

	mova	r1,	r13	;
	adda	#30,	r13	;0x0001e
	mova	r1,	r12	;
	adda	#8,	r12	;
	calla	#__unpack_f		;

	mov.b	#1,	r12	;r3 As==01
	cmp	16(r1),	r12	;0x00010
	jc	.L1433     	;abs 0x897a

	cmp	30(r1),	r12	;0x0001e
	jc	.L1433     	;abs 0x897a

	mova	r1,	r13	;
	adda	#30,	r13	;0x0001e
	mova	r1,	r12	;
	adda	#16,	r12	;0x00010
	calla	#__fpcmp_parts_d		;0x064d0

.L1430:
	adda	#44,	r1	;0x0002c

	popm.a	#1,	r10	;20-bit words

	reta			;

.L1433:
	mov.b	#1,	r12	;r3 As==01
	jmp .L1430	;mova	#35186,	r0	;0x08972



	.global __mspabi_fltlid
	.type __mspabi_fltlid, @function
__mspabi_fltlid:
	nop
	nop
	pushm.a	#4,	r10	;20-bit words

	suba	#14,	r1	;0x0000e

	mov	r12,	r14	;
	mov	r13,	r15	;

	mov	#3,	0(r1)	;

	mov	r13,	r12	;

	rpt #15 { rrux.w	r12		;
	mov	r12,	2(r1)	;

	mov	r14,	r12	;
	bis	r13,	r12	;
	cmp	#0,	r12	;r3 As==00
	jnz	.L1445     	;abs 0x89b4

	mov	#2,	0(r1)	;r3 As==10

.L1441:
	mova	r1,	r12	;
	calla	#__pack_d		;0x06088

.L1442:
	adda	#14,	r1	;0x0000e

	popm.a	#4,	r10	;20-bit words

	reta			;

.L1445:
	cmp	#0,	r13	;r3 As==00
	jge	.L1452     	;abs 0x8a02

	mov	r14,	r13	;
	cmp	#0,	r14	;r3 As==00
	jnz	.L1447      	;abs 0x89c4
	cmp	#-32768,r15	;#0x8000
	jz	.L1454     	;abs 0x8a0a

.L1447:
	clr.b	r8		;
	clr.b	r9		;
	sub	r14,	r8	;
	subc	r15,	r9	;

.L1448:
	mov	r8,	r12	;
	mov	r9,	r13	;
	calla	#__clzsi2		;0x08abe

	mov	r12,	r7	;
	add	#29,	r7	;#0x001d

	clr.b	r10		;
	mov	r10,	r11	;
	mov	r7,	r12	;
	calla	#__mspabi_sllll		;0x05db4
	mov	r12,	6(r1)	;
	mov	r13,	8(r1)	;
	mov	r14,	10(r1)	; 0x000a
	mov	r15,	12(r1)	; 0x000c

	mov.b	#60,	r12	;#0x003c
	sub	r7,	r12	;
	mov	r12,	4(r1)	;
	jmp .L1441	;mova	#35238,	r0	;0x089a6

.L1452:
	mov	r14,	r8	;
	mov	r13,	r9	;

	jmp .L1448	;mova	#35276,	r0	;0x089cc

.L1454:
	mov	r14,	r12	;
	mov	#-15904,r15	;#0xc1e0
	jmp .L1442	;mova	#35244,	r0	;0x089ac



	.global __mspabi_fixdli
	.type __mspabi_fixdli, @function
__mspabi_fixdli:
	nop
	nop
	pushm.a	#4,	r10	;20-bit words

	suba	#22,	r1	;0x00016

	mov	r12,	0(r1)	;
	mov	r13,	2(r1)	;
	mov	r14,	4(r1)	;
	mov	r15,	6(r1)	;

	mova	r1,	r13	;
	adda	#8,	r13	;
	mova	r1,	r12	;

	calla	#__unpack_d		;0x06378

	mov	8(r1),	r12	;

	mov.b	#2,	r13	;r3 As==10
	cmp	r12,	r13	;
	jc	.L1477    	;abs 0x8aaa

	cmp	#4,	r12	;r2 As==10
	jnz	.L1467     	;abs 0x8a58

	cmp	#0,	10(r1)	;r3 As==00, 0x000a
	jz	.L1472     	;abs 0x8a70

.L1463:
	clr.b	r12		;
	mov	#-32768,r13	;#0x8000

.L1464:
	adda	#22,	r1	;0x00016

	popm.a	#4,	r10	;20-bit words

	reta			;

.L1467:
	mov	12(r1),	r12	;0x0000c

	cmp	#0,	r12	;r3 As==00
	jl	.L1477     	;abs 0x8aaa

	mov	10(r1),	r7	;0x0000a

	mov.b	#30,	r14	;#0x001e
	cmp	r12,	r14	;
	jge	.L1473     	;abs 0x8a7a

	cmp	#0,	r7	;r3 As==00
	jnz	.L1463     	;abs 0x8a4a

.L1472:
	mov	#-1,	r12	;r3 As==11
	mov	#32767,	r13	;#0x7fff
	jmp .L1464	;mova	#35408,	r0	;0x08a50

.L1473:
	mov	14(r1),	r8	;0x0000e
	mov	16(r1),	r9	;0x00010
	mov	18(r1),	r10	;0x00012
	mov	20(r1),	r11	;0x00014
	mov.b	#60,	r15	;#0x003c
	sub	r12,	r15	;
	mov	r15,	r12	;
	calla	#__mspabi_srlll		;0x05de0

	cmp	#0,	r7	;r3 As==00
	jz	.L1464     	;abs 0x8a50

	clr.b	r14		;
	clr.b	r15		;
	sub	r12,	r14	;
	subc	r13,	r15	;
	mov	r14,	r12	;

	mov	r15,	r13	;
	jmp .L1464	;mova	#35408,	r0	;0x08a50

.L1477:
	clr.b	r12		;
	clr.b	r13		;
	jmp .L1464	;mova	#35408,	r0	;0x08a50

.L1478:
	add	#-1,	r14	;r3 As==11
	rra	r13		;
	rrc	r12		;



	.global __mspabi_sral
	.type __mspabi_sral, @function
__mspabi_sral:
	nop
	nop
	cmp	#0,	r14	;r3 As==00
	jnz	.L1478      	;abs 0x8ab2
	reta			;



	.global __clzsi2
	.type __clzsi2, @function
__clzsi2:
	nop
	nop
	pushm.a	#2,	r9	;20-bit words

	mov.b	#255,	r14	;#0x00ff
	cmp	#0,	r13	;r3 As==00
	jnz	.L1485     	;abs 0x8af4
	cmp	r12,	r14	;
	jc	.L1487     	;abs 0x8b08
	mov.b	#8,	r14	;r2 As==11

.L1480:
	clr.b	r15		;

	mov.b	#32,	r8	;#0x0020
	clr.b	r9		;
	sub	r14,	r8	;
	subc	r15,	r9	;
	calla	#__mspabi_srll		;0x05dda

	push	r13		;
	push	r12		;
	popm.a	#1,	r12	;20-bit words

	mov	r8,	r13	;
	movx.b	83016(r12),r12	;0x14448
	sub	r12,	r13	;
	mov	r13,	r12	;
	popm.a	#2,	r9	;20-bit words

	reta			;

.L1485:
	cmp	r13,	r14	;
	jnc	.L1486     	;abs 0x8b00
	mov.b	#16,	r14	;#0x0010
	jmp .L1480	;mova	#35534,	r0	;0x08ace

.L1486:
	mov.b	#24,	r14	;#0x0018
	jmp .L1480	;mova	#35534,	r0	;0x08ace

.L1487:
	clr.b	r14		;
	jmp .L1480	;mova	#35534,	r0	;0x08ace



	.global __errno
	.type __errno, @function
__errno:
	nop
	nop
	mova	&11266,	r12	;0x02c02
	reta			;



	.global _exit
	.type _exit, @function
_exit:
	nop
	nop
	jmp _exit	;mova	#35604,	r0	;0x08b14



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
	jc	.L1506     	;abs 0x8b70

	mova	r8,	r11	;
	adda	r14,	r11	;

	cmpa	r11,	r12	;
	jc	.L1506     	;abs 0x8b70

	mova	r14,	r8	;

	xorx.a	#-1,	r8	;r3 As==11

	clr.b	r10		;

.L1496:
	adda	#1048575,r10	;0xfffff

	cmpa	r10,	r8	;
	jnz	.L1501     	;abs 0x8b46

.L1498:
	mova	r15,	r12	;
	popm.a	#1,	r8	;20-bit words

	popm.a	#1,	r10	;20-bit words

	reta			;

.L1501:
	mova	r13,	r12	;
	adda	r10,	r12	;
	adda	r15,	r12	;
	mova	r11,	r14	;
	adda	r10,	r14	;

	mov.b	@r14,	0(r12)	;
	jmp .L1496	;mova	#35638,	r0	;0x08b36

.L1503:
	mova	r8,	r10	;
	adda	r12,	r10	;

	mova	r15,	r14	;
	adda	r12,	r14	;
	mov.b	@r10,	0(r14)	;
	adda	#1,	r12	;

.L1505:
	cmpa	r12,	r13	;
	jnz	.L1503     	;abs 0x8b58
	jmp .L1498	;mova	#35646,	r0	;0x08b3e

.L1506:
	clr.b	r12		;

	jmp .L1505	;mova	#35688,	r0	;0x08b68



	.global memset
	.type memset, @function
memset:
	nop
	nop
	pushm.a	#1,	r10	;20-bit words

	adda	r12,	r14	;

	mova	r12,	r10	;
.L1510:
	cmpa	r14,	r10	;
	jnz	.L1513      	;abs 0x8b84

	popm.a	#1,	r10	;20-bit words

	reta			;

.L1513:
	adda	#1,	r10	;

	mov.b	r13,	-1(r10)	; 0xffff
	jmp .L1510	;mova	#35750,	r0	;0x08ba6