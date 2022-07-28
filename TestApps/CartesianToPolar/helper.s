


	.global _fpadd_parts
	.type _fpadd_parts, @function
_fpadd_parts:
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
	jc	.L11     	;abs 0x50e2

	mova	r13,	r8	;

	mov	@r13,	r13	;

	cmp	r13,	r9	;
	jnc	.L7      	;abs 0x50c8
	jmp .L120	;mova	#22184,	r0	;0x056a8

.L7:
	cmp	#4,	r12	;r2 As==10
	jnz	.L14     	;abs 0x50ec

	cmp	#4,	r13	;r2 As==10
	jnz	.L11     	;abs 0x50e2

	mova	@r1,	r12	;
	cmp	2(r8),	2(r12)	;
	jz	.L11     	;abs 0x50e2

	movx.a	#82944,	0(r1)	;0x14400

.L11:
	mova	@r1,	r12	;
	adda	#36,	r1	;0x00024

	popm.a	#4,	r10	;20-bit words

	reta			;

.L14:
	cmp	#4,	r13	;r2 As==10
	jnz	.L15      	;abs 0x50f4
	jmp .L120	;mova	#22184,	r0	;0x056a8

.L15:
	cmp	#2,	r13	;r3 As==10
	jnz	.L20     	;abs 0x5122

	cmp	#2,	r12	;r3 As==10
	jnz	.L11     	;abs 0x50e2

	mov.b	#14,	r14	;#0x000e
	mova	@r1,	r13	;
	mova	r7,	r12	;
	calla	#memcpy		;0x06878

	mova	@r1,	r13	;
	mov	2(r13),	r14	;
	mova	6(r1),	r13	;
	and	2(r13),	r14	;
	mov	r14,	2(r7)	;

.L19:
	mova	r7,	0(r1)	;
	jmp .L11	;mova	#20706,	r0	;0x050e2

.L20:
	cmp	#2,	r12	;r3 As==10
	jnz	.L21      	;abs 0x512a
	jmp .L120	;mova	#22184,	r0	;0x056a8

.L21:
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
	jge	.L41    	;abs 0x5282

	mov	28(r1),	r14	;0x0001c
	sub	18(r1),	r14	;0x00012
	mov	r14,	24(r1)	; 0x0018

	mov.b	#63,	r8	;#0x003f
	cmp	r14,	r8	;
	jl	.L83    	;abs 0x54d0

	mov	4(r1),	r8	;
	mov	12(r1),	r9	;0x0000c
	mov	22(r1),	r10	;0x00016
	mov	14(r1),	r11	;0x0000e
	mov	24(r1),	r12	;0x00018

	calla	#__mspabi_srlll		;0x062ee

	mov	r12,	18(r1)	; 0x0012

	mov	r13,	30(r1)	; 0x001e
	mov	r14,	32(r1)	; 0x0020
	mov	r15,	34(r1)	; 0x0022
	mov	#-1,	r8	;r3 As==11
	mov	r8,	r9	;
	mov	r8,	r10	;
	mov	r8,	r11	;
	mov	24(r1),	r12	;0x00018
	calla	#__mspabi_sllll		;0x062c2
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
	jnz	.L35      	;abs 0x51fa
	mov	r9,	r15	;

.L35:
	mov	r11,	r12	;
	sub	r13,	r12	;
	mov.b	#1,	r10	;r3 As==01
	cmp	r13,	r11	;
	jnz	.L36      	;abs 0x5206
	mov	r12,	r10	;

.L36:
	mov	r12,	r9	;
	sub	r15,	r9	;
	mov	r9,	22(r1)	; 0x0016
	mov.b	#1,	r15	;r3 As==01
	cmp	r9,	r12	;
	jnc	.L37      	;abs 0x5216
	clr.b	r15		;

.L37:
	bis	r15,	r10	;
	mov	r11,	r12	;
	sub	r14,	r12	;
	mov.b	#1,	r15	;r3 As==01
	cmp	r14,	r11	;
	jnz	.L38      	;abs 0x5224
	mov	r12,	r15	;

.L38:
	mov	r12,	r9	;
	sub	r10,	r9	;
	mov	r9,	4(r1)	;
	mov.b	#1,	r10	;r3 As==01
	cmp	r9,	r12	;
	jnc	.L39      	;abs 0x5234
	clr.b	r10		;

.L39:
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
	calla	#__mspabi_srlll		;0x062ee
	bis	18(r1),	r12	;0x00012
	mov	r12,	4(r1)	;
	bis	30(r1),	r13	;0x0001e
	mov	r13,	12(r1)	; 0x000c
	bis	32(r1),	r14	;0x00020
	mov	r14,	22(r1)	; 0x0016
	bis	34(r1),	r15	;0x00022
	mov	r15,	14(r1)	; 0x000e

	mov	28(r1),	18(r1)	;0x0001c, 0x0012
	jmp .L55	;mova	#21370,	r0	;0x0537a

.L41:
	mov.b	#63,	r9	;#0x003f
	cmp	24(r1),	r9	;0x00018
	jl	.L83    	;abs 0x54d0

	cmp	#0,	24(r1)	;r3 As==00, 0x0018
	jz	.L55    	;abs 0x537a

	mov	10(r1),	r8	;0x0000a

	mov	20(r1),	r9	;0x00014
	mov	26(r1),	r10	;0x0001a
	mov	16(r1),	r11	;0x00010
	mov	24(r1),	r12	;0x00018

	calla	#__mspabi_srlll		;0x062ee

	mov	r12,	28(r1)	; 0x001c

	mov	r13,	30(r1)	; 0x001e
	mov	r14,	32(r1)	; 0x0020
	mov	r15,	34(r1)	; 0x0022
	mov	#-1,	r8	;r3 As==11
	mov	r8,	r9	;
	mov	r8,	r10	;
	mov	r8,	r11	;
	mov	24(r1),	r12	;0x00018
	calla	#__mspabi_sllll		;0x062c2
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
	jnz	.L49      	;abs 0x52fc
	mov	r11,	r15	;

.L49:
	mov	r11,	r12	;
	sub	r13,	r12	;
	mov.b	#1,	r10	;r3 As==01
	cmp	r13,	r11	;
	jnz	.L50      	;abs 0x5308
	mov	r12,	r10	;

.L50:
	mov	r12,	r9	;
	sub	r15,	r9	;
	mov	r9,	24(r1)	; 0x0018

	mov.b	#1,	r15	;r3 As==01
	cmp	r9,	r12	;
	jnc	.L52      	;abs 0x5318
	clr.b	r15		;

.L52:
	bis	r15,	r10	;
	mov	r11,	r12	;
	sub	r14,	r12	;
	mov.b	#1,	r15	;r3 As==01
	cmp	r14,	r11	;
	jnz	.L53      	;abs 0x5326
	mov	r12,	r15	;

.L53:
	mov	r12,	r9	;
	sub	r10,	r9	;
	mov	r9,	10(r1)	; 0x000a
	mov.b	#1,	r10	;r3 As==01
	cmp	r9,	r12	;
	jnc	.L54      	;abs 0x5336
	clr.b	r10		;

.L54:
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
	calla	#__mspabi_srlll		;0x062ee
	bis	28(r1),	r12	;0x0001c
	mov	r12,	10(r1)	; 0x000a
	bis	30(r1),	r13	;0x0001e
	mov	r13,	20(r1)	; 0x0014
	bis	32(r1),	r14	;0x00020
	mov	r14,	26(r1)	; 0x001a
	bis	34(r1),	r15	;0x00022
	mov	r15,	16(r1)	; 0x0010

.L55:
	mova	@r1,	r13	;
	mov	2(r13),	r12	;

	mova	6(r1),	r8	;
	cmp	2(r8),	r12	;
	jz	.L111    	;abs 0x5630

	cmp	#0,	r12	;r3 As==00
	jz	.L88    	;abs 0x5512

	mov	10(r1),	r14	;0x0000a
	sub	4(r1),	r14	;
	mov.b	#1,	r10	;r3 As==01
	cmp	r14,	10(r1)	; 0x000a
	jnc	.L59      	;abs 0x53a0
	clr.b	r10		;

.L59:
	mov	20(r1),	r12	;0x00014
	sub	12(r1),	r12	;0x0000c
	mov.b	#1,	r15	;r3 As==01
	cmp	r12,	20(r1)	; 0x0014
	jnc	.L60      	;abs 0x53b2
	clr.b	r15		;

.L60:
	mov	r12,	r13	;
	sub	r10,	r13	;
	mov.b	#1,	r10	;r3 As==01
	cmp	r13,	r12	;
	jnc	.L61      	;abs 0x53be
	clr.b	r10		;

.L61:
	bis	r10,	r15	;
	mov	26(r1),	r9	;0x0001a
	sub	22(r1),	r9	;0x00016
	mov.b	#1,	r10	;r3 As==01
	cmp	r9,	26(r1)	; 0x001a
	jnc	.L62      	;abs 0x53d2
	clr.b	r10		;

.L62:
	mov	r9,	r12	;
	sub	r15,	r12	;
	mov.b	#1,	r15	;r3 As==01
	cmp	r12,	r9	;
	jnc	.L63      	;abs 0x53de
	clr.b	r15		;

.L63:
	bis	r15,	r10	;
	mov	16(r1),	r11	;0x00010
	sub	14(r1),	r11	;0x0000e

.L64:
	sub	r10,	r11	;

	cmp	#0,	r11	;r3 As==00
	jl	.L94    	;abs 0x5570

	mov	#0,	2(r7)	;r3 As==00

	mov	18(r1),	4(r7)	;0x00012

	mov	r14,	6(r7)	;
	mov	r13,	8(r7)	;
	mov	r12,	10(r7)	; 0x000a
	mov	r11,	12(r7)	; 0x000c

.L69:
	mov.b	#1,	r11	;r3 As==01
	clr.b	r14		;

.L70:
	mov	6(r7),	r15	;
	mov	8(r7),	0(r1)	;
	mov	10(r7),	r10	;0x0000a
	mov	12(r7),	6(r1)	;0x0000c

	mov	r15,	r9	;
	add	#-1,	r9	;r3 As==11
	mov	r9,	10(r1)	; 0x000a
	mov	r11,	r9	;
	cmp	#0,	r15	;r3 As==00
	jnz	.L72      	;abs 0x5430
	mov	r14,	r9	;

.L72:
	mov	@r1,	r8	;
	add	#-1,	r8	;r3 As==11
	mov.b	#1,	r12	;r3 As==01
	cmp	#0,	0(r1)	;r3 As==00
	jnz	.L73      	;abs 0x543e
	clr.b	r12		;

.L73:
	add	r8,	r9	;
	mov	r11,	r13	;
	cmp	r8,	r9	;
	jnc	.L74      	;abs 0x5448
	mov	r14,	r13	;

.L74:
	bis	r13,	r12	;
	mov	r10,	r13	;
	add	#-1,	r13	;r3 As==11
	mov	r13,	4(r1)	;
	mov.b	#1,	r13	;r3 As==01
	cmp	#0,	r10	;r3 As==00
	jnz	.L75      	;abs 0x545a
	clr.b	r13		;

.L75:
	add	4(r1),	r12	;
	mov	r11,	r8	;
	cmp	4(r1),	r12	;
	jnc	.L76      	;abs 0x5468
	mov	r14,	r8	;

.L76:
	bis	r8,	r13	;
	mov	6(r1),	r8	;
	add	#-1,	r8	;r3 As==11
	add	r8,	r13	;

	mov	#4095,	r8	;#0x0fff
	cmp	r13,	r8	;
	jnc	.L78     	;abs 0x5490
	cmp	r8,	r13	;
	jnz	.L104    	;abs 0x55d4
	cmp	#-1,	r12	;r3 As==11
	jnz	.L104    	;abs 0x55d4
	cmp	#-1,	r9	;r3 As==11
	jnz	.L104    	;abs 0x55d4
	mov	#-2,	r9	;#0xfffe
	cmp	10(r1),	r9	;0x0000a
	jc	.L104    	;abs 0x55d4

.L78:
	mov	#3,	0(r7)	;

	mov	6(r7),	r8	;
	mov	8(r7),	r9	;
	mov	10(r7),	r10	;0x0000a
	mov	12(r7),	r11	;0x0000c

	mov	#8191,	r12	;#0x1fff
	cmp	r11,	r12	;
	jc	.L19    	;abs 0x511a

	mov.b	#1,	r12	;r3 As==01
	calla	#__mspabi_srlll		;0x062ee
	and.b	#1,	r8	;r3 As==01
	bis	r8,	r12	;
	mov	r12,	6(r7)	;
	mov	r13,	8(r7)	;
	mov	r14,	10(r7)	; 0x000a
	mov	r15,	12(r7)	; 0x000c

	inc	4(r7)		;
	jmp .L19	;mova	#20762,	r0	;0x0511a

.L83:
	cmp	18(r1),	28(r1)	;0x00012, 0x001c
	jl	.L86     	;abs 0x54f8
	mov	28(r1),	18(r1)	;0x0001c, 0x0012

	mov	#0,	4(r1)	;r3 As==00

	mov	4(r1),	12(r1)	; 0x000c
	mov	4(r1),	22(r1)	; 0x0016
	mov	4(r1),	14(r1)	; 0x000e
	jmp .L55	;mova	#21370,	r0	;0x0537a

.L86:
	mov	#0,	10(r1)	;r3 As==00, 0x000a

	mov	10(r1),	20(r1)	;0x0000a, 0x0014
	mov	10(r1),	26(r1)	;0x0000a, 0x001a
	mov	10(r1),	16(r1)	;0x0000a, 0x0010
	jmp .L55	;mova	#21370,	r0	;0x0537a

.L88:
	mov	4(r1),	r14	;
	sub	10(r1),	r14	;0x0000a
	mov.b	#1,	r10	;r3 As==01
	cmp	r14,	4(r1)	;
	jnc	.L89      	;abs 0x5524
	mov	r12,	r10	;

.L89:
	mov	12(r1),	r12	;0x0000c
	sub	20(r1),	r12	;0x00014
	mov.b	#1,	r15	;r3 As==01
	cmp	r12,	12(r1)	; 0x000c
	jnc	.L90      	;abs 0x5536
	clr.b	r15		;

.L90:
	mov	r12,	r13	;
	sub	r10,	r13	;
	mov.b	#1,	r10	;r3 As==01
	cmp	r13,	r12	;
	jnc	.L91      	;abs 0x5542
	clr.b	r10		;

.L91:
	bis	r10,	r15	;
	mov	22(r1),	r9	;0x00016
	sub	26(r1),	r9	;0x0001a
	mov.b	#1,	r10	;r3 As==01
	cmp	r9,	22(r1)	; 0x0016
	jnc	.L92      	;abs 0x5556
	clr.b	r10		;

.L92:
	mov	r9,	r12	;
	sub	r15,	r12	;
	mov.b	#1,	r15	;r3 As==01
	cmp	r12,	r9	;
	jnc	.L93      	;abs 0x5562
	clr.b	r15		;

.L93:
	bis	r15,	r10	;
	mov	14(r1),	r11	;0x0000e
	sub	16(r1),	r11	;0x00010
	jmp .L64	;mova	#21480,	r0	;0x053e8

.L94:
	mov	#1,	2(r7)	;r3 As==01

	mov	18(r1),	4(r7)	;0x00012

	clr.b	r15		;
	mov	r15,	r10	;
	sub	r14,	r10	;
	mov.b	#1,	r9	;r3 As==01
	cmp	r14,	r15	;
	jnz	.L97      	;abs 0x5588
	mov	r10,	r9	;

.L97:
	mov	r15,	r8	;
	sub	r13,	r8	;
	mov.b	#1,	r14	;r3 As==01

	cmp	r13,	r15	;
	jnz	.L99      	;abs 0x5594
	mov	r8,	r14	;

.L99:
	mov	r8,	r13	;
	sub	r9,	r13	;
	mov.b	#1,	r9	;r3 As==01
	cmp	r13,	r8	;
	jnc	.L100      	;abs 0x55a0
	clr.b	r9		;

.L100:
	bis	r9,	r14	;
	mov	r15,	r8	;
	sub	r12,	r8	;
	mov.b	#1,	r9	;r3 As==01
	cmp	r12,	r15	;
	jnz	.L101      	;abs 0x55ae
	mov	r8,	r9	;

.L101:
	mov	r8,	r12	;
	sub	r14,	r12	;
	mov.b	#1,	r14	;r3 As==01
	cmp	r12,	r8	;
	jnc	.L102      	;abs 0x55ba
	clr.b	r14		;

.L102:
	bis	r14,	r9	;
	sub	r11,	r15	;

	mov	r10,	6(r7)	;
	mov	r13,	8(r7)	;
	mov	r12,	10(r7)	; 0x000a
	sub	r9,	r15	;
	mov	r15,	12(r7)	; 0x000c
	jmp .L69	;mova	#21512,	r0	;0x05408

.L104:
	mov	r15,	r9	;
	add	r15,	r9	;
	mov	r11,	r13	;
	cmp	r15,	r9	;
	jnc	.L105      	;abs 0x55e0
	mov	r14,	r13	;

.L105:
	mov	@r1,	r15	;
	rla	r15		;
	mov.b	#1,	r12	;r3 As==01
	cmp	@r1,	r15	;
	jnc	.L106      	;abs 0x55ec
	clr.b	r12		;

.L106:
	add	r15,	r13	;
	mov	r11,	r8	;
	cmp	r15,	r13	;
	jnc	.L107      	;abs 0x55f6
	mov	r14,	r8	;

.L107:
	bis	r8,	r12	;
	mov	r10,	r8	;
	add	r10,	r8	;
	mov.b	#1,	r15	;r3 As==01
	cmp	r10,	r8	;
	jnc	.L108      	;abs 0x5604
	clr.b	r15		;

.L108:
	add	r8,	r12	;
	mov	r11,	r10	;
	cmp	r8,	r12	;
	jnc	.L109      	;abs 0x560e
	mov	r14,	r10	;

.L109:
	bis	r10,	r15	;
	mov	6(r1),	r10	;
	rla	r10		;
	mov	r9,	6(r7)	;
	mov	r13,	8(r7)	;
	mov	r12,	10(r7)	; 0x000a
	add	r10,	r15	;
	mov	r15,	12(r7)	; 0x000c

	add	#-1,	4(r7)	;r3 As==11
	jmp .L70	;mova	#21516,	r0	;0x0540c

.L111:
	mov	r12,	2(r7)	;

	mov	18(r1),	4(r7)	;0x00012

	mov	4(r1),	r8	;
	add	10(r1),	r8	;0x0000a
	mov.b	#1,	r10	;r3 As==01
	cmp	4(r1),	r8	;
	jnc	.L114      	;abs 0x564c
	clr.b	r10		;

.L114:
	mov	12(r1),	r13	;0x0000c
	add	20(r1),	r13	;0x00014
	mov.b	#1,	r15	;r3 As==01
	cmp	12(r1),	r13	;0x0000c
	jnc	.L115      	;abs 0x565e
	clr.b	r15		;

.L115:
	add	r13,	r10	;
	mov.b	#1,	r12	;r3 As==01
	cmp	r13,	r10	;
	jnc	.L116      	;abs 0x5668
	clr.b	r12		;

.L116:
	bis	r12,	r15	;
	mov	22(r1),	r14	;0x00016
	add	26(r1),	r14	;0x0001a
	mov.b	#1,	r9	;r3 As==01
	cmp	22(r1),	r14	;0x00016
	jnc	.L117      	;abs 0x567c
	clr.b	r9		;

.L117:
	mov	r15,	r13	;
	add	r14,	r13	;
	mov.b	#1,	r12	;r3 As==01
	cmp	r14,	r13	;
	jnc	.L118      	;abs 0x5688
	clr.b	r12		;

.L118:
	bis	r12,	r9	;
	mov	14(r1),	r15	;0x0000e
	add	16(r1),	r15	;0x00010

	mov	r8,	6(r7)	;
	mov	r10,	8(r7)	;
	mov	r13,	10(r7)	; 0x000a
	add	r15,	r9	;
	mov	r9,	12(r7)	; 0x000c
	jmp .L78	;mova	#21648,	r0	;0x05490

.L120:
	movx.a	6(r1),	0(r1)	;

	jmp .L11	;mova	#20706,	r0	;0x050e2



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

	calla	#__unpack_d		;

	mova	r1,	r13	;
	adda	#30,	r13	;0x0001e
	mova	r1,	r12	;
	adda	#8,	r12	;
	calla	#__unpack_d		;

	mova	r1,	r14	;
	adda	#44,	r14	;0x0002c
	mova	r1,	r13	;
	adda	#30,	r13	;0x0001e
	mova	r1,	r12	;
	adda	#16,	r12	;0x00010
	calla	#_fpadd_parts		;0x050a2

	calla	#__pack_d		;0x0635e

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
	calla	#_fpadd_parts		;0x050a2

	calla	#__pack_d		;0x0635e

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
	jnc	.L160     	;abs 0x57f8

