MEMORY
{
  rom      (rx)  : ORIGIN = 0x20038000, LENGTH = 0x0003000
  ram      (rwx) : ORIGIN = 0x2003c000, LENGTH = 0x0002000
}

/* Section Definitions */
SECTIONS
{
    .text :
    {
       /*  KEEP(*(.vectors .vectors.*)) */
        *(.text*)
        *(.rodata*)
    } > rom

    _debutRomData = . ;
    .data :
    {
      _debutRamData = . ;
        *(.data*);
    } > ram AT >rom
    
     /* .bss section which is used for uninitialized data */
     _debutRamBss = . ;
    .bss (NOLOAD) :
    {
        *(.bss*)
        *(COMMON)
    } > ram

 

    _end = . ;
}