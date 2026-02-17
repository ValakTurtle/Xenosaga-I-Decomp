# Xenosaga Episode I Decompilation

A work-in-progress decompilation of **Xenosaga Episode I: Der Wille zur Macht** (PS2, NTSC-U).

**Target:** `SLUS_204.69` (SHA1: `fd206d5715a322830f7fa9285fb4a09276ac2a63`)

## Status

The project currently has a **byte-matching build** of the full executable, with all code and data split into individual assembly files. 7,758 symbols have been extracted from the original ELF's symbol table, providing real function and data names throughout the disassembly.

### Decompilation Progress

| Category | Functions | Bytes | % of .text |
|----------|-----------|-------|------------|
| Matched  | 6 | 132 | 0.010% |
| Hardware | 2 | 44 | 0.003% |
| **Total**| **8** | **176** | **0.014%** |

*Auto-updated on each push. Run `python3 tools/progress.py` locally for current stats.*

## Prerequisites

- **WSL2 / Ubuntu 24** (or native Linux)
- **Python 3.12+** with `venv`
- **ninja-build**
- **ps2dev binutils** (provides `mips64r5900el-ps2-elf-as` and `mips64r5900el-ps2-elf-ld`)
- **mipsel-linux-gnu-gcc** (for compiling C — `sudo apt install gcc-mipsel-linux-gnu`)
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

### Verifying the build

To confirm the build matches the original byte-for-byte:
```bash
/usr/local/ps2dev/ee/bin/mips64r5900el-ps2-elf-objcopy -O binary -j .text iso/SLUS_204.69 build/orig_text.bin
/usr/local/ps2dev/ee/bin/mips64r5900el-ps2-elf-objcopy -O binary -j .cod build/SLUS_204.69.elf build/built_text.bin
dd if=build/built_text.bin of=build/built_text_only.bin bs=1 count=1279344 2>/dev/null
cmp -l build/orig_text.bin build/built_text_only.bin | wc -l
rm build/orig_text.bin build/built_text.bin build/built_text_only.bin
```

This should print `0` (zero differences).

### After modifying Splat config

Whenever you re-run `splat split`, you must also re-run `tools/post_split.sh` before building. This script:

1. Copies the pinned linker script over Splat's auto-generated one
2. Strips `//` comments from `symbol_addrs.txt` (linker can't parse them)
3. Runs `fix_asm.py` to patch R5900 instruction encoding issues

## Decompilation Workflow

Functions are decompiled by writing equivalent C code in `src/` and verifying it produces identical machine code to the original.

1. Pick a function from `asm/cod/000000.s`
2. Write the C equivalent in the appropriate `src/*.c` file
3. Add an entry to `config/decompiled.txt` with the function name, address, and size
4. Build and verify:
```bash
ninja && python3 tools/verify.py
```

`verify.py` compiles your C, extracts the bytes, and compares them against the same address range in the original ELF. Functions are grouped by their original source file (inferred from naming prefixes and adjacency in the binary).

### decompiled.txt format
```
# Verified match — name = address, size; // source_file
sceVif1PkInit = 0x0020AC68, 0x10; // sceVif1Pk

# PS2 hardware function — name = address, size; // source_file HARDWARE
sceVif1PkAddGsPacked = 0x0020B568, 0x14; // sceVif1Pk HARDWARE
```

Functions marked `HARDWARE` use PS2-specific instructions and are skipped by `verify.py`.

## Project Structure
```
├── asm/                    # Disassembled code and data
│   ├── cod/000000.s        # Main .text section (~4,500 functions)
│   ├── data/cod/           # .data, .rodata, .lit4, .sdata, .sbss, .bss
│   └── ov02/2DD000.s       # Overlay segment
├── src/                    # Decompiled C source files
├── assets/                 # Binary blobs (VU microcode)
├── config/
│   ├── SLUS_204.69.yaml    # Splat configuration
│   ├── SLUS_204.69.pinned.ld  # Linker script with pinned section addresses
│   ├── decompiled.txt      # Tracks decompiled functions
│   ├── symbol_addrs.txt    # 7,758 named symbols from original ELF
│   ├── undefined_funcs_auto.txt  # Auto-generated function symbols
│   └── undefined_syms_auto.txt   # Auto-generated data symbols
├── include/
│   ├── macro.inc           # Assembly macros
│   └── labels.inc          # Label macros
├── tools/
│   ├── extract_symbols.py  # Extracts symbols from original ELF
│   ├── fix_asm.py          # Patches ld/sd instruction expansion
│   ├── verify.py           # Verifies decompiled C matches original bytes
│   └── post_split.sh       # Post-split automation
├── configure.py            # Build system generator (ninja)
└── requirements.txt
```

## Technical Notes

### Toolchain

The project uses two toolchains:

- **ps2dev ee-as / ee-ld** — assembles R5900 MIPS and links the final ELF. The ps2dev assembler properly handles R5900-specific instructions (`sq`, `lq`, etc.) that generic MIPS assemblers don't support.
- **mipsel-linux-gnu-gcc** — compiles decompiled C files. The original game was compiled with Sony's EEGCC; instruction scheduling may differ with this compiler, but many functions still match.

The linker uses `-m elf32lr5900` to select the correct emulation for o32 ABI objects, and `--noinhibit-exec` to push past ABI mismatch warnings between the two toolchains.

### R5900 Instruction Expansion

The PS2's Emotion Engine (MIPS R5900) has native 64-bit `ld`/`sd` instructions, but the assembler's o32 ABI mode treats them as pseudo-instructions and expands them into two 32-bit operations. `tools/fix_asm.py` handles this:

- `ld`/`sd` **without relocations** are replaced with raw `.word` directives using the hex bytes from spimdisasm's comments
- `ld`/`sd` **with relocations** (`%lo`, `%hi`, `%gp_rel`) are wrapped with `.set mips3` / `.set at` to prevent expansion while preserving relocation entries

### Pinned Linker Script

Splat's auto-generated linker script places sections sequentially, but minor size differences from alignment cause downstream sections to shift, breaking GP-relative relocations. The pinned linker script forces each section to its exact original virtual address using separate output sections.

### Symbol Extraction

`tools/extract_symbols.py` reads the original ELF's `.symtab` section via `nm` and converts the symbols into Splat's `symbol_addrs.txt` format. It filters out compiler noise (`$L` labels, `.vif`/`.dma` hardware labels), deduplicates symbols sharing the same address (preferring global over local), and disambiguates `static` functions with identical names by appending the address.

### PS2 Hardware Functions

Some functions use PS2-specific instructions (`sq`, `lq`, etc.) that cannot be compiled with `mipsel-linux-gnu-gcc`. These are documented in the source files inside `#ifdef PS2_HARDWARE` blocks with inline comments referencing the original instructions. They are tagged with `HARDWARE` in `decompiled.txt`, and `verify.py` skips them and reports them separately.

To find all hardware-dependent functions:
```bash
grep -r "PS2_HARDWARE" src/
```

## Disclaimer

This project requires a legally obtained copy of the game. No copyrighted assets are included in this repository. The original game executable is required to build and is not provided.