.L153:
	mov	62(r1),	r13	;0x0003e
	xor	76(r1),	r13	;0x0004c
	clr	r12		;
	sub	r13,	r12	;
	bis	r13,	r12	;

	rpt #15 { rrux.w	r12		;
	mov	r12,	62(r1)	; 0x003e

.L155:
	mova	r1,	r12	;
	adda	#60,	r12	;0x0003c

.L156:
	calla	#__pack_d		;0x0635e

	adda	#102,	r1	;0x00066

	popm.a	#4,	r10	;20-bit words

	reta			;

.L160:
	mov	74(r1),	r12	;0x0004a

	mov.b	#1,	r14	;r3 As==01
	cmp	r12,	r14	;
	jnc	.L165     	;abs 0x5822

.L162:
	mov	62(r1),	r13	;0x0003e
	xor	76(r1),	r13	;0x0004c
	clr	r12		;
	sub	r13,	r12	;
	bis	r13,	r12	;

	rpt #15 { rrux.w	r12		;
	mov	r12,	76(r1)	; 0x004c

.L164:
	mova	r1,	r12	;
	adda	#74,	r12	;0x0004a
	jmp .L156	;mova	#22508,	r0	;0x057ec

.L165:
	cmp	#4,	r13	;r2 As==10
	jnz	.L168     	;abs 0x5832

	cmp	#2,	r12	;r3 As==10
	jnz	.L153     	;abs 0x57d0

.L167:
	mova	#82944,	r12	;0x14400
	jmp .L156	;mova	#22508,	r0	;0x057ec

.L168:
	cmp	#4,	r12	;r2 As==10
	jnz	.L170     	;abs 0x583e

	cmp	#2,	r13	;r3 As==10
	jz	.L167     	;abs 0x582a
	jmp .L162	;mova	#22530,	r0	;0x05802

.L170:
	mov	76(r1),	r15	;0x0004c
	xor	62(r1),	r15	;0x0003e
	clr	r14		;
	sub	r15,	r14	;
	bis	r15,	r14	;
	rpt #15 { rrux.w	r14		;
	mov	r14,	32(r1)	; 0x0020

	cmp	#2,	r13	;r3 As==10
	jnz	.L173     	;abs 0x5860

	mov	r14,	62(r1)	; 0x003e
	jmp .L155	;mova	#22502,	r0	;0x057e6

.L173:
	cmp	#2,	r12	;r3 As==10
	jnz	.L175     	;abs 0x586e

	mov	32(r1),	76(r1)	;0x00020, 0x004c
	jmp .L164	;mova	#22552,	r0	;0x05818

.L175:
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

.L181:
	bitx.w	#1,	34(r1)	;r3 As==01, 0x00022
	jz	.L205    	;abs 0x59fc

	mov	8(r1),	r12	;
	add	22(r1),	r12	;0x00016
	mov	r12,	36(r1)	; 0x0024
	mov.b	#1,	r9	;r3 As==01
	cmp	8(r1),	r12	;
	jnc	.L183      	;abs 0x58f0
	clr.b	r9		;

.L183:
	mov	10(r1),	r13	;0x0000a
	add	16(r1),	r13	;0x00010
	mov.b	#1,	r12	;r3 As==01
	cmp	10(r1),	r13	;0x0000a
	jnc	.L184      	;abs 0x5902
	clr.b	r12		;

.L184:
	add	r13,	r9	;
	mov.b	#1,	r14	;r3 As==01
	cmp	r13,	r9	;
	jnc	.L185      	;abs 0x590c
	clr.b	r14		;

.L185:
	bis	r14,	r12	;
	mov	12(r1),	r13	;0x0000c
	add	18(r1),	r13	;0x00012
	mov.b	#1,	r10	;r3 As==01
	cmp	12(r1),	r13	;0x0000c
	jnc	.L186      	;abs 0x5920
	clr.b	r10		;

.L186:
	add	r13,	r12	;
	mov.b	#1,	r14	;r3 As==01
	cmp	r13,	r12	;
	jnc	.L187      	;abs 0x592a
	clr.b	r14		;

.L187:
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
	jnc	.L191      	;abs 0x5952
	clr.b	r8		;

.L191:
	mov	24(r1),	r13	;0x00018
	add	2(r1),	r13	;
	mov.b	#1,	r11	;r3 As==01
	cmp	24(r1),	r13	;0x00018
	jnc	.L192      	;abs 0x5964
	clr.b	r11		;

.L192:
	add	r13,	r8	;
	mov.b	#1,	r14	;r3 As==01
	cmp	r13,	r8	;
	jnc	.L193      	;abs 0x596e
	clr.b	r14		;

.L193:
	bis	r14,	r11	;
	mov	26(r1),	r14	;0x0001a
	add	4(r1),	r14	;
	mov.b	#1,	r13	;r3 As==01
	cmp	26(r1),	r14	;0x0001a
	jnc	.L194      	;abs 0x5982
	clr.b	r13		;

.L194:
	add	r14,	r11	;
	mov.b	#1,	r15	;r3 As==01
	cmp	r14,	r11	;
	jnc	.L195      	;abs 0x598c
	clr.b	r15		;

.L195:
	bis	r15,	r13	;
	mov	30(r1),	r15	;0x0001e
	add	6(r1),	r15	;
	add	r15,	r13	;

	mov.b	#1,	r14	;r3 As==01
	cmp	20(r1),	r10	;0x00014
	jnc	.L198     	;abs 0x59c8
	cmp	r10,	20(r1)	; 0x0014
	jnz	.L197     	;abs 0x59c6
	cmp	18(r1),	r12	;0x00012
	jnc	.L198     	;abs 0x59c8
	cmp	r12,	18(r1)	; 0x0012
	jnz	.L197     	;abs 0x59c6
	cmp	16(r1),	r9	;0x00010
	jnc	.L198     	;abs 0x59c8
	cmp	r9,	16(r1)	; 0x0010
	jnz	.L197     	;abs 0x59c6
	cmp	22(r1),	36(r1)	;0x00016, 0x0024
	jnc	.L198      	;abs 0x59c8

.L197:
	clr.b	r14		;

.L198:
	mov	r14,	r12	;

	add	r7,	r12	;
	mov.b	#1,	r10	;r3 As==01

	cmp	r14,	r12	;
	jnc	.L201      	;abs 0x59d4
	clr.b	r10		;

.L201:
	add	r8,	r10	;
	mov.b	#1,	r14	;r3 As==01
	cmp	r8,	r10	;
	jnc	.L202      	;abs 0x59de
	clr.b	r14		;

.L202:
	clr.b	r15		;
	add	r11,	r14	;
	mov.b	#1,	r9	;r3 As==01

	cmp	r11,	r14	;
	jnc	.L204      	;abs 0x59ea
	mov	r15,	r9	;

.L204:
	bis	r9,	r15	;
	mov	r12,	r7	;
	mov	r10,	2(r1)	;
	mov	r14,	4(r1)	;
	add	r13,	r15	;
	mov	r15,	6(r1)	;

.L205:
	mov	@r1,	r10	;
	rla	r10		;
	mov.b	#1,	r13	;r3 As==01
	cmp	@r1,	r10	;
	jnc	.L206      	;abs 0x5a08
	clr.b	r13		;

.L206:
	mov	24(r1),	r14	;0x00018
	rla	r14		;
	mov.b	#1,	r12	;r3 As==01
	cmp	24(r1),	r14	;0x00018
	jnc	.L207      	;abs 0x5a18
	clr.b	r12		;

.L207:
	add	r14,	r13	;
	mov.b	#1,	r15	;r3 As==01
	cmp	r14,	r13	;
	jnc	.L208      	;abs 0x5a22
	clr.b	r15		;

.L208:
	bis	r15,	r12	;
	mov	26(r1),	r15	;0x0001a
	rla	r15		;
	mov.b	#1,	r14	;r3 As==01
	cmp	26(r1),	r15	;0x0001a
	jnc	.L209      	;abs 0x5a34
	clr.b	r14		;

.L209:
	add	r15,	r12	;
	mov.b	#1,	r9	;r3 As==01
	cmp	r15,	r12	;
	jnc	.L210      	;abs 0x5a3e
	clr.b	r9		;

.L210:
	bis	r9,	r14	;
	mov	30(r1),	r15	;0x0001e
	rla	r15		;
	mov	r10,	0(r1)	;

	mov	r13,	24(r1)	; 0x0018
	mov	r12,	26(r1)	; 0x001a
	add	r15,	r14	;
	mov	r14,	30(r1)	; 0x001e

	cmp	#0,	20(r1)	;r3 As==00, 0x0014
	jge	.L214      	;abs 0x5a62

	bis	#1,	0(r1)	;r3 As==01

.L214:
	mov	22(r1),	r10	;0x00016
	rla	r10		;
	mov.b	#1,	r13	;r3 As==01

	cmp	22(r1),	r10	;0x00016
	jnc	.L216      	;abs 0x5a72
	clr.b	r13		;

.L216:
	mov	16(r1),	r14	;0x00010

	rla	r14		;
	mov.b	#1,	r12	;r3 As==01

	cmp	16(r1),	r14	;0x00010
	jnc	.L219      	;abs 0x5a82
	clr.b	r12		;

.L219:
	add	r14,	r13	;
	mov.b	#1,	r15	;r3 As==01
	cmp	r14,	r13	;
	jnc	.L220      	;abs 0x5a8c
	clr.b	r15		;

.L220:
	bis	r15,	r12	;
	mov	18(r1),	r15	;0x00012
	rla	r15		;
	mov.b	#1,	r14	;r3 As==01
	cmp	18(r1),	r15	;0x00012
	jnc	.L221      	;abs 0x5a9e
	clr.b	r14		;

.L221:
	add	r15,	r12	;
	mov.b	#1,	r9	;r3 As==01
	cmp	r15,	r12	;
	jnc	.L222      	;abs 0x5aa8
	clr.b	r9		;

.L222:
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
	calla	#__mspabi_srlll		;0x062ee

	mov	r12,	34(r1)	; 0x0022

	mov	r13,	38(r1)	; 0x0026
	mov	r14,	40(r1)	; 0x0028
	mov	r15,	42(r1)	; 0x002a

	add	#-1,	28(r1)	;r3 As==11, 0x001c

	cmp	#0,	28(r1)	;r3 As==00, 0x001c
	jnz	.L181    	;abs 0x58d2

	mov	64(r1),	r12	;0x00040

	add	78(r1),	r12	;0x0004e

	add	#4,	r12	;r2 As==10
	mov	r12,	0(r1)	;

	mov	r12,	92(r1)	; 0x005c

	mov	32(r1),	90(r1)	;0x00020, 0x005a

	mov	28(r1),	r12	;0x0001c

.L235:
	mov	#8191,	r13	;#0x1fff
	cmp	6(r1),	r13	;
	jnc	.L259    	;abs 0x5c02
	cmp	#0,	r12	;r3 As==00
	jz	.L236      	;abs 0x5b20
	mov	@r1,	92(r1)	; 0x005c

.L236:
	mov	92(r1),	r11	;0x0005c

	clr.b	r12		;

	mov.b	#1,	r9	;r3 As==01
	mov	r12,	r8	;

.L239:
	mov	#4095,	r13	;#0x0fff
	cmp	6(r1),	r13	;
	jnc	.L267    	;abs 0x5c5c

	mov	r7,	r10	;
	add	r7,	r10	;
	mov	r9,	r13	;
	cmp	r7,	r10	;
	jnc	.L241      	;abs 0x5b40
	mov	r8,	r13	;

.L241:
	mov	2(r1),	r12	;
	rla	r12		;
	mov.b	#1,	r14	;r3 As==01
	cmp	2(r1),	r12	;
	jnc	.L242      	;abs 0x5b50
	clr.b	r14		;

.L242:
	add	r12,	r13	;
	mov	r9,	r15	;
	cmp	r12,	r13	;
	jnc	.L243      	;abs 0x5b5a
	mov	r8,	r15	;

.L243:
	bis	r15,	r14	;
	mov	4(r1),	r15	;
	rla	r15		;
	mov.b	#1,	r12	;r3 As==01
	cmp	4(r1),	r15	;
	jnc	.L244      	;abs 0x5b6c
	clr.b	r12		;

.L244:
	add	r15,	r14	;
	mov	r9,	r7	;

	cmp	r15,	r14	;
	jnc	.L246      	;abs 0x5b76
	mov	r8,	r7	;

.L246:
	bis	r7,	r12	;
	mov	6(r1),	r15	;
	rla	r15		;
	mov	r10,	r7	;
	mov	r13,	2(r1)	;
	mov	r14,	4(r1)	;
	add	r15,	r12	;
	mov	r12,	6(r1)	;

	cmp	#0,	14(r1)	;r3 As==00, 0x000e
	jge	.L249      	;abs 0x5b96

	bis	#1,	r7	;r3 As==01

.L249:
	mov	8(r1),	r14	;

	rla	r14		;
	mov	r14,	0(r1)	;
	mov	r9,	r13	;

	cmp	8(r1),	r14	;
	jnc	.L252      	;abs 0x5baa
	mov	r8,	r13	;

.L252:
	mov	10(r1),	r15	;0x0000a
	rla	r15		;
	mov.b	#1,	r14	;r3 As==01
	cmp	10(r1),	r15	;0x0000a
	jnc	.L253      	;abs 0x5bba
	clr.b	r14		;

.L253:
	add	r15,	r13	;
	mov	r9,	r12	;

	cmp	r15,	r13	;
	jnc	.L255      	;abs 0x5bc4
	mov	r8,	r12	;

.L255:
	bis	r12,	r14	;
	mov	12(r1),	r15	;0x0000c
	rla	r15		;
	mov.b	#1,	r12	;r3 As==01
	cmp	12(r1),	r15	;0x0000c
	jnc	.L256      	;abs 0x5bd6
	clr.b	r12		;

.L256:
	add	r15,	r14	;
	mov	r9,	r10	;
	cmp	r15,	r14	;
	jnc	.L257      	;abs 0x5be0
	mov	r8,	r10	;

.L257:
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
	jmp .L239	;mova	#23338,	r0	;0x05b2a

.L259:
	bit	#1,	r7	;r3 As==01
	jz	.L263     	;abs 0x5c30

	mov	8(r1),	r8	;
	mov	10(r1),	r9	;0x0000a
	mov	12(r1),	r10	;0x0000c
	mov	14(r1),	r11	;0x0000e
	mov.b	#1,	r12	;r3 As==01
	calla	#__mspabi_srlll		;0x062ee

	mov	r12,	8(r1)	;
	mov	r13,	10(r1)	; 0x000a
	mov	r14,	12(r1)	; 0x000c
	bis	#-32768,r15	;#0x8000

	mov	r15,	14(r1)	; 0x000e

.L263:
	mov	r7,	r8	;
	mov	2(r1),	r9	;
	mov	4(r1),	r10	;
	mov	6(r1),	r11	;
	mov.b	#1,	r12	;r3 As==01
	calla	#__mspabi_srlll		;0x062ee
	mov	r12,	r7	;

	mov	r13,	2(r1)	;

	mov	r14,	4(r1)	;
	mov	r15,	6(r1)	;

	inc	0(r1)		;
	mov.b	#1,	r12	;r3 As==01
	jmp .L235	;mova	#23310,	r0	;0x05b0e

.L267:
	cmp	#0,	r12	;r3 As==00
	jz	.L268      	;abs 0x5c64
	mov	r11,	92(r1)	; 0x005c

.L268:
	mov	r7,	r15	;
	and.b	#255,	r15	;#0x00ff

	cmp.b	#-128,	r7	;#0xff80
	jnz	.L278     	;abs 0x5cd0

	mov	r7,	r14	;
	and	#256,	r14	;#0x0100

	bit	#256,	r7	;#0x0100
	jnz	.L278     	;abs 0x5cd0

	mov	8(r1),	r12	;
	bis	10(r1),	r12	;0x0000a
	bis	12(r1),	r12	;0x0000c
	bis	14(r1),	r12	;0x0000e
	cmp	#0,	r12	;r3 As==00
	jz	.L278     	;abs 0x5cd0

	add	r7,	r15	;
	mov.b	#1,	r13	;r3 As==01
	cmp	r7,	r15	;
	jnc	.L274      	;abs 0x5c9a
	mov	r14,	r13	;

.L274:
	clr.b	r12		;
	add	2(r1),	r13	;
	mov.b	#1,	r14	;r3 As==01
	cmp	2(r1),	r13	;
	jnc	.L275      	;abs 0x5caa
	mov	r12,	r14	;

.L275:
	bis	r14,	r12	;
	clr.b	r14		;
	add	4(r1),	r12	;
	mov.b	#1,	r10	;r3 As==01
	cmp	4(r1),	r12	;
	jnc	.L276      	;abs 0x5cbc
	mov	r14,	r10	;

.L276:
	bis	r10,	r14	;

	mov	r15,	r7	;
	and	#-256,	r7	;#0xff00
	mov	r13,	2(r1)	;
	mov	r12,	4(r1)	;
	add	r14,	6(r1)	;

.L278:
	mov	r7,	94(r1)	; 0x005e
	mov	2(r1),	96(r1)	; 0x0060
	mov	4(r1),	98(r1)	; 0x0062
	mov	6(r1),	100(r1)	; 0x0064

	mov	#3,	88(r1)	; 0x0058

	mova	r1,	r12	;
	adda	#88,	r12	;0x00058
	jmp .L156	;mova	#22508,	r0	;0x057ec



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
	calla	#__unpack_d		;

	mova	r1,	r13	;
	adda	#58,	r13	;0x0003a
	mova	r1,	r12	;
	adda	#36,	r12	;0x00024
	calla	#__unpack_d		;

	mov	44(r1),	r13	;0x0002c

	mov.b	#1,	r12	;r3 As==01
	cmp	r13,	r12	;
	jnc	.L294     	;abs 0x5d58

.L289:
	mova	r1,	r12	;
	adda	#44,	r12	;0x0002c

.L290:
	calla	#__pack_d		;0x0635e

	adda	#72,	r1	;0x00048

	popm.a	#4,	r10	;20-bit words

	reta			;

.L294:
	mov	58(r1),	r12	;0x0003a

	mov.b	#1,	r14	;r3 As==01
	cmp	r12,	r14	;
	jc	.L358    	;abs 0x6040

	xor	60(r1),	46(r1)	;0x0003c, 0x002e

	cmp	#4,	r13	;r2 As==10
	jz	.L299      	;abs 0x5d70

	cmp	#2,	r13	;r3 As==10
	jnz	.L301     	;abs 0x5d7c

.L299:
	cmp	r12,	r13	;
	jnz	.L289     	;abs 0x5d46

	mova	#82944,	r12	;0x14400
	jmp .L290	;mova	#23884,	r0	;0x05d4c

.L301:
	cmp	#4,	r12	;r2 As==10
	jnz	.L305     	;abs 0x5d98

	mov	#0,	50(r1)	;r3 As==00, 0x0032
	mov	#0,	52(r1)	;r3 As==00, 0x0034
	mov	#0,	54(r1)	;r3 As==00, 0x0036
	mov	#0,	56(r1)	;r3 As==00, 0x0038

	mov	#0,	48(r1)	;r3 As==00, 0x0030

	jmp .L289	;mova	#23878,	r0	;0x05d46

.L305:
	cmp	#2,	r12	;r3 As==10
	jnz	.L308     	;abs 0x5da4

	mov	#4,	44(r1)	;r2 As==10, 0x002c

	jmp .L289	;mova	#23878,	r0	;0x05d46

.L308:
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
	jnc	.L313     	;abs 0x5e12
	cmp	6(r1),	16(r1)	; 0x0010
	jnz	.L322    	;abs 0x5e72
	cmp	14(r1),	r7	;0x0000e
	jnc	.L313     	;abs 0x5e12
	cmp	r7,	14(r1)	; 0x000e
	jnz	.L322    	;abs 0x5e72
	cmp	12(r1),	2(r1)	;0x0000c
	jnc	.L313     	;abs 0x5e12
	cmp	2(r1),	12(r1)	; 0x000c
	jnz	.L322    	;abs 0x5e72
	cmp	22(r1),	4(r1)	;0x00016
	jc	.L322     	;abs 0x5e72

.L313:
	mov	4(r1),	r9	;
	rla	r9		;
	mov.b	#1,	r13	;r3 As==01
	cmp	4(r1),	r9	;
	jnc	.L314      	;abs 0x5e22
	clr.b	r13		;

.L314:
	mov	2(r1),	r14	;
	rla	r14		;
	mov.b	#1,	r12	;r3 As==01
	cmp	2(r1),	r14	;
	jnc	.L315      	;abs 0x5e32
	clr.b	r12		;

