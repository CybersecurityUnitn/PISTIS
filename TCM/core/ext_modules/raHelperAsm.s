;    Author: Michele Grisafi
;    Email: michele.grisafi@unitn.it
;    License: MIT 
; This file contains the helper functions for RA that backup and restore the system registers.
.text
    .section	.tcm:codeUpper,"ax",@progbits
    .balign 2
    .global	raRegBackup
    .type raRegBackup, @function
raRegBackup:    
    MOV #0xa500, &0x0144	; unlock memory controller
	MOV #0xa502, &0x0140 	; enable segment erase --> need to clear flash before writing to it
    MOVX.W #0,  &0x10200    ; clear segment 512 bytes (0x200)
	MOV #0xa540, &0x0140 	; set controller to write mode
    MOVX.A R0,  &0x10200    ; save PC
    MOVX.A R1,  &0x10204    ; save SP
    MOVX.A R2,  &0x10208    ; save SR
    MOVX.A R3,  &0x1020c    ; save general registers
    MOVX.A R4,  &0x10210     
    MOVX.A R5,  &0x10214    
    MOVX.A R6,  &0x10218
    MOVX.A R7,  &0x1021c 
    MOVX.A R8,  &0x10220 
    MOVX.A R9,  &0x10224 
    MOVX.A R10,  &0x10228 
    MOVX.A R11,  &0x1022c
    MOVX.A R12,  &0x10230
    MOVX.A R13,  &0x10234
    MOVX.A R14,  &0x10238
    MOVX.A R15,  &0x1023c      
    MOV #0xa510, &0x0144	; lock memory controller
    CLR R3                  ; Clear registers to avoid information leakeage
    CLR R4
    CLR R5
    CLR R6
    CLR R7
    CLR R8
    CLR R9
    CLR R10
    CLR R11
    CLR R12
    CLR R13
    CLR R14
    CLR R15
    RETA

    .section	.tcm:codeUpper,"ax",@progbits
    .balign 2
    .global	raRegRestore
    .type raRegRestore, @function
raRegRestore:   
    MOVA #0x10204, R15
    MOVA @R15+, R1          ; restore SP
    MOVX.A @R15+, R2        ; restore SR
    MOVX.A @R15+, R3        ; restore general registers
    MOVA @R15+, R4  
    MOVA @R15+, R5 
    MOVA @R15+, R6
    MOVA @R15+, R7
    MOVA @R15+, R8
    MOVA @R15+, R9
    MOVA @R15+, R10
    MOVA @R15+, R11
    MOVA @R15+, R12
    MOVA @R15+, R13
    MOVA @R15+, R14
    MOVA @R15, R15
    MOVA &0x10200, R0     ; restore PC

