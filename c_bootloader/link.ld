ENTRY(main);
SECTIONS
{
    . = 0x7C00;
    .text : AT(0x7C00)
    {
        *(.text);
    }
    .data : { *(.data); }
    .bss : { *(.bss); }
    .rodata : {*(.rodata);}
    .sig : AT(0x7DFE)
    {
        SHORT(0xAA55);
    }
} 
