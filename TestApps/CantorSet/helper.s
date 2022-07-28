


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
	jc	.L11     	;abs 0x49e0

	mova	r13,	r8	;

	mov	@r13,	r13	;

	cmp	r13,	r9	;
	jnc	.L7      	;abs 0x49c6
	jmp .L120	;mova	#20390,	r0	;0x04fa6

.L7:
	cmp	#4,	r12	;r2 As==10
	jnz	.L14     	;abs 0x49ea

	cmp	#4,	r13	;r2 As==10
	jnz	.L11     	;abs 0x49e0

	mova	@r1,	r12	;
	cmp	2(r8),	2(r12)	;
	jz	.L11     	;abs 0x49e0

	movx.a	#82944,	0(r1)	;0x14400

.L11:
	mova	@r1,	r12	;
	adda	#36,	r1	;0x00024

	popm.a	#4,	r10	;20-bit words

	reta			;

.L14:
	cmp	#4,	r13	;r2 As==10
	jnz	.L15      	;abs 0x49f2
	jmp .L120	;mova	#20390,	r0	;0x04fa6

.L15:
	cmp	#2,	r13	;r3 As==10
	jnz	.L20     	;abs 0x4a20

	cmp	#2,	r12	;r3 As==10
	jnz	.L11     	;abs 0x49e0

	mov.b	#14,	r14	;#0x000e
	mova	@r1,	r13	;
	mova	r7,	r12	;
	calla	#memcpy		;0x05870

	mova	@r1,	r13	;
	mov	2(r13),	r14	;
	mova	6(r1),	r13	;
	and	2(r13),	r14	;
	mov	r14,	2(r7)	;

.L19:
	mova	r7,	0(r1)	;
	jmp .L11	;mova	#18912,	r0	;0x049e0

.L20:
	cmp	#2,	r12	;r3 As==10
	jnz	.L21      	;abs 0x4a28
	jmp .L120	;mova	#20390,	r0	;0x04fa6

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
	jge	.L41    	;abs 0x4b80

	mov	28(r1),	r14	;0x0001c
	sub	18(r1),	r14	;0x00012
	mov	r14,	24(r1)	; 0x0018

	mov.b	#63,	r8	;#0x003f
	cmp	r14,	r8	;
	jl	.L83    	;abs 0x4dce

	mov	4(r1),	r8	;
	mov	12(r1),	r9	;0x0000c
	mov	22(r1),	r10	;0x00016
	mov	14(r1),	r11	;0x0000e
	mov	24(r1),	r12	;0x00018

	calla	#__mspabi_srlll		;0x053f0

	mov	r12,	18(r1)	; 0x0012

	mov	r13,	30(r1)	; 0x001e
	mov	r14,	32(r1)	; 0x0020
	mov	r15,	34(r1)	; 0x0022
	mov	#-1,	r8	;r3 As==11
	mov	r8,	r9	;
	mov	r8,	r10	;
	mov	r8,	r11	;
	mov	24(r1),	r12	;0x00018
	calla	#__mspabi_sllll		;0x053d2
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
	jnz	.L35      	;abs 0x4af8
	mov	r9,	r15	;

.L35:
	mov	r11,	r12	;
	sub	r13,	r12	;
	mov.b	#1,	r10	;r3 As==01
	cmp	r13,	r11	;
	jnz	.L36      	;abs 0x4b04
	mov	r12,	r10	;

.L36:
	mov	r12,	r9	;
	sub	r15,	r9	;
	mov	r9,	22(r1)	; 0x0016
	mov.b	#1,	r15	;r3 As==01
	cmp	r9,	r12	;
	jnc	.L37      	;abs 0x4b14
	clr.b	r15		;

.L37:
	bis	r15,	r10	;
	mov	r11,	r12	;
	sub	r14,	r12	;
	mov.b	#1,	r15	;r3 As==01
	cmp	r14,	r11	;
	jnz	.L38      	;abs 0x4b22
	mov	r12,	r15	;

.L38:
	mov	r12,	r9	;
	sub	r10,	r9	;
	mov	r9,	4(r1)	;
	mov.b	#1,	r10	;r3 As==01
	cmp	r9,	r12	;
	jnc	.L39      	;abs 0x4b32
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
	calla	#__mspabi_srlll		;0x053f0
	bis	18(r1),	r12	;0x00012
	mov	r12,	4(r1)	;
	bis	30(r1),	r13	;0x0001e
	mov	r13,	12(r1)	; 0x000c
	bis	32(r1),	r14	;0x00020
	mov	r14,	22(r1)	; 0x0016
	bis	34(r1),	r15	;0x00022
	mov	r15,	14(r1)	; 0x000e

	mov	28(r1),	18(r1)	;0x0001c, 0x0012
	jmp .L55	;mova	#19576,	r0	;0x04c78

.L41:
	mov.b	#63,	r9	;#0x003f
	cmp	24(r1),	r9	;0x00018
	jl	.L83    	;abs 0x4dce

	cmp	#0,	24(r1)	;r3 As==00, 0x0018
	jz	.L55    	;abs 0x4c78

	mov	10(r1),	r8	;0x0000a

	mov	20(r1),	r9	;0x00014
	mov	26(r1),	r10	;0x0001a
	mov	16(r1),	r11	;0x00010
	mov	24(r1),	r12	;0x00018

	calla	#__mspabi_srlll		;0x053f0

	mov	r12,	28(r1)	; 0x001c

	mov	r13,	30(r1)	; 0x001e
	mov	r14,	32(r1)	; 0x0020
	mov	r15,	34(r1)	; 0x0022
	mov	#-1,	r8	;r3 As==11
	mov	r8,	r9	;
	mov	r8,	r10	;
	mov	r8,	r11	;
	mov	24(r1),	r12	;0x00018
	calla	#__mspabi_sllll		;0x053d2
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
	jnz	.L49      	;abs 0x4bfa
	mov	r11,	r15	;

.L49:
	mov	r11,	r12	;
	sub	r13,	r12	;
	mov.b	#1,	r10	;r3 As==01
	cmp	r13,	r11	;
	jnz	.L50      	;abs 0x4c06
	mov	r12,	r10	;

.L50:
	mov	r12,	r9	;
	sub	r15,	r9	;
	mov	r9,	24(r1)	; 0x0018

	mov.b	#1,	r15	;r3 As==01
	cmp	r9,	r12	;
	jnc	.L52      	;abs 0x4c16
	clr.b	r15		;

.L52:
	bis	r15,	r10	;
	mov	r11,	r12	;
	sub	r14,	r12	;
	mov.b	#1,	r15	;r3 As==01
	cmp	r14,	r11	;
	jnz	.L53      	;abs 0x4c24
	mov	r12,	r15	;

.L53:
	mov	r12,	r9	;
	sub	r10,	r9	;
	mov	r9,	10(r1)	; 0x000a
	mov.b	#1,	r10	;r3 As==01
	cmp	r9,	r12	;
	jnc	.L54      	;abs 0x4c34
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
	calla	#__mspabi_srlll		;0x053f0
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
	jz	.L111    	;abs 0x4f2e

	cmp	#0,	r12	;r3 As==00
	jz	.L88    	;abs 0x4e10

	mov	10(r1),	r14	;0x0000a
	sub	4(r1),	r14	;
	mov.b	#1,	r10	;r3 As==01
	cmp	r14,	10(r1)	; 0x000a
	jnc	.L59      	;abs 0x4c9e
	clr.b	r10		;

