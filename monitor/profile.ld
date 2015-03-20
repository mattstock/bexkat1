MEMORY
{
  rom  : ORIGIN = 0xffffc000, LENGTH = 16K
  ram : ORIGIN = 0x00000000, LENGTH = 16K
}

ENTRY(_start)
SECTIONS
{
  .text : AT (0x0000)
    { 
      *(.text)
      _etext = . ;
    } > rom
  .data : AT ( LOADADDR(.text) + SIZEOF(.text))
    { 
      _data = . ;
      *(.data)
      _edata = . ;
    } > ram
  .bss :
    { 
      _bstart = . ;
      *(.bss)
      _bend = . ;
    } > ram
}
