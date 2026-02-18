/* VIF1 packet builder structure (matches PS2 assembly layout) */
typedef struct Vif1Packet
{
    unsigned int *current;   /* 0x00 - current write pointer */
    unsigned int *base;      /* 0x04 - base/start pointer */
    unsigned int  reserved;  /* 0x08 - state / unused */
    unsigned int *openDirect;  /* 0x0C */
    unsigned int  unk1;      /* 0x10 */
    unsigned int *openGif;   /* 0x14 - pointer to open GIF tag */
} Vif1Packet;


/* Initialize a VIF1 packet builder */
void sceVif1PkInit(Vif1Packet *pkt, unsigned int *buffer)
{
    pkt->current  = buffer;
    pkt->base     = buffer;
    pkt->reserved = 0;
}

/* Reset packet write pointer to base */
void sceVif1PkReset(Vif1Packet *pkt)
{
    pkt->reserved = 0;
    pkt->current  = pkt->base;
}

/* Append a single 32-bit value to the packet */
void sceVif1PkAddCode(Vif1Packet *pkt, unsigned int value)
{
    *pkt->current = value;
    pkt->current++;
}

/* Return number of 16-byte quadwords written */
unsigned int sceVif1PkSize(Vif1Packet *pkt)
{
    return ((unsigned char*)pkt->current -
            (unsigned char*)pkt->base) >> 4;
}

/* Reserve space for a number of 32-bit values */
void sceVif1PkReserve(Vif1Packet *pkt, unsigned int count)
{
    pkt->current += count;
}

/* Append a 64-bit GS data value (written as two 32-bit words) */
void sceVif1PkAddGsData(Vif1Packet *pkt, unsigned long long value)
{
    unsigned int *dest = pkt->current;

    dest[0] = (unsigned int)value;          /* low 32 bits */
    dest[1] = (unsigned int)(value >> 32);  /* high 32 bits */

    pkt->current += 2;  /* advance by 8 bytes */
}

/* Close a previously opened DIRECT code and patch its size */
void sceVif1PkCloseDirectCode(Vif1Packet *pkt)
{
    unsigned int *current = pkt->current;
    unsigned int *open    = pkt->openDirect;

    current -= 1;                 /* exclude last word */
    pkt->openDirect = 0;          /* clear open state */

    open[0] += (unsigned int)(current - open);
}

/* Close a previously opened DIRECT HL code and patch its size */
void sceVif1PkCloseDirectHLCode(Vif1Packet *pkt)
{
    unsigned int *current = pkt->current;
    unsigned int *open    = pkt->openDirect;

    current -= 1;               /* exclude last word */
    pkt->openDirect = 0;        /* clear open state */

    open[0] += (unsigned int)(current - open);
}

/* Append a GS A+D packet entry (64-bit data + 32-bit address) */
void sceVif1PkAddGsAD(Vif1Packet *pkt, unsigned int addr, unsigned long long data)
{
    unsigned int *dest = pkt->current;

    /* 64-bit data */
    dest[0] = (unsigned int)data;          /* low 32 bits */
    dest[1] = (unsigned int)(data >> 32);  /* high 32 bits */

    /* GS register address */
    dest[2] = addr;

    /* padding */
    dest[3] = 0;

    pkt->current += 4;  /* advance by 16 bytes */
}

/* Append N 32-bit words to the packet */
void sceVif1PkAddDataN(Vif1Packet *pkt, unsigned int *src, unsigned int count)
{
    if (count != 0)
    {
        unsigned int *dest = pkt->current;
        unsigned int i = count;

        do
        {
            *dest++ = *src++;
            i--;
        }
        while (i != 0);

        pkt->current = dest;
    }
}

/* Append a 128-bit UNPACK data value (written as four 32-bit words) */
void sceVif1PkAddUpkData128(Vif1Packet *pkt, unsigned int *value)
{
    unsigned int *dest = pkt->current;

    /* Equivalent to PS2 'sq' + split into 32-bit words */
    dest[0] = value[0];
    dest[1] = value[1];
    dest[2] = value[2];
    dest[3] = value[3];

    pkt->current += 4;  /* advance by 16 bytes */
}