.L59:
	mov	20(r1),	r12	;0x00014
	sub	12(r1),	r12	;0x0000c
	mov.b	#1,	r15	;r3 As==01
	cmp	r12,	20(r1)	; 0x0014
	jnc	.L60      	;abs 0x4cb0
	clr.b	r15		;

.L60:
	mov	r12,	r13	;
	sub	r10,	r13	;
	mov.b	#1,	r10	;r3 As==01
	cmp	r13,	r12	;
	jnc	.L61      	;abs 0x4cbc
	clr.b	r10		;

.L61:
	bis	r10,	r15	;
	mov	26(r1),	r9	;0x0001a
	sub	22(r1),	r9	;0x00016
	mov.b	#1,	r10	;r3 As==01
	cmp	r9,	26(r1)	; 0x001a
	jnc	.L62      	;abs 0x4cd0
	clr.b	r10		;

.L62:
	mov	r9,	r12	;
	sub	r15,	r12	;
	mov.b	#1,	r15	;r3 As==01
	cmp	r12,	r9	;
	jnc	.L63      	;abs 0x4cdc
	clr.b	r15		;

.L63:
	bis	r15,	r10	;
	mov	16(r1),	r11	;0x00010
	sub	14(r1),	r11	;0x0000e

.L64:
	sub	r10,	r11	;

	cmp	#0,	r11	;r3 As==00
	jl	.L94    	;abs 0x4e6e

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
	jnz	.L72      	;abs 0x4d2e
	mov	r14,	r9	;

.L72:
	mov	@r1,	r8	;
	add	#-1,	r8	;r3 As==11
	mov.b	#1,	r12	;r3 As==01
	cmp	#0,	0(r1)	;r3 As==00
	jnz	.L73      	;abs 0x4d3c
	clr.b	r12		;

.L73:
	add	r8,	r9	;
	mov	r11,	r13	;
	cmp	r8,	r9	;
	jnc	.L74      	;abs 0x4d46
	mov	r14,	r13	;

.L74:
	bis	r13,	r12	;
	mov	r10,	r13	;
	add	#-1,	r13	;r3 As==11
	mov	r13,	4(r1)	;
	mov.b	#1,	r13	;r3 As==01
	cmp	#0,	r10	;r3 As==00
	jnz	.L75      	;abs 0x4d58
	clr.b	r13		;

.L75:
	add	4(r1),	r12	;
	mov	r11,	r8	;
	cmp	4(r1),	r12	;
	jnc	.L76      	;abs 0x4d66
	mov	r14,	r8	;

.L76:
	bis	r8,	r13	;
	mov	6(r1),	r8	;
	add	#-1,	r8	;r3 As==11
	add	r8,	r13	;

	mov	#4095,	r8	;#0x0fff
	cmp	r13,	r8	;
	jnc	.L78     	;abs 0x4d8e
	cmp	r8,	r13	;
	jnz	.L104    	;abs 0x4ed2
	cmp	#-1,	r12	;r3 As==11
	jnz	.L104    	;abs 0x4ed2
	cmp	#-1,	r9	;r3 As==11
	jnz	.L104    	;abs 0x4ed2
	mov	#-2,	r9	;#0xfffe
	cmp	10(r1),	r9	;0x0000a
	jc	.L104    	;abs 0x4ed2

.L78:
	mov	#3,	0(r7)	;

	mov	6(r7),	r8	;
	mov	8(r7),	r9	;
	mov	10(r7),	r10	;0x0000a
	mov	12(r7),	r11	;0x0000c

	mov	#8191,	r12	;#0x1fff
	cmp	r11,	r12	;
	jc	.L19    	;abs 0x4a18

	mov.b	#1,	r12	;r3 As==01
	calla	#__mspabi_srlll		;0x053f0
	and.b	#1,	r8	;r3 As==01
	bis	r8,	r12	;
	mov	r12,	6(r7)	;
	mov	r13,	8(r7)	;
	mov	r14,	10(r7)	; 0x000a
	mov	r15,	12(r7)	; 0x000c

	inc	4(r7)		;
	jmp .L19	;mova	#18968,	r0	;0x04a18

.L83:
	cmp	18(r1),	28(r1)	;0x00012, 0x001c
	jl	.L86     	;abs 0x4df6
	mov	28(r1),	18(r1)	;0x0001c, 0x0012

	mov	#0,	4(r1)	;r3 As==00

	mov	4(r1),	12(r1)	; 0x000c
	mov	4(r1),	22(r1)	; 0x0016
	mov	4(r1),	14(r1)	; 0x000e
	jmp .L55	;mova	#19576,	r0	;0x04c78

.L86:
	mov	#0,	10(r1)	;r3 As==00, 0x000a

	mov	10(r1),	20(r1)	;0x0000a, 0x0014
	mov	10(r1),	26(r1)	;0x0000a, 0x001a
	mov	10(r1),	16(r1)	;0x0000a, 0x0010
	jmp .L55	;mova	#19576,	r0	;0x04c78

.L88:
	mov	4(r1),	r14	;
	sub	10(r1),	r14	;0x0000a
	mov.b	#1,	r10	;r3 As==01
	cmp	r14,	4(r1)	;
	jnc	.L89      	;abs 0x4e22
	mov	r12,	r10	;

.L89:
	mov	12(r1),	r12	;0x0000c
	sub	20(r1),	r12	;0x00014
	mov.b	#1,	r15	;r3 As==01
	cmp	r12,	12(r1)	; 0x000c
	jnc	.L90      	;abs 0x4e34
	clr.b	r15		;

.L90:
	mov	r12,	r13	;
	sub	r10,	r13	;
	mov.b	#1,	r10	;r3 As==01
	cmp	r13,	r12	;
	jnc	.L91      	;abs 0x4e40
	clr.b	r10		;

.L91:
	bis	r10,	r15	;
	mov	22(r1),	r9	;0x00016
	sub	26(r1),	r9	;0x0001a
	mov.b	#1,	r10	;r3 As==01
	cmp	r9,	22(r1)	; 0x0016
	jnc	.L92      	;abs 0x4e54
	clr.b	r10		;

.L92:
	mov	r9,	r12	;
	sub	r15,	r12	;
	mov.b	#1,	r15	;r3 As==01
	cmp	r12,	r9	;
	jnc	.L93      	;abs 0x4e60
	clr.b	r15		;

.L93:
	bis	r15,	r10	;
	mov	14(r1),	r11	;0x0000e
	sub	16(r1),	r11	;0x00010
	jmp .L64	;mova	#19686,	r0	;0x04ce6

.L94:
	mov	#1,	2(r7)	;r3 As==01

	mov	18(r1),	4(r7)	;0x00012

	clr.b	r15		;
	mov	r15,	r10	;
	sub	r14,	r10	;
	mov.b	#1,	r9	;r3 As==01
	cmp	r14,	r15	;
	jnz	.L97      	;abs 0x4e86
	mov	r10,	r9	;

