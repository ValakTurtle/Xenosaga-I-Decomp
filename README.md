# Xenosaga Episode I: Der Wille zur Macht

[![Build](https://img.shields.io/github/actions/workflow/status/ValakTurtle/Xenosaga-I-Decomp/progress.yml?branch=main&label=build)](https://github.com/ValakTurtle/Xenosaga-I-Decomp/actions)

<!--progress-start-->
### Decompilation Progress

| Category | Functions | Bytes | % of .text |
|----------|-----------|-------|------------|
| Matched  | 10        | 332   | 0.026%     |
| Hardware | 2         | 44    | 0.003%     |
| **Total**| **12**    | **376**| **0.029%** |

*Auto-updated on each push.*
<!--progress-end-->

A work-in-progress decompilation of **Xenosaga Episode I** (PS2, NTSC-U).

**Target:** `SLUS_204.69` (SHA1: `fd206d5715a322830f7fa9285fb4a09276ac2a63`)

The project has a **byte-matching build** of the full executable, with 7,758 named symbols extracted from the original ELF. Functions are being rewritten in C and verified against the original binary.

To set up the repository, see [SETUP.md](SETUP.md).

For information on how the project works and how to contribute, see [CONTRIBUTING.md](CONTRIBUTING.md).

## Project Structure

```
asm/                        Disassembled code and data
  cod/000000.s              Main .text section (~4,500 functions)
  data/cod/                 .data, .rodata, .lit4, .sdata, .sbss, .bss
  ov02/2DD000.s             Overlay segment
src/                        Decompiled C source files
assets/                     Binary blobs (VU microcode)
config/
  SLUS_204.69.yaml          Splat configuration
  SLUS_204.69.pinned.ld     Pinned linker script
  decompiled.txt            Tracks decompiled functions
  symbol_addrs.txt          7,758 named symbols from original ELF
  undefined_funcs_auto.txt  Auto-generated function symbols
  undefined_syms_auto.txt   Auto-generated data symbols
tools/
  extract_symbols.py        Extracts symbols from original ELF
  fix_asm.py                Patches ld/sd instruction expansion
  verify.py                 Verifies decompiled C matches original bytes
  progress.py               Calculates decompilation progress
  post_split.sh             Post-split automation
configure.py                Build system generator (ninja)
setup.sh                    One-step environment setup
```

## Disclaimer

This project requires a legally obtained copy of the game. No copyrighted assets are included in this repository.