/* Close a previously opened UNPACK code and patch its element count */
void sceVif1PkCloseUpkCode(Vif1Packet *pkt)
{
    unsigned int *current = pkt->current;
    unsigned int *open    = pkt->openDirect;  /* location of UNPACK code */
    unsigned int  meta    = pkt->unk1;        /* stored UNPACK parameters */

    unsigned int words;
    unsigned int cl;
    unsigned int fmt;
    unsigned int elements;

    /* Exclude last word and compute number of 32-bit words written */
    current -= 1;
    words = (unsigned int)(current - open);

    /* Extract cycle length (CL) and format bits */
    cl  = meta & 0xFFFF;         /* cycle length */
    fmt = meta & 0xFFFF0000;     /* format bits */

    /* Compute number of UNPACK elements written (ceil division) */
    elements = ((words * 32) + cl - 1) / cl;

    pkt->openDirect = 0;  /* clear open state */

    /* Patch UNPACK instruction */
    open[0] += fmt * elements;
}

/* Finalize the VIF1 packet by aligning to 16 bytes and patching any open DIRECT/HL code sizes */
void sceVif1PkTerminate(Vif1Packet *pkt)
{
    unsigned int *current = pkt->current;
    unsigned int *open    = (unsigned int *)pkt->openDirect;

    /* Align current pointer to 16-byte boundary, filling padding words with zeros */
    while (((unsigned int)current & 0xC) != 0)
    {
        *current++ = 0;
    }

    /* Patch the size of an open DIRECT/HL code if one exists */
    if (open != 0)
    {
        unsigned int size = ((current - open) >> 4) - 1;  /* in 16-byte units minus 1 */
        open[0] += size;
    }

    /* Clear open pointer */
    pkt->openDirect = 0;

    /* Update packet write pointer */
    pkt->current = current;
}

/* Finalize a packet segment and append a VIF1 control word with the given flags */
void sceVif1PkCnt(Vif1Packet *pkt, unsigned int flags)
{
    unsigned int *current;
    unsigned int ctrl;

    /* Terminate packet to align and close any open code */
    sceVif1PkTerminate(pkt);

    /* Build control word: 0x10000000 OR flags */
    current = pkt->current;
    ctrl = 0x10000000 | flags;

    /* Store control word at current pointer */
    *current = ctrl;

    /* Advance the packet pointer twice (8 bytes) */
    current++;
    pkt->current = current;

    /* Clear reserved / state field */
    pkt->reserved = 0;

    /* Zero the next word (padding) */
    *current = 0;
}

/* Finalize a packet segment and append a VIF1 end-of-packet control word */
void sceVif1PkEnd(Vif1Packet *pkt, unsigned int flags)
{
    unsigned int *current;
    unsigned int ctrl;

    /* Terminate packet to align and close any open code */
    sceVif1PkTerminate(pkt);

    /* Build end-of-packet control word: 0x70000000 OR flags */
    current = pkt->current;
    ctrl = 0x70000000 | flags;

    /* Store control word at current pointer */
    *current = ctrl;

    /* Advance the packet pointer twice (8 bytes) */
    current++;
    pkt->current = current;

    /* Clear reserved / state field */
    pkt->reserved = 0;

    /* Zero the next word (padding) */
    *current = 0;
}

/* Align the packet current pointer to a 16-byte (quadword) boundary */
void sceVif1PkAlign(Vif1Packet *pkt, unsigned int padding, unsigned int boundary)
{
    unsigned int *cur;
    unsigned int aligned, offset;

    /* Load current pointer */
    cur = pkt->current;

    /* Compute alignment offset for boundary (16-byte default) */
    aligned = ((unsigned int)cur + padding + (boundary - 1)) & ~(boundary - 1);

    /* Add additional padding for large blocks (a2 * 4) */
    offset = aligned + (boundary * 4);

    /* Write zero padding from current pointer up to offset */
    while ((unsigned int)cur < offset)
    {
        *cur++ = 0;
    }

    /* Update packet pointer */
    pkt->current = cur;
}

/* Open a DIRECT packet section for writing GS commands */
void sceVif1PkOpenDirectCode(Vif1Packet *pkt, unsigned int flags)
{
    unsigned int *cur;
    unsigned int *start;

    /* Align the current pointer to a quadword boundary for DIRECT packet */
    sceVif1PkAlign(pkt, 2, 3);

    /* Load the current pointer */
    cur = pkt->current;

    /* Store start pointer for this DIRECT block */
    start = cur;

    /* Compute the DIRECT header value */
    unsigned int directCode = 0x50000000;  /* VIF1 DIRECT code base */
    if (flags != 0)
        directCode = 0xD0000000;           /* VIF1 DIRECT code if flags set */

    /* Write DIRECT header to packet */
    *cur = directCode;
    pkt->current = cur + 1;   /* advance pointer by 4 bytes */
    pkt->reserved = start;    /* remember the start of this DIRECT block */
}

