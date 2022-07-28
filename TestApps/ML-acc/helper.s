.text


; *******************************   REMU   *******************************
    .global	__mspabi_remu
    .type __mspabi_remu, @function
__mspabi_remu:
    mov.b	#1,	r14	;r3 As==01
    calla	#udivmodhi4		;0x06456
    reta			;
    
    

    .global	udivmodhi4
    .type udivmodhi4, @function
udivmodhi4:
    mov	r12,	r15
    mov.b	#17,	r12	;#0x0011
    mov.b	#1,	r11	;r3 As==01

.L2udivmodhi4:
    cmp	r15,	r13	;
    jc	.L10udivmodhi4     	;abs 0x45b6
    add	#-1,	r12	;r3 As==11
    cmp	#0,	r12	;r3 As==00
    jz	.L4udivmodhi4     	;abs 0x45bc
    cmp	#0,	r13	;r3 As==00
    jge	.L5udivmodhi4     	;abs 0x45c4

.L10udivmodhi4:
    clr.b	r12		;

.L6udivmodhi4:
    cmp	#0,	r11	;r3 As==00
    jnz	.L8udivmodhi4     	;abs 0x45cc

.L4udivmodhi4:
    cmp	#0,	r14	;r3 As==00
    jz	.L1udivmodhi4      	;abs 0x45c2
    mov	r15,	r12	;

.L1udivmodhi4:
    reta			;

.L5udivmodhi4:
    rla	r13		;
    rla	r11		;
    jmp .L2udivmodhi4  ;mova	#17832,	r0	;0x045a8

.L8udivmodhi4:
    cmp	r13,	r15	;
    jnc	.L7udivmodhi4      	;abs 0x45d4
    sub	r13,	r15	;
    bis	r11,	r12	;

.L7udivmodhi4:
    rrum	#1,	r11	;
    rrum	#1,	r13	;
    jmp .L6udivmodhi4 ;mova	#17848,	r0	;0x045b8


.L0udivmodhi4:
    add	#-1,	r13	;r3 As==11
    rla	r12		;


    .global	__mspabi_slli
    .type __mspabi_slli, @function
__mspabi_slli:
    cmp	#0,	r13	;r3 As==00
    jnz	.L0udivmodhi4      	;abs 0x6606
    reta			;







   



   .global	memmove
    .type memmove, @function
memmove:
    pushm.a	#1,	r10	;20-bit words
    pushm.a	#1,	r9	;20-bit words
    pushm.a	#1,	r8	;20-bit words
    pushm.a	#1,	r7	;20-bit words
    mova	r12,	r8	;
    mova	r13,	r10	;
    mova	r14,	r7	;
    cmpa	r12,	r13	;
    jc	.L9memmove     	;abs 0x6522
    mova	r13,	r9	;
    adda	r14,	r9	;
    cmpa	r9,	r12	;
    jc	.L9memmove     	;abs 0x6522
    mova	r14,	r13	;
    xorx.a	#-1,	r13	;r3 As==11
    clr.b	r12		;

.L3memmove:
    adda	#1048575,r12	;0xfffff
    cmpa	r12,	r13	;
    jnz	.L4memmove     	;abs 0x64f8

.L10memmove:
    mova	r8,	r12	;
    popm.a	#1,	r7	;20-bit words
    popm.a	#1,	r8	;20-bit words
    popm.a	#1,	r9	;20-bit words
    popm.a	#1,	r10	;20-bit words
    reta			;

.L4memmove:
    mova	r7,	r10	;
    adda	r12,	r10	;
    adda	r8,	r10	;
    mova	r9,	r14	;
    adda	r12,	r14	;
    mov.b	@r14,	0(r10)	;
    jmp .L3memmove ;mova	#25828,	r0	;0x064e4

.L6memmove:
    mova	r10,	r9	;
    adda	r12,	r9	;
    mova	r8,	r14	;
    adda	r12,	r14	;
    mov.b	@r9,	0(r14)	;
    adda	#1,	r12	;

.L5memmove:
    cmpa	r12,	r7	;
    jnz	.L6memmove     	;abs 0x650a
    jmp .L10memmove    ;mova	#25836,	r0	;0x064ec

.L9memmove:
    clr.b	r12		;
    jmp .L5memmove  ;mova	#25882,	r0	;0x0651a



    .global	__mspabi_srlll
    .type __mspabi_srlll, @function
__mspabi_srlll:
    mov	r11,	r15	
    mov	r12,	r11	
    mov	r10,	r14	
    mov	r9,	r13	
    mov	r8,	r12	
    cmp	#0,	r11	
    jnz	.L1srlll      	
    reta			

.L1srlll:
    clrc			
    rrc	r15		
    rrc	r14		
    rrc	r13		
    rrc	r12		
    add	#-1,	r11	
    jnz	.L1srlll     	
    reta			



;******************* memset

    .global	memset
    .type memset, @function
memset:
    pushm.a	#1,	r10	;20-bit words
    adda	r12,	r14	;
    mova	r12,	r10	;

.L2memset:
    cmpa	r14,	r10	;
    jnz	.L3memset      	;abs 0x6630
    popm.a	#1,	r10	;20-bit words
    reta			;

.L3memset:
    adda	#1,	r10	;
    mov.b	r13,	-1(r10)	; 0xffff
    jmp .L2memset    ;mova	#26152,	r0	;0x06628

