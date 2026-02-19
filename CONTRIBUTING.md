# Contributing

## Decompilation Workflow

Functions are decompiled by writing equivalent C code in `src/` and verifying it produces identical machine code to the original.

1. Pick a function from `asm/cod/000000.s`
2. Write the C equivalent in the appropriate `src/*.c` file
3. Add an entry to `config/decompiled.txt`
4. Build and verify:

```bash
ninja && python3 tools/verify.py
```

If you have aliases set up (see [SETUP.md](SETUP.md#aliases)), step 4 is just `build`.

`verify.py` compiles your C, extracts the bytes, and compares them against the same address range in the original ELF. It masks `jal` targets (unresolved in `.o` files) and `break` instruction encodings.

## decompiled.txt Format

Each decompiled function needs an entry in `config/decompiled.txt`:

```
# Verified match
sceVif1PkInit = 0x0020AC68, 0x10; // sceVif1Pk

# PS2 hardware function (skipped by verify.py)
sceVif1PkAddGsPacked = 0x0020B568, 0x14; // sceVif1Pk HARDWARE
```

The format is: `name = address, size; // source_file [HARDWARE]`

- **address**: Virtual address from the assembly (e.g., `0x0020AC68`)
- **size**: Number of bytes (instruction count × 4)
- **source_file**: Base name of the `.c` file in `src/` (without extension)
- **HARDWARE**: Optional tag for PS2-specific functions

## PS2 Hardware Functions

Some functions use PS2-specific instructions (`sq`, `lq`, etc.) that the compiler cannot emit. These are documented in source files inside `#ifdef PS2_HARDWARE` blocks:

```c
#ifdef PS2_HARDWARE

/* Store a 128-bit quadword into the packet */
void sceVif1PkAddGsPacked(Vif1Packet *pkt, unsigned int *value)
{
    unsigned int *dest = pkt->current;
    /* sq $a1, 0x0($v0) — 128-bit store, equivalent to: */
    dest[0] = value[0];
    dest[1] = value[1];
    dest[2] = value[2];
    dest[3] = value[3];
    pkt->current += 4;
}

#endif /* PS2_HARDWARE */
```

These functions are tagged `HARDWARE` in `decompiled.txt` and skipped by `verify.py`. The C documents the logic for future porting.

To find all hardware-dependent functions:

```bash
grep -r "PS2_HARDWARE" src/
```

## Conventions

### Source files

Functions are grouped by their original source file, inferred from naming prefixes and adjacency in the binary. For example, all `sceVif1Pk*` functions go in `src/sceVif1Pk.c`.

### C89 compliance

The compiler (EE-GCC 2.9) is C89 only. All variable declarations must be at the top of their block — no mid-block declarations.

### Compiler flags

The C compiler flags are `-O2 -G0 -fno-schedule-insns` (EE-GCC 2.9-ee-991111). All pointers and `int` types are 32 bits.

### Comments

Use a single-line comment above each function describing what it does. Inline comments are only needed when something is non-obvious (bitshifts, PS2 quirks, etc.).

```c
/* Return the number of quadwords written to the packet */
unsigned int sceVif1PkSize(Vif1Packet *pkt)
{
    unsigned char *base = (unsigned char*)pkt->base;
    return ((unsigned int)((unsigned char*)pkt->current - base)) >> 4;
}
```

### Types

When you understand the data layout of a struct, define a `typedef` and use it across all functions in that file. This makes the code self-documenting and prepares it for porting.

```c
typedef struct Vif1Packet
{
    unsigned int *current;
    unsigned int *base;
    unsigned int  reserved;
    /* ... */
} Vif1Packet;
```

## Technical Notes

### Toolchain

The project uses two toolchains working together:

- **EE-GCC 2.9-ee-991111** — The original Sony PS2 C compiler, built from [SSXModding/ps2-ee-toolchain](https://github.com/SSXModding/ps2-ee-toolchain). Compiles C to assembly. Flags: `-O2 -G0 -fno-schedule-insns`.
- **PS2DEV binutils** — Assembles R5900 MIPS and links the final ELF. Handles R5900-specific instructions (`sq`, `lq`, etc.) that generic MIPS assemblers don't support.

The build uses a two-step compilation via `tools/ee-cc.sh`:
1. EE-GCC compiles `.c → .s`
2. `sed` replaces `move` pseudo-instructions with `daddu` (matching the original assembler's encoding)
3. PS2DEV assembler assembles `.s → .o` with `-march=r5900 -mabi=eabi` (for native 64-bit `sd`/`ld`)

### R5900 Instruction Expansion

The PS2's Emotion Engine (MIPS R5900) has native 64-bit `ld`/`sd` instructions, but the assembler's o32 ABI mode treats them as pseudo-instructions and expands them into two 32-bit operations. `tools/fix_asm.py` handles this for assembly files:

- `ld`/`sd` **without relocations** are replaced with raw `.word` directives
- `ld`/`sd` **with relocations** (`%lo`, `%hi`, `%gp_rel`) are wrapped with `.set mips3` / `.set at` to prevent expansion

For C-compiled code, the assembler uses `-mabi=eabi` which natively supports 64-bit `sd`/`ld` without expansion.

### Pinned Linker Script

Splat's auto-generated linker script places sections sequentially, but minor size differences from alignment cause downstream sections to shift, breaking GP-relative relocations. The pinned linker script forces each section to its exact original virtual address.

### Symbol Extraction

`tools/extract_symbols.py` reads the original ELF's `.symtab` via `nm` and produces `symbol_addrs.txt`. It filters compiler noise (`$L` labels, hardware labels), deduplicates by address (preferring global over local), and disambiguates static functions with identical names by appending the address.
