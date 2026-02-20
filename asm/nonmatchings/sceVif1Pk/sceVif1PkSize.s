
glabel sceVif1PkSize
    /* ACE0 0020ACE0 0400838C */  lw         $3, 0x4($4)
    /* ACE4 0020ACE4 0000828C */  lw         $2, 0x0($4)
    /* ACE8 0020ACE8 23104300 */  subu       $2, $2, $3
    /* ACEC 0020ACEC 0800E003 */  jr         $31
    /* ACF0 0020ACF0 02110200 */   srl       $2, $2, 4
endlabel sceVif1PkSize
    /* ACF4 0020ACF4 00000000 */  nop