.L97:
	mov	r15,	r8	;
	sub	r13,	r8	;
	mov.b	#1,	r14	;r3 As==01

	cmp	r13,	r15	;
	jnz	.L99      	;abs 0x4e92
	mov	r8,	r14	;

.L99:
	mov	r8,	r13	;
	sub	r9,	r13	;
	mov.b	#1,	r9	;r3 As==01
	cmp	r13,	r8	;
	jnc	.L100      	;abs 0x4e9e
	clr.b	r9		;

.L100:
	bis	r9,	r14	;
	mov	r15,	r8	;
	sub	r12,	r8	;
	mov.b	#1,	r9	;r3 As==01
	cmp	r12,	r15	;
	jnz	.L101      	;abs 0x4eac
	mov	r8,	r9	;

.L101:
	mov	r8,	r12	;
	sub	r14,	r12	;
	mov.b	#1,	r14	;r3 As==01
	cmp	r12,	r8	;
	jnc	.L102      	;abs 0x4eb8
	clr.b	r14		;

.L102:
	bis	r14,	r9	;
	sub	r11,	r15	;

	mov	r10,	6(r7)	;
	mov	r13,	8(r7)	;
	mov	r12,	10(r7)	; 0x000a
	sub	r9,	r15	;
	mov	r15,	12(r7)	; 0x000c
	jmp .L69	;mova	#19718,	r0	;0x04d06

.L104:
	mov	r15,	r9	;
	add	r15,	r9	;
	mov	r11,	r13	;
	cmp	r15,	r9	;
	jnc	.L105      	;abs 0x4ede
	mov	r14,	r13	;

.L105:
	mov	@r1,	r15	;
	rla	r15		;
	mov.b	#1,	r12	;r3 As==01
	cmp	@r1,	r15	;
	jnc	.L106      	;abs 0x4eea
	clr.b	r12		;

.L106:
	add	r15,	r13	;
	mov	r11,	r8	;
	cmp	r15,	r13	;
	jnc	.L107      	;abs 0x4ef4
	mov	r14,	r8	;

.L107:
	bis	r8,	r12	;
	mov	r10,	r8	;
	add	r10,	r8	;
	mov.b	#1,	r15	;r3 As==01
	cmp	r10,	r8	;
	jnc	.L108      	;abs 0x4f02
	clr.b	r15		;

.L108:
	add	r8,	r12	;
	mov	r11,	r10	;
	cmp	r8,	r12	;
	jnc	.L109      	;abs 0x4f0c
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
	jmp .L70	;mova	#19722,	r0	;0x04d0a

.L111:
	mov	r12,	2(r7)	;

	mov	18(r1),	4(r7)	;0x00012

	mov	4(r1),	r8	;
	add	10(r1),	r8	;0x0000a
	mov.b	#1,	r10	;r3 As==01
	cmp	4(r1),	r8	;
	jnc	.L114      	;abs 0x4f4a
	clr.b	r10		;

.L114:
	mov	12(r1),	r13	;0x0000c
	add	20(r1),	r13	;0x00014
	mov.b	#1,	r15	;r3 As==01
	cmp	12(r1),	r13	;0x0000c
	jnc	.L115      	;abs 0x4f5c
	clr.b	r15		;

.L115:
	add	r13,	r10	;
	mov.b	#1,	r12	;r3 As==01
	cmp	r13,	r10	;
	jnc	.L116      	;abs 0x4f66
	clr.b	r12		;

.L116:
	bis	r12,	r15	;
	mov	22(r1),	r14	;0x00016
	add	26(r1),	r14	;0x0001a
	mov.b	#1,	r9	;r3 As==01
	cmp	22(r1),	r14	;0x00016
	jnc	.L117      	;abs 0x4f7a
	clr.b	r9		;

.L117:
	mov	r15,	r13	;
	add	r14,	r13	;
	mov.b	#1,	r12	;r3 As==01
	cmp	r14,	r13	;
	jnc	.L118      	;abs 0x4f86
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
	jmp .L78	;mova	#19854,	r0	;0x04d8e

.L120:
	movx.a	6(r1),	0(r1)	;


	jmp .L11	;mova	#18912,	r0	;0x049e0



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
	calla	#_fpadd_parts		;0x049a0

	calla	#__pack_d		;0x05410

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
	calla	#_fpadd_parts		;0x049a0

	calla	#__pack_d		;0x05410

	adda	#58,	r1	;0x0003a

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
	calla	#__unpack_d		;

	mova	r1,	r13	;
	adda	#58,	r13	;0x0003a
	mova	r1,	r12	;
	adda	#36,	r12	;0x00024
	calla	#__unpack_d		;

	mov	44(r1),	r13	;0x0002c

	mov.b	#1,	r12	;r3 As==01
	cmp	r13,	r12	;
	jnc	.L157     	;abs 0x50e0

.L152:
	mova	r1,	r12	;
	adda	#44,	r12	;0x0002c

.L153:
	calla	#__pack_d		;0x05410

	adda	#72,	r1	;0x00048

	popm.a	#4,	r10	;20-bit words

	reta			;

.L157:
	mov	58(r1),	r12	;0x0003a

	mov.b	#1,	r14	;r3 As==01
	cmp	r12,	r14	;
	jc	.L221    	;abs 0x53c8

	xor	60(r1),	46(r1)	;0x0003c, 0x002e

	cmp	#4,	r13	;r2 As==10
	jz	.L162      	;abs 0x50f8

	cmp	#2,	r13	;r3 As==10
	jnz	.L164     	;abs 0x5104

.L162:
	cmp	r12,	r13	;
	jnz	.L152     	;abs 0x50ce

	mova	#82944,	r12	;0x14400
	jmp .L153	;mova	#20692,	r0	;0x050d4

.L164:
	cmp	#4,	r12	;r2 As==10
	jnz	.L168     	;abs 0x5120

	mov	#0,	50(r1)	;r3 As==00, 0x0032
	mov	#0,	52(r1)	;r3 As==00, 0x0034
	mov	#0,	54(r1)	;r3 As==00, 0x0036
	mov	#0,	56(r1)	;r3 As==00, 0x0038

	mov	#0,	48(r1)	;r3 As==00, 0x0030

	jmp .L152	;mova	#20686,	r0	;0x050ce

.L168:
	cmp	#2,	r12	;r3 As==10
	jnz	.L171     	;abs 0x512c

	mov	#4,	44(r1)	;r2 As==10, 0x002c

	jmp .L152	;mova	#20686,	r0	;0x050ce

.L171:
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
	jnc	.L176     	;abs 0x519a
	cmp	6(r1),	16(r1)	; 0x0010
	jnz	.L185    	;abs 0x51fa
	cmp	14(r1),	r7	;0x0000e
	jnc	.L176     	;abs 0x519a
	cmp	r7,	14(r1)	; 0x000e
	jnz	.L185    	;abs 0x51fa
	cmp	12(r1),	2(r1)	;0x0000c
	jnc	.L176     	;abs 0x519a
	cmp	2(r1),	12(r1)	; 0x000c
	jnz	.L185    	;abs 0x51fa
	cmp	22(r1),	4(r1)	;0x00016
	jc	.L185     	;abs 0x51fa

