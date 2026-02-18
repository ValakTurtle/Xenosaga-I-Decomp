#!/usr/bin/env python3
"""Verify decompiled C functions match the original ELF."""
import subprocess, sys, re, glob

ELF = "elf/SLUS_204.69"
BUILT = "build/src"
OBJDUMP = "/usr/local/ps2dev/ee/bin/mips64r5900el-ps2-elf-objdump"
CC_OBJDUMP = "mipsel-linux-gnu-objdump"


def get_words(cmd):
    """Extract instruction words from objdump output."""
    result = subprocess.run(cmd, capture_output=True, text=True)
    words = []
    for line in result.stdout.split('\n'):
        # Match lines like: "  20b1d8:    8c820000    lw v0,0(a0)"
        m = re.match(r'\s+[0-9a-f]+:\s+([0-9a-f]{8})\b', line)
        if m:
            words.append(m.group(1))
    return words


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
    # Find which .o file contains this function
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

    orig = get_words([OBJDUMP, "-d", "-j", ".text",
                      f"--start-address=0x{addr:x}",
                      f"--stop-address=0x{end:x}", ELF])

    # For the C object, we need to find the function's offset
    # Get the symbol's offset in the .o file
    sym_result = subprocess.run(
        [CC_OBJDUMP, "-t", obj], capture_output=True, text=True
    )
    func_addr = None
    for line in sym_result.stdout.split('\n'):
        if f" {name}\n" in line or line.endswith(f" {name}"):
            m2 = re.match(r'([0-9a-f]+)', line)
            if m2:
                func_addr = int(m2.group(1), 16)
                break

    if func_addr is None:
        print(f"  SKIP {name} - can't find symbol offset")
        continue

    func_end = func_addr + size
    built = get_words([CC_OBJDUMP, "-d",
                       f"--start-address=0x{func_addr:x}",
                       f"--stop-address=0x{func_end:x}", obj])

    if not orig:
        print(f"  SKIP {name} - no original bytes found")
        continue

    if orig == built:
        print(f"  OK   {name}")
        passed += 1
    else:
        print(f"  FAIL {name}")
        print(f"    orig:  {' '.join(orig[:8])}")
        print(f"    built: {' '.join(built[:8])}")
        failed += 1

for name in hardware:
    print(f"  HW   {name}")

print(f"\n{passed} passed, {failed} failed, {len(hardware)} hardware, {len(entries) + len(hardware)} total")
