	.file	"inline-break.c"
	.text
.Ltext0:
	.p2align 4,,15
	.globl	func2
	.type	func2, @function
func2:
.LFB1:
	.file 1 "../gdb.opt/inline-break.c"
	# ../gdb.opt/inline-break.c:39
	.loc 1 39 0
	.cfi_startproc
.LVL0:
# BLOCK 2 freq:10000 seq:0
# PRED: ENTRY [100.0%]  (FALLTHRU)
	# ../gdb.opt/inline-break.c:40
	.loc 1 40 0
	movl	%edi, %eax
	sall	$4, %eax
	addl	%edi, %eax
# SUCC: EXIT [100.0%] 
	# ../gdb.opt/inline-break.c:41
	.loc 1 41 0
	ret
	.cfi_endproc
.LFE1:
	.size	func2, .-func2
	.p2align 4,,15
	.globl	func4a
	.type	func4a, @function
func4a:
.LFB5:
	# ../gdb.opt/inline-break.c:69
	.loc 1 69 0
	.cfi_startproc
.LVL1:
# BLOCK 2 freq:10000 seq:0
# PRED: ENTRY [100.0%]  (FALLTHRU)
	# ../gdb.opt/inline-break.c:70
	.loc 1 70 0
	movl	%edi, %eax
	sall	$4, %eax
	addl	%eax, %edi
.LVL2:
.LBB103:
.LBB104:
	# ../gdb.opt/inline-break.c:64
	.loc 1 64 0
	xorl	%eax, %eax
	cmpl	$12, %edi
	setg	%al
	addl	$1, %eax
.LBE104:
.LBE103:
# SUCC: EXIT [100.0%] 
	# ../gdb.opt/inline-break.c:71
	.loc 1 71 0
	ret
	.cfi_endproc
.LFE5:
	.size	func4a, .-func4a
	.p2align 4,,15
	.globl	func5b
	.type	func5b, @function
func5b:
.LFB6:
	# ../gdb.opt/inline-break.c:78
	.loc 1 78 0
	.cfi_startproc
.LVL3:
# BLOCK 2 freq:10000 seq:0
# PRED: ENTRY [100.0%]  (FALLTHRU)
	# ../gdb.opt/inline-break.c:79
	.loc 1 79 0
	xorl	%eax, %eax
	cmpl	$11, %edi
	setg	%al
	addl	$1, %eax
# SUCC: EXIT [100.0%] 
	# ../gdb.opt/inline-break.c:80
	.loc 1 80 0
	ret
	.cfi_endproc
.LFE6:
	.size	func5b, .-func5b
	.p2align 4,,15
	.globl	func6b
	.type	func6b, @function
func6b:
.LFB8:
	# ../gdb.opt/inline-break.c:93
	.loc 1 93 0
	.cfi_startproc
.LVL4:
# BLOCK 2 freq:10000 seq:0
# PRED: ENTRY [100.0%]  (FALLTHRU)
	# ../gdb.opt/inline-break.c:94
	.loc 1 94 0
	xorl	%eax, %eax
	cmpl	$14, %edi
	setl	%al
	addl	$2, %eax
# SUCC: EXIT [100.0%] 
	# ../gdb.opt/inline-break.c:95
	.loc 1 95 0
	ret
	.cfi_endproc
.LFE8:
	.size	func6b, .-func6b
	.p2align 4,,15
	.globl	func6a
	.type	func6a, @function
func6a:
.LFB9:
	# ../gdb.opt/inline-break.c:99
	.loc 1 99 0
	.cfi_startproc
.LVL5:
# BLOCK 2 freq:10000 seq:0
# PRED: ENTRY [100.0%]  (FALLTHRU)
	# ../gdb.opt/inline-break.c:100
	.loc 1 100 0
	movl	%edi, %eax
	sall	$4, %eax
	addl	%eax, %edi
.LVL6:
.LBB105:
.LBB106:
	# ../gdb.opt/inline-break.c:94
	.loc 1 94 0
	xorl	%eax, %eax
	cmpl	$14, %edi
	setl	%al
	addl	$2, %eax
.LBE106:
.LBE105:
# SUCC: EXIT [100.0%] 
	# ../gdb.opt/inline-break.c:101
	.loc 1 101 0
	ret
	.cfi_endproc
.LFE9:
	.size	func6a, .-func6a
	.p2align 4,,15
	.globl	func8b
	.type	func8b, @function
func8b:
.LFB12:
	# ../gdb.opt/inline-break.c:121
	.loc 1 121 0
	.cfi_startproc
.LVL7:
# BLOCK 2 freq:10000 seq:0
# PRED: ENTRY [100.0%]  (FALLTHRU)
	# ../gdb.opt/inline-break.c:122
	.loc 1 122 0
	xorl	%eax, %eax
	cmpl	$7, %edi
	setl	%al
	leal	9(%rax,%rax), %eax
# SUCC: EXIT [100.0%] 
	# ../gdb.opt/inline-break.c:123
	.loc 1 123 0
	ret
	.cfi_endproc
.LFE12:
	.size	func8b, .-func8b
	.p2align 4,,15
	.globl	inline_func2
	.type	inline_func2, @function
inline_func2:
.LFB16:
	# ../gdb.opt/inline-break.c:149
	.loc 1 149 0
	.cfi_startproc
.LVL8:
# BLOCK 2 freq:10000 seq:0
# PRED: ENTRY [100.0%]  (FALLTHRU)
	# ../gdb.opt/inline-break.c:152
	.loc 1 152 0
	leal	6(%rdi), %eax
# SUCC: EXIT [100.0%] 
	# ../gdb.opt/inline-break.c:153
	.loc 1 153 0
	ret
	.cfi_endproc
.LFE16:
	.size	inline_func2, .-inline_func2
	.p2align 4,,15
	.globl	not_inline_func2
	.type	not_inline_func2, @function
not_inline_func2:
.LFB17:
	# ../gdb.opt/inline-break.c:157
	.loc 1 157 0
	.cfi_startproc
.LVL9:
# BLOCK 2 freq:10000 seq:0
# PRED: ENTRY [100.0%]  (FALLTHRU)
	# ../gdb.opt/inline-break.c:160
	.loc 1 160 0
	leal	10(%rdi), %eax
# SUCC: EXIT [100.0%] 
	# ../gdb.opt/inline-break.c:161
	.loc 1 161 0
	ret
	.cfi_endproc
.LFE17:
	.size	not_inline_func2, .-not_inline_func2
	.p2align 4,,15
	.globl	func_extern_caller
	.type	func_extern_caller, @function
func_extern_caller:
.LFB22:
	# ../gdb.opt/inline-break.c:207
	.loc 1 207 0
	.cfi_startproc
.LVL10:
# BLOCK 2 freq:10000 seq:0
# PRED: ENTRY [100.0%]  (FALLTHRU)
.LBB109:
.LBB110:
.LBB111:
	# ../gdb.opt/inline-break.c:189
	.loc 1 189 0
	imull	$23, %edi, %eax
.LBE111:
.LBE110:
.LBE109:
# SUCC: EXIT [100.0%] 
	# ../gdb.opt/inline-break.c:209
	.loc 1 209 0
	ret
	.cfi_endproc
.LFE22:
	.size	func_extern_caller, .-func_extern_caller
	.section	.text.startup,"ax",@progbits
	.p2align 4,,15
	.globl	main
	.type	main, @function
main:
.LFB23:
	# ../gdb.opt/inline-break.c:215
	.loc 1 215 0
	.cfi_startproc
.LVL11:
# BLOCK 2 freq:10000 seq:0
# PRED: ENTRY [100.0%]  (FALLTHRU)
	# ../gdb.opt/inline-break.c:220
	.loc 1 220 0
	movl	$1, -4(%rsp)
	# ../gdb.opt/inline-break.c:222
	.loc 1 222 0
	movl	-4(%rsp), %eax
.LVL12:
.LBB150:
.LBB151:
	# ../gdb.opt/inline-break.c:32
	.loc 1 32 0
	imull	$23, %eax, %eax
.LVL13:
.LBE151:
.LBE150:
	# ../gdb.opt/inline-break.c:222
	.loc 1 222 0
	movl	%eax, -4(%rsp)
	# ../gdb.opt/inline-break.c:224
	.loc 1 224 0
	movl	-4(%rsp), %edx
.LVL14:
.LBB152:
.LBB153:
	# ../gdb.opt/inline-break.c:40
	.loc 1 40 0
	movl	%edx, %eax
	sall	$4, %eax
	addl	%edx, %eax
.LVL15:
.LBE153:
.LBE152:
	# ../gdb.opt/inline-break.c:224
	.loc 1 224 0
	movl	%eax, -4(%rsp)
	# ../gdb.opt/inline-break.c:226
	.loc 1 226 0
	movl	-4(%rsp), %eax
.LVL16:
.LBB154:
.LBB155:
	# ../gdb.opt/inline-break.c:55
	.loc 1 55 0
	imull	$23, %eax, %eax
.LVL17:
.LBB156:
.LBB157:
	# ../gdb.opt/inline-break.c:49
	.loc 1 49 0
	cmpl	$13, %eax
	setg	%al
.LVL18:
	movzbl	%al, %eax
	addl	$1, %eax
.LBE157:
.LBE156:
.LBE155:
.LBE154:
	# ../gdb.opt/inline-break.c:226
	.loc 1 226 0
	movl	%eax, -4(%rsp)
	# ../gdb.opt/inline-break.c:228
	.loc 1 228 0
	movl	-4(%rsp), %edx
.LVL19:
.LBB158:
.LBB159:
	# ../gdb.opt/inline-break.c:70
	.loc 1 70 0
	movl	%edx, %eax
	sall	$4, %eax
	addl	%edx, %eax
.LBB160:
.LBB161:
	# ../gdb.opt/inline-break.c:64
	.loc 1 64 0
	cmpl	$12, %eax
	setg	%al
	movzbl	%al, %eax
	addl	$1, %eax
.LVL20:
.LBE161:
.LBE160:
.LBE159:
.LBE158:
	# ../gdb.opt/inline-break.c:228
	.loc 1 228 0
	movl	%eax, -4(%rsp)
	# ../gdb.opt/inline-break.c:230
	.loc 1 230 0
	movl	-4(%rsp), %eax
.LVL21:
.LBB162:
.LBB163:
	# ../gdb.opt/inline-break.c:85
	.loc 1 85 0
	imull	$23, %eax, %eax
.LVL22:
.LBB164:
.LBB165:
	# ../gdb.opt/inline-break.c:79
	.loc 1 79 0
	cmpl	$11, %eax
	setg	%al
.LVL23:
	movzbl	%al, %eax
	addl	$1, %eax
.LBE165:
.LBE164:
.LBE163:
.LBE162:
	# ../gdb.opt/inline-break.c:230
	.loc 1 230 0
	movl	%eax, -4(%rsp)
	# ../gdb.opt/inline-break.c:232
	.loc 1 232 0
	movl	-4(%rsp), %edx
.LVL24:
.LBB166:
.LBB167:
	# ../gdb.opt/inline-break.c:100
	.loc 1 100 0
	movl	%edx, %eax
	sall	$4, %eax
	addl	%edx, %eax
.LBB168:
.LBB169:
	# ../gdb.opt/inline-break.c:94
	.loc 1 94 0
	cmpl	$14, %eax
	setl	%al
	movzbl	%al, %eax
	addl	$2, %eax