/* Open a HIGH-LEVEL DIRECT packet section for writing GS commands */
void sceVif1PkOpenDirectHLCode(Vif1Packet *pkt, unsigned int flags)
{
    unsigned int *cur;
    unsigned int *start;

    /* Align the current pointer to a quadword boundary for DIRECT HL packet */
    sceVif1PkAlign(pkt, 2, 3);

    /* Load the current pointer */
    cur = pkt->current;

    /* Store start pointer for this DIRECT HL block */
    start = cur;

    /* Compute the DIRECT HL header value */
    unsigned int directHLCode = 0x51000000;  /* VIF1 DIRECT HL base code */
    if (flags != 0)
        directHLCode = 0xD1000000;          /* VIF1 DIRECT HL if flags set */

    /* Write DIRECT HL header to packet */
    *cur = directHLCode;
    pkt->current = cur + 1;   /* advance pointer by 4 bytes */
    pkt->reserved = start;    /* remember the start of this DIRECT HL block */
}

/* Add N 128-bit DIRECT data units to the VIF1 packet */
void sceVif1PkAddDirectDataN(Vif1Packet *pkt, const unsigned int *src, int N)
{
    unsigned int *cur = pkt->current;  // current write pointer
    int i;

    if (N == 0)  // nothing to add
        return;

    for (i = 0; i < N; i++) {
        cur[0] = src[i * 4 + 0];  // lower 32 bits
        cur[1] = src[i * 4 + 1];  // next 32 bits
        cur[2] = src[i * 4 + 2];  // next 32 bits
        cur[3] = src[i * 4 + 3];  // upper 32 bits
        cur += 4;                  // advance pointer to next 128-bit unit
    }

    pkt->current = cur;  // update packet write pointer
}

/* Add multiple 128-bit UPK data units to the VIF1 packet */
void sceVif1PkAddUpkData128N(Vif1Packet *pkt, const unsigned int *src, int N)
{
    unsigned int *cur = pkt->current;   /* current write pointer in packet */
    const unsigned int *p = src;        /* pointer to source 128-bit data units */
    int i;

    if (N == 0)
        return;

    for (i = 0; i < N; i++) {
        /* store 128-bit unit (4 x 32-bit words) into packet buffer */
        cur[0] = p[0];        /* lower 32 bits */
        cur[1] = p[1];        /* next 32 bits */
        cur[2] = p[2];        /* next 32 bits */
        cur[3] = p[3];        /* upper 32 bits */
        cur += 4;
        p += 4;
    }

    pkt->current = cur;  /* update packet current pointer */
}

/* Initialize a VIF1 packet for an UNPACK code block */
void sceVif1PkOpenUpkCode(Vif1Packet *pkt, unsigned int a1, unsigned int a2, unsigned int a3, unsigned int t0)
{
    unsigned int *start = pkt->current;
    unsigned int tmp;

    tmp = (t0 << 8) | (0x1000000 | a3);
    start[0] = tmp;               /* write first word of UPK code */
    tmp = ((a2 & 0xFFFF) | (a2 << 24));
    start[1] = tmp;               /* second word with masked a2 and shifted */
    tmp = ((a2 & 3) + 1);         /* third word setup */
    start[2] = tmp;

    pkt->current = start + 4;     /* advance current pointer */
    pkt->openDirect = start;      /* remember start of this UNPACK block */
}

/* Add a VIF1 reference packet with 4 words, terminating the current packet first */
void sceVif1PkRef(Vif1Packet *pkt, unsigned int a1, unsigned int a2, unsigned int a3, unsigned int t0, unsigned int t1)
{
    unsigned int *start = pkt->current;

    /* terminate current packet if needed */
    sceVif1PkTerminate(pkt);

    start[0] = a2 | 0x30000000;    // first word
    start[1] = a1 & 0x9FFFFFFF;    // second word masked
    start[2] = a3;
    start[3] = t0;
    start[4] = t1;

    pkt->current = start + 5;       // advance packet pointer
}

