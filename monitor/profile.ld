MEMORY
{
  rom : ORIGIN = 0xffff0000, LENGTH = 64K
  ram : ORIGIN = 0x00000000, LENGTH = 16K
}

STARTUP(boot.o)
ENTRY(_start)
SECTIONS
{
  .vectors 0xffffffc0 :
    {
      _vectors_addr = . ;
      KEEP(*(.vectors))
    }
  .text : AT (0x00000000)
    { 
      *(.text)
      _etext = . ;
      . = ALIGN(0x10);
    } > rom
  .rodata : AT ( LOADADDR(.text) + SIZEOF(.text))
    { 
      _rodata = . ;
      *(.rodata)
      . = ALIGN(0x10);
      _erodata = . ;
    } > rom
  .data : AT ( LOADADDR(.rodata) + SIZEOF(.rodata))
    { 
      _data = . ;
      *(.data)
      . = ALIGN(0x10);
      _edata = . ;
    } > ram
  .bss :
    { 
      _bstart = . ;
      *(.bss)
      _bend = . ;
    } > ram
}
