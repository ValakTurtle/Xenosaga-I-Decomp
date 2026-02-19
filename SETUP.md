# Setup

## Quick Start
```bash
git clone https://github.com/ValakTurtle/Xenosaga-I-Decomp.git xenosaga
cd xenosaga
bash setup.sh
```

The setup script installs all dependencies, builds the PS2DEV cross-toolchain and EE-GCC compiler, and sets up the Python environment. It takes a few minutes on first run and is safe to re-run.

## Prerequisites

- **WSL2 / Ubuntu 24** (or native Linux)
- A legally obtained copy of the game

Everything else is installed automatically by `setup.sh`, including:

- Python 3.12+ with venv and [splat](https://github.com/ethteck/splat)
- ninja-build
- gcc-multilib (for building EE-GCC from source)
- PS2DEV binutils (`mips64r5900el-ps2-elf-as`, `mips64r5900el-ps2-elf-ld`, `mips64r5900el-ps2-elf-objcopy`)
- EE-GCC 2.9-ee-991111 (Sony PS2 C compiler for decompilation matching)

## Building

After running `setup.sh`, place the original ELF in the `elf/` directory and run:
```bash
source venv/bin/activate
mips64r5900el-ps2-elf-objcopy -O binary --gap-fill=0x00 elf/SLUS_204.69 config/SLUS_204.69.rom
python3 -m splat split config/SLUS_204.69.yaml
bash tools/post_split.sh
python3 configure.py
ninja
```

The built ELF will be at `build/SLUS_204.69.elf`.

## Verifying the Build

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

## Aliases

The setup script installs project aliases into the venv. They activate when you `source venv/bin/activate`. To install them manually, run `bash tools/setup_aliases.sh`.

| Alias | Command | Description |
|-------|---------|-------------|
| `build` | `ninja && python3 tools/verify.py` | Build and verify decompiled functions |
| `progress` | `python3 tools/progress.py` | Show decompilation progress |
| `split` | `splat split` + `post_split.sh` + `configure.py` | Re-split and reconfigure after YAML changes |
| `full` | `split` + `build` | Full rebuild from scratch |
| `aliases` | — | Show this list |

## Manual Setup

If you prefer not to use `setup.sh`, install the following manually:
```bash
# System packages
sudo apt install -y python3 python3-venv ninja-build build-essential git bison flex texinfo gcc-multilib

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

# EE-GCC (Sony PS2 compiler)
git clone --depth 1 https://github.com/SSXModding/ps2-ee-toolchain.git /tmp/ps2-ee-toolchain
cd /tmp/ps2-ee-toolchain && mkdir build_cygee && cd build_cygee
CC='gcc -m32' LDFLAGS='-static' ../ee/configure --target=ee --enable-c-cpplib --without-sim --disable-sim --host=i686-linux-gnu --prefix=/tmp/ps2-ee-toolchain/toolchain/ee
make -j$(nproc)
make install
sudo cp -r /tmp/ps2-ee-toolchain/toolchain/ee /usr/local/ps2dev/ee-gcc
# Replace bundled assembler with ps2dev version (fixes BFD assertions)
sudo mv /usr/local/ps2dev/ee-gcc/bin/ee-as /usr/local/ps2dev/ee-gcc/bin/ee-as.old
sudo ln -s /usr/local/ps2dev/ee/bin/mips64r5900el-ps2-elf-as /usr/local/ps2dev/ee-gcc/bin/ee-as
sudo ln -sf /usr/local/ps2dev/ee/bin/mips64r5900el-ps2-elf-as /usr/local/ps2dev/ee-gcc/ee/bin/as

# Add to PATH
echo 'export PATH="$PATH:/usr/local/ps2dev/ee/bin"' >> ~/.bashrc
source ~/.bashrc

# Install aliases
bash tools/setup_aliases.sh
```
