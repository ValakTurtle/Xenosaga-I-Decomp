
glabel sceVif1PkCloseDirectHLCode
    /* B448 0020B448 0000828C */  lw         $2, 0x0($4)
    /* B44C 0020B44C 0C00858C */  lw         $5, 0xC($4)
    /* B450 0020B450 FCFF4224 */  addiu      $2, $2, -0x4
    /* B454 0020B454 0C0080AC */  sw         $0, 0xC($4)
    /* B458 0020B458 23104500 */  subu       $2, $2, $5
    /* B45C 0020B45C 0000A38C */  lw         $3, 0x0($5)
    /* B460 0020B460 83100200 */  sra        $2, $2, 2
    /* B464 0020B464 82100200 */  srl        $2, $2, 2
    /* B468 0020B468 21186200 */  addu       $3, $3, $2
    /* B46C 0020B46C 0800E003 */  jr         $31
    /* B470 0020B470 0000A3AC */   sw        $3, 0x0($5)
endlabel sceVif1PkCloseDirectHLCode
    /* B474 0020B474 00000000 */  nop
