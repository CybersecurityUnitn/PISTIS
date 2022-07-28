


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
	jc	.L12     	;abs 0x4982

	mov	@r7,	r13	;

	mov.b	#1,	r14	;r3 As==01

	cmp	r13,	r14	;
	jc	.L76    	;abs 0x4bc6

	cmp	#4,	r12	;r2 As==10
	jnz	.L15     	;abs 0x498c

	cmp	#4,	r13	;r2 As==10
	jnz	.L12     	;abs 0x4982

	cmp	2(r7),	2(r10)	;
	jz	.L12      	;abs 0x4982

	mova	#83146,	r10	;0x144ca

.L12:
	mova	r10,	r12	;
	adda	#20,	r1	;0x00014

	popm.a	#4,	r10	;20-bit words

	reta			;

.L15:
	cmp	#4,	r13	;r2 As==10
	jz	.L76    	;abs 0x4bc6

	cmp	#2,	r13	;r3 As==10
	jnz	.L22     	;abs 0x49b6

	cmp	#2,	r12	;r3 As==10
	jnz	.L12     	;abs 0x4982

	mov.b	#10,	r14	;#0x000a
	mova	r10,	r13	;
	mova	r8,	r12	;
	calla	#memcpy		;0x051ca

	mov	2(r10),	r10	;

	and	2(r7),	r10	;
	mov	r10,	2(r8)	;

.L21:
	mova	r8,	r10	;
	jmp .L12	;mova	#18818,	r0	;0x04982

.L22:
	cmp	#2,	r12	;r3 As==10
	jz	.L76    	;abs 0x4bc6

	mov	4(r10),	r11	;

	mov	4(r7),	r9	;

	mov	6(r10),	4(r1)	;
	mov	8(r10),	6(r1)	;

	mov	6(r7),	8(r1)	;
	mov	8(r7),	10(r1)	; 0x000a

	mov	r11,	r12	;
	sub	r9,	r12	;

	cmp	#0,	r12	;r3 As==00
	jge	.L37    	;abs 0x4a4c

	mov	r9,	r12	;
	sub	r11,	r12	;

	mov.b	#31,	r15	;#0x001f
	cmp	r12,	r15	;
	jl	.L60    	;abs 0x4b38

	mov	r12,	r13	;
	clr	r14		;
	mov	r13,	12(r1)	; 0x000c
	mov	r14,	14(r1)	; 0x000e
	mov	4(r1),	r12	;

	mov	6(r1),	r13	;

	mov	12(r1),	r14	;0x0000c
	calla	#__mspabi_srll		;0x04f2e

	mov	r12,	16(r1)	; 0x0010
	mov	r13,	18(r1)	; 0x0012
	mov	#-1,	r12	;r3 As==11
	mov	#-1,	r13	;r3 As==11
	mov	12(r1),	r14	;0x0000c
	calla	#__mspabi_slll		;0x04f20
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
	jmp .L44	;mova	#19118,	r0	;0x04aae

.L37:
	mov.b	#31,	r13	;#0x001f
	cmp	r12,	r13	;
	jl	.L60    	;abs 0x4b38

	cmp	#0,	r12	;r3 As==00
	jz	.L44     	;abs 0x4aae

	mov	r12,	r14	;
	clr	r15		;
	mov	r14,	12(r1)	; 0x000c
	mov	r15,	14(r1)	; 0x000e
	mov	8(r1),	r12	;

	mov	10(r1),	r13	;0x0000a
	mova	r11,	0(r1)	;
	calla	#__mspabi_srll		;0x04f2e

	mov	r12,	16(r1)	; 0x0010
	mov	r13,	r9	;
	mov	#-1,	r12	;r3 As==11
	mov	#-1,	r13	;r3 As==11
	mov	12(r1),	r14	;0x0000c
	calla	#__mspabi_slll		;0x04f20
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
	jz	.L72    	;abs 0x4b9e

	cmp	#0,	r12	;r3 As==00
	jz	.L65    	;abs 0x4b56

	mov	8(r1),	r12	;
	mov	10(r1),	r13	;0x0000a
	subx.w	4(r1),	r12	;
	subcx.w	6(r1),	r13	;

.L48:
	cmp	#0,	r13	;r3 As==00
	jl	.L67    	;abs 0x4b6e

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
	jnc	.L55     	;abs 0x4b08
	cmp	r10,	r14	;
	jnz	.L70    	;abs 0x4b8a
	mov	#-2,	r14	;#0xfffe
	cmp	r15,	r14	;
	jc	.L70    	;abs 0x4b8a

