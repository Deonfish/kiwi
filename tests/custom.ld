/* Linker script for custom memory layout */

OUTPUT_ARCH(riscv)
ENTRY(_start)

MEMORY
{
    FLASH (rx) : ORIGIN = 0x70000000, LENGTH = 0x1000000    /* 256KB for .text and .rodata */
    RAM (rw)  : ORIGIN = 0x71000000, LENGTH = 0x1000000 /* 256KB for .data, .bss, heap, stack */
}

SECTIONS
{
    __stack_size = DEFINED(__stack_size) ? __stack_size : 2K;
    /* .text segment at address 0x0 */
    .text : {
        KEEP(*(.text.init))
        KEEP(*(.text))
        KEEP(*(.text.startup))
    } > FLASH

    /* .rodata segment, after .text in FLASH */
    .rodata : {
        *(.rodata)
        *(.rodata.*)
    } > RAM

    /* .eh_frame section, needed for some GCC setups */
    .eh_frame : {
        KEEP(*(.eh_frame))
    } > RAM

    /* .data segment at address 0x20000000 */
    .data : {
        _sdata = .;
        KEEP(*(.data))
        KEEP(*(.data.*))
        _edata = .;
    } > RAM

    /* .bss segment follows .data segment */
    .bss : {
         __bss_start = .;
        _sbss = .;
        KEEP(*(.bss))
        KEEP(*(.bss.*))
        *(COMMON)
        _ebss = .;
        __bss_end = .;
    } > RAM

    .stack ORIGIN(RAM) + LENGTH(RAM) - __stack_size : {
        _heap_end = .;
        _stack_top = .;
        . = __stack_size;
        _sp = .;
    } > RAM
    
    /* Provide end symbol */
    _end = .;
    end = .;
}

/* Define symbols for stack and heap */
PROVIDE(__global_pointer$ = 0x71000000 + 0x800);
