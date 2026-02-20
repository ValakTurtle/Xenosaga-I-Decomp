
glabel sceVif1PkCloseUpkCode
    /* AED0 0020AED0 0000828C */  lw         $2, 0x0($4)
    /* AED4 0020AED4 FFFF033C */  lui        $3, (0xFFFF0000 >> 16)
    /* AED8 0020AED8 0C00878C */  lw         $7, 0xC($4)
    /* AEDC 0020AEDC FCFF4224 */  addiu      $2, $2, -0x4
    /* AEE0 0020AEE0 1000868C */  lw         $6, 0x10($4)
    /* AEE4 0020AEE4 23104700 */  subu       $2, $2, $7
    /* AEE8 0020AEE8 83100200 */  sra        $2, $2, 2
    /* AEEC 0020AEEC FFFFC530 */  andi       $5, $6, 0xFFFF
    /* AEF0 0020AEF0 40110200 */  sll        $2, $2, 5
    /* AEF4 0020AEF4 2430C300 */  and        $6, $6, $3
    /* AEF8 0020AEF8 21104500 */  addu       $2, $2, $5
    /* AEFC 0020AEFC 0100A050 */  beql       $5, $0, .L0020AF04
    /* AF00 0020AF00 CD010000 */   break     0, 7
  .L0020AF04:
    /* AF04 0020AF04 FFFF4224 */  addiu      $2, $2, -0x1
    /* AF08 0020AF08 0000E38C */  lw         $3, 0x0($7)
    /* AF0C 0020AF0C 1B004500 */  divu       $0, $2, $5
    /* AF10 0020AF10 0C0080AC */  sw         $0, 0xC($4)
    /* AF14 0020AF14 12100000 */  mflo       $2
    /* AF18 0020AF18 1830C200 */  mult       $6, $6, $2
    /* AF1C 0020AF1C 21186600 */  addu       $3, $3, $6
    /* AF20 0020AF20 0800E003 */  jr         $31
    /* AF24 0020AF24 0000E3AC */   sw        $3, 0x0($7)
endlabel sceVif1PkCloseUpkCode
