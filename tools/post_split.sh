#!/bin/bash
# Run after every `splat split` to patch generated files

# 1. Replace linker script with our pinned version
cp config/SLUS_204.69.pinned.ld config/SLUS_204.69.ld

# 2. Strip comments from symbol_addrs.txt (linker can't parse //)
sed -i 's|//.*||' config/symbol_addrs.txt

# 3. Fix asm $at issues
python3 tools/fix_asm.py

echo "Post-split patches applied."