.L55:
	mov	#3,	0(r8)	;

	mov	6(r8),	r12	;
	mov	8(r8),	r13	;

	cmp	#0,	r13	;r3 As==00
	jge	.L21    	;abs 0x49b0

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
	jmp .L21	;mova	#18864,	r0	;0x049b0

.L60:
	cmp	r11,	r9	;
	jl	.L63     	;abs 0x4b4a
	mov	r9,	r11	;

	mov	#0,	4(r1)	;r3 As==00

	mov	#0,	6(r1)	;r3 As==00
	jmp .L44	;mova	#19118,	r0	;0x04aae

.L63:
	mov	#0,	8(r1)	;r3 As==00

	mov	#0,	10(r1)	;r3 As==00, 0x000a
	jmp .L44	;mova	#19118,	r0	;0x04aae

.L65:
	mov	4(r1),	r12	;
	mov	6(r1),	r13	;
	subx.w	8(r1),	r12	;
	subcx.w	10(r1),	r13	;0x0000a

	jmp .L48	;mova	#19152,	r0	;0x04ad0

.L67:
	mov	#1,	2(r8)	;r3 As==01

	mov	r11,	4(r8)	;

	clr.b	r14		;
	clr.b	r15		;
	sub	r12,	r14	;
	subc	r13,	r15	;
	mov	r14,	6(r8)	;
	mov	r15,	8(r8)	;
	jmp .L52	;mova	#19172,	r0	;0x04ae4

.L70:
	rla	r12		;
	rlc	r13		;
	mov	r12,	6(r8)	;
	mov	r13,	8(r8)	;

	add	#-1,	4(r8)	;r3 As==11
	jmp .L52	;mova	#19172,	r0	;0x04ae4

.L72:
	mov	r12,	2(r8)	;

	mov	r11,	4(r8)	;

	mov	4(r1),	r15	;
	addx.w	8(r1),	r15	;
	mov	r15,	6(r8)	;
	mov	6(r1),	r10	;

	addcx.w	10(r1),	r10	;0x0000a
	mov	r10,	8(r8)	;
	jmp .L55	;mova	#19208,	r0	;0x04b08

.L76:
	mova	r7,	r10	;

	jmp .L12	;mova	#18818,	r0	;0x04982



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
	calla	#_fpadd_parts		;0x04952

	calla	#__pack_f		;0x04f84

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
	jnc	.L104     	;abs 0x4c88

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
	calla	#__pack_f		;0x04f84

	adda	#54,	r1	;0x00036

	popm.a	#4,	r10	;20-bit words

	reta			;

.L104:
	mov	34(r1),	r12	;0x00022

	mov.b	#1,	r11	;r3 As==01
	cmp	r12,	r11	;
	jnc	.L109     	;abs 0x4cb2

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
	jmp .L100	;mova	#19580,	r0	;0x04c7c

.L109:
	cmp	#4,	r13	;r2 As==10
	jnz	.L112     	;abs 0x4cc2

	cmp	#2,	r12	;r3 As==10
	jnz	.L97     	;abs 0x4c60

.L111:
	mova	#83146,	r12	;0x144ca
	jmp .L100	;mova	#19580,	r0	;0x04c7c

.L112:
	cmp	#4,	r12	;r2 As==10
	jnz	.L114     	;abs 0x4cce

	cmp	#2,	r13	;r3 As==10
	jz	.L111     	;abs 0x4cba
	jmp .L106	;mova	#19602,	r0	;0x04c92

.L114:
	mov	36(r1),	r14	;0x00024
	xor	26(r1),	r14	;0x0001a
	clr	r15		;
	sub	r14,	r15	;
	bis	r14,	r15	;
	rpt #15 { rrux.w	r15		;
	mov	r15,	10(r1)	; 0x000a

	cmp	#2,	r13	;r3 As==10
	jnz	.L117     	;abs 0x4cf0

	mov	r15,	26(r1)	; 0x001a
	jmp .L99	;mova	#19574,	r0	;0x04c76

.L117:
	cmp	#2,	r12	;r3 As==10
	jnz	.L119     	;abs 0x4cfe

	mov	10(r1),	36(r1)	;0x0000a, 0x0024
	jmp .L108	;mova	#19624,	r0	;0x04ca8

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
	jz	.L134     	;abs 0x4d72

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
	jnc	.L132     	;abs 0x4d66
	mov	2(r1),	r7	;
	cmp	r9,	r7	;
	jnz	.L131      	;abs 0x4d62
	cmp	@r1,	r8	;
	jnc	.L132      	;abs 0x4d66

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
	jge	.L138      	;abs 0x4d8c

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
	jnz	.L125    	;abs 0x4d28

	mov	28(r1),	r10	;0x0001c
	add	38(r1),	r10	;0x00026

	incd	r10		;

	mov	r10,	48(r1)	; 0x0030

	mov	10(r1),	46(r1)	;0x0000a, 0x002e

	mov	4(r1),	r14	;

	mov.b	#1,	r7	;r3 As==01