.LVL25:
.LBE169:
.LBE168:
.LBE167:
.LBE166:
	# ../gdb.opt/inline-break.c:232
	.loc 1 232 0
	movl	%eax, -4(%rsp)
	# ../gdb.opt/inline-break.c:234
	.loc 1 234 0
	movl	-4(%rsp), %eax
.LVL26:
	movl	-4(%rsp), %edx
.LBB170:
.LBB171:
	# ../gdb.opt/inline-break.c:114
	.loc 1 114 0
	imull	$29, %eax, %eax
.LVL27:
.LBB172:
.LBB173:
	# ../gdb.opt/inline-break.c:108
	.loc 1 108 0
	cmpl	$23, %eax
	setge	%al
.LVL28:
.LBE173:
.LBE172:
.LBE171:
.LBE170:
.LBB180:
.LBB181:
	cmpl	$23, %edx
	setge	%dl
.LBE181:
.LBE180:
.LBB184:
.LBB178:
.LBB176:
.LBB174:
	movzbl	%al, %eax
.LBE174:
.LBE176:
.LBE178:
.LBE184:
.LBB185:
.LBB182:
	movzbl	%dl, %edx
.LBE182:
.LBE185:
.LBB186:
.LBB179:
.LBB177:
.LBB175:
	leal	1(%rax,%rax,2), %eax
.LBE175:
.LBE177:
.LBE179:
.LBE186:
.LBB187:
.LBB183:
	leal	1(%rdx,%rdx,2), %edx
.LBE183:
.LBE187:
	# ../gdb.opt/inline-break.c:234
	.loc 1 234 0
	addl	%edx, %eax
	movl	%eax, -4(%rsp)
	# ../gdb.opt/inline-break.c:236
	.loc 1 236 0
	movl	-4(%rsp), %edx
.LVL29:
.LBB188:
.LBB189:
	# ../gdb.opt/inline-break.c:128
	.loc 1 128 0
	movl	%edx, %eax
	sall	$5, %eax
	subl	%edx, %eax
.LBB190:
.LBB191:
	# ../gdb.opt/inline-break.c:122
	.loc 1 122 0
	xorl	%edx, %edx
	cmpl	$7, %eax
.LBE191:
.LBE190:
.LBE189:
.LBE188:
	# ../gdb.opt/inline-break.c:236
	.loc 1 236 0
	movl	-4(%rsp), %eax
.LVL30:
.LBB195:
.LBB194:
.LBB193:
.LBB192:
	# ../gdb.opt/inline-break.c:122
	.loc 1 122 0
	setl	%dl
.LBE192:
.LBE193:
.LBE194:
.LBE195:
.LBB196:
.LBB197:
	cmpl	$7, %eax
	setl	%al
.LVL31:
	movzbl	%al, %eax
	leal	9(%rax,%rax), %eax
.LBE197:
.LBE196:
	# ../gdb.opt/inline-break.c:236
	.loc 1 236 0
	leal	9(%rax,%rdx,2), %eax
	movl	%eax, -4(%rsp)
.LVL32:
	# ../gdb.opt/inline-break.c:238
	.loc 1 238 0
	movl	$0, -4(%rsp)
	# ../gdb.opt/inline-break.c:242
	.loc 1 242 0
	movl	-4(%rsp), %eax
# SUCC: EXIT [100.0%] 
	# ../gdb.opt/inline-break.c:243
	.loc 1 243 0
	ret
	.cfi_endproc
.LFE23:
	.size	main, .-main
	.text
.Letext0:
	.section	.debug_info,"",@progbits
