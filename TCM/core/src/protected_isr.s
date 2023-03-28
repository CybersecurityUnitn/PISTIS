;    Author: Michele Grisafi
;    Email: michele.grisafi@unitn.it
;    License: MIT 
;   This code represent that various Interrupt Service Routines used safely by Pistis.
;   Each one will set up the correct address in R4 and then jump to a global handler.

; dstSR = 10000 synch with virt_fun.s
; dstPC = 10002	synch with virt_fun.s
; secureSwitch = 10004 synch with virt_fun.safe
; destination (20bit) = 10006
; base usr ISR address = 0x10400
#include <msp430.h>
;Define all of the protected Interrupt Service Routines 
.text
    .section    .prt_isr,"ax",@progbits  ;Inject into the linker all together
    ;.section	.prt_isr_1,"ax",@progbits
    .balign 2
    .type prt_isr_1, @function
prt_isr_1:
	MOVX.W  &0x10400+(2*0), R4
	JMP .prt_isr_handler

    ;.section	.prt_isr_2,"ax",@progbits
    .balign 2
    .type prt_isr_2, @function
prt_isr_2:
	MOVX.W  &0x10400+(2*1), R4
	JMP .prt_isr_handler

    ;.section	.prt_isr_3,"ax",@progbits
    .balign 2
    .type prt_isr_3, @function
prt_isr_3:
	MOVX.W  &0x10400+(2*2), R4
	JMP .prt_isr_handler

    ;.section	.prt_isr_4,"ax",@progbits
    .balign 2
    .type prt_isr_4, @function
prt_isr_4:
	MOVX.W  &0x10400+(2*3), R4
	JMP .prt_isr_handler

    ;.section	.prt_isr_5,"ax",@progbits
    .balign 2
    .type prt_isr_5, @function
prt_isr_5:
	MOVX.W  &0x10400+(2*4), R4
	JMP .prt_isr_handler

    ;.section	.prt_isr_6,"ax",@progbits
    .balign 2
    .type prt_isr_6, @function
prt_isr_6:
	MOVX.W  &0x10400+(2*5), R4
	JMP .prt_isr_handler

    ;.section	.prt_isr_7,"ax",@progbits
    .balign 2
    .type prt_isr_7, @function
prt_isr_7:
	MOVX.W  &0x10400+(2*6), R4
	JMP .prt_isr_handler

    ;.section	.prt_isr_8,"ax",@progbits
    .balign 2
    .type prt_isr_8, @function
prt_isr_8:
	MOVX.W  &0x10400+(2*7), R4
	JMP .prt_isr_handler

    ;.section	.prt_isr_9,"ax",@progbits
    .balign 2
    .type prt_isr_9, @function
prt_isr_9:
	MOVX.W  &0x10400+(2*8), R4
	JMP .prt_isr_handler

    ;.section	.prt_isr_10,"ax",@progbits
    .balign 2
    .type prt_isr_10, @function
prt_isr_10:
	MOVX.W  &0x10400+(2*9), R4
	JMP .prt_isr_handler

    ;.section	.prt_isr_11,"ax",@progbits
    .balign 2
    .type prt_isr_11, @function
prt_isr_11:
	MOVX.W  &0x10400+(2*10), R4
	JMP .prt_isr_handler

    ;.section	.prt_isr_12,"ax",@progbits
    .balign 2
    .type prt_isr_12, @function
prt_isr_12:
	MOVX.W  &0x10400+(2*11), R4
	JMP .prt_isr_handler

    ;.section	.prt_isr_13,"ax",@progbits
    .balign 2
    .type prt_isr_13, @function
prt_isr_13:
	MOVX.W  &0x10400+(2*12), R4
	JMP .prt_isr_handler

    ;.section	.prt_isr_14,"ax",@progbits
    .balign 2
    .type prt_isr_14, @function
prt_isr_14:
	MOVX.W  &0x10400+(2*13), R4
	JMP .prt_isr_handler

    ;.section	.prt_isr_15,"ax",@progbits
    .balign 2
    .type prt_isr_15, @function
