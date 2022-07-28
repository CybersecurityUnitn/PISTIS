


	.global _fpadd_parts
	.type _fpadd_parts, @function
_fpadd_parts:
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
	jc	.L12     	;abs 0x453a

	mov	@r7,	r13	;

	mov.b	#1,	r14	;r3 As==01

	cmp	r13,	r14	;
	jc	.L76    	;abs 0x477e

	cmp	#4,	r12	;r2 As==10
	jnz	.L15     	;abs 0x4544

	cmp	#4,	r13	;r2 As==10
	jnz	.L12     	;abs 0x453a

	cmp	2(r7),	2(r10)	;
	jz	.L12      	;abs 0x453a

	mova	#82944,	r10	;0x14400

.L12:
	mova	r10,	r12	;
	adda	#20,	r1	;0x00014

	popm.a	#4,	r10	;20-bit words

	reta			;

.L15:
	cmp	#4,	r13	;r2 As==10
	jz	.L76    	;abs 0x477e

	cmp	#2,	r13	;r3 As==10
	jnz	.L22     	;abs 0x456e

	cmp	#2,	r12	;r3 As==10
	jnz	.L12     	;abs 0x453a

	mov.b	#10,	r14	;#0x000a
	mova	r10,	r13	;
	mova	r8,	r12	;
	calla	#memcpy		;0x04e00

	mov	2(r10),	r10	;

	and	2(r7),	r10	;
	mov	r10,	2(r8)	;

.L21:
	mova	r8,	r10	;
	jmp .L12	;mova	#17722,	r0	;0x0453a

.L22:
	cmp	#2,	r12	;r3 As==10
	jz	.L76    	;abs 0x477e

	mov	4(r10),	r11	;

	mov	4(r7),	r9	;

	mov	6(r10),	4(r1)	;
	mov	8(r10),	6(r1)	;

	mov	6(r7),	8(r1)	;
	mov	8(r7),	10(r1)	; 0x000a

	mov	r11,	r12	;
	sub	r9,	r12	;

	cmp	#0,	r12	;r3 As==00
	jge	.L37    	;abs 0x4604

	mov	r9,	r12	;
	sub	r11,	r12	;

	mov.b	#31,	r15	;#0x001f
	cmp	r12,	r15	;
	jl	.L60    	;abs 0x46f0

	mov	r12,	r13	;
	clr	r14		;
	mov	r13,	12(r1)	; 0x000c
	mov	r14,	14(r1)	; 0x000e
	mov	4(r1),	r12	;

	mov	6(r1),	r13	;

	mov	12(r1),	r14	;0x0000c
	calla	#__mspabi_srll		;0x04bb4

	mov	r12,	16(r1)	; 0x0010
	mov	r13,	18(r1)	; 0x0012
	mov	#-1,	r12	;r3 As==11
	mov	#-1,	r13	;r3 As==11
	mov	12(r1),	r14	;0x0000c
	calla	#__mspabi_slll		;0x04ba6
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
	jmp .L44	;mova	#18022,	r0	;0x04666

.L37:
	mov.b	#31,	r13	;#0x001f
	cmp	r12,	r13	;
	jl	.L60    	;abs 0x46f0

	cmp	#0,	r12	;r3 As==00
	jz	.L44     	;abs 0x4666

	mov	r12,	r14	;
	clr	r15		;
	mov	r14,	12(r1)	; 0x000c
	mov	r15,	14(r1)	; 0x000e
	mov	8(r1),	r12	;

	mov	10(r1),	r13	;0x0000a
	mova	r11,	0(r1)	;
	calla	#__mspabi_srll		;0x04bb4

	mov	r12,	16(r1)	; 0x0010
	mov	r13,	r9	;
	mov	#-1,	r12	;r3 As==11
	mov	#-1,	r13	;r3 As==11
	mov	12(r1),	r14	;0x0000c
	calla	#__mspabi_slll		;0x04ba6
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
	jz	.L72    	;abs 0x4756

	cmp	#0,	r12	;r3 As==00
	jz	.L65    	;abs 0x470e

	mov	8(r1),	r12	;
	mov	10(r1),	r13	;0x0000a
	subx.w	4(r1),	r12	;
	subcx.w	6(r1),	r13	;

.L48:
	cmp	#0,	r13	;r3 As==00
	jl	.L67    	;abs 0x4726

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
	jnc	.L55     	;abs 0x46c0
	cmp	r10,	r14	;
	jnz	.L70    	;abs 0x4742
	mov	#-2,	r14	;#0xfffe
	cmp	r15,	r14	;
	jc	.L70    	;abs 0x4742

