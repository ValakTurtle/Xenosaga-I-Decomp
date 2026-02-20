
glabel sceVif1PkAddGsData
    /* B1B0 0020B1B0 0000828C */  lw         $2, 0x0($4)
    /* B1B4 0020B1B4 3C180500 */  dsll32     $3, $5, 0
    /* B1B8 0020B1B8 3F180300 */  dsra32     $3, $3, 0
    /* B1BC 0020B1BC 3F280500 */  dsra32     $5, $5, 0
    /* B1C0 0020B1C0 000043AC */  sw         $3, 0x0($2)
    /* B1C4 0020B1C4 04004224 */  addiu      $2, $2, 0x4
    /* B1C8 0020B1C8 04004324 */  addiu      $3, $2, 0x4
    /* B1CC 0020B1CC 000045AC */  sw         $5, 0x0($2)
    /* B1D0 0020B1D0 0800E003 */  jr         $31
    /* B1D4 0020B1D4 000083AC */   sw        $3, 0x0($4)
endlabel sceVif1PkAddGsData
