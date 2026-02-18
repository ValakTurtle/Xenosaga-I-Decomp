# Xenosaga Episode I: Der Wille zur Macht

<!--badge-start-->
[![Progress](https://img.shields.io/badge/progress-0.029%25-blue?style=flat)](https://github.com/ValakTurtle/Xenosaga-I-Decomp)
<!--badge-end-->

<!--progress-start-->
### Decompilation Progress

| Version | Functions | Bytes | % of .text |
|---------|-----------|-------|------------|
| NTSC-U  | 12        | 376   | 0.029%     |

*Auto-updated on each push.*
<!--progress-end-->

A work-in-progress decompilation of **Xenosaga Episode I** (PS2).

| Version | Target | SHA1 | Status |
|---------|--------|------|--------|
| NTSC-U  | `SLUS_204.69` | `fd206d5715a322830f7fa9285fb4a09276ac2a63` | Active |
| NTSC-J  | `SLPS_291.08` | TBD | Planned |
| PAL     | `SLES_514.98` | TBD | Planned |

The project has a **byte-matching build** of the full NTSC-U executable, with 7,758 named symbols extracted from the original ELF. Functions are being rewritten in C and verified against the original binary.

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
