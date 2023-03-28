;    Author: Michele Grisafi
;    Email: michele.grisafi@unitn.it
;    License: MIT 

;   This file includes all of the virtual functions used by the TCM.

;#include "core.h"
; TODO: the current safe bra and calla use CMPX.A which is ineffective. Use something different.
;.text
;    .asg   "R6",safeDst
;    .asg "R5",safeSrc
;    .asg "R4",storeSr

;executableTop          .set    0xc3ff
;executableBottom          .set   0x4400
;RETI dstSR = 10000 sync with protected_isr 
;RETI dstPC = 10002 sync with protected_isr

;.sect ".virt_fun"

; The following code is commented only partially. 
; The first function is fully commented, the others are similar!

.text


    .section	.virt_fun,"ax",@progbits
    .balign 2
    .global	safe_br_fun
    .type safe_br_fun, @function
safe_br_fun:
    DINT                    ; Disable interrupts
    NOP                     ; Required by DINT
    CMP #0x4303, @R6        ; NOP Check 1   
    JNE .stop               ; Reset if NOP not there
    INCD R6                 ; Check next word
    CMP #0x4303, @R6        ; NOP Check 2
    JNE .stop               ; Reset if NOP not there
    CMPA #0xc3ff+1, R6      ; Boundary check
    JHS .stop               ; Reset
    CMPA #0x4400, R6        ; Boundary check
    JL  .stop               ; Reset 
    MOV R4, SR              ; Restore SR
    BR  R6                  ; Perform original branch (it is safe)


    .balign 2
    .global	safe_bra_fun
    .type safe_bra_fun, @function
safe_bra_fun:
    DINT
    NOP
    CMP #0x4303, @R6
    JNE .stop
    INCD R6
    CMP #0x4303, @R6
    JNE .stop
    CMPA #0xc3ff+1, R6
    JHS .stop
    CMPA #0x4400, R6
    JL  .stop
    MOV R4, SR 
    BRA  R6

    .balign 2
    .global	safe_call_fun
    .type safe_call_fun, @function

safe_call_fun:
    DINT
    NOP
    CMP #0x4303, @R6
    JNE .stop
    INCD R6
    CMP #0x4303, @R6
    JNE .stop
    CMPA #0xc3ff+1, R6
    JHS .stop
    CMPA #0x4400, R6
    JL  .stop
    MOV R4, SR
    BR R6               ; BR instead of CALL because we have already stored the return address

    .balign 2
    .global	safe_calla_fun
    .type safe_calla_fun, @function

safe_calla_fun:
    DINT
    NOP
    CMP #0x4303, @R6
    JNE .stop
    INCD R6
    CMP #0x4303, @R6
    JNE .stop
    CMPA #0xc3ff+1, R6
    JHS .stop
    CMPA #0x4400+1, R6
    JL  .stop
    MOV R4, SR
    BRA R6              ; BR instead of CALL because we have already stored the return address

    .balign 2
    .global	safe_ret_fun
    .type safe_ret_fun, @function

safe_ret_fun:
    DINT
    NOP
    MOV @SP, R6             ; Move the SP to the R6 register (our dstReg)
    CMP #0x4303, @R6        
    JNE .stop
    INCD R6
    CMP #0x4303, @R6
    JNE .stop
    CMP #0xc3ff+1, R6
    JHS .stop
    CMP #0x4400, R6
    JL  .stop
    MOV R4, SR
    RET                     ; It is safe! Return

    .balign 2
    .global	safe_reti_fun
    .type safe_reti_fun, @function

safe_reti_fun:
    DINT
    NOP
    ; no need to check the correctness of the dst address since we stored it in flash (write protected)
    ; Check whether we need to restore the state for secure code operations (e.g. RA)
    CMPX.B #1, &0x10004         ; check location for RA status bit
    JEQ secureRestorer          ; restore the content of the RAM (defined in secureContextSwitch.c)    
    CMPX.A #0x1000, &0x10000    ; Check whether we return to upper memory: 0x10000 contains the PC(19:16), stored in 10000(15:9) and the SR, stored in 10000(8:1). 
    JGE .rotate                 ; Jump to rotate block if targeting upper memory.
    MOVX.W &0x10000, SR         ; restore SR from FLASH
    MOVX.W &0x10002, PC         ; restore execution point from FLASH

.rotate:
    MOVX.W &0x10000, R4         ; load the 4 MBST bits
    AND #0xf000, R4             ; only retain PC bits
    ; shift bits of one byte: 0x1000 --> 0x10000
    RLA R4
    RLA R4
    RLA R4
    RLAX.A R4
    ADDX.A &0x10002, R4         ; load the rest of the PC bits from FLASH
    MOVX.W &0x10000, SR         ; restore the SR from flash
    BRA R4                      ; Perform branch 


    .balign 2
    .global	safe_reta_fun
    .type safe_reta_fun, @function