.L176:
	mov	4(r1),	r9	;
	rla	r9		;
	mov.b	#1,	r13	;r3 As==01
	cmp	4(r1),	r9	;
	jnc	.L177      	;abs 0x51aa
	clr.b	r13		;

.L177:
	mov	2(r1),	r14	;
	rla	r14		;
	mov.b	#1,	r12	;r3 As==01
	cmp	2(r1),	r14	;
	jnc	.L178      	;abs 0x51ba
	clr.b	r12		;

.L178:
	add	r14,	r13	;
	mov.b	#1,	r15	;r3 As==01
	cmp	r14,	r13	;
	jnc	.L179      	;abs 0x51c4
	clr.b	r15		;

.L179:
	bis	r15,	r12	;
	mov	r7,	r15	;
	add	r7,	r15	;
	mov.b	#1,	r14	;r3 As==01
	cmp	r7,	r15	;
	jnc	.L180      	;abs 0x51d2
	clr.b	r14		;

.L180:
	add	r15,	r12	;
	mov.b	#1,	r8	;r3 As==01

	cmp	r15,	r12	;
	jnc	.L182      	;abs 0x51dc
	clr.b	r8		;

.L182:
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

.L185:
	mov	#61,	20(r1)	;#0x003d, 0x0014

	mov	#0,	0(r1)	;r3 As==00
	mov	@r1,	8(r1)	;
	mov	@r1,	10(r1)	; 0x000a
	mov	@r1,	18(r1)	; 0x0012

	mov	@r1,	r8	;
	mov	r8,	24(r1)	; 0x0018
	mov	r8,	r10	;
	mov	#4096,	r11	;#0x1000

.L188:
	cmp	16(r1),	6(r1)	;0x00010
	jnc	.L198    	;abs 0x52d2
	cmp	6(r1),	16(r1)	; 0x0010
	jnz	.L189     	;abs 0x5250
	cmp	14(r1),	r7	;0x0000e
	jnc	.L198    	;abs 0x52d2
	cmp	r7,	14(r1)	; 0x000e
	jnz	.L189     	;abs 0x5250
	cmp	12(r1),	2(r1)	;0x0000c
	jnc	.L198    	;abs 0x52d2
	cmp	2(r1),	12(r1)	; 0x000c
	jnz	.L189     	;abs 0x5250
	cmp	22(r1),	4(r1)	;0x00016
	jnc	.L198    	;abs 0x52d2

.L189:
	bis	r8,	0(r1)	;

	bis	24(r1),	8(r1)	;0x00018
	bis	r10,	10(r1)	; 0x000a
	bis	r11,	18(r1)	; 0x0012

	mov	4(r1),	r12	;
	sub	22(r1),	r12	;0x00016
	mov	r12,	26(r1)	; 0x001a
	mov.b	#1,	r14	;r3 As==01
	cmp	r12,	4(r1)	;
	jnc	.L192      	;abs 0x5278
	clr.b	r14		;

.L192:
	mov	2(r1),	r12	;
	sub	12(r1),	r12	;0x0000c
	mov.b	#1,	r13	;r3 As==01
	cmp	r12,	2(r1)	;
	jnc	.L193      	;abs 0x528a
	clr.b	r13		;

.L193:
	mov	r12,	r9	;
	sub	r14,	r9	;
	mov.b	#1,	r14	;r3 As==01
	cmp	r9,	r12	;
	jnc	.L194      	;abs 0x5296
	clr.b	r14		;

.L194:
	bis	r14,	r13	;
	movx.w	r7,	r14	;
	subx.w	14(r1),	r14	;0x0000e
	mov.b	#1,	r12	;r3 As==01
	cmp	r14,	r7	;
	jnc	.L195      	;abs 0x52aa
	clr.b	r12		;

.L195:
	mov	r14,	r15	;
	sub	r13,	r15	;
	mov.b	#1,	r13	;r3 As==01
	cmp	r15,	r14	;
	jnc	.L196      	;abs 0x52b6
	clr.b	r13		;

.L196:
	bis	r13,	r12	;
	mov	6(r1),	r13	;
	sub	16(r1),	r13	;0x00010
	mov	26(r1),	4(r1)	;0x0001a

	mov	r9,	2(r1)	;
	mov	r15,	r7	;
	sub	r12,	r13	;
	mov	r13,	6(r1)	;

.L198:
	mov	24(r1),	r9	;0x00018
	mov.b	#1,	r12	;r3 As==01
	calla	#__mspabi_srlll		;0x053f0
	mov	r12,	r8	;
	mov	r13,	24(r1)	; 0x0018
	mov	r14,	r10	;
	mov	r15,	r11	;

	mov	4(r1),	r12	;
	rla	r12		;
	mov.b	#1,	r9	;r3 As==01
	cmp	4(r1),	r12	;
	jnc	.L200      	;abs 0x52f6
	clr.b	r9		;

.L200:
	mov	2(r1),	r14	;
	rla	r14		;
	mov.b	#1,	r13	;r3 As==01

	cmp	2(r1),	r14	;
	jnc	.L202      	;abs 0x5306
	clr.b	r13		;

.L202:
	add	r14,	r9	;
	mov.b	#1,	r15	;r3 As==01
	cmp	r14,	r9	;
	jnc	.L203      	;abs 0x5310
	clr.b	r15		;

.L203:
	bis	r15,	r13	;
	mov	r7,	r15	;
	add	r7,	r15	;
	mov.b	#1,	r14	;r3 As==01
	cmp	r7,	r15	;
	jnc	.L204      	;abs 0x531e
	clr.b	r14		;

.L204:
	add	r15,	r13	;
	mov.b	#1,	r7	;r3 As==01

	cmp	r15,	r13	;
	jnc	.L206      	;abs 0x5328
	clr.b	r7		;

.L206:
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
	jnz	.L188    	;abs 0x521c

	mov	@r1,	r15	;
	and.b	#255,	r15	;#0x00ff

	mov	@r1,	r14	;

	cmp.b	#-128,	r14	;#0xff80
	jnz	.L220     	;abs 0x53ae

	bit	#256,	r14	;#0x0100
	jnz	.L220     	;abs 0x53ae

	bis	r9,	r12	;

	bis	r13,	r12	;
	bis	6(r1),	r12	;
	cmp	#0,	r12	;r3 As==00
	jz	.L220     	;abs 0x53ae

	add	r14,	r15	;
	mov.b	#1,	r13	;r3 As==01
	cmp	r14,	r15	;
	jnc	.L215      	;abs 0x5376
	mov	20(r1),	r13	;0x00014

.L215:
	clr.b	r12		;
	add	8(r1),	r13	;
	mov.b	#1,	r14	;r3 As==01
	cmp	8(r1),	r13	;
	jnc	.L216      	;abs 0x5386
	mov	r12,	r14	;

.L216:
	bis	r14,	r12	;
	clr.b	r14		;
	add	10(r1),	r12	;0x0000a
	mov.b	#1,	r10	;r3 As==01

	cmp	10(r1),	r12	;0x0000a
	jnc	.L218      	;abs 0x5398
	mov	r14,	r10	;

