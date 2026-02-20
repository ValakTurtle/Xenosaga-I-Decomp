
glabel sceVif1PkOpenGifTag
    /* AFB0 0020AFB0 0000828C */  lw         $2, 0x0($4)
    /* AFB4 0020AFB4 10004324 */  addiu      $3, $2, 0x10
    /* AFB8 0020AFB8 0000457C */  sq         $5, 0x0($2)
    /* AFBC 0020AFBC 000083AC */  sw         $3, 0x0($4)
    /* AFC0 0020AFC0 0800E003 */  jr         $31
    /* AFC4 0020AFC4 140082AC */   sw        $2, 0x14($4)
endlabel sceVif1PkOpenGifTag