prt_isr_15:
	MOVX.W  &0x10400+(2*14), R4
	JMP .prt_isr_handler

    ;.section	.prt_isr_16,"ax",@progbits
    .balign 2
    .type prt_isr_16, @function
prt_isr_16:
	MOVX.W  &0x10400+(2*15), R4
	JMP .prt_isr_handler

    ;.section	.prt_isr_17,"ax",@progbits
    .balign 2
    .type prt_isr_17, @function
prt_isr_17:
	MOVX.W  &0x10400+(2*16), R4
	JMP .prt_isr_handler

    ;.section	.prt_isr_18,"ax",@progbits
    .balign 2
    .type prt_isr_18, @function
prt_isr_18:
	MOVX.W  &0x10400+(2*17), R4
	JMP .prt_isr_handler

    ;.section	.prt_isr_19,"ax",@progbits
    .balign 2
    .type prt_isr_19, @function
prt_isr_19:
	MOVX.W  &0x10400+(2*18), R4
	JMP .prt_isr_handler

    ;.section	.prt_isr_20,"ax",@progbits
    .balign 2
    .type prt_isr_20, @function
prt_isr_20:
	MOVX.W  &0x10400+(2*19), R4
	JMP .prt_isr_handler

    ;.section	.prt_isr_21,"ax",@progbits
    .balign 2
    .type prt_isr_21, @function
prt_isr_21:
	MOVX.W  &0x10400+(2*20), R4
	JMP .prt_isr_handler

    ;.section	.prt_isr_22,"ax",@progbits
    .balign 2
    .type prt_isr_22, @function
prt_isr_22:
	MOVX.W  &0x10400+(2*21), R4
	JMP .prt_isr_handler

    ;.section	.prt_isr_23,"ax",@progbits
    .balign 2
    .type prt_isr_23, @function
prt_isr_23:
	MOVX.W  &0x10400+(2*22), R4
	JMP .prt_isr_handler

    ;.section	.prt_isr_24,"ax",@progbits
    .balign 2
    .type prt_isr_24, @function
prt_isr_24:
	MOVX.W  &0x10400+(2*23), R4
	JMP .prt_isr_handler

    ;.section	.prt_isr_25,"ax",@progbits
    .balign 2
    .type prt_isr_25, @function
prt_isr_25:
	MOVX.W  &0x10400+(2*24), R4
	JMP .prt_isr_handler

    ;.section	.prt_isr_26,"ax",@progbits
    .balign 2
    .type prt_isr_26, @function
prt_isr_26:
	MOVX.W  &0x10400+(2*25), R4
	JMP .prt_isr_handler

    ;.section	.prt_isr_27,"ax",@progbits
    .balign 2
    .type prt_isr_27, @function
prt_isr_27:
	MOVX.W  &0x10400+(2*26), R4
	JMP .prt_isr_handler

    ;.section	.prt_isr_28,"ax",@progbits
    .balign 2
    .type prt_isr_28, @function
prt_isr_28:
	MOVX.W  &0x10400+(2*27), R4
	JMP .prt_isr_handler

    ;.section	.prt_isr_29,"ax",@progbits
    .balign 2
    .type prt_isr_29, @function
prt_isr_29:
	MOVX.W  &0x10400+(2*28), R4
	JMP .prt_isr_handler

    ;.section	.prt_isr_30,"ax",@progbits
    .balign 2
    .type prt_isr_30, @function
prt_isr_30:
	MOVX.W  &0x10400+(2*29), R4
	JMP .prt_isr_handler

    ;.section	.prt_isr_31,"ax",@progbits
    .balign 2
    .type prt_isr_31, @function
prt_isr_31:
	MOVX.W  &0x10400+(2*30), R4
	JMP .prt_isr_handler

    ;.section	.prt_isr_32,"ax",@progbits
    .balign 2
    .type prt_isr_32, @function
prt_isr_32:
	MOVX.W  &0x10400+(2*31), R4
	JMP .prt_isr_handler

    ;.section	.prt_isr_33,"ax",@progbits
    .balign 2
    .type prt_isr_33, @function