.L218:
	bis	r10,	r14	;

	and	#-256,	r15	;#0xff00
	mov	r15,	0(r1)	;
	mov	r13,	8(r1)	;
	mov	r12,	10(r1)	; 0x000a
	add	r14,	18(r1)	; 0x0012

.L220:
	mov	@r1,	50(r1)	; 0x0032
	mov	8(r1),	52(r1)	; 0x0034
	mov	10(r1),	54(r1)	;0x0000a, 0x0036
	mov	18(r1),	56(r1)	;0x00012, 0x0038
	jmp .L152	;mova	#20686,	r0	;0x050ce

.L221:
	mova	r1,	r12	;
	adda	#58,	r12	;0x0003a
	jmp .L153	;mova	#20692,	r0	;0x050d4



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
	jnz	.L222      	;abs 0x53e2
	reta			;

.L222:
	rla	r12		;
	rlc	r13		;
	rlc	r14		;
	rlc	r15		;
	add	#-1,	r11	;r3 As==11
	jnz	.L222     	;abs 0x53e2
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
	jnz	.L223      	;abs 0x5400
	reta			;

.L223:
	clrc			
	rrc	r15		;
	rrc	r14		;
	rrc	r13		;
	rrc	r12		;
	add	#-1,	r11	;r3 As==11
	jnz	.L223     	;abs 0x5400
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
	jnc	.L241     	;abs 0x5498

	mov	@r1,	r8	;
	mov	4(r1),	r9	;
	mov	6(r1),	r10	;
	mov	2(r1),	r11	;
	mov.b	#8,	r12	;r2 As==11

	calla	#__mspabi_srlll		;0x053f0

	and.b	#7,	r15	;

	mov	r12,	0(r1)	;
	mov	r13,	4(r1)	;
	mov	r14,	6(r1)	;
	bis	#8,	r15	;r2 As==11

	mov	r15,	2(r1)	;

	mov	#2047,	r7	;#0x07ff

.L235:
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

.L241:
	cmp	#4,	r13	;r2 As==10
	jz	.L293    	;abs 0x56e8

	cmp	#2,	r13	;r3 As==10
	jz	.L290    	;abs 0x56d2

	mov	@r1,	r7	;
	bis	4(r1),	r7	;
	bis	6(r1),	r7	;
	bis	2(r1),	r7	;
	cmp	#0,	r7	;r3 As==00
	jz	.L235     	;abs 0x546a

	mov	4(r12),	r7	;

	cmp	#-1022,	r7	;#0xfc02
	jge	.L272    	;abs 0x5618

	mov	#-1022,	r12	;#0xfc02

	sub	r7,	r12	;
	mov	r12,	8(r1)	;

	mov.b	#56,	r14	;#0x0038
	cmp	r12,	r14	;
	jl	.L264    	;abs 0x55b8

	mov	@r1,	r8	;
	mov	4(r1),	r9	;
	mov	6(r1),	r10	;
	mov	2(r1),	r11	;
	calla	#__mspabi_srlll		;0x053f0

	mov	r12,	12(r1)	; 0x000c
	mov	r13,	14(r1)	; 0x000e
	mov	r14,	16(r1)	; 0x0010
	mov	r15,	18(r1)	; 0x0012

	mov	#-1,	r8	;r3 As==11
	mov	r8,	r9	;
	mov	r8,	r10	;
	mov	r8,	r11	;
	mov	8(r1),	r12	;
	calla	#__mspabi_sllll		;0x053d2
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
	jnz	.L253      	;abs 0x5532
	mov	r15,	r10	;

.L253:
	mov	r11,	r15	;
	sub	r13,	r15	;
	mov.b	#1,	r7	;r3 As==01
	cmp	r13,	r11	;
	jnz	.L254      	;abs 0x553e
	mov	r15,	r7	;

.L254:
	mov	r15,	r9	;
	sub	r10,	r9	;
	mov.b	#1,	r10	;r3 As==01
	cmp	r9,	r15	;
	jnc	.L255      	;abs 0x554a
	clr.b	r10		;

.L255:
	bis	r10,	r7	;
	mov	r11,	r8	;
	sub	r14,	r8	;
	mov.b	#1,	r15	;r3 As==01
	cmp	r14,	r11	;
	jnz	.L256      	;abs 0x5558
	mov	r8,	r15	;

.L256:
	mov	r8,	r10	;
	sub	r7,	r10	;
	mov.b	#1,	r7	;r3 As==01
	cmp	r10,	r8	;
	jnc	.L257      	;abs 0x5564
	clr.b	r7		;

.L257:
	bis	r7,	r15	;
	sub	2(r1),	r11	;
	sub	r15,	r11	;
	mov	@r1,	r8	;
	bis	r12,	r8	;
	bis	r13,	r9	;
	bis	r14,	r10	;
	bis	2(r1),	r11	;
	mov.b	#63,	r12	;#0x003f
	calla	#__mspabi_srlll		;0x053f0

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
	jnz	.L265     	;abs 0x55c0

	bit	#256,	r8	;#0x0100
	jz	.L269     	;abs 0x55f2

	add	r8,	r15	;
	mov.b	#1,	r13	;r3 As==01
	cmp	r8,	r15	;
	jnc	.L266     	;abs 0x55ce

.L263:
	clr.b	r13		;
	jmp .L266	;mova	#21966,	r0	;0x055ce

.L264:
	clr.b	r8		;
	mov	r8,	r9	;
	mov	r8,	r10	;
	mov	r8,	r11	;

.L265:
	mov	r8,	r15	;
	add	#127,	r15	;#0x007f
	mov.b	#1,	r13	;r3 As==01
	cmp	#-127,	r8	;#0xff81
	jnc	.L263     	;abs 0x55b2

.L266:
	clr.b	r12		;
	add	r9,	r13	;
	mov.b	#1,	r14	;r3 As==01
	cmp	r9,	r13	;
	jnc	.L267      	;abs 0x55da
	mov	r12,	r14	;

.L267:
	bis	r14,	r12	;
	clr.b	r14		;
	add	r10,	r12	;
	mov.b	#1,	r9	;r3 As==01
	cmp	r10,	r12	;
	jnc	.L268      	;abs 0x55e8
	mov	r14,	r9	;

.L268:
	bis	r9,	r14	;
	mov	r15,	r8	;
	mov	r13,	r9	;
	mov	r12,	r10	;
	add	r14,	r11	;

.L269:
	mov.b	#1,	r7	;r3 As==01
	mov	#4095,	r12	;#0x0fff
	cmp	r11,	r12	;
	jnc	.L270      	;abs 0x55fe
	clr.b	r7		;

.L270:
	mov.b	#8,	r12	;r2 As==11
	calla	#__mspabi_srlll		;0x053f0
	mov	r12,	0(r1)	;
	mov	r13,	4(r1)	;
	mov	r14,	6(r1)	;
	mov	r15,	2(r1)	;

	jmp .L235	;mova	#21610,	r0	;0x0546a