.L315:
	add	r14,	r13	;
	mov.b	#1,	r15	;r3 As==01
	cmp	r14,	r13	;
	jnc	.L316      	;abs 0x5e3c
	clr.b	r15		;

.L316:
	bis	r15,	r12	;
	mov	r7,	r15	;
	add	r7,	r15	;
	mov.b	#1,	r14	;r3 As==01
	cmp	r7,	r15	;
	jnc	.L317      	;abs 0x5e4a
	clr.b	r14		;

.L317:
	add	r15,	r12	;
	mov.b	#1,	r8	;r3 As==01

	cmp	r15,	r12	;
	jnc	.L319      	;abs 0x5e54
	clr.b	r8		;

.L319:
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

.L322:
	mov	#61,	20(r1)	;#0x003d, 0x0014

	mov	#0,	0(r1)	;r3 As==00
	mov	@r1,	8(r1)	;
	mov	@r1,	10(r1)	; 0x000a
	mov	@r1,	18(r1)	; 0x0012

	mov	@r1,	r8	;
	mov	r8,	24(r1)	; 0x0018
	mov	r8,	r10	;
	mov	#4096,	r11	;#0x1000

.L325:
	cmp	16(r1),	6(r1)	;0x00010
	jnc	.L335    	;abs 0x5f4a
	cmp	6(r1),	16(r1)	; 0x0010
	jnz	.L326     	;abs 0x5ec8
	cmp	14(r1),	r7	;0x0000e
	jnc	.L335    	;abs 0x5f4a
	cmp	r7,	14(r1)	; 0x000e
	jnz	.L326     	;abs 0x5ec8
	cmp	12(r1),	2(r1)	;0x0000c
	jnc	.L335    	;abs 0x5f4a
	cmp	2(r1),	12(r1)	; 0x000c
	jnz	.L326     	;abs 0x5ec8
	cmp	22(r1),	4(r1)	;0x00016
	jnc	.L335    	;abs 0x5f4a

.L326:
	bis	r8,	0(r1)	;

	bis	24(r1),	8(r1)	;0x00018
	bis	r10,	10(r1)	; 0x000a
	bis	r11,	18(r1)	; 0x0012

	mov	4(r1),	r12	;
	sub	22(r1),	r12	;0x00016
	mov	r12,	26(r1)	; 0x001a
	mov.b	#1,	r14	;r3 As==01
	cmp	r12,	4(r1)	;
	jnc	.L329      	;abs 0x5ef0
	clr.b	r14		;

.L329:
	mov	2(r1),	r12	;
	sub	12(r1),	r12	;0x0000c
	mov.b	#1,	r13	;r3 As==01
	cmp	r12,	2(r1)	;
	jnc	.L330      	;abs 0x5f02
	clr.b	r13		;

.L330:
	mov	r12,	r9	;
	sub	r14,	r9	;
	mov.b	#1,	r14	;r3 As==01
	cmp	r9,	r12	;
	jnc	.L331      	;abs 0x5f0e
	clr.b	r14		;

.L331:
	bis	r14,	r13	;
	movx.w	r7,	r14	;
	subx.w	14(r1),	r14	;0x0000e
	mov.b	#1,	r12	;r3 As==01
	cmp	r14,	r7	;
	jnc	.L332      	;abs 0x5f22
	clr.b	r12		;

.L332:
	mov	r14,	r15	;
	sub	r13,	r15	;
	mov.b	#1,	r13	;r3 As==01
	cmp	r15,	r14	;
	jnc	.L333      	;abs 0x5f2e
	clr.b	r13		;

.L333:
	bis	r13,	r12	;
	mov	6(r1),	r13	;
	sub	16(r1),	r13	;0x00010
	mov	26(r1),	4(r1)	;0x0001a

	mov	r9,	2(r1)	;
	mov	r15,	r7	;
	sub	r12,	r13	;
	mov	r13,	6(r1)	;

.L335:
	mov	24(r1),	r9	;0x00018
	mov.b	#1,	r12	;r3 As==01
	calla	#__mspabi_srlll		;0x062ee
	mov	r12,	r8	;
	mov	r13,	24(r1)	; 0x0018
	mov	r14,	r10	;
	mov	r15,	r11	;

	mov	4(r1),	r12	;
	rla	r12		;
	mov.b	#1,	r9	;r3 As==01
	cmp	4(r1),	r12	;
	jnc	.L337      	;abs 0x5f6e
	clr.b	r9		;

.L337:
	mov	2(r1),	r14	;
	rla	r14		;
	mov.b	#1,	r13	;r3 As==01

	cmp	2(r1),	r14	;
	jnc	.L339      	;abs 0x5f7e
	clr.b	r13		;

.L339:
	add	r14,	r9	;
	mov.b	#1,	r15	;r3 As==01
	cmp	r14,	r9	;
	jnc	.L340      	;abs 0x5f88
	clr.b	r15		;

.L340:
	bis	r15,	r13	;
	mov	r7,	r15	;
	add	r7,	r15	;
	mov.b	#1,	r14	;r3 As==01
	cmp	r7,	r15	;
	jnc	.L341      	;abs 0x5f96
	clr.b	r14		;

.L341:
	add	r15,	r13	;
	mov.b	#1,	r7	;r3 As==01

	cmp	r15,	r13	;
	jnc	.L343      	;abs 0x5fa0
	clr.b	r7		;

.L343:
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
	jnz	.L325    	;abs 0x5e94

	mov	@r1,	r15	;
	and.b	#255,	r15	;#0x00ff

	mov	@r1,	r14	;

	cmp.b	#-128,	r14	;#0xff80
	jnz	.L357     	;abs 0x6026

	bit	#256,	r14	;#0x0100
	jnz	.L357     	;abs 0x6026

	bis	r9,	r12	;

	bis	r13,	r12	;
	bis	6(r1),	r12	;
	cmp	#0,	r12	;r3 As==00
	jz	.L357     	;abs 0x6026

	add	r14,	r15	;
	mov.b	#1,	r13	;r3 As==01
	cmp	r14,	r15	;
	jnc	.L352      	;abs 0x5fee
	mov	20(r1),	r13	;0x00014

.L352:
	clr.b	r12		;
	add	8(r1),	r13	;
	mov.b	#1,	r14	;r3 As==01
	cmp	8(r1),	r13	;
	jnc	.L353      	;abs 0x5ffe
	mov	r12,	r14	;

.L353:
	bis	r14,	r12	;
	clr.b	r14		;
	add	10(r1),	r12	;0x0000a
	mov.b	#1,	r10	;r3 As==01

	cmp	10(r1),	r12	;0x0000a
	jnc	.L355      	;abs 0x6010
	mov	r14,	r10	;

.L355:
	bis	r10,	r14	;

	and	#-256,	r15	;#0xff00
	mov	r15,	0(r1)	;
	mov	r13,	8(r1)	;
	mov	r12,	10(r1)	; 0x000a
	add	r14,	18(r1)	; 0x0012

.L357:
	mov	@r1,	50(r1)	; 0x0032
	mov	8(r1),	52(r1)	; 0x0034
	mov	10(r1),	54(r1)	;0x0000a, 0x0036
	mov	18(r1),	56(r1)	;0x00012, 0x0038
	jmp .L289	;mova	#23878,	r0	;0x05d46

.L358:
	mova	r1,	r12	;
	adda	#58,	r12	;0x0003a
	jmp .L290	;mova	#23884,	r0	;0x05d4c



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
	jc	.L371     	;abs 0x60ba

	cmp	30(r1),	r12	;0x0001e
	jc	.L371     	;abs 0x60ba

	mova	r1,	r13	;
	adda	#30,	r13	;0x0001e
	mova	r1,	r12	;
	adda	#16,	r12	;0x00010
	calla	#__fpcmp_parts_d		;0x067a6

.L368:
	adda	#44,	r1	;0x0002c

	popm.a	#1,	r10	;20-bit words

	reta			;

.L371:
	mov.b	#1,	r12	;r3 As==01
	jmp .L368	;mova	#24754,	r0	;0x060b2



	.global __nedf2
	.type __nedf2, @function
__nedf2:
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
	jc	.L384     	;abs 0x6130

	cmp	30(r1),	r12	;0x0001e
	jc	.L384     	;abs 0x6130

	mova	r1,	r13	;
	adda	#30,	r13	;0x0001e
	mova	r1,	r12	;
	adda	#16,	r12	;0x00010
	calla	#__fpcmp_parts_d		;0x067a6

.L381:
	adda	#44,	r1	;0x0002c

	popm.a	#1,	r10	;20-bit words

	reta			;

.L384:
	mov.b	#1,	r12	;r3 As==01
	jmp .L381	;mova	#24872,	r0	;0x06128



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
	jc	.L397     	;abs 0x61a6

	cmp	30(r1),	r12	;0x0001e
	jc	.L397     	;abs 0x61a6

	mova	r1,	r13	;
	adda	#30,	r13	;0x0001e
	mova	r1,	r12	;
	adda	#16,	r12	;0x00010
	calla	#__fpcmp_parts_d		;0x067a6

.L394:
	adda	#44,	r1	;0x0002c

	popm.a	#1,	r10	;20-bit words

	reta			;

.L397:
	mov	#-1,	r12	;r3 As==11
	jmp .L394	;mova	#24990,	r0	;0x0619e



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
	jc	.L410     	;abs 0x621c

	cmp	30(r1),	r12	;0x0001e
	jc	.L410     	;abs 0x621c

	mova	r1,	r13	;
	adda	#30,	r13	;0x0001e
	mova	r1,	r12	;
	adda	#16,	r12	;0x00010
	calla	#__fpcmp_parts_d		;0x067a6

.L407:
	adda	#44,	r1	;0x0002c

	popm.a	#1,	r10	;20-bit words

	reta			;

.L410:
	mov.b	#1,	r12	;r3 As==01
	jmp .L407	;mova	#25108,	r0	;0x06214



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
	jnz	.L422     	;abs 0x6256

	mov	#2,	0(r1)	;r3 As==10

.L418:
	mova	r1,	r12	;
	calla	#__pack_d		;0x0635e

.L419:
	adda	#14,	r1	;0x0000e

	popm.a	#4,	r10	;20-bit words

	reta			;

.L422:
	cmp	#0,	r13	;r3 As==00
	jge	.L429     	;abs 0x62a4

	mov	r14,	r13	;
	cmp	#0,	r14	;r3 As==00
	jnz	.L424      	;abs 0x6266
	cmp	#-32768,r15	;#0x8000
	jz	.L431     	;abs 0x62ac

.L424:
	clr.b	r8		;
	clr.b	r9		;
	sub	r14,	r8	;
	subc	r15,	r9	;

.L425:
	mov	r8,	r12	;
	mov	r9,	r13	;
	calla	#__clzsi2		;0x0630e

	mov	r12,	r7	;
	add	#29,	r7	;#0x001d

	clr.b	r10		;
	mov	r10,	r11	;
	mov	r7,	r12	;
	calla	#__mspabi_sllll		;0x062c2
	mov	r12,	6(r1)	;
	mov	r13,	8(r1)	;
	mov	r14,	10(r1)	; 0x000a
	mov	r15,	12(r1)	; 0x000c

	mov.b	#60,	r12	;#0x003c
	sub	r7,	r12	;
	mov	r12,	4(r1)	;
	jmp .L418	;mova	#25160,	r0	;0x06248

.L429:
	mov	r14,	r8	;
	mov	r13,	r9	;

	jmp .L425	;mova	#25198,	r0	;0x0626e

.L431:
	mov	r14,	r12	;
	mov	#-15904,r15	;#0xc1e0
	jmp .L419	;mova	#25166,	r0	;0x0624e

.L432:
	add	#-1,	r14	;r3 As==11
	rla	r12		;
	rlc	r13		;



	.global __mspabi_slll
	.type __mspabi_slll, @function
__mspabi_slll:
	nop
	nop
	cmp	#0,	r14	;r3 As==00
	jnz	.L432      	;abs 0x62b6
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
	jnz	.L433      	;abs 0x62d2
	reta			;

.L433:
	rla	r12		;
	rlc	r13		;
	rlc	r14		;
	rlc	r15		;
	add	#-1,	r11	;r3 As==11
	jnz	.L433     	;abs 0x62d2
	reta			;

.L434:
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
	jnz	.L434     	;abs 0x62e0
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
	jnz	.L435      	;abs 0x62fe
	reta			;

.L435:
	clrc			
	rrc	r15		;
	rrc	r14		;
	rrc	r13		;
	rrc	r12		;
	add	#-1,	r11	;r3 As==11
	jnz	.L435     	;abs 0x62fe
	reta			;



	.global __clzsi2
	.type __clzsi2, @function
__clzsi2:
	nop
	nop
	pushm.a	#2,	r9	;20-bit words

	mov.b	#255,	r14	;#0x00ff
	cmp	#0,	r13	;r3 As==00
	jnz	.L442     	;abs 0x6344
	cmp	r12,	r14	;
	jc	.L444     	;abs 0x6358
	mov.b	#8,	r14	;r2 As==11

.L437:
	clr.b	r15		;

	mov.b	#32,	r8	;#0x0020
	clr.b	r9		;
	sub	r14,	r8	;
	subc	r15,	r9	;
	calla	#__mspabi_srll		;0x062e8

	push	r13		;
	push	r12		;
	popm.a	#1,	r12	;20-bit words

	mov	r8,	r13	;
	movx.b	82958(r12),r12	;0x1440e
	sub	r12,	r13	;
	mov	r13,	r12	;
	popm.a	#2,	r9	;20-bit words

	reta			;

.L442:
	cmp	r13,	r14	;
	jnc	.L443     	;abs 0x6350
	mov.b	#16,	r14	;#0x0010
	jmp .L437	;mova	#25374,	r0	;0x0631e

.L443:
	mov.b	#24,	r14	;#0x0018
	jmp .L437	;mova	#25374,	r0	;0x0631e

.L444:
	clr.b	r14		;
	jmp .L437	;mova	#25374,	r0	;0x0631e



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
	jnc	.L462     	;abs 0x63e6

	mov	@r1,	r8	;
	mov	4(r1),	r9	;
	mov	6(r1),	r10	;
	mov	2(r1),	r11	;
	mov.b	#8,	r12	;r2 As==11

	calla	#__mspabi_srlll		;0x062ee

	and.b	#7,	r15	;

	mov	r12,	0(r1)	;
	mov	r13,	4(r1)	;
	mov	r14,	6(r1)	;
	bis	#8,	r15	;r2 As==11

	mov	r15,	2(r1)	;

	mov	#2047,	r7	;#0x07ff

.L456:
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

.L462:
	cmp	#4,	r13	;r2 As==10
	jz	.L514    	;abs 0x6636

	cmp	#2,	r13	;r3 As==10
	jz	.L511    	;abs 0x6620

	mov	@r1,	r7	;
	bis	4(r1),	r7	;
	bis	6(r1),	r7	;
	bis	2(r1),	r7	;
	cmp	#0,	r7	;r3 As==00
	jz	.L456     	;abs 0x63b8

	mov	4(r12),	r7	;

	cmp	#-1022,	r7	;#0xfc02
	jge	.L493    	;abs 0x6566

	mov	#-1022,	r12	;#0xfc02

	sub	r7,	r12	;
	mov	r12,	8(r1)	;

	mov.b	#56,	r14	;#0x0038
	cmp	r12,	r14	;
	jl	.L485    	;abs 0x6506

	mov	@r1,	r8	;
	mov	4(r1),	r9	;
	mov	6(r1),	r10	;
	mov	2(r1),	r11	;
	calla	#__mspabi_srlll		;0x062ee

	mov	r12,	12(r1)	; 0x000c
	mov	r13,	14(r1)	; 0x000e
	mov	r14,	16(r1)	; 0x0010
	mov	r15,	18(r1)	; 0x0012

	mov	#-1,	r8	;r3 As==11
	mov	r8,	r9	;
	mov	r8,	r10	;
	mov	r8,	r11	;
	mov	8(r1),	r12	;
	calla	#__mspabi_sllll		;0x062c2
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
	jnz	.L474      	;abs 0x6480
	mov	r15,	r10	;

.L474:
	mov	r11,	r15	;
	sub	r13,	r15	;
	mov.b	#1,	r7	;r3 As==01
	cmp	r13,	r11	;
	jnz	.L475      	;abs 0x648c
	mov	r15,	r7	;

.L475:
	mov	r15,	r9	;
	sub	r10,	r9	;
	mov.b	#1,	r10	;r3 As==01
	cmp	r9,	r15	;
	jnc	.L476      	;abs 0x6498
	clr.b	r10		;

.L476:
	bis	r10,	r7	;
	mov	r11,	r8	;
	sub	r14,	r8	;
	mov.b	#1,	r15	;r3 As==01
	cmp	r14,	r11	;
	jnz	.L477      	;abs 0x64a6
	mov	r8,	r15	;

.L477:
	mov	r8,	r10	;
	sub	r7,	r10	;
	mov.b	#1,	r7	;r3 As==01
	cmp	r10,	r8	;
	jnc	.L478      	;abs 0x64b2
	clr.b	r7		;

.L478:
	bis	r7,	r15	;
	sub	2(r1),	r11	;
	sub	r15,	r11	;
	mov	@r1,	r8	;
	bis	r12,	r8	;
	bis	r13,	r9	;
	bis	r14,	r10	;
	bis	2(r1),	r11	;
	mov.b	#63,	r12	;#0x003f
	calla	#__mspabi_srlll		;0x062ee

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
	jnz	.L486     	;abs 0x650e

	bit	#256,	r8	;#0x0100
	jz	.L490     	;abs 0x6540

	add	r8,	r15	;
	mov.b	#1,	r13	;r3 As==01
	cmp	r8,	r15	;
	jnc	.L487     	;abs 0x651c

.L484:
	clr.b	r13		;
	jmp .L487	;mova	#25884,	r0	;0x0651c

.L485:
	clr.b	r8		;
	mov	r8,	r9	;
	mov	r8,	r10	;
	mov	r8,	r11	;

.L486:
	mov	r8,	r15	;
	add	#127,	r15	;#0x007f
	mov.b	#1,	r13	;r3 As==01
	cmp	#-127,	r8	;#0xff81
	jnc	.L484     	;abs 0x6500

.L487:
	clr.b	r12		;
	add	r9,	r13	;
	mov.b	#1,	r14	;r3 As==01
	cmp	r9,	r13	;
	jnc	.L488      	;abs 0x6528
	mov	r12,	r14	;

.L488:
	bis	r14,	r12	;
	clr.b	r14		;
	add	r10,	r12	;
	mov.b	#1,	r9	;r3 As==01
	cmp	r10,	r12	;
	jnc	.L489      	;abs 0x6536
	mov	r14,	r9	;

.L489:
	bis	r9,	r14	;
	mov	r15,	r8	;
	mov	r13,	r9	;
	mov	r12,	r10	;
	add	r14,	r11	;

.L490:
	mov.b	#1,	r7	;r3 As==01
	mov	#4095,	r12	;#0x0fff
	cmp	r11,	r12	;
	jnc	.L491      	;abs 0x654c
	clr.b	r7		;

.L491:
	mov.b	#8,	r12	;r2 As==11
	calla	#__mspabi_srlll		;0x062ee
	mov	r12,	0(r1)	;
	mov	r13,	4(r1)	;
	mov	r14,	6(r1)	;
	mov	r15,	2(r1)	;

	jmp .L456	;mova	#25528,	r0	;0x063b8

.L493:
	mov	#1023,	r14	;#0x03ff
	cmp	r7,	r14	;
	jl	.L514    	;abs 0x6636

	mov	@r1,	r12	;

	cmp.b	#-128,	r12	;#0xff80
	jnz	.L499     	;abs 0x6590

	bit	#256,	r12	;#0x0100
	jz	.L504     	;abs 0x65d4

	mov	r12,	r10	;
	add	#128,	r10	;#0x0080
	mov.b	#1,	r13	;r3 As==01
	cmp	#-128,	r12	;#0xff80
	jc	.L500     	;abs 0x65a0

.L498:
	clr.b	r13		;
	jmp .L500	;mova	#26016,	r0	;0x065a0

.L499:
	mov	@r1,	r10	;
	add	#127,	r10	;#0x007f
	mov.b	#1,	r13	;r3 As==01
	cmp	#-127,	0(r1)	;#0xff81
	jnc	.L498     	;abs 0x658a

.L500:
	clr.b	r12		;
	add	4(r1),	r13	;
	mov.b	#1,	r14	;r3 As==01
	cmp	4(r1),	r13	;
	jnc	.L501      	;abs 0x65b0
	mov	r12,	r14	;

.L501:
	bis	r14,	r12	;
	clr.b	r14		;
	add	6(r1),	r12	;
	mov.b	#1,	r15	;r3 As==01
	cmp	6(r1),	r12	;
	jnc	.L502      	;abs 0x65c2
	mov	r14,	r15	;

