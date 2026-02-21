INCLUDE "config/undefined_funcs_auto.txt";
INCLUDE "config/undefined_syms_auto.txt";
INCLUDE "config/symbol_addrs.txt";

ENTRY(ENTRYPOINT);

PHDRS
{
    text PT_LOAD FLAGS(5);   /* R E */
    data PT_LOAD FLAGS(6);   /* RW  */
    ov02 PT_LOAD FLAGS(7);   /* RWE */
}

SECTIONS
{
    __romPos = 0;

    /* .text segment */
    .text 0x200000 : AT(0x200000)
    {
        FILL(0x00000000);
        cod_TEXT_START = .;
        build/asm/cod/000000.o(.text*);
        build/src/sceVif1Pk.o(.text*);
        build/asm/cod/0B57C.o(.text*);
        . = ALIGN(., 16);
        cod_TEXT_END = .;
        cod_TEXT_SIZE = ABSOLUTE(cod_TEXT_END - cod_TEXT_START);
    } :text

    _gp = 0x4D7B80 + 0x7FF0;

    /* .data segment - all in one LOAD segment */
    .data 0x338600 : AT(0x338600)
    {
        cod_DATA_START = .;
        build/asm/cod/000000.o(.data*);
        build/asm/data/cod/138600.data.o(.data*);
        build/asm/data/cod/2ADE54.data.o(.data*);
        build/asm/data/cod/2ADE5C.data.o(.data*);
        build/asm/data/cod/2ADE68.data.o(.data*);
        build/asm/data/cod/2ADE70.o(.data*);
        . = ALIGN(., 16);
        cod_DATA_END = .;
        cod_DATA_SIZE = ABSOLUTE(cod_DATA_END - cod_DATA_START);
    } :data

    .rodata 0x4BE280 : AT(0x4BE280)
    {
        cod_RODATA_START = .;
        build/asm/cod/000000.o(.rodata*);
        build/asm/data/cod/2BE280.rodata.o(.rodata*);
        . = ALIGN(., 16);
        cod_RODATA_END = .;
        cod_RODATA_SIZE = ABSOLUTE(cod_RODATA_END - cod_RODATA_START);
    } :data

    .lit4 0x4D7B80 : AT(0x4D7B80)
    {
        cod_LIT4_START = .;
        build/asm/cod/000000.o(.lit4*);
        build/asm/data/cod/2D7B80.lit4.o(.lit4*);
        . = ALIGN(., 16);
        cod_LIT4_END = .;
        cod_LIT4_SIZE = ABSOLUTE(cod_LIT4_END - cod_LIT4_START);
    } :data

    .sdata 0x4D8A00 : AT(0x4D8A00)
    {
        cod_SDATA_START = .;
        build/asm/cod/000000.o(.sdata*);
        build/asm/data/cod/2D8A00.sdata.o(.sdata*);
        . = ALIGN(., 16);
        cod_SDATA_END = .;
        cod_SDATA_SIZE = ABSOLUTE(cod_SDATA_END - cod_SDATA_START);
    } :data

    .sbss 0x4DC500 (NOLOAD) :
    {
        cod_SBSS_START = .;
        build/asm/cod/000000.o(.sbss COMMON .scommon);
        build/asm/data/cod/004DC500.sbss.o(.sbss COMMON .scommon);
        . = ALIGN(., 16);
        cod_SBSS_END = .;
        cod_SBSS_SIZE = ABSOLUTE(cod_SBSS_END - cod_SBSS_START);
    } :data

    .bss 0x4DC880 (NOLOAD) :
    {
        cod_BSS_START = .;
        build/asm/cod/000000.o(.bss COMMON .scommon);
        build/asm/data/cod/004DC880.bss.o(.bss COMMON .scommon);
        . = ALIGN(., 16);
        cod_BSS_END = .;
        cod_BSS_SIZE = ABSOLUTE(cod_BSS_END - cod_BSS_START);
    } :data

    /* ov02 segment */
    .ov02 0xA00000 : AT(0xA00000)
    {
        FILL(0x00000000);
        ov02_TEXT_START = .;
        build/asm/ov02/2DD000.o(.text*);
        . = ALIGN(., 16);
        ov02_TEXT_END = .;
        ov02_DATA_START = .;
        build/asm/ov02/2DD000.o(.data*);
        . = ALIGN(., 16);
        ov02_DATA_END = .;
        ov02_RODATA_START = .;
        build/asm/ov02/2DD000.o(.rodata*);
        . = ALIGN(., 16);
        ov02_RODATA_END = .;
        ov02_LIT4_START = .;
        build/asm/ov02/2DD000.o(.lit4*);
        . = ALIGN(., 16);
        ov02_LIT4_END = .;
        ov02_SDATA_START = .;
        build/asm/ov02/2DD000.o(.sdata*);
        . = ALIGN(., 16);
        ov02_SDATA_END = .;
    } :ov02

    /DISCARD/ :
    {
        *(*);
    }
}
