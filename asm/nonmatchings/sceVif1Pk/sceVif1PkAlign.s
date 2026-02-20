
glabel sceVif1PkAlign
    /* B088 0020B088 0200A524 */  addiu      $5, $5, 0x2
    /* B08C 0020B08C 20000324 */  addiu      $3, $0, 0x20
    /* B090 0020B090 1F00A530 */  andi       $5, $5, 0x1F
    /* B094 0020B094 FFFF023C */  lui        $2, (0xFFFFFFFF >> 16)
    /* B098 0020B098 23186500 */  subu       $3, $3, $5
    /* B09C 0020B09C FFFF4234 */  ori        $2, $2, (0xFFFFFFFF & 0xFFFF)
    /* B0A0 0020B0A0 0000858C */  lw         $5, 0x0($4)
    /* B0A4 0020B0A4 06386200 */  srlv       $7, $2, $3
    /* B0A8 0020B0A8 27100700 */  nor        $2, $0, $7
    /* B0AC 0020B0AC 80300600 */  sll        $6, $6, 2
    /* B0B0 0020B0B0 2410A200 */  and        $2, $5, $2
    /* B0B4 0020B0B4 21304600 */  addu       $6, $2, $6
    /* B0B8 0020B0B8 2B18C500 */  sltu       $3, $6, $5
    /* B0BC 0020B0BC 02006010 */  beqz       $3, .L0020B0C8
    /* B0C0 0020B0C0 0100C224 */   addiu     $2, $6, 0x1
    /* B0C4 0020B0C4 21304700 */  addu       $6, $2, $7
  .L0020B0C8:
    /* B0C8 0020B0C8 2B10A600 */  sltu       $2, $5, $6
    /* B0CC 0020B0CC 0B004010 */  beqz       $2, .L0020B0FC
    /* B0D0 0020B0D0 0400A324 */   addiu     $3, $5, 0x4
    /* B0D4 0020B0D4 05000010 */  b          .L0020B0EC
    /* B0D8 0020B0D8 0000A0AC */   sw        $0, 0x0($5)
    /* B0DC 0020B0DC 00000000 */  nop
  .L0020B0E0:
    /* B0E0 0020B0E0 2D286000 */  daddu      $5, $3, $0
    /* B0E4 0020B0E4 0400A324 */  addiu      $3, $5, 0x4
    /* B0E8 0020B0E8 0000A0AC */  sw         $0, 0x0($5)
  .L0020B0EC:
    /* B0EC 0020B0EC 000083AC */  sw         $3, 0x0($4)
    /* B0F0 0020B0F0 2B106600 */  sltu       $2, $3, $6
    /* B0F4 0020B0F4 FAFF4014 */  bnez       $2, .L0020B0E0
    /* B0F8 0020B0F8 00000000 */   nop
  .L0020B0FC:
    /* B0FC 0020B0FC 0800E003 */  jr         $31
    /* B100 0020B100 00000000 */   nop
endlabel sceVif1PkAlign
    /* B104 0020B104 00000000 */  nop
