#!/usr/bin/env python3
"""Verify decompiled C functions match the original ELF."""
import subprocess, sys, re, glob

ELF = "elf/SLUS_204.69"
BUILT = "build/src"
OBJDUMP = "/usr/local/ps2dev/ee/bin/mips64r5900el-ps2-elf-objdump"
CC_OBJDUMP = "mipsel-linux-gnu-objdump"

def get_bytes(cmd):
    result = subprocess.run(cmd, capture_output=True, text=True)
    raw = []
    for line in result.stdout.split('\n'):
        m = re.match(r'\s+[0-9a-f]+:\s+((?:[0-9a-f]{2} )+)', line)
        if m:
            raw.extend(m.group(1).strip().split())
    return raw

# Read decompiled.txt
entries = []
hardware = []
with open("config/decompiled.txt") as f:
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
                hardware.append(name)
            else:
                entries.append((name, addr, size))

passed = 0
failed = 0

for name, addr, size in entries:
    obj = None
    for o in glob.glob(f"{BUILT}/*.o"):
        nm = subprocess.run(
            [CC_OBJDUMP, "-t", o], capture_output=True, text=True
        )
        if f" {name}\n" in nm.stdout:
            obj = o
            break

    if not obj:
        print(f"  SKIP {name} - no object file found")
        continue

    end = addr + size
    orig = get_bytes([OBJDUMP, "-d", "-j", ".text",
                      f"--start-address=0x{addr:x}",
                      f"--stop-address=0x{end:x}", ELF])
    built = get_bytes([CC_OBJDUMP, "-d", obj])

    if orig == built:
        print(f"  OK   {name}")
        passed += 1
    else:
        print(f"  FAIL {name}")
        print(f"    orig:  {' '.join(orig[:16])}")
        print(f"    built: {' '.join(built[:16])}")
        failed += 1

for name in hardware:
    print(f"  HW   {name}")

print(f"\n{passed} passed, {failed} failed, {len(hardware)} hardware, {len(entries) + len(hardware)} total")
