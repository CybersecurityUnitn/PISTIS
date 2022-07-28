	.file	"loc2.c"
.text
	.global	arr_1
	.section	.data.arr_1,"aw"
	.type	arr_1, @object
	.size	arr_1, 80
arr_1:
	.string	"\001"
	.zero	78
	.global	arr_2
	.section	.data.arr_2,"aw"
	.type	arr_2, @object
	.size	arr_2, 80
arr_2:
	.string	"\001"
	.zero	78
	.global	arr_3
	.section	.data.arr_3,"aw"
	.type	arr_3, @object
	.size	arr_3, 80
arr_3:
	.string	"\001"
	.zero	78
	.global	arr_4
	.section	.data.arr_4,"aw"
	.type	arr_4, @object
	.size	arr_4, 80
arr_4:
	.string	"\001"
	.zero	78
	.global	loc808_data
	.section	.data.loc808_data,"aw"
	.balign 2
	.type	loc808_data, @object
	.size	loc808_data, 2
loc808_data:
	.short	2056
	.sym_meta_info loc808_data, SMK_LOCATION, 0x808
	.global	loc510_data
	.section	.data.loc510_data,"aw"
	.type	loc510_data, @object
	.size	loc510_data, 1
loc510_data:
	.byte	81
	.global	loc520_data
	.section	.data.loc520_data,"aw"
	.type	loc520_data, @object
	.size	loc520_data, 1
loc520_data:
	.byte	82
	.global	loc720_data
	.section	.data.loc720_data,"aw"
	.type	loc720_data, @object
	.size	loc720_data, 1
loc720_data:
	.byte	114
	.global	loc5f1_data
	.section	.data.loc5f1_data,"aw"
	.type	loc5f1_data, @object
	.size	loc5f1_data, 1
loc5f1_data:
	.byte	95
	.sym_meta_info loc510_data, SMK_LOCATION, 0x510
	.sym_meta_info loc520_data, SMK_LOCATION, 0x520
	.sym_meta_info loc720_data, SMK_LOCATION, 0x720
	.sym_meta_info loc5f1_data, SMK_LOCATION, 0x5f1
	.section	.text.loc9000_text,"ax",@progbits
	.balign 2
	.global	loc9000_text
	.type	loc9000_text, @function
loc9000_text:
; start of function
; attributes: 
; framesize_regs:     0
; framesize_locals:   0
; framesize_outgoing: 0
; framesize:          0
; elim ap -> fp       2
; elim fp -> sp       0
; saved regs:(none)
	; start of prologue
	; end of prologue
	NOP
	; start of epilogue
	RET
	.size	loc9000_text, .-loc9000_text
	.sym_meta_info loc9000_text, SMK_LOCATION, 0x9000
	.global	loc910a_rodata
	.section	.rodata.loc910a_rodata,"a"
	.type	loc910a_rodata, @object
	.size	loc910a_rodata, 1
loc910a_rodata:
	.byte	2
	.sym_meta_info loc910a_rodata, SMK_LOCATION, 0x910a
	.global	loc850_bss
	.section	.bss.loc850_bss,"aw",@nobits
	.type	loc850_bss, @object
	.size	loc850_bss, 1
loc850_bss:
	.zero	1
	.sym_meta_info loc850_bss, SMK_LOCATION, 0x850
	.global	either
	.section	.either.data,"aw"
	.type	either, @object
	.size	either, 1
either:
	.byte	1
	.section	.text.main,"ax",@progbits
	.balign 2
	.global	main
	.type	main, @function
main:
; start of function
; framesize_regs:     0
; framesize_locals:   0
; framesize_outgoing: 0
; framesize:          0
; elim ap -> fp       2
; elim fp -> sp       0
; saved regs:(none)
	; start of prologue
	; end of prologue
.L3:
	BR	#.L3
	.size	main, .-main
