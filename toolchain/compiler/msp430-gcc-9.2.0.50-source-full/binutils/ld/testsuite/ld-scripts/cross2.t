NOCROSSREFS ( .text .data )
SECTIONS
{
  .text : { *(.text) *(.text.*) *(.pr) *(.opd) *(*.text) *(*.text.*) }
  .data : { *(.data) *(.data.*) *(.sdata) *(.rw) *(.tc0) *(.tc) *(.toc) *(*.data) *(*.data.*) }
}