safe_reta_fun:
    DINT
    NOP
    MOVA @SP, R6
    CMP #0x4303, @R6
    JNE .stop
    INCD R6
    CMP #0x4303, @R6
    JNE .stop
    CMPA #0xc3ff+1, R6
    JHS .stop
    CMPA #0x4400, R6
    JL  .stop
    MOV R4, SR
    RETA

; The following functions are used for the WRITE controls

    .balign 2
    .global	write_mov_fun
    .type write_mov_fun, @function

write_mov_fun:
    DINT                    ; disable interrupts
    NOP                     ; NOP required by DINT
    CMP #FCTL3, R6          ; Check if target is memory controller
    JEQ .stop               ; If so reset
    MOV R5, @R6             ; Perform MOV
    MOV R4, SR              ; Restore SR
    RET                     ; Return to code

    .balign 2
    .global	write_movx_fun
    .type write_movx_fun, @function

write_movx_fun:
    DINT
    NOP
    CMPA #FCTL3, R6
    JEQ .stop
    MOVX R5, @R6
    MOV R4, SR
    RET

    .balign 2
    .global	write_xor_fun
    .type write_xor_fun, @function

write_xor_fun:
    DINT
    NOP
    CMP #FCTL3, R6
    JEQ .stop 
    XOR R5, @R6
    MOV R4, SR
    RET


    .balign 2
    .global	write_xorx_fun
    .type write_xorx_fun, @function
write_xorx_fun:
    DINT
    NOP
    CMPA #FCTL3, R6
    JEQ .stop
    XORX R5, @R6
    MOV R4, SR
    RET

    .balign 2
    .global	write_add_fun
    .type write_add_fun, @function

write_add_fun:
    DINT
    NOP
    CMP #FCTL3, R6
    JEQ .stop
    ADD R5, @R6
    MOV R4, SR
    RET

    .balign 2
    .global	write_addx_fun
    .type write_addx_fun, @function

write_addx_fun:
    DINT
    NOP
    CMPA #FCTL3, R6
    JEQ .stop
    ADDX R5, @R6
    MOV R4, SR
    RET

    .balign 2
    .global	write_addc_fun
    .type write_addc_fun, @function

write_addc_fun:
    DINT
    NOP
    CMP #FCTL3, R6
    JEQ .stop
    ADDC R5, @R6
    MOV R4, SR
    RET

    .balign 2
    .global	write_addcx_fun
    .type write_addcx_fun, @function

write_addcx_fun:
    DINT
    NOP
    CMPA #FCTL3, R6
    JEQ .stop
    ADDCX R5, @R6
    MOV R4, SR
    RET

    .balign 2
    .global	write_dadd_fun
    .type write_dadd_fun, @function

write_dadd_fun:
    DINT
    NOP
    CMP #FCTL3, R6
    JEQ .stop
    DADD R5, @R6
    MOV R4, SR
    RET

    .balign 2
    .global	write_daddx_fun
    .type write_daddx_fun, @function

write_daddx_fun:
    DINT
    NOP
    CMPA #FCTL3, R6
    JEQ .stop
    DADDX R5, @R6
    MOV R4, SR
    RET

    .balign 2
    .global	write_sub_fun
    .type write_sub_fun, @function

write_sub_fun:
    DINT
    NOP
    CMP #FCTL3, R6
    JEQ .stop
    SUB R5, @R6
    MOV R4, SR
    RET

    .balign 2
    .global	write_subx_fun
    .type write_subx_fun, @function

write_subx_fun:
    DINT
    NOP
    CMPA #FCTL3, R6
    JEQ .stop
    SUBX R5, @R6
    MOV R4, SR
    RET

    .balign 2
    .global	write_subc_fun
    .type write_subc_fun, @function

write_subc_fun:
    DINT
    NOP
    CMP #FCTL3, R6
    JEQ .stop
    SUBC R5, @R6
    MOV R4, SR
    RET

    .balign 2
    .global	write_subcx_fun
    .type write_subcx_fun, @function

write_subcx_fun:
    DINT
    NOP
    CMPA #FCTL3, R6
    JEQ .stop
    SUBCX R5, @R6
    MOV R4, SR
    RET

.stop:
    BR #0x1000 ;cause a reset by jumping to the BSL

    .balign 2
    .global receiveUpdate
    .type receiveUpdate, @function
receiveUpdate:
    BR #secureUpdate

