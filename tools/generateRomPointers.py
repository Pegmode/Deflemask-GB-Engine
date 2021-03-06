#helper script to automatically scan for pointer/label addresses
#for C converter

import sys
SYM_FILENAME = "..\\gbEngine\DMGBVGM.sym"
OUT_FILENAME = "converterPointerMap.h"

outString = ""

ADDRESS_TO_C_MACRO_MAP = {#which asm labels map to which c defines
    "tmaTac" : "ROM_SONG_TMA_TAC_CONST",
    "tmaMod" : "ROM_SONG_TMA_MOD_CONST",
    "loopBank" : "ROM_LOOP_BANK_ADDRESS",
    "loopAddress" : "ROM_LOOP_POINTER_ADDRESS",
    "textData5" : "TITLE_PATCH_ADDRESS",
    "textData6" : "AUTHOR_PATCH_ADDRESS"
}

pointerAddresses ={ #addresses we care about for patcher
    "tmaTac" : 0,
    "tmaMod" : 0,
    "loopBank" : 0,
    "loopAddress" : 0,
    "textData5" : 0,
    "textData6" : 0
}

f = open(sys.path[0] + "\\"+ SYM_FILENAME, "r")
lines = f.readlines()
f.close()

for line in lines:
    for key in pointerAddresses:
        if key in line:
            pointerAddresses[key] = line[3:7]

outString += "//POINTERS GENERATED BY SCRIPT\n"

for key in pointerAddresses:
    pointerVal = pointerAddresses[key]
    constantName = ADDRESS_TO_C_MACRO_MAP[key]
    outString += "#define {} 0x{}//{} label in ROM\n".format(constantName, pointerVal, key)

print(outString)

# f = open("tools\\" + OUT_FILENAME, "w")
# f.write(outString)
# f.close()