.Ldebug_info0:
	.long	0x6f0	# Length of Compilation Unit Info
	.value	0x4	# DWARF version number
	.long	.Ldebug_abbrev0	# Offset Into Abbrev. Section
	.byte	0x8	# Pointer Size (in bytes)
	.uleb128 0x1	# (DIE (0xb) DW_TAG_compile_unit)
	.long	.LASF26	# DW_AT_producer: "GNU C11 7.5.0 -mtune=generic -march=x86-64 -g -O2 -fstack-protector-strong"
	.byte	0xc	# DW_AT_language
	.long	.LASF27	# DW_AT_name: "../gdb.opt/inline-break.c"
	.long	.LASF28	# DW_AT_comp_dir: "/home/jozef/msp430/msp430-gnu/gdb.subtree/gdb/testsuite/gdb.dwarf2"
	.long	.Ldebug_ranges0+0x120	# DW_AT_ranges
	.quad	0	# DW_AT_low_pc
	.long	.Ldebug_line0	# DW_AT_stmt_list
	.uleb128 0x2	# (DIE (0x29) DW_TAG_subprogram)
			# DW_AT_external
	.long	.LASF29	# DW_AT_name: "main"
	.byte	0x1	# DW_AT_decl_file (../gdb.opt/inline-break.c)
	.byte	0xd6	# DW_AT_decl_line
			# DW_AT_prototyped
	.long	0x285	# DW_AT_type
	.quad	.LFB23	# DW_AT_low_pc
	.quad	.LFE23-.LFB23	# DW_AT_high_pc
	.uleb128 0x1	# DW_AT_frame_base
	.byte	0x9c	# DW_OP_call_frame_cfa
			# DW_AT_GNU_all_call_sites
	.long	0x285	# DW_AT_sibling
	.uleb128 0x3	# (DIE (0x4a) DW_TAG_formal_parameter)
	.long	.LASF0	# DW_AT_name: "argc"
	.byte	0x1	# DW_AT_decl_file (../gdb.opt/inline-break.c)
	.byte	0xd6	# DW_AT_decl_line
	.long	0x285	# DW_AT_type
	.uleb128 0x1	# DW_AT_location
	.byte	0x55	# DW_OP_reg5
	.uleb128 0x3	# (DIE (0x57) DW_TAG_formal_parameter)
	.long	.LASF1	# DW_AT_name: "argv"
	.byte	0x1	# DW_AT_decl_file (../gdb.opt/inline-break.c)
	.byte	0xd6	# DW_AT_decl_line
	.long	0x291	# DW_AT_type
	.uleb128 0x1	# DW_AT_location
	.byte	0x54	# DW_OP_reg4
	.uleb128 0x4	# (DIE (0x64) DW_TAG_variable)
	.ascii "x\0"	# DW_AT_name
	.byte	0x1	# DW_AT_decl_file (../gdb.opt/inline-break.c)
	.byte	0xdc	# DW_AT_decl_line
	.long	0x28c	# DW_AT_type
	.uleb128 0x2	# DW_AT_location
	.byte	0x91	# DW_OP_fbreg
	.sleb128 -12
	.uleb128 0x5	# (DIE (0x70) DW_TAG_inlined_subroutine)
	.long	0x516	# DW_AT_abstract_origin
	.quad	.LBB150	# DW_AT_low_pc
	.quad	.LBE150-.LBB150	# DW_AT_high_pc
	.byte	0x1	# DW_AT_call_file (../gdb.opt/inline-break.c)
	.byte	0xde	# DW_AT_call_line
	.long	0x95	# DW_AT_sibling
	.uleb128 0x6	# (DIE (0x8b) DW_TAG_formal_parameter)
	.long	0x526	# DW_AT_abstract_origin
	.long	.LLST4	# DW_AT_location
	.byte	0	# end of children of DIE 0x70
	.uleb128 0x5	# (DIE (0x95) DW_TAG_inlined_subroutine)
	.long	0x4fc	# DW_AT_abstract_origin
	.quad	.LBB152	# DW_AT_low_pc
	.quad	.LBE152-.LBB152	# DW_AT_high_pc
	.byte	0x1	# DW_AT_call_file (../gdb.opt/inline-break.c)
	.byte	0xe0	# DW_AT_call_line
	.long	0xba	# DW_AT_sibling
	.uleb128 0x6	# (DIE (0xb0) DW_TAG_formal_parameter)
	.long	0x50c	# DW_AT_abstract_origin
	.long	.LLST5	# DW_AT_location
	.byte	0	# end of children of DIE 0x95
	.uleb128 0x5	# (DIE (0xba) DW_TAG_inlined_subroutine)
	.long	0x4c8	# DW_AT_abstract_origin
	.quad	.LBB154	# DW_AT_low_pc
	.quad	.LBE154-.LBB154	# DW_AT_high_pc
	.byte	0x1	# DW_AT_call_file (../gdb.opt/inline-break.c)
	.byte	0xe2	# DW_AT_call_line
	.long	0x100	# DW_AT_sibling
	.uleb128 0x6	# (DIE (0xd5) DW_TAG_formal_parameter)
	.long	0x4d8	# DW_AT_abstract_origin
	.long	.LLST6	# DW_AT_location
	.uleb128 0x7	# (DIE (0xde) DW_TAG_inlined_subroutine)
	.long	0x4e2	# DW_AT_abstract_origin
	.quad	.LBB156	# DW_AT_low_pc
	.quad	.LBE156-.LBB156	# DW_AT_high_pc
	.byte	0x1	# DW_AT_call_file (../gdb.opt/inline-break.c)
	.byte	0x37	# DW_AT_call_line
	.uleb128 0x6	# (DIE (0xf5) DW_TAG_formal_parameter)
	.long	0x4f2	# DW_AT_abstract_origin
	.long	.LLST7	# DW_AT_location
	.byte	0	# end of children of DIE 0xde
	.byte	0	# end of children of DIE 0xba
	.uleb128 0x5	# (DIE (0x100) DW_TAG_inlined_subroutine)
	.long	0x494	# DW_AT_abstract_origin
	.quad	.LBB158	# DW_AT_low_pc
	.quad	.LBE158-.LBB158	# DW_AT_high_pc
	.byte	0x1	# DW_AT_call_file (../gdb.opt/inline-break.c)
	.byte	0xe4	# DW_AT_call_line
	.long	0x146	# DW_AT_sibling
	.uleb128 0x6	# (DIE (0x11b) DW_TAG_formal_parameter)
	.long	0x4a4	# DW_AT_abstract_origin
	.long	.LLST8	# DW_AT_location
	.uleb128 0x7	# (DIE (0x124) DW_TAG_inlined_subroutine)
	.long	0x4ae	# DW_AT_abstract_origin
	.quad	.LBB160	# DW_AT_low_pc
	.quad	.LBE160-.LBB160	# DW_AT_high_pc
	.byte	0x1	# DW_AT_call_file (../gdb.opt/inline-break.c)
	.byte	0x46	# DW_AT_call_line
	.uleb128 0x6	# (DIE (0x13b) DW_TAG_formal_parameter)
	.long	0x4be	# DW_AT_abstract_origin
	.long	.LLST9	# DW_AT_location
	.byte	0	# end of children of DIE 0x124
	.byte	0	# end of children of DIE 0x100
	.uleb128 0x5	# (DIE (0x146) DW_TAG_inlined_subroutine)
	.long	0x460	# DW_AT_abstract_origin
	.quad	.LBB162	# DW_AT_low_pc
	.quad	.LBE162-.LBB162	# DW_AT_high_pc
	.byte	0x1	# DW_AT_call_file (../gdb.opt/inline-break.c)
	.byte	0xe6	# DW_AT_call_line
	.long	0x18c	# DW_AT_sibling
	.uleb128 0x6	# (DIE (0x161) DW_TAG_formal_parameter)
	.long	0x470	# DW_AT_abstract_origin
	.long	.LLST10	# DW_AT_location
	.uleb128 0x7	# (DIE (0x16a) DW_TAG_inlined_subroutine)
	.long	0x47a	# DW_AT_abstract_origin
	.quad	.LBB164	# DW_AT_low_pc
	.quad	.LBE164-.LBB164	# DW_AT_high_pc
	.byte	0x1	# DW_AT_call_file (../gdb.opt/inline-break.c)
	.byte	0x55	# DW_AT_call_line
	.uleb128 0x6	# (DIE (0x181) DW_TAG_formal_parameter)
	.long	0x48a	# DW_AT_abstract_origin
	.long	.LLST11	# DW_AT_location
	.byte	0	# end of children of DIE 0x16a
	.byte	0	# end of children of DIE 0x146
	.uleb128 0x5	# (DIE (0x18c) DW_TAG_inlined_subroutine)
	.long	0x42c	# DW_AT_abstract_origin
	.quad	.LBB166	# DW_AT_low_pc
	.quad	.LBE166-.LBB166	# DW_AT_high_pc
	.byte	0x1	# DW_AT_call_file (../gdb.opt/inline-break.c)
	.byte	0xe8	# DW_AT_call_line
	.long	0x1d2	# DW_AT_sibling
	.uleb128 0x6	# (DIE (0x1a7) DW_TAG_formal_parameter)
	.long	0x43c	# DW_AT_abstract_origin
	.long	.LLST12	# DW_AT_location
	.uleb128 0x7	# (DIE (0x1b0) DW_TAG_inlined_subroutine)
	.long	0x446	# DW_AT_abstract_origin
	.quad	.LBB168	# DW_AT_low_pc
	.quad	.LBE168-.LBB168	# DW_AT_high_pc
	.byte	0x1	# DW_AT_call_file (../gdb.opt/inline-break.c)
	.byte	0x64	# DW_AT_call_line
	.uleb128 0x6	# (DIE (0x1c7) DW_TAG_formal_parameter)
	.long	0x456	# DW_AT_abstract_origin
	.long	.LLST13	# DW_AT_location
	.byte	0	# end of children of DIE 0x1b0
	.byte	0	# end of children of DIE 0x18c
	.uleb128 0x8	# (DIE (0x1d2) DW_TAG_inlined_subroutine)
	.long	0x3f8	# DW_AT_abstract_origin
	.quad	.LBB170	# DW_AT_entry_pc
	.long	.Ldebug_ranges0+0	# DW_AT_ranges
	.byte	0x1	# DW_AT_call_file (../gdb.opt/inline-break.c)
	.byte	0xea	# DW_AT_call_line
	.long	0x210	# DW_AT_sibling
	.uleb128 0x6	# (DIE (0x1e9) DW_TAG_formal_parameter)
	.long	0x408	# DW_AT_abstract_origin
	.long	.LLST14	# DW_AT_location
	.uleb128 0x9	# (DIE (0x1f2) DW_TAG_inlined_subroutine)
	.long	0x412	# DW_AT_abstract_origin
	.quad	.LBB172	# DW_AT_entry_pc
	.long	.Ldebug_ranges0+0x40	# DW_AT_ranges
	.byte	0x1	# DW_AT_call_file (../gdb.opt/inline-break.c)
	.byte	0x72	# DW_AT_call_line
	.uleb128 0x6	# (DIE (0x205) DW_TAG_formal_parameter)
	.long	0x422	# DW_AT_abstract_origin
	.long	.LLST15	# DW_AT_location
	.byte	0	# end of children of DIE 0x1f2
	.byte	0	# end of children of DIE 0x1d2
	.uleb128 0x8	# (DIE (0x210) DW_TAG_inlined_subroutine)
	.long	0x412	# DW_AT_abstract_origin
	.quad	.LBB180	# DW_AT_entry_pc
	.long	.Ldebug_ranges0+0x80	# DW_AT_ranges
	.byte	0x1	# DW_AT_call_file (../gdb.opt/inline-break.c)
	.byte	0xea	# DW_AT_call_line
	.long	0x22d	# DW_AT_sibling
	.uleb128 0xa	# (DIE (0x227) DW_TAG_formal_parameter)
	.long	0x422	# DW_AT_abstract_origin
	.byte	0	# end of children of DIE 0x210
	.uleb128 0x8	# (DIE (0x22d) DW_TAG_inlined_subroutine)
	.long	0x3c4	# DW_AT_abstract_origin
	.quad	.LBB188	# DW_AT_entry_pc
	.long	.Ldebug_ranges0+0xc0	# DW_AT_ranges
	.byte	0x1	# DW_AT_call_file (../gdb.opt/inline-break.c)
	.byte	0xec	# DW_AT_call_line
	.long	0x263	# DW_AT_sibling
	.uleb128 0xa	# (DIE (0x244) DW_TAG_formal_parameter)
	.long	0x3d4	# DW_AT_abstract_origin
	.uleb128 0x9	# (DIE (0x249) DW_TAG_inlined_subroutine)
	.long	0x3de	# DW_AT_abstract_origin
	.quad	.LBB190	# DW_AT_entry_pc
	.long	.Ldebug_ranges0+0xf0	# DW_AT_ranges
	.byte	0x1	# DW_AT_call_file (../gdb.opt/inline-break.c)
	.byte	0x80	# DW_AT_call_line
	.uleb128 0xa	# (DIE (0x25c) DW_TAG_formal_parameter)
	.long	0x3ee	# DW_AT_abstract_origin
	.byte	0	# end of children of DIE 0x249
	.byte	0	# end of children of DIE 0x22d
	.uleb128 0x7	# (DIE (0x263) DW_TAG_inlined_subroutine)
	.long	0x3de	# DW_AT_abstract_origin
	.quad	.LBB196	# DW_AT_low_pc
	.quad	.LBE196-.LBB196	# DW_AT_high_pc
	.byte	0x1	# DW_AT_call_file (../gdb.opt/inline-break.c)
	.byte	0xec	# DW_AT_call_line
	.uleb128 0x6	# (DIE (0x27a) DW_TAG_formal_parameter)
	.long	0x3ee	# DW_AT_abstract_origin
	.long	.LLST16	# DW_AT_location
	.byte	0	# end of children of DIE 0x263
	.byte	0	# end of children of DIE 0x29
	.uleb128 0xb	# (DIE (0x285) DW_TAG_base_type)
	.byte	0x4	# DW_AT_byte_size
	.byte	0x5	# DW_AT_encoding
	.ascii "int\0"	# DW_AT_name
	.uleb128 0xc	# (DIE (0x28c) DW_TAG_volatile_type)
	.long	0x285	# DW_AT_type
	.uleb128 0xd	# (DIE (0x291) DW_TAG_pointer_type)
	.byte	0x8	# DW_AT_byte_size
	.long	0x297	# DW_AT_type
	.uleb128 0xd	# (DIE (0x297) DW_TAG_pointer_type)
	.byte	0x8	# DW_AT_byte_size
	.long	0x29d	# DW_AT_type
	.uleb128 0xe	# (DIE (0x29d) DW_TAG_base_type)
	.byte	0x1	# DW_AT_byte_size
	.byte	0x6	# DW_AT_encoding
	.long	.LASF2	# DW_AT_name: "char"
	.uleb128 0xf	# (DIE (0x2a4) DW_TAG_subprogram)
			# DW_AT_external
	.long	.LASF7	# DW_AT_name: "func_extern_caller"
	.byte	0x1	# DW_AT_decl_file (../gdb.opt/inline-break.c)
	.byte	0xce	# DW_AT_decl_line
			# DW_AT_prototyped
	.long	0x285	# DW_AT_type
	.byte	0x1	# DW_AT_inline
	.long	0x2be	# DW_AT_sibling
	.uleb128 0x10	# (DIE (0x2b4) DW_TAG_formal_parameter)
	.ascii "x\0"	# DW_AT_name
	.byte	0x1	# DW_AT_decl_file (../gdb.opt/inline-break.c)
	.byte	0xce	# DW_AT_decl_line
	.long	0x285	# DW_AT_type
	.byte	0	# end of children of DIE 0x2a4
	.uleb128 0x11	# (DIE (0x2be) DW_TAG_subprogram)
	.long	.LASF3	# DW_AT_name: "func_inline_caller"
	.byte	0x1	# DW_AT_decl_file (../gdb.opt/inline-break.c)
	.byte	0xc5	# DW_AT_decl_line
			# DW_AT_prototyped
	.long	0x285	# DW_AT_type
	.byte	0x3	# DW_AT_inline
	.long	0x2d8	# DW_AT_sibling
	.uleb128 0x10	# (DIE (0x2ce) DW_TAG_formal_parameter)
	.ascii "x\0"	# DW_AT_name
	.byte	0x1	# DW_AT_decl_file (../gdb.opt/inline-break.c)
	.byte	0xc5	# DW_AT_decl_line
	.long	0x285	# DW_AT_type
	.byte	0	# end of children of DIE 0x2be
	.uleb128 0x11	# (DIE (0x2d8) DW_TAG_subprogram)
	.long	.LASF4	# DW_AT_name: "func_inline_callee"
	.byte	0x1	# DW_AT_decl_file (../gdb.opt/inline-break.c)
	.byte	0xbb	# DW_AT_decl_line
			# DW_AT_prototyped
	.long	0x285	# DW_AT_type
	.byte	0x3	# DW_AT_inline
	.long	0x2f2	# DW_AT_sibling
	.uleb128 0x10	# (DIE (0x2e8) DW_TAG_formal_parameter)
	.ascii "x\0"	# DW_AT_name
	.byte	0x1	# DW_AT_decl_file (../gdb.opt/inline-break.c)
	.byte	0xbb	# DW_AT_decl_line
	.long	0x285	# DW_AT_type
	.byte	0	# end of children of DIE 0x2d8
	.uleb128 0x11	# (DIE (0x2f2) DW_TAG_subprogram)
	.long	.LASF5	# DW_AT_name: "not_inline_func3"
	.byte	0x1	# DW_AT_decl_file (../gdb.opt/inline-break.c)
	.byte	0xac	# DW_AT_decl_line
			# DW_AT_prototyped
	.long	0x285	# DW_AT_type
	.byte	0x1	# DW_AT_inline
	.long	0x315	# DW_AT_sibling
	.uleb128 0x10	# (DIE (0x302) DW_TAG_formal_parameter)
	.ascii "x\0"	# DW_AT_name
	.byte	0x1	# DW_AT_decl_file (../gdb.opt/inline-break.c)
	.byte	0xac	# DW_AT_decl_line
	.long	0x285	# DW_AT_type
	.uleb128 0x12	# (DIE (0x30b) DW_TAG_variable)
	.ascii "y\0"	# DW_AT_name
	.byte	0x1	# DW_AT_decl_file (../gdb.opt/inline-break.c)
	.byte	0xae	# DW_AT_decl_line
	.long	0x285	# DW_AT_type
	.byte	0	# end of children of DIE 0x2f2
	.uleb128 0x11	# (DIE (0x315) DW_TAG_subprogram)
	.long	.LASF6	# DW_AT_name: "inline_func3"
	.byte	0x1	# DW_AT_decl_file (../gdb.opt/inline-break.c)
	.byte	0xa4	# DW_AT_decl_line
			# DW_AT_prototyped
	.long	0x285	# DW_AT_type
	.byte	0x3	# DW_AT_inline
	.long	0x338	# DW_AT_sibling
	.uleb128 0x10	# (DIE (0x325) DW_TAG_formal_parameter)
	.ascii "x\0"	# DW_AT_name
	.byte	0x1	# DW_AT_decl_file (../gdb.opt/inline-break.c)
	.byte	0xa4	# DW_AT_decl_line
	.long	0x285	# DW_AT_type
	.uleb128 0x12	# (DIE (0x32e) DW_TAG_variable)
	.ascii "y\0"	# DW_AT_name
	.byte	0x1	# DW_AT_decl_file (../gdb.opt/inline-break.c)
	.byte	0xa6	# DW_AT_decl_line
	.long	0x285	# DW_AT_type
	.byte	0	# end of children of DIE 0x315
	.uleb128 0xf	# (DIE (0x338) DW_TAG_subprogram)
			# DW_AT_external
	.long	.LASF8	# DW_AT_name: "not_inline_func2"
	.byte	0x1	# DW_AT_decl_file (../gdb.opt/inline-break.c)
	.byte	0x9c	# DW_AT_decl_line
			# DW_AT_prototyped
	.long	0x285	# DW_AT_type
	.byte	0x1	# DW_AT_inline
	.long	0x35b	# DW_AT_sibling
	.uleb128 0x10	# (DIE (0x348) DW_TAG_formal_parameter)
	.ascii "x\0"	# DW_AT_name
	.byte	0x1	# DW_AT_decl_file (../gdb.opt/inline-break.c)
	.byte	0x9c	# DW_AT_decl_line
	.long	0x285	# DW_AT_type
	.uleb128 0x12	# (DIE (0x351) DW_TAG_variable)
	.ascii "y\0"	# DW_AT_name
	.byte	0x1	# DW_AT_decl_file (../gdb.opt/inline-break.c)
	.byte	0x9e	# DW_AT_decl_line
	.long	0x285	# DW_AT_type
	.byte	0	# end of children of DIE 0x338
	.uleb128 0xf	# (DIE (0x35b) DW_TAG_subprogram)
			# DW_AT_external
	.long	.LASF9	# DW_AT_name: "inline_func2"
	.byte	0x1	# DW_AT_decl_file (../gdb.opt/inline-break.c)
	.byte	0x94	# DW_AT_decl_line
			# DW_AT_prototyped
	.long	0x285	# DW_AT_type
	.byte	0x3	# DW_AT_inline
	.long	0x37e	# DW_AT_sibling
	.uleb128 0x10	# (DIE (0x36b) DW_TAG_formal_parameter)
	.ascii "x\0"	# DW_AT_name
	.byte	0x1	# DW_AT_decl_file (../gdb.opt/inline-break.c)
	.byte	0x94	# DW_AT_decl_line
	.long	0x285	# DW_AT_type
	.uleb128 0x12	# (DIE (0x374) DW_TAG_variable)
	.ascii "y\0"	# DW_AT_name
	.byte	0x1	# DW_AT_decl_file (../gdb.opt/inline-break.c)
	.byte	0x96	# DW_AT_decl_line
	.long	0x285	# DW_AT_type
	.byte	0	# end of children of DIE 0x35b
	.uleb128 0x11	# (DIE (0x37e) DW_TAG_subprogram)
	.long	.LASF10	# DW_AT_name: "not_inline_func1"
	.byte	0x1	# DW_AT_decl_file (../gdb.opt/inline-break.c)
	.byte	0x8c	# DW_AT_decl_line
			# DW_AT_prototyped
	.long	0x285	# DW_AT_type
	.byte	0x1	# DW_AT_inline
	.long	0x3a1	# DW_AT_sibling
	.uleb128 0x10	# (DIE (0x38e) DW_TAG_formal_parameter)
	.ascii "x\0"	# DW_AT_name
	.byte	0x1	# DW_AT_decl_file (../gdb.opt/inline-break.c)
	.byte	0x8c	# DW_AT_decl_line
	.long	0x285	# DW_AT_type
	.uleb128 0x12	# (DIE (0x397) DW_TAG_variable)
	.ascii "y\0"	# DW_AT_name
	.byte	0x1	# DW_AT_decl_file (../gdb.opt/inline-break.c)
	.byte	0x8e	# DW_AT_decl_line
	.long	0x285	# DW_AT_type
	.byte	0	# end of children of DIE 0x37e
	.uleb128 0x11	# (DIE (0x3a1) DW_TAG_subprogram)
	.long	.LASF11	# DW_AT_name: "inline_func1"
	.byte	0x1	# DW_AT_decl_file (../gdb.opt/inline-break.c)
	.byte	0x84	# DW_AT_decl_line
			# DW_AT_prototyped
	.long	0x285	# DW_AT_type
	.byte	0x3	# DW_AT_inline
	.long	0x3c4	# DW_AT_sibling
	.uleb128 0x10	# (DIE (0x3b1) DW_TAG_formal_parameter)
	.ascii "x\0"	# DW_AT_name
	.byte	0x1	# DW_AT_decl_file (../gdb.opt/inline-break.c)
	.byte	0x84	# DW_AT_decl_line
	.long	0x285	# DW_AT_type
	.uleb128 0x12	# (DIE (0x3ba) DW_TAG_variable)
	.ascii "y\0"	# DW_AT_name
	.byte	0x1	# DW_AT_decl_file (../gdb.opt/inline-break.c)
	.byte	0x86	# DW_AT_decl_line
	.long	0x285	# DW_AT_type
	.byte	0	# end of children of DIE 0x3a1
	.uleb128 0x11	# (DIE (0x3c4) DW_TAG_subprogram)
	.long	.LASF12	# DW_AT_name: "func8a"
	.byte	0x1	# DW_AT_decl_file (../gdb.opt/inline-break.c)
	.byte	0x7e	# DW_AT_decl_line
			# DW_AT_prototyped
	.long	0x285	# DW_AT_type
	.byte	0x3	# DW_AT_inline
	.long	0x3de	# DW_AT_sibling
	.uleb128 0x10	# (DIE (0x3d4) DW_TAG_formal_parameter)
	.ascii "x\0"	# DW_AT_name
	.byte	0x1	# DW_AT_decl_file (../gdb.opt/inline-break.c)
	.byte	0x7e	# DW_AT_decl_line
	.long	0x285	# DW_AT_type
	.byte	0	# end of children of DIE 0x3c4
	.uleb128 0xf	# (DIE (0x3de) DW_TAG_subprogram)
			# DW_AT_external
	.long	.LASF13	# DW_AT_name: "func8b"
	.byte	0x1	# DW_AT_decl_file (../gdb.opt/inline-break.c)
	.byte	0x78	# DW_AT_decl_line
			# DW_AT_prototyped
	.long	0x285	# DW_AT_type
	.byte	0x3	# DW_AT_inline
	.long	0x3f8	# DW_AT_sibling
	.uleb128 0x10	# (DIE (0x3ee) DW_TAG_formal_parameter)
	.ascii "x\0"	# DW_AT_name
	.byte	0x1	# DW_AT_decl_file (../gdb.opt/inline-break.c)
	.byte	0x78	# DW_AT_decl_line
	.long	0x285	# DW_AT_type
	.byte	0	# end of children of DIE 0x3de
	.uleb128 0x11	# (DIE (0x3f8) DW_TAG_subprogram)
	.long	.LASF14	# DW_AT_name: "func7a"
	.byte	0x1	# DW_AT_decl_file (../gdb.opt/inline-break.c)
	.byte	0x70	# DW_AT_decl_line
			# DW_AT_prototyped
	.long	0x285	# DW_AT_type
	.byte	0x3	# DW_AT_inline
	.long	0x412	# DW_AT_sibling
	.uleb128 0x10	# (DIE (0x408) DW_TAG_formal_parameter)
	.ascii "x\0"	# DW_AT_name
	.byte	0x1	# DW_AT_decl_file (../gdb.opt/inline-break.c)
	.byte	0x70	# DW_AT_decl_line
	.long	0x285	# DW_AT_type
	.byte	0	# end of children of DIE 0x3f8
	.uleb128 0x11	# (DIE (0x412) DW_TAG_subprogram)
	.long	.LASF15	# DW_AT_name: "func7b"
	.byte	0x1	# DW_AT_decl_file (../gdb.opt/inline-break.c)
	.byte	0x6a	# DW_AT_decl_line
			# DW_AT_prototyped
	.long	0x285	# DW_AT_type
	.byte	0x3	# DW_AT_inline
	.long	0x42c	# DW_AT_sibling
	.uleb128 0x10	# (DIE (0x422) DW_TAG_formal_parameter)
	.ascii "x\0"	# DW_AT_name
	.byte	0x1	# DW_AT_decl_file (../gdb.opt/inline-break.c)
	.byte	0x6a	# DW_AT_decl_line
	.long	0x285	# DW_AT_type
	.byte	0	# end of children of DIE 0x412
	.uleb128 0xf	# (DIE (0x42c) DW_TAG_subprogram)
			# DW_AT_external
	.long	.LASF16	# DW_AT_name: "func6a"
	.byte	0x1	# DW_AT_decl_file (../gdb.opt/inline-break.c)
	.byte	0x62	# DW_AT_decl_line
			# DW_AT_prototyped
	.long	0x285	# DW_AT_type
	.byte	0x3	# DW_AT_inline
	.long	0x446	# DW_AT_sibling
	.uleb128 0x10	# (DIE (0x43c) DW_TAG_formal_parameter)
	.ascii "x\0"	# DW_AT_name
	.byte	0x1	# DW_AT_decl_file (../gdb.opt/inline-break.c)
	.byte	0x62	# DW_AT_decl_line
	.long	0x285	# DW_AT_type
	.byte	0	# end of children of DIE 0x42c
	.uleb128 0xf	# (DIE (0x446) DW_TAG_subprogram)
			# DW_AT_external
	.long	.LASF17	# DW_AT_name: "func6b"
	.byte	0x1	# DW_AT_decl_file (../gdb.opt/inline-break.c)
	.byte	0x5c	# DW_AT_decl_line
			# DW_AT_prototyped
	.long	0x285	# DW_AT_type
	.byte	0x3	# DW_AT_inline
	.long	0x460	# DW_AT_sibling
	.uleb128 0x10	# (DIE (0x456) DW_TAG_formal_parameter)
	.ascii "x\0"	# DW_AT_name
	.byte	0x1	# DW_AT_decl_file (../gdb.opt/inline-break.c)
	.byte	0x5c	# DW_AT_decl_line
	.long	0x285	# DW_AT_type
	.byte	0	# end of children of DIE 0x446
	.uleb128 0x11	# (DIE (0x460) DW_TAG_subprogram)
	.long	.LASF18	# DW_AT_name: "func5a"
	.byte	0x1	# DW_AT_decl_file (../gdb.opt/inline-break.c)
	.byte	0x53	# DW_AT_decl_line
			# DW_AT_prototyped
	.long	0x285	# DW_AT_type
	.byte	0x3	# DW_AT_inline
	.long	0x47a	# DW_AT_sibling
	.uleb128 0x10	# (DIE (0x470) DW_TAG_formal_parameter)
	.ascii "x\0"	# DW_AT_name
	.byte	0x1	# DW_AT_decl_file (../gdb.opt/inline-break.c)
	.byte	0x53	# DW_AT_decl_line
	.long	0x285	# DW_AT_type
	.byte	0	# end of children of DIE 0x460
	.uleb128 0xf	# (DIE (0x47a) DW_TAG_subprogram)
			# DW_AT_external
	.long	.LASF19	# DW_AT_name: "func5b"
	.byte	0x1	# DW_AT_decl_file (../gdb.opt/inline-break.c)
	.byte	0x4d	# DW_AT_decl_line
			# DW_AT_prototyped
	.long	0x285	# DW_AT_type
	.byte	0x3	# DW_AT_inline
	.long	0x494	# DW_AT_sibling
	.uleb128 0x10	# (DIE (0x48a) DW_TAG_formal_parameter)
	.ascii "x\0"	# DW_AT_name
	.byte	0x1	# DW_AT_decl_file (../gdb.opt/inline-break.c)
	.byte	0x4d	# DW_AT_decl_line
	.long	0x285	# DW_AT_type
	.byte	0	# end of children of DIE 0x47a
	.uleb128 0xf	# (DIE (0x494) DW_TAG_subprogram)
			# DW_AT_external
	.long	.LASF20	# DW_AT_name: "func4a"
	.byte	0x1	# DW_AT_decl_file (../gdb.opt/inline-break.c)
	.byte	0x44	# DW_AT_decl_line
			# DW_AT_prototyped
	.long	0x285	# DW_AT_type
	.byte	0x3	# DW_AT_inline
	.long	0x4ae	# DW_AT_sibling
	.uleb128 0x10	# (DIE (0x4a4) DW_TAG_formal_parameter)
	.ascii "x\0"	# DW_AT_name
	.byte	0x1	# DW_AT_decl_file (../gdb.opt/inline-break.c)
	.byte	0x44	# DW_AT_decl_line
	.long	0x285	# DW_AT_type
	.byte	0	# end of children of DIE 0x494
	.uleb128 0x11	# (DIE (0x4ae) DW_TAG_subprogram)
	.long	.LASF21	# DW_AT_name: "func4b"
	.byte	0x1	# DW_AT_decl_file (../gdb.opt/inline-break.c)
	.byte	0x3e	# DW_AT_decl_line
			# DW_AT_prototyped
	.long	0x285	# DW_AT_type
	.byte	0x3	# DW_AT_inline
	.long	0x4c8	# DW_AT_sibling
	.uleb128 0x10	# (DIE (0x4be) DW_TAG_formal_parameter)
	.ascii "x\0"	# DW_AT_name
	.byte	0x1	# DW_AT_decl_file (../gdb.opt/inline-break.c)
	.byte	0x3e	# DW_AT_decl_line
	.long	0x285	# DW_AT_type
	.byte	0	# end of children of DIE 0x4ae
	.uleb128 0x11	# (DIE (0x4c8) DW_TAG_subprogram)
	.long	.LASF22	# DW_AT_name: "func3a"
	.byte	0x1	# DW_AT_decl_file (../gdb.opt/inline-break.c)
	.byte	0x35	# DW_AT_decl_line
			# DW_AT_prototyped
	.long	0x285	# DW_AT_type
	.byte	0x3	# DW_AT_inline
	.long	0x4e2	# DW_AT_sibling
	.uleb128 0x10	# (DIE (0x4d8) DW_TAG_formal_parameter)
	.ascii "x\0"	# DW_AT_name
	.byte	0x1	# DW_AT_decl_file (../gdb.opt/inline-break.c)
	.byte	0x35	# DW_AT_decl_line
	.long	0x285	# DW_AT_type
	.byte	0	# end of children of DIE 0x4c8
	.uleb128 0x11	# (DIE (0x4e2) DW_TAG_subprogram)
	.long	.LASF23	# DW_AT_name: "func3b"
	.byte	0x1	# DW_AT_decl_file (../gdb.opt/inline-break.c)
	.byte	0x2f	# DW_AT_decl_line
			# DW_AT_prototyped
	.long	0x285	# DW_AT_type
	.byte	0x3	# DW_AT_inline
	.long	0x4fc	# DW_AT_sibling
	.uleb128 0x10	# (DIE (0x4f2) DW_TAG_formal_parameter)
	.ascii "x\0"	# DW_AT_name
	.byte	0x1	# DW_AT_decl_file (../gdb.opt/inline-break.c)
	.byte	0x2f	# DW_AT_decl_line
	.long	0x285	# DW_AT_type
	.byte	0	# end of children of DIE 0x4e2
	.uleb128 0xf	# (DIE (0x4fc) DW_TAG_subprogram)
			# DW_AT_external
	.long	.LASF24	# DW_AT_name: "func2"
	.byte	0x1	# DW_AT_decl_file (../gdb.opt/inline-break.c)
	.byte	0x26	# DW_AT_decl_line
			# DW_AT_prototyped
	.long	0x285	# DW_AT_type
	.byte	0x3	# DW_AT_inline
	.long	0x516	# DW_AT_sibling
	.uleb128 0x10	# (DIE (0x50c) DW_TAG_formal_parameter)
	.ascii "x\0"	# DW_AT_name
	.byte	0x1	# DW_AT_decl_file (../gdb.opt/inline-break.c)
	.byte	0x26	# DW_AT_decl_line
	.long	0x285	# DW_AT_type
	.byte	0	# end of children of DIE 0x4fc
	.uleb128 0x11	# (DIE (0x516) DW_TAG_subprogram)
	.long	.LASF25	# DW_AT_name: "func1"
	.byte	0x1	# DW_AT_decl_file (../gdb.opt/inline-break.c)
	.byte	0x1e	# DW_AT_decl_line
			# DW_AT_prototyped
	.long	0x285	# DW_AT_type
	.byte	0x3	# DW_AT_inline
	.long	0x530	# DW_AT_sibling
	.uleb128 0x10	# (DIE (0x526) DW_TAG_formal_parameter)
	.ascii "x\0"	# DW_AT_name
	.byte	0x1	# DW_AT_decl_file (../gdb.opt/inline-break.c)
	.byte	0x1e	# DW_AT_decl_line
	.long	0x285	# DW_AT_type
	.byte	0	# end of children of DIE 0x516
	.uleb128 0x13	# (DIE (0x530) DW_TAG_subprogram)
	.long	0x4fc	# DW_AT_abstract_origin
	.quad	.LFB1	# DW_AT_low_pc
	.quad	.LFE1-.LFB1	# DW_AT_high_pc
	.uleb128 0x1	# DW_AT_frame_base
	.byte	0x9c	# DW_OP_call_frame_cfa
			# DW_AT_GNU_all_call_sites
	.long	0x553	# DW_AT_sibling
	.uleb128 0x14	# (DIE (0x54b) DW_TAG_formal_parameter)
	.long	0x50c	# DW_AT_abstract_origin
	.uleb128 0x1	# DW_AT_location
	.byte	0x55	# DW_OP_reg5
	.byte	0	# end of children of DIE 0x530
	.uleb128 0x13	# (DIE (0x553) DW_TAG_subprogram)
	.long	0x494	# DW_AT_abstract_origin
	.quad	.LFB5	# DW_AT_low_pc
	.quad	.LFE5-.LFB5	# DW_AT_high_pc
	.uleb128 0x1	# DW_AT_frame_base
	.byte	0x9c	# DW_OP_call_frame_cfa
			# DW_AT_GNU_all_call_sites
	.long	0x599	# DW_AT_sibling
	.uleb128 0x6	# (DIE (0x56e) DW_TAG_formal_parameter)
	.long	0x4a4	# DW_AT_abstract_origin
	.long	.LLST0	# DW_AT_location
	.uleb128 0x7	# (DIE (0x577) DW_TAG_inlined_subroutine)
	.long	0x4ae	# DW_AT_abstract_origin
	.quad	.LBB103	# DW_AT_low_pc
	.quad	.LBE103-.LBB103	# DW_AT_high_pc
	.byte	0x1	# DW_AT_call_file (../gdb.opt/inline-break.c)
	.byte	0x46	# DW_AT_call_line
	.uleb128 0x6	# (DIE (0x58e) DW_TAG_formal_parameter)
	.long	0x4be	# DW_AT_abstract_origin
	.long	.LLST1	# DW_AT_location
	.byte	0	# end of children of DIE 0x577
	.byte	0	# end of children of DIE 0x553
	.uleb128 0x13	# (DIE (0x599) DW_TAG_subprogram)
	.long	0x47a	# DW_AT_abstract_origin
	.quad	.LFB6	# DW_AT_low_pc
	.quad	.LFE6-.LFB6	# DW_AT_high_pc
	.uleb128 0x1	# DW_AT_frame_base
	.byte	0x9c	# DW_OP_call_frame_cfa
			# DW_AT_GNU_all_call_sites
	.long	0x5bc	# DW_AT_sibling
	.uleb128 0x14	# (DIE (0x5b4) DW_TAG_formal_parameter)
	.long	0x48a	# DW_AT_abstract_origin
	.uleb128 0x1	# DW_AT_location
	.byte	0x55	# DW_OP_reg5
	.byte	0	# end of children of DIE 0x599
	.uleb128 0x13	# (DIE (0x5bc) DW_TAG_subprogram)
	.long	0x446	# DW_AT_abstract_origin
	.quad	.LFB8	# DW_AT_low_pc
	.quad	.LFE8-.LFB8	# DW_AT_high_pc
	.uleb128 0x1	# DW_AT_frame_base
	.byte	0x9c	# DW_OP_call_frame_cfa
			# DW_AT_GNU_all_call_sites
	.long	0x5df	# DW_AT_sibling
	.uleb128 0x14	# (DIE (0x5d7) DW_TAG_formal_parameter)
	.long	0x456	# DW_AT_abstract_origin
	.uleb128 0x1	# DW_AT_location
	.byte	0x55	# DW_OP_reg5
	.byte	0	# end of children of DIE 0x5bc
	.uleb128 0x13	# (DIE (0x5df) DW_TAG_subprogram)
	.long	0x42c	# DW_AT_abstract_origin
	.quad	.LFB9	# DW_AT_low_pc
	.quad	.LFE9-.LFB9	# DW_AT_high_pc
	.uleb128 0x1	# DW_AT_frame_base
	.byte	0x9c	# DW_OP_call_frame_cfa
			# DW_AT_GNU_all_call_sites
	.long	0x625	# DW_AT_sibling
	.uleb128 0x6	# (DIE (0x5fa) DW_TAG_formal_parameter)
	.long	0x43c	# DW_AT_abstract_origin
	.long	.LLST2	# DW_AT_location
	.uleb128 0x7	# (DIE (0x603) DW_TAG_inlined_subroutine)
	.long	0x446	# DW_AT_abstract_origin
	.quad	.LBB105	# DW_AT_low_pc
	.quad	.LBE105-.LBB105	# DW_AT_high_pc
	.byte	0x1	# DW_AT_call_file (../gdb.opt/inline-break.c)
	.byte	0x64	# DW_AT_call_line
	.uleb128 0x6	# (DIE (0x61a) DW_TAG_formal_parameter)
	.long	0x456	# DW_AT_abstract_origin
	.long	.LLST3	# DW_AT_location
	.byte	0	# end of children of DIE 0x603
	.byte	0	# end of children of DIE 0x5df
	.uleb128 0x13	# (DIE (0x625) DW_TAG_subprogram)
	.long	0x3de	# DW_AT_abstract_origin
	.quad	.LFB12	# DW_AT_low_pc
	.quad	.LFE12-.LFB12	# DW_AT_high_pc
	.uleb128 0x1	# DW_AT_frame_base
	.byte	0x9c	# DW_OP_call_frame_cfa
			# DW_AT_GNU_all_call_sites
	.long	0x648	# DW_AT_sibling
	.uleb128 0x14	# (DIE (0x640) DW_TAG_formal_parameter)
	.long	0x3ee	# DW_AT_abstract_origin
	.uleb128 0x1	# DW_AT_location
	.byte	0x55	# DW_OP_reg5
	.byte	0	# end of children of DIE 0x625
	.uleb128 0x13	# (DIE (0x648) DW_TAG_subprogram)
	.long	0x35b	# DW_AT_abstract_origin
	.quad	.LFB16	# DW_AT_low_pc
	.quad	.LFE16-.LFB16	# DW_AT_high_pc
	.uleb128 0x1	# DW_AT_frame_base
	.byte	0x9c	# DW_OP_call_frame_cfa
			# DW_AT_GNU_all_call_sites
	.long	0x671	# DW_AT_sibling
	.uleb128 0x14	# (DIE (0x663) DW_TAG_formal_parameter)
	.long	0x36b	# DW_AT_abstract_origin
	.uleb128 0x1	# DW_AT_location
	.byte	0x55	# DW_OP_reg5
	.uleb128 0x15	# (DIE (0x66a) DW_TAG_variable)
	.long	0x374	# DW_AT_abstract_origin
	.byte	0x3	# DW_AT_const_value
	.byte	0	# end of children of DIE 0x648
	.uleb128 0x13	# (DIE (0x671) DW_TAG_subprogram)
	.long	0x338	# DW_AT_abstract_origin
	.quad	.LFB17	# DW_AT_low_pc
	.quad	.LFE17-.LFB17	# DW_AT_high_pc
	.uleb128 0x1	# DW_AT_frame_base
	.byte	0x9c	# DW_OP_call_frame_cfa
			# DW_AT_GNU_all_call_sites
	.long	0x69a	# DW_AT_sibling
	.uleb128 0x14	# (DIE (0x68c) DW_TAG_formal_parameter)
	.long	0x348	# DW_AT_abstract_origin
	.uleb128 0x1	# DW_AT_location
	.byte	0x55	# DW_OP_reg5
	.uleb128 0x15	# (DIE (0x693) DW_TAG_variable)
	.long	0x351	# DW_AT_abstract_origin
	.byte	0x4	# DW_AT_const_value
	.byte	0	# end of children of DIE 0x671
	.uleb128 0x16	# (DIE (0x69a) DW_TAG_subprogram)
	.long	0x2a4	# DW_AT_abstract_origin
	.quad	.LFB22	# DW_AT_low_pc
	.quad	.LFE22-.LFB22	# DW_AT_high_pc
	.uleb128 0x1	# DW_AT_frame_base
	.byte	0x9c	# DW_OP_call_frame_cfa
			# DW_AT_GNU_all_call_sites
	.uleb128 0x14	# (DIE (0x6b1) DW_TAG_formal_parameter)
	.long	0x2b4	# DW_AT_abstract_origin
	.uleb128 0x1	# DW_AT_location
	.byte	0x55	# DW_OP_reg5
	.uleb128 0x7	# (DIE (0x6b8) DW_TAG_inlined_subroutine)
	.long	0x2be	# DW_AT_abstract_origin
	.quad	.LBB109	# DW_AT_low_pc
	.quad	.LBE109-.LBB109	# DW_AT_high_pc
	.byte	0x1	# DW_AT_call_file (../gdb.opt/inline-break.c)
	.byte	0xd0	# DW_AT_call_line
	.uleb128 0xa	# (DIE (0x6cf) DW_TAG_formal_parameter)
	.long	0x2ce	# DW_AT_abstract_origin
	.uleb128 0x7	# (DIE (0x6d4) DW_TAG_inlined_subroutine)
	.long	0x2d8	# DW_AT_abstract_origin
	.quad	.LBB110	# DW_AT_low_pc
	.quad	.LBE110-.LBB110	# DW_AT_high_pc
	.byte	0x1	# DW_AT_call_file (../gdb.opt/inline-break.c)
	.byte	0xc7	# DW_AT_call_line
	.uleb128 0xa	# (DIE (0x6eb) DW_TAG_formal_parameter)
	.long	0x2e8	# DW_AT_abstract_origin
	.byte	0	# end of children of DIE 0x6d4
	.byte	0	# end of children of DIE 0x6b8
	.byte	0	# end of children of DIE 0x69a
	.byte	0	# end of children of DIE 0xb
	.section	.debug_abbrev,"",@progbits
