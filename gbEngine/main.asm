;Engine Skeleton ROM
include "hardware.asm"
include "constants.asm"
include "vars.asm"
SECTION "TMA VALUES",ROM0[$1]
;use patcher to change these values, set tmaTac to 0 to disable 
tmaMod: db $C3 
tmaTac: db %100;4096 hz
db "DMGBVGM by Pegmode"

SECTION "vBlank IRQ",ROM0[$40]
vBlankIRQ:
    jp vBlankRoutine
SECTION "Timer IRQ",ROM0[$50]
timerIRQ:
    jp timerRoutine

SECTION "MBCDefinition",ROM0[$147]
    dw CART_MBC5

SECTION "EntryPoint",ROM0[$100]
jp codeInit

SECTION "code",ROM0[$150]
codeInit:
    ld a, [tmaTac]
    bit 2,a
    jr nz, .setTMAMode
.setvBlankMode
    ld a, %1;enable vblank
    jr .continueInit
.setTMAMode
    ld [rTAC],a
    ld a, [tmaMod]
    ld [rTMA],a
    ld a, %100;enable timer
.continueInit
    ld [rIE], a
    
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
    call DMEngineUpdate
    reti

include "DMGBVGM.asm"

