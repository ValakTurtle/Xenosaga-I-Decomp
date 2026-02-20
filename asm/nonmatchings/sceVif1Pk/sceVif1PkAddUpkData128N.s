
glabel sceVif1PkAddUpkData128N
    /* B478 0020B478 2D508000 */  daddu      $10, $4, $0
    /* B47C 0020B47C 2D38A000 */  daddu      $7, $5, $0
    /* B480 0020B480 1800C010 */  beqz       $6, .L0020B4E4
    /* B484 0020B484 FFFFC824 */   addiu     $8, $6, -0x1
    /* B488 0020B488 FFFF093C */  lui        $9, (0xFFFFFFFF >> 16)
    /* B48C 0020B48C 0000468D */  lw         $6, 0x0($10)
    /* B490 0020B490 FFFF2935 */  ori        $9, $9, (0xFFFFFFFF & 0xFFFF)
    /* B494 0020B494 00000000 */  nop
  .L0020B498:
    /* B498 0020B498 0000E3DC */  ld         $3, 0x0($7)
    /* B49C 0020B49C FFFF0825 */  addiu      $8, $8, -0x1
    /* B4A0 0020B4A0 0800E4DC */  ld         $4, 0x8($7)
    /* B4A4 0020B4A4 3C100300 */  dsll32     $2, $3, 0
    /* B4A8 0020B4A8 3F100200 */  dsra32     $2, $2, 0
    /* B4AC 0020B4AC 1000E724 */  addiu      $7, $7, 0x10
    /* B4B0 0020B4B0 0000C2AC */  sw         $2, 0x0($6)
    /* B4B4 0020B4B4 3F280400 */  dsra32     $5, $4, 0
    /* B4B8 0020B4B8 0400C624 */  addiu      $6, $6, 0x4
    /* B4BC 0020B4BC 3F180300 */  dsra32     $3, $3, 0
    /* B4C0 0020B4C0 2D10C000 */  daddu      $2, $6, $0
    /* B4C4 0020B4C4 3C200400 */  dsll32     $4, $4, 0
    /* B4C8 0020B4C8 3F200400 */  dsra32     $4, $4, 0
    /* B4CC 0020B4CC 000043AC */  sw         $3, 0x0($2)
    /* B4D0 0020B4D0 0C004624 */  addiu      $6, $2, 0xC
    /* B4D4 0020B4D4 040044AC */  sw         $4, 0x4($2)
    /* B4D8 0020B4D8 EFFF0915 */  bne        $8, $9, .L0020B498
    /* B4DC 0020B4DC 080045AC */   sw        $5, 0x8($2)
    /* B4E0 0020B4E0 000046AD */  sw         $6, 0x0($10)
  .L0020B4E4:
    /* B4E4 0020B4E4 0800E003 */  jr         $31
    /* B4E8 0020B4E8 00000000 */   nop
endlabel sceVif1PkAddUpkData128N
    /* B4EC 0020B4EC 00000000 */  nop