.L272:
	mov	#1023,	r14	;#0x03ff
	cmp	r7,	r14	;
	jl	.L293    	;abs 0x56e8

	mov	@r1,	r12	;

	cmp.b	#-128,	r12	;#0xff80
	jnz	.L278     	;abs 0x5642

	bit	#256,	r12	;#0x0100
	jz	.L283     	;abs 0x5686

	mov	r12,	r10	;
	add	#128,	r10	;#0x0080
	mov.b	#1,	r13	;r3 As==01
	cmp	#-128,	r12	;#0xff80
	jc	.L279     	;abs 0x5652

.L277:
	clr.b	r13		;
	jmp .L279	;mova	#22098,	r0	;0x05652

.L278:
	mov	@r1,	r10	;
	add	#127,	r10	;#0x007f
	mov.b	#1,	r13	;r3 As==01
	cmp	#-127,	0(r1)	;#0xff81
	jnc	.L277     	;abs 0x563c

.L279:
	clr.b	r12		;
	add	4(r1),	r13	;
	mov.b	#1,	r14	;r3 As==01
	cmp	4(r1),	r13	;
	jnc	.L280      	;abs 0x5662
	mov	r12,	r14	;

.L280:
	bis	r14,	r12	;
	clr.b	r14		;
	add	6(r1),	r12	;
	mov.b	#1,	r15	;r3 As==01
	cmp	6(r1),	r12	;
	jnc	.L281      	;abs 0x5674
	mov	r14,	r15	;

.L281:
	bis	r15,	r14	;
	mov	r10,	0(r1)	;

	mov	r13,	4(r1)	;
	mov	r12,	6(r1)	;
	add	r14,	2(r1)	;

.L283:
	mov	#8191,	r14	;#0x1fff
	cmp	2(r1),	r14	;
	jnc	.L286     	;abs 0x56a6

	add	#1023,	r7	;#0x03ff

.L285:
	mov	@r1,	r8	;
	mov	4(r1),	r9	;
	mov	6(r1),	r10	;
	mov	2(r1),	r11	;
	jmp .L270	;mova	#22014,	r0	;0x055fe

.L286:
	mov	@r1,	r8	;
	mov	4(r1),	r9	;
	mov	6(r1),	r10	;
	mov	2(r1),	r11	;
	mov.b	#1,	r12	;r3 As==01
	calla	#__mspabi_srlll		;0x053f0
	mov	r12,	0(r1)	;

	mov	r13,	4(r1)	;
	mov	r14,	6(r1)	;
	mov	r15,	2(r1)	;

	add	#1024,	r7	;#0x0400

	jmp .L285	;mova	#22164,	r0	;0x05694

.L290:
	clr.b	r7		;

	mov	r7,	0(r1)	;

	mov	r7,	4(r1)	;
	mov	r7,	6(r1)	;
	mov	r7,	2(r1)	;
	jmp .L235	;mova	#21610,	r0	;0x0546a

.L293:
	mov	#2047,	r7	;#0x07ff

	mov	#0,	0(r1)	;r3 As==00

	mov	@r1,	4(r1)	;
	mov	@r1,	6(r1)	;
	mov	@r1,	2(r1)	;
	jmp .L235	;mova	#21610,	r0	;0x0546a



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
	jnz	.L328    	;abs 0x57de

	mov	r8,	r12	;
	bis	r9,	r12	;
	bis	r10,	r12	;
	bis	r11,	r12	;
	cmp	#0,	r12	;r3 As==00
	jnz	.L310     	;abs 0x5752

	mov	#2,	0(r7)	;r3 As==10

.L307:
	adda	#6,	r1	;

	popm.a	#4,	r10	;20-bit words

	reta			;

.L310:
	mov.b	#8,	r12	;r2 As==11
	calla	#__mspabi_sllll		;0x053d2

	mov	r12,	r10	;

	mov	#3,	0(r7)	;

	mov	#-1023,	4(r1)	;#0xfc01

	mov.b	#1,	r8	;r3 As==01

.L315:
	mov	r10,	r9	;
	add	r10,	r9	;
	mov	r9,	2(r1)	;
	mov	r8,	r11	;
	cmp	r10,	r9	;
	jnc	.L316      	;abs 0x5778
	clr.b	r11		;

.L316:
	mov	r13,	r10	;

	add	r13,	r10	;
	mov.b	#1,	r12	;r3 As==01
	cmp	r13,	r10	;
	jnc	.L318      	;abs 0x5784
	clr.b	r12		;

.L318:
	add	r10,	r11	;
	mov	r8,	r13	;
	cmp	r10,	r11	;
	jnc	.L319      	;abs 0x578e
	clr.b	r13		;

.L319:
	bis	r13,	r12	;
	mov	r14,	r13	;
	add	r14,	r13	;
	mov.b	#1,	r9	;r3 As==01
	cmp	r14,	r13	;
	jnc	.L320      	;abs 0x579c
	clr.b	r9		;

.L320:
	add	r13,	r12	;
	mov	r8,	r14	;
	cmp	r13,	r12	;
	jnc	.L321      	;abs 0x57a6
	clr.b	r14		;

.L321:
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
	jc	.L315     	;abs 0x5768

	mov	@r1,	4(r7)	;

	mov	r10,	6(r7)	;
	mov	r11,	8(r7)	;
	mov	r12,	10(r7)	; 0x000a

.L326:
	mov	r15,	12(r7)	; 0x000c

	jmp .L307	;mova	#22346,	r0	;0x0574a

.L328:
	cmp	#2047,	2(r1)	;#0x07ff
	jnz	.L336     	;abs 0x582c

	mov	r8,	r12	;
	bis	r9,	r12	;
	bis	r10,	r12	;
	bis	r11,	r12	;
	cmp	#0,	r12	;r3 As==00
	jnz	.L331     	;abs 0x57fa

	mov	#4,	0(r7)	;r2 As==10
	jmp .L307	;mova	#22346,	r0	;0x0574a

.L331:
	mov	r13,	r12	;
	and.b	#8,	r12	;r2 As==11
	bit	#8,	r13	;r2 As==11
	jz	.L335     	;abs 0x5824

	mov	#1,	0(r7)	;r3 As==01

.L333:
	mov.b	#8,	r12	;r2 As==11
	calla	#__mspabi_sllll		;0x053d2

	and	#-256,	r12	;#0xff00
	mov	r12,	6(r7)	;
	mov	r13,	8(r7)	;
	mov	r14,	10(r7)	; 0x000a
	and	#-2049,	r15	;#0xf7ff
	jmp .L326	;mova	#22486,	r0	;0x057d6

.L335:
	mov	r12,	0(r7)	;
	jmp .L333	;mova	#22534,	r0	;0x05806

.L336:
	mov	2(r1),	r12	;
	add	#-1023,	r12	;#0xfc01
	mov	r12,	4(r7)	;

	mov	#3,	0(r7)	;

	mov.b	#8,	r12	;r2 As==11
	calla	#__mspabi_sllll		;0x053d2

	mov	r12,	6(r7)	;
	mov	r13,	8(r7)	;
	mov	r14,	10(r7)	; 0x000a
	bis	#4096,	r15	;#0x1000
	jmp .L326	;mova	#22486,	r0	;0x057d6



	.global malloc
	.type malloc, @function
