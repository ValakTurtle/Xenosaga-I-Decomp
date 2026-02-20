
glabel sceVif1PkAddCode
    /* B108 0020B108 0000828C */  lw         $2, 0x0($4)
    /* B10C 0020B10C 000045AC */  sw         $5, 0x0($2)
    /* B110 0020B110 04004224 */  addiu      $2, $2, 0x4
    /* B114 0020B114 0800E003 */  jr         $31
    /* B118 0020B118 000082AC */   sw        $2, 0x0($4)
endlabel sceVif1PkAddCode
    /* B11C 0020B11C 00000000 */  nop