.L55:
	mov	#3,	0(r8)	;

	mov	6(r8),	r12	;
	mov	8(r8),	r13	;

	cmp	#0,	r13	;r3 As==00
	jge	.L21    	;abs 0x4568

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
	jmp .L21	;mova	#17768,	r0	;0x04568

.L60:
	cmp	r11,	r9	;
	jl	.L63     	;abs 0x4702
	mov	r9,	r11	;

	mov	#0,	4(r1)	;r3 As==00

	mov	#0,	6(r1)	;r3 As==00
	jmp .L44	;mova	#18022,	r0	;0x04666

.L63:
	mov	#0,	8(r1)	;r3 As==00

	mov	#0,	10(r1)	;r3 As==00, 0x000a
	jmp .L44	;mova	#18022,	r0	;0x04666

.L65:
	mov	4(r1),	r12	;
	mov	6(r1),	r13	;
	subx.w	8(r1),	r12	;
	subcx.w	10(r1),	r13	;0x0000a

	jmp .L48	;mova	#18056,	r0	;0x04688

.L67:
	mov	#1,	2(r8)	;r3 As==01

	mov	r11,	4(r8)	;

	clr.b	r14		;
	clr.b	r15		;
	sub	r12,	r14	;
	subc	r13,	r15	;
	mov	r14,	6(r8)	;
	mov	r15,	8(r8)	;
	jmp .L52	;mova	#18076,	r0	;0x0469c

.L70:
	rla	r12		;
	rlc	r13		;
	mov	r12,	6(r8)	;
	mov	r13,	8(r8)	;

	add	#-1,	4(r8)	;r3 As==11
	jmp .L52	;mova	#18076,	r0	;0x0469c

.L72:
	mov	r12,	2(r8)	;

	mov	r11,	4(r8)	;

	mov	4(r1),	r15	;
	addx.w	8(r1),	r15	;
	mov	r15,	6(r8)	;
	mov	6(r1),	r10	;

	addcx.w	10(r1),	r10	;0x0000a
	mov	r10,	8(r8)	;
	jmp .L55	;mova	#18112,	r0	;0x046c0

.L76:
	mova	r7,	r10	;

	jmp .L12	;mova	#17722,	r0	;0x0453a



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
	calla	#_fpadd_parts		;0x0450a

	calla	#__pack_f		;0x04bba

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
	jnc	.L104     	;abs 0x4840

.L97:
	mov	26(r1),	r13	;0x0001a
	xor	36(r1),	r13	;0x00024
	clr	r12		;
	sub	r13,	r12	;
	bis	r13,	r12	;

	rpt #15 { rrux.w	r12		;
	mov	r12,	26(r1)	; 0x001a

.L99:
	mova	r1,	r12	;
	adda	#24,	r12	;0x00018

.L100:
	calla	#__pack_f		;0x04bba

	adda	#54,	r1	;0x00036

	popm.a	#4,	r10	;20-bit words

	reta			;

.L104:
	mov	34(r1),	r12	;0x00022

	mov.b	#1,	r11	;r3 As==01
	cmp	r12,	r11	;
	jnc	.L109     	;abs 0x486a

.L106:
	mov	26(r1),	r13	;0x0001a
	xor	36(r1),	r13	;0x00024
	clr	r12		;
	sub	r13,	r12	;
	bis	r13,	r12	;

	rpt #15 { rrux.w	r12		;
	mov	r12,	36(r1)	; 0x0024

.L108:
	mova	r1,	r12	;
	adda	#34,	r12	;0x00022
	jmp .L100	;mova	#18484,	r0	;0x04834

.L109:
	cmp	#4,	r13	;r2 As==10
	jnz	.L112     	;abs 0x487a

	cmp	#2,	r12	;r3 As==10
	jnz	.L97     	;abs 0x4818

.L111:
	mova	#82944,	r12	;0x14400
	jmp .L100	;mova	#18484,	r0	;0x04834

.L112:
	cmp	#4,	r12	;r2 As==10
	jnz	.L114     	;abs 0x4886

	cmp	#2,	r13	;r3 As==10
	jz	.L111     	;abs 0x4872
	jmp .L106	;mova	#18506,	r0	;0x0484a