malloc:
	nop
	nop
	mova	r12,	r13	;
	mova	&11264,	r12	;0x02c00

	calla	#_malloc_r		;0x059d4

	reta			;



	.global free
	.type free, @function
free:
	nop
	nop
	mova	r12,	r13	;
	mova	&11264,	r12	;0x02c00

	calla	#_free_r		;0x0589a

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

.L347:
	cmpa	r12,	r15	;
	jnz	.L352     	;abs 0x5886

	mova	r8,	r12	;

	popm.a	#1,	r8	;20-bit words

	popm.a	#1,	r10	;20-bit words

	reta			;

.L352:
	mova	r8,	r14	;
	adda	r12,	r14	;

	mova	r13,	r10	;
	adda	r12,	r10	;

	mov.b	@r10,	0(r14)	;
	adda	#1,	r12	;

	jmp .L347	;mova	#22650,	r0	;0x0587a



	.global _free_r
	.type _free_r, @function
_free_r:
	nop
	nop
	pushm.a	#4,	r10	;20-bit words

	suba	#4,	r1	;

	mova	r12,	r9	;

	cmpa	#0,	r13	;
	jz	.L376    	;abs 0x590c

	mova	r13,	r12	;

	adda	#1048572,r12	;0xffffc

	mov	-2(r13),r15	;
	mov	-4(r13),r14	;

	cmp	#0,	r15	;r3 As==00
	jge	.L365     	;abs 0x58c2

	push	r15		;
	push	r14		;
	popm.a	#1,	r14	;20-bit words

	adda	r14,	r12	;

.L365:
	mova	&11576,	r8	;0x02d38

	cmpa	#0,	r8	;
	jnz	.L368     	;abs 0x58d4

.L367:
	mova	r8,	4(r12)	;
	jmp .L375	;mova	#22792,	r0	;0x05908

.L368:
	cmpa	r8,	r12	;
	jc	.L379     	;abs 0x5914

	mov	@r12,	r10	;
	mov	2(r12),	r11	;

	push	r11		;
	push	r10		;
	popm.a	#1,	r14	;20-bit words
	adda	r12,	r14	;

	cmpa	r14,	r8	;
	jnz	.L367     	;abs 0x58cc

	mov	r10,	r13	;

	mov	r11,	r14	;
	addx.w	@r8,	r13	;
	addcx.w	2(r8),	r14	;
	mov	r13,	0(r12)	;
	mov	r14,	2(r12)	;

	movx.a	4(r8),	4(r12)	;

.L375:
	mova	r12,	&11576	; 0x02d38

.L376:
	adda	#4,	r1	;

	popm.a	#4,	r10	;20-bit words

	reta			;

.L379:
	mova	r8,	r13	;

	mova	4(r8),	r8	;

	cmpa	#0,	r8	;
	jz	.L383      	;abs 0x5924

	cmpa	r8,	r12	;
	jc	.L379     	;abs 0x5914

.L383:
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
	jnz	.L392     	;abs 0x5986

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
	jnz	.L376     	;abs 0x590c

	mov	r10,	r14	;
	mov	r11,	r15	;
	addx.w	@r8,	r14	;
	addcx.w	2(r8),	r15	;
	mov	r14,	0(r13)	;
	mov	r15,	2(r13)	;

	movx.a	4(r8),	4(r13)	;
	jmp .L376	;mova	#22796,	r0	;0x0590c

.L392:
	cmpa	r14,	r12	;
	jc	.L395     	;abs 0x5994

	mov	#12,	0(r9)	;#0x000c

	jmp .L376	;mova	#22796,	r0	;0x0590c

.L395:
	mov	@r12,	r10	;
	mov	2(r12),	r11	;

	push	r11		;
	push	r10		;
	popm.a	#1,	r14	;20-bit words
	adda	r12,	r14	;

	cmpa	r14,	r8	;
	jnz	.L402     	;abs 0x59cc

	mov	r10,	r14	;
	mov	r11,	r15	;
	addx.w	@r8,	r14	;
	addcx.w	2(r8),	r15	;
	mov	r14,	0(r12)	;
	mov	r15,	2(r12)	;

	movx.a	4(r8),	4(r12)	;

.L400:
	mova	r12,	4(r13)	;

	jmp .L376	;mova	#22796,	r0	;0x0590c

.L402:
	mova	r8,	4(r12)	;
	jmp .L400	;mova	#22980,	r0	;0x059c4



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
	jc	.L408      	;abs 0x59f4
	mov.b	#12,	r10	;#0x000c

.L408:
	cmpa	r12,	r10	;
	jc	.L413     	;abs 0x5a04

.L409:
	mov	#12,	0(r9)	;#0x000c

	clr.b	r12		;

.L411:
	popm.a	#4,	r10	;20-bit words

	reta			;

.L413:
	mova	&11576,	r12	;0x02d38

	mova	r12,	r8	;

	movx.w	r10,	r14	;

.L416:
	cmpa	#0,	r8	;
	jnz	.L429     	;abs 0x5a5c


	cmpx.a	#0,	&0x02d34;r3 As==00
	jnz	.L422     	;abs 0x5a2a

	mova	r8,	r13	;
	mova	r9,	r12	;

	calla	#_sbrk_r		;

	mova	r12,	&11572	; 0x02d34

.L422:
	mova	r10,	r13	;
	mova	r9,	r12	;
	calla	#_sbrk_r		;

	cmpa	#1048575,r12	;0xfffff
	jz	.L409     	;abs 0x59f8

	mova	r12,	r8	;
	adda	#3,	r8	;
	andx.a	#-4,	r8	;0xffffc

	cmpa	r8,	r12	;
	jz	.L435     	;abs 0x5a84

	movx.a	r8,	r13	;
	subx.a	r12,	r13	;
	mova	r9,	r12	;

	calla	#_sbrk_r		;

	cmpa	#1048575,r12	;0xfffff
	jnz	.L435     	;abs 0x5a84
	jmp .L409	;mova	#23032,	r0	;0x059f8

.L429:
	mov	@r8,	r13	;
	sub	r14,	r13	;

	cmp	#0,	r13	;r3 As==00
	jl	.L449    	;abs 0x5af2

	mov.b	#11,	r14	;#0x000b
	cmp	r13,	r14	;
	jge	.L436     	;abs 0x5a9a

	mov	r13,	r14	;
	mov	r13,	r15	;
	rpt #15 { rrax.w	r15		;
	mov	r14,	0(r8)	;
	mov	r15,	2(r8)	;

	mov	r13,	r15	;
	rlam.a	#4,	r15	;
	rram.a	#4,	r15	;

	adda	r15,	r8	;

.L435:
	pushm.a	#1,	r10	;20-bit words
	popx.w	r12		;
	popx.w	r13		;
	mov	r12,	0(r8)	;
	mov	r13,	2(r8)	;
	jmp .L439	;mova	#23206,	r0	;0x05aa6

.L436:
	mova	4(r8),	r14	;

	cmpa	r8,	r12	;
	jnz	.L448     	;abs 0x5aea

	mova	r14,	&11576	; 0x02d38