.L148:
	cmp	#0,	r13	;r3 As==00
	jl	.L159     	;abs 0x4e10
	cmp	#0,	r14	;r3 As==00
	jz	.L149      	;abs 0x4dd8
	mov	r10,	48(r1)	; 0x0030

.L149:
	mov	48(r1),	r14	;0x00030

	clr.b	r15		;

.L151:
	mov	#16383,	r11	;#0x3fff
	cmp	r13,	r11	;
	jnc	.L164     	;abs 0x4e38

	mov	r12,	r10	;
	mov	r13,	r11	;
	add	r12,	r10	;
	addc	r13,	r11	;
	mov	r10,	r12	;

	mov	r11,	r13	;

	cmp	#0,	r9	;r3 As==00
	jge	.L156      	;abs 0x4dfc

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
	jmp .L151	;mova	#19934,	r0	;0x04dde

.L159:
	mov	r12,	r14	;
	and.b	#1,	r14	;r3 As==01

	cmp	#0,	r14	;r3 As==00
	jz	.L163     	;abs 0x4e2a

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
	jmp .L148	;mova	#19916,	r0	;0x04dcc

.L164:
	cmp	#0,	r15	;r3 As==00
	jz	.L165      	;abs 0x4e40
	mov	r14,	48(r1)	; 0x0030

.L165:
	mov	r12,	r14	;
	and.b	#127,	r14	;#0x007f

	cmp	#64,	r14	;#0x0040
	jnz	.L172     	;abs 0x4e70

	mov	r12,	r14	;
	and.b	#128,	r14	;#0x0080

	cmp	#0,	r14	;r3 As==00
	jnz	.L172     	;abs 0x4e70

	mov	r8,	r14	;
	bis	r9,	r14	;
	cmp	#0,	r14	;r3 As==00
	jz	.L172     	;abs 0x4e70

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
	jmp .L100	;mova	#19580,	r0	;0x04c7c



	.global __mspabi_fltulf
	.type __mspabi_fltulf, @function
__mspabi_fltulf:
	nop
	nop
	pushm.a	#3,	r10	;20-bit words

	suba	#10,	r1	;0x0000a

	mov	r12,	r8	;
	mov	r13,	r9	;

	mov	#0,	2(r1)	;r3 As==00

	mov	r12,	r14	;
	bis	r13,	r14	;
	cmp	#0,	r14	;r3 As==00
	jnz	.L185     	;abs 0x4eb0

	mov	#2,	0(r1)	;r3 As==10

.L181:
	mova	r1,	r12	;
	calla	#__pack_f		;0x04f84

	adda	#10,	r1	;0x0000a

	popm.a	#3,	r10	;20-bit words

	reta			;

.L185:
	mov	#3,	0(r1)	;

	mov	#30,	4(r1)	;#0x001e

	calla	#__clzsi2		;0x04f34

	mov	r12,	r10	;
	add	#-1,	r10	;r3 As==11

	cmp	#0,	r12	;r3 As==00
	jnz	.L195     	;abs 0x4ee8

	mov	r8,	r12	;
	mov	r9,	r13	;
	clrc			
	rrc	r13		;
	rrc	r12		;

	and.b	#1,	r8	;r3 As==01

	bis	r12,	r8	;
	mov	r8,	6(r1)	;
	mov	r13,	8(r1)	;

	mov	#31,	4(r1)	;#0x001f

	jmp .L181	;mova	#20130,	r0	;0x04ea2

.L195:
	cmp	#0,	r10	;r3 As==00
	jnz	.L197     	;abs 0x4ef8

	mov	r8,	6(r1)	;
	mov	r9,	8(r1)	;
	jmp .L181	;mova	#20130,	r0	;0x04ea2

.L197:
	mov	r8,	r12	;
	mov	r9,	r13	;
	mov	r10,	r14	;
	clr	r15		;
	calla	#__mspabi_slll		;0x04f20
	mov	r12,	6(r1)	;
	mov	r13,	8(r1)	;

	mov.b	#30,	r12	;#0x001e
	sub	r10,	r12	;
	mov	r12,	4(r1)	;
	jmp .L181	;mova	#20130,	r0	;0x04ea2