.L502:
	bis	r15,	r14	;
	mov	r10,	0(r1)	;

	mov	r13,	4(r1)	;
	mov	r12,	6(r1)	;
	add	r14,	2(r1)	;

.L504:
	mov	#8191,	r14	;#0x1fff
	cmp	2(r1),	r14	;
	jnc	.L507     	;abs 0x65f4

	add	#1023,	r7	;#0x03ff

.L506:
	mov	@r1,	r8	;
	mov	4(r1),	r9	;
	mov	6(r1),	r10	;
	mov	2(r1),	r11	;
	jmp .L491	;mova	#25932,	r0	;0x0654c

.L507:
	mov	@r1,	r8	;
	mov	4(r1),	r9	;
	mov	6(r1),	r10	;
	mov	2(r1),	r11	;
	mov.b	#1,	r12	;r3 As==01
	calla	#__mspabi_srlll		;0x062ee
	mov	r12,	0(r1)	;

	mov	r13,	4(r1)	;
	mov	r14,	6(r1)	;
	mov	r15,	2(r1)	;

	add	#1024,	r7	;#0x0400

	jmp .L506	;mova	#26082,	r0	;0x065e2

.L511:
	clr.b	r7		;

	mov	r7,	0(r1)	;

	mov	r7,	4(r1)	;
	mov	r7,	6(r1)	;
	mov	r7,	2(r1)	;
	jmp .L456	;mova	#25528,	r0	;0x063b8

.L514:
	mov	#2047,	r7	;#0x07ff

	mov	#0,	0(r1)	;r3 As==00

	mov	@r1,	4(r1)	;
	mov	@r1,	6(r1)	;
	mov	@r1,	2(r1)	;
	jmp .L456	;mova	#25528,	r0	;0x063b8



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
	jnz	.L549    	;abs 0x672c

	mov	r8,	r12	;
	bis	r9,	r12	;
	bis	r10,	r12	;
	bis	r11,	r12	;
	cmp	#0,	r12	;r3 As==00
	jnz	.L531     	;abs 0x66a0

	mov	#2,	0(r7)	;r3 As==10

.L528:
	adda	#6,	r1	;

	popm.a	#4,	r10	;20-bit words

	reta			;

.L531:
	mov.b	#8,	r12	;r2 As==11
	calla	#__mspabi_sllll		;0x062c2

	mov	r12,	r10	;

	mov	#3,	0(r7)	;

	mov	#-1023,	4(r1)	;#0xfc01

	mov.b	#1,	r8	;r3 As==01

.L536:
	mov	r10,	r9	;
	add	r10,	r9	;
	mov	r9,	2(r1)	;
	mov	r8,	r11	;
	cmp	r10,	r9	;
	jnc	.L537      	;abs 0x66c6
	clr.b	r11		;

.L537:
	mov	r13,	r10	;

	add	r13,	r10	;
	mov.b	#1,	r12	;r3 As==01
	cmp	r13,	r10	;
	jnc	.L539      	;abs 0x66d2
	clr.b	r12		;

.L539:
	add	r10,	r11	;
	mov	r8,	r13	;
	cmp	r10,	r11	;
	jnc	.L540      	;abs 0x66dc
	clr.b	r13		;

.L540:
	bis	r13,	r12	;
	mov	r14,	r13	;
	add	r14,	r13	;
	mov.b	#1,	r9	;r3 As==01
	cmp	r14,	r13	;
	jnc	.L541      	;abs 0x66ea
	clr.b	r9		;

.L541:
	add	r13,	r12	;
	mov	r8,	r14	;
	cmp	r13,	r12	;
	jnc	.L542      	;abs 0x66f4
	clr.b	r14		;

.L542:
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
	jc	.L536     	;abs 0x66b6

	mov	@r1,	4(r7)	;

	mov	r10,	6(r7)	;
	mov	r11,	8(r7)	;
	mov	r12,	10(r7)	; 0x000a

.L547:
	mov	r15,	12(r7)	; 0x000c

	jmp .L528	;mova	#26264,	r0	;0x06698

.L549:
	cmp	#2047,	2(r1)	;#0x07ff
	jnz	.L557     	;abs 0x677a

	mov	r8,	r12	;
	bis	r9,	r12	;
	bis	r10,	r12	;
	bis	r11,	r12	;
	cmp	#0,	r12	;r3 As==00
	jnz	.L552     	;abs 0x6748

	mov	#4,	0(r7)	;r2 As==10
	jmp .L528	;mova	#26264,	r0	;0x06698

.L552:
	mov	r13,	r12	;
	and.b	#8,	r12	;r2 As==11
	bit	#8,	r13	;r2 As==11
	jz	.L556     	;abs 0x6772

	mov	#1,	0(r7)	;r3 As==01

.L554:
	mov.b	#8,	r12	;r2 As==11
	calla	#__mspabi_sllll		;0x062c2

	and	#-256,	r12	;#0xff00
	mov	r12,	6(r7)	;
	mov	r13,	8(r7)	;
	mov	r14,	10(r7)	; 0x000a
	and	#-2049,	r15	;#0xf7ff
	jmp .L547	;mova	#26404,	r0	;0x06724

.L556:
	mov	r12,	0(r7)	;
	jmp .L554	;mova	#26452,	r0	;0x06754

.L557:
	mov	2(r1),	r12	;
	add	#-1023,	r12	;#0xfc01
	mov	r12,	4(r7)	;

	mov	#3,	0(r7)	;

	mov.b	#8,	r12	;r2 As==11
	calla	#__mspabi_sllll		;0x062c2

	mov	r12,	6(r7)	;
	mov	r13,	8(r7)	;
	mov	r14,	10(r7)	; 0x000a
	bis	#4096,	r15	;#0x1000
	jmp .L547	;mova	#26404,	r0	;0x06724



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
	jc	.L575     	;abs 0x67d8

	mov	@r14,	r15	;

	cmp	r15,	r10	;
	jc	.L575     	;abs 0x67d8

	cmp	#4,	r13	;r2 As==10
	jnz	.L573     	;abs 0x67ce

	mov	2(r12),	r13	;

	cmp	#4,	r15	;r2 As==10
	jnz	.L581     	;abs 0x67f4

	mov	2(r14),	r12	;

	sub	r13,	r12	;

.L571:
	popm.a	#4,	r10	;20-bit words

	reta			;

.L573:
	cmp	#4,	r15	;r2 As==10
	jnz	.L576     	;abs 0x67de

.L574:
	cmp	#0,	2(r14)	;r3 As==00
	jz	.L582     	;abs 0x67f8

.L575:
	mov.b	#1,	r12	;r3 As==01
	jmp .L571	;mova	#26570,	r0	;0x067ca

.L576:
	cmp	#2,	r13	;r3 As==10
	jnz	.L579     	;abs 0x67ec

	cmp	#2,	r15	;r3 As==10
	jnz	.L574     	;abs 0x67d2

.L578:
	clr.b	r12		;
	jmp .L571	;mova	#26570,	r0	;0x067ca

.L579:
	mov	2(r12),	r13	;

	cmp	#2,	r15	;r3 As==10
	jnz	.L583     	;abs 0x67fe

.L581:
	cmp	#0,	r13	;r3 As==00
	jz	.L575     	;abs 0x67d8

.L582:
	mov	#-1,	r12	;r3 As==11
	jmp .L571	;mova	#26570,	r0	;0x067ca

.L583:
	cmp	r13,	2(r14)	;
	jnz	.L581     	;abs 0x67f4

	mov	4(r12),	r10	;

	mov	4(r14),	r15	;

	cmp	r10,	r15	;
	jl	.L581     	;abs 0x67f4

	cmp	r15,	r10	;
	jge	.L589     	;abs 0x681c

.L588:
	cmp	#0,	r13	;r3 As==00
	jz	.L582     	;abs 0x67f8
	jmp .L575	;mova	#26584,	r0	;0x067d8

.L589:
	mov	6(r12),	r7	;
	mov	8(r12),	r15	;
	mov	10(r12),r11	;0x0000a
	mov	12(r12),r9	;0x0000c

	mov	6(r14),	r8	;
	mov	8(r14),	r12	;

	mov	10(r14),r10	;0x0000a
	mov	12(r14),r14	;0x0000c

	cmp	r9,	r14	;
	jnc	.L581     	;abs 0x67f4
	cmp	r14,	r9	;
	jnz	.L593     	;abs 0x6858
	cmp	r11,	r10	;
	jnc	.L581     	;abs 0x67f4
	cmp	r10,	r11	;
	jnz	.L593     	;abs 0x6858
	cmp	r15,	r12	;
	jnc	.L581     	;abs 0x67f4
	cmp	r12,	r15	;
	jnz	.L593      	;abs 0x6858
	cmp	r7,	r8	;
	jnc	.L581     	;abs 0x67f4

.L593:
	cmp	r14,	r9	;
	jnc	.L588     	;abs 0x6814
	cmp	r9,	r14	;
	jnz	.L578    	;abs 0x67e6
	cmp	r10,	r11	;
	jnc	.L588     	;abs 0x6814
	cmp	r11,	r10	;
	jnz	.L578    	;abs 0x67e6
	cmp	r12,	r15	;
	jnc	.L588     	;abs 0x6814
	cmp	r15,	r12	;
	jnz	.L578    	;abs 0x67e6
	cmp	r8,	r7	;
	jc	.L578    	;abs 0x67e6
	jmp .L588	;mova	#26644,	r0	;0x06814



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

.L597:
	cmpa	r12,	r15	;
	jnz	.L602     	;abs 0x688e

	mova	r8,	r12	;

	popm.a	#1,	r8	;20-bit words

	popm.a	#1,	r10	;20-bit words

	reta			;

.L602:
	mova	r8,	r14	;
	adda	r12,	r14	;

	mova	r13,	r10	;
	adda	r12,	r10	;

	mov.b	@r10,	0(r14)	;
	adda	#1,	r12	;

	jmp .L597	;mova	#26754,	r0	;0x06882



	.global srand
	.type srand, @function
srand:
	nop
	nop
	pushm.a	#1,	r10	;20-bit words

	pushm.a	#1,	r8	;20-bit words

	mov	r12,	r10	;

	mova	&11264,	r8	;0x02c00

	cmpx.a	#0,	44(r8)	;r3 As==00, 0x0002c
	jnz	.L621     	;abs 0x68fa

	mov.b	#22,	r12	;#0x0016

	calla	#malloc		;0x069dc

	mova	r12,	44(r8)	; 0x0002c

	mov	#13070,	0(r12)	;#0x330e

	mov	#-21555,2(r12)	;#0xabcd

	mov	#4660,	4(r12)	;#0x1234

	mov	#-6547,	6(r12)	;#0xe66d

	mov	#-8468,	8(r12)	;#0xdeec

	mov	#5,	10(r12)	; 0x000a

	mov	#11,	12(r12)	;#0x000b, 0x000c

	mov	#1,	14(r12)	;r3 As==01, 0x000e
	mov	#0,	16(r12)	;r3 As==00, 0x0010
	mov	#0,	18(r12)	;r3 As==00, 0x0012
	mov	#0,	20(r12)	;r3 As==00, 0x0014

.L621:
	mova	44(r8),	r12	;0x0002c
	clr.b	r13		;
	mov	r10,	14(r12)	; 0x000e
	mov	r13,	16(r12)	; 0x0010
	mov	r13,	18(r12)	; 0x0012
	mov	r13,	20(r12)	; 0x0014

	popm.a	#1,	r8	;20-bit words

	popm.a	#1,	r10	;20-bit words

	reta			;



	.global rand
	.type rand, @function
rand:
	nop
	nop
	pushm.a	#4,	r10	;20-bit words

	mova	&11264,	r10	;0x02c00

	cmpx.a	#0,	44(r10)	;r3 As==00, 0x0002c
	jnz	.L637     	;abs 0x696a

	mov.b	#22,	r12	;#0x0016
	calla	#malloc		;0x069dc

	mova	r12,	44(r10)	; 0x0002c

	mov	#13070,	0(r12)	;#0x330e

	mov	#-21555,2(r12)	;#0xabcd

	mov	#4660,	4(r12)	;#0x1234

	mov	#-6547,	6(r12)	;#0xe66d

	mov	#-8468,	8(r12)	;#0xdeec

	mov	#5,	10(r12)	; 0x000a

	mov	#11,	12(r12)	;#0x000b, 0x000c

	mov	#1,	14(r12)	;r3 As==01, 0x000e
	mov	#0,	16(r12)	;r3 As==00, 0x0010
	mov	#0,	18(r12)	;r3 As==00, 0x0012
	mov	#0,	20(r12)	;r3 As==00, 0x0014

.L637:
	mova	44(r10),r7	;0x0002c

	mov	#32557,	r12	;#0x7f2d
	mov	#19605,	r13	;#0x4c95
	mov	#-3027,	r14	;#0xf42d
	mov	#22609,	r15	;#0x5851
	mov	14(r7),	r8	;0x0000e
	mov	16(r7),	r9	;0x00010
	mov	18(r7),	r10	;0x00012

	mov	20(r7),	r11	;0x00014
	calla	#__mspabi_mpyll		;0x081e4

	mov	r12,	r8	;
	inc	r8		;
	mov.b	#1,	r9	;r3 As==01
	cmp	#-1,	r12	;r3 As==11
	jc	.L641      	;abs 0x699e
	clr.b	r9		;

.L641:
	clr.b	r10		;
	add	r13,	r9	;
	mov.b	#1,	r12	;r3 As==01
	cmp	r13,	r9	;
	jnc	.L642      	;abs 0x69aa
	mov	r10,	r12	;

.L642:
	bis	r12,	r10	;
	clr.b	r11		;
	add	r14,	r10	;
	mov.b	#1,	r12	;r3 As==01
	cmp	r14,	r10	;
	jnc	.L643      	;abs 0x69b8
	mov	r11,	r12	;

.L643:
	bis	r12,	r11	;
	add	r15,	r11	;

	mov	r8,	14(r7)	; 0x000e
	mov	r9,	16(r7)	; 0x0010
	mov	r10,	18(r7)	; 0x0012
	mov	r11,	20(r7)	; 0x0014

	mov.b	#32,	r12	;#0x0020
	calla	#__mspabi_srlll		;0x062ee

	and	#32767,	r12	;#0x7fff
	popm.a	#4,	r10	;20-bit words

	reta			;



	.global malloc
	.type malloc, @function
malloc:
	nop
	nop
	mova	r12,	r13	;
	mova	&11264,	r12	;0x02c00

	calla	#_malloc_r		;0x069e8

	reta			;



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
	jc	.L655      	;abs 0x6a08
	mov.b	#12,	r10	;#0x000c

.L655:
	cmpa	r12,	r10	;
	jc	.L660     	;abs 0x6a18

.L656:
	mov	#12,	0(r9)	;#0x000c

	clr.b	r12		;

.L658:
	popm.a	#4,	r10	;20-bit words

	reta			;

.L660:
	mova	&11578,	r12	;0x02d3a

	mova	r12,	r8	;

	movx.w	r10,	r14	;

.L663:
	cmpa	#0,	r8	;
	jnz	.L676     	;abs 0x6a70


	cmpx.a	#0,	&0x02d36;r3 As==00
	jnz	.L669     	;abs 0x6a3e

	mova	r8,	r13	;
	mova	r9,	r12	;

	calla	#_sbrk_r		;

	mova	r12,	&11574	; 0x02d36

.L669:
	mova	r10,	r13	;
	mova	r9,	r12	;
	calla	#_sbrk_r		;

	cmpa	#1048575,r12	;0xfffff
	jz	.L656     	;abs 0x6a0c

	mova	r12,	r8	;
	adda	#3,	r8	;
	andx.a	#-4,	r8	;0xffffc

	cmpa	r8,	r12	;
	jz	.L682     	;abs 0x6a98

	movx.a	r8,	r13	;
	subx.a	r12,	r13	;
	mova	r9,	r12	;

	calla	#_sbrk_r		;

	cmpa	#1048575,r12	;0xfffff
	jnz	.L682     	;abs 0x6a98
	jmp .L656	;mova	#27148,	r0	;0x06a0c

.L676:
	mov	@r8,	r13	;
	sub	r14,	r13	;

	cmp	#0,	r13	;r3 As==00
	jl	.L696    	;abs 0x6b06

	mov.b	#11,	r14	;#0x000b
	cmp	r13,	r14	;
	jge	.L683     	;abs 0x6aae

	mov	r13,	r14	;
	mov	r13,	r15	;
	rpt #15 { rrax.w	r15		;
	mov	r14,	0(r8)	;
	mov	r15,	2(r8)	;

	mov	r13,	r15	;
	rlam.a	#4,	r15	;
	rram.a	#4,	r15	;

	adda	r15,	r8	;

.L682:
	pushm.a	#1,	r10	;20-bit words
	popx.w	r12		;
	popx.w	r13		;
	mov	r12,	0(r8)	;
	mov	r13,	2(r8)	;
	jmp .L686	;mova	#27322,	r0	;0x06aba

.L683:
	mova	4(r8),	r14	;

	cmpa	r8,	r12	;
	jnz	.L695     	;abs 0x6afe

	mova	r14,	&11578	; 0x02d3a

.L686:
	mova	r8,	r12	;
	adda	#11,	r12	;0x0000b
	andx.a	#-8,	r12	;0xffff8

	mova	r8,	r10	;

	adda	#4,	r10	;
	movx.a	r12,	r14	;
	subx.a	r10,	r14	;

	movx.w	r14,	r14	;

	cmp	#0,	r14	;r3 As==00
	jz	.L658    	;abs 0x6a14

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
	jmp .L658	;mova	#27156,	r0	;0x06a14

.L695:
	mova	r14,	4(r12)	;
	jmp .L686	;mova	#27322,	r0	;0x06aba

.L696:
	mova	r8,	r12	;
	mova	4(r8),	r8	;

	jmp .L663	;mova	#27170,	r0	;0x06a22



	.global _sbrk_r
	.type _sbrk_r, @function
_sbrk_r:
	nop
	nop
	pushm.a	#1,	r10	;20-bit words

	mova	r12,	r10	;
	mova	r13,	r12	;

	movx.w	#0,	&0x02d3e;r3 As==00

	calla	#_sbrk		;0x083f0

	cmpa	#1048575,r12	;0xfffff
	jnz	.L705     	;abs 0x6b34

	movx.w	&0x02d3e,r13	;

	cmp	#0,	r13	;r3 As==00
	jz	.L705      	;abs 0x6b34

	mov	r13,	0(r10)	;

.L705:
	popm.a	#1,	r10	;20-bit words

	reta			;



	.global atan
	.type atan, @function
atan:
	nop
	nop
	pushm.a	#4,	r10	;20-bit words

	suba	#38,	r1	;0x00026

	mov	r12,	8(r1)	;
	mov	r13,	10(r1)	; 0x000a
	mov	r14,	12(r1)	; 0x000c
	mov	r15,	r7	;

	mov	r14,	r9	;
	mov	r15,	36(r1)	; 0x0024

	mov	r14,	r8	;
	mov	r15,	r10	;
	and	#32767,	r10	;#0x7fff

	mov	#17423,	r11	;#0x440f
	cmp	r10,	r11	;
	jl	.L763    	;abs 0x6f02

	mov	#16347,	r8	;#0x3fdb
	cmp	r10,	r8	;
	jl	.L713      	;abs 0x6b6e
	jmp .L777	;mova	#28558,	r0	;0x06f8e

.L713:
	calla	#fabs		;0x071a8

	mov	r12,	8(r1)	;
	mov	r13,	10(r1)	; 0x000a
	mov	r14,	12(r1)	; 0x000c
	mov	r15,	r7	;

	mov	#16370,	r8	;#0x3ff2
	cmp	r10,	r8	;
	jge	.L716      	;abs 0x6b8c
	jmp .L792	;mova	#28742,	r0	;0x07046

.L716:
	mov	#16357,	r9	;#0x3fe5

	cmp	r10,	r9	;
	jge	.L718      	;abs 0x6b98
	jmp .L784	;mova	#28640,	r0	;0x06fe0

.L718:
	mov	r12,	r8	;
	mov	r13,	r9	;
	mov	r14,	r10	;
	mov	r15,	r11	;
	calla	#__mspabi_addd		;0x056b4

	mov	r12,	r8	;

	mov	r13,	r9	;

	mov	r14,	r10	;

	mov	r15,	r11	;

	clr.b	r12		;
	mov	r12,	r13	;
	mov	r12,	r14	;
	mov	#16368,	r15	;#0x3ff0
	calla	#__mspabi_subd		;0x05718
	mov	r12,	14(r1)	; 0x000e
	mov	r13,	18(r1)	; 0x0012
	mov	r14,	20(r1)	; 0x0014
	mov	r15,	22(r1)	; 0x0016

	clr.b	r12		;
	mov	r12,	r13	;
	mov	r12,	r14	;
	mov	#16384,	r15	;#0x4000
	mov	8(r1),	r8	;
	mov	10(r1),	r9	;0x0000a
	mov	12(r1),	r10	;0x0000c
	mov	r7,	r11	;
	calla	#__mspabi_addd		;0x056b4

	mov	14(r1),	r8	;0x0000e
	mov	18(r1),	r9	;0x00012
	mov	20(r1),	r10	;0x00014
	mov	22(r1),	r11	;0x00016
	calla	#__mspabi_divd		;0x05cf6
	mov	r12,	8(r1)	;

	mov	r13,	10(r1)	; 0x000a
	mov	r14,	12(r1)	; 0x000c
	mov	r15,	r7	;

	mov	#0,	24(r1)	;r3 As==00, 0x0018

