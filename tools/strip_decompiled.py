#!/usr/bin/env python3
"""Replace decompiled functions in assembly with .space directives."""
import re
import sys

DECOMP = "config/decompiled.txt"
ASM = "asm/cod/000000.s"

# Parse decompiled.txt for function names and sizes
decompiled = {}
with open(DECOMP) as f:
    for line in f:
        line = line.strip()
        if not line or line.startswith('#'):
            continue
        m = re.match(r'(\w+)\s*=\s*(0x[0-9A-Fa-f]+),\s*(0x[0-9A-Fa-f]+);', line)
        if m:
            name = m.group(1)
            size = int(m.group(3), 16)
            decompiled[name] = size

if not decompiled:
    print("No decompiled functions found.")
    sys.exit(0)

# Read assembly
with open(ASM) as f:
    lines = f.readlines()

# Replace function bodies with .space
output = []
skip = False
current_func = None

i = 0
while i < len(lines):
    line = lines[i]
    stripped = line.strip()

    # Check for glabel of a decompiled function
    glabel_match = re.match(r'glabel\s+(\w+)', stripped)
    if glabel_match and glabel_match.group(1) in decompiled:
        current_func = glabel_match.group(1)
        size = decompiled[current_func]
        # Emit the label (so other code can still call it) and .space
        output.append(f"glabel {current_func}\n")
        output.append(f"  .space {size}\n")
        skip = True
        i += 1
        continue

    # Check for endlabel — stop skipping
    endlabel_match = re.match(r'endlabel\s+(\w+)', stripped)
    if endlabel_match and endlabel_match.group(1) == current_func:
        output.append(line)  # keep endlabel
        skip = False
        current_func = None
        i += 1
        continue

    if not skip:
        output.append(line)

    i += 1

with open(ASM, 'w') as f:
    f.writelines(output)

print(f"Stripped {len(decompiled)} decompiled functions from {ASM}")
for name, size in sorted(decompiled.items()):
    print(f"  {name}: {size} bytes -> .space")