.L114:
	mov	36(r1),	r14	;0x00024
	xor	26(r1),	r14	;0x0001a
	clr	r15		;
	sub	r14,	r15	;
	bis	r14,	r15	;
	rpt #15 { rrux.w	r15		;
	mov	r15,	10(r1)	; 0x000a

	cmp	#2,	r13	;r3 As==10
	jnz	.L117     	;abs 0x48a8

	mov	r15,	26(r1)	; 0x001a
	jmp .L99	;mova	#18478,	r0	;0x0482e

.L117:
	cmp	#2,	r12	;r3 As==10
	jnz	.L119     	;abs 0x48b6

	mov	10(r1),	36(r1)	;0x0000a, 0x0024
	jmp .L108	;mova	#18528,	r0	;0x04860

.L119:
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

.L125:
	mov	6(r1),	r10	;
	and.b	#1,	r10	;r3 As==01

	cmp	#0,	r10	;r3 As==00
	jz	.L134     	;abs 0x492a

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
	jnc	.L132     	;abs 0x491e
	mov	2(r1),	r7	;
	cmp	r9,	r7	;
	jnz	.L131      	;abs 0x491a
	cmp	@r1,	r8	;
	jnc	.L132      	;abs 0x491e

.L131:
	clr.b	r11		;
	mov	r11,	r10	;

.L132:
	mov	12(r1),	r12	;0x0000c

	add	r11,	r12	;
	mov	14(r1),	r13	;0x0000e
	addc	r10,	r13	;

.L134:
	mov	r14,	r10	;
	mov	r15,	r11	;
	add	r14,	r10	;
	addc	r15,	r11	;
	mov	r10,	r14	;

	mov	r11,	r15	;

	mov	2(r1),	r10	;
	cmp	#0,	r10	;r3 As==00
	jge	.L138      	;abs 0x4944

	mov	r14,	r7	;
	bis	#1,	r7	;r3 As==01
	mov	r7,	r14	;

.L138:
	addx.w	@r1,	0(r1)	;
	rlcx.w	2(r1)		;

	clrc			
	rrcx.w	8(r1)		;
	rrcx.w	6(r1)		;

	add	#-1,	4(r1)	;r3 As==11

	cmp	#0,	4(r1)	;r3 As==00
	jnz	.L125    	;abs 0x48e0

	mov	28(r1),	r10	;0x0001c
	add	38(r1),	r10	;0x00026

	incd	r10		;

	mov	r10,	48(r1)	; 0x0030

	mov	10(r1),	46(r1)	;0x0000a, 0x002e

	mov	4(r1),	r14	;

	mov.b	#1,	r7	;r3 As==01

.L148:
	cmp	#0,	r13	;r3 As==00
	jl	.L159     	;abs 0x49c8
	cmp	#0,	r14	;r3 As==00
	jz	.L149      	;abs 0x4990
	mov	r10,	48(r1)	; 0x0030

.L149:
	mov	48(r1),	r14	;0x00030

	clr.b	r15		;

.L151:
	mov	#16383,	r11	;#0x3fff
	cmp	r13,	r11	;
	jnc	.L164     	;abs 0x49f0

	mov	r12,	r10	;
	mov	r13,	r11	;
	add	r12,	r10	;
	addc	r13,	r11	;
	mov	r10,	r12	;

	mov	r11,	r13	;

	cmp	#0,	r9	;r3 As==00
	jge	.L156      	;abs 0x49b4

	mov	r12,	r7	;
	bis	#1,	r7	;r3 As==01
	mov	r7,	r12	;

.L156:
	mov	r8,	r10	;
	mov	r9,	r11	;
	add	r8,	r10	;
	addc	r9,	r11	;
	mov	r10,	r8	;

	mov	r11,	r9	;

	add	#-1,	r14	;r3 As==11
	mov.b	#1,	r15	;r3 As==01
	jmp .L151	;mova	#18838,	r0	;0x04996

.L159:
	mov	r12,	r14	;
	and.b	#1,	r14	;r3 As==01

	cmp	#0,	r14	;r3 As==00
	jz	.L163     	;abs 0x49e2

	mov	r8,	r14	;
	mov	r9,	r15	;
	clrc			
	rrc	r15		;
	rrc	r14		;

	mov	r14,	r8	;
	mov	r15,	r9	;
	bis	#-32768,r9	;#0x8000

.L163:
	clrc			
	rrc	r13		;
	rrc	r12		;
	inc	r10		;
	mov	r7,	r14	;
	jmp .L148	;mova	#18820,	r0	;0x04984

