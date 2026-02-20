INCLUDE "config/undefined_funcs_auto.txt";
INCLUDE "config/undefined_syms_auto.txt";
INCLUDE "config/symbol_addrs.txt";

SECTIONS
{
    __romPos = 0;
    _gp = cod_LIT4_START + 0x7FF0;
    cod_ROM_START = __romPos;
    cod_VRAM = ADDR(.cod);
    .cod 0x200000 : AT(cod_ROM_START)
    {
        FILL(0x00000000);
        cod_TEXT_START = .;
        build/asm/cod/000000.o(.text*);
        build/src/sceVif1Pk.o(.text*);
        build/asm/cod/0B57C.o(.text*);
        . = ALIGN(., 16);
        cod_TEXT_END = .;
        cod_TEXT_SIZE = ABSOLUTE(cod_TEXT_END - cod_TEXT_START);
    }
    .cod_data 0x338600 : AT(cod_ROM_START + 0x138600)
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
    }
    .cod_rodata 0x4BE280 : AT(cod_ROM_START + 0x2BE280)
    {
        cod_RODATA_START = .;
        build/asm/cod/000000.o(.rodata*);
        build/asm/data/cod/2BE280.rodata.o(.rodata*);
        . = ALIGN(., 16);
        cod_RODATA_END = .;
        cod_RODATA_SIZE = ABSOLUTE(cod_RODATA_END - cod_RODATA_START);
    }
    .cod_lit4 0x4D7B80 : AT(cod_ROM_START + 0x2D7B80)
    {
        cod_LIT4_START = .;
        build/asm/cod/000000.o(.lit4*);
        build/asm/data/cod/2D7B80.lit4.o(.lit4*);
        . = ALIGN(., 16);
        cod_LIT4_END = .;
        cod_LIT4_SIZE = ABSOLUTE(cod_LIT4_END - cod_LIT4_START);
    }
    .cod_sdata 0x4D8A00 : AT(cod_ROM_START + 0x2D8A00)
    {
        cod_SDATA_START = .;
        build/asm/cod/000000.o(.sdata*);
        build/asm/data/cod/2D8A00.sdata.o(.sdata*);
        . = ALIGN(., 16);
        cod_SDATA_END = .;
        cod_SDATA_SIZE = ABSOLUTE(cod_SDATA_END - cod_SDATA_START);
    }
    cod_bss_VRAM = ADDR(.cod_bss);
    .cod_bss 0x4DC500 (NOLOAD) :
    {
        FILL(0x00000000);
        cod_SBSS_START = .;
        build/asm/cod/000000.o(.sbss COMMON .scommon);
        build/asm/data/cod/004DC500.sbss.o(.sbss COMMON .scommon);
        . = ALIGN(., 16);
        cod_SBSS_END = .;
        cod_SBSS_SIZE = ABSOLUTE(cod_SBSS_END - cod_SBSS_START);
    }
    .cod_bss2 0x4DC880 (NOLOAD) :
    {
        cod_BSS_START = .;
        build/asm/cod/000000.o(.bss COMMON .scommon);
        build/asm/data/cod/004DC880.bss.o(.bss COMMON .scommon);
        . = ALIGN(., 16);
        cod_BSS_END = .;
        cod_BSS_SIZE = ABSOLUTE(cod_BSS_END - cod_BSS_START);
    }
    __romPos += SIZEOF(.cod) + SIZEOF(.cod_data) + SIZEOF(.cod_rodata) + SIZEOF(.cod_lit4) + SIZEOF(.cod_sdata);
    __romPos = ALIGN(__romPos, 16);
    . = ALIGN(., 16);
    cod_ROM_END = __romPos;
    cod_VRAM_END = .;

    ov02_ROM_START = __romPos;
    ov02_VRAM = ADDR(.ov02);
    .ov02 0xA00000 : AT(ov02_ROM_START)
    {
        FILL(0x00000000);
        ov02_TEXT_START = .;
        build/asm/ov02/2DD000.o(.text*);
        . = ALIGN(., 16);
        ov02_TEXT_END = .;
        ov02_TEXT_SIZE = ABSOLUTE(ov02_TEXT_END - ov02_TEXT_START);
        ov02_DATA_START = .;
        build/asm/ov02/2DD000.o(.data*);
        . = ALIGN(., 16);
        ov02_DATA_END = .;
        ov02_DATA_SIZE = ABSOLUTE(ov02_DATA_END - ov02_DATA_START);
        ov02_RODATA_START = .;
        build/asm/ov02/2DD000.o(.rodata*);
        . = ALIGN(., 16);
        ov02_RODATA_END = .;
        ov02_RODATA_SIZE = ABSOLUTE(ov02_RODATA_END - ov02_RODATA_START);
        ov02_LIT4_START = .;
        build/asm/ov02/2DD000.o(.lit4*);
        . = ALIGN(., 16);
        ov02_LIT4_END = .;
        ov02_LIT4_SIZE = ABSOLUTE(ov02_LIT4_END - ov02_LIT4_START);
        ov02_SDATA_START = .;
        build/asm/ov02/2DD000.o(.sdata*);
        . = ALIGN(., 16);
        ov02_SDATA_END = .;
        ov02_SDATA_SIZE = ABSOLUTE(ov02_SDATA_END - ov02_SDATA_START);
    }
    ov02_bss_VRAM = ADDR(.ov02_bss);
    .ov02_bss (NOLOAD) :
    {
        FILL(0x00000000);
        ov02_SBSS_START = .;
        build/asm/ov02/2DD000.o(.sbss COMMON .scommon);
        . = ALIGN(., 16);
        ov02_SBSS_END = .;
        ov02_SBSS_SIZE = ABSOLUTE(ov02_SBSS_END - ov02_SBSS_START);
        ov02_BSS_START = .;
        build/asm/ov02/2DD000.o(.bss COMMON .scommon);
        . = ALIGN(., 16);
        ov02_BSS_END = .;
        ov02_BSS_SIZE = ABSOLUTE(ov02_BSS_END - ov02_BSS_START);
    }
    __romPos += SIZEOF(.ov02);
    __romPos = ALIGN(__romPos, 16);
    . = ALIGN(., 16);
    ov02_ROM_END = __romPos;
    ov02_VRAM_END = .;

    /DISCARD/ :
    {
        *(*);
    }
}