.L728:
	mov	#0,	26(r1)	;r3 As==00, 0x001a

.L729:
	mov	8(r1),	r12	;
	mov	10(r1),	r13	;0x0000a
	mov	12(r1),	r14	;0x0000c
	mov	r7,	r15	;
	mov	r12,	r8	;
	mov	r13,	r9	;
	mov	r14,	r10	;
	mov	r7,	r11	;
	calla	#__mspabi_mpyd		;0x05780
	mov	r12,	28(r1)	; 0x001c
	mov	r13,	30(r1)	; 0x001e
	mov	r14,	32(r1)	; 0x0020
	mov	r15,	34(r1)	; 0x0022

	mov	r12,	r8	;
	mov	r13,	r9	;
	mov	r14,	r10	;
	mov	r15,	r11	;
	calla	#__mspabi_mpyd		;0x05780

	mov	r12,	14(r1)	; 0x000e
	mov	r13,	18(r1)	; 0x0012
	mov	r14,	20(r1)	; 0x0014
	mov	r15,	22(r1)	; 0x0016

	mov	#-9711,	r12	;#0xda11

	mov	#-7390,	r13	;#0xe322

	mov	#-21190,r14	;#0xad3a

	mov	#16272,	r15	;#0x3f90

	mov	14(r1),	r8	;0x0000e

	mov	18(r1),	r9	;0x00012

	mov	20(r1),	r10	;0x00014

	mov	22(r1),	r11	;0x00016
	calla	#__mspabi_mpyd		;0x05780
	mov	r12,	r8	;
	mov	r13,	r9	;
	mov	r14,	r10	;
	mov	r15,	r11	;

	mov	#3563,	r12	;#0x0deb
	mov	#9334,	r13	;#0x2476
	mov	#31563,	r14	;#0x7b4b
	mov	#16297,	r15	;#0x3fa9
	calla	#__mspabi_addd		;0x056b4
	mov	r12,	r8	;
	mov	r13,	r9	;
	mov	r14,	r10	;
	mov	r15,	r11	;

	mov	14(r1),	r12	;0x0000e
	mov	18(r1),	r13	;0x00012
	mov	20(r1),	r14	;0x00014
	mov	22(r1),	r15	;0x00016
	calla	#__mspabi_mpyd		;0x05780
	mov	r12,	r8	;
	mov	r13,	r9	;
	mov	r14,	r10	;
	mov	r15,	r11	;

	mov	#15697,	r12	;#0x3d51
	mov	#-24368,r13	;#0xa0d0
	mov	#3430,	r14	;#0x0d66
	mov	#16305,	r15	;#0x3fb1
	calla	#__mspabi_addd		;0x056b4
	mov	r12,	r8	;
	mov	r13,	r9	;
	mov	r14,	r10	;
	mov	r15,	r11	;

	mov	14(r1),	r12	;0x0000e
	mov	18(r1),	r13	;0x00012
	mov	20(r1),	r14	;0x00014
	mov	22(r1),	r15	;0x00016
	calla	#__mspabi_mpyd		;0x05780
	mov	r12,	r8	;
	mov	r13,	r9	;
	mov	r14,	r10	;
	mov	r15,	r11	;

	mov	#8302,	r12	;#0x206e
	mov	#-15028,r13	;#0xc54c
	mov	#17869,	r14	;#0x45cd
	mov	#16311,	r15	;#0x3fb7
	calla	#__mspabi_addd		;0x056b4
	mov	r12,	r8	;
	mov	r13,	r9	;
	mov	r14,	r10	;
	mov	r15,	r11	;

	mov	14(r1),	r12	;0x0000e
	mov	18(r1),	r13	;0x00012
	mov	20(r1),	r14	;0x00014
	mov	22(r1),	r15	;0x00016
	calla	#__mspabi_mpyd		;0x05780
	mov	r12,	r8	;
	mov	r13,	r9	;
	mov	r14,	r10	;
	mov	r15,	r11	;

	mov	#-31745,r12	;#0x83ff
	mov	#-28160,r13	;#0x9200
	mov	#18724,	r14	;#0x4924
	mov	#16322,	r15	;#0x3fc2
	calla	#__mspabi_addd		;0x056b4
	mov	r12,	r8	;
	mov	r13,	r9	;
	mov	r14,	r10	;
	mov	r15,	r11	;

	mov	14(r1),	r12	;0x0000e
	mov	18(r1),	r13	;0x00012
	mov	20(r1),	r14	;0x00014
	mov	22(r1),	r15	;0x00016
	calla	#__mspabi_mpyd		;0x05780
	mov	r12,	r8	;
	mov	r13,	r9	;
	mov	r14,	r10	;
	mov	r15,	r11	;

	mov	#21773,	r12	;#0x550d
	mov	#21845,	r13	;#0x5555
	mov	r13,	r14	;
	mov	#16341,	r15	;#0x3fd5
	calla	#__mspabi_addd		;0x056b4
	mov	r12,	r8	;
	mov	r13,	r9	;
	mov	r14,	r10	;
	mov	r15,	r11	;

	mov	28(r1),	r12	;0x0001c
	mov	30(r1),	r13	;0x0001e
	mov	32(r1),	r14	;0x00020
	mov	34(r1),	r15	;0x00022
	calla	#__mspabi_mpyd		;0x05780
	mov	r12,	28(r1)	; 0x001c

	mov	r13,	30(r1)	; 0x001e
	mov	r14,	32(r1)	; 0x0020
	mov	r15,	34(r1)	; 0x0022

	mov	#27695,	r12	;#0x6c2f
	mov	#11370,	r13	;#0x2c6a
	mov	#-19388,r14	;#0xb444
	mov	#-16478,r15	;#0xbfa2
	mov	14(r1),	r8	;0x0000e
	mov	18(r1),	r9	;0x00012
	mov	20(r1),	r10	;0x00014
	mov	22(r1),	r11	;0x00016
	calla	#__mspabi_mpyd		;0x05780
	mov	r12,	r8	;
	mov	r13,	r9	;
	mov	r14,	r10	;
	mov	r15,	r11	;

	mov	#-614,	r12	;#0xfd9a
	mov	#21214,	r13	;#0x52de
	mov	#-8659,	r14	;#0xde2d
	mov	#16301,	r15	;#0x3fad
	calla	#__mspabi_subd		;0x05718
	mov	r12,	r8	;
	mov	r13,	r9	;
	mov	r14,	r10	;
	mov	r15,	r11	;

	mov	14(r1),	r12	;0x0000e
	mov	18(r1),	r13	;0x00012
	mov	20(r1),	r14	;0x00014
	mov	22(r1),	r15	;0x00016
	calla	#__mspabi_mpyd		;0x05780
	mov	r12,	r8	;
	mov	r13,	r9	;
	mov	r14,	r10	;
	mov	r15,	r11	;

	mov	#-26003,r12	;#0x9a6d
	mov	#-20620,r13	;#0xaf74
	mov	#-20238,r14	;#0xb0f2
	mov	#16307,	r15	;#0x3fb3
	calla	#__mspabi_subd		;0x05718
	mov	r12,	r8	;
	mov	r13,	r9	;
	mov	r14,	r10	;
	mov	r15,	r11	;

	mov	14(r1),	r12	;0x0000e
	mov	18(r1),	r13	;0x00012
	mov	20(r1),	r14	;0x00014
	mov	22(r1),	r15	;0x00016
	calla	#__mspabi_mpyd		;0x05780
	mov	r12,	r8	;
	mov	r13,	r9	;
	mov	r14,	r10	;
	mov	r15,	r11	;

	mov	#5745,	r12	;#0x1671
	mov	#-477,	r13	;#0xfe23
	mov	#29126,	r14	;#0x71c6
	mov	#16316,	r15	;#0x3fbc
	calla	#__mspabi_subd		;0x05718
	mov	r12,	r8	;
	mov	r13,	r9	;
	mov	r14,	r10	;
	mov	r15,	r11	;

	mov	14(r1),	r12	;0x0000e
	mov	18(r1),	r13	;0x00012
	mov	20(r1),	r14	;0x00014
	mov	22(r1),	r15	;0x00016
	calla	#__mspabi_mpyd		;0x05780
	mov	r12,	r8	;
	mov	r13,	r9	;
	mov	r14,	r10	;
	mov	r15,	r11	;

	mov	#-5180,	r12	;#0xebc4
	mov	#-26216,r13	;#0x9998
	mov	#-26215,r14	;#0x9999
	mov	#16329,	r15	;#0x3fc9
	calla	#__mspabi_subd		;0x05718
	mov	r12,	r8	;
	mov	r13,	r9	;
	mov	r14,	r10	;
	mov	r15,	r11	;

	mov	14(r1),	r12	;0x0000e
	mov	18(r1),	r13	;0x00012
	mov	20(r1),	r14	;0x00014
	mov	22(r1),	r15	;0x00016
	calla	#__mspabi_mpyd		;0x05780
	mov	28(r1),	r8	;0x0001c
	mov	30(r1),	r9	;0x0001e
	mov	32(r1),	r10	;0x00020
	mov	34(r1),	r11	;0x00022
	calla	#__mspabi_addd		;0x056b4
	mov	r12,	r8	;
	mov	r13,	r9	;
	mov	r14,	r10	;
	mov	r15,	r11	;
	mov	8(r1),	r12	;
	mov	10(r1),	r13	;0x0000a
	mov	12(r1),	r14	;0x0000c
	mov	r7,	r15	;
	calla	#__mspabi_mpyd		;0x05780
	mov	r12,	18(r1)	; 0x0012

	mov	r13,	r9	;
	mov	r14,	r10	;
	mov	r15,	r11	;

	mov	24(r1),	r8	;0x00018
	cmp	#-1,	r8	;r3 As==11
	jnz	.L809    	;abs 0x710a
	mov	26(r1),	r8	;0x0001a
	cmp	#-1,	r8	;r3 As==11
	jnz	.L809    	;abs 0x710a

	mov	8(r1),	r8	;
	mov	10(r1),	r9	;0x0000a
	mov	12(r1),	r10	;0x0000c
	mov	r7,	r11	;
	calla	#__mspabi_subd		;0x05718
	jmp .L771	;mova	#28482,	r0	;0x06f42

.L763:
	mov	#32752,	r11	;#0x7ff0
	cmp	r10,	r11	;
	jl	.L767     	;abs 0x6f28
	cmp	r11,	r10	;
	jnz	.L764      	;abs 0x6f12
	cmp	#0,	r14	;r3 As==00
	jnz	.L767     	;abs 0x6f28

.L764:
	cmp	#0,	r8	;r3 As==00
	jnz	.L772     	;abs 0x6f54
	cmp	#32752,	r10	;#0x7ff0
	jnz	.L772     	;abs 0x6f54

	mov	8(r1),	r12	;

	bis	10(r1),	r12	;0x0000a
	cmp	#0,	r12	;r3 As==00
	jz	.L772     	;abs 0x6f54

.L767:
	mov	8(r1),	r12	;
	mov	10(r1),	r13	;0x0000a
	mov	12(r1),	r14	;0x0000c
	mov	r7,	r15	;
	mov	r12,	r8	;

	mov	r13,	r9	;

	mov	r14,	r10	;

	mov	r7,	r11	;
	calla	#__mspabi_addd		;0x056b4

.L771:
	mov	r12,	8(r1)	;
	mov	r13,	10(r1)	; 0x000a
	mov	r14,	12(r1)	; 0x000c
	mov	r15,	r7	;
	jmp .L774	;mova	#28536,	r0	;0x06f78

.L772:
	clr.b	r12		;
	cmp	r7,	r12	;
	jl	.L817    	;abs 0x718e
	cmp	r12,	r7	;
	jnz	.L773      	;abs 0x6f62
	cmp	r12,	r9	;
	jnz	.L817    	;abs 0x718e

.L773:
	mov	#11544,	8(r1)	;#0x2d18
	mov	#21572,	10(r1)	;#0x5444, 0x000a
	mov	#8699,	12(r1)	;#0x21fb, 0x000c
	mov	#-16391,r7	;#0xbff9

.L774:
	mov	8(r1),	r12	;
	mov	10(r1),	r13	;0x0000a
	mov	12(r1),	r14	;0x0000c
	mov	r7,	r15	;
	adda	#38,	r1	;0x00026

	popm.a	#4,	r10	;20-bit words

	reta			;

.L777:
	mov	#15903,	r13	;#0x3e1f
	cmp	r10,	r13	;
	jl	.L783     	;abs 0x6fd4

	mov	#30108,	r12	;#0x759c

	mov	#-30720,r13	;#0x8800
	mov	#-7108,	r14	;#0xe43c
	mov	#32311,	r15	;#0x7e37
	mov	8(r1),	r8	;
	mov	10(r1),	r9	;0x0000a

	mov	12(r1),	r10	;0x0000c

	mov	r7,	r11	;
	calla	#__mspabi_addd		;0x056b4

	clr.b	r10		;
	mov	r10,	0(r1)	;
	mov	r10,	2(r1)	;
	mov	r10,	4(r1)	;
	mov	#16368,	6(r1)	;#0x3ff0
	calla	#__gtdf2		;0x06136
	cmp	r12,	r10	;
	jl	.L774     	;abs 0x6f78

.L783:
	mov	#-1,	24(r1)	;r3 As==11, 0x0018
	mov	#-1,	26(r1)	;r3 As==11, 0x001a
	jmp .L729	;mova	#27664,	r0	;0x06c10

.L784:
	clr.b	r12		;

	mov	r12,	r13	;

	mov	r12,	r14	;

	mov	#16368,	r15	;#0x3ff0
	mov	8(r1),	r8	;
	mov	10(r1),	r9	;0x0000a
	mov	12(r1),	r10	;0x0000c
	mov	r7,	r11	;
	calla	#__mspabi_subd		;0x05718
	mov	r12,	8(r1)	;

	mov	r13,	10(r1)	; 0x000a
	mov	r14,	12(r1)	; 0x000c
	mov	r15,	14(r1)	; 0x000e

	clr.b	r12		;
	mov	r12,	r13	;
	mov	r12,	r14	;
	mov	#16368,	r15	;#0x3ff0
	mov	r7,	r11	;
	calla	#__mspabi_addd		;0x056b4

	mov	8(r1),	r8	;
	mov	10(r1),	r9	;0x0000a
	mov	12(r1),	r10	;0x0000c
	mov	14(r1),	r11	;0x0000e
	calla	#__mspabi_divd		;0x05cf6
	mov	r12,	8(r1)	;
	mov	r13,	10(r1)	; 0x000a
	mov	r14,	12(r1)	; 0x000c
	mov	r15,	r7	;

	mov	#1,	24(r1)	;r3 As==01, 0x0018
	jmp .L728	;mova	#27660,	r0	;0x06c0c

.L792:
	mov	#16387,	r11	;#0x4003
	cmp	r10,	r11	;
	jl	.L803    	;abs 0x70d6
	cmp	r11,	r10	;
	jnz	.L794     	;abs 0x705a
	mov	#32767,	r12	;#0x7fff

	cmp	r9,	r12	;
	jnc	.L803    	;abs 0x70d6

.L794:
	clr.b	r12		;
	mov	r12,	r13	;

	mov	r12,	r14	;

	mov	#16376,	r15	;#0x3ff8
	mov	8(r1),	r8	;
	mov	10(r1),	r9	;0x0000a

	mov	12(r1),	r10	;0x0000c
	mov	r7,	r11	;
	calla	#__mspabi_subd		;0x05718
	mov	r12,	8(r1)	;

	mov	r13,	10(r1)	; 0x000a
	mov	r14,	12(r1)	; 0x000c
	mov	r15,	14(r1)	; 0x000e

	clr.b	r12		;
	mov	r12,	r13	;
	mov	r12,	r14	;
	mov	#16376,	r15	;#0x3ff8
	mov	r7,	r11	;
	calla	#__mspabi_mpyd		;0x05780
	mov	r12,	r8	;
	mov	r13,	r9	;
	mov	r14,	r10	;
	mov	r15,	r11	;

	clr.b	r12		;
	mov	r12,	r13	;
	mov	r12,	r14	;
	mov	#16368,	r15	;#0x3ff0
	calla	#__mspabi_addd		;0x056b4

	mov	8(r1),	r8	;
	mov	10(r1),	r9	;0x0000a
	mov	12(r1),	r10	;0x0000c
	mov	14(r1),	r11	;0x0000e
	calla	#__mspabi_divd		;0x05cf6
	mov	r12,	8(r1)	;
	mov	r13,	10(r1)	; 0x000a
	mov	r14,	12(r1)	; 0x000c
	mov	r15,	r7	;

	mov	#2,	24(r1)	;r3 As==10, 0x0018
	jmp .L728	;mova	#27660,	r0	;0x06c0c

.L803:
	mov	8(r1),	r12	;
	mov	10(r1),	r13	;0x0000a

	mov	12(r1),	r14	;0x0000c

	mov	r7,	r15	;
	clr.b	r8		;
	mov	r8,	r9	;

	mov	r8,	r10	;
	mov	#-16400,r11	;#0xbff0
	calla	#__mspabi_divd		;0x05cf6
	mov	r12,	8(r1)	;

	mov	r13,	10(r1)	; 0x000a
	mov	r14,	12(r1)	; 0x000c
	mov	r15,	r7	;

	mov	#3,	24(r1)	; 0x0018
	jmp .L728	;mova	#27660,	r0	;0x06c0c

.L809:
	mov	24(r1),	r12	;0x00018
	mov	26(r1),	r13	;0x0001a
	push	r13		;
	push	r12		;
	popm.a	#1,	r8	;20-bit words
	rlam.a	#3,	r8	;
	mova	r8,	r13	;
	adda	#83248,	r13	;0x14530
	mova	r13,	14(r1)	; 0x0000e

	adda	#83216,	r8	;0x14510

	mov	@r8,	r12	;
	mov	2(r8),	r13	;
	mov	4(r8),	r14	;
	mov	6(r8),	r15	;
	mov	18(r1),	r8	;0x00012
	calla	#__mspabi_subd		;0x05718
	mov	r12,	r8	;
	mov	r13,	r9	;
	mov	r14,	r10	;
	mov	r15,	r11	;

	mov	8(r1),	r12	;
	mov	10(r1),	r13	;0x0000a
	mov	12(r1),	r14	;0x0000c
	mov	r7,	r15	;
	calla	#__mspabi_subd		;0x05718

	mova	14(r1),	r9	;0x0000e
	mov	@r9,	r8	;
	mova	r9,	r10	;
	mov	2(r9),	r9	;
	mova	r10,	r7	;

	mov	4(r10),	r10	;
	mov	6(r7),	r11	;
	calla	#__mspabi_subd		;0x05718
	mov	r12,	8(r1)	;
	mov	r13,	10(r1)	; 0x000a
	mov	r14,	12(r1)	; 0x000c
	mov	r15,	r7	;

	cmp	#0,	36(r1)	;r3 As==00, 0x0024
	jge	.L774    	;abs 0x6f78
	add	#-32768,r7	;#0x8000

	jmp .L774	;mova	#28536,	r0	;0x06f78

.L817:
	mov	#11544,	8(r1)	;#0x2d18
	mov	#21572,	10(r1)	;#0x5444, 0x000a
	mov	#8699,	12(r1)	;#0x21fb, 0x000c
	mov	#16377,	r7	;#0x3ff9

	jmp .L774	;mova	#28536,	r0	;0x06f78



	.global fabs
	.type fabs, @function
fabs:
	nop
	nop
	and	#32767,	r15	;#0x7fff

	reta			;



	.global atan2
	.type atan2, @function
atan2:
	nop
	nop
	suba	#8,	r1	;

	mov	12(r1),	0(r1)	;0x0000c
	mov	14(r1),	2(r1)	;0x0000e
	mov	16(r1),	4(r1)	;0x00010
	mov	18(r1),	6(r1)	;0x00012
	calla	#__ieee754_atan2		;0x07352

	adda	#8,	r1	;

	reta			;



	.global hypot
	.type hypot, @function
