#!/usr/bin/env python3
"""Extract symbols from the original ELF into Splat's symbol_addrs.txt format."""
import subprocess

result = subprocess.run(
    ["/usr/local/ps2dev/ee/bin/mips64r5900el-ps2-elf-nm", "iso/SLUS_204.69"],
    capture_output=True, text=True
)

skip_prefixes = ['$', '.']
entries = []

for line in result.stdout.strip().split('\n'):
    parts = line.split()
    if len(parts) != 3:
        continue
    addr, typ, name = parts
    if any(name.startswith(s) for s in skip_prefixes):
        continue
    if typ in ('a', 'A'):
        continue
    entries.append((addr.upper(), typ, name))

# One symbol per address, prefer global (uppercase type) over local
addr_map = {}  # addr -> (name, typ)
for addr, typ, name in entries:
    if addr not in addr_map:
        addr_map[addr] = (name, typ)
    elif typ.isupper() and not addr_map[addr][1].isupper():
        addr_map[addr] = (name, typ)

# Now ensure unique names - if same name at different addrs, suffix with addr
name_count = {}
for addr, (name, typ) in addr_map.items():
    name_count[name] = name_count.get(name, 0) + 1

used_names = set()
lines = []
for addr, (name, typ) in sorted(addr_map.items()):
    out_name = name
    if name_count[name] > 1:
        out_name = f"{name}_{addr}"
    if out_name in used_names:
        continue
    used_names.add(out_name)

    if typ in ('T', 't'):
        lines.append(f"{out_name} = 0x{addr}; // type:func")
    else:
        lines.append(f"{out_name} = 0x{addr};")

with open("config/symbol_addrs.txt", "w") as f:
    f.write('\n'.join(lines) + '\n')

print(f"Wrote {len(lines)} symbols to config/symbol_addrs.txt")
