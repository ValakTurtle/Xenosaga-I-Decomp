#!/usr/bin/env python3
"""Calculate decompilation progress and optionally update README."""
import re
import sys

DECOMP = "config/decompiled.txt"
TOTAL_TEXT_SIZE = 1279344

matched = 0
matched_count = 0
hardware = 0
hardware_count = 0

with open(DECOMP) as f:
    for line in f:
        line = line.strip()
        if not line or line.startswith('#'):
            continue
        m = re.match(r'(\w+)\s*=\s*(0x[0-9A-Fa-f]+),\s*(0x[0-9A-Fa-f]+);', line)
        if m:
            size = int(m.group(3), 16)
            if 'HARDWARE' in line:
                hardware += size
                hardware_count += 1
            else:
                matched += size
                matched_count += 1

total_bytes = matched + hardware
total_count = matched_count + hardware_count
pct = (total_bytes / TOTAL_TEXT_SIZE) * 100
matched_pct = (matched / TOTAL_TEXT_SIZE) * 100
hw_pct = (hardware / TOTAL_TEXT_SIZE) * 100

print(f"Decompilation progress: {total_bytes}/{TOTAL_TEXT_SIZE} bytes ({pct:.3f}%)")
print(f"  Matched:  {matched_count} functions ({matched} bytes)")
print(f"  Hardware: {hardware_count} functions ({hardware} bytes)")
print(f"  Total:    {total_count} functions ({total_bytes} bytes)")

if "--update-readme" in sys.argv:
    table = f"""### Decompilation Progress

| Category | Functions | Bytes | % of .text |
|----------|-----------|-------|------------|
| Matched  | {matched_count} | {matched} | {matched_pct:.3f}% |
| Hardware | {hardware_count} | {hardware} | {hw_pct:.3f}% |
| **Total**| **{total_count}** | **{total_bytes}** | **{pct:.3f}%** |

*Auto-updated on each push. Run `python3 tools/progress.py` locally for current stats.*"""

    with open("README.md") as f:
        readme = f.read()

    updated = re.sub(
        r'### Decompilation Progress.*?\*Auto-updated.*?\*',
        table,
        readme,
        flags=re.DOTALL
    )

    if updated != readme:
        with open("README.md", "w") as f:
            f.write(updated)
        print("README.md updated.")
    else:
        print("README.md already up to date.")
