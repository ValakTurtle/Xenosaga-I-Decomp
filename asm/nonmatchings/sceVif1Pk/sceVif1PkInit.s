
glabel sceVif1PkInit
    /* AC68 0020AC68 000085AC */  sw         $5, 0x0($4)
    /* AC6C 0020AC6C 080080AC */  sw         $0, 0x8($4)
    /* AC70 0020AC70 0800E003 */  jr         $31
    /* AC74 0020AC74 040085AC */   sw        $5, 0x4($4)
endlabel sceVif1PkInit
