
glabel sceVif1PkTerminate
    /* AC88 0020AC88 0000858C */  lw         $5, 0x0($4)
    /* AC8C 0020AC8C 0C00A230 */  andi       $2, $5, 0xC
    /* AC90 0020AC90 08004010 */  beqz       $2, .L0020ACB4
    /* AC94 0020AC94 0800868C */   lw        $6, 0x8($4)
  .L0020AC98:
    /* AC98 0020AC98 0000A0AC */  sw         $0, 0x0($5)
    /* AC9C 0020AC9C 0400A524 */  addiu      $5, $5, 0x4
    /* ACA0 0020ACA0 0C00A230 */  andi       $2, $5, 0xC
    /* ACA4 0020ACA4 00000000 */  nop
    /* ACA8 0020ACA8 00000000 */  nop
    /* ACAC 0020ACAC FAFF4014 */  bnez       $2, .L0020AC98
    /* ACB0 0020ACB0 00000000 */   nop
  .L0020ACB4:
    /* ACB4 0020ACB4 0600C010 */  beqz       $6, .L0020ACD0
    /* ACB8 0020ACB8 2310A600 */   subu      $2, $5, $6
    /* ACBC 0020ACBC 0000C38C */  lw         $3, 0x0($6)
    /* ACC0 0020ACC0 03110200 */  sra        $2, $2, 4
    /* ACC4 0020ACC4 FFFF4224 */  addiu      $2, $2, -0x1
    /* ACC8 0020ACC8 21186200 */  addu       $3, $3, $2
    /* ACCC 0020ACCC 0000C3AC */  sw         $3, 0x0($6)
  .L0020ACD0:
    /* ACD0 0020ACD0 080080AC */  sw         $0, 0x8($4)
    /* ACD4 0020ACD4 2D10A000 */  daddu      $2, $5, $0
    /* ACD8 0020ACD8 0800E003 */  jr         $31
    /* ACDC 0020ACDC 000085AC */   sw        $5, 0x0($4)
endlabel sceVif1PkTerminate
