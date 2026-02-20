
glabel sceVif1PkRef
    /* AD50 0020AD50 90FFBD27 */  addiu      $29, $29, -0x70
    /* AD54 0020AD54 3000B3FF */  sd         $19, 0x30($29)
    /* AD58 0020AD58 2D988000 */  daddu      $19, $4, $0
    /* AD5C 0020AD5C 5000B5FF */  sd         $21, 0x50($29)
    /* AD60 0020AD60 4000B4FF */  sd         $20, 0x40($29)
    /* AD64 0020AD64 2DA80001 */  daddu      $21, $8, $0
    /* AD68 0020AD68 2000B2FF */  sd         $18, 0x20($29)
    /* AD6C 0020AD6C 2DA0E000 */  daddu      $20, $7, $0
    /* AD70 0020AD70 1000B1FF */  sd         $17, 0x10($29)
    /* AD74 0020AD74 2D90A000 */  daddu      $18, $5, $0
    /* AD78 0020AD78 0000B0FF */  sd         $16, 0x0($29)
    /* AD7C 0020AD7C 2D88C000 */  daddu      $17, $6, $0
    /* AD80 0020AD80 6000BFFF */  sd         $31, 0x60($29)
    /* AD84 0020AD84 222B080C */  jal        sceVif1PkTerminate
    /* AD88 0020AD88 2D802001 */   daddu     $16, $9, $0
    /* AD8C 0020AD8C 0030043C */  lui        $4, (0x30000000 >> 16)
    /* AD90 0020AD90 0000628E */  lw         $2, 0x0($19)
    /* AD94 0020AD94 25882402 */  or         $17, $17, $4
    /* AD98 0020AD98 FF9F033C */  lui        $3, (0x9FFFFFFF >> 16)
    /* AD9C 0020AD9C 25801102 */  or         $16, $16, $17
    /* ADA0 0020ADA0 FFFF6334 */  ori        $3, $3, (0x9FFFFFFF & 0xFFFF)
    /* ADA4 0020ADA4 000050AC */  sw         $16, 0x0($2)
    /* ADA8 0020ADA8 24904302 */  and        $18, $18, $3
    /* ADAC 0020ADAC 04004224 */  addiu      $2, $2, 0x4
    /* ADB0 0020ADB0 6000BFDF */  ld         $31, 0x60($29)
    /* ADB4 0020ADB4 0C004324 */  addiu      $3, $2, 0xC
    /* ADB8 0020ADB8 000052AC */  sw         $18, 0x0($2)
    /* ADBC 0020ADBC 000063AE */  sw         $3, 0x0($19)
    /* ADC0 0020ADC0 040054AC */  sw         $20, 0x4($2)
    /* ADC4 0020ADC4 080055AC */  sw         $21, 0x8($2)
    /* ADC8 0020ADC8 5000B5DF */  ld         $21, 0x50($29)
    /* ADCC 0020ADCC 4000B4DF */  ld         $20, 0x40($29)
    /* ADD0 0020ADD0 3000B3DF */  ld         $19, 0x30($29)
    /* ADD4 0020ADD4 2000B2DF */  ld         $18, 0x20($29)
    /* ADD8 0020ADD8 1000B1DF */  ld         $17, 0x10($29)
    /* ADDC 0020ADDC 0000B0DF */  ld         $16, 0x0($29)
    /* ADE0 0020ADE0 0800E003 */  jr         $31
    /* ADE4 0020ADE4 7000BD27 */   addiu     $29, $29, 0x70
endlabel sceVif1PkRef
