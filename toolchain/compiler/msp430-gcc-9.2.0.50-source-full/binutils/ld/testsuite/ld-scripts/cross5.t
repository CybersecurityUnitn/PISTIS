NOCROSSREFS_TO(.nocrossrefs .data)

SECTIONS
{
  .text : { *(.text) *(.text.*) *(*.text) *(*.text.*) }
  .nocrossrefs : { *(.nocrossrefs) }
  .data : { *(.data) *(.data.*) *(.sdata) *(.opd) *(.toc) *(*.data) *(*.data.*) }
  .bss : { *(.bss) *(COMMON) }
  /DISCARD/ : { *(*) }
}
