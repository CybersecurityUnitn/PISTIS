NOCROSSREFS_TO(.text .data)

SECTIONS
{
  .text : { *(.text) *(.text.*) *(.opd ) *(*.text) *(*.text.*) }
  .data : { *(.data) *(.data.*) *(.sdata) *(.toc) *(*.data) *(*.data.*) }
  .bss : { *(.bss) *(COMMON) }
  /DISCARD/ : { *(*) }
}
