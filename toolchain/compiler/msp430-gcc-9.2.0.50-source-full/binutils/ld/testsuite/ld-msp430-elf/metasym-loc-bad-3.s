	.file	"tester.c"
.text
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
.L2:
	BR	#.L2
	.size	main, .-main
	.balign 2
	.global	loc9100_text
	.type	loc9100_text, @function
loc9100_text:
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
	NOP
	; start of epilogue
	RET
	.size	loc9100_text, .-loc9100_text
	.sym_meta_info loc9100_text, SMK_LOCATION, 0x9100
	.ident	"GCC: (GNU) 10.0.1 20200214 (experimental)"
	.mspabi_attribute 4, 2
	.mspabi_attribute 6, 1
	.mspabi_attribute 8, 1
	.gnu_attribute 4, 1