.Ldebug_abbrev0:
	.uleb128 0x1	# (abbrev code)
	.uleb128 0x11	# (TAG: DW_TAG_compile_unit)
	.byte	0x1	# DW_children_yes
	.uleb128 0x25	# (DW_AT_producer)
	.uleb128 0xe	# (DW_FORM_strp)
	.uleb128 0x13	# (DW_AT_language)
	.uleb128 0xb	# (DW_FORM_data1)
	.uleb128 0x3	# (DW_AT_name)
	.uleb128 0xe	# (DW_FORM_strp)
	.uleb128 0x1b	# (DW_AT_comp_dir)
	.uleb128 0xe	# (DW_FORM_strp)
	.uleb128 0x55	# (DW_AT_ranges)
	.uleb128 0x17	# (DW_FORM_sec_offset)
	.uleb128 0x11	# (DW_AT_low_pc)
	.uleb128 0x1	# (DW_FORM_addr)
	.uleb128 0x10	# (DW_AT_stmt_list)
	.uleb128 0x17	# (DW_FORM_sec_offset)
	.byte	0
	.byte	0
	.uleb128 0x2	# (abbrev code)
	.uleb128 0x2e	# (TAG: DW_TAG_subprogram)
	.byte	0x1	# DW_children_yes
	.uleb128 0x3f	# (DW_AT_external)
	.uleb128 0x19	# (DW_FORM_flag_present)
	.uleb128 0x3	# (DW_AT_name)
	.uleb128 0xe	# (DW_FORM_strp)
	.uleb128 0x3a	# (DW_AT_decl_file)
	.uleb128 0xb	# (DW_FORM_data1)
	.uleb128 0x3b	# (DW_AT_decl_line)
	.uleb128 0xb	# (DW_FORM_data1)
	.uleb128 0x27	# (DW_AT_prototyped)
	.uleb128 0x19	# (DW_FORM_flag_present)
	.uleb128 0x49	# (DW_AT_type)
	.uleb128 0x13	# (DW_FORM_ref4)
	.uleb128 0x11	# (DW_AT_low_pc)
	.uleb128 0x1	# (DW_FORM_addr)
	.uleb128 0x12	# (DW_AT_high_pc)
	.uleb128 0x7	# (DW_FORM_data8)
	.uleb128 0x40	# (DW_AT_frame_base)
	.uleb128 0x18	# (DW_FORM_exprloc)
	.uleb128 0x2117	# (DW_AT_GNU_all_call_sites)
	.uleb128 0x19	# (DW_FORM_flag_present)
	.uleb128 0x1	# (DW_AT_sibling)
	.uleb128 0x13	# (DW_FORM_ref4)
	.byte	0
	.byte	0
	.uleb128 0x3	# (abbrev code)
	.uleb128 0x5	# (TAG: DW_TAG_formal_parameter)
	.byte	0	# DW_children_no
	.uleb128 0x3	# (DW_AT_name)
	.uleb128 0xe	# (DW_FORM_strp)
	.uleb128 0x3a	# (DW_AT_decl_file)
	.uleb128 0xb	# (DW_FORM_data1)
	.uleb128 0x3b	# (DW_AT_decl_line)
	.uleb128 0xb	# (DW_FORM_data1)
	.uleb128 0x49	# (DW_AT_type)
	.uleb128 0x13	# (DW_FORM_ref4)
	.uleb128 0x2	# (DW_AT_location)
	.uleb128 0x18	# (DW_FORM_exprloc)
	.byte	0
	.byte	0
	.uleb128 0x4	# (abbrev code)
	.uleb128 0x34	# (TAG: DW_TAG_variable)
	.byte	0	# DW_children_no
	.uleb128 0x3	# (DW_AT_name)
	.uleb128 0x8	# (DW_FORM_string)
	.uleb128 0x3a	# (DW_AT_decl_file)
	.uleb128 0xb	# (DW_FORM_data1)
	.uleb128 0x3b	# (DW_AT_decl_line)
	.uleb128 0xb	# (DW_FORM_data1)
	.uleb128 0x49	# (DW_AT_type)
	.uleb128 0x13	# (DW_FORM_ref4)
	.uleb128 0x2	# (DW_AT_location)
	.uleb128 0x18	# (DW_FORM_exprloc)
	.byte	0
	.byte	0
	.uleb128 0x5	# (abbrev code)
	.uleb128 0x1d	# (TAG: DW_TAG_inlined_subroutine)
	.byte	0x1	# DW_children_yes
	.uleb128 0x31	# (DW_AT_abstract_origin)
	.uleb128 0x13	# (DW_FORM_ref4)
	.uleb128 0x11	# (DW_AT_low_pc)
	.uleb128 0x1	# (DW_FORM_addr)
	.uleb128 0x12	# (DW_AT_high_pc)
	.uleb128 0x7	# (DW_FORM_data8)
	.uleb128 0x58	# (DW_AT_call_file)
	.uleb128 0xb	# (DW_FORM_data1)
	.uleb128 0x59	# (DW_AT_call_line)
	.uleb128 0xb	# (DW_FORM_data1)
	.uleb128 0x1	# (DW_AT_sibling)
	.uleb128 0x13	# (DW_FORM_ref4)
	.byte	0
	.byte	0
	.uleb128 0x6	# (abbrev code)
	.uleb128 0x5	# (TAG: DW_TAG_formal_parameter)
	.byte	0	# DW_children_no
	.uleb128 0x31	# (DW_AT_abstract_origin)
	.uleb128 0x13	# (DW_FORM_ref4)
	.uleb128 0x2	# (DW_AT_location)
	.uleb128 0x17	# (DW_FORM_sec_offset)
	.byte	0
	.byte	0
	.uleb128 0x7	# (abbrev code)
	.uleb128 0x1d	# (TAG: DW_TAG_inlined_subroutine)
	.byte	0x1	# DW_children_yes
	.uleb128 0x31	# (DW_AT_abstract_origin)
	.uleb128 0x13	# (DW_FORM_ref4)
	.uleb128 0x11	# (DW_AT_low_pc)
	.uleb128 0x1	# (DW_FORM_addr)
	.uleb128 0x12	# (DW_AT_high_pc)
	.uleb128 0x7	# (DW_FORM_data8)
	.uleb128 0x58	# (DW_AT_call_file)
	.uleb128 0xb	# (DW_FORM_data1)
	.uleb128 0x59	# (DW_AT_call_line)
	.uleb128 0xb	# (DW_FORM_data1)
	.byte	0
	.byte	0
	.uleb128 0x8	# (abbrev code)
	.uleb128 0x1d	# (TAG: DW_TAG_inlined_subroutine)
	.byte	0x1	# DW_children_yes
	.uleb128 0x31	# (DW_AT_abstract_origin)
	.uleb128 0x13	# (DW_FORM_ref4)
	.uleb128 0x52	# (DW_AT_entry_pc)
	.uleb128 0x1	# (DW_FORM_addr)
	.uleb128 0x55	# (DW_AT_ranges)
	.uleb128 0x17	# (DW_FORM_sec_offset)
	.uleb128 0x58	# (DW_AT_call_file)
	.uleb128 0xb	# (DW_FORM_data1)
	.uleb128 0x59	# (DW_AT_call_line)
	.uleb128 0xb	# (DW_FORM_data1)
	.uleb128 0x1	# (DW_AT_sibling)
	.uleb128 0x13	# (DW_FORM_ref4)
	.byte	0
	.byte	0
	.uleb128 0x9	# (abbrev code)
	.uleb128 0x1d	# (TAG: DW_TAG_inlined_subroutine)
	.byte	0x1	# DW_children_yes
	.uleb128 0x31	# (DW_AT_abstract_origin)
	.uleb128 0x13	# (DW_FORM_ref4)
	.uleb128 0x52	# (DW_AT_entry_pc)
	.uleb128 0x1	# (DW_FORM_addr)
	.uleb128 0x55	# (DW_AT_ranges)
	.uleb128 0x17	# (DW_FORM_sec_offset)
	.uleb128 0x58	# (DW_AT_call_file)
	.uleb128 0xb	# (DW_FORM_data1)
	.uleb128 0x59	# (DW_AT_call_line)
	.uleb128 0xb	# (DW_FORM_data1)
	.byte	0
	.byte	0
	.uleb128 0xa	# (abbrev code)
	.uleb128 0x5	# (TAG: DW_TAG_formal_parameter)
	.byte	0	# DW_children_no
	.uleb128 0x31	# (DW_AT_abstract_origin)
	.uleb128 0x13	# (DW_FORM_ref4)
	.byte	0
	.byte	0
	.uleb128 0xb	# (abbrev code)
	.uleb128 0x24	# (TAG: DW_TAG_base_type)
	.byte	0	# DW_children_no
	.uleb128 0xb	# (DW_AT_byte_size)
	.uleb128 0xb	# (DW_FORM_data1)
	.uleb128 0x3e	# (DW_AT_encoding)
	.uleb128 0xb	# (DW_FORM_data1)
	.uleb128 0x3	# (DW_AT_name)
	.uleb128 0x8	# (DW_FORM_string)
	.byte	0
	.byte	0
	.uleb128 0xc	# (abbrev code)
	.uleb128 0x35	# (TAG: DW_TAG_volatile_type)
	.byte	0	# DW_children_no
	.uleb128 0x49	# (DW_AT_type)
	.uleb128 0x13	# (DW_FORM_ref4)
	.byte	0
	.byte	0
	.uleb128 0xd	# (abbrev code)
	.uleb128 0xf	# (TAG: DW_TAG_pointer_type)
	.byte	0	# DW_children_no
	.uleb128 0xb	# (DW_AT_byte_size)
	.uleb128 0xb	# (DW_FORM_data1)
	.uleb128 0x49	# (DW_AT_type)
	.uleb128 0x13	# (DW_FORM_ref4)
	.byte	0
	.byte	0
	.uleb128 0xe	# (abbrev code)
	.uleb128 0x24	# (TAG: DW_TAG_base_type)
	.byte	0	# DW_children_no
	.uleb128 0xb	# (DW_AT_byte_size)
	.uleb128 0xb	# (DW_FORM_data1)
	.uleb128 0x3e	# (DW_AT_encoding)
	.uleb128 0xb	# (DW_FORM_data1)
	.uleb128 0x3	# (DW_AT_name)
	.uleb128 0xe	# (DW_FORM_strp)
	.byte	0
	.byte	0
	.uleb128 0xf	# (abbrev code)
	.uleb128 0x2e	# (TAG: DW_TAG_subprogram)
	.byte	0x1	# DW_children_yes
	.uleb128 0x3f	# (DW_AT_external)
	.uleb128 0x19	# (DW_FORM_flag_present)
	.uleb128 0x3	# (DW_AT_name)
	.uleb128 0xe	# (DW_FORM_strp)
	.uleb128 0x3a	# (DW_AT_decl_file)
	.uleb128 0xb	# (DW_FORM_data1)
	.uleb128 0x3b	# (DW_AT_decl_line)
	.uleb128 0xb	# (DW_FORM_data1)
	.uleb128 0x27	# (DW_AT_prototyped)
	.uleb128 0x19	# (DW_FORM_flag_present)
	.uleb128 0x49	# (DW_AT_type)
	.uleb128 0x13	# (DW_FORM_ref4)
	.uleb128 0x20	# (DW_AT_inline)
	.uleb128 0xb	# (DW_FORM_data1)
	.uleb128 0x1	# (DW_AT_sibling)
	.uleb128 0x13	# (DW_FORM_ref4)
	.byte	0
	.byte	0
	.uleb128 0x10	# (abbrev code)
	.uleb128 0x5	# (TAG: DW_TAG_formal_parameter)
	.byte	0	# DW_children_no
	.uleb128 0x3	# (DW_AT_name)
	.uleb128 0x8	# (DW_FORM_string)
	.uleb128 0x3a	# (DW_AT_decl_file)
	.uleb128 0xb	# (DW_FORM_data1)
	.uleb128 0x3b	# (DW_AT_decl_line)
	.uleb128 0xb	# (DW_FORM_data1)
	.uleb128 0x49	# (DW_AT_type)
	.uleb128 0x13	# (DW_FORM_ref4)
	.byte	0
	.byte	0
	.uleb128 0x11	# (abbrev code)
	.uleb128 0x2e	# (TAG: DW_TAG_subprogram)
	.byte	0x1	# DW_children_yes
	.uleb128 0x3	# (DW_AT_name)
	.uleb128 0xe	# (DW_FORM_strp)
	.uleb128 0x3a	# (DW_AT_decl_file)
	.uleb128 0xb	# (DW_FORM_data1)
	.uleb128 0x3b	# (DW_AT_decl_line)
	.uleb128 0xb	# (DW_FORM_data1)
	.uleb128 0x27	# (DW_AT_prototyped)
	.uleb128 0x19	# (DW_FORM_flag_present)
	.uleb128 0x49	# (DW_AT_type)
	.uleb128 0x13	# (DW_FORM_ref4)
	.uleb128 0x20	# (DW_AT_inline)
	.uleb128 0xb	# (DW_FORM_data1)
	.uleb128 0x1	# (DW_AT_sibling)
	.uleb128 0x13	# (DW_FORM_ref4)
	.byte	0
	.byte	0
	.uleb128 0x12	# (abbrev code)
	.uleb128 0x34	# (TAG: DW_TAG_variable)
	.byte	0	# DW_children_no
	.uleb128 0x3	# (DW_AT_name)
	.uleb128 0x8	# (DW_FORM_string)
	.uleb128 0x3a	# (DW_AT_decl_file)
	.uleb128 0xb	# (DW_FORM_data1)
	.uleb128 0x3b	# (DW_AT_decl_line)
	.uleb128 0xb	# (DW_FORM_data1)
	.uleb128 0x49	# (DW_AT_type)
	.uleb128 0x13	# (DW_FORM_ref4)
	.byte	0
	.byte	0
	.uleb128 0x13	# (abbrev code)
	.uleb128 0x2e	# (TAG: DW_TAG_subprogram)
	.byte	0x1	# DW_children_yes
	.uleb128 0x31	# (DW_AT_abstract_origin)
	.uleb128 0x13	# (DW_FORM_ref4)
	.uleb128 0x11	# (DW_AT_low_pc)
	.uleb128 0x1	# (DW_FORM_addr)
	.uleb128 0x12	# (DW_AT_high_pc)
	.uleb128 0x7	# (DW_FORM_data8)
	.uleb128 0x40	# (DW_AT_frame_base)
	.uleb128 0x18	# (DW_FORM_exprloc)
	.uleb128 0x2117	# (DW_AT_GNU_all_call_sites)
	.uleb128 0x19	# (DW_FORM_flag_present)
	.uleb128 0x1	# (DW_AT_sibling)
	.uleb128 0x13	# (DW_FORM_ref4)
	.byte	0
	.byte	0
	.uleb128 0x14	# (abbrev code)
	.uleb128 0x5	# (TAG: DW_TAG_formal_parameter)
	.byte	0	# DW_children_no
	.uleb128 0x31	# (DW_AT_abstract_origin)
	.uleb128 0x13	# (DW_FORM_ref4)
	.uleb128 0x2	# (DW_AT_location)
	.uleb128 0x18	# (DW_FORM_exprloc)
	.byte	0
	.byte	0
	.uleb128 0x15	# (abbrev code)
	.uleb128 0x34	# (TAG: DW_TAG_variable)
	.byte	0	# DW_children_no
	.uleb128 0x31	# (DW_AT_abstract_origin)
	.uleb128 0x13	# (DW_FORM_ref4)
	.uleb128 0x1c	# (DW_AT_const_value)
	.uleb128 0xb	# (DW_FORM_data1)
	.byte	0
	.byte	0
	.uleb128 0x16	# (abbrev code)
	.uleb128 0x2e	# (TAG: DW_TAG_subprogram)
	.byte	0x1	# DW_children_yes
	.uleb128 0x31	# (DW_AT_abstract_origin)
	.uleb128 0x13	# (DW_FORM_ref4)
	.uleb128 0x11	# (DW_AT_low_pc)
	.uleb128 0x1	# (DW_FORM_addr)
	.uleb128 0x12	# (DW_AT_high_pc)
	.uleb128 0x7	# (DW_FORM_data8)
	.uleb128 0x40	# (DW_AT_frame_base)
	.uleb128 0x18	# (DW_FORM_exprloc)
	.uleb128 0x2117	# (DW_AT_GNU_all_call_sites)
	.uleb128 0x19	# (DW_FORM_flag_present)
	.byte	0
	.byte	0
	.byte	0
	.section	.debug_loc,"",@progbits
