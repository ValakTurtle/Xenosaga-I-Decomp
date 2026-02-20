
glabel sceVif1PkCnt
    /* ACF8 0020ACF8 D0FFBD27 */  addiu      $29, $29, -0x30
    /* ACFC 0020ACFC 1000B1FF */  sd         $17, 0x10($29)
    /* AD00 0020AD00 2D888000 */  daddu      $17, $4, $0
    /* AD04 0020AD04 0000B0FF */  sd         $16, 0x0($29)
    /* AD08 0020AD08 2000BFFF */  sd         $31, 0x20($29)
    /* AD0C 0020AD0C 222B080C */  jal        sceVif1PkTerminate
    /* AD10 0020AD10 2D80A000 */   daddu     $16, $5, $0
    /* AD14 0020AD14 0000248E */  lw         $4, 0x0($17)
    /* AD18 0020AD18 0010033C */  lui        $3, (0x10000000 >> 16)
    /* AD1C 0020AD1C 25800302 */  or         $16, $16, $3
    /* AD20 0020AD20 080022AE */  sw         $2, 0x8($17)
    /* AD24 0020AD24 000090AC */  sw         $16, 0x0($4)
    /* AD28 0020AD28 04008424 */  addiu      $4, $4, 0x4
    /* AD2C 0020AD2C 0C0020AE */  sw         $0, 0xC($17)
    /* AD30 0020AD30 04008224 */  addiu      $2, $4, 0x4
    /* AD34 0020AD34 2000BFDF */  ld         $31, 0x20($29)
    /* AD38 0020AD38 000022AE */  sw         $2, 0x0($17)
    /* AD3C 0020AD3C 1000B1DF */  ld         $17, 0x10($29)
    /* AD40 0020AD40 0000B0DF */  ld         $16, 0x0($29)
    /* AD44 0020AD44 000080AC */  sw         $0, 0x0($4)
    /* AD48 0020AD48 0800E003 */  jr         $31
    /* AD4C 0020AD4C 3000BD27 */   addiu     $29, $29, 0x30
endlabel sceVif1PkCnt