hypot:
	nop
	nop
	pushm.a	#4,	r10	;20-bit words

	suba	#28,	r1	;0x0001c

	mov	r12,	20(r1)	; 0x0014
	mov	r13,	22(r1)	; 0x0016
	mov	r14,	24(r1)	; 0x0018
	mov	r15,	26(r1)	; 0x001a
	mov	48(r1),	12(r1)	;0x00030, 0x000c
	mov	50(r1),	14(r1)	;0x00032, 0x000e
	mov	52(r1),	16(r1)	;0x00034, 0x0010
	mov	54(r1),	18(r1)	;0x00036, 0x0012

	mov	12(r1),	0(r1)	;0x0000c
	mov	14(r1),	2(r1)	;0x0000e
	mov	16(r1),	4(r1)	;0x00010
	mov	18(r1),	6(r1)	;0x00012
	calla	#__ieee754_hypot		;0x0773a

	mov	r12,	r10	;
	mov	r13,	r7	;
	mov	r14,	r8	;
	mov	r14,	10(r1)	; 0x000a
	mov	r15,	r9	;

	cmpx.w	#-1,	&0x02ce4;r3 As==11
	jz	.L840     	;abs 0x7284


	calla	#finite		;

	mov	r12,	8(r1)	;

	cmp	#0,	r12	;r3 As==00
	jnz	.L840     	;abs 0x7284

	mov	20(r1),	r12	;0x00014
	mov	22(r1),	r13	;0x00016
	mov	24(r1),	r14	;0x00018
	mov	26(r1),	r15	;0x0001a
	calla	#finite		;

	cmp	#0,	r12	;r3 As==00
	jz	.L840     	;abs 0x7284

	mov	12(r1),	r12	;0x0000c
	mov	14(r1),	r13	;0x0000e
	mov	16(r1),	r14	;0x00010
	mov	18(r1),	r15	;0x00012
	calla	#finite		;

	cmp	#0,	r12	;r3 As==00
	jz	.L840     	;abs 0x7284

	calla	#__errno		;0x083e6

	mov	#34,	0(r12)	;#0x0022

	mov	8(r1),	r10	;

	mov	r10,	r7	;
	mov	r10,	10(r1)	; 0x000a
	mov	#32752,	r9	;#0x7ff0

.L840:
	mov	r10,	r12	;
	mov	r7,	r13	;
	mov	10(r1),	r14	;0x0000a
	mov	r9,	r15	;
	adda	#28,	r1	;0x0001c

	popm.a	#4,	r10	;20-bit words

	reta			;



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
	calla	#__ieee754_sqrt		;0x07cea

	mov	r12,	12(r1)	; 0x000c
	mov	r13,	14(r1)	; 0x000e
	mov	r14,	16(r1)	; 0x0010
	mov	r15,	18(r1)	; 0x0012

	mova	8(r1),	r11	;
	cmpx.w	#-1,	&0x02ce4;r3 As==11
	jz	.L858    	;abs 0x733a

	mov	r11,	0(r1)	;
	mov	r7,	2(r1)	;
	mov	r8,	4(r1)	;
	mov	r9,	6(r1)	;
	mov	r11,	r12	;

	mov	r7,	r13	;

	mov	r8,	r14	;

	mov	r9,	r15	;

	calla	#__unorddf2		;0x08350
	mov	r12,	r10	;
	mova	8(r1),	r11	;
	cmp	#0,	r12	;r3 As==00
	jnz	.L858     	;abs 0x733a

	mov	r12,	0(r1)	;
	mov	r12,	2(r1)	;
	mov	r12,	4(r1)	;
	mov	r12,	6(r1)	;
	mov	r11,	r12	;
	mov	r7,	r13	;
	mov	r8,	r14	;
	mov	r9,	r15	;
	calla	#__ltdf2		;0x061ac
	cmp	#0,	r12	;r3 As==00
	jge	.L858     	;abs 0x733a

	calla	#__errno		;0x083e6

	mov	#33,	0(r12)	;#0x0021

	mov	r10,	r12	;
	mov	r10,	r13	;
	mov	r10,	r14	;
	mov	r10,	r15	;
	mov	r10,	r8	;
	mov	r10,	r9	;
	mov	r10,	r11	;
	calla	#__mspabi_divd		;0x05cf6
	mov	r12,	12(r1)	; 0x000c

	mov	r13,	14(r1)	; 0x000e
	mov	r14,	16(r1)	; 0x0010
	mov	r15,	18(r1)	; 0x0012

.L858:
	mov	12(r1),	r12	;0x0000c
	mov	14(r1),	r13	;0x0000e
	mov	16(r1),	r14	;0x00010
	mov	18(r1),	r15	;0x00012
	adda	#20,	r1	;0x00014

	popm.a	#4,	r10	;20-bit words

	reta			;



	.global __ieee754_atan2
	.type __ieee754_atan2, @function
__ieee754_atan2:
	nop
	nop
	pushm.a	#4,	r10	;20-bit words

	suba	#48,	r1	;0x00030

	mov	r12,	r8	;
	mov	r13,	r9	;
	mov	r14,	r10	;
	mov	r15,	r11	;
	mov	68(r1),	28(r1)	;0x00044, 0x001c
	mov	70(r1),	30(r1)	;0x00046, 0x001e
	mov	72(r1),	32(r1)	;0x00048, 0x0020
	mov	74(r1),	34(r1)	;0x0004a, 0x0022

	mov	32(r1),	r7	;0x00020
	mov	34(r1),	26(r1)	;0x00022, 0x001a

	mov	28(r1),	6(r1)	;0x0001c
	mov	30(r1),	8(r1)	;0x0001e

	mov	r7,	18(r1)	; 0x0012
	mov	26(r1),	r12	;0x0001a

	and	#32767,	r12	;#0x7fff
	mov	r12,	20(r1)	; 0x0014

	mov	r7,	38(r1)	; 0x0026
	mov	r12,	40(r1)	; 0x0028

	clr.b	r14		;
	clr.b	r15		;
	subx.w	6(r1),	r14	;
	subcx.w	8(r1),	r15	;

	mov	r14,	r12	;
	bis	6(r1),	r12	;
	mov	r15,	r13	;
	bis	8(r1),	r13	;
	mov.b	#31,	r14	;#0x001f
	mova	r11,	0(r1)	;
	calla	#__mspabi_srll		;0x062e8

	bis	r7,	r12	;
	bis	40(r1),	r13	;0x00028

	mova	@r1,	r11	;
	mov	#32752,	r14	;#0x7ff0
	cmp	r13,	r14	;
	jnc	.L879    	;abs 0x7448
	cmp	r14,	r13	;
	jnz	.L872      	;abs 0x73e6
	cmp	#0,	r12	;r3 As==00
	jnz	.L879    	;abs 0x7448

.L872:
	mov	r10,	4(r1)	;
	mov	r11,	46(r1)	; 0x002e
	mov	r8,	22(r1)	; 0x0016
	mov	r9,	24(r1)	; 0x0018

	mov	r10,	10(r1)	; 0x000a
	mov	r11,	r12	;
	and	#32767,	r12	;#0x7fff
	mov	r12,	12(r1)	; 0x000c

	mov	r10,	42(r1)	; 0x002a
	mov	r12,	44(r1)	; 0x002c

	clr.b	r14		;
	clr.b	r15		;
	subx.w	22(r1),	r14	;0x00016
	subcx.w	24(r1),	r15	;0x00018

	mov	r14,	r12	;
	bis	r8,	r12	;
	mov	r15,	r13	;
	bis	r9,	r13	;
	mov.b	#31,	r14	;#0x001f
	mova	r11,	0(r1)	;
	calla	#__mspabi_srll		;0x062e8

	bis	r10,	r12	;
	bis	44(r1),	r13	;0x0002c

	mova	@r1,	r11	;
	mov	#32752,	r14	;#0x7ff0
	cmp	r13,	r14	;
	jnc	.L879     	;abs 0x7448
	cmp	r14,	r13	;
	jnz	.L885     	;abs 0x7474
	cmp	#0,	r12	;r3 As==00
	jz	.L885     	;abs 0x7474

.L879:
	mov	28(r1),	r12	;0x0001c
	mov	30(r1),	r13	;0x0001e
	mov	32(r1),	r14	;0x00020
	mov	34(r1),	r15	;0x00022
	calla	#__mspabi_addd		;0x056b4

.L880:
	mov	r12,	r8	;
	mov	r13,	r9	;
	mov	r14,	r10	;

.L881:
	mov	r15,	r11	;

.L882:
	mov	r8,	r12	;
	mov	r9,	r13	;
	mov	r10,	r14	;
	mov	r11,	r15	;
	adda	#48,	r1	;0x00030

	popm.a	#4,	r10	;20-bit words

	reta			;

.L885:
	mov	r7,	r12	;
	add	#0,	r12	;r3 As==00
	mov	26(r1),	r12	;0x0001a
	addc	#-16368,r12	;#0xc010

	mov	r12,	r13	;
	bis	8(r1),	r13	;

	mov	r7,	r12	;
	bis	6(r1),	r12	;
	bis	r13,	r12	;
	cmp	#0,	r12	;r3 As==00
	jnz	.L890     	;abs 0x74a2

	mov	r8,	r12	;
	mov	r9,	r13	;
	mov	r10,	r14	;
	mov	r11,	r15	;
	calla	#atan		;0x06b38

	jmp .L880	;mova	#29788,	r0	;0x0745c

.L890:
	mov	r7,	r12	;
	mov	26(r1),	r13	;0x0001a
	mov.b	#30,	r14	;#0x001e
	mova	r11,	0(r1)	;
	calla	#__mspabi_sral		;0x083be

	and.b	#2,	r12	;r3 As==10
	mov	r12,	36(r1)	; 0x0024

	mov	4(r1),	r12	;
	mov	46(r1),	r13	;0x0002e
	mov.b	#31,	r14	;#0x001f
	calla	#__mspabi_srll		;0x062e8

	mov	36(r1),	r7	;0x00024

	bis	r12,	r7	;
	mov	r13,	4(r1)	;

	mov	42(r1),	r12	;0x0002a
	bis	22(r1),	r12	;0x00016
	mov	44(r1),	r14	;0x0002c
	bis	24(r1),	r14	;0x00018

	bis	r14,	r12	;
	mova	@r1,	r11	;
	cmp	#0,	r12	;r3 As==00
	jnz	.L900     	;abs 0x7516

	cmp	#2,	r7	;r3 As==10
	jnz	.L898      	;abs 0x74f4
	cmp	#0,	r13	;r3 As==00
	jz	.L938    	;abs 0x76fe

.L898:
	cmp	#3,	r7	;
	jnz	.L882    	;abs 0x7464
	mov	4(r1),	r12	;
	cmp	#0,	r12	;r3 As==00
	jnz	.L882    	;abs 0x7464

	mov	#11544,	r8	;#0x2d18
	mov	#21572,	r9	;#0x5444
	mov	#8699,	r10	;#0x21fb
	mov	#-16375,r11	;#0xc009
	jmp .L882	;mova	#29796,	r0	;0x07464

.L900:
	mov	38(r1),	r12	;0x00026
	bis	6(r1),	r12	;
	mov	40(r1),	r13	;0x00028

	bis	8(r1),	r13	;

	bis	r13,	r12	;
	cmp	#0,	r12	;r3 As==00
	jnz	.L906     	;abs 0x7544

.L903:
	mov	#11544,	r8	;#0x2d18
	mov	#21572,	r9	;#0x5444
	mov	#8699,	r10	;#0x21fb

	cmp	#0,	r11	;r3 As==00
	jge	.L941    	;abs 0x7732

	mov	#-16391,r11	;#0xbff9
	jmp .L882	;mova	#29796,	r0	;0x07464

.L906:
	mov	18(r1),	r12	;0x00012
	cmp	#0,	r12	;r3 As==00
	jnz	.L913    	;abs 0x75d4
	mov	20(r1),	r12	;0x00014
	cmp	#32752,	r12	;#0x7ff0
	jnz	.L913    	;abs 0x75d4

	add	#-1,	r7	;r3 As==11

	mov	r7,	14(r1)	; 0x000e
	mov	4(r1),	r12	;
	addc	#-1,	r12	;r3 As==11
	mov	r12,	16(r1)	; 0x0010

	mov	10(r1),	r12	;0x0000a
	cmp	#0,	r12	;r3 As==00
	jnz	.L912     	;abs 0x75ac
	mov	12(r1),	r12	;0x0000c
	cmp	#32752,	r12	;#0x7ff0
	jnz	.L912     	;abs 0x75ac

	mov	16(r1),	r12	;0x00010
	cmp	#0,	r12	;r3 As==00
	jnz	.L939    	;abs 0x7712
	mov.b	#2,	r13	;r3 As==10
	cmp	r7,	r13	;
	jnc	.L939    	;abs 0x7712
	mov	14(r1),	r13	;0x0000e
	mov	16(r1),	r14	;0x00010
	push	r14		;
	push	r13		;
	popm.a	#1,	r12	;20-bit words
	rlam.a	#3,	r12	;
	adda	#83304,	r12	;0x14568

.L911:
	mov	@r12,	r8	;
	mov	2(r12),	r9	;
	mov	4(r12),	r10	;
	mov	6(r12),	r11	;
	jmp .L882	;mova	#29796,	r0	;0x07464

.L912:
	mov	16(r1),	r12	;0x00010
	cmp	#0,	r12	;r3 As==00
	jnz	.L940    	;abs 0x7726
	mov.b	#2,	r14	;r3 As==10
	cmp	14(r1),	r14	;0x0000e
	jnc	.L940    	;abs 0x7726
	mov	14(r1),	r13	;0x0000e
	mov	16(r1),	r14	;0x00010
	push	r14		;
	push	r13		;
	popm.a	#1,	r12	;20-bit words
	rlam.a	#3,	r12	;
	adda	#83280,	r12	;0x14550
	jmp .L911	;mova	#30106,	r0	;0x0759a

.L913:
	mov	10(r1),	r12	;0x0000a
	cmp	#0,	r12	;r3 As==00
	jnz	.L914     	;abs 0x75e6
	mov	12(r1),	r12	;0x0000c
	cmp	#32752,	r12	;#0x7ff0
	jz	.L903    	;abs 0x752c

.L914:
	mov	10(r1),	r12	;0x0000a
	mov	12(r1),	r13	;0x0000c
	subx.w	18(r1),	r12	;0x00012
	subcx.w	20(r1),	r13	;0x00014
	mov.b	#20,	r14	;#0x0014
	mova	r11,	0(r1)	;
	calla	#__mspabi_sral		;0x083be

	mova	@r1,	r11	;
	clr.b	r14		;
	cmp	r13,	r14	;
	jl	.L930    	;abs 0x76a8
	cmp	r14,	r13	;
	jnz	.L916     	;abs 0x761a
	mov.b	#60,	r14	;#0x003c
	cmp	r12,	r14	;
	jnc	.L930    	;abs 0x76a8

.L916:
	mov	26(r1),	r14	;0x0001a
	cmp	#0,	r14	;r3 As==00
	jge	.L919     	;abs 0x7630

	cmp	#-1,	r13	;r3 As==11
	jl	.L931    	;abs 0x76bc

	cmp	#-1,	r13	;r3 As==11
	jnz	.L919      	;abs 0x7630
	cmp	#-60,	r12	;#0xffc4
	jnc	.L931    	;abs 0x76bc

.L919:
	mov	28(r1),	r12	;0x0001c

	mov	30(r1),	r13	;0x0001e
	mov	32(r1),	r14	;0x00020
	mov	34(r1),	r15	;0x00022
	calla	#__mspabi_divd		;0x05cf6
	calla	#fabs		;0x071a8

	calla	#atan		;0x06b38

	mov	r12,	r8	;
	mov	r13,	r9	;
	mov	r14,	r10	;
	mov	r15,	r11	;

.L923:
	cmp	#1,	r7	;r3 As==01
	jnz	.L924     	;abs 0x7660
	mov	4(r1),	r12	;
	cmp	#0,	r12	;r3 As==00
	jz	.L932    	;abs 0x76c8

.L924:
	cmp	#2,	r7	;r3 As==10
	jnz	.L925     	;abs 0x766c
	mov	4(r1),	r12	;
	cmp	#0,	r12	;r3 As==00
	jz	.L934    	;abs 0x76d2

.L925:
	mov	r7,	r12	;
	bis	4(r1),	r12	;
	cmp	#0,	r12	;r3 As==00
	jz	.L882    	;abs 0x7464


	mov	#23559,	r12	;#0x5c07
	mov	#13076,	r13	;#0x3314
	mov	#-23002,r14	;#0xa626
	mov	#15521,	r15	;#0x3ca1
	calla	#__mspabi_subd		;

	mov	r12,	r8	;
	mov	r13,	r9	;
	mov	r14,	r10	;
	mov	r15,	r11	;

	mov	#11544,	r12	;#0x2d18
	mov	#21572,	r13	;#0x5444
	mov	#8699,	r14	;#0x21fb
	mov	#16393,	r15	;#0x4009
	jmp .L937	;mova	#30456,	r0	;0x076f8

.L930:
	mov	#11544,	r8	;#0x2d18
	mov	#21572,	r9	;#0x5444
	mov	#8699,	r10	;#0x21fb
	mov	#16377,	r11	;#0x3ff9
	jmp .L923	;mova	#30292,	r0	;0x07654

.L931:
	clr.b	r8		;
	mov	r8,	r9	;
	mov	r8,	r10	;
	mov	r8,	r11	;
	jmp .L923	;mova	#30292,	r0	;0x07654

.L932:
	mov	r11,	r15	;
	add	#-32768,r15	;#0x8000

	jmp .L881	;mova	#29794,	r0	;0x07462

.L934:

	mov	#23559,	r12	;#0x5c07
	mov	#13076,	r13	;#0x3314
	mov	#-23002,r14	;#0xa626
	mov	#15521,	r15	;#0x3ca1
	calla	#__mspabi_subd		;

	mov	#11544,	r8	;#0x2d18
	mov	#21572,	r9	;#0x5444
	mov	#8699,	r10	;#0x21fb
	mov	#16393,	r11	;#0x4009

.L937:
	calla	#__mspabi_subd		;
	jmp .L880	;mova	#29788,	r0	;0x0745c

.L938:
	mov	#11544,	r8	;#0x2d18
	mov	#21572,	r9	;#0x5444
	mov	#8699,	r10	;#0x21fb
	mov	#16393,	r11	;#0x4009
	jmp .L882	;mova	#29796,	r0	;0x07464

.L939:
	mov	#11544,	r8	;#0x2d18
	mov	#21572,	r9	;#0x5444
	mov	#8699,	r10	;#0x21fb
	mov	#16361,	r11	;#0x3fe9
	jmp .L882	;mova	#29796,	r0	;0x07464

.L940:
	clr.b	r8		;
	mov	r8,	r9	;
	mov	r8,	r10	;
	mov	r8,	r11	;
	jmp .L882	;mova	#29796,	r0	;0x07464

.L941:
	mov	#16377,	r11	;#0x3ff9
	jmp .L882	;mova	#29796,	r0	;0x07464



	.global __ieee754_hypot
	.type __ieee754_hypot, @function
__ieee754_hypot:
	nop
	nop
	pushm.a	#4,	r10	;20-bit words

	suba	#54,	r1	;0x00036

	mov	r12,	28(r1)	; 0x001c
	mov	r13,	30(r1)	; 0x001e
	mov	74(r1),	22(r1)	;0x0004a, 0x0016
	mov	76(r1),	26(r1)	;0x0004c, 0x001a
	mov	80(r1),	r12	;0x00050

	mov	r14,	8(r1)	;
	mov	r15,	r13	;

	and	#32767,	r13	;#0x7fff
	mov	r13,	10(r1)	; 0x000a

	mov	78(r1),	r13	;0x0004e

	mov	r13,	12(r1)	; 0x000c
	mov	r12,	r13	;
	and	#32767,	r13	;#0x7fff
	mov	r13,	14(r1)	; 0x000e

	and	#32767,	r15	;#0x7fff

	cmp	r13,	r15	;
	jl	.L950     	;abs 0x778a
	cmp	r15,	r13	;
	jnz	.L956     	;abs 0x77c2
	cmp	12(r1),	r14	;0x0000c
	jc	.L956     	;abs 0x77c2

.L950:
	mov	8(r1),	r12	;

	mov	10(r1),	r13	;0x0000a
	mov	12(r1),	8(r1)	;0x0000c

	mov	14(r1),	10(r1)	;0x0000e, 0x000a
	mov	r12,	12(r1)	; 0x000c

	mov	r13,	14(r1)	; 0x000e
	mov	28(r1),	r13	;0x0001c
	mov	30(r1),	r12	;0x0001e

	mov	22(r1),	28(r1)	;0x00016, 0x001c
	mov	26(r1),	30(r1)	;0x0001a, 0x001e

	mov	r13,	22(r1)	; 0x0016
	mov	r12,	26(r1)	; 0x001a

