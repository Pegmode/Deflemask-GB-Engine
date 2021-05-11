import pdb
import math
GBROMPATH = "DMGBVGM.gb"
OUTPATH = "patchrom.h"

f = open(GBROMPATH,"rb")
inBuffer = f.read()
f.close()

outBuffer = 'unsigned char gb_patch_rom[] = {\n'

buffernLen =  len(inBuffer)

for i in range(math.ceil(buffernLen/16)):
    for j in range(16):
        outBuffer += "0x{},".format(hex(inBuffer[i*16+j])[2:])
        z = i+j
    outBuffer += '\n'
outBuffer = outBuffer[:-2]
outBuffer += '\n};\n'
outBuffer += "unsigned int gb_patch_rom_length = {} ;".format(buffernLen)

f = open(OUTPATH,"w")
f.write(outBuffer)
f.close()