.L164:
	cmp	#0,	r15	;r3 As==00
	jz	.L165      	;abs 0x49f8
	mov	r14,	48(r1)	; 0x0030

.L165:
	mov	r12,	r14	;
	and.b	#127,	r14	;#0x007f

	cmp	#64,	r14	;#0x0040
	jnz	.L172     	;abs 0x4a28

	mov	r12,	r14	;
	and.b	#128,	r14	;#0x0080

	cmp	#0,	r14	;r3 As==00
	jnz	.L172     	;abs 0x4a28

	mov	r8,	r14	;
	bis	r9,	r14	;
	cmp	#0,	r14	;r3 As==00
	jz	.L172     	;abs 0x4a28

	mov	r12,	r15	;
	add	#64,	r15	;#0x0040
	mov	r13,	r14	;
	adc	r14		;

	mov	r15,	r12	;
	and	#-128,	r12	;#0xff80
	mov	r14,	r13	;

.L172:
	mov	r12,	50(r1)	; 0x0032
	mov	r13,	52(r1)	; 0x0034

	mov	#3,	44(r1)	; 0x002c

	mova	r1,	r12	;

	adda	#44,	r12	;0x0002c
	jmp .L100	;mova	#18484,	r0	;0x04834



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
	jnc	.L189     	;abs 0x4a92

.L184:
	mova	r1,	r12	;
	adda	#14,	r12	;0x0000e

.L185:
	calla	#__pack_f		;0x04bba

	adda	#34,	r1	;0x00022

	popm.a	#4,	r10	;20-bit words

	reta			;

.L189:
	mov	24(r1),	r12	;0x00018

	mov.b	#1,	r8	;r3 As==01
	cmp	r12,	r8	;
	jc	.L234    	;abs 0x4b96

	xor	26(r1),	16(r1)	;0x0001a, 0x0010

	cmp	#4,	r13	;r2 As==10
	jz	.L194      	;abs 0x4aaa

	cmp	#2,	r13	;r3 As==10
	jnz	.L196     	;abs 0x4ab6

.L194:
	cmp	r12,	r13	;
	jnz	.L184     	;abs 0x4a80

	mova	#82944,	r12	;0x14400
	jmp .L185	;mova	#19078,	r0	;0x04a86

.L196:
	cmp	#4,	r12	;r2 As==10
	jnz	.L200     	;abs 0x4aca

	mov	#0,	20(r1)	;r3 As==00, 0x0014
	mov	#0,	22(r1)	;r3 As==00, 0x0016

	mov	#0,	18(r1)	;r3 As==00, 0x0012

	jmp .L184	;mova	#19072,	r0	;0x04a80

.L200:
	cmp	#2,	r12	;r3 As==10
	jnz	.L203     	;abs 0x4ad6

	mov	#4,	14(r1)	;r2 As==10, 0x000e

	jmp .L184	;mova	#19072,	r0	;0x04a80

.L203:
	mov	18(r1),	r14	;0x00012
	sub	28(r1),	r14	;0x0001c

	mov	r14,	18(r1)	; 0x0012

	mov	20(r1),	r12	;0x00014
	mov	22(r1),	r13	;0x00016

	mov	30(r1),	r10	;0x0001e
	mov	32(r1),	r11	;0x00020

	cmp	r11,	r13	;
	jnc	.L208     	;abs 0x4afe
	cmp	r13,	r11	;
	jnz	.L211     	;abs 0x4b10
	cmp	r10,	r12	;
	jc	.L211     	;abs 0x4b10

.L208:
	mov	r12,	r7	;
	mov	r13,	r8	;
	add	r12,	r7	;
	addc	r13,	r8	;
	mov	r7,	r12	;

	mov	r8,	r13	;

	add	#-1,	r14	;r3 As==11
	mov	r14,	18(r1)	; 0x0012

.L211:
	mov.b	#31,	r9	;#0x001f

	clr.b	r14		;
	mov	r14,	r15	;

	mov	#0,	0(r1)	;r3 As==00
	mov	#16384,	2(r1)	;#0x4000

	mov	r11,	4(r1)	;

.L215:
	cmp	r11,	r13	;
	jnc	.L219     	;abs 0x4b46
	cmp	r13,	4(r1)	;
	jnz	.L216      	;abs 0x4b34
	cmp	r10,	r12	;
	jnc	.L219     	;abs 0x4b46

