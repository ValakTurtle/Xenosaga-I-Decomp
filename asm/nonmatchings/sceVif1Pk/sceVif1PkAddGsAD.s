
glabel sceVif1PkAddGsAD
    /* B1D8 0020B1D8 0000828C */  lw         $2, 0x0($4)
    /* B1DC 0020B1DC 3C180600 */  dsll32     $3, $6, 0
    /* B1E0 0020B1E0 3F180300 */  dsra32     $3, $3, 0
    /* B1E4 0020B1E4 3F300600 */  dsra32     $6, $6, 0
    /* B1E8 0020B1E8 000043AC */  sw         $3, 0x0($2)
    /* B1EC 0020B1EC 04004224 */  addiu      $2, $2, 0x4
    /* B1F0 0020B1F0 0C004324 */  addiu      $3, $2, 0xC
    /* B1F4 0020B1F4 000046AC */  sw         $6, 0x0($2)
    /* B1F8 0020B1F8 000083AC */  sw         $3, 0x0($4)
    /* B1FC 0020B1FC 040045AC */  sw         $5, 0x4($2)
    /* B200 0020B200 0800E003 */  jr         $31
    /* B204 0020B204 080040AC */   sw        $0, 0x8($2)
endlabel sceVif1PkAddGsAD
