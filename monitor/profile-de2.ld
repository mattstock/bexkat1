/* Custom linker script for ROM applications */
OUTPUT_FORMAT("elf32-bexkat1-be", "elf32-bexkat1-be",
	      "elf32-bexkat1-le")
OUTPUT_ARCH(bexkat1)
STARTUP(boot-de2.o)
ENTRY(_start)

MEMORY
{
  rom : ORIGIN = 0x70000000, LENGTH = 128K
  ram : ORIGIN = 0x07ff0000, LENGTH = 64K
}

SECTIONS
{
  .text :
    {
      boot-de2.o
      *(.text.unlikely .text.*_unlikely .text.unlikely.*)
      *(.text.exit .text.exit.*)
      *(.text.startup .text.startup.*)
      *(.text.hot .text.hot.*)
      *(.text .stub .text.* .gnu.linkonce.t.*)
      *(.gnu.warning)
      . = ALIGN(0x4);
    } > rom
  .init :
    {
      KEEP (*(SORT_NONE(.init)))
    } > rom
  .fini :
    {
      KEEP (*(SORT_NONE(.fini)))
    } > rom
  . = ALIGN(0x4);
  PROVIDE (__etext = .);
  PROVIDE (_etext = .);
  PROVIDE (etext = .);
  .sdata2         :
  {
    *(.sdata2 .sdata2.* .gnu.linkonce.s2.*)
  } > rom
  .eh_frame_hdr : { *(.eh_frame_hdr) *(.eh_frame_entry .eh_frame_entry.*) } > rom
  .eh_frame       : ONLY_IF_RO { KEEP (*(.eh_frame)) *(.eh_frame.*) } > rom
  .jcr            : { KEEP (*(.jcr)) } > rom
  .rodata :
    { 
      _rodata = . ;
      *(.rodata .rodata.* .gnu.linkonce.r.*)
      _erodata = . ;
    } > rom
  . = ALIGN(0x4);

  .ctors          :
  {
    _data_start = .;
    /* gcc uses crtbegin.o to find the start of
       the constructors, so we make sure it is
       first.  Because this is a wildcard, it
       doesn't matter if the user does not
       actually link against crtbegin.o; the
       linker won't look for a file to match a
       wildcard.  The wildcard also means that it
       doesn't matter which directory crtbegin.o
       is in.  */
    KEEP (*crtbegin.o(.ctors))
    KEEP (*crtbegin?.o(.ctors))
    /* We don't want to include the .ctor section from
       the crtend.o file until after the sorted ctors.
       The .ctor section from the crtend file contains the
       end of ctors marker and it must be last */
    KEEP (*(EXCLUDE_FILE (*crtend.o *crtend?.o ) .ctors))
    KEEP (*(SORT(.ctors.*)))
    KEEP (*(.ctors))
  } > ram AT > rom
  .dtors          :
  {
    KEEP (*crtbegin.o(.dtors))
    KEEP (*crtbegin?.o(.dtors))
    KEEP (*(EXCLUDE_FILE (*crtend.o *crtend?.o ) .dtors))
    KEEP (*(SORT(.dtors.*)))
    KEEP (*(.dtors))
  } > ram AT > rom
  /* Exception handling  */
  .eh_frame : ONLY_IF_RW { KEEP (*(.eh_frame)) *(.eh_frame.*) } > ram AT > rom
  .eh_frame : ONLY_IF_RO { KEEP (*(.eh_frame)) *(.eh_frame.*) } > rom
  .data :
    { 
      _data = . ;
      *(.data)
      . = ALIGN(0x4);
      _edata = . ;
    } > ram AT > rom
  .bss :
    {
      __bss_start = .;
      _bstart = .;
      *(.bss)
      _bend = .;
      _end = .; PROVIDE (end = .);
    } > ram
}
