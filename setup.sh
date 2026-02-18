#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export PATH="$PATH:/usr/local/ps2dev/ee/bin"

spin() {
    local pid=$1
    local msg=$2
    local chars='/-\|'
    local i=0
    while kill -0 "$pid" 2>/dev/null; do
        printf "\r  [%c] %s" "${chars:$i:1}" "$msg"
        i=$(( (i + 1) % ${#chars} ))
        sleep 0.15
    done
    wait "$pid"
    local exit_code=$?
    if [ $exit_code -eq 0 ]; then
        printf "\r  [+] %s\n" "$msg"
    else
        printf "\r  [!] %s (failed)\n" "$msg"
        exit $exit_code
    fi
}

echo "Xenosaga Episode I Decomp -- Setup"
echo "-----------------------------------"

# System packages
(sudo apt update -qq > /dev/null 2>&1 && sudo apt install -y -qq python3 python3-venv ninja-build build-essential git bison flex texinfo gcc-mipsel-linux-gnu binutils-mips-linux-gnu > /dev/null 2>&1) &
spin $! "Installing system packages"

# Python venv
cd "$SCRIPT_DIR"
if [ -d "venv" ]; then
    echo "  [+] Python environment already exists"
else
    (python3 -m venv venv && source venv/bin/activate && pip install --upgrade pip -q > /dev/null 2>&1 && pip install -r requirements.txt -q > /dev/null 2>&1) &
    spin $! "Setting up Python environment"
fi

# Project aliases
bash tools/setup_aliases.sh > /dev/null 2>&1 && echo "  [+] Project aliases installed (build, progress, split, full)"

# PS2DEV binutils
if command -v mips64r5900el-ps2-elf-as &> /dev/null; then
    echo "  [+] PS2DEV binutils already installed"
else
    rm -rf /tmp/binutils-gdb
    (git clone --depth 1 -q https://github.com/ps2dev/binutils-gdb.git /tmp/binutils-gdb 2>/dev/null && \
     cd /tmp/binutils-gdb && mkdir -p build && cd build && \
     ../configure --target=mips64r5900el-ps2-elf --prefix=/usr/local/ps2dev/ee --disable-gdb --disable-nls --disable-werror > /dev/null 2>&1 && \
     make -j$(nproc) > /dev/null 2>&1 && \
     sudo make install > /dev/null 2>&1) &
    spin $! "Building PS2DEV binutils (this takes a few minutes)"
fi

# Persist PATH
if ! grep -q 'ps2dev' ~/.bashrc; then
    echo 'export PATH="$PATH:/usr/local/ps2dev/ee/bin"' >> ~/.bashrc
fi

mkdir -p "$SCRIPT_DIR/elf"

echo "-----------------------------------"
echo "Setup complete! Place your SLUS_204.69 in elf/, then run:"
echo ""
echo "  source venv/bin/activate"
echo "  mips-linux-gnu-objcopy -O binary --gap-fill=0x00 elf/SLUS_204.69 config/SLUS_204.69.rom"
echo "  python3 -m splat split config/SLUS_204.69.yaml"
echo "  bash tools/post_split.sh"
echo "  python3 configure.py"
echo "  ninja"
