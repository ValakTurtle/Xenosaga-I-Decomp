# Setup

## Quick Start

```bash
git clone https://github.com/ValakTurtle/Xenosaga-I-Decomp.git xenosaga
cd xenosaga
bash setup.sh
```

The setup script installs all dependencies, builds the PS2DEV cross-toolchain, and sets up the Python environment. It takes a few minutes on first run and is safe to re-run.

## Prerequisites

- **WSL2 / Ubuntu 24** (or native Linux)
- A legally obtained copy of the game

Everything else is installed automatically by `setup.sh`, including:

- Python 3.12+ with venv and [splat](https://github.com/ethteck/splat)
- ninja-build
- ps2dev binutils (`mips64r5900el-ps2-elf-as`, `mips64r5900el-ps2-elf-ld`)
- mipsel-linux-gnu-gcc (for compiling decompiled C)
- binutils-mips-linux-gnu (for ROM generation)

## Building

After running `setup.sh`, place the original ELF in the `elf/` directory and run:

```bash
source venv/bin/activate
mips-linux-gnu-objcopy -O binary --gap-fill=0x00 elf/SLUS_204.69 config/SLUS_204.69.rom
python3 -m splat split config/SLUS_204.69.yaml
bash tools/post_split.sh
python3 configure.py
ninja
```

The built ELF will be at `build/SLUS_204.69.elf`.

## Verifying the Build

To confirm the build matches the original byte-for-byte:

```bash
/usr/local/ps2dev/ee/bin/mips64r5900el-ps2-elf-objcopy -O binary -j .text elf/SLUS_204.69 build/orig_text.bin
/usr/local/ps2dev/ee/bin/mips64r5900el-ps2-elf-objcopy -O binary -j .cod build/SLUS_204.69.elf build/built_text.bin
dd if=build/built_text.bin of=build/built_text_only.bin bs=1 count=1279344 2>/dev/null
cmp -l build/orig_text.bin build/built_text_only.bin | wc -l
rm build/orig_text.bin build/built_text.bin build/built_text_only.bin
```

This should print `0` (zero differences).

To verify decompiled functions match:

```bash
python3 tools/verify.py
```

To check overall progress:

```bash
python3 tools/progress.py
```

## Rebuilding After Changes

If you only changed C files in `src/`, just run:

```bash
ninja && python3 tools/verify.py
```

If you modified the Splat config (`config/SLUS_204.69.yaml`), you need to re-split:

```bash
python3 -m splat split config/SLUS_204.69.yaml
bash tools/post_split.sh
python3 configure.py
ninja
```

`tools/post_split.sh` copies the pinned linker script over Splat's auto-generated one, strips comments from `symbol_addrs.txt`, and runs `fix_asm.py` to patch R5900 instruction encoding issues.

## Manual Setup

If you prefer not to use `setup.sh`, install the following manually:

```bash
# System packages
sudo apt install -y python3 python3-venv ninja-build build-essential git bison flex texinfo gcc-mipsel-linux-gnu binutils-mips-linux-gnu

# Python environment
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

# PS2DEV binutils
git clone --depth 1 https://github.com/ps2dev/binutils-gdb.git /tmp/binutils-gdb
cd /tmp/binutils-gdb && mkdir build && cd build
../configure --target=mips64r5900el-ps2-elf --prefix=/usr/local/ps2dev/ee --disable-gdb --disable-nls --disable-werror
make -j$(nproc)
sudo make install

# Add to PATH
echo 'export PATH="$PATH:/usr/local/ps2dev/ee/bin"' >> ~/.bashrc
source ~/.bashrc
```
