OUTPUT_ARCH(msp430)
ENTRY(_start)

MEMORY
{
  FRAM (rwx)   : ORIGIN = 0x00500, LENGTH = 0x0ea00
  HIFRAM (rwx) : ORIGIN = 0x10000, LENGTH = 0x80000
}

SECTIONS
{
  .data :
  {
    . = ALIGN(2);
    PROVIDE (__datastart = .);
    *(.lower.data .lower.data.*)
    . = ALIGN(2);
    *(.data .data.*)
    . = ALIGN(2);
    _edata = .;
    PROVIDE (edata = .);
    PROVIDE (__dataend = .);
  } > FRAM

  .rodata 0x3000 :
  {
    . = ALIGN(2);
    *(.lower.rodata .lower.rodata.*)
    . = ALIGN(2);
    *(.rodata .rodata.*)
  } > FRAM

  .text 0x4000 :
  {
    . = ALIGN(2);
    PROVIDE (_start = .);

    . = ALIGN(2);
    KEEP (*(SORT(.crt_*)))

    . = ALIGN(2);
    *(.lower.text .lower.text.*)
    . = ALIGN(2);
    *(.text .text.*)
  } > FRAM

  .bss 0x1000 :
  {
    . = ALIGN(2);
    PROVIDE (__bssstart = .);
    *(.lower.bss .lower.bss.*)
    . = ALIGN(2);
    *(.bss .bss.*)
    PROVIDE (__bssend = .);
    PROVIDE (end = .);
  } > FRAM

  .stack (ORIGIN (FRAM) + LENGTH (FRAM)) :
  {
    PROVIDE (__stack = .);
  }

  PROVIDE (__bsssize = SIZEOF(.bss));
  __romdatastart = LOADADDR(.data);
  __romdatacopysize = SIZEOF(.data);

  .upper.text :
  {
    *(.upper.text .upper.text.*)
  } > HIFRAM

  .upper.data :
  {
    *(.upper.data .upper.data.*)
  } > HIFRAM

  .upper.rodata :
  {
    *(.upper.rodata .upper.rodata.*)
  } > HIFRAM

  .upper.bss :
  {
    *(.upper.bss .upper.bss.*)
  } > HIFRAM

  /* Stabs debugging sections.  */
  .stab          0 : { *(.stab) }
  .stabstr       0 : { *(.stabstr) }
  .stab.excl     0 : { *(.stab.excl) }
  .stab.exclstr  0 : { *(.stab.exclstr) }
  .stab.index    0 : { *(.stab.index) }
  .stab.indexstr 0 : { *(.stab.indexstr) }
  .comment       0 : { *(.comment) }
  /* DWARF debug sections.
     Symbols in the DWARF debugging sections are relative to the beginning
     of the section so we begin them at 0.  */
  /* DWARF 1.  */
  .debug          0 : { *(.debug) }
  .line           0 : { *(.line) }
  /* GNU DWARF 1 extensions.  */
  .debug_srcinfo  0 : { *(.debug_srcinfo) }
  .debug_sfnames  0 : { *(.debug_sfnames) }
  /* DWARF 1.1 and DWARF 2.  */
  .debug_aranges  0 : { *(.debug_aranges) }
  .debug_pubnames 0 : { *(.debug_pubnames) }
  /* DWARF 2.  */
  .debug_info     0 : { *(.debug_info .gnu.linkonce.wi.*) }
  .debug_abbrev   0 : { *(.debug_abbrev) }
  .debug_line     0 : { *(.debug_line .debug_line.* .debug_line_end ) }
  .debug_frame    0 : { *(.debug_frame) }
  .debug_str      0 : { *(.debug_str) }
  .debug_loc      0 : { *(.debug_loc) }
  .debug_macinfo  0 : { *(.debug_macinfo) }
  /* SGI/MIPS DWARF 2 extensions.  */
  .debug_weaknames 0 : { *(.debug_weaknames) }
  .debug_funcnames 0 : { *(.debug_funcnames) }
  .debug_typenames 0 : { *(.debug_typenames) }
  .debug_varnames  0 : { *(.debug_varnames) }
  /* DWARF 3 */
  .debug_pubtypes 0 : { *(.debug_pubtypes) }
  .debug_ranges   0 : { *(.debug_ranges) }
  /* DWARF Extension.  */
  .debug_macro    0 : { *(.debug_macro) }
}