.L216:
	mov	r14,	r7	;
	bis	@r1,	r7	;
	mov	r15,	r8	;
	bis	2(r1),	r8	;
	mov	r7,	r14	;

	mov	r8,	r15	;

	sub	r10,	r12	;
	subc	r11,	r13	;

.L219:
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
	jnz	.L215     	;abs 0x4b26

	mov	r14,	r10	;

	and.b	#127,	r10	;#0x007f

	cmp	#64,	r10	;#0x0040
	jnz	.L233     	;abs 0x4b8a

	mov	r14,	r10	;
	and.b	#128,	r10	;#0x0080

	cmp	#0,	r10	;r3 As==00
	jnz	.L233     	;abs 0x4b8a

	bis	r8,	r12	;

	cmp	#0,	r12	;r3 As==00
	jz	.L233     	;abs 0x4b8a

	add	#64,	r14	;#0x0040

	adc	r15		;

	and	#-128,	r14	;#0xff80

.L233:
	mov	r14,	20(r1)	; 0x0014
	mov	r15,	22(r1)	; 0x0016
	jmp .L184	;mova	#19072,	r0	;0x04a80

.L234:
	mova	r1,	r12	;
	adda	#24,	r12	;0x00018
	jmp .L185	;mova	#19078,	r0	;0x04a86

.L235:
	add	#-1,	r14	;r3 As==11
	rla	r12		;
	rlc	r13		;



	.global __mspabi_slll
	.type __mspabi_slll, @function
__mspabi_slll:
	nop
	nop
	cmp	#0,	r14	;r3 As==00
	jnz	.L235      	;abs 0x4ba0
	reta			;

.L236:
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
	jnz	.L236     	;abs 0x4bac
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
	jnc	.L252     	;abs 0x4c18

	mov	r8,	r12	;

	mov	r9,	r13	;
	mov.b	#7,	r14	;
	calla	#__mspabi_srll		;0x04bb4

	and.b	#63,	r13	;#0x003f

	mov	r12,	r8	;
	mov	r13,	r9	;
	bis	#64,	r9	;#0x0040

	mov.b	#255,	r10	;#0x00ff

.L247:
	mov	r8,	r12	;
	mov	r9,	r13	;
	mov.b	#16,	r14	;#0x0010
	calla	#__mspabi_srll		;0x04bb4
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

.L252:
	cmp	#4,	r13	;r2 As==10
	jz	.L296    	;abs 0x4d1a

	cmp	#2,	r13	;r3 As==10
	jz	.L293    	;abs 0x4d10

	mov	r8,	r10	;
	bis	r9,	r10	;
	cmp	#0,	r10	;r3 As==00
	jz	.L247     	;abs 0x4bf0

	mov	4(r12),	r10	;

	cmp	#-126,	r10	;#0xff82
	jge	.L277    	;abs 0x4cc6

	mov	#-126,	r12	;#0xff82
	sub	r10,	r12	;

	mov.b	#25,	r13	;#0x0019
	cmp	r12,	r13	;
	jl	.L273    	;abs 0x4cba

	mov	r12,	r10	;
	clr	r11		;
	mov	r8,	r12	;

	mov	r9,	r13	;
	mov	r10,	r14	;
	mova	r11,	0(r1)	;
	calla	#__mspabi_srll		;0x04bb4
	mov	r12,	4(r1)	;
	mov	r13,	6(r1)	;

	mov	#-1,	r12	;r3 As==11
	mov	#-1,	r13	;r3 As==11
	mov	r10,	r14	;
	calla	#__mspabi_slll		;0x04ba6
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
	jnz	.L275     	;abs 0x4cbe

	mov	r12,	r14	;
	and.b	#128,	r14	;#0x0080

	cmp	#0,	r14	;r3 As==00
	jz	.L270      	;abs 0x4c9e

	add	#64,	r12	;#0x0040

.L269:
	adc	r13		;

.L270:
	mov.b	#1,	r10	;r3 As==01
	mov	#16383,	r14	;#0x3fff
	cmp	r13,	r14	;
	jnc	.L271      	;abs 0x4caa
	clr.b	r10		;

.L271:
	mov.b	#7,	r14	;
	calla	#__mspabi_srll		;0x04bb4
	mov	r12,	r8	;
	mov	r13,	r9	;

	jmp .L247	;mova	#19440,	r0	;0x04bf0

.L273:
	clr.b	r12		;

	clr.b	r13		;

.L275:
	add	#63,	r12	;#0x003f

	jmp .L269	;mova	#19612,	r0	;0x04c9c

