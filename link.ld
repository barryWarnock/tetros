ENTRY(main);
SECTIONS
{
    . = 0x7C00;
    .text : AT(0x7C00)
    {
        *(.text);
	FILL(0x00);
    }
    .data : { *(.data); }
    .bss : { *(.bss); }
    .sig : AT(0x7DFE)
    {
        SHORT(0xaa55);
    }
} 