.L199:
	add	#-1,	r14	;r3 As==11
	rla	r12		;
	rlc	r13		;



	.global __mspabi_slll
	.type __mspabi_slll, @function
__mspabi_slll:
	nop
	nop
	cmp	#0,	r14	;r3 As==00
	jnz	.L199      	;abs 0x4f1a
	reta			;

.L200:
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
	jnz	.L200     	;abs 0x4f26
	reta			;



	.global __clzsi2
	.type __clzsi2, @function
__clzsi2:
	nop
	nop
	pushm.a	#2,	r9	;20-bit words

	mov.b	#255,	r14	;#0x00ff
	cmp	#0,	r13	;r3 As==00
	jnz	.L207     	;abs 0x4f6a
	cmp	r12,	r14	;
	jc	.L209     	;abs 0x4f7e
	mov.b	#8,	r14	;r2 As==11

.L202:
	clr.b	r15		;

	mov.b	#32,	r8	;#0x0020
	clr.b	r9		;
	sub	r14,	r8	;
	subc	r15,	r9	;
	calla	#__mspabi_srll		;0x04f2e

	push	r13		;
	push	r12		;
	popm.a	#1,	r12	;20-bit words

	mov	r8,	r13	;
	movx.b	83156(r12),r12	;0x144d4
	sub	r12,	r13	;
	mov	r13,	r12	;
	popm.a	#2,	r9	;20-bit words

	reta			;

.L207:
	cmp	r13,	r14	;
	jnc	.L208     	;abs 0x4f76
	mov.b	#16,	r14	;#0x0010
	jmp .L202	;mova	#20292,	r0	;0x04f44

.L208:
	mov.b	#24,	r14	;#0x0018
	jmp .L202	;mova	#20292,	r0	;0x04f44

.L209:
	clr.b	r14		;
	jmp .L202	;mova	#20292,	r0	;0x04f44



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
	jnc	.L225     	;abs 0x4fe2

	mov	r8,	r12	;

	mov	r9,	r13	;
	mov.b	#7,	r14	;
	calla	#__mspabi_srll		;0x04f2e

	and.b	#63,	r13	;#0x003f

	mov	r12,	r8	;
	mov	r13,	r9	;
	bis	#64,	r9	;#0x0040

	mov.b	#255,	r10	;#0x00ff

.L220:
	mov	r8,	r12	;
	mov	r9,	r13	;
	mov.b	#16,	r14	;#0x0010
	calla	#__mspabi_srll		;0x04f2e
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

.L225:
	cmp	#4,	r13	;r2 As==10
	jz	.L269    	;abs 0x50e4

	cmp	#2,	r13	;r3 As==10
	jz	.L266    	;abs 0x50da

	mov	r8,	r10	;
	bis	r9,	r10	;
	cmp	#0,	r10	;r3 As==00
	jz	.L220     	;abs 0x4fba

	mov	4(r12),	r10	;

	cmp	#-126,	r10	;#0xff82
	jge	.L250    	;abs 0x5090

	mov	#-126,	r12	;#0xff82
	sub	r10,	r12	;

	mov.b	#25,	r13	;#0x0019
	cmp	r12,	r13	;
	jl	.L246    	;abs 0x5084

	mov	r12,	r10	;
	clr	r11		;
	mov	r8,	r12	;

	mov	r9,	r13	;
	mov	r10,	r14	;
	mova	r11,	0(r1)	;
	calla	#__mspabi_srll		;0x04f2e
	mov	r12,	4(r1)	;
	mov	r13,	6(r1)	;

	mov	#-1,	r12	;r3 As==11
	mov	#-1,	r13	;r3 As==11
	mov	r10,	r14	;
	calla	#__mspabi_slll		;0x04f20
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
	jnz	.L248     	;abs 0x5088

	mov	r12,	r14	;
	and.b	#128,	r14	;#0x0080

	cmp	#0,	r14	;r3 As==00
	jz	.L243      	;abs 0x5068

	add	#64,	r12	;#0x0040

.L242:
	adc	r13		;

.L243:
	mov.b	#1,	r10	;r3 As==01
	mov	#16383,	r14	;#0x3fff
	cmp	r13,	r14	;
	jnc	.L244      	;abs 0x5074
	clr.b	r10		;

.L244:
	mov.b	#7,	r14	;
	calla	#__mspabi_srll		;0x04f2e
	mov	r12,	r8	;
	mov	r13,	r9	;

	jmp .L220	;mova	#20410,	r0	;0x04fba

.L246:
	clr.b	r12		;

	clr.b	r13		;