.Ldebug_loc0:
.LLST4:
	.quad	.LVL12	# Location list begin address (*.LLST4)
	.quad	.LVL13	# Location list end address (*.LLST4)
	.value	0x1	# Location expression size
	.byte	0x50	# DW_OP_reg0
	.quad	0	# Location list terminator begin (*.LLST4)
	.quad	0	# Location list terminator end (*.LLST4)
.LLST5:
	.quad	.LVL14	# Location list begin address (*.LLST5)
	.quad	.LVL15	# Location list end address (*.LLST5)
	.value	0x1	# Location expression size
	.byte	0x51	# DW_OP_reg1
	.quad	0	# Location list terminator begin (*.LLST5)
	.quad	0	# Location list terminator end (*.LLST5)
.LLST6:
	.quad	.LVL16	# Location list begin address (*.LLST6)
	.quad	.LVL17	# Location list end address (*.LLST6)
	.value	0x1	# Location expression size
	.byte	0x50	# DW_OP_reg0
	.quad	0	# Location list terminator begin (*.LLST6)
	.quad	0	# Location list terminator end (*.LLST6)
.LLST7:
	.quad	.LVL16	# Location list begin address (*.LLST7)
	.quad	.LVL17	# Location list end address (*.LLST7)
	.value	0x5	# Location expression size
	.byte	0x70	# DW_OP_breg0
	.sleb128 0
	.byte	0x47	# DW_OP_lit23
	.byte	0x1e	# DW_OP_mul
	.byte	0x9f	# DW_OP_stack_value
	.quad	.LVL17	# Location list begin address (*.LLST7)
	.quad	.LVL18	# Location list end address (*.LLST7)
	.value	0x1	# Location expression size
	.byte	0x50	# DW_OP_reg0
	.quad	0	# Location list terminator begin (*.LLST7)
	.quad	0	# Location list terminator end (*.LLST7)