prt_isr_33:
	MOVX.W  &0x10400+(2*32), R4
	JMP .prt_isr_handler

    ;.section	.prt_isr_34,"ax",@progbits
    .balign 2
    .type prt_isr_34, @function
prt_isr_34:
	MOVX.W  &0x10400+(2*33), R4
	JMP .prt_isr_handler

    ;.section	.prt_isr_35,"ax",@progbits
    .balign 2
    .type prt_isr_35, @function
prt_isr_35:
	MOVX.W  &0x10400+(2*34), R4
	JMP .prt_isr_handler

    ;.section	.prt_isr_36,"ax",@progbits
    .balign 2
    .type prt_isr_36, @function
prt_isr_36:
	MOVX.W  &0x10400+(2*35), R4
	JMP .prt_isr_handler

    ;.section	.prt_isr_37,"ax",@progbits
    .balign 2
    .type prt_isr_37, @function
prt_isr_37:
	MOVX.W  &0x10400+(2*36), R4
	JMP .prt_isr_handler

    ;.section	.prt_isr_38,"ax",@progbits
    .balign 2
    .type prt_isr_38, @function
prt_isr_38:
	MOVX.W  &0x10400+(2*37), R4
	JMP .prt_isr_handler

    ;.section	.prt_isr_39,"ax",@progbits
    .balign 2
    .type prt_isr_39, @function
prt_isr_39:
	MOVX.W  &0x10400+(2*38), R4
	JMP .prt_isr_handler

    ;.section	.prt_isr_40,"ax",@progbits
    .balign 2
    .type prt_isr_40, @function
prt_isr_40:
	MOVX.W  &0x10400+(2*39), R4
	JMP .prt_isr_handler

    ;.section	.prt_isr_41,"ax",@progbits
    .balign 2
    .type prt_isr_41, @function
prt_isr_41:
	MOVX.W  &0x10400+(2*40), R4
	JMP .prt_isr_handler

    ;.section	.prt_isr_42,"ax",@progbits
    .balign 2
    .type prt_isr_42, @function
prt_isr_42:
	MOVX.W  &0x10400+(2*41), R4
	JMP .prt_isr_handler

    ;.section	.prt_isr_43,"ax",@progbits
    .balign 2
    .type prt_isr_43, @function
prt_isr_43:
	MOVX.W  &0x10400+(2*42), R4
	JMP .prt_isr_handler

    ;.section	.prt_isr_44,"ax",@progbits
    .balign 2
    .type prt_isr_44, @function
prt_isr_44:
	MOVX.W  &0x10400+(2*43), R4
	JMP .prt_isr_handler

    ;.section	.prt_isr_45,"ax",@progbits
    .balign 2
    .type prt_isr_45, @function
prt_isr_45:
	MOVX.W  &0x10400+(2*44), R4
	JMP .prt_isr_handler

    ;.section	.prt_isr_46,"ax",@progbits
    .balign 2
    .type prt_isr_46, @function
prt_isr_46:
	MOVX.W  &0x10400+(2*45), R4
	JMP .prt_isr_handler

    ;.section	.prt_isr_47,"ax",@progbits
    .balign 2
    .type prt_isr_47, @function
prt_isr_47:
	MOVX.W  &0x10400+(2*46), R4
	JMP .prt_isr_handler

    ;.section	.prt_isr_48,"ax",@progbits
    .balign 2
    .type prt_isr_48, @function
prt_isr_48:
	MOVX.W  &0x10400+(2*47), R4
	JMP .prt_isr_handler

    ;.section	.prt_isr_49,"ax",@progbits
    .balign 2
    .type prt_isr_49, @function
prt_isr_49:
	MOVX.W  &0x10400+(2*48), R4
	JMP .prt_isr_handler

    ;.section	.prt_isr_50,"ax",@progbits
    .balign 2
    .type prt_isr_50, @function
prt_isr_50:
	MOVX.W  &0x10400+(2*49), R4
	JMP .prt_isr_handler

    ;.section	.prt_isr_51,"ax",@progbits
    .balign 2
    .type prt_isr_51, @function
