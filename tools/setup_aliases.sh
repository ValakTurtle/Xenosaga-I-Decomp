#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ACTIVATE="$SCRIPT_DIR/venv/bin/activate"

if [ ! -f "$ACTIVATE" ]; then
    echo "Error: venv not found. Run setup.sh first."
    exit 1
fi

if grep -q "Xenosaga decomp aliases" "$ACTIVATE"; then
    echo "Aliases already installed."
    exit 0
fi

cat >> "$ACTIVATE" << 'ALIASES'

# Xenosaga decomp aliases
alias build='ninja && python3 tools/verify.py'
alias progress='python3 tools/progress.py'
alias split='python3 -m splat split config/SLUS_204.69.yaml && bash tools/post_split.sh && python3 configure.py'
alias full='python3 -m splat split config/SLUS_204.69.yaml && bash tools/post_split.sh && python3 configure.py && ninja && python3 tools/verify.py'
alias aliases='echo "  build    - ninja + verify"; echo "  progress - progress.py"; echo "  split    - splat + post_split + configure"; echo "  full     - split + build"; echo "  aliases  - show this list"'
ALIASES

echo "Aliases installed. Re-activate venv to use: source venv/bin/activate"