.L277:
	mov.b	#127,	r12	;#0x007f

	cmp	r10,	r12	;
	jl	.L296     	;abs 0x4d1a

	mov	r8,	r12	;
	and.b	#127,	r12	;#0x007f

	cmp	#64,	r12	;#0x0040
	jnz	.L288     	;abs 0x4cfa

	mov	r8,	r12	;
	and.b	#128,	r12	;#0x0080

	cmp	#0,	r12	;r3 As==00
	jz	.L285      	;abs 0x4cea

	add	#64,	r8	;#0x0040

.L284:
	adc	r9		;

.L285:
	cmp	#0,	r9	;r3 As==00
	jl	.L290     	;abs 0x4d02

	add	#127,	r10	;#0x007f

.L287:
	mov	r8,	r12	;
	mov	r9,	r13	;
	jmp .L271	;mova	#19626,	r0	;0x04caa

.L288:
	add	#63,	r8	;#0x003f

	jmp .L284	;mova	#19688,	r0	;0x04ce8

.L290:
	clrc			
	rrc	r9		;
	rrc	r8		;

	add	#128,	r10	;#0x0080

	jmp .L287	;mova	#19698,	r0	;0x04cf2

.L293:
	clr.b	r10		;

.L294:
	clr.b	r8		;

	clr.b	r9		;
	jmp .L247	;mova	#19440,	r0	;0x04bf0

.L296:
	mov.b	#255,	r10	;#0x00ff
	jmp .L294	;mova	#19730,	r0	;0x04d12



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
	jnz	.L321     	;abs 0x4d98

	mov	r12,	r14	;
	bis	r13,	r14	;
	cmp	#0,	r14	;r3 As==00
	jnz	.L311     	;abs 0x4d5e

	mov	#2,	0(r10)	;r3 As==10

.L309:
	popm.a	#3,	r10	;20-bit words

	reta			;

.L311:
	mov.b	#7,	r14	;
	calla	#__mspabi_slll		;0x04ba6

	mov	#3,	0(r10)	;

	mov	#-127,	r14	;#0xff81

.L314:
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
	jc	.L314     	;abs 0x4d70
	mov	r15,	4(r10)	;

	mov	r8,	6(r10)	;

.L319:
	mov	r13,	8(r10)	;

	jmp .L309	;mova	#19802,	r0	;0x04d5a

.L321:
	cmp	#255,	r11	;#0x00ff
	jnz	.L329     	;abs 0x4dde

	mov	r12,	r14	;
	bis	r13,	r14	;
	cmp	#0,	r14	;r3 As==00
	jnz	.L324     	;abs 0x4dae

	mov	#4,	0(r10)	;r2 As==10
	jmp .L309	;mova	#19802,	r0	;0x04d5a

.L324:
	mov	r15,	r14	;
	and.b	#64,	r14	;#0x0040
	bit	#64,	r15	;#0x0040
	jz	.L328     	;abs 0x4dd6

	mov	#1,	0(r10)	;r3 As==01

.L326:
	mov.b	#7,	r14	;
	calla	#__mspabi_slll		;0x04ba6

	and	#-128,	r12	;#0xff80
	mov	r12,	6(r10)	;
	and	#-8193,	r13	;#0xdfff
	jmp .L319	;mova	#19856,	r0	;0x04d90

.L328:
	mov	r14,	0(r10)	;
	jmp .L326	;mova	#19902,	r0	;0x04dbe

.L329:
	add	#-127,	r11	;#0xff81

	mov	r11,	4(r10)	;

	mov	#3,	0(r10)	;

	mov.b	#7,	r14	;
	calla	#__mspabi_slll		;0x04ba6

	mov	r12,	6(r10)	;
	bis	#16384,	r13	;#0x4000
	jmp .L319	;mova	#19856,	r0	;0x04d90



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

.L337:
	cmpa	r12,	r15	;
	jnz	.L342     	;abs 0x4e16

	mova	r8,	r12	;

	popm.a	#1,	r8	;20-bit words

	popm.a	#1,	r10	;20-bit words

	reta			;

.L342:
	mova	r8,	r14	;
	adda	r12,	r14	;

	mova	r13,	r10	;
	adda	r12,	r10	;

	mov.b	@r10,	0(r14)	;
	adda	#1,	r12	;

	jmp .L337	;mova	#19978,	r0	;0x04e0a



	.global _exit
	.type _exit, @function
_exit:
	nop
	nop
	jmp _exit	;mova	#20010,	r0	;0x04e2a