prt_isr_51:
	MOVX.W  &0x10400+(2*50), R4
	JMP .prt_isr_handler

    ;.section	.prt_isr_52,"ax",@progbits
    .balign 2
    .type prt_isr_52, @function
prt_isr_52:
	MOVX.W  &0x10400+(2*51), R4
	JMP .prt_isr_handler

    ;.section	.prt_isr_53,"ax",@progbits
    .balign 2
    .type prt_isr_53, @function
prt_isr_53:
	MOVX.W  &0x10400+(2*52), R4
	JMP .prt_isr_handler

    ;.section	.prt_isr_54,"ax",@progbits
    .balign 2
    .type prt_isr_54, @function
prt_isr_54:
	MOVX.W  &0x10400+(2*53), R4
	JMP .prt_isr_handler

    ;.section	.prt_isr_55,"ax",@progbits
    .balign 2
    .type prt_isr_55, @function
prt_isr_55:
	MOVX.W  &0x10400+(2*54), R4
	JMP .prt_isr_handler

    ;.section	.prt_isr_56,"ax",@progbits
    .balign 2
    .type prt_isr_56, @function
prt_isr_56:
	MOVX.W  &0x10400+(2*55), R4
	JMP .prt_isr_handler

    ;.section	.prt_isr_57,"ax",@progbits
    .balign 2
    .type prt_isr_57, @function
prt_isr_57:
	MOVX.W  &0x10400+(2*56), R4
	JMP .prt_isr_handler

    ;.section	.prt_isr_58,"ax",@progbits
    .balign 2
    .type prt_isr_58, @function
prt_isr_58:
	MOVX.W  &0x10400+(2*57), R4
	JMP .prt_isr_handler

    ;.section	.prt_isr_59,"ax",@progbits
    .balign 2
    .type prt_isr_59, @function
prt_isr_59:
	MOVX.W  &0x10400+(2*58), R4
	JMP .prt_isr_handler

    ;.section	.prt_isr_60,"ax",@progbits
    .balign 2
    .type prt_isr_60, @function
prt_isr_60:
	MOVX.W  &0x10400+(2*59), R4
	JMP .prt_isr_handler

    ;.section	.prt_isr_61,"ax",@progbits
    .balign 2
    .type prt_isr_61, @function
prt_isr_61:
	MOVX.W  &0x10400+(2*60), R4
	JMP .prt_isr_handler

    ;.section	.prt_isr_62,"ax",@progbits
    .balign 2
    .type prt_isr_62, @function
prt_isr_62:
	MOVX.W  &0x10400+(2*61), R4
	JMP .prt_isr_handler

    ;.section	.prt_isr_63,"ax",@progbits
    .balign 2
    .type prt_isr_63, @function
prt_isr_63:
	MOVX.W  &0x10400+(2*62), R4
	JMP .prt_isr_handler

	;.section	.prt_isr_handler,"ax",@progbits

;All of the handlers jump to this function
.prt_isr_handler:
	MOV #0xa500, &0x0144	; unlock memory controller
	MOV #0xa502, &0x0140 	; enable segment erase --> need to clear flash before writing to it
    MOVX.W #0, &0x10000     ; clear segment 512 bytes (0x200)
	MOV #0xa540, &0x0140 	; set controller to write mode
    MOVX.W @SP+, &0x10000 	; store SR and the four MSBs of the PC (PC.19:16). 19:16 are the 19:16 of SR. Eg: SR=0022, PC=14400 -> '1022' saved on stack 
	MOVX.W @SP+, &0x10002	; store 16bit PC
    MOVX.A R4, &0x10006     ; save ISR destination in case of backup
	MOV #0xa510, &0x0144	; lock memory controller
    CMPX.B #1, &0x10004     ; check whether RABackup must be invoked
    JEQ secureCleaner       ; if so jump to secureCleaner function (defined in secureContextSwitch.c)
	BRA R4					; Give control to user defined ISR stored in R4