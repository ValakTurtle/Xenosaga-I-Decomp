
glabel sceVif1PkReserve
    /* B070 0020B070 0000828C */  lw         $2, 0x0($4)
    /* B074 0020B074 80280500 */  sll        $5, $5, 2
    /* B078 0020B078 21284500 */  addu       $5, $2, $5
    /* B07C 0020B07C 0800E003 */  jr         $31
    /* B080 0020B080 000085AC */   sw        $5, 0x0($4)
endlabel sceVif1PkReserve
    /* B084 0020B084 00000000 */  nop
