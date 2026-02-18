#!/bin/bash
# Two-step compile: .c -> .s (with move->daddu fix) -> .o
# Usage: ee-cc.sh <gcc> <as> <cflags...> -o output input

GCC="$1"; shift
AS="$1"; shift

# Assembler flags for C-compiled code (need eabi for 64-bit sd/ld)
CC_ASFLAGS="-march=r5900 -mabi=eabi -Iinclude --no-warn"

# Collect args, find -o and input
ARGS=()
OUTPUT=""
while [ $# -gt 0 ]; do
    if [ "$1" = "-o" ]; then
        OUTPUT="$2"
        shift 2
    elif [ "$1" = "-c" ]; then
        shift  # skip -c, we use -S instead
    else
        ARGS+=("$1")
        shift
    fi
done

# Last arg is input file
INPUT="${ARGS[-1]}"
unset 'ARGS[-1]'

# Step 1: compile to assembly
$GCC "${ARGS[@]}" -S -o "${OUTPUT}.s" "$INPUT" || exit 1

# Step 2: fix move -> daddu
sed -i 's/\tmove\t\(\$[0-9]*\),\(\$[0-9]*\)/\tdaddu\t\1,\2,$0/' "${OUTPUT}.s"

# Step 3: assemble with eabi flags
$AS $CC_ASFLAGS -o "$OUTPUT" "${OUTPUT}.s" || exit 1
