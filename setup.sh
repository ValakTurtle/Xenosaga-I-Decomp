#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=== Installing system dependencies ==="
sudo apt update -qq
sudo apt install -y -qq python3 python3-venv ninja-build build-essential git bison flex texinfo gcc-mipsel-linux-gnu binutils-mips-linux-gnu

echo "=== Setting up Python venv ==="
cd "$SCRIPT_DIR"
python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip -q
pip install -r requirements.txt -q

echo "=== Installing PS2DEV binutils (this may take a few minutes) ==="
if ! command -v mips64r5900el-ps2-elf-as &> /dev/null; then
    git clone --depth 1 -q https://github.com/ps2dev/binutils-gdb.git /tmp/binutils-gdb
    cd /tmp/binutils-gdb && mkdir -p build && cd build
    ../configure --target=mips64r5900el-ps2-elf --prefix=/usr/local/ps2dev/ee --disable-gdb --disable-nls --disable-werror > /dev/null 2>&1
    make -j$(nproc) > /dev/null 2>&1
    sudo make install > /dev/null 2>&1
    cd "$SCRIPT_DIR"
else
    echo "PS2DEV binutils already installed, skipping"
fi

echo "=== Updating PATH ==="
export PATH="$PATH:/usr/local/ps2dev/ee/bin"
if ! grep -q 'ps2dev' ~/.bashrc; then
    echo 'export PATH="$PATH:/usr/local/ps2dev/ee/bin"' >> ~/.bashrc
fi

mkdir -p "$SCRIPT_DIR/iso"

echo ""
echo "=== Setup complete ==="
echo ""
echo "Place your SLUS_204.69 in the iso/ directory, then run:"
echo "  source venv/bin/activate"
echo "  mips-linux-gnu-objcopy -O binary --gap-fill=0x00 iso/SLUS_204.69 config/SLUS_204.69.rom"
echo "  python3 -m splat split config/SLUS_204.69.yaml"
echo "  bash tools/post_split.sh"
echo "  python3 configure.py"
echo "  ninja"
