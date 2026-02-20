
glabel sceVif1PkReset
    /* AC78 0020AC78 0400828C */  lw         $2, 0x4($4)
    /* AC7C 0020AC7C 080080AC */  sw         $0, 0x8($4)
    /* AC80 0020AC80 0800E003 */  jr         $31
    /* AC84 0020AC84 000082AC */   sw        $2, 0x0($4)
endlabel sceVif1PkReset