.L439:
	mova	r8,	r12	;
	adda	#11,	r12	;0x0000b
	andx.a	#-8,	r12	;0xffff8

	mova	r8,	r10	;

	adda	#4,	r10	;
	movx.a	r12,	r14	;
	subx.a	r10,	r14	;

	movx.w	r14,	r14	;

	cmp	#0,	r14	;r3 As==00
	jz	.L411    	;abs 0x5a00

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
	jmp .L411	;mova	#23040,	r0	;0x05a00

.L448:
	mova	r14,	4(r12)	;
	jmp .L439	;mova	#23206,	r0	;0x05aa6

.L449:
	mova	r8,	r12	;
	mova	4(r8),	r8	;

	jmp .L416	;mova	#23054,	r0	;0x05a0e



	.global _sbrk_r
	.type _sbrk_r, @function
_sbrk_r:
	nop
	nop
	pushm.a	#1,	r10	;20-bit words

	mova	r12,	r10	;
	mova	r13,	r12	;

	movx.w	#0,	&0x02d3c;r3 As==00

	calla	#_sbrk		;0x05b24

	cmpa	#1048575,r12	;0xfffff
	jnz	.L458     	;abs 0x5b20

	movx.w	&0x02d3c,r13	;

	cmp	#0,	r13	;r3 As==00
	jz	.L458      	;abs 0x5b20

	mov	r13,	0(r10)	;

.L458:
	popm.a	#1,	r10	;20-bit words

	reta			;



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
	jc	.L470     	;abs 0x5b56

	mov.b	#26,	r14	;#0x001a
	mova	#82960,	r13	;0x14410
	mov.b	#1,	r12	;r3 As==01

	calla	#write		;0x05b62

	calla	#abort		;0x05bf8

.L470:
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

.L480:
	clr.b	r12		;
	cmp	r8,	r12	;
	jl	.L484     	;abs 0x5b8e

	mov	r9,	r12	;
	adda	#10,	r1	;0x0000a

	popm.a	#4,	r10	;20-bit words

	reta			;

.L484:
	mov	r8,	r10	;
	mov.b	#64,	r13	;#0x0040
	cmp	r8,	r13	;
	jge	.L485      	;abs 0x5b9a
	mov	r13,	r10	;

.L485:
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
	calla	#memcpy		;0x05870

	calla	#C$$IO$$		;0x05bf4

	add	r10,	r9	;

	sub	r10,	r8	;

	mova	@r1,	r15	;
	jmp .L480	;mova	#23422,	r0	;0x05b7e



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
	calla	#raise		;0x05cf0

	mov.b	#1,	r12	;r3 As==01
	calla	#_exit		;0x05d40



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
	jc	.L519     	;abs 0x5c5e

	mova	r8,	r11	;
	adda	r14,	r11	;

	cmpa	r11,	r12	;
	jc	.L519     	;abs 0x5c5e

	mova	r14,	r8	;

	xorx.a	#-1,	r8	;r3 As==11

	clr.b	r10		;

.L509:
	adda	#1048575,r10	;0xfffff

	cmpa	r10,	r8	;
	jnz	.L514     	;abs 0x5c34

.L511:
	mova	r15,	r12	;
	popm.a	#1,	r8	;20-bit words

	popm.a	#1,	r10	;20-bit words

	reta			;

.L514:
	mova	r13,	r12	;
	adda	r10,	r12	;
	adda	r15,	r12	;
	mova	r11,	r14	;
	adda	r10,	r14	;

	mov.b	@r14,	0(r12)	;
	jmp .L509	;mova	#23588,	r0	;0x05c24

.L516:
	mova	r8,	r10	;
	adda	r12,	r10	;

	mova	r15,	r14	;
	adda	r12,	r14	;
	mov.b	@r10,	0(r14)	;
	adda	#1,	r12	;

.L518:
	cmpa	r12,	r13	;
	jnz	.L516     	;abs 0x5c46
	jmp .L511	;mova	#23596,	r0	;0x05c2c

.L519:
	clr.b	r12		;

	jmp .L518	;mova	#23638,	r0	;0x05c56



	.global memset
	.type memset, @function
memset:
	nop
	nop
	pushm.a	#1,	r10	;20-bit words

	adda	r12,	r14	;

	mova	r12,	r10	;

.L523:
	cmpa	r14,	r10	;
	jnz	.L526      	;abs 0x5c72

	popm.a	#1,	r10	;20-bit words

	reta			;

.L526:
	adda	#1,	r10	;

	mov.b	r13,	-1(r10)	; 0xffff
	jmp .L523	;mova	#23658,	r0	;0x05c6a



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
	jc	.L535     	;abs 0x5c98

	mov	#22,	0(r10)	;#0x0016

	mov	#-1,	r12	;r3 As==11

.L533:
	popm.a	#2,	r10	;20-bit words

	reta			;

.L535:
	mova	56(r10),r12	;0x00038

	cmpa	#0,	r12	;
	jz	.L540     	;abs 0x5cb4

	rlam.a	#4,	r13	;
	rram.a	#4,	r13	;
	mova	r13,	r14	;
	rlam.a	#2,	r14	;
	adda	r14,	r12	;

	mova	@r12,	r14	;

	cmpa	#0,	r14	;
	jnz	.L543     	;abs 0x5cc8

.L540:
	mova	r10,	r12	;
	calla	#_getpid_r		;0x05d24

	mov	r9,	r14	;
	mov	r12,	r13	;
	mova	r10,	r12	;
	calla	#_kill_r		;0x05cfc

	jmp .L533	;mova	#23700,	r0	;0x05c94

.L543:
	cmpa	#1,	r14	;
	jz	.L549     	;abs 0x5cea

	cmpa	#1048575,r14	;0xfffff
	jnz	.L547     	;abs 0x5ce0

	mov	#22,	0(r10)	;#0x0016

	mov.b	#1,	r12	;r3 As==01
	jmp .L533	;mova	#23700,	r0	;0x05c94

.L547:
	movx.a	#0,	0(r12)	;r3 As==00

	mov	r9,	r12	;
	calla	r14		;

.L549:
	clr.b	r12		;
	jmp .L533	;mova	#23700,	r0	;0x05c94



	.global raise
	.type raise, @function
raise:
	nop
	nop
	mov	r12,	r13	;
	mova	&11264,	r12	;0x02c00

	calla	#_raise_r		;0x05c7e

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

	calla	#kill		;0x05d30

	cmp	#-1,	r12	;r3 As==11
	jnz	.L560     	;abs 0x5d20

	movx.w	&0x02d3c,r13	;

	cmp	#0,	r13	;r3 As==00
	jz	.L560      	;abs 0x5d20

	mov	r13,	0(r10)	;

.L560:
	popm.a	#1,	r10	;20-bit words

	reta			;



	.global _getpid_r
	.type _getpid_r, @function
_getpid_r:
	nop
	nop
	calla	#getpid		;0x05d2a

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
	calla	#__errno		;0x05d44
	movx.w	#88,	0(r12)	;0x00058
	mov	#-1,	r12	;r3 As==11
	reta			;



	.global _exit
	.type _exit, @function
_exit:
	nop
	nop
	jmp _exit	;mova	#23872,	r0	;0x05d40



	.global __errno
	.type __errno, @function
__errno:
	nop
	nop
	mova	&11264,	r12	;0x02c00
	reta			;