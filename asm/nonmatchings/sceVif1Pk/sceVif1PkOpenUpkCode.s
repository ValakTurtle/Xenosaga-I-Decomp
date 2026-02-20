
glabel sceVif1PkOpenUpkCode
    /* AE40 0020AE40 2D688000 */  daddu      $13, $4, $0
    /* AE44 0020AE44 0001033C */  lui        $3, (0x1000000 >> 16)
    /* AE48 0020AE48 0000A98D */  lw         $9, 0x0($13)
    /* AE4C 0020AE4C 2518E300 */  or         $3, $7, $3
    /* AE50 0020AE50 00120800 */  sll        $2, $8, 8
    /* AE54 0020AE54 82200600 */  srl        $4, $6, 2
    /* AE58 0020AE58 25104300 */  or         $2, $2, $3
    /* AE5C 0020AE5C 00010A24 */  addiu      $10, $0, 0x100
    /* AE60 0020AE60 000022AD */  sw         $2, 0x0($9)
    /* AE64 0020AE64 001E0600 */  sll        $3, $6, 24
    /* AE68 0020AE68 FFFFA530 */  andi       $5, $5, 0xFFFF
    /* AE6C 0020AE6C 03008430 */  andi       $4, $4, 0x3
    /* AE70 0020AE70 0300C630 */  andi       $6, $6, 0x3
    /* AE74 0020AE74 20000224 */  addiu      $2, $0, 0x20
    /* AE78 0020AE78 04002925 */  addiu      $9, $9, 0x4
    /* AE7C 0020AE7C 2D604001 */  daddu      $12, $10, $0
    /* AE80 0020AE80 2D584001 */  daddu      $11, $10, $0
    /* AE84 0020AE84 25186500 */  or         $3, $3, $5
    /* AE88 0020AE88 0710C200 */  srav       $2, $2, $6
    /* AE8C 0020AE8C 01008424 */  addiu      $4, $4, 0x1
    /* AE90 0020AE90 04002525 */  addiu      $5, $9, 0x4
    /* AE94 0020AE94 0B58E700 */  movn       $11, $7, $7
    /* AE98 0020AE98 0B600801 */  movn       $12, $8, $8
    /* AE9C 0020AE9C 18504400 */  mult       $10, $2, $4
    /* AEA0 0020AEA0 000023AD */  sw         $3, 0x0($9)
    /* AEA4 0020AEA4 2B106C01 */  sltu       $2, $11, $12
    /* AEA8 0020AEA8 0000A5AD */  sw         $5, 0x0($13)
    /* AEAC 0020AEAC 03004014 */  bnez       $2, .L0020AEBC
    /* AEB0 0020AEB0 0C00A9AD */   sw        $9, 0xC($13)
    /* AEB4 0020AEB4 03000010 */  b          .L0020AEC4
    /* AEB8 0020AEB8 0100023C */   lui       $2, (0x10000 >> 16)
  .L0020AEBC:
    /* AEBC 0020AEBC 18504B01 */  mult       $10, $10, $11
    /* AEC0 0020AEC0 00140C00 */  sll        $2, $12, 16
  .L0020AEC4:
    /* AEC4 0020AEC4 25104A00 */  or         $2, $2, $10
    /* AEC8 0020AEC8 0800E003 */  jr         $31
    /* AECC 0020AECC 1000A2AD */   sw        $2, 0x10($13)
endlabel sceVif1PkOpenUpkCode