.L248:
	add	#63,	r12	;#0x003f

	jmp .L242	;mova	#20582,	r0	;0x05066

.L250:
	mov.b	#127,	r12	;#0x007f

	cmp	r10,	r12	;
	jl	.L269     	;abs 0x50e4

	mov	r8,	r12	;
	and.b	#127,	r12	;#0x007f

	cmp	#64,	r12	;#0x0040
	jnz	.L261     	;abs 0x50c4

	mov	r8,	r12	;
	and.b	#128,	r12	;#0x0080

	cmp	#0,	r12	;r3 As==00
	jz	.L258      	;abs 0x50b4

	add	#64,	r8	;#0x0040

.L257:
	adc	r9		;

.L258:
	cmp	#0,	r9	;r3 As==00
	jl	.L263     	;abs 0x50cc

	add	#127,	r10	;#0x007f

.L260:
	mov	r8,	r12	;
	mov	r9,	r13	;
	jmp .L244	;mova	#20596,	r0	;0x05074

.L261:
	add	#63,	r8	;#0x003f

	jmp .L257	;mova	#20658,	r0	;0x050b2

.L263:
	clrc			
	rrc	r9		;
	rrc	r8		;

	add	#128,	r10	;#0x0080

	jmp .L260	;mova	#20668,	r0	;0x050bc

.L266:
	clr.b	r10		;

.L267:
	clr.b	r8		;

	clr.b	r9		;
	jmp .L220	;mova	#20410,	r0	;0x04fba

.L269:
	mov.b	#255,	r10	;#0x00ff
	jmp .L267	;mova	#20700,	r0	;0x050dc



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
	jnz	.L294     	;abs 0x5162

	mov	r12,	r14	;
	bis	r13,	r14	;
	cmp	#0,	r14	;r3 As==00
	jnz	.L284     	;abs 0x5128

	mov	#2,	0(r10)	;r3 As==10

.L282:
	popm.a	#3,	r10	;20-bit words

	reta			;

.L284:
	mov.b	#7,	r14	;
	calla	#__mspabi_slll		;0x04f20

	mov	#3,	0(r10)	;

	mov	#-127,	r14	;#0xff81

.L287:
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
	jc	.L287     	;abs 0x513a
	mov	r15,	4(r10)	;

	mov	r8,	6(r10)	;

.L292:
	mov	r13,	8(r10)	;

	jmp .L282	;mova	#20772,	r0	;0x05124

.L294:
	cmp	#255,	r11	;#0x00ff
	jnz	.L302     	;abs 0x51a8

	mov	r12,	r14	;
	bis	r13,	r14	;
	cmp	#0,	r14	;r3 As==00
	jnz	.L297     	;abs 0x5178

	mov	#4,	0(r10)	;r2 As==10
	jmp .L282	;mova	#20772,	r0	;0x05124

.L297:
	mov	r15,	r14	;
	and.b	#64,	r14	;#0x0040
	bit	#64,	r15	;#0x0040
	jz	.L301     	;abs 0x51a0

	mov	#1,	0(r10)	;r3 As==01

.L299:
	mov.b	#7,	r14	;
	calla	#__mspabi_slll		;0x04f20

	and	#-128,	r12	;#0xff80
	mov	r12,	6(r10)	;
	and	#-8193,	r13	;#0xdfff
	jmp .L292	;mova	#20826,	r0	;0x0515a

.L301:
	mov	r14,	0(r10)	;
	jmp .L299	;mova	#20872,	r0	;0x05188

.L302:
	add	#-127,	r11	;#0xff81

	mov	r11,	4(r10)	;

	mov	#3,	0(r10)	;

	mov.b	#7,	r14	;
	calla	#__mspabi_slll		;0x04f20

	mov	r12,	6(r10)	;
	bis	#16384,	r13	;#0x4000
	jmp .L292	;mova	#20826,	r0	;0x0515a



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

.L310:
	cmpa	r12,	r15	;
	jnz	.L315     	;abs 0x51e0

	mova	r8,	r12	;

	popm.a	#1,	r8	;20-bit words

	popm.a	#1,	r10	;20-bit words

	reta			;

.L315:
	mova	r8,	r14	;
	adda	r12,	r14	;

	mova	r13,	r10	;
	adda	r12,	r10	;

	mov.b	@r10,	0(r14)	;
	adda	#1,	r12	;

	jmp .L310	;mova	#20948,	r0	;0x051d4



	.global _exit
	.type _exit, @function
_exit:
	nop
	nop
	jmp _exit	;mova	#20980,	r0	;0x051f4
