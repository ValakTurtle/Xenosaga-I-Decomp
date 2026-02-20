#ifndef COMMON_H
#define COMMON_H

asm(".include \"macro.inc\"");

#define INCLUDE_ASM(dir, func) \
    asm( \
        ".set noreorder\n" \
        ".set noat\n" \
        ".include \"" dir "/" #func ".s\"\n" \
        ".set at\n" \
        ".set reorder\n" \
    );

#endif