.LLST8:
	.quad	.LVL19	# Location list begin address (*.LLST8)
	.quad	.LVL20	# Location list end address (*.LLST8)
	.value	0x1	# Location expression size
	.byte	0x51	# DW_OP_reg1
	.quad	0	# Location list terminator begin (*.LLST8)
	.quad	0	# Location list terminator end (*.LLST8)
.LLST9:
	.quad	.LVL19	# Location list begin address (*.LLST9)
	.quad	.LVL20	# Location list end address (*.LLST9)
	.value	0x5	# Location expression size
	.byte	0x71	# DW_OP_breg1
	.sleb128 0
	.byte	0x41	# DW_OP_lit17
	.byte	0x1e	# DW_OP_mul
	.byte	0x9f	# DW_OP_stack_value
	.quad	0	# Location list terminator begin (*.LLST9)
	.quad	0	# Location list terminator end (*.LLST9)
.LLST10:
	.quad	.LVL21	# Location list begin address (*.LLST10)
	.quad	.LVL22	# Location list end address (*.LLST10)
	.value	0x1	# Location expression size
	.byte	0x50	# DW_OP_reg0
	.quad	0	# Location list terminator begin (*.LLST10)
	.quad	0	# Location list terminator end (*.LLST10)
.LLST11:
	.quad	.LVL21	# Location list begin address (*.LLST11)
	.quad	.LVL22	# Location list end address (*.LLST11)
	.value	0x5	# Location expression size
	.byte	0x70	# DW_OP_breg0
	.sleb128 0
	.byte	0x47	# DW_OP_lit23
	.byte	0x1e	# DW_OP_mul
	.byte	0x9f	# DW_OP_stack_value
	.quad	.LVL22	# Location list begin address (*.LLST11)
	.quad	.LVL23	# Location list end address (*.LLST11)
	.value	0x1	# Location expression size
	.byte	0x50	# DW_OP_reg0
	.quad	0	# Location list terminator begin (*.LLST11)
	.quad	0	# Location list terminator end (*.LLST11)
