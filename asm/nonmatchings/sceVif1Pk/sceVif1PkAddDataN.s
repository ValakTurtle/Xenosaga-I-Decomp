
glabel sceVif1PkAddDataN
    /* B120 0020B120 0D00C010 */  beqz       $6, .L0020B158
    /* B124 0020B124 FFFFC724 */   addiu     $7, $6, -0x1
    /* B128 0020B128 FFFF063C */  lui        $6, (0xFFFFFFFF >> 16)
    /* B12C 0020B12C 0000838C */  lw         $3, 0x0($4)
    /* B130 0020B130 FFFFC634 */  ori        $6, $6, (0xFFFFFFFF & 0xFFFF)
    /* B134 0020B134 00000000 */  nop
  .L0020B138:
    /* B138 0020B138 0000A28C */  lw         $2, 0x0($5)
    /* B13C 0020B13C FFFFE724 */  addiu      $7, $7, -0x1
    /* B140 0020B140 0400A524 */  addiu      $5, $5, 0x4
    /* B144 0020B144 000062AC */  sw         $2, 0x0($3)
    /* B148 0020B148 04006324 */  addiu      $3, $3, 0x4
    /* B14C 0020B14C FAFFE614 */  bne        $7, $6, .L0020B138
    /* B150 0020B150 00000000 */   nop
    /* B154 0020B154 000083AC */  sw         $3, 0x0($4)
  .L0020B158:
    /* B158 0020B158 0800E003 */  jr         $31
    /* B15C 0020B15C 00000000 */   nop
endlabel sceVif1PkAddDataN