/* Close a currently open GIF tag in the VIF1 packet */
void sceVif1PkCloseGifTag(Vif1Packet *pkt)
{
    unsigned int *gifPtr = pkt->openGif;   /* pointer to open GIF tag */
    unsigned int *pktBase = pkt->base;     /* start of packet */
    unsigned int *cur = (unsigned int *)pktBase[0];  /* current write pointer */
    unsigned int qwords, leftover, i;
    unsigned int tag = gifPtr ? *gifPtr : 0;

    /* compute number of qwords written since GIF tag */
    qwords = ((unsigned int)pktBase - (unsigned int)gifPtr) >> 3;
    leftover = (tag >> 26) & 0x3;           /* lower 2 bits of upper 6 bits */

    /* adjust qwords based on leftover */
    if (leftover != 2) {
        unsigned int tmp = (qwords >> 1);
        if (((tag >> 28) & 0xF) == 0)
            tmp = 0x10;
        qwords += tmp;
    }

    /* store final GIF tag word */
    if (gifPtr)
        *gifPtr = tag + (qwords << 2);      /* update GIF tag qword count */

    /* clear the openGif pointer in the packet */
    pkt->openGif = 0;

    /* zero out padding to align next write to 16-byte boundary */
    cur = (unsigned int *)pktBase[0];
    if (((unsigned int)cur & 0xC) != 0) {
        for (i = 0; ((unsigned int)(cur + i) & 0xC) != 0; ++i)
            cur[i] = 0;
    }

    /* update packet current pointer to next available position */
    pkt->current = cur;
}

/* Build a VIF1 packet to load an image into the GS */
void sceVif1PkRefLoadImage(Vif1Packet *pkt, unsigned int a1, unsigned int a2, unsigned int a3, 
                           unsigned int t0, unsigned int t1, unsigned int t2, unsigned int t3,
                           unsigned int fp)
{
    unsigned int s0, s1, s2, s3, s4, s5, s6, s7;

    /* save registers (represented as locals here) */
    s7 = (unsigned int)pkt;
    s6 = t2;
    s5 = t3;
    s4 = t0;
    s3 = a2 & 0xFF;
    s1 = a3 & 0xFFFF;
    s0 = a1 & 0xFFFF;
    fp = fp;
    
    /* start building packet */
    sceVif1PkCnt(s7, 0);
    sceVif1PkOpenDirectHLCode(s7, 0);

    /* open GIF tag for data */
    sceVif1PkOpenGifTag(s7, *(unsigned long long *)0); // value from stack/sp

    /* build GS ADDR packet entries */
    s0 = (s0 << 0) | (s1 << 16);
    s3 <<= 24;
    sceVif1PkAddGsAD(s7, 0x50, s0 | s3);

    s6 <<= 0;
    s5 <<= 16;
    sceVif1PkAddGsAD(s7, 0x51, s6 | s5);

    s2 <<= 0;
    s2 >>= 0;
    s0 = *(unsigned int *)(0xC8); // load some value
    s0 <<= 0;
    sceVif1PkAddGsAD(s7, 0x52, s2 | s0);

    /* close GIF tag and Direct HL code */
    sceVif1PkCloseGifTag(s7);
    sceVif1PkCloseDirectHLCode(s7);

    /* optional: loop for remaining image data */
    if (fp)
    {
        unsigned int s5_reg = 0x08000000 | 0x8000;
        unsigned int s3_reg = 0x13000;
        unsigned int s2_reg = 0x51000000;

        do
        {
            unsigned int s0_reg = (fp < fp) ? fp : fp;
            sceVif1PkCnt(s7, 0);
            sceVif1PkAlign(s7, 2, 3);
            sceVif1PkAddCode(s7, 0x51000001);
            sceVif1PkReserve(s7, 4);

            unsigned int v1 = s0_reg;
            unsigned int a1 = s0_reg ^ fp;
            unsigned int a2 = s0_reg;
            unsigned int a0 = v1 | s5_reg;
            unsigned int t0 = s0_reg | s2_reg;
            unsigned int v1_alt = v1 | s3_reg;

            /* reference the image chunk */
            sceVif1PkRef(s7, s4, a1, a2, s0, fp);

            s0_reg <<= 4;
            fp -= s0_reg;
            s4 += s0_reg;
        } while (fp != 0);
    }

    /* restore registers */
}



#ifdef PS2_HARDWARE

/* Store a 128-bit quadword into the packet */
void sceVif1PkAddGsPacked(Vif1Packet *pkt, unsigned int *value)
{
    unsigned int *dest = pkt->current;

    /* Equivalent to PS2 'sq' instruction */
    dest[0] = value[0];
    dest[1] = value[1];
    dest[2] = value[2];
    dest[3] = value[3];

    pkt->current += 4;  /* advance by 16 bytes */
}

/* Open a GIF tag and remember its location */
void sceVif1PkOpenGifTag(Vif1Packet *pkt, unsigned int *gifTag)
{
    unsigned int *dest = pkt->current;

    /* Store 128-bit GIF tag (sq equivalent) */
    dest[0] = gifTag[0];
    dest[1] = gifTag[1];
    dest[2] = gifTag[2];
    dest[3] = gifTag[3];

    pkt->current += 4;     /* advance by 16 bytes */
    pkt->openGif = dest;   /* save location of this tag */
}

#endif /* PS2_HARDWARE */