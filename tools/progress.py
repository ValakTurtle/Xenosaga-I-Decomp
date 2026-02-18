#!/usr/bin/env python3
"""Calculate decompilation progress and optionally update README."""
import re
import sys
import subprocess
import glob

DECOMP = "config/decompiled.txt"
ELF = "elf/SLUS_204.69"
BUILT = "build/src"
OBJDUMP = "/usr/local/ps2dev/ee/bin/mips64r5900el-ps2-elf-objdump"
TOTAL_TEXT_SIZE = 1279344


def get_words(cmd):
    result = subprocess.run(cmd, capture_output=True, text=True)
    words = []
    for line in result.stdout.split('\n'):
        m = re.match(r'\s+[0-9a-f]+:\s+([0-9a-f]{8})\b', line)
        if m:
            words.append(m.group(1))
    return words


def mask_word(w):
    val = int(w, 16)
    if (val >> 26) == 0x03:
        return f"{val & 0xFC000000:08x}"
    if (val & 0xFC00003F) == 0x0000000D:
        return "BREAK"
    return w


def verify_function(name, addr, size):
    """Returns True if function matches."""
    obj = None
    for o in glob.glob(f"{BUILT}/*.o"):
        nm = subprocess.run([OBJDUMP, "-t", o], capture_output=True, text=True)
        if f" {name}\n" in nm.stdout or nm.stdout.rstrip().endswith(f" {name}"):
            obj = o
            break
    if not obj:
        return False

    end = addr + size
    orig = get_words([OBJDUMP, "-d", "-j", ".text",
                      f"--start-address=0x{addr:x}",
                      f"--stop-address=0x{end:x}", ELF])

    sym_result = subprocess.run([OBJDUMP, "-t", obj], capture_output=True, text=True)
    func_addr = None
    for line in sym_result.stdout.split('\n'):
        if f" {name}\n" in line or line.endswith(f" {name}"):
            m2 = re.match(r'([0-9a-f]+)', line)
            if m2:
                func_addr = int(m2.group(1), 16)
                break
    if func_addr is None:
        return False

    func_end = func_addr + size
    built = get_words([OBJDUMP, "-d",
                       f"--start-address=0x{func_addr:x}",
                       f"--stop-address=0x{func_end:x}", obj])

    if not orig:
        return False

    orig_masked = [mask_word(w) for w in orig]
    built_masked = [mask_word(w) for w in built]
    return orig_masked == built_masked


# Read decompiled.txt
entries = []
hardware_entries = []
with open(DECOMP) as f:
    for line in f:
        line = line.strip()
        if not line or line.startswith('#'):
            continue
        m = re.match(r'(\w+)\s*=\s*(0x[0-9A-Fa-f]+),\s*(0x[0-9A-Fa-f]+);', line)
        if m:
            name = m.group(1)
            addr = int(m.group(2), 16)
            size = int(m.group(3), 16)
            if 'HARDWARE' in line:
                hardware_entries.append((name, size))
            else:
                entries.append((name, addr, size))

# Verify each function
matched_bytes = 0
matched_count = 0
unmatched_bytes = 0
unmatched_count = 0
hardware_bytes = sum(s for _, s in hardware_entries)
hardware_count = len(hardware_entries)

for name, addr, size in entries:
    if verify_function(name, addr, size):
        matched_bytes += size
        matched_count += 1
    else:
        unmatched_bytes += size
        unmatched_count += 1

decompiled_bytes = matched_bytes + unmatched_bytes + hardware_bytes
decompiled_count = matched_count + unmatched_count + hardware_count
pct = (matched_bytes / TOTAL_TEXT_SIZE) * 100
decomp_pct = (decompiled_bytes / TOTAL_TEXT_SIZE) * 100

print(f"Decompilation progress: {decompiled_bytes}/{TOTAL_TEXT_SIZE} bytes ({decomp_pct:.3f}%)")
print(f"  Verified match: {matched_count} functions ({matched_bytes} bytes, {pct:.3f}%)")
print(f"  In progress:    {unmatched_count} functions ({unmatched_bytes} bytes)")
print(f"  Hardware:       {hardware_count} functions ({hardware_bytes} bytes)")
print(f"  Total:          {decompiled_count} functions ({decompiled_bytes} bytes)")

if "--update-readme" in sys.argv:
    table = f"""### Decompilation Progress
| Category | Functions | Bytes | % of .text |
|----------|-----------|-------|------------|
| Verified match | {matched_count} | {matched_bytes} | {pct:.3f}% |
| In progress | {unmatched_count} | {unmatched_bytes} | |
| Hardware | {hardware_count} | {hardware_bytes} | |
| **Total** | **{decompiled_count}** | **{decompiled_bytes}** | **{decomp_pct:.3f}%** |
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
