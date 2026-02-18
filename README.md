# Xenosaga Episode I: Der Wille zur Macht

A work-in-progress decompilation of **Xenosaga Episode I** (PS2).

<!--progress-start-->
| Version | Target | Bytes | Progress |
|---------|--------|-------|----------|
| NTSC-U  | `SLUS_204.69` | 1,980 / 1,279,344 | 0.155% |
| NTSC-J  | `SLPS_290.02` | — | Planned |
| Reloaded | `SLPS_290.05` | — | Planned |
<!--progress-end-->

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
include/
  macro.inc                 Assembly macros
  labels.inc                Label macros
tools/
  extract_symbols.py        Extracts symbols from original ELF
  fix_asm.py                Patches ld/sd instruction expansion
  verify.py                 Verifies decompiled C matches original bytes
  progress.py               Calculates decompilation progress
  post_split.sh             Post-split automation
  setup_aliases.sh          Installs project aliases into venv
.github/workflows/
  progress.yml              Auto-updates README progress on push
configure.py                Build system generator (ninja)
setup.sh                    One-step environment setup
SETUP.md                    Installation and build instructions
CONTRIBUTING.md             Workflow, conventions, and technical notes
```

## Disclaimer

This project requires a legally obtained copy of the game. No copyrighted assets are included in this repository.
