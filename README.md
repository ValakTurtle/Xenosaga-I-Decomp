# Xenosaga Episode I Decompilation

A work-in-progress decompilation of **Xenosaga Episode I: Der Wille zur Macht** (PS2, NTSC-U).

**Target:** `SLUS_204.69` (SHA1: `fd206d5715a322830f7fa9285fb4a09276ac2a63`)

## Status

The project currently has a **byte-matching build** of the full executable, with all code and data split into individual assembly files. 7,758 symbols have been extracted from the original ELF's symbol table, providing real function and data names throughout the disassembly.

Decompilation (replacing assembly with C) has not yet begun.

## Prerequisites

- **WSL2 / Ubuntu 24** (or native Linux)
- **Python 3.12+** with `venv`
- **ninja-build**
- **ps2dev binutils** (provides `mips64r5900el-ps2-elf-as` and `mips64r5900el-ps2-elf-ld`)
- A legally obtained copy of the game

### Installing ps2dev binutils

```bash
sudo apt-get install -y build-essential bison flex texinfo
git clone --depth 1 https://github.com/ps2dev/binutils-gdb.git /tmp/binutils-gdb
cd /tmp/binutils-gdb && mkdir build && cd build
../configure --target=mips64r5900el-ps2-elf --prefix=/usr/local/ps2dev/ee --disable-gdb --disable-nls --disable-werror
make -j$(nproc)
sudo make install
```

### Python setup

```bash
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

## Building

Place the original ELF at `iso/SLUS_204.69`, then:

```bash
source venv/bin/activate
python3 -m splat split config/SLUS_204.69.yaml
bash tools/post_split.sh
python3 configure.py
ninja
```

The built ELF will be at `build/SLUS_204.69.elf`.

### After modifying Splat config

Whenever you re-run `splat split`, you must also re-run `tools/post_split.sh` before building. This script:

1. Copies the pinned linker script over Splat's auto-generated one
2. Strips `//` comments from `symbol_addrs.txt` (linker can't parse them)
3. Runs `fix_asm.py` to patch R5900 instruction encoding issues

## Project Structure

```
├── asm/                    # Disassembled code and data
│   ├── cod/000000.s        # Main .text section
│   ├── data/cod/           # .data, .rodata, .lit4, .sdata, .sbss, .bss
│   └── ov02/2DD000.s       # Overlay segment
├── assets/                 # Binary blobs (VU microcode)
├── config/
│   ├── SLUS_204.69.yaml    # Splat configuration
│   ├── SLUS_204.69.pinned.ld  # Linker script with pinned section addresses
│   ├── symbol_addrs.txt    # 7,758 named symbols from original ELF
│   ├── undefined_funcs_auto.txt  # Auto-generated function symbols
│   └── undefined_syms_auto.txt   # Auto-generated data symbols
├── include/
│   ├── macro.inc           # Assembly macros
│   └── labels.inc          # Label macros
├── tools/
│   ├── extract_symbols.py  # Extracts symbols from original ELF
│   ├── fix_asm.py          # Patches ld/sd instruction expansion
│   └── post_split.sh       # Post-split automation
├── configure.py            # Build system generator (ninja)
└── requirements.txt
```

## Technical Notes

### R5900 Instruction Expansion

The PS2's Emotion Engine (MIPS R5900) has native 64-bit `ld`/`sd` instructions, but the assembler's o32 ABI mode treats them as pseudo-instructions and expands them into two 32-bit operations. `tools/fix_asm.py` handles this:

- `ld`/`sd` **without relocations** are replaced with raw `.word` directives using the hex bytes from spimdisasm's comments
- `ld`/`sd` **with relocations** (`%lo`, `%hi`, `%gp_rel`) are wrapped with `.set mips3` / `.set at` to prevent expansion while preserving relocation entries

### Pinned Linker Script

Splat's auto-generated linker script places sections sequentially, but minor size differences from alignment cause downstream sections to shift, breaking GP-relative relocations. The pinned linker script forces each section to its exact original virtual address using separate output sections.

## Disclaimer

This project requires a legally obtained copy of the game. No copyrighted assets are included in this repository. The original game executable is required to build and is not provided.
