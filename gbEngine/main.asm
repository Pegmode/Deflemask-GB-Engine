;Engine Skeleton ROM
include "hardware.asm"
include "constants.asm"
include "vars.asm"

SECTION "vBlank IRQ",ROM0[$40]
vBlankIRQ:
    jp vBlankRoutine
SECTION "MBCDefinition",ROM0[$147]
    dw CART_MBC5
SECTION "EntryPoint",ROM0[$100]
jp codeInit

SECTION "code",ROM0[$150]
codeInit:
    ld a, $01
    ld [rIE], a;enable Vblank interupt
    call DMEngineInit
    ld a, 1
    ld [SoundStatus],a
    ei

main:;main loop
    nop
    jp main

vBlankRoutine:
    call DMEngineUpdate
    reti

include "DMGBVGM.asm"

SECTION "SoundData1",ROMX,BANK[1]
incbin "ExampleData/wide putin/songBank0.bin"
SECTION "SoundData2",ROMX,BANK[2]
incbin "ExampleData/wide putin/songBank1.bin"
SECTION "SoundData3",ROMX,BANK[3]
incbin "ExampleData/wide putin/songBank2.bin"