
glabel sceVif1PkEnd
    /* ADE8 0020ADE8 D0FFBD27 */  addiu      $29, $29, -0x30
    /* ADEC 0020ADEC 1000B1FF */  sd         $17, 0x10($29)
    /* ADF0 0020ADF0 2D888000 */  daddu      $17, $4, $0
    /* ADF4 0020ADF4 0000B0FF */  sd         $16, 0x0($29)
    /* ADF8 0020ADF8 2000BFFF */  sd         $31, 0x20($29)
    /* ADFC 0020ADFC 222B080C */  jal        sceVif1PkTerminate
    /* AE00 0020AE00 2D80A000 */   daddu     $16, $5, $0
    /* AE04 0020AE04 0000248E */  lw         $4, 0x0($17)
    /* AE08 0020AE08 0070033C */  lui        $3, (0x70000000 >> 16)
    /* AE0C 0020AE0C 25800302 */  or         $16, $16, $3
    /* AE10 0020AE10 080022AE */  sw         $2, 0x8($17)
    /* AE14 0020AE14 000090AC */  sw         $16, 0x0($4)
    /* AE18 0020AE18 04008424 */  addiu      $4, $4, 0x4
    /* AE1C 0020AE1C 0C0020AE */  sw         $0, 0xC($17)
    /* AE20 0020AE20 04008224 */  addiu      $2, $4, 0x4
    /* AE24 0020AE24 2000BFDF */  ld         $31, 0x20($29)
    /* AE28 0020AE28 000022AE */  sw         $2, 0x0($17)
    /* AE2C 0020AE2C 1000B1DF */  ld         $17, 0x10($29)
    /* AE30 0020AE30 0000B0DF */  ld         $16, 0x0($29)
    /* AE34 0020AE34 000080AC */  sw         $0, 0x0($4)
    /* AE38 0020AE38 0800E003 */  jr         $31
    /* AE3C 0020AE3C 3000BD27 */   addiu     $29, $29, 0x30
endlabel sceVif1PkEnd
