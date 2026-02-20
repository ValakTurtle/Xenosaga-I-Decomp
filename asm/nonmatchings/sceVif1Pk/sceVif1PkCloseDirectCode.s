
glabel sceVif1PkCloseDirectCode
    /* AF80 0020AF80 0000828C */  lw         $2, 0x0($4)
    /* AF84 0020AF84 0C00858C */  lw         $5, 0xC($4)
    /* AF88 0020AF88 FCFF4224 */  addiu      $2, $2, -0x4
    /* AF8C 0020AF8C 0C0080AC */  sw         $0, 0xC($4)
    /* AF90 0020AF90 23104500 */  subu       $2, $2, $5
    /* AF94 0020AF94 0000A38C */  lw         $3, 0x0($5)
    /* AF98 0020AF98 83100200 */  sra        $2, $2, 2
    /* AF9C 0020AF9C 82100200 */  srl        $2, $2, 2
    /* AFA0 0020AFA0 21186200 */  addu       $3, $3, $2
    /* AFA4 0020AFA4 0800E003 */  jr         $31
    /* AFA8 0020AFA8 0000A3AC */   sw        $3, 0x0($5)
endlabel sceVif1PkCloseDirectCode
    /* AFAC 0020AFAC 00000000 */  nop
