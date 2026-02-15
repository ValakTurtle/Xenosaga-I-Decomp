#!/usr/bin/env python3
"""
Post-processes assembly files to prevent instruction expansion.
- ld/sd/lwu WITHOUT relocations: replace with .word using raw hex
- ld/sd/lwu WITH relocations: wrap with .set mips3 to prevent o32 expansion
"""

import re
import sys
from pathlib import Path

# Match lines with raw hex in comment and ld/sd/lwu
RAW_PATTERN = re.compile(
    r'^(\s+)/\*\s+[0-9A-Fa-f]+\s+[0-9A-Fa-f]+\s+([0-9A-Fa-f]{8})\s+\*/\s+(ld|sd|lwu)\s+(.*)'
)

RELOC_RE = re.compile(r'%(?:lo|hi|gp_rel)\(')

def swap_endian(hex_str):
    b = bytes.fromhex(hex_str)
    return int.from_bytes(b, 'little')

def fix_file(filepath):
    text = filepath.read_text()
    lines = text.split('\n')
    new_lines = []
    word_fixes = 0
    reloc_fixes = 0

    for line in lines:
        match = RAW_PATTERN.match(line)
        if match:
            indent = match.group(1)
            hex_bytes = match.group(2)
            insn = match.group(3)
            operands = match.group(4)

            if RELOC_RE.search(operands):
                # Has relocation — keep as instruction but prevent o32 expansion
                new_lines.append('    .set push')
                new_lines.append('    .set mips3')
                new_lines.append('    .set at')
                new_lines.append(line)
                new_lines.append('    .set pop')
                reloc_fixes += 1
            else:
                # No relocation — safe to .word encode
                word_val = swap_endian(hex_bytes)
                new_lines.append(f'{indent}.word 0x{word_val:08X} /* {insn} {operands} */')
                word_fixes += 1
        else:
            new_lines.append(line)

    if word_fixes > 0 or reloc_fixes > 0:
        filepath.write_text('\n'.join(new_lines))
    return word_fixes, reloc_fixes

def main():
    asm_dir = Path('asm')
    if not asm_dir.exists():
        print("Error: asm/ directory not found")
        sys.exit(1)

    total_word = 0
    total_reloc = 0
    files_fixed = 0
    for asm_file in sorted(asm_dir.rglob('*.s')):
        w, r = fix_file(asm_file)
        if w > 0 or r > 0:
            print(f"  {asm_file}: {w} .word, {r} .set mips3 wraps")
            total_word += w
            total_reloc += r
            files_fixed += 1
    print(f"\nTotal: {total_word} .word, {total_reloc} .set mips3 wraps across {files_fixed} files")

if __name__ == "__main__":
    main()
