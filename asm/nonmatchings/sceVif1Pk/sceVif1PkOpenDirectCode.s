
glabel sceVif1PkOpenDirectCode
    /* AF28 0020AF28 D0FFBD27 */  addiu      $29, $29, -0x30
    /* AF2C 0020AF2C 03000624 */  addiu      $6, $0, 0x3
    /* AF30 0020AF30 1000B1FF */  sd         $17, 0x10($29)
    /* AF34 0020AF34 0000B0FF */  sd         $16, 0x0($29)
    /* AF38 0020AF38 2D88A000 */  daddu      $17, $5, $0
    /* AF3C 0020AF3C 2D808000 */  daddu      $16, $4, $0
    /* AF40 0020AF40 2000BFFF */  sd         $31, 0x20($29)
    /* AF44 0020AF44 222C080C */  jal        sceVif1PkAlign
    /* AF48 0020AF48 02000524 */   addiu     $5, $0, 0x2
    /* AF4C 0020AF4C 0000058E */  lw         $5, 0x0($16)
    /* AF50 0020AF50 00D0023C */  lui        $2, (0xD0000000 >> 16)
    /* AF54 0020AF54 0050043C */  lui        $4, (0x50000000 >> 16)
    /* AF58 0020AF58 2000BFDF */  ld         $31, 0x20($29)
    /* AF5C 0020AF5C 0400A324 */  addiu      $3, $5, 0x4
    /* AF60 0020AF60 0B205100 */  movn       $4, $2, $17
    /* AF64 0020AF64 000003AE */  sw         $3, 0x0($16)
    /* AF68 0020AF68 0C0005AE */  sw         $5, 0xC($16)
    /* AF6C 0020AF6C 1000B1DF */  ld         $17, 0x10($29)
    /* AF70 0020AF70 0000B0DF */  ld         $16, 0x0($29)
    /* AF74 0020AF74 0000A4AC */  sw         $4, 0x0($5)
    /* AF78 0020AF78 0800E003 */  jr         $31
    /* AF7C 0020AF7C 3000BD27 */   addiu     $29, $29, 0x30
endlabel sceVif1PkOpenDirectCode