.L956:
	mov	8(r1),	r12	;
	mov	10(r1),	r11	;0x0000a

	mov	28(r1),	18(r1)	;0x0001c, 0x0012
	mov	30(r1),	20(r1)	;0x0001e, 0x0014
	mov	r12,	r7	;
	mov	r11,	16(r1)	; 0x0010

	mov	14(r1),	32(r1)	;0x0000e, 0x0020

	mov	22(r1),	38(r1)	;0x00016, 0x0026
	mov	26(r1),	40(r1)	;0x0001a, 0x0028
	mov	12(r1),	24(r1)	;0x0000c, 0x0018
	mov	32(r1),	36(r1)	;0x00020, 0x0024

	mov	8(r1),	r14	;
	mov	10(r1),	r15	;0x0000a
	subx.w	12(r1),	r14	;0x0000c
	subcx.w	14(r1),	r15	;0x0000e

	mov	#960,	r13	;#0x03c0
	cmp	r15,	r13	;
	jl	.L962     	;abs 0x7820
	cmp	#960,	r15	;#0x03c0
	jnz	.L964     	;abs 0x7850
	cmp	#0,	r14	;r3 As==00
	jz	.L964     	;abs 0x7850

.L962:
	mov	22(r1),	r12	;0x00016
	mov	26(r1),	r13	;0x0001a
	mov	24(r1),	r14	;0x00018
	mov	32(r1),	r15	;0x00020
	mov	28(r1),	r8	;0x0001c
	mov	30(r1),	r9	;0x0001e
	mov	r7,	r10	;
	calla	#__mspabi_addd		;0x056b4

.L963:
	mov	r12,	18(r1)	; 0x0012
	mov	r13,	20(r1)	; 0x0014
	mov	r14,	r7	;
	mov	r15,	16(r1)	; 0x0010
	jmp .L1021	;mova	#31548,	r0	;0x07b3c

.L964:
	mov	#24368,	r13	;#0x5f30
	cmp	10(r1),	r13	;0x0000a
	jl	.L965     	;abs 0x786c
	mov	10(r1),	r13	;0x0000a
	cmp	#24368,	r13	;#0x5f30
	jnz	.L1024    	;abs 0x7b52
	mov	8(r1),	r13	;
	cmp	#0,	r13	;r3 As==00
	jz	.L1024    	;abs 0x7b52

.L965:
	mov	#32751,	r13	;#0x7fef
	cmp	10(r1),	r13	;0x0000a
	jl	.L1013    	;abs 0x7acc

	addx.w	#0,	8(r1)	;r3 As==00
	addcx.w	#55936,	10(r1)	;0x0da80, 0x0000a

	addx.w	#0,	12(r1)	;r3 As==00, 0x0000c
	addcx.w	#55936,	14(r1)	;0x0da80, 0x0000e

	mov	10(r1),	r15	;0x0000a

	mov	8(r1),	r7	;
	mov	r15,	16(r1)	; 0x0010

	mov	14(r1),	r15	;0x0000e

	mov	12(r1),	24(r1)	;0x0000c, 0x0018

	mov	r15,	36(r1)	; 0x0024

	mov	#600,	32(r1)	;#0x0258, 0x0020

.L974:
	mov	#0,	34(r1)	;r3 As==00, 0x0022

	mov	#8367,	r12	;#0x20af
	cmp	14(r1),	r12	;0x0000e
	jl	.L987    	;abs 0x7948

	mov.b	#15,	r13	;#0x000f
	cmp	14(r1),	r13	;0x0000e
	jl	.L1025    	;abs 0x7b5a

	mov	26(r1),	r13	;0x0001a
	bis	14(r1),	r13	;0x0000e

	mov	22(r1),	r12	;0x00016
	bis	12(r1),	r12	;0x0000c
	bis	r13,	r12	;
	cmp	#0,	r12	;r3 As==00
	jz	.L1021    	;abs 0x7b3c

	clr.b	r12		;
	mov	r12,	r13	;
	mov	r12,	r14	;
	mov	#32720,	r15	;#0x7fd0
	mov	22(r1),	r8	;0x00016
	mov	26(r1),	r9	;0x0001a
	mov	24(r1),	r10	;0x00018
	mov	36(r1),	r11	;0x00024
	calla	#__mspabi_mpyd		;0x05780
	mov	r12,	38(r1)	; 0x0026
	mov	r13,	40(r1)	; 0x0028
	mov	r14,	24(r1)	; 0x0018

	mov	r15,	36(r1)	; 0x0024

	clr.b	r12		;

	mov	r12,	r13	;

	mov	r12,	r14	;

	mov	#32720,	r15	;#0x7fd0

	mov	28(r1),	r8	;0x0001c
	mov	30(r1),	r9	;0x0001e
	mov	r7,	r10	;
	mov	16(r1),	r11	;0x00010
	calla	#__mspabi_mpyd		;0x05780
	mov	r12,	18(r1)	; 0x0012
	mov	r13,	20(r1)	; 0x0014
	mov	r14,	r7	;
	mov	r15,	16(r1)	; 0x0010

	addx.w	#64514,	32(r1)	;0x0fc02, 0x00020
	addcx.w	#65535,	34(r1)	;0x0ffff, 0x00022

.L987:
	mov	38(r1),	r12	;0x00026
	mov	40(r1),	r13	;0x00028
	mov	24(r1),	r14	;0x00018
	mov	36(r1),	r15	;0x00024
	mov	18(r1),	r8	;0x00012
	mov	20(r1),	r9	;0x00014
	mov	r7,	r10	;
	mov	16(r1),	r11	;0x00010
	calla	#__mspabi_subd		;0x05718
	mov	r12,	28(r1)	; 0x001c
	mov	r13,	30(r1)	; 0x001e
	mov	r14,	42(r1)	; 0x002a
	mov	r15,	44(r1)	; 0x002c

	mov	r12,	0(r1)	;
	mov	r13,	2(r1)	;
	mov	r14,	4(r1)	;
	mov	r15,	6(r1)	;
	mov	38(r1),	r12	;0x00026

	mov	40(r1),	r13	;0x00028

	mov	24(r1),	r14	;0x00018

	mov	36(r1),	r15	;0x00024

	calla	#__ltdf2		;0x061ac

	cmp	#0,	r12	;r3 As==00
	jge	.L1034    	;abs 0x7ba4

	mov	10(r1),	12(r1)	;0x0000a, 0x000c

	clr.b	r12		;
	mov	r12,	r13	;
	mov	8(r1),	r14	;
	mov	12(r1),	r15	;0x0000c
	mov	r12,	r8	;
	mov	r12,	r9	;
	mov	r14,	r10	;
	mov	r15,	r11	;
	calla	#__mspabi_mpyd		;0x05780
	mov	r12,	22(r1)	; 0x0016
	mov	r13,	26(r1)	; 0x001a
	mov	r14,	28(r1)	; 0x001c

	mov	r15,	30(r1)	; 0x001e

	mov	38(r1),	r12	;0x00026
	mov	40(r1),	r13	;0x00028
	mov	24(r1),	r14	;0x00018
	mov	36(r1),	r15	;0x00024
	mov	r12,	r8	;
	mov	r13,	r9	;
	mov	r14,	r10	;
	mov	r15,	r11	;
	add	#-32768,r11	;#0x8000
	calla	#__mspabi_mpyd		;0x05780
	mov	r12,	24(r1)	; 0x0018

	mov	r13,	36(r1)	; 0x0024
	mov	r14,	38(r1)	; 0x0026
	mov	r15,	40(r1)	; 0x0028

	clr.b	r12		;
	mov	r12,	r13	;
	mov	8(r1),	r14	;
	mov	12(r1),	r15	;0x0000c
	mov	18(r1),	r8	;0x00012
	mov	20(r1),	r9	;0x00014
	mov	r7,	r10	;
	mov	16(r1),	r11	;0x00010
	calla	#__mspabi_addd		;0x056b4
	mov	r12,	18(r1)	; 0x0012

	mov	r13,	20(r1)	; 0x0014
	mov	r14,	42(r1)	; 0x002a
	mov	r15,	r7	;

	clr.b	r12		;
	mov	r12,	r13	;
	mov	8(r1),	r14	;
	mov	12(r1),	r15	;0x0000c
	mov	16(r1),	r11	;0x00010
	calla	#__mspabi_subd		;0x05718

	mov	18(r1),	r8	;0x00012
	mov	20(r1),	r9	;0x00014
	mov	42(r1),	r10	;0x0002a
	mov	r7,	r11	;
	calla	#__mspabi_mpyd		;0x05780

	mov	24(r1),	r8	;0x00018
	mov	36(r1),	r9	;0x00024
	mov	38(r1),	r10	;0x00026
	mov	40(r1),	r11	;0x00028
	calla	#__mspabi_subd		;0x05718

	mov	22(r1),	r8	;0x00016
	mov	26(r1),	r9	;0x0001a
	mov	28(r1),	r10	;0x0001c
	mov	30(r1),	r11	;0x0001e

.L1005:
	calla	#__mspabi_subd		;0x05718
	calla	#__ieee754_sqrt		;0x07cea

	mov	r12,	18(r1)	; 0x0012
	mov	r13,	20(r1)	; 0x0014
	mov	r14,	r7	;
	mov	r15,	16(r1)	; 0x0010

	mov	32(r1),	r12	;0x00020

	bis	34(r1),	r12	;0x00022
	cmp	#0,	r12	;r3 As==00
	jz	.L1021    	;abs 0x7b3c

	mov	32(r1),	r12	;0x00020
	mov	34(r1),	r13	;0x00022

	mov.b	#20,	r14	;#0x0014
	calla	#__mspabi_slll		;0x062bc

	mov	r12,	r14	;
	add	#0,	r14	;r3 As==00
	mov	r13,	r15	;
	addc	#16368,	r15	;#0x3ff0

	clr.b	r12		;
	mov	r12,	r13	;
	mov	18(r1),	r8	;0x00012
	mov	20(r1),	r9	;0x00014
	mov	r7,	r10	;
	mov	16(r1),	r11	;0x00010
	calla	#__mspabi_mpyd		;0x05780
	jmp .L963	;mova	#30782,	r0	;0x0783e

.L1013:
	bis	28(r1),	r12	;0x0001c
	mov	r11,	r13	;
	and.b	#15,	r13	;#0x000f
	bis	30(r1),	r13	;0x0001e

	bis	r13,	r12	;
	cmp	#0,	r12	;r3 As==00
	jz	.L1016     	;abs 0x7b0c

	mov	22(r1),	r12	;0x00016
	mov	26(r1),	r13	;0x0001a
	mov	24(r1),	r14	;0x00018
	mov	32(r1),	r15	;0x00020
	mov	28(r1),	r8	;0x0001c
	mov	30(r1),	r9	;0x0001e
	mov	r7,	r10	;
	calla	#__mspabi_addd		;0x056b4
	mov	r12,	18(r1)	; 0x0012
	mov	r13,	20(r1)	; 0x0014
	mov	r14,	r7	;
	mov	r15,	16(r1)	; 0x0010

.L1016:
	mov	12(r1),	r12	;0x0000c
	mov	14(r1),	r13	;0x0000e
	xor	#32752,	r13	;#0x7ff0

	bis	22(r1),	r12	;0x00016
	bis	26(r1),	r13	;0x0001a

	bis	r13,	r12	;
	cmp	#0,	r12	;r3 As==00
	jnz	.L1021     	;abs 0x7b3c

	mov	22(r1),	18(r1)	;0x00016, 0x0012

	mov	26(r1),	20(r1)	;0x0001a, 0x0014
	mov	24(r1),	r7	;0x00018
	mov	32(r1),	16(r1)	;0x00020, 0x0010

.L1021:
	mov	18(r1),	r12	;0x00012
	mov	20(r1),	r13	;0x00014
	mov	r7,	r14	;
	mov	16(r1),	r15	;0x00010
	adda	#54,	r1	;0x00036

	popm.a	#4,	r10	;20-bit words

	reta			;

.L1024:
	mov	#0,	32(r1)	;r3 As==00, 0x0020
	jmp .L974	;mova	#30898,	r0	;0x078b2

.L1025:
	addx.w	#0,	8(r1)	;r3 As==00
	addcx.w	#9600,	10(r1)	;0x02580, 0x0000a

	addx.w	#0,	12(r1)	;r3 As==00, 0x0000c
	addcx.w	#9600,	14(r1)	;0x02580, 0x0000e

	addx.w	#64936,	32(r1)	;0x0fda8, 0x00020
	addcx.w	#65535,	34(r1)	;0x0ffff, 0x00022

	mov	10(r1),	r15	;0x0000a

	mov	8(r1),	r7	;
	mov	r15,	16(r1)	; 0x0010

	mov	14(r1),	r15	;0x0000e

	mov	12(r1),	24(r1)	;0x0000c, 0x0018

	mov	r15,	36(r1)	; 0x0024

	jmp .L987	;mova	#31048,	r0	;0x07948

.L1034:
	mov	14(r1),	26(r1)	;0x0000e, 0x001a

	mov	8(r1),	r12	;
	add	#0,	r12	;r3 As==00
	mov	r12,	22(r1)	; 0x0016
	mov	10(r1),	r12	;0x0000a
	addc	#16,	r12	;#0x0010
	mov	r12,	8(r1)	;

	clr.b	r12		;
	mov	r12,	r13	;
	mov	22(r1),	r14	;0x00016
	mov	8(r1),	r15	;
	mov	r12,	r8	;
	mov	r12,	r9	;
	mov	12(r1),	r10	;0x0000c
	mov	26(r1),	r11	;0x0001a
	calla	#__mspabi_mpyd		;0x05780
	mov	r12,	46(r1)	; 0x002e
	mov	r13,	48(r1)	; 0x0030
	mov	r14,	50(r1)	; 0x0032
	mov	r15,	52(r1)	; 0x0034

	mov	28(r1),	r12	;0x0001c
	mov	30(r1),	r13	;0x0001e
	mov	42(r1),	r14	;0x0002a
	mov	44(r1),	r15	;0x0002c
	mov	r12,	r8	;
	mov	r13,	r9	;
	mov	r14,	r10	;
	mov	r15,	r11	;
	add	#-32768,r11	;#0x8000
	calla	#__mspabi_mpyd		;0x05780
	mov	r12,	28(r1)	; 0x001c

	mov	r13,	30(r1)	; 0x001e
	mov	r14,	42(r1)	; 0x002a
	mov	r15,	44(r1)	; 0x002c

	mov	18(r1),	r12	;0x00012
	mov	20(r1),	r13	;0x00014
	mov	r7,	r14	;
	mov	16(r1),	r15	;0x00010
	mov	r12,	r8	;
	mov	r13,	r9	;
	mov	r7,	r10	;
	mov	r15,	r11	;
	calla	#__mspabi_addd		;0x056b4
	mov	r12,	r8	;
	mov	r13,	r9	;
	mov	r14,	r10	;
	mov	r15,	r11	;

	clr.b	r12		;
	mov	r12,	r13	;
	mov	22(r1),	r14	;0x00016
	mov	8(r1),	r15	;
	calla	#__mspabi_subd		;0x05718
	mov	r12,	r8	;
	mov	r13,	r9	;
	mov	r14,	r10	;
	mov	r15,	r11	;

	mov	38(r1),	r12	;0x00026
	mov	40(r1),	r13	;0x00028
	mov	24(r1),	r14	;0x00018
	mov	36(r1),	r15	;0x00024
	calla	#__mspabi_mpyd		;0x05780
	mov	r12,	16(r1)	; 0x0010
	mov	r13,	18(r1)	; 0x0012
	mov	r14,	20(r1)	; 0x0014
	mov	r15,	r7	;

	clr.b	r12		;
	mov	r12,	r13	;
	mov	12(r1),	r14	;0x0000c
	mov	26(r1),	r15	;0x0001a
	mov	38(r1),	r8	;0x00026
	mov	40(r1),	r9	;0x00028
	mov	24(r1),	r10	;0x00018
	mov	36(r1),	r11	;0x00024
	calla	#__mspabi_subd		;0x05718
	mov	r12,	r8	;
	mov	r13,	r9	;
	mov	r14,	r10	;
	mov	r15,	r11	;

	clr.b	r12		;
	mov	r12,	r13	;
	mov	22(r1),	r14	;0x00016
	mov	8(r1),	r15	;
	calla	#__mspabi_mpyd		;0x05780

	mov	16(r1),	r8	;0x00010
	mov	18(r1),	r9	;0x00012
	mov	20(r1),	r10	;0x00014
	mov	r7,	r11	;
	calla	#__mspabi_addd		;0x056b4

	mov	28(r1),	r8	;0x0001c
	mov	30(r1),	r9	;0x0001e
	mov	42(r1),	r10	;0x0002a
	mov	44(r1),	r11	;0x0002c
	calla	#__mspabi_subd		;0x05718

	mov	46(r1),	r8	;0x0002e
	mov	48(r1),	r9	;0x00030
	mov	50(r1),	r10	;0x00032
	mov	52(r1),	r11	;0x00034
	jmp .L1005	;mova	#31350,	r0	;0x07a76



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
	jnz	.L1059     	;abs 0x7d48

	mov	r15,	r11	;
	calla	#__mspabi_mpyd		;0x05780

	mov	r7,	r11	;
	calla	#__mspabi_addd		;0x056b4

.L1055:
	mov	r12,	r8	;
	mov	r13,	r9	;
	mov	r14,	r10	;
	mov	r15,	r7	;

.L1056:
	mov	r8,	r12	;
	mov	r9,	r13	;
	mov	r10,	r14	;
	mov	r7,	r15	;
	adda	#46,	r1	;0x0002e

	popm.a	#4,	r10	;20-bit words

	reta			;

.L1059:
	clr.b	r12		;

	cmp	@r1,	r12	;
	jl	.L1070     	;abs 0x7d98
	cmp	r12,	r15	;
	jnz	.L1061     	;abs 0x7d5a
	mov	30(r1),	r12	;0x0001e
	cmp	#0,	r12	;r3 As==00
	jnz	.L1070     	;abs 0x7d98

.L1061:
	mov	30(r1),	r14	;0x0001e

	mov	36(r1),	r12	;0x00024
	bis	r14,	r12	;
	mov	@r1,	r13	;
	and	#32767,	r13	;#0x7fff
	bis	38(r1),	r13	;0x00026

	bis	r13,	r12	;
	cmp	#0,	r12	;r3 As==00
	jz	.L1056     	;abs 0x7d38

	bis	@r1,	r14	;
	cmp	#0,	r14	;r3 As==00
	jz	.L1070     	;abs 0x7d98

	mov	r8,	r12	;
	mov	r9,	r13	;
	mov	r10,	r14	;
	mov	r7,	r15	;
	mov	r7,	r11	;
	calla	#__mspabi_subd		;0x05718
	mov	r12,	r8	;

	mov	r13,	r9	;

	mov	r14,	r10	;

	mov	r15,	r11	;

	calla	#__mspabi_divd		;0x05cf6
	jmp .L1055	;mova	#32048,	r0	;0x07d30

.L1070:
	mov	30(r1),	r12	;0x0001e
	mov	@r1,	r13	;
	mov.b	#20,	r14	;#0x0014
	calla	#__mspabi_sral		;0x083be
	mov	r12,	r8	;

	mov	r13,	r9	;

	bis	r13,	r12	;
	cmp	#0,	r12	;r3 As==00
	jz	.L1164    	;abs 0x8192

.L1073:
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
	jz	.L1080     	;abs 0x7e04
	rla	r10		;

	rlc	r9		;

	mov	10(r1),	r12	;0x0000a
	mov	12(r1),	r13	;0x0000c
	mov.b	#31,	r14	;#0x001f
	calla	#__mspabi_srll		;0x062e8
	add	r12,	r10	;
	addc	r13,	r9	;
	rlax.w	10(r1)		;#0x0000a
	rlcx.w	12(r1)		;#0x0000c

.L1080:
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
	calla	#__mspabi_srll		;0x062e8
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

.L1089:
	mov	r8,	r14	;
	add	r10,	r14	;
	mov	r14,	26(r1)	; 0x001a
	mov	r9,	r12	;
	addc	r11,	r12	;
	mov	r12,	28(r1)	; 0x001c

	mov	8(r1),	r12	;
	cmp	28(r1),	r12	;0x0001c
	jl	.L1095     	;abs 0x7ec2
	mov	28(r1),	r12	;0x0001c
	cmp	8(r1),	r12	;
	jnz	.L1091     	;abs 0x7e92
	mov	6(r1),	r12	;
	cmp	r14,	r12	;
	jnc	.L1095     	;abs 0x7ec2

.L1091:
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

