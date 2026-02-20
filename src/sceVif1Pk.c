#include "common.h"

typedef struct Vif1Packet
{
    unsigned int *current;
    unsigned int *base;
    unsigned int  reserved;
    unsigned int *openDirect;
    unsigned int  unk1;
    unsigned int *openGif;
} Vif1Packet;

void sceVif1PkInit(Vif1Packet *pkt, unsigned int *buffer)
{
    pkt->current  = buffer;
    pkt->reserved = 0;
    pkt->base     = buffer;
}

void sceVif1PkReset(Vif1Packet *pkt)
{
    pkt->reserved = 0;
    pkt->current  = pkt->base;
}

INCLUDE_ASM("asm/nonmatchings/sceVif1Pk", sceVif1PkTerminate);

unsigned int sceVif1PkSize(Vif1Packet *pkt)
{
    unsigned char *base = (unsigned char*)pkt->base;
    return ((unsigned int)((unsigned char*)pkt->current - base)) >> 4;
}

INCLUDE_ASM("asm/nonmatchings/sceVif1Pk", sceVif1PkCnt);
INCLUDE_ASM("asm/nonmatchings/sceVif1Pk", sceVif1PkRef);
INCLUDE_ASM("asm/nonmatchings/sceVif1Pk", sceVif1PkEnd);
INCLUDE_ASM("asm/nonmatchings/sceVif1Pk", sceVif1PkOpenUpkCode);

void sceVif1PkCloseUpkCode(Vif1Packet *pkt)
{
    unsigned int *current = pkt->current;
    unsigned int *open    = pkt->openDirect;
    unsigned int  meta    = pkt->unk1;

    unsigned int words;
    unsigned int cl;
    unsigned int fmt;
    unsigned int elements;

    current -= 1;
    words = (unsigned int)(current - open);

    cl  = meta & 0xFFFF;
    fmt = meta & 0xFFFF0000;

    elements = ((words * 32) + cl - 1) / cl;

    pkt->openDirect = 0;

    open[0] += fmt * elements;
}

INCLUDE_ASM("asm/nonmatchings/sceVif1Pk", sceVif1PkOpenDirectCode);
INCLUDE_ASM("asm/nonmatchings/sceVif1Pk", sceVif1PkCloseDirectCode);
INCLUDE_ASM("asm/nonmatchings/sceVif1Pk", sceVif1PkOpenGifTag);
INCLUDE_ASM("asm/nonmatchings/sceVif1Pk", sceVif1PkCloseGifTag);
INCLUDE_ASM("asm/nonmatchings/sceVif1Pk", sceVif1PkReserve);
INCLUDE_ASM("asm/nonmatchings/sceVif1Pk", sceVif1PkAlign);

void sceVif1PkAddCode(Vif1Packet *pkt, unsigned int value)
{
    *pkt->current = value;
    pkt->current++;
}

INCLUDE_ASM("asm/nonmatchings/sceVif1Pk", sceVif1PkAddDataN);
INCLUDE_ASM("asm/nonmatchings/sceVif1Pk", sceVif1PkAddUpkData128);
INCLUDE_ASM("asm/nonmatchings/sceVif1Pk", sceVif1PkAddGsData);

void sceVif1PkAddGsAD(Vif1Packet *pkt, unsigned int addr, unsigned long long data)
{
    unsigned int *dest = pkt->current;
    *dest++ = (unsigned int)data;
    *dest = (unsigned int)(data >> 32);
    pkt->current = dest + 3;
    dest[1] = addr;
    dest[2] = 0;
}

INCLUDE_ASM("asm/nonmatchings/sceVif1Pk", sceVif1PkRefLoadImage);
INCLUDE_ASM("asm/nonmatchings/sceVif1Pk", sceVif1PkOpenDirectHLCode);
INCLUDE_ASM("asm/nonmatchings/sceVif1Pk", sceVif1PkCloseDirectHLCode);
INCLUDE_ASM("asm/nonmatchings/sceVif1Pk", sceVif1PkAddUpkData128N);
INCLUDE_ASM("asm/nonmatchings/sceVif1Pk", sceVif1PkAddDirectDataN);
INCLUDE_ASM("asm/nonmatchings/sceVif1Pk", sceVif1PkAddGsPacked);
