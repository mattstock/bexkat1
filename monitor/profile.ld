MEMORY
{
  monitor  : ORIGIN = 0xffc00000, LENGTH = 4K
  flash : ORIGIN = 0xfe000000, LENGTH = 4M
  ram : ORIGIN = 0x00000000, LENGTH = 512K
}


SECTIONS
{
  .text : AT (0x0000)
    { 
      *(.text)
      _etext = . ;
    } > monitor
  .data : AT ( LOADADDR(.text) + SIZEOF(.text))
    { 
      *(.data)
    } > monitor
  .bss :
    { 
      *(.bss)
    } > ram
}
