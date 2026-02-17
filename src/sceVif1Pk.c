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