.LLST12:
	.quad	.LVL24	# Location list begin address (*.LLST12)
	.quad	.LVL25	# Location list end address (*.LLST12)
	.value	0x1	# Location expression size
	.byte	0x51	# DW_OP_reg1
	.quad	0	# Location list terminator begin (*.LLST12)
	.quad	0	# Location list terminator end (*.LLST12)
.LLST13:
	.quad	.LVL24	# Location list begin address (*.LLST13)
	.quad	.LVL25	# Location list end address (*.LLST13)
	.value	0x5	# Location expression size
	.byte	0x71	# DW_OP_breg1
	.sleb128 0
	.byte	0x41	# DW_OP_lit17
	.byte	0x1e	# DW_OP_mul
	.byte	0x9f	# DW_OP_stack_value
	.quad	0	# Location list terminator begin (*.LLST13)
	.quad	0	# Location list terminator end (*.LLST13)
.LLST14:
	.quad	.LVL26	# Location list begin address (*.LLST14)
	.quad	.LVL27	# Location list end address (*.LLST14)
	.value	0x1	# Location expression size
	.byte	0x50	# DW_OP_reg0
	.quad	0	# Location list terminator begin (*.LLST14)
	.quad	0	# Location list terminator end (*.LLST14)
.LLST15:
	.quad	.LVL26	# Location list begin address (*.LLST15)
	.quad	.LVL27	# Location list end address (*.LLST15)
	.value	0x5	# Location expression size
	.byte	0x70	# DW_OP_breg0
	.sleb128 0
	.byte	0x4d	# DW_OP_lit29
	.byte	0x1e	# DW_OP_mul
	.byte	0x9f	# DW_OP_stack_value
	.quad	.LVL27	# Location list begin address (*.LLST15)
	.quad	.LVL28	# Location list end address (*.LLST15)
	.value	0x1	# Location expression size
	.byte	0x50	# DW_OP_reg0
	.quad	0	# Location list terminator begin (*.LLST15)
	.quad	0	# Location list terminator end (*.LLST15)
