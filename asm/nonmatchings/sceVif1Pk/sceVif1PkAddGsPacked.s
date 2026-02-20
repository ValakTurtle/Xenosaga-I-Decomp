
glabel sceVif1PkAddGsPacked
    /* B568 0020B568 0000828C */  lw         $2, 0x0($4)
    /* B56C 0020B56C 10004324 */  addiu      $3, $2, 0x10
    /* B570 0020B570 0000457C */  sq         $5, 0x0($2)
    /* B574 0020B574 0800E003 */  jr         $31
    /* B578 0020B578 000083AC */   sw        $3, 0x0($4)
endlabel sceVif1PkAddGsPacked
