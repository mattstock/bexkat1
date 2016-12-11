MEMORY
{
  rom : ORIGIN = 0x70000000, LENGTH = 128K
  ram : ORIGIN = 0x03ff0000, LENGTH = 64K
}

STARTUP(boot-max10.o)
ENTRY(_start)
SECTIONS
{
  .text :
    { 
      *(.text)
      _etext = . ;
      . = ALIGN(0x4);
    } > rom
  .rodata :
    { 
      _rodata = . ;
      *(.rodata)
      . = ALIGN(0x4);
      _erodata = . ;
    } > rom
  .eh_frame_hdr : { *(.eh_frame_hdr) } 
  .data :
    { 
      _data = . ;
      *(.data)
      . = ALIGN(0x4);
      _edata = . ;
    } > ram AT>rom
  .eh_frame : { KEEP (*(.eh_frame)) } > ram AT>rom
  .bss :
    { 
      _bstart = . ;
      *(.bss)
      _bend = . ;
    } > ram
}