.LLST16:
	.quad	.LVL30	# Location list begin address (*.LLST16)
	.quad	.LVL31	# Location list end address (*.LLST16)
	.value	0x1	# Location expression size
	.byte	0x50	# DW_OP_reg0
	.quad	0	# Location list terminator begin (*.LLST16)
	.quad	0	# Location list terminator end (*.LLST16)
.LLST0:
	.quad	.LVL1	# Location list begin address (*.LLST0)
	.quad	.LVL2	# Location list end address (*.LLST0)
	.value	0x1	# Location expression size
	.byte	0x55	# DW_OP_reg5
	.quad	.LVL2	# Location list begin address (*.LLST0)
	.quad	.LFE5	# Location list end address (*.LLST0)
	.value	0x4	# Location expression size
	.byte	0xf3	# DW_OP_GNU_entry_value
	.uleb128 0x1
	.byte	0x55	# DW_OP_reg5
	.byte	0x9f	# DW_OP_stack_value
	.quad	0	# Location list terminator begin (*.LLST0)
	.quad	0	# Location list terminator end (*.LLST0)
.LLST1:
	.quad	.LVL1	# Location list begin address (*.LLST1)
	.quad	.LVL2	# Location list end address (*.LLST1)
	.value	0x5	# Location expression size
	.byte	0x75	# DW_OP_breg5
	.sleb128 0
	.byte	0x41	# DW_OP_lit17
	.byte	0x1e	# DW_OP_mul
	.byte	0x9f	# DW_OP_stack_value
	.quad	.LVL2	# Location list begin address (*.LLST1)
	.quad	.LFE5	# Location list end address (*.LLST1)
	.value	0x6	# Location expression size
	.byte	0xf3	# DW_OP_GNU_entry_value
	.uleb128 0x1
	.byte	0x55	# DW_OP_reg5
	.byte	0x41	# DW_OP_lit17
	.byte	0x1e	# DW_OP_mul
	.byte	0x9f	# DW_OP_stack_value
	.quad	0	# Location list terminator begin (*.LLST1)
	.quad	0	# Location list terminator end (*.LLST1)
.LLST2:
	.quad	.LVL5	# Location list begin address (*.LLST2)
	.quad	.LVL6	# Location list end address (*.LLST2)
	.value	0x1	# Location expression size
	.byte	0x55	# DW_OP_reg5
	.quad	.LVL6	# Location list begin address (*.LLST2)
	.quad	.LFE9	# Location list end address (*.LLST2)
	.value	0x4	# Location expression size
	.byte	0xf3	# DW_OP_GNU_entry_value
	.uleb128 0x1
	.byte	0x55	# DW_OP_reg5
	.byte	0x9f	# DW_OP_stack_value
	.quad	0	# Location list terminator begin (*.LLST2)
	.quad	0	# Location list terminator end (*.LLST2)
.LLST3:
	.quad	.LVL5	# Location list begin address (*.LLST3)
	.quad	.LVL6	# Location list end address (*.LLST3)
	.value	0x5	# Location expression size
	.byte	0x75	# DW_OP_breg5
	.sleb128 0
	.byte	0x41	# DW_OP_lit17
	.byte	0x1e	# DW_OP_mul
	.byte	0x9f	# DW_OP_stack_value
	.quad	.LVL6	# Location list begin address (*.LLST3)
	.quad	.LFE9	# Location list end address (*.LLST3)
	.value	0x6	# Location expression size
	.byte	0xf3	# DW_OP_GNU_entry_value
	.uleb128 0x1
	.byte	0x55	# DW_OP_reg5
	.byte	0x41	# DW_OP_lit17
	.byte	0x1e	# DW_OP_mul
	.byte	0x9f	# DW_OP_stack_value
	.quad	0	# Location list terminator begin (*.LLST3)
	.quad	0	# Location list terminator end (*.LLST3)
	.section	.debug_aranges,"",@progbits
	.long	0x3c	# Length of Address Ranges Info
	.value	0x2	# DWARF Version
	.long	.Ldebug_info0	# Offset of Compilation Unit Info
	.byte	0x8	# Size of Address
	.byte	0	# Size of Segment Descriptor
	.value	0	# Pad to 16 byte boundary
	.value	0
	.quad	.Ltext0	# Address
	.quad	.Letext0-.Ltext0	# Length
	.quad	.LFB23	# Address
	.quad	.LFE23-.LFB23	# Length
	.quad	0
	.quad	0
	.section	.debug_ranges,"",@progbits
.Ldebug_ranges0:
	.quad	.LBB170	# Offset 0
	.quad	.LBE170
	.quad	.LBB184
	.quad	.LBE184
	.quad	.LBB186
	.quad	.LBE186
	.quad	0
	.quad	0
	.quad	.LBB172	# Offset 0x40
	.quad	.LBE172
	.quad	.LBB176
	.quad	.LBE176
	.quad	.LBB177
	.quad	.LBE177
	.quad	0
	.quad	0
	.quad	.LBB180	# Offset 0x80
	.quad	.LBE180
	.quad	.LBB185
	.quad	.LBE185
	.quad	.LBB187
	.quad	.LBE187
	.quad	0
	.quad	0
	.quad	.LBB188	# Offset 0xc0
	.quad	.LBE188
	.quad	.LBB195
	.quad	.LBE195
	.quad	0
	.quad	0
	.quad	.LBB190	# Offset 0xf0
	.quad	.LBE190
	.quad	.LBB193
	.quad	.LBE193
	.quad	0
	.quad	0
	.quad	.Ltext0	# Offset 0x120
	.quad	.Letext0
	.quad	.LFB23	# Offset 0x130
	.quad	.LFE23
	.quad	0
	.quad	0
	.section	.debug_line,"",@progbits
.Ldebug_line0:
	.section	.debug_str,"MS",@progbits,1
.LASF7:
	.string	"func_extern_caller"
.LASF26:
	.string	"GNU C11 7.5.0 -mtune=generic -march=x86-64 -g -O2 -fstack-protector-strong"
.LASF22:
	.string	"func3a"
.LASF23:
	.string	"func3b"
.LASF15:
	.string	"func7b"
.LASF27:
	.string	"../gdb.opt/inline-break.c"
.LASF24:
	.string	"func2"
.LASF10:
	.string	"not_inline_func1"
.LASF8:
	.string	"not_inline_func2"
.LASF5:
	.string	"not_inline_func3"
.LASF20:
	.string	"func4a"
.LASF21:
	.string	"func4b"
.LASF18:
	.string	"func5a"
.LASF19:
	.string	"func5b"
.LASF29:
	.string	"main"
.LASF16:
	.string	"func6a"
.LASF17:
	.string	"func6b"
.LASF14:
	.string	"func7a"
.LASF0:
	.string	"argc"
.LASF4:
	.string	"func_inline_callee"
.LASF12:
	.string	"func8a"
.LASF13:
	.string	"func8b"
.LASF1:
	.string	"argv"
.LASF11:
	.string	"inline_func1"
.LASF9:
	.string	"inline_func2"
.LASF6:
	.string	"inline_func3"
.LASF25:
	.string	"func1"
.LASF3:
	.string	"func_inline_caller"
.LASF2:
	.string	"char"
.LASF28:
	.string	"/home/jozef/msp430/msp430-gnu/gdb.subtree/gdb/testsuite/gdb.dwarf2"
	.ident	"GCC: (Ubuntu 7.5.0-3ubuntu1~18.04) 7.5.0"
	.section	.note.GNU-stack,"",@progbits
