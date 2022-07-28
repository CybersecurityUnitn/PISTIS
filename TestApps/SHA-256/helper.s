.text


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



;******************* memcpy

 	.global	memcpy
    .type memcpy, @function
memcpy:
    pushm.a	#1,	r10	;20-bit words
    pushm.a	#1,	r9	;20-bit words
    pushm.a	#1,	r8	;20-bit words
    pushm.a	#1,	r7	;20-bit words
    mova	r13,	r8	;
    mova	r14,	r7	;
    clr.b	r14		;

.L2memcpy:
    cmpa	r14,	r7	;
    jnz	.L3memcpy     	;abs 0x56f6
    popm.a	#1,	r7	;20-bit words
    popm.a	#1,	r8	;20-bit words
    popm.a	#1,	r9	;20-bit words
    popm.a	#1,	r10	;20-bit words
    reta			;

.L3memcpy:
    mova	r12,	r10	;
    adda	r14,	r10	;
    mova	r8,	r9	;
    adda	r14,	r9	;
    mov.b	@r9,	0(r10)	;
    adda	#1,	r14	;
    jmp .L2memcpy    ;mova	#22248,	r0	;0x056e8