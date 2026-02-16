/* Initialize a VIF1 packet builder */
void sceVif1PkInit(unsigned int* p, unsigned int v)
{
    p[0] = v;   // Set start of packet
    p[2] = 0;   // Clear end pointer
    p[1] = v;   // Set current write pointer
}

/* Reset packet write pointer to base */
void sceVif1PkReset(unsigned int* p)
{
    unsigned int temp = p[1];  // Save current write pointer
    p[2] = 0;                  // Clear end pointer
    p[0] = temp;               // Reset start to current write pointer
}

/* Append a single word to the VIF packet and advance the write pointer */
void sceVif1PkAddCode(unsigned int **p, unsigned int value)
{
    unsigned int *dest = *p;   // Load current write position
    *dest = value;             // Store the value
    *p = dest + 1;             // Advance write pointer by one word
}

/* Return the number of quadwords written to the packet */
unsigned int sceVif1PkSize(unsigned int *p)
{
    return (p[0] - p[1]) >> 4;  // Divide byte difference by 16
}

/* Reserve space for a number of 32-bit words in the packet */
void sceVif1PkReserve(unsigned int **p, unsigned int wordCount)
{
    *p += wordCount;
}

#ifdef PS2_HARDWARE

/* Store a 128-bit quadword into the packet */
void sceVif1PkAddGsPacked(unsigned int **p, unsigned int *value)
{
    unsigned int *dest = *p;
    /* sq $a1, 0x0($v0) — 128-bit store, equivalent to: */
    dest[0] = value[0];
    dest[1] = value[1];
    dest[2] = value[2];
    dest[3] = value[3];
    *p = dest + 4;  // Advance by 16 bytes
}

#endif /* PS2_HARDWARE */