.L1095:
	mov	18(r1),	r12	;0x00012
	mov	20(r1),	r13	;0x00014
	mov.b	#31,	r14	;#0x001f
	mova	r11,	2(r1)	;
	calla	#__mspabi_srll		;0x062e8
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
	jnz	.L1089    	;abs 0x7e66
	mov	#32,	26(r1)	;#0x0020, 0x001a

	clr.b	r10		;

	clr.b	r11		;

	mov	r10,	r7	;
	mov	r11,	30(r1)	; 0x001e

	mov	#0,	10(r1)	;r3 As==00, 0x000a
	mov	#-32768,12(r1)	;#0x8000, 0x000c

.L1104:
	mov	10(r1),	r14	;0x0000a
	add	r7,	r14	;
	mov	r14,	22(r1)	; 0x0016
	mov	30(r1),	r12	;0x0001e
	addcx.w	12(r1),	r12	;0x0000c
	mov	r12,	24(r1)	; 0x0018

	cmp	8(r1),	r9	;
	jl	.L1108     	;abs 0x7f82
	mov	8(r1),	r12	;
	cmp	r9,	r12	;
	jnz	.L1106      	;abs 0x7f54
	cmp	6(r1),	r8	;
	jnc	.L1108     	;abs 0x7f82

.L1106:
	mov	6(r1),	r12	;
	cmp	r8,	r12	;
	jnz	.L1122    	;abs 0x800a
	mov	8(r1),	r12	;
	cmp	r9,	r12	;
	jnz	.L1122    	;abs 0x800a

	mov	20(r1),	r12	;0x00014
	cmp	24(r1),	r12	;0x00018
	jnc	.L1122    	;abs 0x800a
	mov	24(r1),	r12	;0x00018
	cmp	20(r1),	r12	;0x00014
	jnz	.L1108     	;abs 0x7f82
	mov	18(r1),	r12	;0x00012
	cmp	22(r1),	r12	;0x00016
	jnc	.L1122    	;abs 0x800a

.L1108:
	mov	22(r1),	r7	;0x00016

	addx.w	10(r1),	r7	;0x0000a
	mov	24(r1),	r13	;0x00018
	addcx.w	12(r1),	r13	;0x0000c
	mov	r13,	30(r1)	; 0x001e

	mov	24(r1),	r12	;0x00018
	cmp	#0,	r12	;r3 As==00
	jge	.L1170    	;abs 0x81b2

	mov	r13,	r12	;
	mov	r8,	r13	;

	cmp	#0,	r12	;r3 As==00
	jl	.L1171    	;abs 0x81b4

	inc	r13		;
	mov	r9,	r12	;

	adc	r12		;

.L1115:
	subx.w	r8,	6(r1)	;
	subcx.w	r9,	8(r1)	;

	mov	20(r1),	r14	;0x00014
	cmp	24(r1),	r14	;0x00018
	jnc	.L1117     	;abs 0x7fda
	mov	24(r1),	r14	;0x00018
	cmp	20(r1),	r14	;0x00014
	jnz	.L1118     	;abs 0x7fea
	mov	18(r1),	r14	;0x00012
	cmp	22(r1),	r14	;0x00016
	jc	.L1118     	;abs 0x7fea

.L1117:
	addx.w	#65535,	6(r1)	;0x0ffff
	addcx.w	#65535,	8(r1)	;0x0ffff

.L1118:
	subx.w	22(r1),	18(r1)	;0x00016, 0x00012
	subcx.w	24(r1),	20(r1)	;0x00018, 0x00014

	addx.w	10(r1),	r10	;0x0000a

	addcx.w	12(r1),	r11	;0x0000c

	mov	r13,	r8	;
	mov	r12,	r9	;

.L1122:
	mov	18(r1),	r12	;0x00012
	mov	20(r1),	r13	;0x00014
	mov.b	#31,	r14	;#0x001f
	mova	r11,	2(r1)	;
	calla	#__mspabi_srll		;0x062e8
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
	jnz	.L1104    	;abs 0x7f28

	bis	18(r1),	r12	;0x00012
	bis	20(r1),	r13	;0x00014

	bis	r13,	r12	;
	cmp	#0,	r12	;r3 As==00
	jz	.L1132     	;abs 0x8088

	cmp	#-1,	r10	;r3 As==11
	jnz	.L1172    	;abs 0x81ba
	cmp	#-1,	r11	;r3 As==11
	jnz	.L1172    	;abs 0x81ba

	incx.w	14(r1)		;
	adcx.w	16(r1)		;

	clr.b	r10		;
	clr.b	r11		;

.L1132:
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
	jz	.L1141     	;abs 0x80be

	mov	r9,	r12	;
	bis	#-32768,r12	;#0x8000
	mov	r12,	r9	;

.L1141:
	mov	32(r1),	r12	;0x00020
	mov	34(r1),	r13	;0x00022
	mov.b	#20,	r14	;#0x0014
	calla	#__mspabi_slll		;0x062bc

	mov	6(r1),	r10	;

	add	r12,	r10	;
	addc	r13,	r7	;

	jmp .L1056	;mova	#32056,	r0	;0x07d38

.L1145:
	add	#-21,	r10	;#0xffeb

	addc	#-1,	r11	;r3 As==11

	mov	10(r1),	r12	;0x0000a
	mov	12(r1),	r13	;0x0000c
	mov.b	#11,	r14	;#0x000b
	mova	r11,	2(r1)	;
	calla	#__mspabi_srll		;0x062e8
	mov	r12,	14(r1)	; 0x000e

	mov	r13,	16(r1)	; 0x0010

	mov	10(r1),	r12	;0x0000a
	mov	12(r1),	r13	;0x0000c
	mov.b	#21,	r14	;#0x0015
	calla	#__mspabi_slll		;0x062bc
	mov	r12,	10(r1)	; 0x000a

	mov	r13,	12(r1)	; 0x000c

	mova	2(r1),	r11	;

.L1152:
	mov	14(r1),	r12	;0x0000e
	bis	16(r1),	r12	;0x00010
	cmp	#0,	r12	;r3 As==00
	jz	.L1145     	;abs 0x80da

.L1153:
	bitx.w	#16,	16(r1)	;0x00010, 0x00010
	jz	.L1166    	;abs 0x819a

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
	calla	#__mspabi_srll		;0x062e8

	bis	14(r1),	r12	;0x0000e
	bis	16(r1),	r13	;0x00010
	mov	r12,	14(r1)	; 0x000e

	mov	r13,	16(r1)	; 0x0010

	mov	10(r1),	r12	;0x0000a
	mov	12(r1),	r13	;0x0000c
	mov	r8,	r14	;
	clr	r15		;
	calla	#__mspabi_slll		;0x062bc
	mov	r12,	10(r1)	; 0x000a
	mov	r13,	12(r1)	; 0x000c

	mov	r9,	r8	;

	mov	r10,	r9	;

	jmp .L1073	;mova	#32176,	r0	;0x07db0

.L1164:
	mov	r8,	r10	;

	mov	r13,	r11	;
	jmp .L1152	;mova	#33048,	r0	;0x08118

.L1166:
	rlax.w	14(r1)		;#0x0000e
	rlcx.w	16(r1)		;#0x00010

	inc	r8		;

	adc	r9		;

	jmp .L1153	;mova	#33060,	r0	;0x08124

.L1170:
	mov	r8,	r13	;

.L1171:
	mov	r9,	r12	;
	jmp .L1115	;mova	#32688,	r0	;0x07fb0

.L1172:
	mov	r10,	r13	;
	inc	r13		;
	mov	r11,	r12	;
	adc	r12		;
	mov	r13,	r10	;

	bic	#1,	r10	;r3 As==01
	mov	r12,	r11	;

	jmp .L1132	;mova	#32904,	r0	;0x08088



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
	calla	#__mspabi_srll		;0x062e8

	reta			;



	.global __mspabi_mpyll
	.type __mspabi_mpyll, @function
__mspabi_mpyll:
	nop
	nop
	pushm.a	#4,	r10	;20-bit words

	suba	#36,	r1	;0x00024

	mov	r9,	16(r1)	; 0x0010
	mov	r10,	28(r1)	; 0x001c
	mov	r11,	30(r1)	; 0x001e
	mov	r12,	r7	;
	mov	r13,	18(r1)	; 0x0012
	mov	r14,	32(r1)	; 0x0020
	mov	r15,	34(r1)	; 0x0022

	mov	r8,	r9	;
	mov	r8,	20(r1)	; 0x0014

	mov	r8,	r12	;

	mov	16(r1),	r13	;0x00010
	mov.b	#16,	r14	;#0x0010
	calla	#__mspabi_srll		;0x062e8
	mov	r12,	4(r1)	;
	mov	r13,	6(r1)	;

	mov	r7,	22(r1)	; 0x0016

	mov	r7,	r12	;
	mov	18(r1),	r13	;0x00012
	mov.b	#16,	r14	;#0x0010
	calla	#__mspabi_srll		;0x062e8
	mov	r12,	12(r1)	; 0x000c
	mov	r13,	14(r1)	; 0x000e


	mov	r7,	r14	;
	clr.b	r15		;
	mov	r9,	r12	;
	mov	r15,	r13	;
	calla	#__mulsi2_f5		;

	mov	r12,	r11	;
	mov	r12,	24(r1)	; 0x0018
	mov	r13,	26(r1)	; 0x001a

	mov	r7,	r14	;
	clr.b	r15		;
	mov	4(r1),	r12	;
	mov	6(r1),	r13	;

	mova	r11,	0(r1)	;
	calla	#__mulsi2_f5		;

	mov	r12,	r7	;
	mov	r13,	r10	;

	mov	12(r1),	r14	;0x0000c
	mov	14(r1),	r15	;0x0000e
	mov	4(r1),	r12	;
	mov	6(r1),	r13	;
	calla	#__mulsi2_f5		;

	mov	r12,	4(r1)	;

	mov	r13,	6(r1)	;

	mov	12(r1),	r14	;0x0000c
	mov	14(r1),	r15	;0x0000e
	mov	r9,	r12	;
	clr.b	r13		;
	calla	#__mulsi2_f5		;

	mov	r12,	r9	;
	add	r7,	r9	;
	mov	r13,	r8	;
	addc	r10,	r8	;

	mova	@r1,	r11	;
	mov	r11,	r12	;
	mov	26(r1),	r13	;0x0001a
	mov.b	#16,	r14	;#0x0010
	calla	#__mspabi_srll		;0x062e8
	add	r12,	r9	;
	addc	r8,	r13	;

	cmp	r10,	r13	;
	jnc	.L1198     	;abs 0x82b8
	cmp	r13,	r10	;
	jnz	.L1199     	;abs 0x82c4
	cmp	r7,	r9	;
	jc	.L1199     	;abs 0x82c4

.L1198:
	addx.w	#0,	4(r1)	;r3 As==00
	addcx.w	#1,	6(r1)	;r3 As==01

.L1199:
	mov	r9,	r12	;
	mov.b	#16,	r14	;#0x0010
	calla	#__mspabi_srll		;0x062e8

	mov	r12,	r8	;
	addx.w	4(r1),	r8	;
	addcx.w	6(r1),	r13	;
	mov	r13,	r10	;

	clr.b	r7		;
	mov	r9,	r12	;
	mov	r7,	r13	;
	mov.b	#16,	r14	;#0x0010
	calla	#__mspabi_slll		;0x062bc
	mov	24(r1),	r15	;0x00018
	add	r15,	r12	;
	addc	r7,	r13	;

	mov	r12,	4(r1)	;

	mov	r13,	6(r1)	;
	mov	r8,	8(r1)	;
	mov	r10,	10(r1)	; 0x000a

	mov	32(r1),	r14	;0x00020
	mov	34(r1),	r15	;0x00022
	mov	20(r1),	r12	;0x00014
	mov	16(r1),	r13	;0x00010
	calla	#__mulsi2_f5		;

	mov	8(r1),	r8	;
	mov	10(r1),	r9	;0x0000a
	add	r12,	r8	;
	addc	r13,	r9	;

	mov	28(r1),	r14	;0x0001c
	mov	30(r1),	r15	;0x0001e
	mov	22(r1),	r12	;0x00016
	mov	18(r1),	r13	;0x00012
	calla	#__mulsi2_f5		;

	mov	r8,	r14	;
	add	r12,	r14	;
	mov	r9,	r15	;
	addc	r13,	r15	;

	mov	4(r1),	r12	;
	mov	6(r1),	r13	;
	adda	#36,	r1	;0x00024

	popm.a	#4,	r10	;20-bit words

	reta			;



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

	calla	#__unpack_d		;

	mova	r1,	r13	;
	adda	#30,	r13	;0x0001e
	mova	r1,	r12	;
	adda	#8,	r12	;
	calla	#__unpack_d		;

	mov.b	#1,	r12	;r3 As==01
	cmp	16(r1),	r12	;0x00010
	jc	.L1222     	;abs 0x83b2

	cmp	30(r1),	r12	;0x0001e
	jc	.L1219      	;abs 0x83aa
	clr.b	r12		;

.L1219:
	adda	#44,	r1	;0x0002c

	popm.a	#1,	r10	;20-bit words

	reta			;

.L1222:
	mov.b	#1,	r12	;r3 As==01
	jmp .L1219	;mova	#33706,	r0	;0x083aa

.L1223:
	add	#-1,	r14	;r3 As==11
	rra	r13		;
	rrc	r12		;



	.global __mspabi_sral
	.type __mspabi_sral, @function
__mspabi_sral:
	nop
	nop
	cmp	#0,	r14	;r3 As==00
	jnz	.L1223      	;abs 0x83b8
	reta			;



	.global __mulsi2_f5
	.type __mulsi2_f5, @function
__mulsi2_f5:
	nop
	nop
	push	r2		;
	dint			
	nop			
	mov	r12,	&0x04d0	;
	mov	r13,	&0x04d2	;
	mov	r14,	&0x04e0	;
	mov	r15,	&0x04e2	;
	mov	&0x04e4,r12	;0x04e4
	mov	&0x04e6,r13	;0x04e6
	pop	r2		;
	reta			;



	.global __errno
	.type __errno, @function
__errno:
	nop
	nop
	mova	&11264,	r12	;0x02c00
	reta			;



	.global _exit
	.type _exit, @function
_exit:
	nop
	nop
	jmp _exit	;mova	#33772,	r0	;0x083ec



	.global _sbrk
	.type _sbrk, @function
_sbrk:
	nop
	nop
	pushm.a	#1,	r10	;20-bit words

	suba	#4,	r1	;

	mov	r12,	r14	;

	mova	&11494,	r12	;0x02ce6

	clr.b	r13		;
	adda	r1,	r13	;
	mova	r13,	0(r1)	;

	rlam.a	#4,	r14	;
	rram.a	#4,	r14	;

	adda	r12,	r14	;

	mova	r1,	r10	;
	cmpa	r14,	r10	;
	jc	.L1234     	;abs 0x8422

	mov.b	#26,	r14	;#0x001a
	mova	#83328,	r13	;0x14580
	mov.b	#1,	r12	;r3 As==01

	calla	#write		;0x0842e

	calla	#abort		;0x084c4

.L1234:
	mova	r14,	&11494	; 0x02ce6

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

	mova	#11498,	r15	;0x02cea

.L1244:
	clr.b	r12		;
	cmp	r8,	r12	;
	jl	.L1248     	;abs 0x845a

	mov	r9,	r12	;
	adda	#10,	r1	;0x0000a

	popm.a	#4,	r10	;20-bit words

	reta			;

.L1248:
	mov	r8,	r10	;
	mov.b	#64,	r13	;#0x0040
	cmp	r8,	r13	;
	jge	.L1249      	;abs 0x8466
	mov	r13,	r10	;

.L1249:
	mov.b	r10,	r12	;
	mov.b	r12,	0(r15)	;

	movx.b	#0,	&0x02ceb;r3 As==00

	movx.b	#-13,	&0x02cec;0xffff3

	mov.b	r7,	3(r15)	;

	mov	4(r1),	r13	;
	mov.b	r13,	4(r15)	;

	mov.b	r12,	5(r15)	;

	movx.b	#0,	&0x02cf0;r3 As==00

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
	mova	#11509,	r12	;0x02cf5
	mova	r15,	0(r1)	;
	calla	#memcpy		;0x06878

	calla	#C$$IO$$		;0x084c0

	add	r10,	r9	;

	sub	r10,	r8	;

	mova	@r1,	r15	;
	jmp .L1244	;mova	#33866,	r0	;0x0844a



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
	calla	#raise		;0x085bc

	mov.b	#1,	r12	;r3 As==01
	calla	#_exit		;0x083ec



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
	jc	.L1283     	;abs 0x852a

	mova	r8,	r11	;
	adda	r14,	r11	;

	cmpa	r11,	r12	;
	jc	.L1283     	;abs 0x852a

	mova	r14,	r8	;

	xorx.a	#-1,	r8	;r3 As==11

	clr.b	r10		;

.L1273:
	adda	#1048575,r10	;0xfffff

	cmpa	r10,	r8	;
	jnz	.L1278     	;abs 0x8500

.L1275:
	mova	r15,	r12	;
	popm.a	#1,	r8	;20-bit words

	popm.a	#1,	r10	;20-bit words

	reta			;

.L1278:
	mova	r13,	r12	;
	adda	r10,	r12	;
	adda	r15,	r12	;
	mova	r11,	r14	;
	adda	r10,	r14	;

	mov.b	@r14,	0(r12)	;
	jmp .L1273	;mova	#34032,	r0	;0x084f0

.L1280:
	mova	r8,	r10	;
	adda	r12,	r10	;

	mova	r15,	r14	;
	adda	r12,	r14	;
	mov.b	@r10,	0(r14)	;
	adda	#1,	r12	;

.L1282:
	cmpa	r12,	r13	;
	jnz	.L1280     	;abs 0x8512
	jmp .L1275	;mova	#34040,	r0	;0x084f8

.L1283:
	clr.b	r12		;

	jmp .L1282	;mova	#34082,	r0	;0x08522



	.global memset
	.type memset, @function
memset:
	nop
	nop
	pushm.a	#1,	r10	;20-bit words

	adda	r12,	r14	;

	mova	r12,	r10	;

.L1287:
	cmpa	r14,	r10	;
	jnz	.L1290      	;abs 0x853e

	popm.a	#1,	r10	;20-bit words

	reta			;

.L1290:
	adda	#1,	r10	;

	mov.b	r13,	-1(r10)	; 0xffff
	jmp .L1287	;mova	#34102,	r0	;0x08536



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
	jc	.L1299     	;abs 0x8564

	mov	#22,	0(r10)	;#0x0016

	mov	#-1,	r12	;r3 As==11

.L1297:
	popm.a	#2,	r10	;20-bit words

	reta			;

.L1299:
	mova	56(r10),r12	;0x00038

	cmpa	#0,	r12	;
	jz	.L1304     	;abs 0x8580

	rlam.a	#4,	r13	;
	rram.a	#4,	r13	;
	mova	r13,	r14	;
	rlam.a	#2,	r14	;
	adda	r14,	r12	;

	mova	@r12,	r14	;

	cmpa	#0,	r14	;
	jnz	.L1307     	;abs 0x8594

.L1304:
	mova	r10,	r12	;
	calla	#_getpid_r		;0x085f0

	mov	r9,	r14	;
	mov	r12,	r13	;
	mova	r10,	r12	;
	calla	#_kill_r		;0x085c8

	jmp .L1297	;mova	#34144,	r0	;0x08560

.L1307:
	cmpa	#1,	r14	;
	jz	.L1313     	;abs 0x85b6

	cmpa	#1048575,r14	;0xfffff
	jnz	.L1311     	;abs 0x85ac

	mov	#22,	0(r10)	;#0x0016

	mov.b	#1,	r12	;r3 As==01
	jmp .L1297	;mova	#34144,	r0	;0x08560

.L1311:
	movx.a	#0,	0(r12)	;r3 As==00

	mov	r9,	r12	;
	calla	r14		;

.L1313:
	clr.b	r12		;
	jmp .L1297	;mova	#34144,	r0	;0x08560



	.global raise
	.type raise, @function
raise:
	nop
	nop
	mov	r12,	r13	;
	mova	&11264,	r12	;0x02c00

	calla	#_raise_r		;0x0854a

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

	movx.w	#0,	&0x02d3e;r3 As==00

	calla	#kill		;0x085fc

	cmp	#-1,	r12	;r3 As==11
	jnz	.L1324     	;abs 0x85ec

	movx.w	&0x02d3e,r13	;

	cmp	#0,	r13	;r3 As==00
	jz	.L1324      	;abs 0x85ec

	mov	r13,	0(r10)	;

.L1324:
	popm.a	#1,	r10	;20-bit words

	reta			;



	.global _getpid_r
	.type _getpid_r, @function
_getpid_r:
	nop
	nop
	calla	#getpid		;0x085f6

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
	calla	#__errno		;0x083e6
	movx.w	#88,	0(r12)	;0x00058
	mov	#-1,	r12	;r3 As==11
	reta			;
