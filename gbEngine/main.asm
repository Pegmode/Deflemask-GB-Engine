;Engine Skeleton ROM
include "hardware.asm"
include "constants.asm"
include "vars.asm"

SECTION "vBlank IRQ",ROM0[$40]
vBlankIRQ:
    jp vBlankRoutine
SECTION "vBlank IRQ",ROM0[$50]
timerIRQ:
    jp timerRoutine

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
    halt
    jp main

vBlankRoutine:
    call DMEngineUpdate
    reti

timerRoutine:

include "DMGBVGM.asm"

SECTION "SoundData0",ROMX,BANK[1]
incbin "ExampleData/hina/songBank0.bin"
SECTION "SoundData1",ROMX,BANK[2]
incbin "ExampleData/hina/songBank1.bin"
SECTION "SoundData2",ROMX,BANK[3]
incbin "ExampleData/hina/songBank2.bin"
SECTION "SoundData3",ROMX,BANK[4]
incbin "ExampleData/hina/songBank3.bin"
SECTION "SoundData4",ROMX,BANK[5]
incbin "ExampleData/hina/songBank4.bin"
SECTION "SoundData5",ROMX,BANK[6]
incbin "ExampleData/hina/songBank5.bin"
SECTION "SoundData6",ROMX,BANK[7]
incbin "ExampleData/hina/songBank6.bin"
SECTION "SoundData7",ROMX,BANK[8]
incbin "ExampleData/hina/songBank7.bin"
SECTION "SoundData8",ROMX,BANK[9]
incbin "ExampleData/hina/songBank8.bin"
SECTION "SoundData9",ROMX,BANK[10]
incbin "ExampleData/hina/songBank9.bin"
SECTION "SoundData10",ROMX,BANK[11]
incbin "ExampleData/hina/songBank10.bin"
SECTION "SoundData11",ROMX,BANK[12]
incbin "ExampleData/hina/songBank11.bin"
SECTION "SoundData12",ROMX,BANK[13]
incbin "ExampleData/hina/songBank12.bin"
SECTION "SoundData13",ROMX,BANK[14]
incbin "ExampleData/hina/songBank13.bin"
SECTION "SoundData14",ROMX,BANK[15]
incbin "ExampleData/hina/songBank14.bin"
SECTION "SoundData15",ROMX,BANK[16]
incbin "ExampleData/hina/songBank15.bin"
SECTION "SoundData16",ROMX,BANK[17]
incbin "ExampleData/hina/songBank16.bin"
SECTION "SoundData17",ROMX,BANK[18]
incbin "ExampleData/hina/songBank17.bin"
SECTION "SoundData18",ROMX,BANK[19]
incbin "ExampleData/hina/songBank18.bin"
SECTION "SoundData19",ROMX,BANK[20]
incbin "ExampleData/hina/songBank19.bin"
SECTION "SoundData20",ROMX,BANK[21]
incbin "ExampleData/hina/songBank20.bin"
SECTION "SoundData21",ROMX,BANK[22]
incbin "ExampleData/hina/songBank21.bin"
SECTION "SoundData22",ROMX,BANK[23]
incbin "ExampleData/hina/songBank22.bin"
SECTION "SoundData23",ROMX,BANK[24]
incbin "ExampleData/hina/songBank23.bin"
SECTION "SoundData24",ROMX,BANK[25]
incbin "ExampleData/hina/songBank24.bin"
SECTION "SoundData25",ROMX,BANK[26]
incbin "ExampleData/hina/songBank25.bin"
SECTION "SoundData26",ROMX,BANK[27]
incbin "ExampleData/hina/songBank26.bin"